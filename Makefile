all: plot_data plot_gradient

plot_data: measurements.1.png SH-fit.1.png SH-fit.2.png SH-fit.corrected.png

measurements.1.png: 104GT-measurements.1.tab gt-2-glass-thermistors.tab
	cat plot-measurements.r | R --vanilla --slave > tmp.eps
	convert -density 100 -flatten tmp.eps $@
	rm tmp.eps

SH-fit.1.png: 104GT-measurements.1.tab gt-2-glass-thermistors.tab Steinhart-Hart-nls.m1.r
	cat Steinhart-Hart-nls.m1.r | R --vanilla --slave > tmp.eps
	convert -density 100 -flatten tmp.eps $@
	rm tmp.eps

SH-fit.2.png: 104GT-measurements.2.tab gt-2-glass-thermistors.tab Steinhart-Hart-nls.m2.r
	cat Steinhart-Hart-nls.m2.r | R --vanilla --slave > tmp.eps
	convert -density 100 -flatten tmp.eps $@
	rm tmp.eps

SH-fit.corrected.png: 104GT-measurements.2.tab gt-2-glass-thermistors.tab simulation.tab Steinhart-Hart-nls.corrected.r
	cat Steinhart-Hart-nls.corrected.r | R --vanilla --slave > tmp.eps
	convert -density 100 -flatten tmp.eps $@
	rm tmp.eps

plot_gradient: gradient.png

gradient.png: simulation.tab
	cat plot-gradient.r | R --vanilla --slave # png device writes directly to gradient.png
