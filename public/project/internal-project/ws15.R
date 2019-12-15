newdat<-features
newdat$count.max.duplicates<-c(seq(0,60,length.out=154),mean(features$count.max.duplicates))
newdat$Is.Human<-rep("Yes",length(newdat$Is.Human))
newdat$pred1<-predict(model,newdat)
newdat$Is.Human<-rep("No",length(newdat$Is.Human))
newdat$pred2<-predict(model,newdat)
med$count.max.duplicates_c<-features$count.max.duplicates_c

ggplot(features, aes(x = count.max.duplicates, y = num.consecutive)) +
    geom_point() + geom_line(data = newdat, aes(y = pred1),color='blue' ) +
    geom_line(data = newdat, aes(y = pred2),color='red' )+scale_x_continuous(limits=c(0,57))+geom_vline(xintercept=0,lty=2,color='yellow')+geom_vline(xintercept=mean(features$count.max.duplicates),lty=2,color='yellow')+annotate("text",7,45,label="No - Yes = -1.597")+geom_segment(x=5,xend=.2,y=46,yend=50)+geom_segment(x=32.9,xend=45,y=71.5,yend=60)+annotate("text",45,59,label="No - Yes = 1.153")+geom_segment(aes(x=0, xend=0, y=pred2[count.max.duplicates==0],yend=pred1[count.max.duplicates==0]),data=newdat,color="green")+geom_segment(aes(x=mean(features$count.max.duplicates), xend=mean(features$count.max.duplicates), y=pred2[count.max.duplicates==mean(features$count.max.duplicates)],yend=pred1[count.max.duplicates==mean(features$count.max.duplicates)]),data=newdat,color="green")