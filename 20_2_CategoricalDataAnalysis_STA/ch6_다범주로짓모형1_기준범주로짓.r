### 다범주 로짓 모형 ###
Gators = read.table("http://www.stat.ufl.edu/~aa/cat/data/Alligators.dat", header = T)
head(Gators) # x~체장; y~먹이종류



install.packages("VGAM"); library(VGAM)
 


fit = vglm(y ~ x, family = multinomial, data = Gators) 
summary(fit)
# 기준 범주는 3번째 범주(알파벳 순서로 F, I, O)
# 해석은 3(O)을 기준으로 1(F)의 효과, 3을 기준으로 2(I)의 효과; Names of linear predictors

coef(fit, matrix = T)
# 위의 fit 모형을 matrix 형태로 반환
# 1열이 3대비 1효과; 2열이 3대비 2효과






### 기준범주 지정 ###
fit2 = vglm(y ~ x, family = multinomial(refLevel="I"), data = Gators)
summary(fit2)
# I를 기준범주로 잡음
# 1은 I 대비 F의 효과; 2는 I 대비 O의 효과
# 길이가 한 단위 증가할 때마다 I(연체류) 대비 F(어류)를 선호할 오즈의 추정값은 exp(2.3553)배 증가





### 추정값에 대한 CI ###
confint(fit2, method = "wald") # pearson or profile은 오류...
# x:1 // "I" 대비 "F"의 효과
# 연체류 대비 어류 선호할 오즈가 최소 exp(0.78)배에서 최대 exp(3.92)배 사이에 있을 것으로 95% 확신한다






### 각 악어 별로 선호하는 먹이에 대한 확률 ###
fitted(fit)

# 시각화
plot(Gators$x, fitted(fit)[,1], type = "l", ylim = c(0,1), col = "red") #어류
lines(Gators$x, fitted(fit)[,2], type = "l", col = "blue") # 연체류
lines(Gators$x, fitted(fit)[,3], type = "l", col = "green") # 기타





### 몸길이가 먹이 선호에 영향을 주는지 검정 ###
# H0:beta1 = 0
fit0 = vglm(y ~ 1, family = multinomial, data = Gators)
# 몸길이 고려x인 모형



# 상수만 고려한 fit0와 그렇지 않은 fit 모형으로 LRT
lrtest(fit, fit0)
# LogLik 값에 -2 곱해주면 Deviance
# ex) -49.171 * (-2) = 98.3412; Residual deviance
# 2(L0 - L1) = 2(-49.171 - (-57.571)) = 16.801; Chisq
# p값 매우 유의하므로 귀무가설 기각













### 사후세계에 대한 믿음 ###
Afterlife = read.table("http://www.stat.ufl.edu/~aa/cat/data/Afterlife.dat", header = T)

Afterlife
# table에서는 yes, undecided, no가 각각의 칼럼이지만
# 이는 사후세계에 대한 믿음 여부에 대한 결과이므로 하나의 변수로 봐야 함~cbind


fit = vglm(cbind(yes, undecided, no) ~ gender + race, family = multinomial, data = Afterlife)
summary(fit)
# 변수의 기준은 female,black
# 반응변수의 기준은 no

# gendermale:1 기준
# 인종이 고정돼있을 때, 여성 대비 남성이 아니오 대비 예라고 대답할 오즈가 exp(-0.41)배 감소

# racewhite:1 기준
# 성별이 고정돼있을 때, 흑인 대비 백인이 아니오 대비 예라고 대답할 오즈가 exp(0.3418)배 증가





# p값을 보면 race는 두 변수 모두 크지만, gender는 반반임 => 반쪽짜리만 채택? => x
# 하나의 변수로 묶어야 함 using LRT
# 변수의 유의성 검정

# race만 사용한 모델
fit.race = vglm(cbind(yes, undecided, no) ~ race, family = multinomial, data = Afterlife)
# gender만 사용한 모델
fit.gender = vglm(cbind(yes, undecided, no) ~ gender, family = multinomial, data = Afterlife)


# 성별 효과 검정
lrtest(fit, fit.race)
# H0: beta_gender = 0
# 귀무가설 기각 => 성별에 따른 효과가 있다


# 인종 효과 검정
lrtest(fit, fit.gender)
# H0: beta_race = 0
# 귀무가설 채택 => 인종에 따른 차이는 없다




# lrtest를 anova 함수로도 사용할 수 있음
anova(fit.gender, fit, type = "I", test = "LRT")

# CI for beta, 해석하려면 exp 취해야함
confint(fit, method = "profile")























### 다범주 로짓 모형 ###
Gators = read.table("http://www.stat.ufl.edu/~aa/cat/data/Alligators.dat", header = T)
head(Gators) # x~체장; y~먹이종류



install.packages("VGAM"); library(VGAM)
 


fit = vglm(y ~ x, family = multinomial, data = Gators) 
summary(fit)
# 기준 범주는 3번째 범주(알파벳 순서로 F, I, O)
# 해석은 3(O)을 기준으로 1(F)의 효과, 3을 기준으로 2(I)의 효과; Names of linear predictors

coef(fit, matrix = T)
# 위의 fit 모형을 matrix 형태로 반환
# 1열이 3대비 1효과; 2열이 3대비 2효과






### 기준범주 지정 ###
fit2 = vglm(y ~ x, family = multinomial(refLevel="I"), data = Gators)
summary(fit2)
# I를 기준범주로 잡음
# 1은 I 대비 F의 효과; 2는 I 대비 O의 효과
# 길이가 한 단위 증가할 때마다 I(연체류) 대비 F(어류)를 선호할 오즈의 추정값은 exp(2.3553)배 증가





### 추정값에 대한 CI ###
confint(fit2, method = "wald") # pearson or profile은 오류...
# x:1 // "I" 대비 "F"의 효과
# 연체류 대비 어류 선호할 오즈가 최소 exp(0.78)배에서 최대 exp(3.92)배 사이에 있을 것으로 95% 확신한다






### 각 악어 별로 선호하는 먹이에 대한 확률 ###
fitted(fit)

# 시각화
plot(Gators$x, fitted(fit)[,1], type = "l", ylim = c(0,1), col = "red") #어류
lines(Gators$x, fitted(fit)[,2], type = "l", col = "blue") # 연체류
lines(Gators$x, fitted(fit)[,3], type = "l", col = "green") # 기타





### 몸길이가 먹이 선호에 영향을 주는지 검정 ###
# H0:beta1 = 0
fit0 = vglm(y ~ 1, family = multinomial, data = Gators)
# 몸길이 고려x인 모형



# 상수만 고려한 fit0와 그렇지 않은 fit 모형으로 LRT
lrtest(fit, fit0)
# LogLik 값에 -2 곱해주면 Deviance
# ex) -49.171 * (-2) = 98.3412; Residual deviance
# 2(L0 - L1) = 2(-49.171 - (-57.571)) = 16.801; Chisq
# p값 매우 유의하므로 귀무가설 기각













### 사후세계에 대한 믿음 ###
Afterlife = read.table("http://www.stat.ufl.edu/~aa/cat/data/Afterlife.dat", header = T)

Afterlife
# table에서는 yes, undecided, no가 각각의 칼럼이지만
# 이는 사후세계에 대한 믿음 여부에 대한 결과이므로 하나의 변수로 봐야 함~cbind


fit = vglm(cbind(yes, undecided, no) ~ gender + race, family = multinomial, data = Afterlife)
summary(fit)
# 변수의 기준은 female,black
# 반응변수의 기준은 no

# gendermale:1 기준
# 인종이 고정돼있을 때, 여성 대비 남성이 아니오 대비 예라고 대답할 오즈가 exp(-0.41)배 감소

# racewhite:1 기준
# 성별이 고정돼있을 때, 흑인 대비 백인이 아니오 대비 예라고 대답할 오즈가 exp(0.3418)배 증가





# p값을 보면 race는 두 변수 모두 크지만, gender는 반반임 => 반쪽짜리만 채택? => x
# 하나의 변수로 묶어야 함 using LRT
# 변수의 유의성 검정

# race만 사용한 모델
fit.race = vglm(cbind(yes, undecided, no) ~ race, family = multinomial, data = Afterlife)
# gender만 사용한 모델
fit.gender = vglm(cbind(yes, undecided, no) ~ gender, family = multinomial, data = Afterlife)


# 성별 효과 검정
lrtest(fit, fit.race)
# H0: beta_gender = 0
# 귀무가설 기각 => 성별에 따른 효과가 있다


# 인종 효과 검정
lrtest(fit, fit.gender)
# H0: beta_race = 0
# 귀무가설 채택 => 인종에 따른 차이는 없다




# lrtest를 anova 함수로도 사용할 수 있음
anova(fit.gender, fit, type = "I", test = "LRT")

# CI for beta, 해석하려면 exp 취해야함
confint(fit, method = "profile")
