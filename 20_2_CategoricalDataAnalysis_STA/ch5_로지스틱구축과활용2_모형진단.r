Marijuana = read.table("http://www.stat.ufl.edu/~aa/cat/data/Marijuana.dat", header = T)

Marijuana


fit = glm(yes/(yes+no) ~ gender + race, weights = yes+no, family = binomial, data = Marijuana)

summary(fit)

fit$deviance # 모형의 이탈도, Residual deviance
fit$df.residual # 모형의 자유도

# 모형에 대한 p값
1-pchisq(fit$deviance, fit$df.residual) # H0:모형이 적합하다 => 귀무가설 채택

# 예측값
fitted(fit)
# 1; white + female의 yes 확률
# 2; white + male의 yes 확률
# 3; other + female의 yes 확률
# 4; other + male의 yes 확률


# 적합값 계산(확률에 대한 칸도수 예측값)
attach(Marijuana)
fit_yes = (yes+no)*fitted(fit)
fit_no = (yes+no)*(1-fitted(fit))

data.frame(race, gender, yes, fit_yes, no, fit_no)
# 이 데이터프레임을 기준으로 위의 fit$deviance, fit$df.residual 구함










### Hosmer-Lemeshow ###
# Marijuana 말고 Crabs 같이 그룹화 되지 않은 데이터 사용
Crabs = read.table("http://www.stat.ufl.edu/~aa/cat/data/Crabs.dat", header = T)

fit = glm(y ~ width + factor(color), family = binomial, data = Crabs)
hat_y = fitted(fit); hat_y # 부수체를 가질 확률(P(Y=1))의 추정값



### 함수 정의 ###
hosmerlem = function(y, yhat, g=10) { # g:그룹의 개수

  cutyhat = cut(yhat, # yhat을 자르는 함수 정의
                breaks = quantile(yhat, probs = seq(0, 1, 1/g)), 
                include.lowest = T)
  # quantile 함수를 통해 그룹의 개수만큼 분할
  # 위 결과를 breaks로 찍어줌으로써 분할점으로 설정
  # include.lowest; 가장 작은 점을 breaks로 사용하는지 여부

  obs = xtabs(cbind(1 - y, y) ~ cutyhat)
  # cutyhat의 범위에 대해 관측도수(1-y; 0 // y; 1)

  expect = xtabs(cbind(1 - yhat, yhat) ~ cutyhat)
  # cutyhat의 범위에 대해 예측(적합)도수(1-yhat; 0 // yhat; 1)

  chisq = sum((obs - expect)^2 / expect) # pearson 형태

  P = 1 - pchisq(chisq, g-2) # df; 그룹의 개수 - 2

  return(list(chisq = chisq, p.value = P))
}


hosmerlem(Crabs$y, hat_y)
# chisq 통계량과 p값 반환
# H0=관측도수와 기대도수의 차이가 크지 않다(모형이 적합하다)
# p값으로 H0 accept => 모형은 적합하다



### 기존 라이브러리 사용 ###
install.packages("ResourceSelection"); library(ResourceSelection)
hoslem.test(Crabs$y, hat_y)








### residual ###
Marijuana = read.table("http://www.stat.ufl.edu/~aa/cat/data/Marijuana.dat", header = T)

fit = glm(yes/(yes+no) ~ gender + race, weights = yes+no, family = binomial, data = Marijuana)

cbind(rstandard(fit, type = "pearson"), # 표준화 잔차, 2~3 넘으면 x인 것
      residuals(fit, type = "pearson"), # 피어슨 잔차
      residuals(fit, type = "deviance"), # 이탈도 잔차
      rstandard(fit, type = "deviance")) # 이탈도 잔차를 표준화한 것








### 영향점 진단 ###
x = c(111.5,121.5,131.5,141.5,151.5,161.5,176.5,191.5)
yes = c(3,17,12,16,12,8,16,8)
n = c(156,252,284,271,139,85,99,43)
fit0 = glm(yes/n ~ x, weights = n, family = binomial)

fitted(fit0)   # 각 그룹에 대한 심장병 발병 확률
fitted(fit0)*n # yes에 대한 예측(적합)값; 확률*표본수; 추정값 in table 5.3

rstandard(fit0, type = "pearson") # 표준화 잔차, table 5.3

dfbetas(fit0) # 교재와 값이 조금 다르나 상관x

influence.measures(fit0) # inf로 표시되는 경우가 영향점























# 174p 데이터표
Dept = rep(LETTERS[1:23], times=2)
gender = rep(c("Females", "Males"), times=1, 23)

cbind(Dept, gender)

yes = c(32,6,12,3,52,8,35,9,6,17,9,26,21,25,3,10,25,2,3,29,16,23,4,21,3,34,4,5,6,30,11,15,4,21,25,7,31,9,25,39,4,0,6,7,36,10)
no = c(81,0,43,1,149,7,100,1,3,0,9,7,10,18,0,11,34,123,3,13,33,9,62,41,8,110,0,10,12,112,11,6,1,19,16,8,37,6,53,49,41,2,3,17,14,54)
# 각각 여성의 숫자 나열 후 남성의 숫자 나열

cbind(Dept, gender, yes, no)

fit = glm(yes/(yes+no) ~ factor(Dept), weights = yes+no, family = binomial)
# 성별에 대한 효과는 없다고 가정한 모형

rstandard(fit, type="pearson")
# 여성의 residual 값 먼저 나열, 24번째부턴 남성의 residual
