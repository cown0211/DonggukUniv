# 모형 선택의 기준


concrete = read.csv('Concrete91.csv', header = T)
summary(concrete)



# CCS 변수와의 상관계수를 기준으로 변수 선택
ccs = data.frame(CCS = cor(concrete)[,9]); ccs

para2 = lm(CCS~Cement+Age, data = concrete)
para4 = lm(CCS~Cement+Age+Sp+Water, data = concrete)
paraall = lm(CCS~., data = concrete)
stepwise = step(paraall, direction = 'both') # 모든 변수가 들어간 상태에서 넣었다 뺐다 반복

# 위에서부터 변수2, 변수4, 모든변수, stepwise로 변수채택





# 각각의 경우 Rsquared, RMSE, AIC 계산
# Rsuqred; 0~1 값을 가지며 1에 가까울수록 잘 적합된 모델
# RMSE; 작을수록 적합한 모델
# AIC; 모형의 적합도와 변수의 개수를 토대로 하는 평가 지표, 낮을수록 적합한 모델

summary(para2)
sqrt(sum(para2$residuals^2)/nrow(concrete))
AIC(para2)

summary(para4)
sqrt(sum(para4$residuals^2)/nrow(concrete))
AIC(para4)

summary(paraall)
sqrt(sum(paraall$residuals^2)/nrow(concrete))
AIC(paraall)

summary(stepwise) # Cement, FlyAsh, BFS, Water, Age 변수만 채택
sqrt(sum(stepwise$residuals^2)/nrow(concrete))
AIC(stepwise)



# 요약
변수2 = list(coefficients = para2$coefficients, Rsquared = summary(para2)$r.squared,
RMSE = sqrt(sum(para2$residuals^2)/nrow(concrete)), AIC = AIC(para2)); 변수2

변수4 = list(coefficients = para4$coefficients, Rsquared = summary(para4)$r.squared,
RMSE = sqrt(sum(para4$residuals^2)/nrow(concrete)), AIC = AIC(para4)); 변수4

변수all = list(coefficients = paraall$coefficients, Rsquared = summary(paraall)$r.squared,
RMSE = sqrt(sum(paraall$residuals^2)/nrow(concrete)), AIC = AIC(paraall)); 변수all

변수step = list(coefficients = stepwise$coefficients, Rsquared = summary(stepwise)$r.squared,
RMSE = sqrt(sum(stepwise$residuals^2)/nrow(concrete)), AIC = AIC(stepwise)); 변수step

# 변수2, 변수4, 변수all의 경우, 변수의 개수가 많아질수록 모델이 더 적합해지는 것을 알 수 있음
# 변수의 개수가 많아질수록 Rsq는 1에 가깝게, RMSE, AIC는 낮아지는 모습을 보인다

# 변수all과 변수step의 경우, stepwise에서 변수 3개를 탈락시켰음
# 그 결과 Rsq 값은 stepwise에서 조금 더 낮고, RMSE는 stepwise에서 더 높다
# 하지만, AIC는 stepwise에서 의미 없는 변수를 탈락시켜서 더 낮다
