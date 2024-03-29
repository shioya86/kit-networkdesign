import std;
import systems;
import tools;

void main()
{
  const uint flag = 0b1111111;

  /* 課題1 */
  if (flag & 0b1000000)
  {
    writeln("> task1");
    runTask1("data/sample1.dat");
  } 

  /* 課題1(理論値) */
  if (flag & 0b0000010)
  {
    writeln("> task2");
    runTask2("data/sample2.dat");
  }

  /* 課題2(IPP/M/1/K) */
  if (flag & 0b0000100)
  {
    writeln("> task3");
    runTask3("data/sample3.dat", "data/sample5.dat");
  }
  
  /* 課題2(M/M/1/K) */
  if (flag & 0b0001000)
  {
    writeln("> task4");
    runTask4("data/sample4.dat", "data/sample6.dat");
  } 

  /* ex1(alpha_1 可変) */
  if (flag & 0b0010000)
  {
    writeln("> task5");
    runTask5("data/sample7.dat", "data/sample8.dat");
  }

  /* ex2(alpha_2 可変) */
  if (flag & 0b0100000)
  {
    writeln("> task6");
    runTask6("data/sample9.dat", "data/sample10.dat");
  } 

  /* ex3(バッファサイズ可変) */
  if (flag & 0b1000000)
  {
    writeln("> task7");
    runTask7("data/sample11.dat", "data/sample12.dat");
  } 
}


void runTask1(string filename)
{
    ResCalc[] res;
  for(real i=0; i<=1; i+=0.05)
  {
    res ~= calcQueueing(serv_rate*i);
  }

  auto fout = File(filename, "w");
  foreach(e; res)
  {
    auto sample_mean = e.wait_time.calcSampleMean();
    fout.writefln( "%e %e %e", 
      e.x, 
      sample_mean, 
      calcConfidenceInterval(e.wait_time, sample_mean) );
  }
}


void runTask2(string filename)
{
  ResCalc[] res;
  for(real i=0; i<=1.0; i+=0.01)
  {
    const real val = 1.0/( serv_rate*(1-i) );
    if(val==real.nan) break;
    res ~= ResCalc(i, null, [val]);
  }

  auto fout = File(filename, "w");
  foreach(e; res)
  {
    const real sample_mean = e.wait_time.calcSampleMean();
    fout.writefln( "%e %e", e.x, e.wait_time.calcSampleMean() );
  }
}


void runTask3(string filename1, string filename2)
{
  ResCalc[] res;
  for(real i=0; i<=1.0; i+=0.01)
  {
    i.writeln;
    res ~= calcIPPQueueing(serv_rate*i, 10, 0.04, 0.04);
  }
  
  auto fout1 = File(filename1, "w");
  auto fout2 = File(filename2, "w");

  foreach(e; res)
  {
    fout1.writefln("%e %e", e.x, e.wait_time.calcSampleMean() );
    fout2.writefln("%e %e", e.x, e.ploss.calcSampleMean() );
  }
}


void runTask4(string filename1, string filename2)
{
  ResCalc[] res;
  for(real i=0; i<=1.0; i+=0.01)
  {
    res ~= calcQueueing(serv_rate*i, 10);
  }

  auto fout1 = File(filename1, "w");
  auto fout2 = File(filename2, "w");
  foreach(e; res)
  {
    fout1.writefln("%e %e", e.x, e.wait_time.calcSampleMean() );
    fout2.writefln("%e %e", e.x, e.ploss.calcSampleMean() );
  }
}


void runTask5(string filename1, string filename2)
{
  struct Val { real x; real v1; real v2;}
  Val[] res_wt, res_pl;
  foreach(i; [0.4, 0.8])
  {
    i.writeln;
    int cnt;
    for(real j=0.0; j<=1.0; j+=0.01)
    {
      auto tmp = calcIPPQueueing(serv_rate*j, 10, i, 0.04);
      if(i==0.4)
      {
        res_wt ~= Val(tmp.x, tmp.wait_time.calcSampleMean());
        res_pl ~= Val(tmp.x, tmp.ploss.calcSampleMean());
      }
      else 
      {
        res_wt[cnt].v2 = tmp.wait_time.calcSampleMean();
        res_pl[cnt].v2 = tmp.ploss.calcSampleMean();
      }
      cnt++;
    }
  }

  auto fout1 = File(filename1, "w");
  fout1.writeln("# x y1 y2 y3");
  foreach(e; res_wt)
  {
    fout1.writefln("%e %e %e", e.x, e.v1, e.v2);
  }

  auto fout2 = File(filename2, "w");
  fout2.writeln("# x y1 y2 y3");
  foreach(e; res_pl)
  {
    fout2.writefln("%e %e %e", e.x, e.v1, e.v2);
  }
}


void runTask6(string filename1, string filename2)
{
  struct Val { real x; real v1; real v2;}
  Val[] res_wt, res_pl;
  foreach(i; [0.4, 0.8])
  {
    i.writeln;
    int cnt;
    for(real j=0.0; j<=1.0; j+=0.01)
    {
      auto tmp = calcIPPQueueing(serv_rate*j, 10, 0.04, i);
      if(i==0.4)
      {
        res_wt ~= Val(tmp.x, tmp.wait_time.calcSampleMean());
        res_pl ~= Val(tmp.x, tmp.ploss.calcSampleMean());
      }
      else 
      {
        res_wt[cnt].v2 = tmp.wait_time.calcSampleMean();
        res_pl[cnt].v2 = tmp.ploss.calcSampleMean();
      }
      cnt++;
    }
  }

  auto fout1 = File(filename1, "w");
  fout1.writeln("# x y1 y2 y3");
  foreach(e; res_wt)
  {
    fout1.writefln("%e %e %e", e.x, e.v1, e.v2);
  }

  auto fout2 = File(filename2, "w");
  fout2.writeln("# x y1 y2 y3");
  foreach(e; res_pl)
  {
    fout2.writefln("%e %e %e", e.x, e.v1, e.v2);
  }
}

void runTask7 (string filename1, string filename2)
{
  struct Val { real x; real v1; real v2; real v3;}
  Val[] res_wt, res_pl;
  foreach(i; [5, 50, 100])
  {
    i.writeln;
    int cnt;
    for (real j=0.0; j<=1.0; j+=0.01)
    {
      auto tmp = calcIPPQueueing(serv_rate*j, i, 0.04, 0.04);
      if (i==5)
      {
        res_wt ~= Val(tmp.x, tmp.wait_time.calcSampleMean());
        res_pl ~= Val(tmp.x, tmp.ploss.calcSampleMean());
      }
      else if (i==50)
      {
        res_wt[cnt].v2 = tmp.wait_time.calcSampleMean();
        res_pl[cnt].v2 = tmp.ploss.calcSampleMean();
      }
      else
      {
        res_wt[cnt].v3 = tmp.wait_time.calcSampleMean();
        res_pl[cnt].v3 = tmp.ploss.calcSampleMean();
      }
      cnt++;
    }
  }


  auto fout1 = File(filename1, "w");
  fout1.writeln("# x y1 y2 y3");
  foreach(e; res_wt)
  {
    fout1.writefln("%e %e %e %e", e.x, e.v1, e.v2, e.v3);
  }

  auto fout2 = File(filename2, "w");
  fout2.writeln("# x y1 y2 y3");
  foreach(e; res_pl)
  {
    fout2.writefln("%e %e %e %e", e.x, e.v1, e.v2, e.v3);
  }
}