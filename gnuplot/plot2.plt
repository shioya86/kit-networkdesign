set multiplot layout 2, 1
set key inside left
set xtics nomirror
set ytics nomirror
set logscale x

set title '平均滞在時間の比較'
set xlabel '利用率ρ'
set ylabel '平均滞在時間'
plot 'data/sample3.dat' with lines title 'IPP/M/1/K', \
  'data/sample3.dat' with points notitle, \
  'data/sample4.dat' with lines title 'M/M/1/K', \
  'data/sample4.dat' with points notitle

set title 'パケット廃棄率の比較'
set xlabel '利用率ρ'
set ylabel 'パケット廃棄率'

plot 'data/sample5.dat' with lines title 'IPP/M/1/K', \
  'data/sample5.dat' with points notitle, \
  'data/sample6.dat' with lines title 'M/M/1/K', \
  'data/sample6.dat' with points notitle

set nologscale
unset multiplot