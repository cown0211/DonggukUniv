### 진화론과 정치성향 ###
Evo = read.table("https://www.stat.ufl.edu/~aa/cat/data/Evolution.dat", header = T)
Evo
n = Evo$true + Evo$false

# H0: beta==0에 대한
# 왈드검정
fit = glm(true/n ~ ideology, family = binomial(link = logit), weights = n, data = Evo)
# (link = logit)은 생략 가능
summary(fit)
# logit(phi(x)) = -1.75658 + 0.49422x
# 왈드검정값, 0.49422 / se(=0.05092) => z값 = 9.706
# 9.706^2 ~ chisq
# p값이 매우 작으므로 유의함 => H0: beta==0 기각 => 정치성향이 진화론 찬성 비율에 영향을 준다


# Likelihood Ratio Test, 가능도비검정
drop1(fit, test = "LRT") 
# LRT값 = 109.48 ~ chisq
# <none>의 Deviance 113.20 => 상수만 고려한(x 고려 안한) null 모델의 이탈도
# 포화모형의 자유도 7, <none>의 자유도 1 => 자유도 차이 6
# ideology의 Deviance 3.72 => ideology 변수 모델의 이탈도
# 포화모형 자유도 7, alpha와 beta 자유도 2개 빠져서 총 자유도 5
# Deviance가 클수록 포화모델과의 차이가 큼 => 설명 잘 못함
# 작을수록 차이 적음 => 설명 굳
# 여기서의 Deviance(이탈도)는 포화모델과의 차이

# <none>에서의 p값, 매우 큼
1-pchisq(3.72, 5)

# 두 모형에서의 이탈도 차이는 LRT 값
# 113.20 - 3.72 = 109.48
# 포화모델과의 비교가 아닌 두 모델 간의 비교
# null deviance 모델은 alpha만 사용, residual deviance 모델은 alpha + beta
# 두 모델간의 비교는 곧 beta == 0에 대한 검정
# ~ chisq(6-5)

# profile likelihood CI
confint(fit)



# 잔차 계산
attach(Evo)
pearson_r = rstandard(fit, type = "deviance") # 피어슨 잔차
standard_r = rstandard(fit, type = "pearson") # 표준화 잔차
# 믿음의 수준, 실제값, 예측값, 피어슨잔차, 표준화잔차
cbind(ideology, true/n, fitted(fit), pearson_r, standard_r)
# 모든 수준에서 표준화잔차는 2나 3을 넘지 않음
