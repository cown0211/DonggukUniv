
###playtennis1.csv###

시작하기전에 작업디렉토리 확인!


install.packages("C50")   /*패키지 설치 크랜미러 아무거나 선택*/
library(C50)             /*설치한 패키지 불러오기*/


playtennis<-read.csv("playtennis1.csv")
playtennis


dt.play<-C5.0(PlayTennis~.,data=playtennis)  /*함수명주의+클래스명이 변수로 들어감+이게 끝*/
summary(dt.play)


dt.play1<-C5.0(PlayTennis~.,data=playtennis,rule=T)    /*rule 추가*/
summary(dt.play1)

/*후자는 error 하나 생김*/
/*d6에서 에러가 생김(humidity=normal) 왜인지는 모르고 프로그래밍상 심플하게,overfitting 고려해서 이래 나오는듯*/




###eBayAuctions.csv###

ebay<-read.csv("eBayAuctions.csv")
summary(ebay)
/*ebay에서 Competitive 변수는 숫자형이 아니고 카테고리형임 근데 r에서 숫자형으로 읽어옴*/
/*이대로 데이터 쓰면 백퍼 오류남*/
/*so 항상 summary함수 습관 들여야 함*/


ebay$Competitive=factor(ebay$Competitive)
summary(ebay)
/*factor 함수는 숫자형을 카테고리형으로 바꿔주는 함수임 1=경쟁력있음 0=경쟁력없음*/


dt.ebay<-C5.0(Competitive~.,data=ebay)
summary(dt.ebay)
/*여기도 rule 써도 됨*/
/*원래 attribute는 한번씩 쓰여야 하는데 여기보면 여려번 나옴 -> 연속숫자형이라 잘라씀?*/




###train,test나누기###

ebay1<-read.csv("eBayAuctions.csv")
ebay1$Competitive<-factor(ebay1$Competitive)
summary(ebay1)        /*Competitive변수 카테고리형으로 변경*/


sample_idx<-sample(1:nrow(ebay1),round(nrow(ebay1)*0.6))
sample_idx
/*nrow -> 불러온 데이터의 행개수  * 0.6 하면 60퍼센트 // 만큼의 index를 뽑아내는 함수가 sample*/
/*여기 나온 값들은 ebay1에서 뽑아낸 랜덤 '행번호'   */


dt.c50<-C5.0(Competitive~.,data=ebay1[sample_idx,])
summary(dt.c50)
/*sample로 뽑아낸 train data로 모델링*/



pre1<-predict(dt.c50,ebay1[-sample_idx,])
table(ebay1[-sample_idx,]$Competitive,pre1)

/*pre1
      0   1
  0 339  39
  1  73 338*/

/*predict 함수로 test data 예측값 계산하고 table로 정리함*/
/*행이 실제값 열이 예측값 0을 0으로 예측 339, 0을 1로 예측 39,1을 0으로 예측 73,1을 1로 예측 338*/








### flight delays ###

install.packages("C50")
library(C50)                          #패키지 설치 및 불러오기

flight<-read.csv("FlightDelays.csv")
summary(flight)                       #FlightDelays.csv 불러오기


sample_idx<-sample(1:nrow(flight),round(nrow(flight)*0.6))
sample_idx                          #전체 데이터 중 60퍼센트 train data 추출



dt.flight<-C5.0(Flight.Status~CARRIER+DEP_TIME+DEST+ORIGIN+Weather+DAY_WEEK,data=flight[sample_idx,])
summary(dt.flight)            #Flight.Status 종속변수로, 독립변수는 6개 활용
                              #train data 활용하여 모델링


pre1<-predict(dt.flight,flight[-sample_idx,])          #test data로 예측


table(flight[-sample_idx,]$Flight.Status,pre1)         #table로 정리

