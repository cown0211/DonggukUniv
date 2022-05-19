install.packages("igraph")
install.packages("statnet")
library(igraph)
library(statnet)

#������ �б� ������ 1_Ȯ���ڰ�CSV�� from to������ ���
data = read.csv("C://data/1.csv", header = TRUE)
class(data); data
el=as.matrix(data)
class(el); el
g <- graph.edgelist(el,directed=FALSE); g;
#edge=arc
#directed�� ���⼺, ���⼺ ������ T ������ F


#������ �б� ������ 2_gefx Ȯ���� ������ ���
install.packages("rgexf")
library(rgexf)
h <- read.gexf("C://data/2.gexf")
g <-gexf.to.igraph(h)

#������ �б� ������ 3_Ȯ���ڰ� gml
g <- read.graph("C://data/3.gml",format="gml")




###�߽ɼ���ǥ���###
#��� ���� ��(Degree)
degree<-igraph::degree(g,mode="out")
plot(g) #g�� �׸�


degree_vcount<-vcount(g)   #g�� degree ī����
degree_centralization<-centralization.degree(g) #centralization
#degree ũ�⿡ ���� ��� ũ�� ��ȯ
V(g)$size<-igraph::degree(g)*2
plot(g)





#���� �߽ɼ�(closeness)
#�������� closeness ũ�� ������� ����
clo <- igraph::closeness(g)
clo.score<-round((clo-min(clo))*length(clo)/max(clo))+1  
clo.colors<-rev(heat.colors(max(clo.score)))
#Degree ũ�⿡ ���� ��� ũ�� ��ȭ
V(g)$color<-clo.colors[clo.score]
plot(g)





#�Ű� �߽ɼ�(betweeness)
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
#csize=node�� ����, membetship=cluster ����
#3.gml=>34���� ��尡 ��� 1�̶�� cluster�� ����
#1.csv=>24,5,3���� ��尡 ���� 1,2,3���� ������




#clique
clique<-cliques(g) # clique ����Ʈ
clique_length<-sapply(cliques(g), length); clique_length #clique�� ���ڸ� ������
largest_clique<-largest_cliques(g); largest_clique #���� ū clique ����
#3.gml���� largest_clique�� �ΰ�����.

#�� �׷����� clique�� Ȳ�ݻ����� ǥ��
vcol <- rep("grey80", vcount(g))
vcol[unlist(largest_cliques(g))] <- "gold"
#vcol[unlist(largest_cliques(g)[1])] <- "gold"  #largest_clique�� ù��° �͸� ��ĥ!
plot(as.undirected(g), vertex.label=V(g)$name, vertex.color=vcol)






#Link Prediction
predicted <- predict_edges(g)
V(g)$name
a1 <- predicted$edges
a2 <- predicted$prob
a3 <- cbind(a1,a2)
colnames(a3) = c("from", "to", "prob")
write.csv(a3, "C://users//wngud//desktop//link_prediction.csv")
