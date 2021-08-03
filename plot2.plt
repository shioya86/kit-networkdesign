set multiplot layout 2, 1
set key left top
set logscale x
set format x "10^{%L}"
plot 'data/sample2.dat' with lines, 'data/sample2.dat' with points notitle
plot 'data/sample3.dat' with lines, 'data/sample3.dat' with points notitle
set nologscale
unset multiplot