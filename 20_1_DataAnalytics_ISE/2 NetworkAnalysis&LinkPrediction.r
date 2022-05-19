install.packages("igraph")
install.packages("statnet")
library(igraph)
library(statnet)

#데이터 읽기 선택지 1_확장자가CSV인 from to파일의 경우
data = read.csv("C://data/1.csv", header = TRUE)
class(data); data
el=as.matrix(data)
class(el); el
g <- graph.edgelist(el,directed=FALSE); g;
#edge=arc
#directed는 방향성, 방향성 있으면 T 없으면 F


#데이터 읽기 선택지 2_gefx 확장자 파일의 경우
install.packages("rgexf")
library(rgexf)
h <- read.gexf("C://data/2.gexf")
g <-gexf.to.igraph(h)

#데이터 읽기 선택지 3_확장자가 gml
g <- read.graph("C://data/3.gml",format="gml")




###중심성지표계산###
#노드 연결 수(Degree)
degree<-igraph::degree(g,mode="out")
plot(g) #g의 그림


degree_vcount<-vcount(g)   #g의 degree 카운팅
degree_centralization<-centralization.degree(g) #centralization
#degree 크기에 따라 노드 크기 변환
V(g)$size<-igraph::degree(g)*2
plot(g)





#근접 중심성(closeness)
#빨갈수록 closeness 크고 노랄수록 작음
clo <- igraph::closeness(g)
clo.score<-round((clo-min(clo))*length(clo)/max(clo))+1  
clo.colors<-rev(heat.colors(max(clo.score)))
#Degree 크기에 따라 노드 크기 변화
V(g)$color<-clo.colors[clo.score]
plot(g)





#매개 중심성(betweeness)
btw<-igraph::betweenness(g)
btw.score<-round(btw)+1
btw.colors<-rev(heat.colors(max(btw.score)))
V(g)$color<-btw.colors[btw.score]
plot(g)





#density
graph_density<-graph.density(g)
graph_density
plot(g)


#cluster
clusters<-clusters(g)
clusters
#csize=node의 개수, membetship=cluster 구분
#3.gml=>34개의 노드가 모두 1이라는 cluster에 속함
#1.csv=>24,5,3개의 노드가 각각 1,2,3으로 군집됨




#clique
clique<-cliques(g) # clique 리스트
clique_length<-sapply(cliques(g), length); clique_length #clique의 숫자를 보여줌
largest_clique<-largest_cliques(g); largest_clique #가장 큰 clique 도출
#3.gml에서 largest_clique는 두가지임.

#원 그래프에 clique를 황금색으로 표시
vcol <- rep("grey80", vcount(g))
vcol[unlist(largest_cliques(g))] <- "gold"
#vcol[unlist(largest_cliques(g)[1])] <- "gold"  #largest_clique중 첫번째 것만 색칠!
plot(as.undirected(g), vertex.label=V(g)$name, vertex.color=vcol)






#Link Prediction
predicted <- predict_edges(g)
V(g)$name
a1 <- predicted$edges
a2 <- predicted$prob
a3 <- cbind(a1,a2)
colnames(a3) = c("from", "to", "prob")
write.csv(a3, "C://users//wngud//desktop//link_prediction.csv")
