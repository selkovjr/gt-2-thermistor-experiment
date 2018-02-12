library(ggplot2)


data <- read.table('simulation.tab')
names(data) = c('probe', 'thermistor', 'nozzle', 'heater')

func <- function(x) 108.2518 * exp( -1744.688 / (x + 82.16401) ) - 4.782322e-05

#postscript(file='', command='cat', paper='special', onefile=F, horizontal=F, width=10, height=4, pointsize=8)
png(filename = 'gradient.png', width = 1200, height = 600, pointsize = 16, bg = "white", res = 120)

ggplot() +
  stat_function(fun = func, data = data, mapping = aes(x = probe, y = func(probe), color = 'best fit'), show.legend = FALSE) +
  scale_colour_manual('', values = c('gray', rgb(1, 0.2, 0.2, 0.6))) +
  geom_point(data = data, mapping = aes(x = probe, y = 0.0001 + probe - thermistor), size = 0.5) +
  xlab(expression('Probe temperature, ' * degree * C)) +
  ylab(expression(italic(T)[probe] - italic(T)[thermistor] * ', ' * degree * C)) +
  theme(legend.position = c(0.046, 0.895), legend.justification=c(0,1), legend.text.align = 0)

#  ggtitle(bquote(paste('Temperature dependence of probe-thermistor gradient')))
