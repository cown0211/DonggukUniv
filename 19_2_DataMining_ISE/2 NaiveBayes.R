### play tennis ###


install.packages("e1071")
library(e1071)                 #패키지 설치



pt<-read.csv('playtennis1.csv')


NBplay<-naiveBayes(PlayTennis~.,data=pt)
NBplay                 
#전체 14개의 레코드 중 Y/N의 확률을 구함
#No       Yes 
#0.3571429 0.6428571 


#conditional probabilities
#각 열 조건에 따른 확률 보여줌



predict(NBplay,pt[1:14,-5],type='raw')
#train/test 구분안하고 predict 실행
#NBplay라는 데이터로 모델 짜겠다
#pt의 모든 레코드 사용,5열은 제외(=class)
#자기자신의 모든 레코드로 모델 짰기때문에 완성형x, test로 실험 필요








### naive bayes 실습###
### flight delays ###


install.packages("e1071")
library(e1071)
#e1071 패키지 설치및 불러오기
#flightdelays에서 carrier dep_time dest origin weather day_week flightstatus 열만 남기고 지움




FD<-read.csv("FlightDelays.csv")
summary(FD)
#dep_time weather day_week 세 열은 factor로 바꿔줘야함


FD$DEP_TIME=factor(FD$DEP_TIME%/%100)
#DEP_TIME을 100으로 나눠서 HHMM에서 hour만 남김
#/연산자만 쓰면 소수점 나와서 안됨 %/% 써야 정수나옴

FD$DAY_WEEK=factor(FD$DAY_WEEK)
FD$Weather=factor(FD$Weather)
#DAYWEEK와 Weather도 factor화

summary(FD) #모든변수 factor화





NBmodel=naiveBayes(Flight.Status~. , FD)
NBmodel
#naive bayes 모델링


predict(NBmodel, FD[1:10,-7] , type="raw")
#1~10행만 가지고 예측





### Accidents ###

#패키지설치 및 불러오기
install.packages("e1071")
library(e1071)



#Accidents.csv 불러옴
acc<-read.csv("Accidents20.csv")
summary(acc)



#모든 attribute factor로 변환
for (i in 1:20) {
acc[,i]<-factor(acc[,i])
}
summary(acc)


#전체 데이터 중 60퍼센트 train data 추출
sample_idx<-sample(1:nrow(acc),round(nrow(acc)*0.6))
sample_idx


#train data만 가지고 모델링
nbmodel<-naiveBayes(INJURY~., acc[sample_idx,])
nbmodel



#test data로 예측
pre<-predict(nbmodel,acc[-sample_idx,])
summary(pre)


#table로 정리
table=table(acc[-sample_idx,]$INJURY,pre)
table


#이 모델의 accuracy
accuracy=(sum(table[1,1],table[2,2]))/(sum(table[1,1],table[1,2],table[2,1],table[2,2]))
accuracy
