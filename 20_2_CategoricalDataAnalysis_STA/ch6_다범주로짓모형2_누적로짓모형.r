### 총 가구 수입과 행복도 ###
Happy = read.table("http://www.stat.ufl.edu/~aa/cat/data/Happy.dat", header=T)
Happy # y1보다 y2가 더 행복, y2보다 y3가 더 행복


fit = vglm(cbind(y1, y2, y3) ~ income, family = cumulative(parallel = T), data = Happy)
# y1~y3는 하나의 y로 묶어줌(cbind); income은 양적의미 그대로 사용
# family는 누적(parallel은 비례오즈 여부)

summary(fit)
# (intercept):1; 행복한 사람(y2,y3) 대비 행복x(y1)
# (intercept):2; 아주 행복(y3) 대비 낮은 행복(y1,y2)
# income은 1,2,3 그대로 양적 의미로 사용
# 수입이 한 단위 증가할수록 행복하지 않을 오즈가 다른 범주 대비 exp(-0.2668)배 감소





### 수입에 대한 유의성 검정 ###
fit0 = vglm(cbind(y1, y2, y3) ~ 1, family = cumulative(parallel = T), data = Happy)
# 상수항 표현식은 ~ 1
summary(fit0)

lrtest(fit,fit0)
# 검정통계량 3.109~Chisq(df=1)
# p값은 0.07






### income 변수를 factor화 ###
fit2 = vglm(cbind(y1, y2, y3) ~ factor(income), family = cumulative, data = Happy)
# parallel x
summary(fit2)
# factor(income)2 -> income 1 대비 income 2
# factor(income)3 -> income 1 대비 income 3

# factor(income)2:1 -> 행복한 사람(y2,y3) 대비 행복x(y1)
# factor(income)2:2 -> 아주 행복(y3) 대비 낮은 행복(y1,y2)


lrtest(fit2,fit0)
# income을 factor로 보니 H0 채택...


# income을 1,2,3 숫자로 그대로 넣으면 df=1, H0 기각
# income을 factor화 하면 df=4, H0 채택
# => 자유도가 낮을수록 검정력 증가

# income이라는 변수가 선형성이 있다는 가정을 하면 수치형 그대로 사용 -> 유의한 변수
# 그렇지 않다면 factor로 사용 -> 무의미한 변수






















### 정치 성향과 정당 가입의 관련성 ###

Polviews = read.table("http://www.stat.ufl.edu/~aa/cat/data/Polviews.dat", header=T)
Polviews # y1~y5 -> 매우진보~매우보수

library(VGAM)
fit = vglm(cbind(y1, y2, y3, y4, y5) ~ party + gender, data = Polviews, family = cumulative(parallel=T))
# parallel = T; 비례오즈 모형 사용

summary(fit)
# Intercept:1 => logitlink(P[Y<=1])
# Y가 1보다 작을 확률 / 1-(Y가 1보다 작을 확률)
# Intercept는 1부터 4까지 모두 다름; alpha_hat
# party, gender는 모두 같음; beta_hat
# Y에 대한 누적값에 따라 Intercept는 모두 다르지만 beta_hat은 같음



### y5~y1으로 순서를 반대로 한다면? ###
fit1 = vglm(cbind(y5, y4, y3, y2, y1) ~ party + gender, data = Polviews, family = cumulative(parallel=T))
summary(fit2)
# 부호가 뒤집어진 상태; 해석은 똑같음




# x1(gender)과 x2(party)가 주어졌을 때, y(정치성향)에 대한 예측값
attach(Polviews)
data.frame(gender, party, fitted(fit))
# party에 따라 y 값의 비중이 달라짐
# gender에 따라서는 fitted 값이 크게 다르진 않아 보이지만 검정 필요



### gender에 대한 검정 ###
fit2 = vglm(cbind(y1, y2, y3, y4, y5) ~ party, data = Polviews, family = cumulative(parallel=T))
lrtest(fit, fit2) # gender 변수 제외한 모델과 비교
# H0: 복잡모형 대비 심플모형도 적합 or H0: beta2 = 0
# p = 0.7522; H0 채택; 심플모형도 적함; gender 빼도 충분



### party에 대한 검정 ###
fit3 = vglm(cbind(y1, y2, y3, y4, y5) ~ gender, data = Polviews, family = cumulative(parallel=T))
lrtest(fit, fit3)
# H0: party 변수는 유의하지 않다
# p값 매우 작음; H0 기각; party 변수 필요




### CI ###
confint(fit, method = "profile")
# Intercept는 노상관

# gender에 대해 -0.24 ~ 0.34 -> 신뢰구간에 0을 포함하므로 beta 계수 = 0이라 볼 수도 있음
# 신뢰구간이 음수와 양수를 모두 포함하여 방향성 없음
