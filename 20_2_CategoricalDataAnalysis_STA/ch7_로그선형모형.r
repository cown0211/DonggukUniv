### ch7. 분할표 및 도수자료에 대한 로그 선형모형 ###

### 행복과 천국에 대한 믿음 ###
HappyHeaven = read.table("http://www.stat.ufl.edu/~aa/cat/data/HappyHeaven.dat", header=T)
HappyHeaven

fit = glm(count ~ happy+heaven, data = HappyHeaven, family = poisson)
summary(fit)

# lambda_1_x = 0; lambda_2_x = 1.18211; lambda_3_x = 0.52957; 
# happy는 no가 기준
# happy=no 대비 happy=pretty인 사람이 heaven=yes일 odds=exp(1.18)
# happy=no 대비 happy=very인 사람이 heaven=yes일 odds=exp(0.52)

# heaven=no 대비 heaven=yes일 odds는 각 행복 수준에서 exp(1.749)
# X와 Y는 독립이라는 가정 때문























### 2차원 분할표 포화모형 ###
HappyHeaven = read.table("http://www.stat.ufl.edu/~aa/cat/data/HappyHeaven.dat", header=T)
HappyHeaven

fit = glm(count ~ happy+heaven, data = HappyHeaven, family = poisson)
summary(fit)
# happy에 대해 no 대비 pretty // very의 odds
# heaven에 대해 no 대비 yes의 odds
# happy와 heaven이 독립이라는 가정 하의 모형임


# 포화 로그선형 모형
fit_f = glm(count ~ happy+heaven+happy:heaven, data = HappyHeaven, family = poisson)
summary(fit_f)
# happypretty:heavenyes; odds ratio
# residual deviance; 통계량0, 자유도0 => 모형이 적합함
# fit_f의 자유도는 6, resi_devi의 자유도0은 풀모형과의 차이가 0이라는 의미
# null deviance는 상수항 1개 쓰므로 자유도5














### 로그 선형 모형 ###
Drugs = read.table("http://www.stat.ufl.edu/~aa/cat/data/Substance.dat", header = T)
Drugs


A = Drugs$alcohol
C = Drugs$cigarettes
M = Drugs$marijuana


### 주효과만 있는 모형 ###
fit1 = glm(count~A+C+M, family = poisson, data=Drugs)

# 각 칸도수의 예측값
fitted(fit1) # 순서는 원래 데이터의 순서대로

# 원 데이터 칸도수와 비교
cbind(A, C, M, Drugs$count, fitted(fit1))




### ACM 모형 ###
fit2 = glm(count ~ A + C+ M + A:C + A:M + C:M + A:C:M, family = poisson, data = Drugs)
cbind(A, C, M, Drugs$count, fitted(fit2))
# 포화모형의 예측값은 원데이터와 완전 같음




### 동질적 연관성 모형 ###
fit3 = glm(count ~ A + C+ M + A:C + A:M + C:M, family = poisson, data = Drugs)
summary(fit3)
# 여기서 나오는 계수값(Ayes:Cyes ~ Cyes:Myes)은 조건부 로그 오즈비
# 각각에 exp() 취해주면 조건부 오즈비를 구할 수 있음

exp(summary(fit3)$coefficient[,1])
# A와 M에 대한 조건부 오즈비는 19.8
# C와 M에 대한 조건부 오즈비는 17.2
# A와 C에 대한 조건부 오즈비는 7.8

# 이탈도 통계량, 자유도, p값
res = summary(fit3)
cbind(res$deviance, res$df.residual, 1-pchisq(res$deviance, res$df.residual))

# cf) 포화모형의 이탈도 통계량, 자유도, p값
res = summary(fit2)
cbind(res$deviance, res$df.residual, 1-pchisq(res$deviance, res$df.residual))






### AM, CM 모형 ###
fit4 = glm(count ~ A + C+ M + A:M + C:M, family = poisson, data = Drugs)
dev_3 = deviance(fit3)
dev_4 = deviance(fit4)
1-pchisq(dev_4 - dev_3, 1)
# H0; 풀모형 대비 비교모형이 적합하다
# p값 매우 작으므로 H0 기각 -> AC 변수 필요함


# 위와 같이 포함모형 vs 비포함모형으로 비교분석하거나 
# 아래와 같이 포함된 모형 내부효과로 확인도 가능

library(car)
Anova(fit3)
# 이렇게 계산해도 AC 변수는 유의하다는 결과 얻을 수 있음



### 표준화잔차 ###
# 절대값이 2나 3 이상이면 문제 있다고 판단
residual = rstandard(fit4, type = "pearson")
data.frame(A, C, M, Drugs$count, fitted(fit4), residual)




### 오즈비에 대한 CI ###

confint(fit3)
# fit3의 계수에 대한 CI == 로그오즈비에 대한 CI

exp(confint(fit3))
# 오즈비에 대한 CI