# kyutech-netdesign
2021年ネットワークデザイン特論の最終課題


## M/M/1 待ち行列システムのシミュレーション
M/M/1 待ち行列システムの平均滞在時間 <img src="https://latex.codecogs.com/gif.latex?\bar{w}(n)" /> および,
真の平均滞在時間　<img src="https://latex.codecogs.com/gif.latex?\hat{w}" /> の **95\%信頼区間** を求める
シミュレーションプログラムを作成する.

- シミュレーション方式: Single-run 法
- 標本区間長: 100,000(パケット), 標本個数n: 10
- サービス率<img src="https://latex.codecogs.com/gif.latex?\mu=100,000" />


(※ 回線帯域: 1Gb/s, 平均パケット長: 1,250バイト → 平均処理時間 <img src="https://latex.codecogs.com/gif.latex?1/\mu=10us" />と仮定)

以上の条件のもと, <img src="https://latex.codecogs.com/gif.latex?\bar{w}(n)" />, 95\%信頼区間と利用率<img src="https://latex.codecogs.com/gif.latex?\rho" />
の関係を図示する.
その際, 待ち行列理論から解析的に求まる値(式(38))と比較, 考察する.
<p align="center">
  <img src="img/sample1.png">
</p>

## IPP/M/1/K 待ち行列システムのシミュレーション
パケットの到着に関する確率仮定がパラメータ(<img src="https://latex.codecogs.com/gif.latex?\lambda_{ON},\alpha_1,\alpha_2" />)
の **IPP(Interrupted Poisson Process)** に従う場合を考える. この過程の概要は以下の通りである.

- ある時点において, 到着に関してON, OFFのどちらかの状態をとる.
  - ON状態の場合, パケットの到着はパラメータ<img src="https://latex.codecogs.com/gif.latex?\lambda_{ON}" />のポアソン過程に従う.
  - OFF状態の場合, パケット到着はないものとする.
- ある時点の状態変化は ON(OFF) にある場合, パラメータ<img src="https://latex.codecogs.com/gif.latex?\alpha_1(\alpha_2)" />でOFF(ON)に遷移する.
  - 平均ON(OFF)区間は, <img src="https://latex.codecogs.com/gif.latex?1/\alpha_1(1/\alpha_2)" />となる.
 
本システムにおいて以下を実現する.

(a) 平均滞在時間/パケット廃棄率を導出するシミュレーションプログラムの作成

(b) M/M/1/K システムとの性能比較について, **各自適当に課題を設定してデータ取得, 考察**. なおポアソン過程のパラメータ
<img src="https://latex.codecogs.com/gif.latex?\lambda" /> と, IPPの平均トラヒック量<img src="https://latex.codecogs.com/gif.latex?\bar{\lambda}" />
は等しくする. すなわち,
<p align="center">
  <img  src="https://latex.codecogs.com/gif.latex?\lambda=\bar{\lambda}=\lambda_{ON}\times\frac{1/\alpha_1}{1/\alpha_1+1/\alpha_2}=\frac{\lambda_{ON}\alpha_2}{\alpha_1+\alpha_2}" />
</p>

### 利用率を変化させたときの平均滞在時間, パケット廃棄率の比較
<p align="center">
  <img src="img/sample2.png">
</p>

### α1をパラメータとしたときの利用率変化時の比較
<p align="center">
  <img src="img/sample3.png">
</p>

### α2をパラメータとしたときの利用率変化時の比較
<p align="center">
  <img src="img/sample4.png">
</p>

### IPP/M/1/K のKをパラメータとしたときの利用率変化時の比較
<p align="center">
  <img src="img/sample5.png">
</p>
