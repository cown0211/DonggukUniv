### 마리화나 ###
Marijuana = read.table("https://www.stat.ufl.edu/~aa/cat/data/Marijuana.dat", header = T)

fit = glm(yes/(yes+no) ~ gender + race, weights = yes+no, family = "binomial", data = Marijuana)
# 분할표 형식에서는 weights를 지정해줘야 함

summary(fit)

# logit(phi_hat(x)) = -0.830 + 0.203x + 0.444z
# gendermale => male이 기준이 되어 male일 때 x=1, female일 때 x=0
# racewhite => white가 기준이 되어 race=white일 때 z=1, 나머지일 때 z=0
# 성별에 대한 조건부 오즈비 추정값 = exp(0.203)
# 인종에 대한 조건부 오즈비 추정값 = exp(0.444)



# 모형이 적합한가에 대한 검정 H0: beta1 = beta2 = 0
# beta1, beta2 둘 다 0이면 의미 성별, 인종은 영향 안준다는 의미

# Null deviance: 상수항만 있을 때의 이탈도 12.7527...
# Residual deviance: fit으로 얻어낸 식의 이탈도 0.057982...

# 이탈도0(Null) - 이탈도1(Resi) = 12.69
# df의 경우 인종(white or o.w.), 성별(m or f)의 2x2=4의 경우의 수에서
# Null deviance는 상수항 가지니 3
# Residual deviance는 3개 항 가지니 1
# 이 둘의 차이인 2
# chisq(df=2) 그래프에 12.69에 대한 p값 = 0.002



# 각 변수에 대한 검정 H0: beta1 = 0
# gendermale의 우측에 Estimate, Std.Error를 가지고 z-value 구하고
# z-value 가지고 만든 게 p-value ; wald method

install.packages("car")
library(car)

Anova(fit)
# 각 변수에 대한 유의성 검정(LRT)
# LR, df => p-value

