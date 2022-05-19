
boston = read.csv('BostonHousing2.csv', header = T)
summary(boston)



### outlier ###

# rm < 6.5이고, medv = 50인 경우를 아웃라이어로 정의하고 제거하고자 함
plot(medv ~ rm, data = boston)


#아웃라이어 정의
outlier = c(which(boston$rm < 6.5 & boston$medv == 50))
outlier # 아웃라이어의 행번호

# 아웃라이어에 해당하는 경우를 빨간색으로 칠함
points(boston[outlier,]$rm, boston[outlier,]$medv, pch=16, col='red')

# 아웃라이어에 해당하는 인덱스만 뽑음
boston[outlier,]

# 아웃라이어 제거
bostonout = boston[-outlier,]






### train, test 분할 ###

set.seed(97)
sample.no = sample(1:nrow(bostonout), nrow(bostonout) * 0.8)

bostonout.train = bostonout[sample.no,]
bostonout.test = bostonout[-sample.no,]
# 8:2 비율로 train, test 분할


# 회귀모형 적합
fit.Case1 = lm(medv ~ ., data = bostonout.train)
summary(fit.Case1)


# train data의 RMSE
sqrt(mean((fit.Case1$residuals)^2))

# Case1의 test data residual
res.Case1 = bostonout.test$medv - predict(fit.Case1, newdata = bostonout.test)

# Rsq
1 - sum(res.Case1)^2 / sum((bostonout.test$medv - mean(bostonout.test$medv))^2)

# test data의 RMSE
sqrt(mean(res.Case1^2))














### 변수 log 변환 ###

# 타겟인 medv와 corr 높은 3개만 추림
cor(boston)

# 타겟인 medv를 log로 변환
fit3.var = lm(log(medv) ~ lstat + rm + ptratio, data = bostonout.train)
summary(fit3.var)


# train data로 구한 Rsq와 RMSE
# 종속변수인 medv를 자연로그로 변환했기 때문에 Rsq와 RMSE는 다시 지수 취한 후 계산
# Rsq
1 - sum((bostonout.train$medv - exp(fit3.var$fitted.values))^2) / 
sum((bostonout.train$medv - mean(bostonout.train$medv))^2)
# RMSE
sqrt(mean((exp(fit3.var$fitted.values) - bostonout.train$medv)^2))



# test data로 구한 Rsq와 RMSE
# Rsq
1 - sum((bostonout.test$medv - exp(predict(fit3.var, newdata = bostonout.test)))^2) / 
sum((bostonout.test$medv - mean(bostonout.test$medv))^2 )
# RMSE
sqrt(mean((bostonout.test$medv - exp(predict(fit3.var, newdata = bostonout.test)))^2))
# AIC
AIC(fit3.var)

 







### RAD 범주화 ###

bostoncat = bostonout
str(bostoncat) # rad 변수는 숫자 형태로 입력돼있음
bostoncat$rad = as.factor(bostoncat$rad)
str(bostoncat) # factor로 변환



set.seed(32)
sample.no = sample(1:nrow(bostoncat), nrow(bostoncat) * 0.8)
bostoncat.train = bostoncat[sample.no,]
bostoncat.test = bostoncat[-sample.no,]
head(bostoncat)


# rm^2를 안하면 그냥 rm변수로만 계산, rm^2를 별개의 변수로 보려면 I()를 입혀줘야 함
fit.Cat = lm(log(medv) ~ . + I(rm^2) + I(nox^2) + log(lstat) + log(dis) - rm - nox - lstat - dis, data = bostoncat.train)
summary(fit.Cat)




# train에서 Rsq, RMSE
# Rsq
1 - sum((bostoncat.train$medv - exp(fit.Cat$fitted.values))^2) / 
sum((bostoncat.train$medv - mean(bostoncat.train$medv))^2)
# RMSE
sqrt(mean((exp(fit.Cat$fitted.values) - bostoncat.train$medv)^2 ))











### OLS, Stepwise, Ridge, Lasso 모형 비교 ###
# Ridge, Lasso를 하기 위해 범주형 변수(rad)를 binary로 변환
rad2 = ifelse(bostoncat$rad == 2, 1, 0)
rad3 = ifelse(bostoncat$rad == 3, 1, 0)
rad4 = ifelse(bostoncat$rad == 4, 1, 0)
rad5 = ifelse(bostoncat$rad == 5, 1, 0)
rad6 = ifelse(bostoncat$rad == 6, 1, 0)
rad7 = ifelse(bostoncat$rad == 7, 1, 0)
rad8 = ifelse(bostoncat$rad == 8, 1, 0)
rad24 = ifelse(bostoncat$rad == 24, 1, 0)
bostontrans  = cbind(bostonout, rad2, rad3, rad4, rad5, rad6, rad7, rad8, rad24); head(bostontrans)




# 변수 변환; rm^2, nox^2, ln(lstat), ln(dis)
bostontrans = with(bostontrans, cbind(bostontrans, rm2 = rm^2, nox2 = nox^2, llstat = log(lstat), ldis = log(dis)))
head(bostontrans)
str(bostontrans)

# set.seed(32)의 sample.no 그대로 사용
bostontrans.train = bostontrans[sample.no,]
bostontrans.test = bostontrans[-sample.no,]






## OLS
# rad는 binary로 변환했으므로 회귀식에서 rad는 제외

fit.Trans = lm(log(medv) ~ . - rm - rad - nox - lstat - dis , data = bostontrans.train)
summary(fit.Trans)

# train의 Rsq와 RMSE 계산
# Rsq
1 - sum((bostontrans.train$medv - exp(fit.Trans$fitted.values))^2) / 
sum((bostontrans.train$medv - mean(bostontrans.train$medv))^2)
# RMSE
sqrt(mean((exp(fit.Trans$fitted.values) - bostontrans.train$medv)^2))



# test Rsq, RMSE
# Rsq
1 - sum((bostontrans.test$medv - exp(predict(fit.Trans, newdata = bostontrans.test)))^2) / 
sum((bostontrans.test$medv - mean(bostontrans.test$medv))^2)
# RMSE
sqrt(mean((exp(predict(fit.Trans, newdata = bostontrans.test)) - bostontrans.test$medv)^2))








## Stepwise
fit.step = step(fit.Trans, direction = "both")
summary(fit.step)

# 훈련집합의 R squared와 RMSE 계산
# Rsq
1 - sum((bostontrans.train$medv - exp(fit.step$fitted.values))^2) / 
sum((bostontrans.train$medv - mean(bostontrans.train$medv))^2)
# RMSE
sqrt(mean((exp(fit.step$fitted.values) - bostontrans.train$medv)^2 ))

# test Rsq, RMSE
# Rsq
1 - sum((bostontrans.test$medv - exp(predict(fit.step, newdata = bostontrans.test)))^2) / 
sum((bostontrans.test$medv - mean(bostontrans.test$medv))^2)
# RMSE
sqrt(mean((exp(predict(fit.step, newdata = bostontrans.test)) - bostontrans.test$medv)^2))






## Ridge
library(glmnet)
fit.ridge = glmnet(as.matrix(bostontrans.train[,-14]), log(bostontrans.train$medv), alpha = 0)
plot(fit.ridge, xvar= "lambda", label = T)
set.seed(1234)
fit.cv.ridge = cv.glmnet(as.matrix(bostontrans.train[,-14]), log(bostontrans.train$medv), alpha = 0)
plot(fit.cv.ridge)

grid = seq(fit.cv.ridge$lambda.min, fit.cv.ridge$lambda.1se, length.out = 5)
fit.ridge = glmnet(as.matrix(bostontrans.train[,-14]), log(bostontrans.train$medv), alpha = 0, lambda = grid)
head(fit.ridge)

# 훈련집합의 R squared와 RMSE 계산
ridge.fitted.value = predict(fit.ridge, newx = as.matrix(bostontrans.train[,-14]))
# Rsq
1 - colSums((bostontrans.train$medv - exp(ridge.fitted.value))^2) / 
sum((bostontrans.train$medv - mean(bostontrans.train$medv))^2)
# RMSE
sqrt(colMeans((exp(ridge.fitted.value) - bostontrans.train$medv)^2))

# test Rsq, RMSE
ridge.fitted.value = predict(fit.ridge, newx = as.matrix(bostontrans.test[,-14]))
# Rsq
1 - colSums((bostontrans.test$medv - exp(ridge.fitted.value))^2) / 
sum((bostontrans.test$medv - mean(bostontrans.test$medv))^2)
# RMSE
sqrt(colMeans((exp(ridge.fitted.value) - bostontrans.test$medv)^2))




## Lasso
fit.lasso = glmnet(as.matrix(bostontrans.train[,-14]), log(bostontrans.train$medv), alpha = 1)
plot(fit.lasso, xvar= "lambda", label = T)
set.seed(1234)
fit.cv.lasso = cv.glmnet(as.matrix(bostontrans.train[,-14]), log(bostontrans.train$medv), alpha = 1)
plot(fit.cv.lasso)

grid = seq(fit.cv.lasso$lambda.min, fit.cv.lasso$lambda.1se, length.out = 5)
fit.lasso = glmnet(as.matrix(bostontrans.train[,-14]), log(bostontrans.train$medv), alpha = 1, lambda = grid)
head(fit.lasso)

# 훈련집합의 R squared와 RMSE 계산
lasso.fitted.value = predict(fit.lasso, newx = as.matrix(bostontrans.train[,-14]))
# Rsq
1 - colSums((bostontrans.train$medv - exp(lasso.fitted.value))^2) / 
sum((bostontrans.train$medv - mean(bostontrans.train$medv))^2)
# RMSE
sqrt(colMeans((exp(lasso.fitted.value) - bostontrans.train$medv)^2))

# test Rsq, RMSE
lasso.fitted.value = predict(fit.lasso, newx = as.matrix(bostontrans.test[,-14]))
# Rsq
1 - colSums((bostontrans.test$medv - exp(lasso.fitted.value))^2) / 
sum((bostontrans.test$medv - mean(bostontrans.test$medv))^2)
# RMSE
sqrt(colMeans((exp(lasso.fitted.value) - bostontrans.test$medv)^2))
