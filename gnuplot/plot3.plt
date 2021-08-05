set multiplot layout 2, 1
set key outside right
set xtics nomirror
set ytics nomirror
set logscale x

set title '平均滞在時間の比較'
set xlabel '利用率ρ'
set ylabel '平均滞在時間'
plot \
  'data/sample3.dat' with lines title 'α1=0.4', \
  'data/sample7.dat' using 1:2 with lines title 'α1=0.4', \
  'data/sample7.dat' using 1:3 with lines title 'α1=0.8', \
  'data/sample4.dat' with points title 'M/M/1/K'

set title 'パケット廃棄率の比較'
set xlabel '利用率ρ'
set ylabel 'パケット廃棄率'

plot \
  'data/sample5.dat' with lines title 'α1=0.04', \
  'data/sample8.dat' using 1:2 with lines title 'α1=0.4', \
  'data/sample8.dat' using 1:3 with lines title 'α1=0.8', \
  'data/sample6.dat' with points title 'M/M/1/K'
set nologscale
unset multiplot