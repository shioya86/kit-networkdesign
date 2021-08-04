import std;
import systems;
import tools;

void main()
{
  const uint flag = 0b000000;

  /* 課題1 */
  writeln("> task1");
  if (flag & 0b000001) runTask1("data/sample1.dat");

  /* 課題1(理論値) */
  writeln("> task2");
  if (flag & 0b000010) runTask2("data/sample2.dat");

  /* 課題2(IPP/M/1/K) */
  writeln("> task3");
  if (flag & 0b000100) runTask3("data/sample3.dat", "data/sample5.dat");
  
  /* 課題2(M/M/1/K) */
  writeln("> task4");
  if (flag & 0b001000) runTask4("data/sample4.dat", "data/sample6.dat");

  /* ex1(alpha_1 可変) */
  writeln("> task5");
  if (flag & 0b010000) runTask5("data/sample7.dat", "data/sample8.dat");

  /* ex2(alpha_2 可変) */
  writeln("> task6");
  if (flag & 0b100000) runTask6("data/sample9.dat","data/sample10.dat");
}


void runTask1(string filename)
{
    ResCalc[] res1;
  for(real i=50_000; i<=serv_rate; i*=1.01)
  {
    res1 ~= calcQueueing(i);
  }

  auto fout1 = File(filename, "w");
  foreach(e; res1)
  {
    auto sample_mean = e.wait_time.calcSampleMean();
    fout1.writefln( "%e %e %e", e.x, sample_mean, calcConfidenceInterval(e.wait_time, sample_mean) );
  }
}


void runTask2(string filename)
{
  ResCalc[] res2;
  for(real i=50_000; i<=serv_rate; i*=1.01)
  {
    const real val = 1.0/( serv_rate*(1.0-i/serv_rate) );
    res2 ~= ResCalc(i/serv_rate, null, [val]);
  }

  auto fout2 = File(filename, "w");
  foreach(e; res2)
  {
    const real sample_mean = e.wait_time.calcSampleMean();
    fout2.writefln( "%e %e", e.x, e.wait_time.calcSampleMean() );
  }
}


void runTask3(string filename1, string filename2)
{
  ResCalc[] res3;
  for(real i=50_000; i<=serv_rate*10; i*=1.1)
  {
    res3 ~= calcIPPQueueing(i, 10, 0.04, 0.04);
  }
  
  auto fout3 = File(filename1, "w");
  auto fout5 = File(filename2, "w");

  foreach(e; res3)
  {
    fout3.writefln("%e %e", e.x, e.wait_time.calcSampleMean() );
    fout5.writefln("%e %e", e.x, e.ploss.calcSampleMean() );
  }
}


void runTask4(string filename1, string filename2)
{
  ResCalc[] res4;
  for(real i=50_000; i<=serv_rate*10; i*=1.1)
  {
    res4 ~= calcQueueing(i, 10);
  }

  auto fout4 = File(filename1, "w");
  auto fout6 = File(filename2, "w");
  foreach(e; res4)
  {
    fout4.writefln("%e %e", e.x, e.wait_time.calcSampleMean() );
    fout6.writefln("%e %e", e.x, e.ploss.calcSampleMean() );
  }
}


void runTask5(string filename1, string filename2)
{
  ResCalc[][] res5_arr;

  foreach(i; [0.04, 0.4, 0.8])
  {
    i.writeln;
    ResCalc[] res5;
    for(real j=50_000; j<=serv_rate*10; j*=1.1)
    {
      res5 ~= calcIPPQueueing(j, 10, i, 0.04);
    }
    res5_arr ~= res5;
  }

  auto fout7 = File(filename1, "w");
  fout7.writeln("# x y1 y2 y3");
  foreach(i; 0..res5_arr[0].length)
  {
    real[] vals;
    foreach(j; 0..res5_arr.length)
    {
      vals ~= res5_arr[j][i].wait_time.calcSampleMean();
    }
    fout7.writefln("%e %s", res5_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }

  auto fout8 = File(filename2, "w");
  fout8.writeln("# x y1 y2 y3");
  foreach(i; 0..res5_arr[0].length)
  {
    real[] vals;
    foreach(j; 0..res5_arr.length)
    {
      vals ~= res5_arr[j][i].ploss.calcSampleMean();
    }
    fout8.writefln("%e %s", res5_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }
}


void runTask6(string filename1, string filename2)
{
  ResCalc[][] res6_arr;

  foreach(i; [0.04, 0.4, 0.8])
  {
    i.writeln;
    ResCalc[] res6;
    for(real j=50_000; j<=serv_rate*10; j*=1.1)
    {
      res6 ~= calcIPPQueueing(j, 10, i, 0.04);
    }
    res6_arr ~= res6;
  }

  auto fout9 = File(filename1, "w");
  fout9.writeln("# x y1 y2 y3");
  foreach(i; 0..res6_arr[0].length)
  {
    real[] vals;
    foreach(j; 0..res6_arr.length)
    {
      vals ~= res6_arr[j][i].wait_time.calcSampleMean();
    }
    fout9.writefln("%e %s", res6_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }

  auto fout10 = File(filename2, "w");
  fout10.writeln("# x y1 y2 y3");
  foreach(i; 0..res6_arr[0].length)
  {
    real[] vals;
    foreach(j; 0..res6_arr.length)
    {
      vals ~= res6_arr[j][i].ploss.calcSampleMean();
    }
    fout10.writefln("%e %s", res6_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }
}