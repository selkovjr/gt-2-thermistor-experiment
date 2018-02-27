library(ggplot2)


data.nominal_abc <- read.table('nominal-ABC.tab')
data.nominal_rbc <- read.table('nominal-RBC.tab')
data.proxy_1 <- read.table('proxy-1.tab')
data.proxy_2 <- read.table('proxy-2.tab')
data.proxy_zg <- read.table('proxy-zero-gradient.tab')
names(data.nominal_abc) = c('probe', 'setting')
names(data.nominal_rbc) = c('probe', 'setting')
names(data.proxy_1) = c('probe', 'setting')
names(data.proxy_2) = c('probe', 'setting')
names(data.proxy_zg) = c('setting', 'probe')

#postscript(file='', command='cat', paper='special', onefile=F, horizontal=F, width=10, height=4, pointsize=8)
png(filename = 'proxy.png', width = 1200, height = 600, pointsize = 16, bg = "white", res = 120)

ggplot() +
  scale_colour_manual('',
    values = c(rgb(1.0, 0.0, 0.0, 0.8), rgb(0.9, 0.4, 0.4, 0.6), rgb(0.2, 0.7, 0.8, 0.8), rgb(0.0, 0.0, 1.0, 0.6), rgb(0.4, 0.4, 1.0, 0.6)),
    labels = c(
      expression(paste('Nominal ', italic(A), ', ', italic(B), ', ', italic(C))),
      expression(paste('Measured ', italic(R)[25], ', nominal ', italic(B), ' and ', italic(C))),
      expression(paste('Least squares ', italic(A), ', ', italic(B), ', ', italic(C), ', zero gradient assumption')),
      expression(paste('Least squares ', italic(A), ', ', italic(B), ', ', italic(C), ', gradient compensation (test 1)')),
      expression(paste('Least squares ', italic(A), ', ', italic(B), ', ', italic(C), ', gradient compensation (test 2)'))
    )
  ) +
  geom_point(data = data.nominal_abc, mapping = aes(x = probe, y = setting - probe, color = 'a. nominal ABC'), shape = 19, size = 1.5) +
  geom_line(data = data.nominal_abc, mapping = aes(x = probe, y = setting - probe, color = 'a. nominal ABC'), size = 0.5) +
  geom_point(data = data.nominal_rbc, mapping = aes(x = probe, y = setting - probe, color = 'b. nominal RBC'), shape = 19, size = 1.5) +
  geom_line(data = data.nominal_rbc, mapping = aes(x = probe, y = setting - probe, color = 'b. nominal RBC'), size = 0.5) +
  geom_point(data = data.proxy_zg, mapping = aes(x = probe, y = setting - probe, color = 'c. zero gradient'), shape = 19, size = 1.5) +
  geom_line(data = data.proxy_zg, mapping = aes(x = probe, y = setting - probe, color = 'c. zero gradient'), size = 0.5) +
  geom_point(data = data.proxy_1, mapping = aes(x = probe, y = setting - probe, color = 'd. proxy 1'), shape = 19, size = 1.5) +
  stat_smooth(data = data.proxy_1, mapping = aes(x = probe, y = setting - probe, color = 'd. proxy 1'), method = "loess", se = FALSE, size = 0.5) +
  geom_point(data = data.proxy_2, mapping = aes(x = probe, y = setting - probe, color = 'e. proxy 2'), shape = 19, size = 1.5) +
  stat_smooth(data = data.proxy_2, mapping = aes(x = probe, y = setting - probe, color = 'e. proxy 2'), method = "loess", se = FALSE, size = 0.5) +
  xlab(expression('Probe temperature, ' * degree * C)) +
  ylab(expression(italic(T)[setpoint] - italic(T)[probe] * ', ' * degree * C)) +
  ggtitle(bquote(paste('Obesrved proxy deviation from set point'))) +
  theme(legend.position = c(0.025, 0.95), legend.justification=c(0,1), legend.text.align = 0, legend.title = element_blank(), plot.title = element_text(size=10))
