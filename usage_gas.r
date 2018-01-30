postscript(file="", command="cat", paper="special", onefile=F, horizontal=F, width=8, height=6, pointsize=8)
d <- read.table("usage_gas.tab", sep='\t')
t <- na.omit(d)
d$V1 <- as.Date(d$V1, "%y/%m/%d")
plot(d$V1, d$V2, main="Daily gas consumption", ylab=expression(100 %*% ft^3), xlab="", xaxt="n", type="S")
lines(lowess(d$V1, d$V2, f=0.2, iter=0), lwd=2)
abline(h=mean(d$V2), lty=2)
r <- as.Date(range(d$V1))
dates <- seq(as.Date("08/02/01", "%y/%m/%d"), r[2], by="month")
axis.Date(1, at=dates, format="%b", labels=T)
dates <- seq(as.Date("08/02/03", "%y/%m/%d"), r[2], by="week")
axis.Date(1, at=dates, format="%m/%d", labels=F, tck=0.02)
dates <- seq(as.Date("08/02/03", "%y/%m/%d"), r[2], by="day")
axis.Date(1, at=dates, format="%m/%d", labels=F, tck=0.01)

par(new = TRUE)
plot(lowess(t$V1, (t$V3 + t$V4)/2, f=0.05, iter=1), lwd=2, axes = FALSE, bty = "n", xlab = "", ylab = "")

calorific_value <- 39.8478
tariff <- 0.07149
conv_factor <- 1.02264
conv_metric <- 2.83
legend("topleft",
       bty="n",
       cex=0.6,
       legend=c(
         parse(text=paste(
                 sprintf("%4.2f", mean(d$V2)),
                 " %*% ",
                 sprintf("%4.2f", conv_metric),
                 " %*% over(",
                 sprintf("%6.4f", tariff),
                 " %.% ",
                 sprintf("%6.4f", conv_factor),
                 " %.% ",
                 sprintf("%7.4f", calorific_value),
                 ", 3.6) == ",
                 sprintf("%4.2f", tariff * conv_factor * conv_metric * calorific_value * mean(d$V2)/3.6),
                 " ~~ italic(GBP/day)",
                 sep="")),
         parse(text=paste(
                 sprintf("%4.2f", mean(d$V2)),
                 " %*% ",
                 sprintf("%4.2f", conv_metric),
                 " %*% ",
                 sprintf("%4.2f", conv_factor),
                 " %*% over(",
                 sprintf("%4.1f", calorific_value),
                 ", 3.6) == ",
                 sprintf("%4.2f", calorific_value * conv_factor * conv_metric * mean(d$V2)/3.6),
                 " ~~ italic(kWh/day)",
                 sep=""))
         ),
       )

