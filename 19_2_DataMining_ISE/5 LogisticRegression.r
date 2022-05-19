# 1 purchase

purchase=read.csv("C:/purchase2.csv")
purchase


train=purchase[1:20,]
test=purchase[1:20,]   #train셋과 test셋 똑같이 둠


attach(purchase)
group=y[1:20]     #아니면 buy열
group

logit.purchase=glm(y~. , family=binomial , data=train)
logit.purchase    #결과 coefficients 값은 ppt 57p와 같음

exp(coef(logit.purchase))   #odds 값



logitpred=(predict(logit.purchase , test, type="response")>=0.5)
logitpred


y=table(logitpred,group)
y





#2 칼라티비 보급율

tv=read.csv("TVspread.csv")
tv

tv$spread=factor(tv$spread)
summary(tv)         #spread변수 factor화

logit.tv=glm(spread~year, family=binomial, data=tv, weights=count)
logit.tv
summary(logit.tv)

coef(logit.tv)
exp(coef(logit.tv))




#3 챌린저호 사고

ch=read.csv("challenger.csv")
ch[,2]=factor(ch[,2])
summary(ch)          #TD변수 factor화

logit.ch=glm(TD~temp, family=binomial, data=ch)
logit.ch
summary(logit.ch)

pred.TD0=predict(logit.ch, data=ch, type="response")  #TD=1일 확률
pred.TD0

pred.TD1=1-pred.TD0      #TD=0일 확률
pred.TD1

ch[24,]=c(31,0)           #화씨31도일 때, TD=0일 확률
f31=ch[24,]
1-predict(logit.ch, f31, type="response")

ch[25,]=c(87.8,0)       #섭씨31도일 때, TD=0일 확률
c31=ch[25,]
1-predict(logit.ch, c31, type="response")