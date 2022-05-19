### CART 실습 ###


install.packages("rpart")
library(rpart)
#rpart 패키지 설치및 불러오기




bodyfat<-read.csv("Bodyfat.csv")
bodyfat
head(bodyfat)   #1~6열까지만 데이터 보여줌


index=sample(2,nrow(bodyfat),replace=TRUE,prob=c(0.7,0.3))
index
#sample 함수의 활용법
#2는 결과값 (1or2), prob-> 70퍼는 train data =1, 30퍼는 test data=2




bodyfat.train=bodyfat[index==1,]
bodyfat.test=bodyfat[index==2,]
#index=1인 row는 train데이터 , index=2인 row는 test데이터


bodyfat.cart=rpart(bodyfat~Age+Weight+Hip+Knee+Forearm, data=bodyfat.train, control=rpart.control(minsplit=10))
bodyfat.cart
#열값 다 쓰지 않음
#split>=10


plot(bodyfat.cart)
text(bodyfat.cart,use.n=T)
#CART 그림그리고 노드에 글씨씀




print(bodyfat.cart$cptable)
opt=which.min(bodyfat.cart$cptable[,"xerror"])
cp=bodyfat.cart$cptable[opt,"CP"]
cp
#cptable에서 xerror값 최소인 CP값 찾음



bodyfat_prune=prune(bodyfat.cart,cp=cp)
print(bodyfat_prune)



plot(bodyfat_prune)
text(bodyfat_prune)
#결과보면 프루닝 이전보다 줄어듦



#bodyfat.test 데이터로 예측모형
bodyfat_pre=predict(bodyfat_prune,newdata=bodyfat.test)
bodyfat_pre






### CART 과제 ###

#rpart 패키지 설치 및 불러오기
install.packages("rpart")
library(rpart)

#universalbank 불러오기
ub<-read.csv("UniversalBank.csv")
summary(ub)

#Personal_Loan factor화
ub[,10]<-factor(ub[,10])
summary(ub)


#traindata 60%, testdata 40%
index=sample(2,nrow(ub),replace=TRUE,prob=c(0.6,0.4))
ub.train=ub[index==1,]
ub.test=ub[index==2,]

#ID,ZIP_code 열은 제외
ub.cart=rpart(Personal_Loan~Age+Experience+Income+Family+CCAvg+Education+Mortgage
+Securities_Account+CD_Account+Online+CreditCard, data=ub.train, 
control=rpart.control(minsplit=10))
ub.cart



#여기까지의 그림
plot(ub.cart)
text(ub.cart,use.n=T)



print(ub.cart$cptable)
opt=which.min(ub.cart$cptable[,"xerror"])
cp=ub.cart$cptable[opt,"CP"]
cp
#cptable에서 xerror값 최소인 CP값 찾음


#프루닝
ub_prune=prune(ub.cart,cp=cp)
print(ub_prune)

#프루닝 이후의 그림
plot(ub_prune)
text(ub_prune,use.n=T)



#ub.test 데이터로 예측
ub_pre=predict(ub_prune,ub.test,type="class")
ub_pre

#table화
a=table(ub.test$Personal_Loan,ub_pre)
a

#정확도
accuracy=sum(a[1,1],a[2,2])/sum(a)
accuracy


#주어진 데이터로 예측
customer=data.frame(Age=40,Experience=10,Income=84,Family=2,CCAvg=2,Education=2
,Mortgage=0,Securities_Account=0,CD_Account=0,Online=1,CreditCard=1)
ub_pre1=predict(ub_prune,customer,type="class")
ub_pre1
