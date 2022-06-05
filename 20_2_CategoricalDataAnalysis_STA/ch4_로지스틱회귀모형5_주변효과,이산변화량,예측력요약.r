Crabs = read.table("http://www.stat.ufl.edu/~aa/cat/data/Crabs.dat", header = T)


### 평균주변효과와 이산변화량 ####

install.packages("mfx")
library(mfx)

logitmfx(fit3, atmean=F, data=Crabs)

# dF/dx; 각 x에 대해서 변화율을 구한 뒤, 변화율의 평균을 계산함
# width 변수에 대해서는 해당 값이 0.087로 계산, p값은 매우 유의함
# c4는 연속형이 아님; 이산변화량
# c4=1일 때의 phi_hat과 c4=0일 떄의 phi_hat의 차이에 대한 평균
# c4=1일때(어두울때) 부수체 가질 확률이 더 작기 때문에 음수값을 가짐









### ROC Curve ###
# 표본비율을 계산해야 함(여기서는 mean으로 대체)
prop = mean(Crabs$y)

# 표본비율보다 크면 1, 아니면 0
predicted = as.numeric(fitted(fit) > prop)

# 실제값과 예측값 2차원 table
xtabs(~Crabs$y + predicted)





# ROC curve
install.packages("pROC"); library(pROC)
rocplot = roc(y ~ fitted(fit), data = Crabs)
plot.roc(rocplot, legacy.axes = T)
# 1-특이도를 x축에 두려면 legacy.axes=T

auc(rocplot)
# rocplot 밑부분의 면적





# 상관계수 R
cor(Crabs$y, fitted(fit))
# Crabs$y가 이산형이기 때문에 여기서 갖는 0.45 값이 큰 의미는 갖지 않지만 다른 모델과의 비교 가능
# 타모델보다 R 값이 크다면 그만큼 설명력을 갖는다고 해석