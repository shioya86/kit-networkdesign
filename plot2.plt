set multiplot layout 2, 1
set key left top
set logscale x
set format x "10^{%L}"
plot 'data/sample3.dat' with lines, 'data/sample3.dat' with points
set nologscale
unset multiplot