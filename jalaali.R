library(ggplot2);
data = read.csv('jdate.tsv', sep="\t", head=F, col.names=c('jyear','equinox'));
png('offset.png',w=1500,h=500);
ggplot(data,aes(x=jyear,y=equinox)) + geom_line() + geom_point() + scale_y_reverse();
dev.off();
