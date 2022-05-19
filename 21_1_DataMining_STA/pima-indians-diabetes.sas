/*210414*/
data pima;
infile '/folders/myfolders/dm/pima-indians-diabetes.txt' delimiter=',';
input Num_pregnant Plasma pressure skin insulin BMI pedigree Age target @@;
run;










/*210419*/
options obs=25; /*25개 데이터만 추출해서 미리보기*/
proc print data=pima;
run;


proc freq data=pima;  /*도수분포표 그리기*/
table target/missing;
run;
/*당뇨x 500명, 당뇨o 268명이므로 비율 맞춰야함!*/



/*당뇨x인 사람 중 절반가량만 뽑아 nonresp 변수에 할당*/
options obs=max; /*obs 전체로 되돌리기*/
data nonresp(where=(ranuni(5555)<0.5)); /*난수 생성하여 0.5로 컷 (절반만 뽑아야 함),5555는 seed*/
set pima(where=(target^=1));  /*target=0, 당뇨x인 사람 대상*/
run;
/*target=0인 당뇨x인 사람이 200여명 뽑힘,난수로 뽑다보니 정확히 절반은 아니*/



/*pima에서 당뇨o인사람, nonresp 두 데이터 merge*/
data model;
set pima(where=(target=1)) nonresp;
if target=1 then smp_wgt=1;  /*sample_weight*/
else smp_wgt=2;     /*nonresp의 1명이 모집단의 두명 역할 함*/
run;



/*model 데이터로 도수분포표*/
proc freq data=model;
weight smp_wgt;    /*설정한 weight 값 불러옴*/
table target/missing;
run;
/*난수로 절반 뽑아온 걸 두 배 해준 거라 위의 도수분포표와는 조금 다르*/



/*데이터셋의 정보 확인, 변수명 확인*/
proc contents data=pima;
run;



/*bmi 변수 확인!*/
proc univariate data=model plot;
weight smp_wgt;
var bmi;
run;
/*box-plot으로부터 outlier 확인
0은 missing 값으로 추정됨
큰 값으로 outlier는 99백분위수로 대체*/



data model;
set model;
if bmi=0 then bmi_miss=1;
else bmi_miss=0;
run;
/*bmi가 0인 경우 bmi_miss라는 새로운 변수에 1 할당
아닌경우에는 0 할당
덮어써버리면 처리 어렵*/



/*99백분위수 계산*/
proc univariate data=model noprint;
weight smp_wgt;
where bmi>0;   /*or bmi_miss=0*/
var bmi;
output out=bmidata pctlpts=99 pctlpre=bmi;
/*bmidata라는 데이터에 bmi99라는 변수에 할당됨*/
run;
/*계산된 99백분위수는 52.3*/



/*99백분위수 대체*/
data model;
set model;
if (_n_ eq 1) then set bmidata(keep=bmi99);
if bmi>2*bmi99 then bmi2=bmi99; /*bmi가 99백분위수의 두배보다 크면 99백분위수로 대체*/
else bmi2=bmi;
run;














/*210421*/
/*bmi 변수만 가지고 한것들을 모든 변수에 매크로 적용*/
/*매크로 설정하기*/
%macro univar(dsname,var,svar);  /*매크로 돌면서 바꾸는 부분 설ㅈ*/
title 'Evaluation of ' &var; /*& 기호가 붙은 부분이 매크로 돌면서 바뀌는 부분*/

/*99백분위수 찾기*/
proc univariate data=&dsname plot;
weight smp_wgt;
var &var;
output out=&svar.data pctlpts=99 pctlpre=&svar;
run;

/*99백분위수 대체*/
data &dsname;
set &dsname;
if (_n_ eq 1) then set &svar.data(keep=&svar.99);
if &var>2*&svar.99 then &var.2=2*&svar.99;
else &var.2=&var;
run;

/*대체된 99백분위수 값만 추출*/
proc print data=&dsname;
where &var^=&var.2;
var &var &var.2;
run;

%mend;   /*매크로 닫기*/


%univar(model,Num_pregnant,np); /*매크로 실행*/
%univar(model,Plasma,pl);
%univar(model,pressure,pr);
%univar(model,skin,sk);
%univar(model,insulin,in);
%univar(model,pedigree,ped);
%univar(model,Age,ag);




/*bmi 변수의 평균값 구하기, 결측치(bmi=0)는 빼고 계산*/
proc means data=model maxdec=2; /*maxdec:소수점 자리수*/
weight smp_wgt;
where bmi2>0;
var bmi2;
run;
/*32.28 출력*/

/*평균값으로 대체*/
data model;
set model;
if bmi2=0 then bmi3=32.28;
else bmi3=bmi2;
run;



/*회귀값으로 대체하기 위해 회귀모델 설정*/
proc reg data=model(where=(bmi>0)) outset=reg_out;
weight smp_wgt;
bmi_reg: model bmi2= Num_pregnant Plasma pressure skin insulin pedigree Age /selection=backward;
run;

/*회귀값 추출, bmi_reg로 반환*/
proc score data=model score=reg_out out=model2 type=parms predict;
var Num_pregnant Plasma pressure skin insulin pedigree Age;
run;

/*bmi3 변수에 할당*/
data model2;
set model2;
if bmi2=0 then bmi3=bmi_reg;
else bmi3=bmi2;
run;


/*회귀값으로 대체하기 전후의 값 비교*/
proc means data=model2;
where bmi2>0;
var bmi2;
run;
proc means data=model2;
var bmi3;
run;
/*전반적인 분포의 모양을 흐트러트리지 않는 수준*/













/*210426*/
/*날짜데이터 실습*/
data buy;
set sashelp.buy;
day=day(date);
mon=month(date);
yy=year(date);
fixday=mdy('12','31','1990');  /*mdy()쓰면 기준일로부터 며칠 떨어져있는지 반환*/
fixday_2=mdy('1','1','1960');  /*1960.1.1이 sas 내장 날짜데이터의 기준일*/
term=(date-fixday)/365;/*년수로 반환*/
      /*ㄴ괄호까지만 적으면 일수로 반환*/
run;













/*210428*/
proc logistic data=model2 descending;
weight smp_wgt;
model target=Num_pregnant Plasma pressure skin insulin pedigree Age target bmi3 bmi_miss/selection=stepwise maxstep=1 details;
run;
/*Analysis of Effects Eligible for Entry의 p값이 모두 유의하므로 모든 변수 포함! (0.5 기준으로 매우 넓은 기준 적용)*/


proc univariate data=model2 noprint;
weight smp_wgt;
var bmi3;
output out=bmidata pctlpts=10 20 30 40 50 60 70 80 90 100 pctlpre=bmi;
run;
/*bmi3 변수를 10분위수로 나눔*/


data model2;
set model2;
if (_n_ eq 1) then set bmidata;
run;
/*위에 만든 bmidata를 model2의 변수로 붙임*/



data model2;
set model2;
if bmi3<bmi10 then bmigrp=1;
else if bmi3<bmi20 then bmigrp=2;
else if bmi3<bmi30 then bmigrp=3;
else if bmi3<bmi40 then bmigrp=4;
else if bmi3<bmi50 then bmigrp=5;
else if bmi3<bmi60 then bmigrp=6;
else if bmi3<bmi70 then bmigrp=7;
else if bmi3<bmi80 then bmigrp=8;
else if bmi3<bmi90 then bmigrp=9;
else bmigrp=10;
run;
/*bmigrp 변수 생성, 연속형 bmi를 그룹화*/



proc freq data=model2;
weight smp_wgt;
table target*bmigrp;
run;
/*칼럼백분율 계산후 결과를 보니 선형관계를 가진것은 아니라고 보임 bmigrp 변수를 그룹화하기 애매하므로 거름*/



/*bmi3 값 변환하기*/
data model2;
set model2;
bmi_sq=bmi3**2;
bmi_cu=bmi3**3;
bmi_sqrt=sqrt(bmi3);
bmi_curt=bmi3**0.3333;
bmi_log=log(max(0.0001,bmi3)); /*로그 변환시엔 0값 계산 안되므로 max()로 0값을 대체함*/
bmi_exp=exp(bmi3);
bmi_tan=tan(bmi3);
bmi_sin=sin(bmi3);
bmi_cos=cos(bmi3);
bmi_inv=1/max(0.0001,bmi3);  /*역수변환, 분모에 0 있으면 안되므로 max()*/
bmi_sqi=1/max(0.0001,bmi3**2);
bmi_cui=1/max(0.0001,bmi3**3);
bmi_sqri=1/max(0.0001,sqrt(bmi3));
bmi_curi=1/max(0.0001,bmi3**0.3333);
bmi_logi=1/max(0.0001,log(max(0.0001,bmi3))); /*로그 변환시엔 0값 계산 안되므로 max()로 0값을 대체함*/
bmi_expi=1/max(0.0001,exp(bmi3));
bmi_tani=1/max(0.0001,tan(bmi3));
bmi_sini=1/max(0.0001,sin(bmi3));
bmi_cosi=1/max(0.0001,cos(bmi3));
run;


proc logistic data=model2 descending;
weight smp_wgt;
model target=bmi3 bmi_miss bmi_sq bmi_cu bmi_sqrt bmi_curt bmi_log bmi_exp bmi_tan bmi_sin bmi_cos bmi_inv bmi_sqi bmi_cui bmi_sqri bmi_curi bmi_logi bmi_expi bmi_tani bmi_sini bmi_cosi/selection=stepwise maxstep=2 details;
/*원변수 bmi3와 변환한 모든 변수 넣음, bmigrp은 결과가 유효하지 않다고 판단돼 제거
details는 가장 유효한 변수만 뽑아서 보여달라는 것, maxstep은 그 갯수*/
run;


/*bmi 말고 다른 연속형 변수들도 똑같은 과정 거칠 것!*/











/*210503*/
%macro group(var);
proc univariate data=model2 noprint;
weight smp_wgt;
var &var;
output out=&var.data pctlpts=10 20 30 40 50 60 70 80 90 100 pctlpre=&var;
run;

data model2;
set model2;
if (_n_ eq 1) then set &var.data;
run;

data model2;
set model2;
if &var<&var.10 then &var.grp=1;
else if &var<&var.20 then &var.grp=2;
else if &var<&var.30 then &var.grp=3;
else if &var<&var.40 then &var.grp=4;
else if &var<&var.50 then &var.grp=5;
else if &var<&var.60 then &var.grp=6;
else if &var<&var.70 then &var.grp=7;
else if &var<&var.80 then &var.grp=8;
else if &var<&var.90 then &var.grp=9;
else &var.grp=10;

proc freq data=model2;
weight smp_wgt;
table target*&var.grp;
run;

%mend;


%group(bmi3);
%group(Num_pregnant);
%group(Plasma);
%group(pressure);
/*%group(skin);
%group(insulin);*/
%group(pedigree);
%group(Age);



%macro trans(var);

data model2;
set model2;
&var._sq=&var**2;
&var._cu=&var**3;
&var._sqrt=sqrt(&var);
&var._curt=&var**0.3333;
&var._log=log(max(0.0001,&var));
&var._exp=exp(&var);
&var._tan=tan(&var);
&var._sin=sin(&var);
&var._cos=cos(&var);
&var._inv=1/max(0.0001,&var);
&var._sqi=1/max(0.0001,&var**2);
&var._cui=1/max(0.0001,&var**3);
&var._sqri=1/max(0.0001,sqrt(&var));
&var._curi=1/max(0.0001,&var**0.3333);
&var._logi=1/max(0.0001,log(max(0.0001,&var)));
&var._expi=1/max(0.0001,exp(&var));
&var._tani=1/max(0.0001,tan(&var));
&var._sini=1/max(0.0001,sin(&var));
&var._cosi=1/max(0.0001,cos(&var));
run;

proc logistic data=model2 descending;
weight smp_wgt;
model target=&var &var._sq &var._cu &var._sqrt &var._curt &var._log &var._exp &var._tan &var._sin &var._cos &var._inv &var._sqi &var._cui &var._sqri &var._curi &var._logi &var._expi &var._tani &var._sini &var._cosi/selection=stepwise maxstep=2 details;
run;  /*missing 값은 있는 애들도 있고 없는 애들도 있어서 여기선 뺌, 공통으로 들어가는 변수들만 넣어줌*/
%mend;





%trans(bmi3);
%trans(Num_pregnant);
%trans(Plasma);
%trans(pressure);
/*%trans(skin);
%trans(insulin);*/
%trans(pedigree);
%trans(Age);



/*선택된 변수
bmi3_inv, bmi3_cui
Num_pregnant_sq, Num_pregnant_curi
Plasma_sq, Plasma_expi
pressure_cu, pressure_expi
pedigree_log
Age_cui, Age_cu*/



/*insulin data는 0 값이 넘 많아 제외*/
proc univariate data=model2;
var insulin;
weight smp_wgt;
run;








/*210505*/
/*위 과정으로부터 선택된 후보변수들; 교재에서의 70개 변수
bmi3_inv bmi3_cui Num_pregnant_sq Num_pregnant_curi Plasma_sq Plasma_expi
pressure_cu pressure_expi pedigree_log Age_cui Age_cu*/

/*train/test data 구분*/
data model2;
set model2;
if ranuni(555)<0.7 then splitwgt=smp_wgt;
/*train data 70퍼 추출, splitwgt에 smp_wgt 그대로 대입*/
else splitwgt=.;
/*test data 30퍼, 위에서 추출x면 결측치로 표시해 모델링에서 제외*/
records=1;
run;


/*후보변수 모두 때려넣고 backward 실행, 유의수준 0.3으로 널널하게 잡음*/
proc logistic data=model2 descending;
weight splitwgt;
model target=bmi3_inv bmi3_cui Num_pregnant_sq Num_pregnant_curi Plasma_sq Plasma_expi 
pressure_cu pressure_expi pedigree_log Age_cui Age_cu
/selection=backward sls=0.3;
run;


/*이번엔 stepwise 실행, 유의수준 0.3으로 널널하게 잡음*/
proc logistic data=model2 descending;
weight splitwgt;
model target=bmi3_inv bmi3_cui Num_pregnant_sq Num_pregnant_curi Plasma_sq Plasma_expi 
pressure_cu pressure_expi pedigree_log Age_cui Age_cu
/selection=stepwise sle=0.3 sls=0.3;
run;


/*두 과정 결과 채택된 변수
bmi3_inv bmi3_cui Num_pregnant_sq Plasma_sq pressure_expi 
pedigree_log Age_cui Age_cu 로 같음*/


/*score로 변수 조합!*/
proc logistic data=model2 descending;
weight splitwgt;
model target=bmi3_inv bmi3_cui Num_pregnant_sq Plasma_sq 
 pressure_expi pedigree_log Age_cui Age_cu
/selection=score best=2;  /*2개만 보여라*/
run;
/*해석 교재 141p*/




/*변수 7개 확정! bmi3_inv Num_pregnant_sq Plasma_sq pressure_expi pedigree_log Age_cui Age_cu*/
proc logistic data=model2 descending;
weight splitwgt;
model target=bmi3_inv Num_pregnant_sq Plasma_sq pressure_expi pedigree_log Age_cui Age_cu;
output out=m_out pred=pred;   /*pred 변수에 확률값*/
run;



/*이제 위 아웃풋을 그룹화해줄 것임*/
/*m_out 데이터를 pred 값 기준으로 내림차순 정렬*/
proc sort data=m_out;
by descending pred;
run;



proc univariate data=m_out(where=(splitwgt^=.)) noprint;
weight smp_wgt;   /*splitwgt^=.인 데이터만 대상이므로 smp_wgt 써도 무방*/
var pred target;
output out=preddata sumwgt=sumwgt;
run;
/*sumwgt는 smp_wgt 반영한 찐 obs를 의미*/


proc print data=m_out(where=(splitwgt^=.));
var target pred splitwgt smp_wgt;
run;
/*여기의 smp_wgt(or splitwgt) 값 싹 합친게 sumwgt(=524)*/


/*이 sumwgt(=524)를 기준으로 그룹화!*/
data mod_dec;
set m_out(where=(splitwgt^=.));
if (_n_ eq 1) then set preddata;
retain sumwgt;
n+smp_wgt;   /*n은 smp_wgt의 누적합*/

if n<0.1*sumwgt then mod_dec=0;
else if n<0.2*sumwgt then mod_dec=1;
else if n<0.3*sumwgt then mod_dec=2;
else if n<0.4*sumwgt then mod_dec=3;
else if n<0.5*sumwgt then mod_dec=4;
else if n<0.6*sumwgt then mod_dec=5;
else if n<0.7*sumwgt then mod_dec=6;
else if n<0.8*sumwgt then mod_dec=7;
else if n<0.9*sumwgt then mod_dec=8;
else mod_dec=9;
run;


	

title "Decile Analysis";
proc tabulate data=mod_dec;
weight smp_wgt;   /*splitwgt^=.인 데이터만 만들었기 때문*/
class mod_dec;
var records target pred;
table mod_dec='decile' all='Total',
records='Number of obs'*(sum=' '*f=comma10.)
pred='Predicted probability'*(mean=' '*f=11.5)
target='Actual'*(mean=' '*f=11.5)/rts=9 row=float;
run;










/*210510*/
/*test data에 대한 sumwgt(=230) 구함*/
proc univariate data=m_out(where=(splitwgt=.)) noprint;
weight smp_wgt;
var pred target;
output out=preddata sumwgt=sumwgt;
run;



/*이 sumwgt(=230)를 기준으로 그룹화!*/
data mod_dec;
set m_out(where=(splitwgt=.));
if (_n_ eq 1) then set preddata;
retain sumwgt;
n+smp_wgt;   /*n은 smp_wgt의 누적합*/

if n<0.1*sumwgt then mod_dec=0;
else if n<0.2*sumwgt then mod_dec=1;
else if n<0.3*sumwgt then mod_dec=2;
else if n<0.4*sumwgt then mod_dec=3;
else if n<0.5*sumwgt then mod_dec=4;
else if n<0.6*sumwgt then mod_dec=5;
else if n<0.7*sumwgt then mod_dec=6;
else if n<0.8*sumwgt then mod_dec=7;
else if n<0.9*sumwgt then mod_dec=8;
else mod_dec=9;
run;




title "Decile Analysis";
proc tabulate data=mod_dec;
weight smp_wgt;
class mod_dec;
var records target pred;
table mod_dec='decile' all='Total',
records='Number of obs'*(sum=' '*f=comma10.)
pred='Predicted probability'*(mean=' '*f=11.5)
target='Actual'*(mean=' '*f=11.5)/rts=9 row=float;
run;







/*210517*/
/**ch6**/
/*아예 다른 dataset에 적용 위해 회귀계수만 원함*/
proc logistic data=model2 descending outest=score;
weight splitwgt;    /*train data만 가지고 회귀계수 추정해야함*/
model target=bmi3_inv Num_pregnant_sq Plasma_sq pressure_expi pedigree_log Age_cui Age_cu;
run;
/*최종선택된 변수, train data로 로지스틱 회귀모형 만들고 그 계수만 취함*/


data valid;   /*완전 새로운 데이터(뉴욕주->다른주)를 써야 하나 pima에선 없으니 걍 랜덤샘플*/
set model2;
if ranuni(7777)<0.3 then output;
run;   /*157개 샘플링*/

proc score data=valid out=valid_1 predict score=score type=parms;
id target records smp_wgt ;
var bmi3_inv Num_pregnant_sq Plasma_sq pressure_expi pedigree_log Age_cui Age_cu;
run;
/*model2에 이미 target 변수가 있어서 target2로 생성됨, 그 값은 로짓*/


proc sort data=valid_1;    /*target2(로짓값)을 기준으로 내림차순*/
by descending target2;
run;


data valid_1;
set valid_1;
pred_target=exp(target2)/(1+exp(target2)); /*로짓을 확률로 변환*/
run;




/*밑의 과정 똑같이 진행 but 생략*/

proc univariate data=m_out(where=(splitwgt^=.)) noprint;
weight smp_wgt;   /*splitwgt^=.인 데이터만 대상이므로 smp_wgt 써도 무방*/
var pred target;
output out=preddata sumwgt=sumwgt;
run;
/*sumwgt는 smp_wgt 반영한 찐 obs를 의미*/


proc print data=m_out(where=(splitwgt^=.));
var target pred splitwgt smp_wgt;
run;
/*여기의 smp_wgt(or splitwgt) 값 싹 합친게 sumwgt(=524)*/


/*이 sumwgt(=524)를 기준으로 그룹화!*/
data mod_dec;
set m_out(where=(splitwgt^=.));
if (_n_ eq 1) then set preddata;
retain sumwgt;
n+smp_wgt;   /*n은 smp_wgt의 누적합*/

if n<0.1*sumwgt then mod_dec=0;
else if n<0.2*sumwgt then mod_dec=1;
else if n<0.3*sumwgt then mod_dec=2;
else if n<0.4*sumwgt then mod_dec=3;
else if n<0.5*sumwgt then mod_dec=4;
else if n<0.6*sumwgt then mod_dec=5;
else if n<0.7*sumwgt then mod_dec=6;
else if n<0.8*sumwgt then mod_dec=7;
else if n<0.9*sumwgt then mod_dec=8;
else mod_dec=9;
run;


	

title "Decile Analysis";
proc tabulate data=mod_dec;
weight smp_wgt;   /*splitwgt^=.인 데이터만 만들었기 때문*/
class mod_dec;
var records target pred;
table mod_dec='decile' all='Total',
records='Number of obs'*(sum=' '*f=comma10.)
pred='Predicted probability'*(mean=' '*f=11.5)
target='Actual'*(mean=' '*f=11.5)/rts=9 row=float;
run;










/*210510*/
/*test data에 대한 sumwgt(=230) 구함*/
proc univariate data=m_out(where=(splitwgt=.)) noprint;
weight smp_wgt;
var pred target;
output out=preddata sumwgt=sumwgt;
run;



/*이 sumwgt(=230)를 기준으로 그룹화!*/
data mod_dec;
set m_out(where=(splitwgt=.));
if (_n_ eq 1) then set preddata;
retain sumwgt;
n+smp_wgt;   /*n은 smp_wgt의 누적합*/

if n<0.1*sumwgt then mod_dec=0;
else if n<0.2*sumwgt then mod_dec=1;
else if n<0.3*sumwgt then mod_dec=2;
else if n<0.4*sumwgt then mod_dec=3;
else if n<0.5*sumwgt then mod_dec=4;
else if n<0.6*sumwgt then mod_dec=5;
else if n<0.7*sumwgt then mod_dec=6;
else if n<0.8*sumwgt then mod_dec=7;
else if n<0.9*sumwgt then mod_dec=8;
else mod_dec=9;
run;




title "Decile Analysis";
proc tabulate data=mod_dec;
weight smp_wgt;
class mod_dec;
var records target pred;
table mod_dec='decile' all='Total',
records='Number of obs'*(sum=' '*f=comma10.)
pred='Predicted probability'*(mean=' '*f=11.5)
target='Actual'*(mean=' '*f=11.5)/rts=9 row=float;
run;


















/*210519*/
/*resampling*/

/*resample 위해 데이터 가져오기*/
proc logistic data=model2 descending;
weight splitwgt;
model target=pedigree_log bmi3_inv pressure_expi Plasma_sq Num_pregnant_sq age_cui age_cu;
output out=resamp(where=(splitwgt=.) keep=pred target records smp_wgt splitwgt) pred=pred;   /*resample은 test data를 대상으로 하므로 splitwgt=.*/
run;



/*처음 1퍼센트 제거->100퍼센트 제거까지 매크로! 설명은 1퍼센트 기준*/
%macro jackknife;


data jk_sum;
val_dec=.;
run;


%do prcnt=1 %to 100;


/*첫번째 1퍼센트 제거*/
data out&prcnt;
set resamp;
if 0.01*(&prcnt-1)<ranuni(5555)<0.01*(&prcnt) then delete;
run;
/*1퍼센트 제거 하면 약 154개 행 나오지만 이게 154명의 데이터를 의미하지 않음 (smp_wgt 고려해야 함)*/

proc sort data=out&prcnt;
by descending pred;
run;

proc univariate data=out&prcnt noprint;
weight smp_wgt;
var pred;
output out=preddata sumwgt=sumwgt;
run;    /*smp_wgt 고려된 데이터 수는 227*/






data out&prcnt;
set out&prcnt;
if (_n_ eq 1) then set preddata;
retain sumwgt;
n+smp_wgt;   /*n은 smp_wgt의 누적합*/

if n<0.1*sumwgt then val_dec=0;
else if n<0.2*sumwgt then val_dec=1;
else if n<0.3*sumwgt then val_dec=2;
else if n<0.4*sumwgt then val_dec=3;
else if n<0.5*sumwgt then val_dec=4;
else if n<0.6*sumwgt then val_dec=5;
else if n<0.7*sumwgt then val_dec=6;
else if n<0.8*sumwgt then val_dec=7;
else if n<0.9*sumwgt then val_dec=8;
else val_dec=9;
run;


proc summary data=out&prcnt;
var target pred;
class val_dec;
weight smp_wgt;
output out=jkmns&prcnt mean=actmn&prcnt prdmn&prcnt;
run;

/*lift 그리기 위해 위의 summary에서 전체(val_dec=.) 데이터 불러모음*/
data actomean(rename=(actmn&prcnt=actom&prcnt) drop=val_dec);
set jkmns&prcnt(where=(val_dec=.) keep=actmn&prcnt val_dec);
run;


data jkmns&prcnt;
set jkmns&prcnt;
if(_n_ eq 1) then set actomean;
retain actom&prcnt;
liftd&prcnt=100*actmn&prcnt/actom&prcnt;
run;


data jk_sum;
merge jk_sum jkmns&&prcnt;
by val_dec;
run;



%end;
%mend;
%jackknife;



data jk_sum;
set jk_sum;

prdmjk=mean(of prdmn1-prdmn100);
prdsdjk=std(of prdmn1-prdmn100);

actmjk=mean(of actmn1-actmn100);
actsdjk=std(of actmn1-actmn100);

lftmjk=mean(of liftd1-liftd100);
lftsdjk=std(of liftd1-liftd100);


lci_p=prdmjk-1.96*prdsdjk;
uci_p=prdmjk+1.96*prdsdjk;

lci_a=actmjk-1.96*actsdjk;
uci_a=actmjk+1.96*actsdjk;

lci_l=lftmjk-1.96*lftsdjk;
uci_l=lftmjk+1.96*lftsdjk;
run;



/*테이블화*/
proc format;
picture perc
low-high = '9.999%' (mult=1000000);
run;

proc tabulate data=jk_sum;
var prdmjk lci_p uci_p actmjk lci_a uci_a lftmjk lci_l uci_l;
class val_dec;
table val_Dec='Decile' all='Total',
prdmjk='JK Est prob'*(mean=' '*f=perc.)
lci_p='JK Lower Cl Prob'*(mean=' '*f=perc.)
uci_p='JK Upper Cl Prob'*(mean=' '*f=perc.)
actmjk='JK Est %Active'*(mean=' '*f=perc.)
lci_a='JK Lower CI %Active'*(mean=' '*f=perc.)
uci_a='JK Upper CI %Active'*(mean=' '*f=perc.)
lftmjk='JK Est Lift'*(mean=' '*f=6.)
lci_l='JK Lower CI Lift'*(mean=' '*f=6.)
uci_l='JK Upper CI Lift'*(mean=' '*f=6.)/rts=6 row=float;
run;








/*210524*/
/*bootstrap*/

proc logistic data=model2 descending;
weight splitwgt;
model target=pedigree_log bmi3_inv pressure_expi Plasma_sq Num_pregnant_sq age_cui age_cu;
output out=resamp(where=(splitwgt=.) keep=pred target records smp_wgt splitwgt) pred=pred;   /*resample은 test data를 대상으로 하므로 splitwgt=.*/
run;

proc sort data=resamp;
by descending pred;
run;


proc univariate data=resamp noprint;
weight smp_wgt;
var pred target;
output out=preddata sumwgt=sumwgt mean=predmean actmean;
run;    /*smp_wgt 고려한 실제 인원수 = sumwgt*/


data resamp;
set resamp;
if (_n_ eq 1) then set preddata;
retain sumwgt predmean actmean;
n+smp_wgt;
if n<0.1*sumwgt then val_dec=0;
else if n<0.2*sumwgt then val_dec=1;
else if n<0.3*sumwgt then val_dec=2;
else if n<0.4*sumwgt then val_dec=3;
else if n<0.5*sumwgt then val_dec=4;
else if n<0.6*sumwgt then val_dec=5;
else if n<0.7*sumwgt then val_dec=6;
else if n<0.8*sumwgt then val_dec=7;
else if n<0.9*sumwgt then val_dec=8;
else val_dec=9;
run; 





/*210526*/
proc summary data=resamp;
var target pred;
class val_dec;
weight smp_wgt;
output out=fullmean mean=actmnf prdmnf;   /*fullmean으로 out, act와 prd 평균 반환*/
run;



data actfmean(rename=(actmnf=actomn_g) drop=val_dec);
set fullmean(where=(val_dec=.) keep=actmnf val_dec);
run;



data fullmean_1;
set fullmean;
if (_n_ eq 1) then set actfmean;
liftf=100*actmnf/actomn_g;
retain actomn_g;
run;




/*2*/
%macro bootst25;    /*작은 매크로의 allbs를 25회 반복*/

data bs_sum; val_dec=.; run;   /*3*/
%do samp=1 %to 25;



%macro bootstrap;   /*하나의 allbs 만드는 과정*/

data allbs&samp; set _null_; run;     /*modbs 누적 위한 빈 데이터 세트*/

%do prcnt=1 %to 100;
data modbs&prcnt;   /*modbs1~modbs100*/
set resamp;
if 0.01*(&prcnt-1)<ranuni(-1)<0.01*&prcnt then output modbs&prcnt;  /*seed넘버 -1 주면 복원추출 가능*/
run;

data allbs&samp;
set allbs&samp modbs&prcnt;
run;

%end;
%mend;
%bootstrap;

/*여기까지가 한개의 부스트랩 샘플, 아래로는 이짓을 25회 반복-2로 ㄱㄱ*/


proc sort data=allbs&samp;
by descending pred;
run;


proc univariate data=allbs&samp noprint;
weight smp_wgt;
var pred;
output out=preddata sumwgt=sumwgt;
run;    /*smp_wgt 고려한 실제 인원수 = sumwgt*/


data allbs&samp;
set allbs&samp;
if (_n_ eq 1) then set preddata;
retain sumwgt ;
n+smp_wgt;
if n<0.1*sumwgt then val_dec=0;
else if n<0.2*sumwgt then val_dec=1;
else if n<0.3*sumwgt then val_dec=2;
else if n<0.4*sumwgt then val_dec=3;
else if n<0.5*sumwgt then val_dec=4;
else if n<0.6*sumwgt then val_dec=5;
else if n<0.7*sumwgt then val_dec=6;
else if n<0.8*sumwgt then val_dec=7;
else if n<0.9*sumwgt then val_dec=8;
else val_dec=9;
run; 




proc summary data=allbs&samp;
var target pred;
class val_dec;
weight smp_wgt;
output out=bsmns&samp mean=actmn&samp prdmn&samp;   /*fullmean으로 out, act와 prd 평균 반환*/
run;



data actomean(rename=(actmn&samp=actomn&samp) drop=val_dec);
set bsmns&samp(where=(val_dec=.) keep=actmn&samp val_dec);
run;



data bsmns_1&samp;
set bsmns&samp;
if (_n_ eq 1) then set actomean;
liftd&samp=100*actmn&samp/actomn&samp;
retain actomn&samp;
run;




data bs_sum;    /*25개 bs merge, null set 지정해줘야 함 -3 */   
merge bs_sum bsmns_1&samp;
by val_dec;
run;


%end;
%mend;
%bootst25;





/*2est-mean(bs)를 위한 데이터셋 생성*/
data bs_sum;
merge bs_sum fullmean_1;
by val_dec; 
run;

data bs_sum_1;
set bs_sum;
prdmbs=mean(of prdmn1-prdmn25);
prdsbs=std(of prdmn1-prdmn25);

actmbs=mean(of actmn1-actmn25);
actsbs=std(of actmn1-actmn25);

liftmbs=mean(of liftd1-liftd25);
liftsbs=std(of liftd1-liftd25);


/*bootstrap estimate*/
bsest_p=2*prdmnf-prdmbs; /*2est-mean(bs)*/
lci_p=bsest_p-1.96*prdsbs;
uci_p=bsest_p+1.96*prdsbs;

bsest_a=2*actmnf-actmbs;
lci_a=bsest_a-1.96*actsbs;
uci_a=bsest_a+1.96*actsbs;

bsest_l=2*liftf-liftmbs;
lci_l=bsest_l-1.96*liftsbs;
uci_l=bsest_l+1.96*liftsbs;
run;



proc tabulate data=bs_sum_1;
var prdmnf bsest_p lci_p uci_p actmnf bsest_a lci_a uci_a liftf bsest_l lci_l uci_l;
class val_dec;
table (val_dec='Decile' all='Total'), 
(prdmnf='Pred'*mean=' '*f=6.2
bsest_p='BS Est Prob'*mean=' '*f=6.2
lci_p='BS Lower CI Prob'*mean=' '*f=6.2
uci_p='BS Upper CI Prob'*mean=' '*f=6.2

actmnf='% Y=1'*mean=' '*f=6.2
bsest_a='BS Est % Y=1'*mean=' '*f=6.2
lci_a='BS Lower CI % Y=1'*mean=' '*f=6.2
uci_a='BS Upper CI % Y=1'*mean=' '*f=6.2

liftf='Lift'*mean=' '*f=4.
bsest_l='BS Est Lift'*mean=' '*f=4.
lci_l='BS Lower CI Lift'*mean=' '*f=4.
uci_l='BS Upper CI Lift'*mean=' '*f=4.
) / rts=6 row=float;
run;
