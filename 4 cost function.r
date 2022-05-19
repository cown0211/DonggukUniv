# cost function

# ex1
# 초기 데이터
x = c(3,4,5,4,5,6,7,8,12,13)
y = c(40,50,45,45,50,55,70,85,100,115)

# 1열을 모두 1 값을 갖는 x 행렬 생성
x = cbind(rep(1,10), x)

# theta의 초기값은 0,0으로 alpha 값은 0.01로 설정
theta = c(0,0)
temp = c(0,0)
alpha = 0.01
m = nrow(x)


# 반복횟수 10000회로 설정
for (i in 1:10000) {
temp[1] = theta[1] - alpha * (1/m) * sum(x %*% theta - y)
temp[2] = theta[2] - alpha * (1/m) * sum((x %*% theta - y) * x[,2])
theta = temp
}; theta


# 최종값 theta0 = 15.202, theta1 = 7.507



# lm함수 결과와 비교
x = c(3,4,5,4,5,6,7,8,12,13)
y = c(40,50,45,45,50,55,70,85,100,115)
df = data.frame(x,y)
summary(lm(y~., data = df))





# ex2
# 초기데이터
y = c(9,20,22,15,17,30,18,25,10,20)
x1 = c(4,8,9,8,8,12,6,10,6,9)
x2 = c(4,10,8,5,10,15,8,13,5,12)


x = cbind(rep(1,10), x1, x2)

theta = c(0,0,0)
temp = c(0,0,0)
alpha = 0.01
m = nrow(x)


for (i in 1:10000) {
temp[1] = theta[1] - alpha * (1/m) * sum(x %*% theta - y)
temp[2] = theta[2] - alpha * (1/m) * sum((x %*% theta - y) * x[,2])
temp[3] = theta[3] - alpha * (1/m) * sum((x %*% theta - y) * x[,3])
theta = temp
}; theta

# 최종값, theta0 = -0.648, theta1 = 1.551, theta2 = 0.760



# lm함수와 비교
y = c(9,20,22,15,17,30,18,25,10,20)
x1 = c(4,8,9,8,8,12,6,10,6,9)
x2 = c(4,10,8,5,10,15,8,13,5,12)
tmp = data.frame(x1,x2,y)
summary(lm(y~.,data=tmp))
