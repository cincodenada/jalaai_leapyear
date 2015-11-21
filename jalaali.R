library(ggplot2);
library(grid);
library(scales);
diff = read.csv('leap_diff.tsv', sep="\t");
# Convert to hours and adjust for Tehran time (UTC + 3.425 hrs)
diff$hrs = diff$diff*24 + 3.425
cycles = read.csv('leap_cycles.tsv', sep="\t");
# Shift the cycles back two years, center brackets
# On the middle of the 5-year cycle
cycles$start = cycles$start - 2;
cycles$end = cycles$end - 2;
# Calculate mids and lengths
cycles$mid = (cycles$start + cycles$end)/2
cycles$len = (cycles$end - cycles$start)
ypos = -14
ticksize = 1

linecol = "blue";
scalecol = "gray30";
scalesize = 0.3;

#png('offset.png',w=1000,h=500);
svg('offset.svg');
ggplot() +
    geom_line(data=diff,aes(year,hrs),color=linecol,size=0.25) + geom_point(data=diff,aes(year,hrs),color=linecol,shape=19, size=0.9) +
    geom_segment(data=cycles, aes(x=start,xend=end,y=ypos,yend=ypos), color=scalecol, size=scalesize) +
    geom_segment(data=cycles, aes(x=start,xend=start,y=ypos+ticksize,yend=ypos), color=scalecol, size=scalesize) +
    geom_segment(data=cycles, aes(x=end,xend=end,y=ypos+ticksize,yend=ypos), color=scalecol, size=scalesize) +
    geom_text(data=cycles, aes(label=len, x=mid), y=ypos-ticksize*1.25, color=scalecol, size=3) +
    scale_y_continuous(expand=c(0,5)) +
    scale_x_continuous(
        expand=c(0,0),
        minor_breaks = pretty_breaks(5*4),
        labels = function(y) { paste(y,"\n(",y+621,")\n",sep="") }
    ) +
    theme_bw() +
    labs(title=expression(bold("Jalaai Leap Years\n")), x="Jalaai Year\n(Gregorian Year)", y="Diff Between Solstice and New Year (hours)\n") +
    theme(
        text = element_text(size=8),
        aspect.ratio = 1/2.5,
        panel.grid.major = element_line(color="gray60"),
        panel.grid.minor = element_line(color="gray90",size=0.1),
        panel.border = element_rect(color="black"),
        plot.margin = unit(c(24,12,12,12), "points")
    );
dev.off();
