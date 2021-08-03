set multiplot layout 2, 2
set key left top
set xtics nomirror
set ytics nomirror

set title 'IPP/M/1/K'
set xlabel '利用率ρ'
set ylabel '平均滞在時間/パケット廃棄率'
set logscale x
plot 'data/sample2.dat' with lines

set title 'M/M/1/K'
set xlabel '利用率ρ'
set ylabel '平均滞在時間/パケット廃棄率'
plot 'data/sample3.dat' with lines

set title 'IPP/M/1/KとM/M/1/K'
set xlabel '利用率ρ'
set ylabel '平均滞在時間/パケット廃棄率'
plot 'data/sample2.dat' with lines, 'data/sample3.dat' with lines

set nologscale
unset multiplot