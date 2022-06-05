### 로지스틱 회귀분석의 무한대 추정값 ###


x = c(10,20,30,40,60,70,80,90)
y = c(0,0,0,0,1,1,1,1)

fit = glm(y~x, family = binomial)
summary(fit)
# beta에 대한 추정값 2.363, se 5805....
# Null deviance와 Residual deviance 차이가 매우매우 적음
# wald 신뢰구간은 무한대까지 감 -> 유의성 검정 어떻게 해야 하는지?

library(car)
Anova(fit)
# LRT로 검정, x에 대한 p값 매우 작으므로 유의함

# CI
install.packages("profileModel"); library(profileModel)
confintModel(fit, objective = "ordinaryDeviance", method = "zoom")
# 일반적인 CI 구하는 함수로는 에러나서 안됨




### 자궁내막암 병기 ###
Endo = read.table("http://www.stat.ufl.edu/~aa/cat/data/Endometrial.dat", header = T)
Endo # HG가 y변수
xtabs(~NV+HG, data = Endo) # NV = 1이면 y = 1

fit = glm(HG ~ NV+PI+EH, family = binomial, data = Endo)
summary(fit)
# NV 변수의 se 1715..., p값도 매우 큼

Anova(fit)
# LRT로 검정하면 검정통계량 9.3576, p값 매우 작음

confintModel(fit, objective = "ordinaryDeviance", method = "zoom")
# NV 변수에 대한 CI





install.packages("brglm2"); library(brglm2)
install.packages("detectSeparation"); library(detectSeparation)
glm(HG ~ NV+PI+EH, family = binomial, data = Endo, method = "detectSeparation")
# 무한대면 Inf, 0으로 나오면 유한값을 갖는다는 의미

