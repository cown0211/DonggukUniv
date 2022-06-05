Crabs = read.table("http://www.stat.ufl.edu/~aa/cat/data/Crabs.dat", header = T)




fit = glm(y ~ weight + width + factor(color) + factor(spine), family = binomial, data = Crabs)



### 다중공선성 문제 ###
summary(fit)
# 모형의 적합성; Null deviance(상수모형) vs Residual deviance(풀모형)

1-pchisq(225.76-185.20, 172-165)
# H0:beta1=beta2=...=0에 대한 p값, 매우 유의하므로 기각
# 어떤 변수이든 변수를 사용해서 모델을 만드는 게 합리적이다
# 하지만 summary(fit)에서 각 변수에 대한 p값은 전혀 유의하지 않음 => 다중공선성 문제 고려


cor(Crabs$weight, Crabs$width)
# weight와 width 변수 간에 강한 상관관계가 발견됨
# -> 둘 중 하나만 채택






### 변수채택 ###

# color 변수에 대한 유의성 검정
fit_c = glm(y ~ factor(color), family = binomial, data = Crabs)
summary(fit_c)
# Null deviance vs Residual deviance로 검정


# spine 변수에 대한 유의성 검정
fit_s = glm(y ~ factor(spine), family = binomial, data = Crabs)
summary(fit_s)


# 교호작용에 대한 유의성 검정
fit_x = glm(y ~ factor(color) + width + width:factor(color), family = binomial, data = Crabs)
summary(fit_x)






### 최종 모형 width, color에 대한 AIC ###

fit = glm(y ~ width + factor(color), family = binomial, data = Crabs)

# summary 함수
summary(fit)

# AIC함수
AIC(fit)

# BIC
BIC(fit)

# AIC 직접 계산
-2*logLik(fit) + 2*5 # p=5






### 풀모형으로부터 backward 변수 채택 ###

fit = glm(y ~ weight + width + factor(color) + factor(spine), family = binomial, data = Crabs)
library(MASS)
stepAIC(fit)
# 위와 같은 방식으로 채택하면 width, color만 채택하고 그때의 AIC = 197.46




### bestglm 패키지 활용 ###
install.packages("bestglm"); library(bestglm)
attach(Crabs)


### 201111 보강 ###
# 교재에는 아래처럼 수치형으로 넣어버림
Crabs2 = data.frame(weight, width, color, spine, y)
bestglm(Crabs2, family = binomial, IC = "AIC")
bestglm(Crabs2, family = binomial, IC = "BIC")

# 팩터화하여 다시 계산
Crabs3 = data.frame(weight, width, factor(color), factor(spine), y)
result = bestglm(Crabs3, family = binomial, IC = "AIC); result
result$BestModel$coefficients # 계수 추정값만 확인

