library(ggplot2)


data <- read.table('simulation.tab')
names(data) = c('probe', 'thermistor', 'nozzle', 'heater')

bf_func <- function(x) 108.2518 * exp( -1744.688 / (x + 82.16401) ) - 4.782322e-05 # best-fitting
func <- function(x) 4231.441 * exp( -4659.264 / (x + 273.15) ) - 0.00580773 # realistic

#postscript(file='', command='cat', paper='special', onefile=F, horizontal=F, width=10, height=4, pointsize=8)
png(filename = 'gradient.png', width = 1200, height = 600, pointsize = 16, bg = "white", res = 120)

ggplot() +
  stat_function(fun = func, data = data, mapping = aes(x = probe, y = func(probe), color = 'realistic')) +
  stat_function(fun = bf_func, data = data, mapping = aes(x = probe, y = func(probe), color = 'best fit')) +
  scale_colour_manual('Approximation', values = c('gray', rgb(1, 0.2, 0.2, 0.6)), labels = c(expression(paste(108 %.% italic(e) ^ bgroup("(", frac( scriptstyle(-1745), scriptstyle(italic(T) + 82)), ")") - 0.0000478, ' (best fit)')), expression(paste(4231 %.% italic(e) ^ bgroup("(", frac( scriptstyle(-4659), scriptstyle(italic(T) + 273.15)), ")") - 0.0058, ' (realistic)')))) +
  geom_point(data = data, mapping = aes(x = probe, y = 0.0001 + probe - thermistor), size = 0.5) +
  xlab(expression('Probe temperature, ' * degree * C)) +
  ylab(expression(italic(T)[probe] - italic(T)[thermistor] * ', ' * degree * C)) +
  theme(legend.position = c(0.046, 0.895), legend.justification=c(0,1), legend.text.align = 0)

#  ggtitle(bquote(paste('Temperature dependence of probe-thermistor gradient')))
