al=read.csv("al3.csv")

al_omit = na.omit(al)
al_omit = al_omit[,c(-2,-3,-5)]
al_omit$Group = factor(al_omit$Group)
str(al_omit)

sample_idx = sample(1:nrow(al_omit),round(nrow(al_omit)*0.6))

#모든변수 사용
al_logit = glm(Group~.,family=binomial,data=al_omit[sample_idx,])
summary(al_logit)
exp(coef(al_logit))

pred_al_logit = (predict(al_logit,al_omit[-sample_idx,],type="response")>=0.5)
pred_al_logit

table_al_test = table(al_omit[-sample_idx,]$Group,pred_al_logit)
table_al_test

accuracy = sum(table_al_test[1,1]+table_al_test[2,2])/sum(table_al_test)
accuracy

#4변수 사용
al_logit2 = glm(Group~M.F+Age+MMSE+nWBV,family=binomial,data=al_omit[sample_idx,])
summary(al_logit2)
exp(coef(al_logit2))

pred_al_logit2 = (predict(al_logit2,al_omit[-sample_idx,],type="response")>=0.5)
pred_al_logit2

table_al_test2 = table(al_omit[-sample_idx,]$Group,pred_al_logit2)
table_al_test2

accuracy2 = sum(table_al_test2[1,1]+table_al_test2[2,2])/sum(table_al_test2)
accuracy2
