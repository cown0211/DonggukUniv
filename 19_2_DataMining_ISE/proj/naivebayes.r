install.packages("e1071")
library(e1071)

al = read.csv("al.csv")

al_omit = na.omit(al)
al_omit = al_omit[,c(-2,-3,-5)]
str(al_omit)

al_omit$eTIV=al_omit$eTIV%/%100
al_omit$nWBV=(al_omit$nWBV*1000)%/%10
al_omit$ASF=(al_omit$ASF*1000)%/%100

for(i in 1:ncol(al_omit)) {
al_omit[,i]=factor(al_omit[,i])
}
str(al_omit)

sample_idx = sample(1:nrow(al_omit),round(nrow(al_omit)*0.6))
nb_al = naiveBayes(Group~. , data=al_omit[sample_idx,])
nb_al

pre1 = predict(nb_al,al_omit[-sample_idx,])
pre_table = table(al_omit[-sample_idx,]$Group,pre1)
pre_table

accuracy = (pre_table[1,1]+pre_table[2,2])/sum(pre_table)
accuracy

