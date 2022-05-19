/*1.데이터 읽기*/
data abalone;
infile '/folders/myfolders/Abalone/abalone_data.txt' delimiter=',';
input Sex $ Length Diameter Height Whole Shucked Viscera Shell Rings;
run;

/*25개 데이터만 추출해서 미리보기*/
options obs=25;
proc print data=abalone;
run;

/*기초통계량 계산 및 데이터 확인*/
options obs=max;
proc univariate data=abalone plot;
run;

/*도수분포표 그리기*/
proc freq data=abalone;
table sex/missing;
run;

/*2.데이터 정제*/
/*m,f 값만 채택*/
data model;
set abalone(where=(sex^='I'));
if sex = 'M' then target=1;
else target=0;
smp_wgt=1;
run;




/*'M','F'도수분포표 그리기*/
proc freq data=model;
table sex/missing;
run;

/*기초통계량 계산 및 데이터 확인*/
proc univariate data=model plot;
run;

/*이상치 탐색 및 백분위수로 대체*/
%macro outlier(dsname,var);

/*백분위수 찾기*/
proc univariate data=&dsname plot;
var &var;
output out=&var.data pctlpts=99 pctlpts=1 pctlpre=&var;
run;

/*백분위수 대체*/
data &dsname;
set &dsname;
if (_n_ eq 1) then set &var.data(keep=&var.99 &var.1);
if &var>2*&var.99 then &var.2=2*&var.99;
else if &var<0.5*&var.1 then &var.2=0.5*&var.1;
else &var.2=&var;
run;

/*대체된 백분위수 값만 추출*/
proc print data=&dsname;
where &var^=&var.2;
var &var &var.2;
run;

%mend;



%outlier(model,length);
%outlier(model,diameter);
%outlier(model,height);
%outlier(model,whole);
%outlier(model,shucked);
%outlier(model,viscera);
%outlier(model,shell);
%outlier(model,rings);

/*기존의 분포를 크게 변화시키지 않음*/
proc univariate data=model plot;
var height height2;
run;

/*변수변환*/
%macro trans(var);
title "&var";
data model;
set model;
&var._sq=&var.2**2;
&var._cu=&var.2**3;
&var._sqrt=sqrt(&var.2);
&var._curt=&var.2**(1/3);
&var._log=log(max(0.0001,&var.2));
&var._exp=exp(&var.2);
&var._tan=tan(&var.2);
&var._sin=sin(&var.2);
&var._cos=cos(&var.2);
&var._inv=1/max(0.0001,&var.2);
&var._sqi=1/max(0.0001,&var.2**2);
&var._cui=1/max(0.001,&var.2**3);
&var._sqri=1/max(0.0001,sqrt(&var.2));
&var._curi=1/max(0.0001,&var.2**(1/3));
&var._logi=1/max(0.0001,log(max(0.0001,&var.2)));
&var._expi=1/max(0.0001,exp(&var.2));
&var._tani=1/max(0.0001,tan(&var.2));
&var._sini=1/max(0.0001,sin(&var.2));
&var._cosi=1/max(0.0001,cos(&var.2));
run;

proc logistic data=model descending;
model target=&var.2 &var._sq &var._cu &var._sqrt &var._curt &var._log &var._exp &var._tan &var._cos &var._sin
&var._inv &var._sqi &var._cui &var._curi &var._logi &var._expi &var._tani &var._sini &var._cosi/selection=stepwise maxstep=4 details;
run;

%mend;

%trans(Length);
%trans(Diameter);
%trans(Height);
%trans(Whole);
%trans(Shucked);
%trans(Viscera);
%trans(Shell);
%trans(Rings);

/*3.모형구축*/

/*훈련 데이터 생성*/
data model;
set model;
if ranuni(5555)<0.7 then splitwgt=1;
else splitwgt=.;
records=1;
run;

/*변수 선택*/
proc logistic data=model descending;
title "Stepwise";
weight splitwgt;
model target=Length_sini Length_curi Diameter_sini Diameter_curi Height_sini Whole_sini Shucked_curt Shucked_sini Viscera_tani Shell_tani/selection=stepwise sle=0.3 sls=0.3;
run;

proc logistic data=model descending;
title "Backward";
weight splitwgt;
model target=Length_sini Length_curi Diameter_sini Diameter_curi Height_sini Whole_sini Shucked_curt Shucked_sini Viscera_tani Shell_tani/selection=backward sls=0.3;
run;

proc logistic data=model descending;
title "Forward";
weight splitwgt;
model target=Length_sini Length_curi Diameter_sini Diameter_curi Height_sini Whole_sini Shucked_curt Shucked_sini Viscera_tani Shell_tani/selection=forward sle=0.3;
run;

proc logistic data=model descending;
title "Score";
weight splitwgt;
model target=Length_sini Length_curi Diameter_sini Diameter_curi Height_sini Whole_sini Shucked_curt Shucked_sini Shell_tani
/selection=score best=2;
run;

/*모형 구축*/
proc logistic data=model descending;
weight splitwgt;
model target = Length_sini Length_curi Diameter_curi Height_sini Shucked_curt Shucked_sini Shell_tani/details;
output out=m_out pred=pred;
run;

proc sort data=m_out;
by descending pred;
run;
/*4.모형평가*/

/*십분위 데이터 생성*/
proc univariate data=m_out(where=(splitwgt^=.)) noprint;
weight smp_wgt;
var pred target;
output out=preddata sumwgt=sumwgt;
run;

proc print data=m_out(where=(splitwgt^=.));
var target pred splitwgt smp_wgt;
run;

data mod_dec;
set m_out(where=(splitwgt^=.));
if (_n_ eq 1) then set preddata;
retain sumwgt;
n+smp_wgt;
if n<0.1*sumwgt then mod_dec=0; else
if n<0.2*sumwgt then mod_dec=1; else
if n<0.3*sumwgt then mod_dec=2; else
if n<0.4*sumwgt then mod_dec=3; else
if n<0.5*sumwgt then mod_dec=4; else
if n<0.6*sumwgt then mod_dec=5; else
if n<0.7*sumwgt then mod_dec=6; else
if n<0.8*sumwgt then mod_dec=7; else
if n<0.9*sumwgt then mod_dec=8; else
mod_dec=9;
run;


/*십분위 분석*/
proc tabulate data=mod_dec;
title "Decile Analysis of training data";
weight smp_wgt;
class mod_dec;
var records target pred;
table mod_dec='decile' all='total',
records='Number of obs'*(sum=' '*f=comma10.)
pred='Predicted probability'*(mean=' '*f=11.5)
target='Actual'*(mean=' '*f=11.5)/rts=9 row=float;
run;

/*테스트 데이터세트를 이용한 평가*/
proc univariate data=m_out(where=(splitwgt=.)) noprint;
weight smp_wgt;
var pred target;
output out=preddata sumwgt=sumwgt;
run;

proc print data=m_out(where=(splitwgt=.));
var target pred splitwgt smp_wgt;
run;

data mod_dec;
set m_out(where=(splitwgt=.));
if (_n_ eq 1) then set preddata;
retain sumwgt;
n+smp_wgt;
if n<0.1*sumwgt then mod_dec=0; else
if n<0.2*sumwgt then mod_dec=1; else
if n<0.3*sumwgt then mod_dec=2; else
if n<0.4*sumwgt then mod_dec=3; else
if n<0.5*sumwgt then mod_dec=4; else
if n<0.6*sumwgt then mod_dec=5; else
if n<0.7*sumwgt then mod_dec=6; else
if n<0.8*sumwgt then mod_dec=7; else
if n<0.9*sumwgt then mod_dec=8; else
mod_dec=9;
run;




/*십분위 분석*/
proc tabulate data=mod_dec;
title "Decile Analysis of test data";
weight smp_wgt;
class mod_dec;
var records target pred;
table mod_dec='decile' all='total',
records='Number of obs'*(sum=' '*f=comma10.)
pred='Predicted probability'*(mean=' '*f=11.5)
target='Actual'*(mean=' '*f=11.5)/rts=9 row=float;
run;

/*5.재표본을 통한 모형 안정성 검정*/

/*테스트 데이터와 중요변수 몇개, 예측값을 포함한 데이터셋 생성*/
proc logistic data=model descending;
weight splitwgt;
model target = diameter_sini 
diameter_curi  
height_sini  
shucked_curt 
shucked_sini 
shell_tani;
output out=resamp(where=(splitwgt=.) keep= pred target records smp_wgt splitwgt) pred=pred;
run;

/*잭나이프 방법*/
%macro jackknif;

data jk_sum;
val_dec=.;
run;

%do prcnt=1 %to 100;

data out&prcnt;
set resamp;
if 0.01*(&prcnt-1)<ranuni(5555)<0.01*(&prcnt) then delete;
run;

proc sort data=out&prcnt;
by descending pred;
run;

proc univariate data=out&prcnt noprint;
weight smp_wgt;
var pred;
output out=preddata sumwgt=sumwgt;
run;

data out&prcnt;
set out&prcnt;
if (_n_ eq 1) then set preddata;
retain sumwgt;
n+smp_wgt;
if n<0.1*sumwgt then val_dec=0; else
if n<0.2*sumwgt then val_dec=1; else
if n<0.3*sumwgt then val_dec=2; else
if n<0.4*sumwgt then val_dec=3; else
if n<0.5*sumwgt then val_dec=4; else
if n<0.6*sumwgt then val_dec=5; else
if n<0.7*sumwgt then val_dec=6; else
if n<0.8*sumwgt then val_dec=7; else
if n<0.9*sumwgt then val_dec=8; else
val_dec=9;
run;

proc summary data=out&prcnt;
var target pred;
class val_dec;
weight smp_wgt;
output out=jkmns&prcnt mean=actmn&prcnt prdmn&prcnt;
run;

data actomean(rename=(actmn&prcnt=actom&prcnt) drop=val_dec);
set jkmns&prcnt(where=(val_dec=.) keep=actmn&prcnt val_dec);
run;

data jkmns&prcnt;
set jkmns&prcnt;
if (_n_ eq 1) then set actomean;
retain actom&prcnt;
liftd&prcnt=100*actmn&prcnt/actom&prcnt;
run;

data jk_sum;
merge jk_sum jkmns&prcnt;
by val_dec;
run;

%end;
%mend;

%jackknif;

/*잭나이프방법 이익도표*/
data jk_sum;
set jk_sum;

prdmjk=mean(of prdmn1-prdmn100);
prdsdjk=std(of prdmn1-prdmn100);

actmjk=mean(of actmn1-actmn100);
actsdjk=std(of actmn1-actmn100);

liftmjk=mean(of liftd1-liftd100);
liftsdjk=std(of liftd1-liftd100);

lci_p=prdmjk-1.96*prdsdjk;
uci_p=prdmjk+1.96*prdsdjk;

lci_a=actmjk-1.96*actsdjk;
uci_a=actmjk+1.96*actsdjk;

lci_l=liftmjk-1.96*liftsdjk;
uci_l=liftmjk+1.96*liftsdjk;

run;

proc format;
picture perc
low-high = '9.999%' (mult=1000000);
run;

proc tabulate data=jk_sum;
var prdmjk lci_p uci_p actmjk lci_a uci_a liftmjk lci_l uci_l;
class val_dec;
table val_Dec='Decile' all='Total',
prdmjk='JK Est prob'*(mean=' '*f=perc.)
lci_p='JK Lower Cl Prob'*(mean=' '*f=perc.)
uci_p='JK Upper Cl Prob'*(mean=' '*f=perc.)
actmjk='JK Est %Active'*(mean=' '*f=perc.)
lci_a='JK Lower CI %Active'*(mean=' '*f=perc.)
uci_a='JK Upper CI %Active'*(mean=' '*f=perc.)
liftmjk='JK Est Lift'*(mean=' '*f=6.)
lci_l='JK Lower CI Lift'*(mean=' '*f=6.)
uci_l='JK Upper CI Lift'*(mean=' '*f=6.)/rts=6 row=float;
run;