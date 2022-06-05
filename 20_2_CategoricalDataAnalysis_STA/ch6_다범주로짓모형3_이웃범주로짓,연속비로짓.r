### 이웃범주 로짓 ###
fit_acat = vglm(cbind(y1, y2, y3, y4, y5) ~ party + gender, data = Polviews, family = acat(parallel=T, reverse=T))
# family = acat
# parallel=T; 범주간 간격 같음
# reverse=T; 큰 범주가 분모로, 작은 범주가 분자로; phi_1/phi_2 ... phi_4/phi_5
# reverse=F라면 위의 반대, 이 예제에서는 T로 놔야 순서가 맞음

summary(fit_acat)
# party 계수가 음수인 것으로 보아 방향성은 이전과 같음
# reverse=T; loglink(P[Y=1]/P[Y=2])























### Score Test for the Proportional Odds Assumption ###

Polviews = read.table("http://www.stat.ufl.edu/~aa/cat/data/Polviews.dat", header=T)

library(VGAM)
fit = vglm(cbind(y1, y2, y3, y4, y5) ~ party + gender, data = Polviews, family = cumulative(parallel=T))

fit_gender = vglm(cbind(y1, y2, y3, y4, y5) ~ gender, data = Polviews, family = cumulative(parallel=T))

# 여기까지는 하나의 beta_hat을 가지는 모형




# fit_each는 j가 각각의 beta_hat을 가지는 모형
# parallel = F
fit_each = vglm(cbind(y1, y2, y3, y4, y5) ~ party + gender, data = Polviews, family = cumulative(parallel=F))
summary(fit_each)
# 1까지 누적, 2까지 누적, ..., 4까지 누적, 5까지 누적 == 1이기 때문에 5는 없음



lrtest(fit_each, fit) # 유의성 검정
# df_fit_each = 12, df_fit = 6 => df = 6
# H0; 비례오즈가정의 모형이 적합 => p값 크므로 채택 => 비례오즈모형 채택
# if 기각이 됐다면 each 모형 채택 but 그럴 바엔 그냥 기준범주 쓰지 이렇게 안함





### 순차로짓(연속비로짓) ###

# 편도선 예제
carrier = c("yes","no")
y1 = c(19,497)
y2 = c(29,560)
y3 = c(24,269)

fit = vglm(cbind(y1, y2, y3) ~ carrier, family = sratio(parallel = T))
# family = sratio

summary(fit)
# 하나의 범주를 기준으로 그것 이상의 범주의 비율 => 1 / (2+3) or 2 / 3
# 보균자(carrier = yes(1))는 비보균자(0)보다 붓지 않을(phi_1) 오즈가 부을(phi_2+phi_3) 오즈보다 exp(-0.528)배(=0.59배) 낮다
# intercept:1 -> 1 / (2+3)의 alpha_hat




















### 독극물 예제 ###

Toxicity = read.table("http://www.stat.ufl.edu/~aa/cat/data/Toxicity.dat", header=T)

library(VGAM)
Toxicity


fit = vglm(cbind(dead, malformation, normal) ~ concentration, data = Toxicity, family = sratio(parallel=F))
summary(fit)


### 모형의 적합도 ###
# concentration 추정값이 매우 작게 나오지만 x가 연속값인 점, 단위를 고려해야 하는 점을 생각해야 함
# p 값도 매우 유의하다고 나옴
# 사망vs기형vs정상 모델의 Residual deviance(Gsq) = 11.8384

fit0 = vglm(cbind(dead, malformation+normal) ~ concentration, data = Toxicity, family = sratio(parallel=F))
summary(fit0) # 사망 vs생존의 residual deviance(Gsq) = 5.7775

fit1 = vglm(cbind(malformation, normal) ~ concentration, data = Toxicity, family = sratio(parallel=F))
summary(fit1) # 생존했다는 조건 하에 기형vs정상의 residual deviance(Gsq) = 6.0609
 

# Gsq_fit = Gsq_fit0 + Gsq_fit1





# 보균자(carrier = yes(1))는 비보균자(0)보다 조금 부을(phi_2) 오즈가 많이 부을(phi_3) 오즈보다 exp(-0.528)배(=0.59배) 낮다
# intercept:2 -> 2 / 3의 alpha_hat

# logitlink(P[Y=1|Y>=1]) => 1 / (2+3)
# logitlink(P[Y=2|Y>=2]) => 2 / 3




# 모형의 적합성 검정
# 각각의 칸도수가 충분히 큼

# summary()의 Residual deviance로 p값 계산해보면
1-pchisq(0.0057,1) # 매우 큼 -> 모형 적합함 
