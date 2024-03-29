//+------------------------------------------------------------------+
//|                                                 niShiJiaCnag.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
datetime alarm=0;
input int magic=612973;//魔术号
input double volume=0.1;//起始手数
input int jc_point=300;//加仓点位
extern bool isTimeAstict = true;//是否开启时间段限制
extern int XZ_H = 16;//时间分割线
extern int XZ_H_2 = 18;//时间分割线
extern int openPoint=300;//开仓点位
extern int zhishun=300;//止损
string mark = "Matrix_SS_PL";//标识
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double totalVolume=0;
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      int order = jy.CheckOrderByaSymbol(Symbol());
      setDayHaveOrder();
      if(order==0 && !isDayHaveOrder)
        {
         kaiCang();
        }

      alarm=Time[0];

     }


  }
void setDayHaveOrder(){
 if(TimeHour(Time[0])<TimeHour(Time[1]))
           {
            isDayHaveOrder = false;
           }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isDayHaveOrder=false;//当天是否存在订单
void kaiCang()
  {
   double oprice = Open[0];
   for(int i=1; i<1000; i++) 
     {
      if(isTimeAstict)
        {                
         if(TimeHour(Time[i])<XZ_H || TimeHour(Time[i])>XZ_H_2)
           {           
            break;
           }
           
        }
      if(Open[i]-Open[0]>=openPoint*Point())
        {
         if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,Ask+zhishun*Point(),Ask-zhishun*Point(),mark,magic,clrRed)<0)
           {
            Alert("订单发送失败！");
            Print("OrderSend failed with error #",GetLastError());

           }
         else
           {
            isDayHaveOrder=true;
            Alert(isDayHaveOrder);
           }
         break;

        }
      else
         if(Open[0]-Open[i]>=openPoint*Point())
           {
            if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,Bid-zhishun*Point(),Bid+zhishun*Point(),mark,magic,clrRed)<0)
              {
               Alert("订单发送失败！");
               Print("OrderSend failed with error #",GetLastError());
              }
            else
              {
               Alert(isDayHaveOrder);
               isDayHaveOrder=true;
              }
            break;
           }

     }

  }
//+------------------------------------------------------------------+
