### IRIS ###

install.packages("randomForest")
library(randomForest)




#7:3비율 랜덤샘플링(1 70퍼,2 30퍼)
ind=sample(2,nrow(iris),replace=TRUE,prob=c(0.7,0.3))

traindata=iris[ind==1,]
testdata=iris[ind==2,]




rf=randomForest(Species~.   , data=traindata   ,  ntree=100,  proximity=TRUE)
rf
#?randomForest (?함수명 or ??패키지명) 하면 설명 나옴




###################결과
Call:
 randomForest(formula = Species ~ ., data = traindata, ntree = 100,      proximity = TRUE) 
               Type of random forest: classification
                     Number of trees: 100
No. of variables tried at each split: 2

        OOB estimate of  error rate: 3.85%        ##oob 데이터로 validation한게 3.85%다
Confusion matrix:
           setosa versicolor virginica class.error
setosa         36          0         0  0.00000000
versicolor      0         34         2  0.05555556
virginica       0          2        30  0.06250000
####################






predict(rf, testdata)
table(testdata$Species,predict(rf,testdata))
importance(rf)    #각 변수의 중요도 설명해줌
#####결과
             MeanDecreaseGini
Sepal.Length         8.660879
Sepal.Width          2.087579
Petal.Length        25.251748
Petal.Width         32.525371
######    여기선 Petal.Width가 가장 중요
varImpPlot(rf)    #이에 대한 그림



irispred=predict(rf,newdata=testdata)  #새로운 데이터로 모델링
table(testdata$Species,irispred)
plot(margin(rf,testdata$Species))    #margin에 대한 그림
                                     #indes 커질수록 정확도는 1로 수렴
                                     #실제로 한두개만 틀림


rf_c=table(testdata$Species,irispred)  #정확도계산
accuracy_rf=(rf_c[1,1]+rf_c[2,2]+rf_c[3,3])/sum(rf_c)
accuracy_rf











### Accidents ###


#패키지 설치 및 불러오기
install.packages("randomForest")
library(randomForest)

#1#MAX_SEV_IR->INJURY로 변환#1#
#Accidents.csv 불러오기
acc=read.csv("Accidents24.csv")
for(i in 1:24){
acc[,i]=factor(acc[,i])
}


#6:4비율 랜덤샘플링(1 60퍼,2 40퍼)
#training data 60% / test data 40%
ind=sample(2,nrow(acc),replace=TRUE,prob=c(0.6,0.4))

traindata=acc[ind==1,]
testdata=acc[ind==2,]



#traindata로 모델링
rf=randomForest(INJURY~.   , data=traindata   ,  ntree=100)
rf



#testdata로 예측
predict(rf, testdata)
table(testdata$INJURY,predict(rf,testdata))




#test데이터로 모델링
accpred=predict(rf,newdata=testdata)
table(testdata$INJURY,accpred)
plot(margin(rf,testdata$INJURY))  




#정확도계산
rf_c=table(testdata$INJURY,accpred)
accuracy_rf=(rf_c[1,1]+rf_c[2,2])/sum(rf_c)
accuracy_rf




#2#MAX_SEV_IR->INJURY로 변환#2#
###INJURY_CRASH,NO_INJ_I,PRPTYDMG_CRASH,FATALITIES 삭제###

#Accidents.csv 불러오기
acc=read.csv("Accidents20.csv")
for(i in 1:20){
acc[,i]=factor(acc[,i])
}


#6:4비율 랜덤샘플링(1 60퍼,2 40퍼)
#training data 60% / test data 40%
ind=sample(2,nrow(acc),replace=TRUE,prob=c(0.6,0.4))

traindata=acc[ind==1,]
testdata=acc[ind==2,]



#traindata로 모델링
rf=randomForest(INJURY~.   , data=traindata   ,  ntree=100)
rf



#testdata로 예측
predict(rf, testdata)
table(testdata$INJURY,predict(rf,testdata))




#test데이터로 모델링
accpred=predict(rf,newdata=testdata)
table(testdata$INJURY,accpred)
plot(margin(rf,testdata$INJURY))  




#정확도계산
rf_c=table(testdata$INJURY,accpred)
accuracy_rf=(rf_c[1,1]+rf_c[2,2])/sum(rf_c)
accuracy_rf


