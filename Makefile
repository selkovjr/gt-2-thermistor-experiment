all: plot-data

plot-data: measurements.png

measurements.png: 104GT-measurements.tab gt-2-glass-thermistors.tab
	cat plot-measurements.r | R --vanilla --slave > measurements.eps
	convert -density 100 -flatten measurements.eps $@
