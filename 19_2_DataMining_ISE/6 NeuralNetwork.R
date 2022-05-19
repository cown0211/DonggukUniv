install.packages("nnet")
library(nnet)


airline=read.csv("EastWestAirlinesNN.csv")

airline=airline[,-1]    #ID열 제거
airline$Topflight=as.factor(airline$Topflight)
airline$cc1_miles.=as.factor(airline$cc1_miles.)
airline$cc2_miles.=as.factor(airline$cc2_miles.)
airline$cc3_miles.=as.factor(airline$cc3_miles.)
airline$Email=as.factor(airline$Email)
airline$Club_member=as.factor(airline$Club_member)
airline$Any_cc_miles_12mo=as.factor(airline$Any_cc_miles_12mo)
airline$Phone_sale=as.factor(airline$Phone_sale)

summary(airline)          #변수 factor화




sample_idx=sample(1:nrow(airline),round(nrow(airline)*0.6)) #traindata추출

trainnn=airline[sample_idx,]
testnn=airline[-sample_idx,]



nn=nnet(Phone_sale~.,data=trainnn,size=2,rang=0.1,decay=5e-4,maxit=100)

nnpre=(predict(nn,testnn)>=0.5)

table(testnn$Phone_sale,nnpre)

table(testnn$Phone_sale,nnpre)[1,1]/sum(table(testnn$Phone_sale,nnpre))

