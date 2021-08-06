set key inside left top
set xtics nomirror
set ytics nomirror
set nologscale xy

set title 'M/M/1待ち行列システムの平均滞在時間のシミュレーション'
set xlabel '利用率ρ'
set ylabel '平均滞在時間'
plot [0:0.98][0:0.0003] 'data/sample1.dat' with errorbars  pt 6 ps 0 title "95%信頼区間", \
  'data/sample2.dat' with lines title "理論値"