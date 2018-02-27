library(ggplot2)


data <- read.table('simulation.tab')
names(data) = c('probe', 'thermistor', 'nozzle', 'heater')

data_h <- read.table('simulation.heatsink.tab')
names(data_h) = c('probe', 'thermistor', 'nozzle', 'heater')

#postscript(file='', command='cat', paper='special', onefile=F, horizontal=F, width=10, height=4, pointsize=8)
png(filename = 'gradient.heatsink.png', width = 1200, height = 600, pointsize = 16, bg = "white", res = 120)

ggplot() +
  scale_colour_manual('',
    values = c(rgb(0.4, 0.6, 0.2, 0.6), rgb(0.9, 0.2, 0.3, 0.6)),
    labels = c('lucky strike', "fool's errand")
  ) +
  geom_point(data = data_h, mapping = aes(x = probe, y = 0.0001 - 0.15 * (probe - thermistor), color = 'b'), shape = 19, size = 1.5) +
  stat_smooth(data = data_h, mapping = aes(x = probe, y = 0.0001 - 0.15 * (probe - thermistor), color = 'b'), method = "loess", se = FALSE, size = 0.5) +
  geom_point(data = data, mapping = aes(x = probe, y = 0.0001 + probe - thermistor, color = 'a'), shape = 19, size = 1.5) +
  stat_smooth(data = data, mapping = aes(x = probe, y = 0.0001 + probe - thermistor, color = 'a'), method = "loess", se = FALSE, size = 0.5) +
  xlab(expression('Probe temperature, ' * degree * C)) +
  ylab(expression(italic(T)[probe] - italic(T)[thermistor] * ', ' * degree * C)) +
  ggtitle(bquote(paste('Modeled probe-thermistor gradient, with heatsink'))) +
  theme(legend.position = c(0.046, 0.895), legend.justification=c(0,1), legend.text.align = 0, legend.title = element_blank(), plot.title = element_text(size=10))
