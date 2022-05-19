# 최소제곱법 실습


# 행렬방법

data = read.csv('38ptest.csv', header = T); data
data = matrix(c(data[,1],data[,2],data[,3]),ncol=3,byrow=F);data

y = data[,1]; y
x = cbind(rep(1,10), data[,2], data[,3]); x

b = t(x) %*% x; b
c = solve(b) %*% t(x); c
theta = c %*% y; theta
# y = 1.551*x1 + 0.760*x2 - 0.651



# lm()방법

data = read.csv('38ptest.csv', header = T); data

out = lm(y~., data = data)
summary(out)
