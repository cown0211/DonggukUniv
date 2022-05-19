#install.packages(sm); library(sm)
#install.packages("corrplot")
#install.packages('leaps')


############################################
######### Simple Linear regression #########
############################################

set.seed(123)

x = rnorm(100, 170, 10)
e = rnorm(100, 0, 2)

y = 0.3 + 0.5*x + e 

plot(x, y, xlab = "x", ylab="y")


### fitting model
# intercept 있는 모형
result = lm(y~x)
summary(result)

# intercept 없는 모형
result2 = lm(y~x-1) 
summary(result2)

### regression line
plot(x, y, xlab = "x", ylab="y")
abline(result, col="red")
abline(result2, col="blue")

### confidence Interval
# 직접
str(result)

y_pred = result$fitted.values
n = length(y)

sse = sum((y - y_pred)^2)
mse = sse / (n - 2)

Sxx = sum((x-mean(x))^2)

b0 = result$coeff[[1]]
b1 = result$coeff[[2]]

b0_ci_low = b0 - qt(0.975, n-2)*sqrt((mse/n)*(sum(x^2)/Sxx))
b0_ci_upper = b0 + qt(0.975, n-2)*sqrt((mse/n)*(sum(x^2)/Sxx))
b0_ci = c(b0_ci_low, b0_ci_upper)

b1_ci_low = b1 - qt(0.975, n-2)*sqrt(mse/Sxx)
b1_ci_upper = b1 + qt(0.975, n-2)*sqrt(mse/Sxx)
b1_ci = c(b1_ci_low, b1_ci_upper)

b0_ci
b1_ci

# confint 함수 이용
confint(result)
confint(result, level=0.90)

### prediction
str(result)
predict(result, newdata = data.frame(x=140))

newx = data.frame(x = seq(130, 140, 2))
newx
predict(result, newdata = newx)


### Confidence Interval & Prediction Interval
conf_int = as.data.frame(predict(result, interval = 'confidence'))
pred_int = as.data.frame(predict(result, interval = 'prediction'))

plot(x, y)
abline(result, col="red")
lines(x[order(x)], conf_int$lwr[order(x)], col="blue", type='l', lty = "dashed")
lines(x[order(x)], conf_int$upr[order(x)], col="blue", type='l', lty = "dashed")

lines(x[order(x)], pred_int$lwr[order(x)], col="green", type='l', lty = "dashed")
lines(x[order(x)], pred_int$upr[order(x)], col="green", type='l', lty = "dashed")

legend("bottomright", legend=c("fiited", "Confidence", "Prediction"),
		col=c("red", "blue", "green"), lty = c(1, 2, 2), cex=0.8)	

### residual plot
# optional 4 graphs/page
layout(matrix(c(1,2,3,4),2,2))
plot(result)

### Normality test
shapiro.test(y)

##############################################
######### Multiple Linear regression #########
##############################################
#data(mtcars)

#[, 1]  mpg Miles/(US) gallon
#[, 2]  cyl Number of cylinders
#[, 3]  disp    Displacement (cu.in.)
#[, 4]  hp  Gross horsepower
#[, 5]  drat    Rear axle ratio
#[, 6]  wt  Weight (1000 lbs)
#[, 7]  qsec    1/4 mile time
#[, 8]  vs  V/S
#[, 9]  am  Transmission (0 = automatic, 1 = manual)
#[,10]  gear    Number of forward gears
#[,11]  carb    Number of carburetors

input = mtcars[,c("mpg","disp","hp","wt")]
head(input)

### Correlation 
corrmat = cor(input)
corrmat

plot(input)

library(corrplot)
corrplot(corrmat, method="circle")
#method="number", "color", "pie"


### fitting model
result = lm(mpg~disp+hp+wt, data = input)
summary(result)

# disp 제거
result2 = lm(mpg~hp+wt, data = input) 
summary(result2)

### Model Selection
## AIC 이용
library(MASS)
ResultStep = stepAIC(result, direction="both")
# direction = "backward", "forward"
# step(result, direction="both")
ResultStep

## 모든 subset 
library(leaps)

result_leaps = regsubsets(mpg~disp+hp+wt,data=input,nbest=7)
summary(result_leaps)
plot(result_leaps,scale="r2")

### Interaction 
result3 = lm(mpg~hp+wt+hp*wt, data = input) 
summary(result3)


#########################################
######### Polynomial regression #########
#########################################

set.seed(123)

x = rnorm(100, 5, 2)
e = rnorm(100, 0, 1)

y = -2.5 + 5*x -0.5*x^2 + e 

plot(x, y, xlab = "x", ylab="y")


### fitting model
# simple linear regression
result = lm(y~x)   
summary(result)

# polyunnomial reg
x2 = x^2
x3 = x^3

result2 = lm(y~x+x2+x3)
summary(result2)

result3 = lm(y~x+x2)
summary(result3)

### regression line
plot(x, y, xlab = "x", ylab="y")
abline(result, col="red")
lines(x[order(x)], predict(result3)[order(x)], col="blue")
