Crabs = read.table("http://www.stat.ufl.edu/~aa/cat/data/Crabs.dat", header = T)


### color 변수에 대한 더미변수로 모델링 ###
fit = glm(y ~ width + factor(color), family = binomial, data = Crabs)
summary(fit)
# alpha = -11.385
# beta_hat = 0.467
# color는 2~4만 있음 => 1이 기준
# color 1보다 c2가 부수체 가질 오즈 큼
# but p값이 0.922 => 유의x
# c3,4의 경우도 p값이 너무 큼



### 어떤 항이 필요한가? (color 변수에 대해)###
# 위에서 모든 color 더미 변수의 p값이 0.1보다 큼
# color 제거하고 width만 가지고 모델

summary(glm(y ~ width, family = binomial, data = Crabs))

# width만 가지고 있는 모델의 Residual deviance = 194.45
# color 더미변수 가진 모델의 Residual deviance = 187.46
# 둘의 Residual deviance 값의 차이로 유의성 검정

library(car)
Anova(fit)

# factor(color)에 대한 LR Chisq 값이 6.9956 = 194.45 - 187.46
# Df = 3 = 171 - 168
# Anova()에서 귀무가설은 color 변수 필요없다 => beta1=beta2=beta3=0 => p값 = 0.07
# color 변수를 무시하기는 애매함 => 다른 방법 강구!





### 팩터화 하지 않고 수치형 그대로 사용(점수로 사용) ###
fit2 = glm(y ~ width + color, family = binomial, data = Crabs)
summary(fit2)

# color의 계수가 음수 => 점수가 커질수록(색이 어두워질수록) 부수체 가질 오즈가 감소
# p값 또한 유의하다고 나옴






### Anova()를 통해 color 변수를 사용하기로 함 ###
### 그런데 더미변수 사용 vs 수치형 사용 중 뭐가 더 나은지? ###

anova(fit2, fit, test = "LRT")
# 복잡한 모형 대비 심플 모형이 얼마나 잘 설명하는가?
# Model 1: 수치형
# Model 2: 팩터화(더미변수), 더 복잡한 모델
# 이탈도가 187.46 vs 189.12로 모델2가 조금 더 작음
# 이탈도가 크다 => 풀모형에 비해 설명 못함
# 이탈도가 작다 => 풀모형과 비슷하게 설명
# 두 모델의 이탈도 차이(=검정통계량) = 1.6641
# chisq 검정 통해서 p값 = 0.4351
# p값이 크다 => 검정통계량이 작다 => 차이가 적다 => 심플 모형이나 복잡 모형이나 별 차이 없다





### color 변수의 이항범주화(어둡 vs 어둡x) ###

Crabs$c4 = ifelse(Crabs$color == 4, 1, 0)
# c4; 어두우면 1, 어둡x면 0

fit3 = glm(y ~ width + c4, family = binomial, data = Crabs)
summary(fit3)
# c4 변수는 매우 유의함

anova(fit3, fit, test = "LRT")
# p값이 매우 큼 => 두 모델간 차이 거의 없음
# color 변수를 복잡하게 4범주로 가져갈 필요 없음
# 어두운 색깔(c4=1)만 부수체 가질 오즈 작음





### 교호작용 고려 ###
fit4 = glm(y ~ width + c4 + width:c4, family = binomial, data = Crabs)
# width:c4의 콜론 기호가 교호작용에 대한 기호

summary(fit4)
# p값이 0.26 매우 큼.. 
# 심지어 c4의 p값까지 매우 커짐
# 교호작용은 의미x




### 오즈비가 와닿지 않는다면 확률로 계산 ###
# c4(밝기)가 어느정도 영향을 주는가
predict(fit3, data.frame(c4 = 1, width = mean(Crabs$width)), type = "response")
# type = response; phi_hat에 대한 확률 값
# width는 평균이고, c4=1(어두운) 참게가 부수체 가질 확률 = 0.400


predict(fit3, data.frame(c4 = 0, width = mean(Crabs$width)), type = "response")
# c4=0(어둡x)가 가질 확률은 0.710




# width가 어느정도 영향을 주는가
predict(fit3, data.frame(c4 = mean(Crabs$c4), width = max(Crabs$width)), type = "response")
# width가 max인 경우는 확률이 0.98

predict(fit3, data.frame(c4 = mean(Crabs$c4), width = min(Crabs$width)), type = "response")
# width가 min인 경우는 0.14

predict(fit3, data.frame(c4 = mean(Crabs$c4), width = quantile(Crabs$width)), type = "response")
# 4분위 수로 계산
