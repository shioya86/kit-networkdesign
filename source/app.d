import std;
import systems;


void main()
{

  /* 課題1 */
  writeln("> task1");
  auto fout = File("data/sample1.dat", "w");
  for(real i=50_000; i<=serv_rate; i*=1.01)
  {
    fout.writeln( calcQueueing(RET_FLAGS.WAIT_TIME_CONFINTERV, i) );
  }


  /* 課題1(理論値) */
  writeln("> task2");
  auto fout2 = File("data/sample2.dat", "w");
  for(real i=50_000; i<=serv_rate; i*=1.01)
  {
    const real val = 1.0/( serv_rate*(1.0-i/serv_rate) );
    fout2.writeln( format("%e %e", i/serv_rate, val) );
  }


  /* 課題2(IPP/M/1/K) */
  writeln("> task3");
  auto fout3 = File("data/sample3.dat", "w");
  for(real i=50_000; i<=serv_rate*10; i*=1.1)
  {
    fout3.writeln( calcIPPQueueing(i, 10, 0.3, 0.2) );
  }
  

  /* 課題2(M/M/1/K) */
  writeln("> task4");
  auto fout4 = File("data/sample4.dat", "w");
  for(real i=50_000; i<=serv_rate*10; i*=1.1)
  {
    fout4.writeln( calcQueueing(RET_FLAGS.WAIT_TIME_PER_PLOSS, i, 10) );
  }
}
