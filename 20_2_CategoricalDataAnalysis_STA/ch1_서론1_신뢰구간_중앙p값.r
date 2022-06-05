Clinical=read.table("http://www.stat.ufl.edu/~aa/cat/data/Clinical.dat",head=T)
Clinical
str(Clinical) # 변수에 대한 구조 확인


# 유의성 검정


# prop.test()   # 스코어 검정 # 스코어 CI
prop.test(sum(Clinical$response),nrow(Clinical),p=0.5,alternative="two.sided",conf.level=0.90,correct=F)
# 성공횟수 y, 시행횟수 n
# p : 귀무가설 하의 p, 기본값 0.5
# alternative : 양측 two.sided, 우단측 greater, 좌단측 less
# conf.level : 기각역 범위
# correct : 연속성수정 여부, 기본값 true
## 해석 ##
## 표본비율이 0.9 나오는데 얘가 0.5가 맞는지를 검정
## 카이제곱 통계량 6.4
## 자유도 1
## p값 0.1141
## 대립가설; 모비율은 0.5가 아니다; 양측검정
## 95% CI (0.5959, 0.9821)







# 여러가지 신뢰구간을 구하는 함수

install.packages("binom")
library(binom)



binom.confint(9,10,conf.level=0.95,method="all")
# 성공횟수, 시행횟수, 유의수준
# method는 신뢰구간 구하는 방식을 의미, 아그레스티콜리,prop.test,etc...
# asymptotic = wald, wilson = score, agresti-coull, exact = 정확분포, prop.test = 연속성 수정 된 score
# upper가 1 넘어가는 경우가 생김 => 1로 맞추고 포함확률을 95퍼로 맞추도록 수정


# 정확검정
# 9번 성공할 확률 + 10번 성공할 확률
binom.test(9,10,0.5,alternative="two.sided")
# 10번 시행, 9번 성공, H0 : p=0.5, 양검
binom.test(9,10,0.5,alternative="greater")
# 10번 시행, 9번 성공, H0 : p=0.5, 우검



# 중앙p값 활용하는 패키지
install.packages("exactci")
library(exactci)

binom.exact(9,10,0.5,alternative="two.sided",midp=T)
# 정확검정의 첫번째 버전과 비교했을 때, p값이 0.02148에서 0.01172로 줄어듦

