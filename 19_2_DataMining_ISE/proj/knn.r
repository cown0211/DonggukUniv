install.packages("class")
library(class)

al=read.csv("al.csv")

al_omit = na.omit(al)
al_omit = al_omit[,c(-2,-3,-5)]
al_omit$M.F=as.numeric(al_omit$M.F)
str(al_omit)

y=al_omit[,1]
tr.idx=sample(length(y),round(length(y)*0.6))
x.tr=al_omit[tr.idx,-1]
x.te=al_omit[-tr.idx,-1]

m1=knn(x.tr,x.te,y[tr.idx],k=3)
m1

table(y[-tr.idx],m1)
sum(table(y[-tr.idx],m1)[1,1]+table(y[-tr.idx],m1)[2,2])/sum(table(y[-tr.idx],m1))
