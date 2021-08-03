module tools;
import std;

auto rnd = Random(0);

// パケット
struct Packet
{
  real arrival_time;    // 客の到着
  real service_time;    // 客の退去

  /* packet* next;      // 次のパケット(DListで管理するため不要) */
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