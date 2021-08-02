import std;
import core.thread;
auto rnd = Random(0);
const int packet_len = 100_000; 	// 標本区間長
const int n = 10; 								// 標本個数
const real serv_rate = 100_000; 	// サービス率: μ
// const real arr_time = 1_000; 	// 平均到着率: λ

void main()
{
  /* 課題1 */
  auto fout = File("data/sample1.dat", "w");
  for(real i=10; i<=serv_rate; i*=1.3)
  {
    fout.writeln(calc1(i));
  }

  /* 課題1(理論値) */
  auto fout2 = File("data/theor1.dat", "w");
  for(real i=10; i<=serv_rate; i*=1.3)
  {
    real val = 1.0/( serv_rate*(1.0-i/serv_rate) );
    fout2.writeln( format("%e %e", i/serv_rate, val) );
  }
  /* 課題2 */
  //calc2();
}


// パケット
struct Packet
{
  real arrival_time; 		// 客の到着
  real service_time; 		// 客の退去

  /* packet* next; 			// 次のパケット(DListで管理するため不要) */
}

// 0 ~ 1 rnd
real getRndRate()
{
  return uniform(0.0L, 1.0L, rnd);
}

// 式(48)
real getServDistr(real _lambda, real rate)
{
  return -log(1.0L-rate)/_lambda;
}

// 式(51)
real getArrvintr(real _mu, real rate)
{
  return -log(1.0L-rate)/_mu;
}

// 標本平均
real calcSampleMean(T=real)(T[] res)
{
  return res.sum/res.length;
}

// 信頼区間
real calcConfidenceInterval(T=real)(T[] res, real xBar)
{
  auto sx2 = res.map!(a=> (a-xBar)^^2).array().sum()/(res.length.to!real-1.0);
  return sqrt(sx2/res.length)*1.96;
}
// M/M/1 待ち行列システム
string calc1(real arr_time)
{
  /* Single-run 法 */
  real[] ans; 

  foreach(i; 0..n)
  {
    DList!(Packet) q; 	// パケット待ちキュー
    real w_tmp 	= 0.0; 	// パケットの queue における滞在時間の総和
    real at 		= 0.0; 	// 到着時間軸
    real dt 		= 0.0; 	// 退去時間軸
    uint sample; 				// サンプルパケット数

    while (  sample < packet_len )
    {
      if (q.empty() || at<dt)
      {
        /* パケットの発生 */
        Packet curr_packet = Packet(at, getArrvintr(serv_rate, getRndRate()));

        if(q.empty)
        {
          q.insert(curr_packet);
          dt = at + curr_packet.service_time;
        }
        else
        {
          q.insert(curr_packet);
        }

        at += getServDistr(arr_time, getRndRate());
      }
      else
      {

        /* パケットの退去 */
        const auto curr_packet = q.removeAny();
        w_tmp += dt - curr_packet.arrival_time;

        sample++;
        if (!q.empty())
        {
          dt += q.front().service_time;
        
        }
      }
    }
    ans ~= w_tmp/sample;
  }
  auto sample_mean = ans.calcSampleMean();
  auto confidence_interval = calcConfidenceInterval(ans, sample_mean);
  return format("%e %e %e", 
    arr_time/serv_rate, 
    sample_mean, 
    confidence_interval);
}


// IPP/M/1/K 待ち行列システム
void calc2()
{

}