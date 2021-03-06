### 두 비율의 차이에 대한 추론
# 위약, 아스피린 예제




prop.test(c(189,104), c(11034,11037), conf.level=0.95, correct=F)
# 성공횟수, 시행횟수, 유의수준, 연속성수정x
# 95% ci : (0.004687751, 0.01072497)
# 표본비율을 토대로 계산한 wald ci



install.packages("PropCIs")
library(PropCIs)
diffscoreci(189, 11034, 104, 11037, conf.level=0.95)
# 1의 성공횟수,시행횟수, 2의 성공횟수,시행횟수, 유의수준
# 95% ci : (0.004716821, 0.010788501)
# 귀무가설 하의 score ci



# 위 둘의 경우는 대표본이라 결과가 크게 다르지 않음
# 만약 하나라도 0 or 1에 근사한 값을 가지면 결과 신뢰 어려워 아래와 같이 보정(소표본인 경우)


wald2ci(189, 11034, 104, 11037, conf.level=0.95, adjust="AC")
# 1의 성공횟수,시행횟수, 2의 성공횟수,시행횟수, 유의수준, 보정방법
# 이 경우는 대표본이라 보정을 해도 크게 다르지 않음
# 모든 칸에 +1 해주는 경우(2x2면 전체시행 +4)
# adjust wald ci









### 상대위험도에 대한 신뢰구간
riskscoreci(189, 11034, 104, 11037, conf.level=0.95)
# 1의 성공횟수,시행횟수, 2의 성공횟수,시행횟수, 유의수준
# 대표본이기 때문에 로그를 취한 상대위험도 값이 z분포를 따른다고 가정 후 안티로그





### 오즈비에 대한 신뢰구간
install.packages("epitools")
library(epitools)
oddsratio(c(189,10845,104,10933), method="wald", conf.level=0.95, correct=F)
# wald ci
# n11,n12,n21,n22(각각의 칸도수를 넣어야 함), ci 종류, 유의수준, 연속성수정x
# $measure // Exposed2 (L,U)



orscoreci(189, 11034, 104, 11037, conf.level=0.95)
# score ci
# 어떤 칸도수가 0이나 1에 해당하면 신뢰구간이 터무니 없는 값이 나오기 때문에 score 방식으로 보정



###### 예제가 대표본 케이스라서 값이 거기서 거기로 나오지만 소표본인 경우엔 구분 필요


