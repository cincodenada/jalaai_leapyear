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

linecol = "blue";
scalecol = "gray30";

png('offset.png',w=1000,h=500);
ggplot() + 
    geom_line(data=diff,aes(year,hrs),color=linecol) + geom_point(data=diff,aes(year,hrs),color=linecol,shape=19) +
    geom_segment(data=cycles, aes(x=start,xend=end,y=ypos,yend=ypos), color=scalecol) +
    geom_segment(data=cycles, aes(x=start,xend=start,y=ypos+ticksize,yend=ypos-ticksize), color=scalecol) +
    geom_segment(data=cycles, aes(x=end,xend=end,y=ypos+ticksize,yend=ypos-ticksize), color=scalecol) +
    geom_text(data=cycles, aes(label=len, x=mid), y=ypos-ticksize*1.5, color=scalecol) +
    scale_y_continuous(expand=c(0,5)) +
    scale_x_continuous(expand=c(0,0), labels = function(y) { paste(y,"\n(",y+621,")",sep="") }) +
    theme_bw() +
    labs(title="Jalaai Leap Years", x="Jalaai Year\n(Gregorian Year)", y="Diff Between Solstice and New Year (hours)") +
    theme(
        panel.grid.major = element_line(color="gray50"),
        panel.border = element_rect(color="black")
    );
dev.off();
