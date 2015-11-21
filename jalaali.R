library(ggplot2);
diff = read.csv('leap_diff.tsv', sep="\t");
diff$hrs = diff$diff*24
cycles = read.csv('leap_cycles.tsv', sep="\t");
# Shift the cycles back two years, center brackets
# On the middle of the 5-year cycle
cycles$start = cycles$start - 2;
cycles$end = cycles$end - 2;
# Calculate mids and lengths
cycles$mid = (cycles$start + cycles$end)/2
cycles$len = (cycles$end - cycles$start)
ypos = -0.75*24
ticksize = 0.025*24
png('offset.png',w=1500,h=500);
ggplot() + 
    geom_line(data=diff,aes(year,hrs)) + geom_point(data=diff,aes(year,hrs)) +
    geom_segment(data=cycles, aes(x=start,xend=end,y=ypos,yend=ypos)) +
    geom_segment(data=cycles, aes(x=start,xend=start,y=ypos+ticksize,yend=ypos-ticksize)) +
    geom_segment(data=cycles, aes(x=end,xend=end,y=ypos+ticksize,yend=ypos-ticksize)) +
    geom_text(data=cycles, aes(label=len, x=mid), y=ypos-ticksize) +
    scale_x_continuous(expand=c(0,0)) +
    labs(title="Jalaai Leap Years", x="Jalaai Year", y="Diff Between Solstice and New Year (hours)");
dev.off();
