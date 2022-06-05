
### 피셔의 정확검정
tea = matrix(c(3,1,1,3),nrow=2)

fisher.test(tea)
# 여기서의 p값은 양측검정이라 교재보다 크게 나옴
# => true odds ratio != 1

fisher.test(tea,alternative='greater')
# 우단측 검정, p값 0.2429




# mid-p값 적용 패키지
library(epitools)



ormidp.test(3,1,1,3,or=1)
# or=1 -> odds ratio==1

or.midp(c(3,1,1,3),conf.level=0.95)
# $estimate; odds ratio의 추정값
# $conf.int; 신뢰구간