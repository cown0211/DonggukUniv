
### �Ǽ��� ��Ȯ����
tea = matrix(c(3,1,1,3),nrow=2)

fisher.test(tea)
# ���⼭�� p���� ���������̶� ���纸�� ũ�� ����
# => true odds ratio != 1

fisher.test(tea,alternative='greater')
# ����� ����, p�� 0.2429




# mid-p�� ���� ��Ű��
library(epitools)



ormidp.test(3,1,1,3,or=1)
# or=1 -> odds ratio==1

or.midp(c(3,1,1,3),conf.level=0.95)
# $estimate; odds ratio�� ������
# $conf.int; �ŷڱ���