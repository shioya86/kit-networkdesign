module systems;
import std;
import tools;

const real serv_rate = 100_000;   // サービス率: μ
const int packet_len = 100_000;   // 標本区間長
const int n = 10;                 // 標本個数

const int K_INF = 0;


enum RET_FLAGS 
{
  PLOSS,
  WAIT_TIME,
  WAIT_TIME_PER_PLOSS,
  WAIT_TIME_CONFINTERV
}


string calcQueueing(uint out_style, real arr_time, uint k=K_INF)
{
  real[] ploss; 
  real[] ans;
  foreach(i; 0..n)
  {
    DList!(Packet) q;   // パケット待ちキュー
    uint loss;
    real w_tmp 	= 0.0;  // パケットの queue における滞在時間の総和
    real at     = 0.0;  // 到着時間軸
    real dt     = 0.0;  // 退去時間軸
    uint sample;        // サンプルパケット数

    while (  sample < packet_len )
    {
      if (q.empty() || at<dt)
      {
        /* パケットの発生 */
        Packet curr_packet = Packet(at, getArrvintr(serv_rate, getRndRate()));
        if (k!=K_INF && q.array().length==k)
        {
          /* パケットロス */
          loss++;
        }
        else if(q.empty)
        {
          q.insertFront(curr_packet);
          dt = at + curr_packet.service_time;
        }
        else
        {
          q.insertFront(curr_packet);
        }
        at += getServDistr(arr_time, getRndRate());
      }
      else
      {

        /* パケットの退去 */
        const auto curr_packet = q.back();
        q.removeBack();
        w_tmp += dt - curr_packet.arrival_time;

        sample++;
        if (!q.empty())
        {
          dt += q.back().service_time;
        }
      }
    }
    ploss ~= loss.to!real / (sample + loss);
    ans ~= w_tmp/sample;
  }

  /* 出力フォーマット */
  string val;
  switch(out_style)
  {
    case RET_FLAGS.PLOSS:
      val = format("%e", ploss.calcSampleMean());
      break;
    case RET_FLAGS.WAIT_TIME:
      val = format("%e", ans.calcSampleMean());
      break;
    case RET_FLAGS.WAIT_TIME_CONFINTERV:
      const real sample_mean = ans.calcSampleMean();
      val = format("%e %e", ans.calcSampleMean(), calcConfidenceInterval(ans, sample_mean));
      break;
    case RET_FLAGS.WAIT_TIME_PER_PLOSS:
      val = format("%e", ans.calcSampleMean()/ploss.calcSampleMean());
      break;
    default:
      val = format("%e", ploss.calcSampleMean());
  }

  return format("%e %s", arr_time/serv_rate, val);
}


// IPP/M/1/K 待ち行列システム
string calcIPPQueueing(real arr_time, uint k, real a1, real a2)
{
  real arr_time_on = arr_time*(a1+a2)/a2;
  real[] ploss; 
  real[] ans;
  bool stat;            // パケット到着のON/OFF状態


  foreach(i; 0..n)
  {
    DList!(Packet) q;   // パケット待ちキュー
    uint loss;
    real w_tmp 	= 0.0;  // パケットの queue における滞在時間の総和
    real at     = 0.0;  // 到着時間軸
    real dt     = 0.0;  // 退去時間軸
    uint sample;        // サンプルパケット数

    while (  sample < packet_len )
    {
      /* 状態遷移 */
      const real trans_rate = (stat)? a1 : a2;
      stat = (getRndRate <= trans_rate)? !stat : stat;

      if ( q.empty() || at<dt)
      {
        /* パケットの発生 */
        Packet curr_packet = Packet(at, getArrvintr(serv_rate, getRndRate()));

        if (!stat)
        {
          /* 状態がOFFであれば, パケットは到着しない */
        }
        else if (q.array().length==k)
        {
          /* パケットロス */
          loss++;
        }
        else if( q.empty() )
        {
          q.insertFront(curr_packet);
          dt = at + curr_packet.service_time;
        }
        else
        {
          q.insertFront(curr_packet);
        }
        at += getServDistr(arr_time_on, getRndRate());
      }
      else
      {

        /* パケットの退去 */
        const auto curr_packet = q.back();
        q.removeBack();
        w_tmp += dt - curr_packet.arrival_time;

        sample++;
        if (!q.empty())
        {
          dt += q.back().service_time;
        }
      }
    }
    ploss ~= loss.to!real / (sample + loss);
    ans ~= w_tmp/sample;
  }
  return format("%e %e", 
    arr_time/serv_rate, 
    ans.calcSampleMean()/ploss.calcSampleMean());
}