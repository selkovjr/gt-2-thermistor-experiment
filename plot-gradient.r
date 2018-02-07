library(ggplot2)
library(reshape2)


data <- read.table('simulation.tab')
names(data) = c('probe', 'thermistor', 'nozzle', 'heater')

bf_func <- function(x) 108.2518 * exp( -1744.688 / (x + 82.16401) ) - 4.782322e-05
func <- function(x) 5447.376 * exp( -4796.171 / (x + 273.15) )

postscript(file='', command='cat', paper='special', onefile=F, horizontal=F, width=10, height=4, pointsize=8)

ggplot() +
  geom_point(data = data, mapping = aes(x = probe, y = 0.0001 + probe - thermistor), size = 0.2) +
  stat_function(fun = func, data = data, mapping = aes(x = probe, y = func(probe))) +
  stat_function(fun = bf_func, data = data, mapping = aes(x = probe, y = func(probe))) +
  xlab(expression('Probe temperature, ' * degree * C)) +
  #scale_y_log10(breaks = 10**(1:5) / 100000, labels = c('0.0001', '0.001', '0.01', '0.1', '1'), name = bquote(paste('Resistance, k', Omega))) +
  ggtitle(bquote(paste('Temperature dependence of probe-thermistor gradient')))
