# ridge, lasso

# 패키지 설치및불러오기

install.packages('glmnet'); library(glmnet)
install.packages('lasso2'); library(lasso2)
install.packages('pastecs'); library(pastecs)


data(Prostate); Prostate   # lpsa가 타겟
p = Prostate
cor(p)
set.seed(12)


# Df; 자유도, %Dev; 분산(모델의 설명 정도), Lambda; 값이 클수록 모델이 단순
# 따라서 첫 행은 'y = 상수'인 모델(자유도 0, 설명력(분산) 0)
# alpha 기본값은 1 -> lasso
fit = glmnet(as.matrix(p[,-9]), p[,9]); fit
# 시각화
plot(fit, label = T)
# 각 곡선은 변수를 의미
# 상단의 숫자는 자유도



# cross validation
Prostate.cv = cv.glmnet(as.matrix(p[,-9]), p[,9]); Prostate.cv
plot(Prostate.cv)
# x축은 log(lambda) 값, 상단은 채택된 변수
# 빨간 점은 주어진 lambda에 대해 k 개의 교차검증의 평균값(위아래는 오차범위)
# 좌로 갈수록 복잡, 우로 갈수록 간단
# 최적의 lambda? lambda.min or lambda.1se
Prostate.cv$lambda.min # cv 오차의 평균값을 최소화 하는 값
Prostate.cv$lambda.1se # cv 오차의 평균값이 최소값으로부터 1-se 이상 떨어지지 않은 값
# 위 두 값에 log 취하면 plot의 점선에서의 x 값과 같다


# 각 방식대로 선택된 변수의 계수의 모수값
coef(Prostate.cv, s = 'lambda.1se')
coef(Prostate.cv, s = 'lambda.min')




predict(Prostate.cv, as.matrix(Prostate[,-9], s = 'lambda.min'))


# lambda 값을 min~1se 값을 하한,상한으로 두어 5개로 나누어 대입
grid = with(Prostate.cv, seq(lambda.min, lambda.1se, length.out = 5)); grid
Prostate.lasso = glmnet(as.matrix(Prostate[,-9]), Prostate[,9], alpha = 1, lambda = grid); Prostate.lasso

lasso.fitted.value = predict(Prostate.lasso, newx = as.matrix(Prostate[,-9])); lasso.fitted.value


# Rsq
1 - colSums((Prostate$lpsa - lasso.fitted.value)^2) / sum((Prostate$lpsa - mean(Prostate$lpsa))^2)
# RMSE
sqrt(colMeans((Prostate$lpsa - lasso.fitted.value)^2))







# glmnet에서 alpha = 0이면 ridge
Prostate.cv.ridge = cv.glmnet(as.matrix(p[,-9]), p[,9], alpha = 0); Prostate.cv.ridge
plot(Prostate.cv.ridge)

# ridge 방식에서의 lambda 값
Prostate.cv.ridge$lambda.min
Prostate.cv.ridge$lambda.1se

# ridge 방식에서 선택된 계수 모수값
coef(Prostate.cv.ridge, s = 'lambda.min')
coef(Prostate.cv.ridge, s = 'lambda.1se')

# 예측
predict(Prostate.cv.ridge, as.matrix(Prostate[,-9], s = 'lambda.min'))




grid = with(Prostate.cv.ridge, seq(lambda.min, lambda.1se, length.out = 5)); grid
Prostate.ridge = glmnet(as.matrix(Prostate[,-9]), Prostate[,9], alpha = 0, lambda = grid); Prostate.ridge



ridge.fitted.value = predict(Prostate.ridge, newx = as.matrix(Prostate[,-9]))


# Rsq
1 - colSums((Prostate$lpsa - ridge.fitted.value)^2) / sum((Prostate$lpsa - mean(Prostate$lpsa))^2)
# RMSE
sqrt(colMeans((Prostate$lpsa - ridge.fitted.value)^2)) #RMSE값 실제값-예측값
