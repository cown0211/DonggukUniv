install.packages("randomForest")
library(randomForest)

al=read.csv("al.csv")

al_omit = na.omit(al)
al_omit = al_omit[,c(-2,-3,-5)]

idx = sample(2,nrow(al_omit),replace=TRUE,prob=c(0.6,0.4))
traindata = al_omit[idx==1,]
testdata = al_omit[idx==2,]

rf = randomForest(Group~.,data=traindata,ntree=100,proximity=TRUE)
rf

pre1=predict(rf,testdata)
table(testdata$Group,pre1)

accpred = predict(rf,newdata=testdata)
table(testdata$Group,accpred)

rf_c= table(testdata$Group,accpred)
acc_rf = (rf_c[1,1]+rf_c[2,2])/sum(rf_c)
acc_rf

