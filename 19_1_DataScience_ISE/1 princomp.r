# pca 실습 및 해석

setwd('C:/data')


# 파일 불러오기
# 각 도시의 연평균 기온
temperature = read.csv('temperature.csv', header=T)
temperature
# dataframe 구조 확인
str(temperature); summary(temperature)


# 도시명 -> rowname으로 변환
rownames(temperature) = temperature[,1]
temperature = temperature[,-1]


# 주성분 분석에 corr 사용
p1 = princomp(temperature, cor = T)
summary(p1)
# 전체 분산이 100%라고 할 때, pc1이 누적분산 66.57% 설명
# pc2까지 사용하면 누적분산 89.70% 설명, pc3부터는 95% 이상 설명


# 상관계수x 공분산o
p2 = princomp(temperature, cor = F)
summary(p2)


# 고유벡터
p1$loadings
# 각 주성분의 가중치
# PC1 : 0.326*JAN + 0.332*FEB + ... + 0.321*DEC
# PC2 : 0.204*JAN + 0*FEB + ... + 0.236*DEC
# 주성분1은 6,7월의 영향이 적다
# 주성분2는 6,7월의 음의 영향이 크다고 해석할 수 있다

p2$loadings
# PC1 : 0.457*JAN + 0.410*FEB + ... + 0.469*DEC
# PC1은 상대적으로 겨울 온도에 영향 받음 -> 겨울 기온이 상대적으로 높음
# PC2는 상대적으로 여름 온도에 영향 받음 -> 여름 기온이 상대적으로 낮음




# 주성분점수
p1$scores
# 서울을 comp.1의 계수가 -1.272, comp.2의 계수가 -2.443
# 겨울 기온은 상대적으로 낮고, 여름기온은 상대적으로 높은 것으로 해석

p2$scores
# 울진의 경우 comp.1의 계수 0.171, comp.2의 계수는 4.717
# 겨울 기온은 평균에 가깝고, 여름 기온은 상대적으로 낮음
# 서귀포는 comp.1 15.292, comp.2 -1.456으로 겨울과 여름 모두 기온 높음




###시각화 및 결과 해석###

biplot(p1)
# 빨간 화살표가 수평이면 PC1과, 수직이면 PC2와 상관관계가 크다는 것을 의미
# 예를 들어 JUN은 PC2와 음의 상관관계를 갖는다

biplot(p2)
# comp.1 : 서귀포,제주,부산,여수,통영 등은 겨울 기온이 높은 도시
# 추풍령,서산,대전,청주,서울,수원 등은 겨울 기온이 낮은 도시
# comp.2 : 속초,울진,울릉도 여름 기온 낮은 도시
# 서울,대구,전주,수원,진주 여름 기온 높은 도시
