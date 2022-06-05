### Logistic Regression, CI ###
Crabs = read.table("https://www.stat.ufl.edu/~aa/cat/data/Crabs.dat", header = T)
Crabs


fit = glm(y ~ width, family = "binomial", data = Crabs)



# Y = 1일 확률의 예측값
pred.prob = fitted(fit)



lp = predict(fit, se.fit = T)
lp
# $fit; 1.7208~은 logit의 예측값이자 alpha+beta*x값이자 선형예측값
# 위에선 type을 response(확률)로 놨고, 여기선 예측값으로 둠
# $se.fit; 선형예측값(fit)에 대한 s.e.



### CI ###

# logit 예측값의 경계값
LB = lp$fit - 1.96*lp$se.fit # Lower Bound
UB = lp$fit + 1.96*lp$se.fit # Upper Bound

# 성공확률 p에 대한 경계값
LB.p = exp(LB)/(1+exp(LB))
UB.p = exp(UB)/(1+exp(UB))

# x(width)에 대한 예측 성공확률과 상,하한
cbind(Crabs$width, pred.prob, LB.p, UB.p)






# 신뢰구간 그래프 그리기

plot(jitter(y, 0.1) ~ width, data = Crabs, xlim = c(18,34), pch = 16, ylab = "Prob(satellite)")

# 위처럼 그리면 width의 실제 값 때문에 그래프가 잘림
# 따라서 그래프 그리기 위한 변수 생성
# width 18~34
data.plot = data.frame(width = (18:34))
lp = predict(fit, newdata = data.plot, se.fit = T)

# Y = 1일 확률의 예측값
pred.prob = exp(lp$fit)/(1+exp(lp$fit))

# CI 구하기
LB = lp$fit - 1.96*lp$se.fit
UB = lp$fit + 1.96*lp$se.fit

LB.p = exp(LB)/(1+exp(LB))
UB.p = exp(UB)/(1+exp(UB))

# 잘리지 않고 자연스런 곡선 모양
lines(18:34, pred.prob) # 예측 확률의 그래프
lines(18:34, LB.p, col = "red") # 하한의 그래프
lines(18:34, UB.p, col = "blue")# 상한의 그래프


