set multiplot layout 2, 1
set key left top
set xtics nomirror
set ytics nomirror
set title 'M/M/1待ち行列システムの平均滞在時間のシミュレーション'
set xlabel '利用率ρ'
set ylabel '平均滞在時間と95%信頼区間'
plot 'data/sample1.dat' with errorbars  pt 6 ps 0, 'data/sample1.dat' with lines notitle

set title 'M/M/1待ち行列システムの平均滞在時間の理論値'
set xlabel '利用率ρ'
set ylabel 'E[T]'
plot 'data/theor1.dat' with lines
unset multiplot