library(ggplot2)
library(reshape2)


m <- read.table('104GT-measurements.tab')
names(m) = c('T', 'r')

d <- read.table('gt-2-glass-thermistors.tab', header = TRUE)
md <- melt(d, id.vars = 'T')
names(md) <- c('T', 'Thermistor', 'Resistance')
levels(md$Thermistor) <- sub('X', '', levels(md$Thermistor)) # get rid of the 'X' inserted by melt()

postscript(file='', command='cat', paper='special', onefile=F, horizontal=F, width=10, height=8, pointsize=8)

ggplot() +
  geom_line(data = md, aes(T, Resistance, col=Thermistor), na.rm = TRUE) +
  geom_point(data = m, mapping = aes(x = T, y = r), size = 0.2) +
  scale_y_log10(breaks = 10**(1:7) / 100, labels = c('0.1', '1', '10', '100', '1000', '10000', '100000'), name = bquote(paste('Resistance, k', Omega))) +
  xlab(expression('Temperature, ' * degree * C)) +
  ggtitle(bquote(paste('Measured 104GT data and nominal ', italic(R(T)), ' for the GT-2 series')))
