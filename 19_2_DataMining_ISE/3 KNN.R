### IRIS ###
install.packages("class")
library(class)



#분꽃의 종류(class)만 나옴
#1열짜리 벡터임(행렬아님)
y=iris[,5]
y



#y의 전체 갯수중에 75개만 선별(traindata 갯수)
tr.idx=sample(length(y),75)
tr.idx




#traindata testdata 정의
x.tr=iris[tr.idx,-5]
x.te=iris[-tr.idx,-5]






#x.tr으로 training, x.te로 test , k=3일때
m1=knn(x.tr,x.te,y[tr.idx],k=3)




#m1과 값이 다른것의 평균
mean(m1 != y[-tr.idx])




#테이블로 정리
a=table(m1,y[-tr.idx])
a





#x.tr로 트레이닝후, c(~~)으로 테스팅해봄
knnpredict=knn(x.tr,c(5.1,3.5,1.4,0.2),y[tr.idx],k=3)
knnpredict










### KNN 과제 ###

#class 패키지 설치 및 불러오기
install.packages("class")
library(class)

#universalbank 불러오기
ub<-read.csv("UniversalBank.csv")
head(ub)

#Personal_Loan 열만 추출
y=ub[,10]
y

#y의 전체 갯수중에 60%만 선별(traindata 갯수)
tr.idx=sample(length(y),round(length(y)*0.6))
tr.idx

#traindata testdata 정의
#ID,ZIP_code,Personal_Loan 열은 제외
x.tr=ub[tr.idx,-c(1,5,10)]
x.te=ub[-tr.idx,-c(1,5,10)]

#x.tr으로 training, x.te로 test , k=3일 때 knn모델
m1=knn(x.tr,x.te,y[tr.idx],k=3)
m1


#테이블로 정리
a=table(m1,y[-tr.idx])
a

#이때의 accuracy
accuracy=sum(a[1,1],a[2,2])/sum(a)
accuracy

#x.tr로 트레이닝후, b2)예시로 테스트
knnpredict=knn(x.tr,c(40,10,84,2,2,2,0,0,0,1,1),y[tr.idx],k=3)
knnpredict

