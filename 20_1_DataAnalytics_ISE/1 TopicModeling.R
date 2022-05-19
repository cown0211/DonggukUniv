install.packages('ldatuning')
install.packages('topicmodels')
install.packages('tm')
install.packages('slam')
install.packages('lda')
install.packages('KoNLP')

library(ldatuning)
library(topicmodels)
library(tm)
library(slam)
library(lda)
library(KoNLP)

#원본 데이터
lda_source<-read.csv("data.csv",stringsAsFactors = FALSE, header =TRUE )
#사용할 데이터 
target_doc<-lda_source[,2]  #csv의 두번째 열만 사용


#######################실습에선 생략#########################
##한글 사전 불러오기
useSejongDic()

##텍스트 추출
nouns <- sapply(target_doc, extractNoun)
nouns <- nouns[nchar(nouns)>=2]

##영문제거
nouns <- rapply(nouns, function(x) gsub("[A-z1234567890()]", "", x), how = "replace")
target_doc <- nouns #영문과 데이터 명을 맞추기 위한과정
##############################################################



#데이터에서 말뭉치를 만드는 작업
doc_vec<-VectorSource(target_doc)   #앞에서 만든 target_doc에 vectorsource 씌움
corpus<-Corpus(doc_vec)             #doc_vec에 corpus 씌워서 corpus 만듦


## term document matrix
#숫자,기호,빈칸 지우고, stemming 안하고 단어 그대로 사용
tdm = TermDocumentMatrix(corpus, control = list(removeNumbers = T,
                                                removePunctuation = T,
                                                stemming = FALSE,
                                                omit_empty = T))
Encoding(tdm$dimnames$Terms) = 'unicode'
word.count = as.array(rollup(tdm,2))       #어떤 단어가 몇번 나왔는지 count
word.order = order(word.count, decreasing = T)[1:1000] # 많이 쓰인 단어대로 올림차순 정렬,이 개수에 따라 결과 달라짐
freq.word = word.order[1:1000]           #많이 쓰인 순서대로 1등부터 1000등까지만 사용



#dtm 생성
##지금 과정은 열이 docu, 행이 1:1000 term
dtm = as.DocumentTermMatrix(tdm[freq.word,])
dtm.matrix<-as.matrix(dtm)

dtm
ldaform=dtm2ldaformat(dtm, omit_empty=T) #dtm을 LDA 포멧의 데이터로 변환

result.lda = lda.collapsed.gibbs.sampler(documents = ldaform$documents,
                                         K = 50,         #topic 개수, 바꿔보며 해야 정확도up
                                         vocab = ldaform$vocab,
                                         num.iterations = 500,
                                         burnin = 100,
                                         alpha = 0.01,
                                         eta = 0.01)



#분석결과 확인
attributes(result.lda)
dim(result.lda$topics)
result.lda$topics
document_sums <- result.lda$document_sums

#주제별 키워드 도출
##결과 보면 k=50으로 두었기 때문에 50개 topic이 생성되고
###하나의 topic당 n개의 term들이 들어가있음(여기선 20)
topic_word <- top.topic.words(result.lda$topics, num.words = 20) 

#주제별 핵심 문서 도출
##위의 50개의 topic에 대해 가장 연관있는 상위 n개 docu만 추출(여기선 10)
num.documents = 10
doc_topic <- top.topic.documents(document_sums, num.documents, alpha = 0.1) 

#파일 저장
write.csv(topic_word, "topic_word.csv")
write.csv(doc_topic, "doc_topic.csv")
