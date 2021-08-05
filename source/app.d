import std;
import systems;
import tools;

void main()
{
  const uint flag = 0b1111111;

  /* 課題1 */
  if (flag & 0b0000001)
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
  for(real i=50_000; i<=serv_rate; i*=1.01)
  {
    res ~= calcQueueing(i);
  }

  auto fout = File(filename, "w");
  foreach(e; res)
  {
    auto sample_mean = e.wait_time.calcSampleMean();
    fout.writefln( "%e %e %e", e.x, sample_mean, calcConfidenceInterval(e.wait_time, sample_mean) );
  }
}


void runTask2(string filename)
{
  ResCalc[] res;
  for(real i=50_000; i<=serv_rate; i*=1.01)
  {
    const real val = 1.0/( serv_rate*(1.0-i/serv_rate) );
    res ~= ResCalc(i/serv_rate, null, [val]);
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
  for(real i=50_000; i<=serv_rate; i*=1.1)
  {
    res ~= calcIPPQueueing(i, 10, 0.04, 0.04);
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
  for(real i=50_000; i<=serv_rate; i*=1.1)
  {
    res ~= calcQueueing(i, 10);
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
  ResCalc[][] res_arr;

  foreach(i; [0.4, 0.8])
  {
    i.writeln;
    ResCalc[] res;
    for(real j=50_000; j<=serv_rate; j*=1.1)
    {
      res ~= calcIPPQueueing(j, 10, i, 0.04);
    }
    res_arr ~= res;
  }

  auto fout1 = File(filename1, "w");
  fout1.writeln("# x y1 y2 y3");
  foreach(i; 0..res_arr[0].length)
  {
    real[] vals;
    foreach(j; 0..res_arr.length)
    {
      vals ~= res_arr[j][i].wait_time.calcSampleMean();
    }
    fout1.writefln("%e %s", res_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }

  auto fout2 = File(filename2, "w");
  fout2.writeln("# x y1 y2 y3");
  foreach(i; 0..res_arr[0].length)
  {
    real[] vals;
    foreach(j; 0..res_arr.length)
    {
      vals ~= res_arr[j][i].ploss.calcSampleMean();
    }
    fout2.writefln("%e %s", res_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }
}


void runTask6(string filename1, string filename2)
{
  ResCalc[][] res_arr;

  foreach(i; [0.4, 0.8])
  {
    i.writeln;
    ResCalc[] res;
    for(real j=50_000; j<=serv_rate; j*=1.1)
    {
      res ~= calcIPPQueueing(j, 10, 0.04, i);
    }
    res_arr ~= res;
  }

  auto fout1 = File(filename1, "w");
  fout1.writeln("# x y1 y2 y3");
  foreach(i; 0..res_arr[0].length)
  {
    real[] vals;
    foreach(j; 0..res_arr.length)
    {
      vals ~= res_arr[j][i].wait_time.calcSampleMean();
    }
    fout1.writefln("%e %s", res_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }

  auto fout2 = File(filename2, "w");
  fout2.writeln("# x y1 y2 y3");
  foreach(i; 0..res_arr[0].length)
  {
    real[] vals;
    foreach(j; 0..res_arr.length)
    {
      vals ~= res_arr[j][i].ploss.calcSampleMean();
    }
    fout2.writefln("%e %s", res_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }
}

void runTask7 (string filename1, string filename2)
{
  ResCalc[][] res_arr;
  foreach(i; [5, 50])
  {
    i.writeln;
    ResCalc[] res;

    for (real j=50_000; j<=serv_rate; j*=1.1)
    {
      res ~= calcIPPQueueing(j, i, 0.04, 0.04);
    }
    res_arr ~= res;
  }

  auto fout1 = File(filename1, "w");
  fout1.writeln("# x y1 y2 y3");
  foreach (i; 0..res_arr[0].length)
  {
    real[] vals;
    foreach (j; 0..res_arr.length)
    {
      vals ~= res_arr[j][i].wait_time.calcSampleMean();
    }
    fout1.writefln("%e %s", res_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }

  auto fout2 = File(filename2, "w");
  fout2.writeln("# x y1 y2 y3");
  foreach (i; 0..res_arr[0].length)
  {
    real[] vals;
    foreach (j; 0..res_arr.length)
    {
      vals ~= res_arr[j][i].ploss.calcSampleMean();
    }
    fout2.writefln("%e %s", res_arr[0][i].x, vals.map!(a=>format("%e", a)).join(" ") );
  }
}