
sim=10^4
n=10
#simulation
x=1:n
y=c()
y=matrix(ncol=n,nrow=sim)
for (j in 1:sim){
  for (i in 1:length(x)){
    y[j,i] = 2+3*x[i]+rnorm(1,0,sd=1)
  }
}

#plot 2pictures together
par(mfrow=c(1,2))

##a
#scatter plot
plot(x,y[1,],main='(a) \n Yi~2+3*Xi+Ei , Ei~N(0,1)',xlim=c(-1,12),ylim=c(0,35),ylab='Y',pch=20)
#draw true trend
lines(x,2+3*x,lwd=2,col='red')
#draw reg line
fit=lm(y[1,]~x)
pred=predict(fit,newdata=data.frame(x), se.fit = TRUE)
lines(x,pred$fit,lwd=2,col='grey')
predict(fit,newdata=data.frame(x),interval='confidence', se.fit = TRUE)

#ci for y_hat
ci_high=pred$fit + (pred$se.fit)*qt(0.975,df=n-2)
ci_low=pred$fit - (pred$se.fit)*qt(0.975,df=n-2)
lines(x,ci_low,lwd=2,col='green4')
lines(x,ci_high,lwd=2,col='green4')
#legend
legend('topleft',legend=c('true trend','regression line','95% CI for Y_hat'),
      col=c('red','grey','green4'),lwd=2,lty=1,cex=0.75)

##(b)
#draw true trend
plot(x,2+3*x,lwd=2,col='red',type='l',main='(b) \n Yi~2+3*Xi+Ei , Ei~N(0,1)',xlim=c(-1,12),ylim=c(0,35),ylab='Y')
#draw first reg line
fit=lm(y[1,]~x)
pred=predict(fit,newdata=data.frame(x=-1:12), se.fit = TRUE)
y_hat=matrix(pred$fit,ncol=14)
lines(x,pred$fit[3:12],lwd=0.1,col='grey')
#draw other reg line
for(i in 2:nrow(y)){
  fit=lm(y[i,]~x)
  pred=predict(fit,newdata=data.frame(x=-1:12), se.fit = TRUE)
  y_hat=rbind(y_hat,pred$fit)
  lines(x,pred$fit[3:12],lwd=0.1,col='grey')
}
#draw true trend again...
lines(x,2+3*x,lwd=2,col='red')


#ci by simulation matrix
ci_sim=matrix(ncol=2,nrow=ncol(y_hat))
for(i in 1:ncol(y_hat)){
  ci_sim[i,]=quantile(y_hat[,i],c(0.025,0.975))
}

#draw ci by simulation
lines(-1:12,ci_sim[,1],col='green4',lwd=2)
points(-1:12,ci_sim[,1],col='green')
lines(-1:12,ci_sim[,2],col='green4',lwd=2)
points(-1:12,ci_sim[,2],col='green')

#horizental line
abline(v=c(1,10),lty='dotted')

legend('topleft',legend=c('true trend','regression','95% CI for Y_hat by simulation'),
       col=c('red','grey','green4'),lwd=2,lty=1,cex=0.75)

