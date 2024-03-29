//+------------------------------------------------------------------+
//|                                                           震荡.mq4 |
//|                                                       ChinaCheng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ChinaCheng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
datetime alarm=0;
void OnTick()
  {
  if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {  
      xiaDan();
      alarm=Time[0];

     }

  }
extern  int K = 3;//统计K线数
extern int bd_point = 300;//波动点数
extern int  w_pc_point = 100;//外偏差点数
extern int  n_pc_point = 100;//内偏差点数
extern int zhiYin= 300;//止盈点
extern int zhiShun= 300;//止损点
extern double volume = 0.1;//起始手数
extern int magic=612973;//魔术号
 string mark = "Matrix_ma_atr";//标识
extern double mall_bl = 0.8;//平均波动与振浮比例
enum type {buy=OP_BUY,sell=OP_SELL,all=2};
extern type this_type=all;//做单方向
extern bool openTime_xz = true;//开始时间段限制
extern int time_xz_1 = 5;//运行时间段一起始
extern int time_xz_2 = 7;//运行时间段一结束
extern int time_xz_3 = 10;//运行时间段二起始
extern int time_xz_4 = 14;//运行时间段二结束
extern int time_xz_5 = 17;//运行时间段三起始
extern int time_xz_6 = 20;//运行时间段三结束
extern bool is_open_qs=true;//是否开启趋势判断
extern int trend_k = 5;//前多少根K线为趋势
enum time_type {M30=PERIOD_M30,H1=PERIOD_H1,H4=PERIOD_H4,D1=PERIOD_D1};
extern time_type period = H1;//判断趋势周期
void xiaDan()
  {
   if(!isTimeOpen()) return;
   if(existOrder()) return;
   if(is_open_qs) this_type =  pd_qs();
   
   double hPrice = iHigh(Symbol(),0,iHighest(Symbol(),0,MODE_HIGH,K,1));
   double lPrice = iLow(Symbol(),0,iLowest(Symbol(),0,MODE_LOW,K,1));
   double atr=iCustom(Symbol(),0,"ATR",K,0,1);
   printf("atr="+atr);
   if(hPrice-lPrice>=bd_point*Point() && NormalizeDouble(atr/(hPrice-lPrice),2)>=mall_bl)
     {
      
      if((this_type==OP_SELL || this_type==all) && Bid-hPrice>=0 &&  Bid-hPrice<w_pc_point*Point()) //上回调 外 sell
        {
         if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,NormalizeDouble(Bid+zhiShun*Point(),Digits),NormalizeDouble(Bid-zhiYin*Point(),Digits),mark,magic,0,clrRed)<0)
           {
            Print("OrderSend failed with error #",GetLastError());
            Alert("跌单发送失败："+GetLastError());
           }

        }
      else
         if((this_type==OP_SELL || this_type==all) && hPrice-Bid>0 && hPrice-Bid<n_pc_point*Point()) //上回调 内 sell
           {
            if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,NormalizeDouble(Bid+zhiShun*Point(),Digits),NormalizeDouble(Bid-zhiYin*Point(),Digits),mark,magic,0,clrRed)<0)
              {
               Print("OrderSend failed with error #",GetLastError());
               Alert("跌单发送失败："+GetLastError());
              }

           }
         else
            if((this_type==OP_BUY || this_type==all) && Ask-lPrice>0 && Ask-lPrice<n_pc_point*Point()) //下回调 内 buy
              {
               if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,NormalizeDouble(Ask-zhiShun*Point(),Digits),NormalizeDouble(Ask+zhiYin*Point(),Digits),mark,magic,0,clrRed)<0)
                 {
                  Print("OrderSend failed with error #",GetLastError());
                  Alert("涨单发送失败："+GetLastError());
                 }

              }
            else
               if((this_type==OP_BUY || this_type==all) && lPrice-Ask>=0 && lPrice-Ask<n_pc_point*Point()) //下回调 外 buy
                 {

                  if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,NormalizeDouble(Ask-zhiShun*Point(),Digits),NormalizeDouble(Ask+zhiYin*Point(),Digits),mark,magic,0,clrRed)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("涨单发送失败："+GetLastError());
                    }
                 }

     }
  }
bool isTimeOpen(){
   int localTime_h = TimeHour(Time[0]);
   if(localTime_h==0) return false;
   if(openTime_xz){
      if(localTime_h>=time_xz_1 && localTime_h<=time_xz_2) return true;
      if(localTime_h>=time_xz_3 && localTime_h<=time_xz_4) return true;
      if(localTime_h>=time_xz_5 && localTime_h<=time_xz_6) return true;
   }
  
   return false;
}
bool existOrder(){
   int totals = OrdersTotal();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(Symbol()==OrderSymbol())
           {
             return true;

           }
        }
     }
  return false;
}
int pd_qs(){
       double atr=iCustom(Symbol(),period,"ATR",trend_k,0,1);
       int bar = trend_k*(period/TimeMinute(Time[1]-Time[2]));
       if(Open[bar]+atr<Open[0]){
          return OP_BUY;
       }else if(Open[bar]-atr>Open[0]){
           return OP_SELL;
       }
       return 2;
}