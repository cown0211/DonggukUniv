
### 암 참게 ###
Crabs = read.table("http://www.stat.ufl.edu/~aa/cat/data/Crabs.dat", header=T)
Crabs
# sat, 부수체 수
# y, 부수체 유무

# 너비에 따른 부수체의 개수
plot(sat ~ width, xlab = "Width", ylab = "# of Satellites", data = Crabs)
# 위의 결과로는 알기 모호함

# 평활곡선을 이용해 추세 확인해보고자 함
install.packages("gam")
library(gam)
# gam.fit으로 평활값 구함
gam.fit = gam(sat ~ s(width), family = poisson, data = Crabs)
# gam.fit의 평활값으로부터 predict 값을 구한 뒤, 평활곡선 구함
curve(predict(gam.fit, data.frame(width = x), type = "resp"), add = T)

# width가 증가함에 따라 부수체도 많아지는 추세가 있음을 보임

fit4 = glm(sat ~ width, family = poisson(link = log), data = Crabs)
summary(fit4)
fitted(fit4)
fitted(fit2)

