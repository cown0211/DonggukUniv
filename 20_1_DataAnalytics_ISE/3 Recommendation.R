#1. Getting the data


#2. Working with the dataset
#디렉토리 설정
setwd("C:\\data")

#read data
data<- read.table('u.data')
colnames(data)<-c('user_id','item_id','rating','timestamp') #유저id,영화명,점수,평가시간시점)
data=data[,-which(names(data) %in% c('timestamp'))]

#check data
str(data)   #196번 유저가 242번 아이템에 대해 3점 줬다 
summary(data)
hist(data$rating)

#data sparsity
Number_Ratings=nrow(data)
Number_Movies=length(unique(data$item_id))
Number_User=length(unique(data$user_id))


#함수 정의, 여기서 함수 건들지 않고 4번 거를 건드림
data.frame2matrix = function(data, rowtitle, coltitle, datatitle, 
                             rowdecreasing = FALSE, coldecreasing = FALSE,   #row,col 정렬x
                             default_value = NA) {
  
  # check, whether titles exist as columns names in the data.frame data
  if ( (!(rowtitle%in%names(data))) 
       || (!(coltitle%in%names(data))) 
       || (!(datatitle%in%names(data))) ) {
    stop('data.frame2matrix: bad row-, col-, or datatitle.')
  }
  
  # get number of rows in data
  ndata = dim(data)[1]
  
  # extract rownames and colnames for the matrix from the data.frame
  rownames = sort(unique(data[[rowtitle]]), decreasing = rowdecreasing)
  nrows = length(rownames)
  colnames = sort(unique(data[[coltitle]]), decreasing = coldecreasing)
  ncols = length(colnames)
  
  # initialize the matrix
  out_matrix = matrix(NA, 
                      nrow = nrows, ncol = ncols,
                      dimnames=list(rownames, colnames))
  
  # iterate rows of data
  for (i1 in 1:ndata) {
    # get matrix-row and matrix-column indices for the current data-row
    iR = which(rownames==data[[rowtitle]][i1])
    iC = which(colnames==data[[coltitle]][i1])
    
    # throw an error if the matrix entry (iR,iC) is already filled.
    if (!is.na(out_matrix[iR, iC])) stop('data.frame2matrix: double entry in data.frame')
    out_matrix[iR, iC] = data[[datatitle]][i1]
  }
  
  # set empty matrix entries to the default value
  out_matrix[is.na(out_matrix)] = default_value
  
  # return matrix
  return(out_matrix)
  
}
colnames(data)<-c('user_id','item_id','rating','timestamp')
#위쪽에서 timestamp 제거했기 떄문에 에러 뜨는게 정상










############################################################################################
############################################################################################
############################################################################################
#3. Recommender libraries in R
############################################################################################

#install package
install.packages("SnowballC") #tf-idf를 구성하기 위한 패키지
install.packages("class") #KNN 분석을 위한 패키지
install.packages("dbscan") #KNN 분석을 위한 패키지
install.packages("proxy") #코사인 유사도, 거리를 계산하기 위한 패키지
install.packages("recommenderlab") #추천 시스템을 위한 패키지
install.packages("dplyr") #데이터 프레임을 처리하는 함수 패키지
install.packages("tm") #tf-idf matrix를 구성하기 위한 패키지
install.packages('caTools')

library(recommenderlab)
library(dplyr)
library(tm)
library(SnowballC)
library(class)
library(dbscan)
library(proxy)
library(caTools)







############################################################################################
############################################################################################
############################################################################################
#4. Data partitions(train, test)
############################################################################################

pre_data = data.frame2matrix(data, 'user_id', 'item_id', 'rating')
target_data<- as(  as(pre_data, "matrix")   , "realRatingMatrix")

#sub-setting the data users with 50 or more ratings remained
#평가 20개 이상 준 유저의 데이터만 이용
data2<-data[data$user_id %in% names(table(data$user_id))[table(data$user_id)>20],]

#splitting data randomly(train/test) 7:3
spl<-sample.split(data2$rating,0.7)
train<-subset(data2,spl==TRUE)
test<-subset(data2,spl==FALSE)






############################################################################################
############################################################################################
############################################################################################
#5. Integrating a popularity Recommender
############################################################################################

#평균 평점이 높은 영화
avg_top3 =head(sort(colMeans(normalize(target_data)), decreasing = TRUE),3)
avg_top3
#평가 횟수가 제일 높은 영화
freq_top3 =head(sort(colCounts(normalize(target_data)), decreasing = TRUE),3)
freq_top3
#평점도 높고 자주 언급되는 영화
#1보다 작은 값들은 0으로, 1보다 크면 1로
avg_freq_top3 =head(sort(colCounts(binarize(normalize(target_data),minRating=1)), decreasing = TRUE),3)
avg_freq_top3





############################################################################################
############################################################################################
############################################################################################
#6. Integrating a collaborative filtering recommender
#9. evaluation: RMSE & 
#10. evaluation: confusion matrix, precision-recall 
############################################################################################

set.seed(2017)
index <- sample(1:nrow(target_data), size = nrow(target_data) * 0.75)

#데이터 구분(train/test데이터로 구분)
train <- target_data[index, ]
test <- target_data[-index, ]

dim(train) 

#데이터모델링
recommender_models <- recommenderRegistry$get_entries(dataType = "realRatingMatrix")
recomm_model <- Recommender(data = train, method = "UBCF")
recomm_model
recomm_model@model$data

#테스트 데이터 예측(가장 많이 추천받을 가능성이 높은 영화  상위 10개)
pred <- predict(recomm_model, newdata = test, n = 10)
pred

#테스트데이터에 있는 해당 사용자가 몇 번째 영화를 추천받을지 예측
pred_list <- sapply(pred@items, function(x) { colnames(pre_data)[x] })
pred_list[1] #1번 사용자에게 추천하는 농담

#test에 속한 사용자들에게 몇개의 영화가 추천되었는가?
table(unlist(lapply(pred_list, length)))

#모델평가
data_modify <- target_data[rowCounts(target_data)]

eval_sets_UBCF <- evaluationScheme(data = data_modify,
                                   method = "cross-validation",
                                   train = 0.7, k = 10, goodRating = 3, given = 3)
sapply(eval_sets_UBCF@runsTrain, length)
getData(eval_sets_UBCF, "train")

#Traning
recomm_eval <- Recommender(data = getData(eval_sets_UBCF, "train"),
                           method = "UBCF", parameter = NULL)
recomm_eval

#prediction
pred_eval <- predict(recomm_eval, 
                     newdata = getData(eval_sets_UBCF, "known"),
                     n = 10, type = "ratings")
pred_eval

# Calculate accuracy(각 사용자별 추천이 적절했는지)
accuracy_eval_UBCF <- calcPredictionAccuracy(x = pred_eval,
                                             data = getData(eval_sets_UBCF,
                                                            "unknown"),
                                             byUser = TRUE)
head( accuracy_eval_UBCF, 10 )

#전체 정확도
colMeans(accuracy_eval_UBCF, na.rm = TRUE)

#정밀도/재현율을 이용한 정확도
accuracy_eval2_UBCF <- evaluate(x = eval_sets_UBCF, method = "UBCF" )
head( getConfusionMatrix(accuracy_eval2_UBCF), 10)

#ROC 커브
plot(accuracy_eval2_UBCF, annotate = TRUE, main = "ROC Curve")

############################################################################################
############################################################################################
############################################################################################
#7. Integrating an item-similarity recommender
#9. evaluation: RMSE & 
#10. evaluation: confusion matrix, precision-recall 
############################################################################################
#list(k)는 아이템의 유사도 값을 계산하는데 고려하는 이웃의 수
recomm_model2 <- Recommender(data = train, 
                             method = "IBCF",
                             parameter = list(k = 30))
recomm_model2
str( getModel(recomm_model2) )

#테스트 데이터 내용 예측
pred2 <- predict(recomm_model2, newdata = test, n = 10)

pred_list2 <- sapply(pred2@items, function(x) { colnames(target_data)[x] })

pred_list2[1]

table(unlist(lapply(pred_list2, length)))


#모델평가
data_modify <- target_data[rowCounts(target_data)]

eval_sets_IBCF <- evaluationScheme(data = data_modify,
                                   method = "cross-validation",
                                   train = 0.7,
                                   k = 5,
                                   goodRating = 3,
                                   given = 15)
#데이터 세트 추출
sapply(eval_sets_IBCF@runsTrain, length)

getData(eval_sets_IBCF, "train")

#Training
recomm_eval_IBCF <- Recommender(data = getData(eval_sets_IBCF, "train"),
                                method = "IBCF", 
                                parameter = NULL)
recomm_eval_IBCF

#Prediction
pred_eval_IBCF <- predict(recomm_eval_IBCF, 
                          newdata = getData(eval_sets_IBCF, "known"),
                          n = 10, type = "ratings")
pred_eval_IBCF

#정확도 계산
accuracy_eval_IBCF <- calcPredictionAccuracy(x = pred_eval_IBCF,
                                             data = getData(eval_sets_IBCF, 
                                                            "unknown"),
                                             byUser = TRUE)

head(accuracy_eval_IBCF,10)

#평균 정확도
meanitem<- colMeans(accuracy_eval_IBCF,na.rm = TRUE)

#정밀도/재현율 정확도
accuracy_eval_IBCF <- evaluate(x = eval_sets_IBCF, 
                               method = "IBCF", 
                               n = seq(10, 100, by = 10))
head( getConfusionMatrix(accuracy_eval_IBCF) )

#ROC 커브
plot(accuracy_eval_IBCF, annotate = TRUE, main = "ROC Curve")


############################################################################################
############################################################################################
############################################################################################
#8. Getting top k recommentations & 
#9. evaluation: RMSE & 
#10. evaluation: confusion matrix, precision-recall 
############################################################################################

#매개변수 튜닝
#1. 아이템 간 유사도를 계산하는데 필요한 최적의 이웃의 수
#2. 코사인 또는 피어슨 상관계수 중 유사도 계산 기준 선택
vector_k <- c(5, 10, 20, 30, 40)
mod1 <- lapply(vector_k, function(k, l) { list(name = "IBCF", 
                                               parameter = list(method = "cosine", 
                                                                k = k)) })
names(mod1) <- paste0("IBCF_cos_k_", vector_k)
names(mod1)

mod2 <- lapply(vector_k, function(k, l) { list(name = "IBCF", 
                                               parameter = list(method = "pearson", 
                                                                k = k)) })
names(mod2) <- paste0("IBCF_pea_k_", vector_k)
names(mod2)

mod <- append(mod1, mod2)

list_results <- evaluate(x = eval_sets_IBCF, 
                         method = mod,
                         n = c(1, 5, seq(10, 100, by = 10)))

#매개변수 별 ROC 커브
plot(list_results, annotate = c(1, 2), legend = "topleft")
title("ROC Curve")

#매개변수 별 재현/회상
plot(list_results, "prec/rec", annotate = 1, legend = "bottomright")
title("Precision-Recall")

