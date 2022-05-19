#######################################################################
##################데이터 불러오기 및 전처리#################################
#######################################################################
c_1<-read.csv('C://가계 1분위.csv',header=T)
c_2<-read.csv('C://가계 2분위.csv',header=T)
c_3<-read.csv('C://가계 3분위.csv',header=T)
c_4<-read.csv('C://가계 4분위.csv',header=T)
c_5<-read.csv('C://가계 5분위.csv',header=T)
c_all<-read.csv('C://가계 전체.csv',header=T)
c_10<-read.csv('C://가계 하위 10% 분위.csv',header=T)
#c_1~5은 소득1~5분위 자료,c_all은 전체자료, c_10 소득 하위 10%분위 자료, 소득 하위 10%자료는 본론 5에 활용
#목록이름 단순화
names(c_1)<-c("년도","가구분포","소득","가계지출","소비지출","식료품비주류음료","주류담배","의류신발","주거수도광열","가정용품가사서비스","보건","교통","통신","오락문화","교육","음식숙박","기타상품서비스","비소비지출")
names(c_2)<-c("년도","가구분포","소득","가계지출","소비지출","식료품비주류음료","주류담배","의류신발","주거수도광열","가정용품가사서비스","보건","교통","통신","오락문화","교육","음식숙박","기타상품서비스","비소비지출")
names(c_3)<-c("년도","가구분포","소득","가계지출","소비지출","식료품비주류음료","주류담배","의류신발","주거수도광열","가정용품가사서비스","보건","교통","통신","오락문화","교육","음식숙박","기타상품서비스","비소비지출")
names(c_4)<-c("년도","가구분포","소득","가계지출","소비지출","식료품비주류음료","주류담배","의류신발","주거수도광열","가정용품가사서비스","보건","교통","통신","오락문화","교육","음식숙박","기타상품서비스","비소비지출")
names(c_5)<-c("년도","가구분포","소득","가계지출","소비지출","식료품비주류음료","주류담배","의류신발","주거수도광열","가정용품가사서비스","보건","교통","통신","오락문화","교육","음식숙박","기타상품서비스","비소비지출")
names(c_all)<-c("년도","가구분포","소득","가계지출","소비지출","식료품비주류음료","주류담배","의류신발","주거수도광열","가정용품가사서비스","보건","교통","통신","오락문화","교육","음식숙박","기타상품서비스","비소비지출")
names(c_10)<-c("년도","가구분포","소득","가계지출","소비지출","식료품비주류음료","주류담배","의류신발","주거수도광열","가정용품가사서비스","보건","교통","통신","오락문화","교육","음식숙박","기타상품서비스","비소비지출")

#NA및 0개수확인,Min,Max파악하여 이상치가 있는지 판단: NA,0,이상치 없음.
sum(is.na(c_1));sum(is.na(c_2));sum(is.na(c_3));sum(is.na(c_4));sum(is.na(c_5));sum(is.na(c_all));sum(is.na(c_10))
sum(c_1==0);sum(c_2==0);sum(c_3==0);sum(c_4==0);sum(c_5==0);sum(c_all==0);sum(c_10==0)
summary(c_1);summary(c_2);summary(c_3);summary(c_4);summary(c_5);summary(c_all);summary(c_10)
#소비지출액=12개소비목록 합 확인
sum(c_1[,c(6:17)])-sum(c_1[,5])
sum(c_2[,c(6:17)])-sum(c_2[,5])
sum(c_3[,c(6:17)])-sum(c_3[,5])
sum(c_4[,c(6:17)])-sum(c_4[,5])
sum(c_5[c(6:17)])-sum(c_5[,5])
sum(c_all[c(6:17)])-sum(c_all[,5])
sum(c_10[c(6:17)])-sum(c_10[,5])

#금액의 단위가 너무커서 10000단위로 바꿈
c_1[,3:18]<-c_1[,3:18]/10000
c_2[,3:18]<-c_2[,3:18]/10000
c_3[,3:18]<-c_3[,3:18]/10000
c_4[,3:18]<-c_4[,3:18]/10000
c_5[,3:18]<-c_5[,3:18]/10000
c_all[,3:18]<-c_all[,3:18]/10000
c_10[,3:18]<-c_10[,3:18]/10000

#######################################################################
#################################본론1##################################
#######################################################################

install.packages("corrplot")
library(corrplot)
#그림1-1. 소득, 가계지출, 소득지출, 비소비지출 간의 상관계수 표
## 유의수준 0.05에 따라 유의하지 않은 경우 X 표시하기

res1=cor.mtest(cor(c_1[,c(3:5,18)]))
res2=cor.mtest(cor(c_2[,c(3:5,18)]))
res3=cor.mtest(cor(c_3[,c(3:5,18)]))
res4=cor.mtest(cor(c_4[,c(3:5,18)]))
res5=cor.mtest(cor(c_5[,c(3:5,18)]))

par(mfrow=c(2,3))
corrplot(cor(c_1[,c(3:5,18)]), p.mat = res1[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='1분위', mar=c(0,0,1,0))
corrplot(cor(c_2[,c(3:5,18)]), p.mat = res2[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='2분위', mar=c(0,0,1,0))
corrplot(cor(c_3[,c(3:5,18)]), p.mat = res3[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='3분위', mar=c(0,0,1,0))
corrplot(cor(c_4[,c(3:5,18)]), p.mat = res4[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='4분위', mar=c(0,0,1,0))
corrplot(cor(c_5[,c(3:5,18)]), p.mat = res5[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='5분위', mar=c(0,0,1,0))



#그림1-2. 년도에 따른 소득,가계지출,소비지출의 변화
#소비지출=가계지출-비소비지출
#비소비지출= 조세,공적연금,사회보험,비영리단체로이전, 가구간 이전 등
par(mfrow=c(2,3))
plot(소득~년도,type="l",data=c_1,main='1분위',ylim=c(min(소득,가계지출,소비지출),max(소득,가계지출,소비지출)))
lines(가계지출~년도,type="l",col="Red",data=c_1)
lines(소비지출~년도,type="l",col="blue",data=c_1)
plot(소득~년도,type="l",data=c_2,main='2분위',ylim=c(min(소득,가계지출,소비지출),max(소득,가계지출,소비지출)))
lines(가계지출~년도,type="l",col="Red",data=c_2)
lines(소비지출~년도,type="l",col="blue",data=c_2)
plot(소득~년도,type="l",data=c_3,main='3분위',ylim=c(min(소득,가계지출,소비지출),max(소득,가계지출,소비지출)))
lines(가계지출~년도,type="l",col="Red",data=c_3)
lines(소비지출~년도,type="l",col="blue",data=c_3)
plot(소득~년도,type="l",data=c_4,main='4분위',ylim=c(min(소득,가계지출,소비지출),max(소득,가계지출,소비지출)))
lines(가계지출~년도,type="l",col="Red",data=c_4)
lines(소비지출~년도,type="l",col="blue",data=c_4)
plot(소득~년도,type="l",data=c_5,main='5분위',ylim=c(min(소득,가계지출,소비지출),max(소득,가계지출,소비지출)))
lines(가계지출~년도,type="l",col="Red",data=c_5)
lines(소비지출~년도,type="l",col="blue",data=c_5)
plot.new();legend("center",legend=c("소득","가계지출","소비지출"),col=c('black','red','blue'),lty=1)
###소득은 분위에 상관없이 증가하는 추세이나, 지출은 저분위일수록 증가->감소 추세이고 고분위일수록 증가추세이다.








#######################################################################
################################본론2###################################
#######################################################################

#그림2-1. 소비지출분야별 상관분석

res1=cor.mtest(cor(c_1[,c(6:17)]))
res2=cor.mtest(cor(c_2[,c(6:17)]))
res3=cor.mtest(cor(c_3[,c(6:17)]))
res4=cor.mtest(cor(c_4[,c(6:17)]))
res5=cor.mtest(cor(c_5[,c(6:17)]))


par(mfrow=c(2,3))
corrplot(cor(c_1[,c(6:17)]), p.mat = res1[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='1분위', mar=c(0,0,1,0))
corrplot(cor(c_2[,c(6:17)]), p.mat = res1[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='2분위', mar=c(0,0,1,0))
corrplot(cor(c_3[,c(6:17)]), p.mat = res1[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='3분위', mar=c(0,0,1,0))
corrplot(cor(c_4[,c(6:17)]), p.mat = res1[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='4분위', mar=c(0,0,1,0))
corrplot(cor(c_5[,c(6:17)]), p.mat = res1[[1]], sig.level = 0.05, type="upper", tl.pos="d", main='5분위', mar=c(0,0,1,0))

#그림2-2. 년도에 따른 소비분야별 액수변화
par(mfrow=c(2,3))
plot(c_1[,6]~c_1[,1],type="l",ylim=c(0,max(c_1[,6:17])),xlab='년도',ylab='지출액(단위:만 원)',main='1분위')
lines(c_1[,7]~c_1[,1],type="l",col='red')
lines(c_1[,8]~c_1[,1],type="l",col='blue')
lines(c_1[,9]~c_1[,1],type="l",col='purple')
lines(c_1[,10]~c_1[,1],type="l",col='yellow')
lines(c_1[,11]~c_1[,1],type="l",col='orange')
lines(c_1[,12]~c_1[,1],type="l",col='grey')
lines(c_1[,13]~c_1[,1],type="l",col='brown')
lines(c_1[,14]~c_1[,1],type="l",col='light blue')
lines(c_1[,15]~c_1[,1],type="l",col='green')
lines(c_1[,16]~c_1[,1],type="l",col='dark green')
lines(c_1[,17]~c_1[,1],type="l",col='pink')
plot(c_2[,6]~c_2[,1],type="l",ylim=c(0,max(c_2[,6:17])),xlab='년도',ylab='지출액(단위:만 원)',main='2분위')
lines(c_2[,7]~c_2[,1],type="l",col='red')
lines(c_2[,8]~c_2[,1],type="l",col='blue')
lines(c_2[,9]~c_2[,1],type="l",col='purple')
lines(c_2[,10]~c_2[,1],type="l",col='yellow')
lines(c_2[,11]~c_2[,1],type="l",col='orange')
lines(c_2[,12]~c_2[,1],type="l",col='grey')
lines(c_2[,13]~c_2[,1],type="l",col='brown')
lines(c_2[,14]~c_2[,1],type="l",col='light blue')
lines(c_2[,15]~c_2[,1],type="l",col='green')
lines(c_2[,16]~c_2[,1],type="l",col='dark green')
lines(c_2[,17]~c_2[,1],type="l",col='pink')
plot(c_3[,6]~c_3[,1],type="l",ylim=c(0,max(c_3[,6:17])),xlab='년도',ylab='지출액(단위:만 원)',main='3분위')
lines(c_3[,7]~c_3[,1],type="l",col='red')
lines(c_3[,8]~c_3[,1],type="l",col='blue')
lines(c_3[,9]~c_3[,1],type="l",col='purple')
lines(c_3[,10]~c_3[,1],type="l",col='yellow')
lines(c_3[,11]~c_3[,1],type="l",col='orange')
lines(c_3[,12]~c_3[,1],type="l",col='grey')
lines(c_3[,13]~c_3[,1],type="l",col='brown')
lines(c_3[,14]~c_3[,1],type="l",col='light blue')
lines(c_3[,15]~c_3[,1],type="l",col='green')
lines(c_3[,16]~c_3[,1],type="l",col='dark green')
lines(c_3[,17]~c_3[,1],type="l",col='pink')
plot(c_4[,6]~c_4[,1],type="l",ylim=c(0,max(c_4[,6:17])),xlab='년도',ylab='지출액(단위:만 원)',main='4분위')
lines(c_4[,7]~c_4[,1],type="l",col='red')
lines(c_4[,8]~c_4[,1],type="l",col='blue')
lines(c_4[,9]~c_4[,1],type="l",col='purple')
lines(c_4[,10]~c_4[,1],type="l",col='yellow')
lines(c_4[,11]~c_4[,1],type="l",col='orange')
lines(c_4[,12]~c_4[,1],type="l",col='grey')
lines(c_4[,13]~c_4[,1],type="l",col='brown')
lines(c_4[,14]~c_4[,1],type="l",col='light blue')
lines(c_4[,15]~c_4[,1],type="l",col='green')
lines(c_4[,16]~c_4[,1],type="l",col='dark green')
lines(c_4[,17]~c_4[,1],type="l",col='pink')
plot(c_5[,6]~c_5[,1],type="l",ylim=c(0,max(c_5[,6:17])),xlab='년도',ylab='지출액(단위:만 원)',main='5분위')
lines(c_5[,7]~c_5[,1],type="l",col='red')
lines(c_5[,8]~c_5[,1],type="l",col='blue')
lines(c_5[,9]~c_5[,1],type="l",col='purple')
lines(c_5[,10]~c_5[,1],type="l",col='yellow')
lines(c_5[,11]~c_5[,1],type="l",col='orange')
lines(c_5[,12]~c_5[,1],type="l",col='grey')
lines(c_5[,13]~c_5[,1],type="l",col='brown')
lines(c_5[,14]~c_5[,1],type="l",col='light blue')
lines(c_5[,15]~c_5[,1],type="l",col='green')
lines(c_5[,16]~c_5[,1],type="l",col='dark green')
lines(c_5[,17]~c_5[,1],type="l",col='pink')
plot.new()
legend("center",legend=c("식료품·비주류음료","주류·담배","의류·신발","주거·수도·광열","가정용품·가사서비스","보건","교통","통신","오락·문화","교육","음식·숙박","기타상품·서비스"),
col=c('black','red','blue','purple','yellow','orange','grey','brown','light blue','green','dark green','pink'),lty=1)









#######################################################################
######################3.소득과 지출에 대한 다중회귀분석#######################
#######################################################################

install.packages('car');library(car);
#다중공선성 확인 (vif>10이면 해당변수 제외)
y1=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소득~주류담배+의류신발+주거수도광열+보건+교통+오락문화+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소득~주류담배+의류신발+주거수도광열+보건+교통+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소득~주류담배+의류신발+주거수도광열+보건+교통+교육+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소득~주류담배+의류신발+보건+교통+교육+기타상품서비스,data=c_1)
summary(y1);vif(y1);
#p-value 확인 (p-value>0.05인 변수 제외)
y1=lm(소득~주류담배+보건+교통+교육+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1_earn=lm(소득~보건+교통+교육+기타상품서비스,data=c_1)
summary(y1_earn);vif(y1_earn);


#다중공선성
y2=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소득~주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소득~주류담배+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소득~주류담배+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소득~주류담배+가정용품가사서비스+보건+교통+통신+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소득~주류담배+가정용품가사서비스+교통+통신+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소득~주류담배+가정용품가사서비스+교통+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
#p-value
y2=lm(소득~가정용품가사서비스+교통+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2_earn=lm(소득~가정용품가사서비스+교육+기타상품서비스,data=c_2)
summary(y2_earn);vif(y2_earn);


#다중공선성
y3=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소득~식료품비주류음료+주류담배+주거수도광열+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소득~주류담배+주거수도광열+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소득~주류담배+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소득~주류담배+보건+교통+통신+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소득~주류담배+교통+통신+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
#pvalue
y3=lm(소득~주류담배+교통+통신+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3_earn=lm(소득~주류담배+교통+기타상품서비스,data=c_3)
summary(y3_earn);vif(y3_earn);


#다중공선성
y4=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소득~주류담배+의류신발+주거수도광열+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소득~주류담배+의류신발+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소득~주류담배+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소득~주류담배+보건+교통+통신+교육+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소득~주류담배+보건+통신+교육+기타상품서비스,data=c_4)
summary(y4);vif(y4);
#pvalue
y4=lm(소득~주류담배+보건+통신+교육,data=c_4)
summary(y4);vif(y4);
y4=lm(소득~보건+통신+교육,data=c_4)
summary(y4);vif(y4);
y4_earn=lm(소득~보건+통신,data=c_4)
summary(y4_earn);vif(y4_earn);


#다중공선성
y5=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소득~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소득~식료품비주류음료+주류담배+의류신발+가정용품가사서비스+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소득~식료품비주류음료+주류담배+의류신발+가정용품가사서비스+보건+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소득~식료품비주류음료+주류담배+의류신발+가정용품가사서비스+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소득~식료품비주류음료+주류담배+가정용품가사서비스+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소득~식료품비주류음료+주류담배+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소득~주류담배+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
#pvalue
y5_earn=lm(소득~주류담배+교통+통신+교육,data=c_5)
summary(y5_earn);vif(y5_earn);

##소득~지출분야 요약
par(mfrow=c(2,2))
summary(y1_earn);vif(y1_earn);plot(y1_earn);
summary(y2_earn);vif(y2_earn);plot(y2_earn);
summary(y3_earn);vif(y3_earn);plot(y3_earn);
summary(y4_earn);vif(y4_earn);plot(y4_earn);
summary(y5_earn);vif(y5_earn);plot(y5_earn);

y1_earn$coefficients
y2_earn$coefficients
y3_earn$coefficients
y4_earn$coefficients
y5_earn$coefficients;

##지출~지출분야##
#다중공선성
y1=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소비지출~주류담배+의류신발+주거수도광열+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소비지출~주류담배+의류신발+주거수도광열+보건+교통+오락문화+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소비지출~주류담배+의류신발+주거수도광열+보건+교통+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소비지출~주류담배+의류신발+보건+교통+교육+음식숙박+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1=lm(소비지출~주류담배+의류신발+보건+교통+교육+기타상품서비스,data=c_1)
summary(y1);vif(y1);
#pvalue
y1=lm(소비지출~주류담배+의류신발+보건+교통+기타상품서비스,data=c_1)
summary(y1);vif(y1);
y1_consume=lm(소비지출~의류신발+보건+교통+기타상품서비스,data=c_1)
summary(y1_consume);vif(y1_consume);


#다중공선성
y2=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소비지출~주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소비지출~주류담배+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소비지출~주류담배+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소비지출~주류담배+가정용품가사서비스+보건+교통+통신+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소비지출~주류담배+가정용품가사서비스+교통+통신+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
y2=lm(소비지출~주류담배+가정용품가사서비스+교통+교육+기타상품서비스,data=c_2)
summary(y2);vif(y2);
#pvalue
y2_consume=lm(소비지출~가정용품가사서비스+교통+교육+기타상품서비스,data=c_2)
summary(y2_consume);vif(y2_consume);


#다중공선성
y3=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소비지출~식료품비주류음료+주류담배+의류신발+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소비지출~주류담배+의류신발+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소비지출~주류담배+보건+교통+통신+오락문화+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소비지출~주류담배+보건+교통+통신+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
y3=lm(소비지출~주류담배+교통+통신+교육+기타상품서비스,data=c_3)
summary(y3);vif(y3);
#pvalue
y3_consume=lm(소비지출~주류담배+교통+통신+기타상품서비스,data=c_3)
summary(y3_consume);vif(y3_consume);

#다중공선성
y4=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소비지출~주류담배+의류신발+주거수도광열+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소비지출~주류담배+의류신발+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소비지출~주류담배+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소비지출~주류담배+보건+교통+통신+교육+기타상품서비스,data=c_4)
summary(y4);vif(y4);
y4=lm(소비지출~주류담배+보건+통신+교육+기타상품서비스,data=c_4)
summary(y4);vif(y4);
#pvalue
y4_consume=lm(소비지출~주류담배+보건+통신+교육,data=c_4)
summary(y4_consume);vif(y4_consume);

#다중공선성
y5=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+오락문화+교육+음식숙박+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소비지출~식료품비주류음료+주류담배+의류신발+주거수도광열+가정용품가사서비스+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소비지출~식료품비주류음료+주류담배+의류신발+가정용품가사서비스+보건+교통+통신+교육+음식숙박+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소비지출~식료품비주류음료+주류담배+의류신발+가정용품가사서비스+보건+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소비지출~식료품비주류음료+주류담배+의류신발+가정용품가사서비스+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소비지출~식료품비주류음료+주류담배+가정용품가사서비스+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소비지출~식료품비주류음료+주류담배+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
y5=lm(소비지출~주류담배+교통+통신+교육+기타상품서비스,data=c_5)
summary(y5);vif(y5);
#pvalue
y5_consume=lm(소비지출~주류담배+교통+통신+교육,data=c_5)
summary(y5_consume);vif(y5_consume);


#지출~지출분야 요약
summary(y1_consume);vif(y1_consume);plot(y1_consume);
summary(y2_consume);vif(y2_consume);plot(y2_consume);
summary(y3_consume);vif(y3_consume);plot(y3_consume);
summary(y4_consume);vif(y4_consume);plot(y4_consume);
summary(y5_consume);vif(y5_consume);plot(y5_consume);

y1_consume$coefficients;y2_consume$coefficients;y3_consume$coefficients;y4_consume$coefficients;y5_consume$coefficients;














#######################################################################
############################본론4#######################################
#######################################################################

##############4-1. 범주형회귀분석#################

##소득 categorical fitting##
x_1<-rep(1:5,each=15) #소득분위
x_2<-rep(2005:2019,5) #년도
y_income<-c(c_1[,3],c_2[,3],c_3[,3],c_4[,3],c_5[,3])
cate_income=lm(y_income~factor(x_1)+x_2)
summary(cate_income);cate_income
cor(x_1,x_2)
vif(cate_income)

##저축 categorical fitting##
#저축변수 추가
c_1[,19]<-c_1[,3]-c_1[,4];names(c_1)[19]="저축"
c_2[,19]<-c_2[,3]-c_2[,4];names(c_2)[19]="저축"
c_3[,19]<-c_3[,3]-c_3[,4];names(c_3)[19]="저축"
c_4[,19]<-c_4[,3]-c_4[,4];names(c_4)[19]="저축"
c_5[,19]<-c_5[,3]-c_5[,4];names(c_5)[19]="저축"
c_all[,19]<-c_all[,3]-c_all[,4];names(c_all)[19]="저축"
c_10[,19]<-c_10[,3]-c_10[,4];names(c_10)[19]="저축"
y_save<-c(c_1[,19],c_2[,19],c_3[,19],c_4[,19],c_5[,19])
cate_save=lm(y_save~factor(x_1)+x_2)
summary(cate_save);cate_save
vif(cate_save)


#############4-2. 소득불평등vs저축불평등#################
######소득불균형 지표#####
#지니계수 도출
p_income<-vector()
for (i in 1:15){
p_income[i]<-y_income[i]/
sum(y_income[i],y_income[i+15],y_income[i+30],y_income[i+45]+y_income[i+60])

p_income[i+15]<-(y_income[i]+y_income[i+15])/
sum(y_income[i],y_income[i+15],y_income[i+30],y_income[i+45]+y_income[i+60])

p_income[i+30]<-(y_income[i]+y_income[i+15]+y_income[i+30])/
sum(y_income[i],y_income[i+15],y_income[i+30],y_income[i+45]+y_income[i+60])

p_income[i+45]<-(y_income[i]+y_income[i+15]+y_income[i+30]+y_income[i+45])/
sum(y_income[i],y_income[i+15],y_income[i+30],y_income[i+45]+y_income[i+60])

p_income[i+60]<-1;p_income[i+75]<-0}
p_income

x_gini<-rep(c(0.2,0.4,0.6,0.8,1.0,0),each=15)

par(mfrow=c(1,1))
plot(x_gini,p_income,main="소득불평등",xlab="누적인구비율",ylab="누적소득비율",pch=16) 
#1차 선형회귀식으로 추정할수 없음->소득 구간별 기울기가 달라야 함

#2차
x_gini2<-x_gini^2
lm_gini2<-lm(p_income~x_gini+x_gini2);summary(lm_gini2)
lines(c_01,lm_gini2$coefficient[1]+c_01*lm_gini2$coefficient[2]
+c_01^2*lm_gini2$coefficient[3],type="l",col="red")

#3차
x_gini3<-x_gini^3
lm_gini3<-lm(p_income~x_gini+x_gini2+x_gini3);summary(lm_gini3)
lines(c_01,lm_gini3$coefficient[1]+c_01*lm_gini3$coefficient[2]
+c_01^2*lm_gini3$coefficient[3]+c_01^3*lm_gini3$coefficient[4],type="l",col="blue")
abline(a=0,b=1)
legend(0,1,title="x:누적인구비율,y:누적소득비율",col=c("red","blue","black"),legend=c("2차:E(y)=0.008+0.072x+0.904x^2",
"3차:E(y)=-0.003+0.34x+0.171x^2+0.488x^3","Data"),lty=c(1,1,0),pch=c(NA,NA,16),cex=0.9)

#적분값
gin2<-function(x){lm_gini2$coefficient[1]+x*lm_gini2$coefficient[2]+x^2*lm_gini2$coefficient[3]}
gin3<-function(x){
lm_gini3$coefficient[1]+x*lm_gini3$coefficient[2]+x^2*lm_gini3$coefficient[3]+x^3*lm_gini3$coefficient[4]}
integrate(gin2,0,1)
integrate(gin3,0,1)
2*(0.5-0.3458068)



######저축 불균형지표######

p_save<-vector()
for (i in 1:15){
p_save[i]<-y_save[i]/
sum(y_save[i],y_save[i+15],y_save[i+30],y_save[i+45]+y_save[i+60])

p_save[i+15]<-(y_save[i]+y_save[i+15])/
sum(y_save[i],y_save[i+15],y_save[i+30],y_save[i+45]+y_save[i+60])

p_save[i+30]<-(y_save[i]+y_save[i+15]+y_save[i+30])/
sum(y_save[i],y_save[i+15],y_save[i+30],y_save[i+45]+y_save[i+60])

p_save[i+45]<-(y_save[i]+y_save[i+15]+y_save[i+30]+y_save[i+45])/
sum(y_save[i],y_save[i+15],y_save[i+30],y_save[i+45]+y_save[i+60])

p_save[i+60]<-1;p_save[i+75]<-0}
p_save

x_gini<-rep(c(0.2,0.4,0.6,0.8,1.0,0),each=15)

par(mfrow=c(1,1))
plot(x_gini,p_save,main="저축불평등",xlab="누적인구비율",ylab="누적저축비율",pch=16)

#2차
x_gini2<-x_gini^2
lm_sgini2<-lm(p_save~x_gini+x_gini2);summary(lm_sgini2)
lines(c_01,lm_sgini2$coefficient[1]+c_01*lm_sgini2$coefficient[2]
+c_01^2*lm_sgini2$coefficient[3],type="l",col="red")

#3차
x_gini3<-x_gini^3
lm_sgini3<-lm(p_save~x_gini+x_gini2+x_gini3);summary(lm_sgini3)
lines(c_01,lm_sgini3$coefficient[1]+c_01*lm_sgini3$coefficient[2]
+c_01^2*lm_sgini3$coefficient[3]+c_01^3*lm_sgini3$coefficient[4],type="l",col="blue")
abline(a=0,b=1)
legend(0,1,title="x:누적인구비율,y:누적저축비율",col=c("red","blue","black"),legend=c("2차:E(y)=0.02-0.639x+1.584x^2",
"3차:E(y)=-0.007-0.018x-0.115x^2+1.133x^3","Data"),lty=c(1,1,0),pch=c(NA,NA,16),cex=0.9)

#적분값
sgin2<-function(x){lm_sgini2$coefficient[1]+x*lm_sgini2$coefficient[2]+x^2*lm_sgini2$coefficient[3]}
sgin2(1.0)
sgin3<-function(x){
lm_sgini3$coefficient[1]+x*lm_sgini3$coefficient[2]+x^2*lm_sgini3$coefficient[3]+x^3*lm_sgini3$coefficient[4]}
ins2<-integrate(sgin2,0,1)
ins3<-integrate(sgin3,0,1)
2*(0.5-ins2$value)
2*(0.5-ins3$value)


#outlier test
rstudent(lm_sgini2)
rstudent(lm_sgini3)
outlierTest(lm_sgini2)
outlierTest(lm_sgini3)

#절편 포함 2차vs제외 2차
lm_sgini2<-lm(p_save~x_gini+x_gini2);summary(lm_sgini2)
lm_sgini2i<-lm(p_save~x_gini+x_gini2+0);summary(lm_sgini2i)

sgin2i<-function(x){x*lm_sgini2i$coefficient[1]+x^2*lm_sgini2i$coefficient[2]}
ins2i<-integrate(sgin2i,0,1)
ins2i$value
2*(0.5-ins2i$value)









#######################################################################
############################5.소비 항목별 불균형지표########################
#######################################################################

y_consume<-matrix(nrow=90,ncol=12)
for (i in 1:12){
y_consume[,i]<-c(rep(0,15),c_1[,i+5],c_2[,i+5],c_3[,i+5],c_4[,i+5],c_5[,i+5])}

p_consume<-matrix(nrow=90,ncol=12)
p_consume[1:15,1:12]<-0
for (i in 1:15) for (j in 1:12){
sumv<-sum(y_consume[15+i,j],y_consume[30+i,j],y_consume[45+i,j],y_consume[60+i,j],y_consume[75+i,j])
p_consume[15+i,j]<-y_consume[15+i,j]/sumv
p_consume[30+i,j]<-sum(y_consume[15+i,j],y_consume[30+i,j])/sumv
p_consume[45+i,j]<-sum(y_consume[15+i,j],y_consume[30+i,j],y_consume[45+i,j])/sumv
p_consume[60+i,j]<-sum(y_consume[15+i,j],y_consume[30+i,j],y_consume[45+i,j],y_consume[60+i,j])/sumv
p_consume[75+i,j]<-1}
consume_x<-rep(c(0,0.2,0.4,0.6,0.8,1.0),each=15)


#1
consume_x2<-consume_x^2
lm_cgini1<-lm(p_consume[,1]~consume_x+consume_x2);summary(lm_cgini1)
ginfun1<-function(x){
lm_cgini1$coefficient[1]+x*lm_cgini1$coefficient[2]+x^2*lm_cgini1$coefficient[3]}
abline(a=0,b=1)
ins1_2<-integrate(ginfun1,0,1)
ins1_2$value;2*(0.5-ins1_2$value)

#2
lm_cgini2<-lm(p_consume[,2]~consume_x+consume_x2);summary(lm_cgini2)
ginfun2<-function(x){
lm_cgini2$coefficient[1]+x*lm_cgini2$coefficient[2]+x^2*lm_cgini2$coefficient[3]}
ins2_2<-integrate(ginfun2,0,1)
ins2_2$value;2*(0.5-ins2_2$value)

#3
lm_cgini3<-lm(p_consume[,3]~consume_x+consume_x2);summary(lm_cgini3)
ginfun3<-function(x){
lm_cgini3$coefficient[1]+x*lm_cgini3$coefficient[2]+x^2*lm_cgini3$coefficient[3]}
ins3_2<-integrate(ginfun3,0,1)
ins3_2$value;2*(0.5-ins3_2$value)


#4
lm_cgini4<-lm(p_consume[,4]~consume_x+consume_x2);summary(lm_cgini4)
ginfun4<-function(x){
lm_cgini4$coefficient[1]+x*lm_cgini4$coefficient[2]+x^2*lm_cgini4$coefficient[3]}
ins4_2<-integrate(ginfun4,0,1)
ins4_2$value;2*(0.5-ins4_2$value)

#5
lm_cgini5<-lm(p_consume[,5]~consume_x+consume_x2);summary(lm_cgini5)
ginfun5<-function(x){
lm_cgini5$coefficient[1]+x*lm_cgini5$coefficient[2]+x^2*lm_cgini5$coefficient[3]}
ins5_2<-integrate(ginfun5,0,1)
ins5_2$value;2*(0.5-ins5_2$value)

#6
lm_cgini6<-lm(p_consume[,6]~consume_x+consume_x2);summary(lm_cgini6)
ginfun6<-function(x){
lm_cgini6$coefficient[1]+x*lm_cgini6$coefficient[2]+x^2*lm_cgini6$coefficient[3]}
ins6_2<-integrate(ginfun6,0,1)
ins6_2$value;2*(0.5-ins6_2$value)

#7
lm_cgini7<-lm(p_consume[,7]~consume_x+consume_x2);summary(lm_cgini7)
ginfun7<-function(x){
lm_cgini7$coefficient[1]+x*lm_cgini7$coefficient[2]+x^2*lm_cgini7$coefficient[3]}
ins7_2<-integrate(ginfun7,0,1)
ins7_2$value;2*(0.5-ins7_2$value)

#8
lm_cgini8<-lm(p_consume[,8]~consume_x+consume_x2);summary(lm_cgini8)
ginfun8<-function(x){
lm_cgini8$coefficient[1]+x*lm_cgini8$coefficient[2]+x^2*lm_cgini8$coefficient[3]}
ins8_2<-integrate(ginfun8,0,1)
ins8_2$value;2*(0.5-ins8_2$value)

#9
lm_cgini9<-lm(p_consume[,9]~consume_x+consume_x2);summary(lm_cgini9)
ginfun9<-function(x){
lm_cgini9$coefficient[1]+x*lm_cgini9$coefficient[2]+x^2*lm_cgini9$coefficient[3]}
ins9_2<-integrate(ginfun9,0,1)
ins9_2$value;2*(0.5-ins9_2$value)

#10
lm_cgini10<-lm(p_consume[,10]~consume_x+consume_x2);summary(lm_cgini10)
ginfun10<-function(x){
lm_cgini10$coefficient[1]+x*lm_cgini10$coefficient[2]+x^2*lm_cgini10$coefficient[3]}
ins10_2<-integrate(ginfun10,0,1)
ins10_2$value;2*(0.5-ins10_2$value)

#11
lm_cgini11<-lm(p_consume[,11]~consume_x+consume_x2);summary(lm_cgini11)
ginfun11<-function(x){
lm_cgini11$coefficient[1]+x*lm_cgini11$coefficient[2]+x^2*lm_cgini11$coefficient[3]}
ins11_2<-integrate(ginfun11,0,1)
ins11_2$value;2*(0.5-ins11_2$value)

#12
lm_cgini12<-lm(p_consume[,12]~consume_x+consume_x2);summary(lm_cgini12)
ginfun12<-function(x){
lm_cgini12$coefficient[1]+x*lm_cgini12$coefficient[2]+x^2*lm_cgini12$coefficient[3]}
ins12_2<-integrate(ginfun12,0,1)
ins12_2$value;2*(0.5-ins12_2$value)










#######################################################################
############6. 최극빈층(소득분위 하위 10%집단)에 대한 분석######################
#######################################################################

##fitted value for regression model##
gin2(0.1)
sgin2(0.1)
ginfun1(0.1);ginfun2(0.1);ginfun3(0.1);ginfun4(0.1)
ginfun5(0.1);ginfun6(0.1);ginfun7(0.1);ginfun8(0.1)
ginfun9(0.1);ginfun10(0.1);ginfun11(0.1);ginfun12(0.1)

##소득 하위 10% data에서 얻어낸 추정치##
colMeans(c_10[,c(3,19,6:17)])/colMeans(c_all[,c(3,19,6:17)])*0.1

##95% CI for fitted value##
predict10<-matrix(c(predict(lm_gini2,data.frame("x_gini"=0.1,"x_gini2"=0.01),interval="confidence"),
predict(lm_sgini2,data.frame("x_gini"=0.1,"x_gini2"=0.01),interval="confidence"),
predict(lm_cgini1,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini2,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini3,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini4,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini5,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini6,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini7,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini8,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini9,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini10,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini11,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence"),
predict(lm_cgini12,data.frame("consume_x"=0.1,"consume_x2"=0.01),interval="confidence")),
byrow=F,nrow=3,dimnames=list(c("fitted_value","lowrange","uprange"),names(c_1)[c(3,19,6:17)]))

#Plot
value10<-colMeans(c_10[,c(3,19,6:17)])/colMeans(c_all[,c(3,19,6:17)])*0.1
plot(c(1,1),c(predict10[2,1],predict10[3,1]),type="l",lwd=12,col="pink",xlim=c(0.5,14.5),ylim=c(-0.07,0.12)
,main="소득 하위 10%계층이 차지하는 비중",xlab="소득,저축 및 소비항목",ylab="전체 금액=1일때 차지하는 값")
for (i in 2:14){
lines(c(i,i),c(predict10[2,i],predict10[3,i]),type="l",lwd=12,col="pink")
}
lines(1:14,predict10[1,1:14],type="p",lwd=3,col="red",pch=19,cex=1)
lines(1:14,value10,type="p",pch=19,col="blue")
text(seq(1,13,by=2),rep(-0.06,7),labels=colnames(predict10)[seq(1,13,by=2)])
text(seq(2,14,by=2),rep(-0.07,7),labels=colnames(predict10)[seq(2,14,by=2)])
legend(0,0.12,col=c("pink","red","blue"),legend=c("CI for fitted value",
"Mean of fitted value","estimation of 10% data"),lty=c(1,0,0),pch=c(NA,16,16),lwd=10)

#10% data로 추정한 결과가 CI 내에 있는지 확인
value10>predict10[2,]
value10<predict10[3,]
