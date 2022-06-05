### 심장병 발생확률 ###
heart = read.table("http://www.stat.ufl.edu/~aa/cat/data/Heart.dat", header=T)
heart


# 범주형 자료에 점수부여
library(dplyr)
heart$x = recode(heart$snoring, never=0, occasional=2, nearly_every_night=4, every_night=5)
n = heart$yes + heart$no


# logit 모형에 적합, 로지스틱 회귀모형
fit = glm(yes/n ~ x, family = binomial(link = logit), weight = n, data = heart)
summary(fit)
# family를 binomial로 하면 link는 자동적으로 logit으로 설정, 해당 부분 제거해도 값은 같음

fitted(fit)
# 차례대로 x의 수준과 해당 수준에서의 심장병 발병 확률을 나타냄(never, occasional, ...)



# probit 적합
fit2 = glm(yes/n ~ x, family = binomial(link = probit), weight = n, data = heart)
summary(fit2)

fitted(fit2)



# 선형확률모형 적합
fit3 = glm(yes/n ~ x, family = quasi(link = identity, variance = "mu(1-mu)"), weight = n, data = heart)
summary(fit3)

fitted(fit3)
