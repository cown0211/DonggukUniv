library(rpart)

al=read.csv("al.csv")

al_omit = na.omit(al)
al_omit = al_omit[,c(-2,-3,-5)]
summary(al_omit)
str(al_omit)

index = sample(2,nrow(al_omit),replace=TRUE,prob=c(0.6,0.4))
traindata = al_omit[index==1,]
testdata = al_omit[index==2,]

al_cart = rpart(Group~. , data=traindata , control=rpart.control(minsplit=10))
al_cart
plot(al_cart)
text(al_cart,use.n=T)

print(al_cart$cptable)
opt = which.min(al_cart$cptable[,"xerror"])
cp = al_cart$cptable[opt,"CP"]
cp

al_prune = prune(al_cart,cp=cp)
print(al_prune)
plot(al_prune)
text(al_prune,use.n=T)

al_pre = predict(al_prune,testdata,type="class")
al_pre
pre_table = table(testdata$Group,al_pre)
pre_table
accuracy = (pre_table[1,1]+pre_table[2,2])/sum(pre_table)
accuracy