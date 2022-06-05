### Logistic Regression ###
Crabs = read.table("https://www.stat.ufl.edu/~aa/cat/data/Crabs.dat", header = T)
Crabs


plot(y ~ width, data = Crabs)
# 그대로 쓰면 분포를 보기 어려우므로 변환 필요

plot(jitter(y, 0.08) ~ width, data = Crabs)
# y에 대해 0.08의 변동성을 주는 함수


# 평활곡선 그리기
library(gam)
gam.fit = gam(y ~ s(width), family = "binomial", data = Crabs)
curve(predict(gam.fit, data.frame(width = x), type = "response"), add = T)



# 로지스틱 회귀분석
fit = glm(y ~ width, family = "binomial", data = Crabs)
curve(predict(fit, data.frame(width = x), type = "response"), add = T, col = "red")
# 평활곡선보다 더 자연스런 모습


# 모형 적합 결과
summary(fit)
# logit(phi(x)) = -12.3508 + 0.4972x
# beta에 대한 wald 검정값(z값, p값)이 표시됨
# Null deviance, 아무것도 없는 상수항에 대한 검정값
# Residual deviance, 현재 모델에 대한 검정값
# Null - Residual로 beta == 0에 대해 검정함

drop1(fit, test = "LRT")
# beta == 0에 대한 가능도비 검정
# width에 대한 (beta에 대한) LRT = 31.306 <==> 위의 Null - Residual
# p < 0.05




# width = 21.0일 때의 부수체를 가질 확률
predict(fit, data.frame(width = 21.0), type = "response")
# 평균 width에 대한 부수체를 가질 확률
predict(fit, data.frame(width = mean(Crabs$width)), type = "response")
