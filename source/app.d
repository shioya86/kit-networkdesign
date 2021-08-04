import std;
import systems;
import tools;

void main()
{

  /* 課題1 */
  writeln("> task1");
  ResCalc[] res1;
  for(real i=50_000; i<=serv_rate; i*=1.01)
  {
    res1 ~= calcQueueing(i);
  }


  /* 課題1(理論値) */
  writeln("> task2");
  ResCalc[] res2;
  for(real i=50_000; i<=serv_rate; i*=1.01)
  {
    real val = 1.0/( serv_rate*(1.0-i/serv_rate) );
    res2 ~= ResCalc(i/serv_rate, null, [val]);
  }


  /* 課題2(IPP/M/1/K) */
  ResCalc[] res3;
  writeln("> task3");
  for(real i=50_000; i<=serv_rate*10; i*=1.1)
  {
    res3 ~= calcIPPQueueing(i, 10, 0.3, 0.2);
  }
  

  /* 課題2(M/M/1/K) */
  writeln("> task4");
  ResCalc[] res4;
  for(real i=50_000; i<=serv_rate*10; i*=1.1)
  {
    res4 ~= calcQueueing(i, 10);
  }

  /* M/M/1待ち行列の出力 */
  writeln("> task5");
  auto fout1 = File("data/sample1.dat", "w");
  foreach(e; res1)
  {
    auto sample_mean = e.wait_time.calcSampleMean();
    fout1.writefln( "%e %e %e", e.x, sample_mean, calcConfidenceInterval(e.wait_time, sample_mean) );
  }

  /* M/M/1待ち行列理論値の出力 */
  auto fout2 = File("data/sample2.dat", "w");
  foreach(e; res2)
  {
    const real sample_mean = e.wait_time.calcSampleMean();
    fout2.writefln( "%e %e", e.x, e.wait_time.calcSampleMean() );
  }

  /* IPP/M/1/Kの比較(平均滞在時間/パケット廃棄率) */
  auto fout3 = File("data/sample3.dat", "w");

  foreach(e; res3)
  {
    fout3.writefln("%e %e", e.x, e.wait_time.calcSampleMean()/e.ploss.calcSampleMean() );
  }


  auto fout4 = File("data/sample4.dat", "w");

  foreach(e; res4)
  {
    fout4.writefln("%e %e", e.x, e.wait_time.calcSampleMean()/e.ploss.calcSampleMean() );
  }
  /* IPP/M/1/Kの比較(平均滞在時間) */

  auto fout5 = File("data/sample5.dat", "w");

  foreach(e; res3)
  {
    fout5.writefln("%e %e", e.x, e.wait_time.calcSampleMean() );
  }


  auto fout6 = File("data/sample6.dat", "w");

  foreach(e; res4)
  {
    fout6.writefln("%e %e", e.x, e.wait_time.calcSampleMean() );
  }

  /* IPP/M/1/Kの比較(パケット廃棄率) */
    auto fout7 = File("data/sample7.dat", "w");

  foreach(e; res3)
  {
    fout7.writefln("%e %e", e.x, e.ploss.calcSampleMean() );
  }


  auto fout8 = File("data/sample8.dat", "w");

  foreach(e; res4)
  {
    fout8.writefln("%e %e", e.x, e.ploss.calcSampleMean() );
  }
}
