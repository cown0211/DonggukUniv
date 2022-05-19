
install.packages("C50")
library(C50) 

al=read.csv("al.csv")

al_omit = na.omit(al)
al_omit = al_omit[,c(-2,-3,-5)]
summary(al_omit)

index = sample(2,nrow(al_omit),replace=TRUE,prob=c(0.6,0.4))
traindata = al_omit[index==1,]
testdata = al_omit[index==2,]

dt.al<-C5.0(Group~.,data=traindata)
summary(dt.al)


pre1<-predict(dt.al,testdata)
table=table(testdata$Group,pre1)
table

accuracy=(table[1,1]+table[2,2])/sum(table)
accuracy
