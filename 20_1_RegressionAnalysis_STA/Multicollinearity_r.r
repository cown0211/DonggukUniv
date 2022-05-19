
#### 자료불러오기 ####
mri = read.csv("MRI_IQ.csv", head=T)

head(mri)
summary(mri)  # kg <- 0.45*lb, cm <- 2.54*inch


#### EDA ####

## scatter plot & Correlation Matrix
pairs(mri[,-1])

correlation = cor(mri[,-1])
round(correlation, 3)

# library(corrplot)
# corrplot(correlation, method="number")


#### Regression ####

## 상관관계가 낮은 두 변수(PIQ, wieght) 이용

reg1 = lm(FSIQ~PIQ, data = mri)
summary(reg1)

reg2 = lm(FSIQ~Weight, data = mri)
summary(reg2)

reg3 = lm(FSIQ~PIQ + Weight, data = mri)
summary(reg3)


## 상관관계가 높은 두 변수(PIQ, VIQ) 이용
summary(reg1)

reg2 = lm(FSIQ~VIQ, data = mri)
summary(reg2)

reg3 = lm(FSIQ~PIQ + VIQ, data = mri)
summary(reg3)


## 상관관계가 높은 두 변수(PIQ, VIQ)와 MRI변수 이용
reg4 = lm(FSIQ~ MRI + VIQ, data = mri)
summary(reg4)

reg5 = lm(FSIQ~ PIQ + MRI + VIQ, data = mri)
summary(reg5)


#### 다중공선성 진단 ####
#install.packages('olsrr')
library(olsrr)

ols_vif_tol(reg5)
ols_eigen_cindex(reg5)



#### 다중공선성 해결 ####

## 변수 제거
reg = lm(FSIQ~ VIQ + MRI, data = mri)
summary(reg)

reg = lm(FSIQ~ VIQ, data = mri)
summary(reg)


## 주성분분석
pca = prcomp(mri[, c('PIQ', 'VIQ', 'MRI')], scale = TRUE)
summary(pca)

pca.data = data.frame(FSIQ = mri$FSIQ, pca$x)
pairs(pca.data)

pca.reg = lm(FSIQ~PC1+PC2, data = pca.data)
summary(pca.reg)
pca


