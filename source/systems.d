module systems;
import std;
import tools;

const real serv_rate = 100_000;   // サービス率: μ
const int packet_len = 100_000;   // 標本区間長
const int n = 10;                 // 標本個数

const int K_INF = 0;

struct ResCalc
{
  real x;
  real[] ploss;
  real[] wait_time;
}

ResCalc calcQueueing(real arv_time, uint k=K_INF)
{
  if (arv_time==0.0) return ResCalc(0.0, [0.0], [1/serv_rate]);

  ResCalc res;
  res.x = arv_time/serv_rate;

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
        at += getServDistr(arv_time, getRndRate());
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
    res.ploss ~= loss.to!real / (sample + loss);
    res.wait_time ~= w_tmp/sample;
  }


  return res; 
}


ResCalc calcIPPQueueing(real arv_time, uint k=K_INF, real a1=0.0, real a2=0.0)
{
  if (arv_time==0.0) return ResCalc(0.0, [0.0], [1/serv_rate]);
  a1 *= serv_rate;
  a2 *= serv_rate;
  ResCalc res;
  res.x = arv_time/serv_rate;

  real arv_time_on = arv_time*(a1 + a2)/a2;
  bool stat = false;
  foreach(i; 0..n)
  {
    DList!(Packet) q;   // パケット待ちキュー
    uint loss;
    real w_tmp 	= 0.0;  // パケットの queue における滞在時間の総和
    real at     = 0.0;  // 到着時間軸
    real dt     = 0.0;  // 退去時間軸
    real ot     = 0.0;  // ON状態時間
    uint sample;        // サンプルパケット数

    while (  sample < packet_len )
    {

      if (stat && ot<at)
      {
        stat = false;
      }


      if (q.empty() || at<dt)
      {
        /* パケットの発生 */
        Packet curr_packet = Packet(at, getArrvintr(serv_rate, getRndRate()));
        if (!stat)
        {
          // OFF状態
          at += getServDistr(a2, getRndRate());
          stat = true;
          ot = at + getServDistr(a1, getRndRate());
        }
        else if (k!=K_INF && q.array().length==k)
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
        // 次のパケット
        at += getServDistr(arv_time_on, getRndRate());
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
    res.ploss ~= loss.to!real / (sample + loss);
    res.wait_time ~= w_tmp/sample;
  }


  return res; 
}