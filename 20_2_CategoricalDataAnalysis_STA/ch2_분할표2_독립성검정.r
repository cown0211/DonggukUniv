
### ����ǥ ������ ����
Political=read.table("http://www.stat.ufl.edu/~aa/cat/data/Political.dat", header=T)
str(Political)
head(Political,10)


# �� �����͸� ����ǥ �������� ��ȯ
party=factor(Political$party, levels=c("Dem","Rep","Ind"))
GenderGap=xtabs(~gender+party, data=Political)


# �Ǿ ī����������
chisq.test(GenderGap) # ����ǥ�� ����
# ������ ���������� �����̶�� �͹����� �Ⱒ

chisq.test(GenderGap)$observed # ��������
chisq.test(GenderGap)$expected # �͹�����(�����̶�� ����) ���� ��밪
chisq.test(GenderGap)$residuals # �Ǿ����
stdres=chisq.test(GenderGap)$stdres # ǥ��ȭ����


# ������ũ �׸�
install.packages('vcd')
library(vcd)
mosaic(GenderGap, gp=shading_Friendly, residuals=stdres, residuals_type='Std\nresiduals', labeling=labeling_residuals)
# ������ ����ǥ, ����, ������ ����, ���ʸ� ǥ��, ĭ�� ������ ǥ��
# ������ ������ ���(���Ҽ��� �� ����)
# ������ +- ���� -> ������ ĥ�����ٸ� ���̰� ������
















### ������ �ڷ��� ������ ����

Malform=matrix(c(17066,14464,788,126,37,48,38,5,1,1),ncol=2)
# ������ �߻��� ���

install.packages('vcdExtra')
library(vcdExtra)

# �߼�����
CMHtest(Malform, rscores=c(0,0.5,1.5,4.0,7.0))
# rscores; �Һ� ����ȭ
# cor Nonzero correlation; �븳����:corr

M = sqrt(6.5699) # M ��跮 ~ N(0,1)
1-pnorm(M) # H0 : theta>1 => ����� ����; M ��跮�� ���� p��



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