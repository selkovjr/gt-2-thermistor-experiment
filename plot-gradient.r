library(ggplot2)


data <- read.table('simulation.tab')
names(data) = c('probe', 'thermistor', 'nozzle', 'heater')

func <- function(x) 108.2518 * exp( -1744.688 / (x + 82.16401) ) - 4.782322e-05

#postscript(file='', command='cat', paper='special', onefile=F, horizontal=F, width=10, height=4, pointsize=8)
png(filename = 'gradient.png', width = 1200, height = 600, pointsize = 16, bg = "white", res = 120)

ggplot() +
  stat_function(fun = func, data = data, mapping = aes(x = probe, y = func(probe), color = 'b'), show.legend = FALSE) +
  scale_colour_manual('',
    values = c(rgb(0.4, 0.6, 0.2, 0.6), rgb(0.4, 0.6, 0.2, 0.6))
  ) +
  geom_point(data = data, mapping = aes(x = probe, y = 0.0001 + probe - thermistor, color = 'a'), shape = 19, size = 1.5) +
  xlab(expression('Probe temperature, ' * degree * C)) +
  ylab(expression(italic(T)[probe] - italic(T)[thermistor] * ', ' * degree * C)) +
  ggtitle(bquote(paste('Modeled probe-thermistor gradient'))) +
  theme(legend.position = 'none', plot.title = element_text(size=10))
