# GT-2 thermistor experiment

**How good is this thermistor?**

Thanks to [David Crocker](https://github.com/dc42) who has identified it from my vauge description, now I at least know what it was supposed to be like. It is a 104GT glass thermistor by ATC Semitec). The codename obviously means *"an (approximately) 100k&Omega; Glass Thermistor"*. This is how we know:

![measured data](SH-fit.1.png)

```
Steinthart-Hart coefficients, 3-point estimation:                  A = 0.0008149464, B = 0.0002077971, C = 0.0000000996
Steinthart-Hart coefficients, NLS fit to data:                     A = 0.0008235063, B = 0.0002046960, C = 0.0000001247
```

The colored lines are [resistance-temeperature tables](https://github.com/selkovjr/gt-2-thermistor-experiment/blob/master/gt-2-glass-thermistors.tab) from [ATC Semitec's product leaflet](http://www.atcsemitec.co.uk/gt-2-glass-thermistors.html); black dots are the measurements I took from the thermistor I received with the [BiQu Diamond Hotend](https://www.biqu.equipment/products/diamond-3d-printer-extruder-reprap-hotend-3d-v6-heatsink-3-in-1-out-multi-nozzle-extruder-prusa-i3-kit-for-1-75-0-4mm) I bought on eBay.

While the data points from the first experiment appear to straddle the nominal curve for 104GT pretty nicely, the Steinhart-Hart model residuals reveal a flaw in this experiment.

```
Steinthart-Hart coefficients, 3-point estimation:                  A = 0.0008387813, B = 0.0001983343, C = 0.0000001545
Steinthart-Hart coefficients, NLS fit to data:                     A = 0.0008401263, B = 0.0001971350, C = 0.0000001683
```
