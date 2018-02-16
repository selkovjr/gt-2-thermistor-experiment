library(reshape2)
library(ggplot2)
library(patchwork)  ##devtools::install_github('thomasp85/patchwork')

sim <- read.table('simulation.tab')
names(sim) <- c('Thermocouple', 'Thermistor', 'Nozzle', 'Heater')

m2 <- read.table('104GT-measurements.2.tab')
names(m2) = c('T', 'R')

m2$T <- m2$T + (m2$T - sim$Thermistor) * 22.8 # Correct for thermal gradient

d <- read.table('gt-2-glass-thermistors.tab', header = TRUE)
md <- melt(d, id.vars = 'T')
names(md) <- c('T', 'Thermistor', 'Resistance')
levels(md$Thermistor) <- sub('X', '', levels(md$Thermistor)) # get rid of the 'X' inserted by melt()

# If measurement columns (m2) were swapped, I could have called this function:
# abc <- ThermistorSteinhartHartCoeffFromMeasurements(transform(m2[c(1, 100, 396), ], R = R * 1000)) # ℃, Ω
#
# Instead, I have copied the code from library(thermocouple) and swapped column indices (,1 and ,2)
# in all references to m3p.
#
m3p <- transform(m2[c(1, 20, 38), ], R = R * 1000)  # pick any three data points and convert kΩ to Ω
b <- 1/(m3p[,1] + 273.15 ) # convert the row of Celsius temperatures to Kelvin
b <- cbind(b)              # make it a column
a <- matrix(c(
  1, log(m3p[1,2]), log(m3p[1,2])^3,
  1, log(m3p[2,2]), log(m3p[2,2])^3,
  1, log(m3p[3,2]), log(m3p[3,2])^3
), 3, 3, byrow = TRUE)
x <- solve(a, b)
abc <- list(A = x[1], B = x[2], C = x[3])
write(sprintf('Steinthart-Hart coefficients, 3-point estimation:                  A = %12.10f, B = %12.10f, C = %12.10f', abc$A, abc$B, abc$C), stderr())


tm <- transform(m2, T = T + 273.15, R = R * 1000) # transformed measurements
sh <- nls(T ~ 1 / (A + B * log(R) + C * log(R) ^ 3), data = tm, start = abc) # K, Ω
abc <- list(A = coef(summary(sh))[1,1], B = coef(summary(sh))[2,1], C = coef(summary(sh))[3,1])
r2 <- sh$m$deviance()
write(sprintf('Steinthart-Hart coefficients, NLS fit to data:                     A = %12.10f, B = %12.10f, C = %12.10f', abc$A, abc$B, abc$C), stderr())

residuals <- data.frame(cbind(tm[,1] - 273.15, predict(sh) - tm[,1]))
names(residuals) <- c('T', 'ΔT')

postscript(file='', command='cat', paper='special', onefile=F, horizontal=F, width=12, height=9, pointsize=8)

# Inverse Steinhart-Hart
model <- function(t) {
  T <- 273.15 + t
  x <- (abc$A - 1 / T) / abc$C
  y <- ((abc$B / (3 * abc$C)) ^ 3 + (x / 2) ^ 2) ^ (1/2)
  0.001 * exp( (y - x / 2) ^ (1/3) - (y + x / 2) ^ (1/3) )
}

m2$model = sapply(m2$T, model, simplify = TRUE)

breaks <- 10**(1:7) / 100
minor_breaks <- rep(seq(2, 8, by = 2), 21) * (10 ^ rep(seq(-10, 10, by = 1), each = 4))

plot1 <- ggplot() +
  geom_line(data = md, aes(T, Resistance, col = Thermistor, linetype = Thermistor), na.rm = TRUE) +
  geom_point(data = m2, mapping = aes(x = T, y = R), size = 0.2) +
  geom_line(data = m2, mapping = aes(x = T, y = model, color='nls fit', linetype = 'nls fit')) +
  scale_y_log10(breaks = breaks, minor_breaks = minor_breaks, labels = c('0.1', '1', '10', '100', '1000', '10000', '100000'), name = bquote(paste('Resistance, k', Omega))) +
  scale_linetype_manual(values=c('102GT' = 1, '103GT' = 1, '104GT' = 1, '105GT' = 1, '202GT' = 1, '203GT' = 1, '204GT' = 1, '502GT' = 1, '503GT' = 1, '504GT' = 1, 'nls fit' = 3), name='Thermistor') +
  xlim(range(md$T)) +
  ggtitle(bquote(paste('Gradient-adjusted 104GT data and nominal ', italic(R(T)), ' for the GT-2 series'))) +
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())

plot2 <- ggplot() +
  geom_point(data = residuals, mapping = aes(x = T, y = ΔT), size = 0.2) +
  scale_y_continuous(breaks = -1.5 + 0.1 * (1:30), name = bquote(paste('Steinhart-Hart residuals ', degree * C))) +
  xlab(expression('Temperature, ' * degree * C)) +
  xlim(range(md$T)) +
  annotate(geom="text", x = Inf, y = Inf, hjust = 1.2, vjust = 1.5, label = paste0('italic(r)^{2}==', sprintf('%.2f', r2)), parse = TRUE)

plot1 + plot2 + plot_layout(ncol = 1, heights = c(3, 1))
