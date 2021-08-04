set multiplot layout 2, 2
set key right bottom
set xtics nomirror
set ytics nomirror
set logscale x

set title '平均滞在時間/パケット廃棄率の比較'
set xlabel '利用率ρ'
set ylabel '平均滞在時間/パケット廃棄率'
plot 'data/sample3.dat' with lines title 'IPP/M/1/K', 'data/sample4.dat' with lines title 'M/M/1/K'

set title '平均滞在時間の比較'
set xlabel '利用率ρ'
set ylabel '平均滞在時間'
plot 'data/sample5.dat' with lines title 'IPP/M/1/K', 'data/sample6.dat' with lines title 'M/M/1/K'

set title 'パケット廃棄率の比較'
set xlabel '利用率ρ'
set ylabel 'パケット廃棄率'
plot 'data/sample7.dat' with lines title 'IPP/M/1/K', 'data/sample8.dat' with lines title 'M/M/1/K'


set nologscale
unset multiplot