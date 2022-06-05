
### 분할표 독립성 검정
Political=read.table("http://www.stat.ufl.edu/~aa/cat/data/Political.dat", header=T)
str(Political)
head(Political,10)


# 원 데이터를 분할표 형식으로 변환
party=factor(Political$party, levels=c("Dem","Rep","Ind"))
GenderGap=xtabs(~gender+party, data=Political)


# 피어슨 카이제곱검정
chisq.test(GenderGap) # 분할표를 넣음
# 성별과 지지정당이 독립이라는 귀무가설 기각

chisq.test(GenderGap)$observed # 원데이터
chisq.test(GenderGap)$expected # 귀무가설(독립이라는 가정) 하의 기대값
chisq.test(GenderGap)$residuals # 피어슨잔차
stdres=chisq.test(GenderGap)$stdres # 표준화잔차


# 모자이크 그림
install.packages('vcd')
library(vcd)
mosaic(GenderGap, gp=shading_Friendly, residuals=stdres, residuals_type='Std\nresiduals', labeling=labeling_residuals)
# 적용할 분할표, 색깔, 적용할 잔차, 범례명 표기, 칸에 잔차값 표기
# 면적은 도수에 비례(무소속이 젤 넓음)
# 색깔은 +- 구분 -> 색깔이 칠해졌다면 차이가 유의함
















### 순서형 자료의 독립성 검정

Malform=matrix(c(17066,14464,788,126,37,48,38,5,1,1),ncol=2)
# 기형아 발생률 행렬

install.packages('vcdExtra')
library(vcdExtra)

# 추세검정
CMHtest(Malform, rscores=c(0,0.5,1.5,4.0,7.0))
# rscores; 소비량 범주화
# cor Nonzero correlation; 대립가설:corr

M = sqrt(6.5699) # M 통계량 ~ N(0,1)
1-pnorm(M) # H0 : theta>1 => 우단측 검정; M 통계량에 대한 p값



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