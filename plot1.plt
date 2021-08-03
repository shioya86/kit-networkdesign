set multiplot layout 2, 1
set key left top
set logscale x
set format x "10^{%L}"
plot 'data/sample1.dat' with errorbars pt 6 ps 0, 'data/sample1.dat' with lines notitle
plot 'data/theor1.dat' with points, 'data/theor1.dat' with lines notitle
set nologscale
unset multiplot