# gradient descent 실습


# 함수 정의
f = function(x){1.2*(x-2)^2+3.2} # 원함수
grad = function(x){1.2*2*(x-2)}  # 미분함수


# 시각화
xs = seq(0,4,len=20); xs
plot(xs, f(xs), type="l", xlab="x", ylab=expression(1.2(x-2)^2+3.2)) # 실선 그래프
lines(c(2,2), c(3,8), col="red", lty=2) # 기울기 0 되는 지점에 점선
text(2.1, 7, "Closed form solution", col="red", pos=4)



# gradient descent
x = 0.1
xtrace = x
ftrace = f(x)
stepFactor = 0.0001
# x = 0.1을 시작으로 x와 y(=f(x))값을 각각 xtrace, ftrace에 기록함
# x와 stepFactor는 임의 설정, stepFactor에 따라 x의 변화 폭이 결정
# 변화 폭이 너무 크면 해를 못찾고 그래프 위로 날아갈 수도 있음
# 너무 작으면 최적해에 닿지 못함



for (step in 1:100) {        # 100번 반복, 횟수는 임의 설정
x = x - stepFactor * grad(x) # 처음 x 값에서 stepFactor * x에서의 미분값을 뺌
xtrace = c(xtrace,x)         # x값 누적
ftrace = c(ftrace,f(x))      # f(x)값 누적
}


# 시각화
lines(xtrace, ftrace, type="b",col="blue")
text(0.5, 6, "Gradient descent", col = 'blue', pos = 4)
print(x)