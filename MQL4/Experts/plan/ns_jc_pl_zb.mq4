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
extern int XZ_H = 18;//时间分割线1
extern int XZ_H_2 = 3;//时间分割线2（悉尼时间不用管）
extern int openPoint=300;//开仓点位
extern int zhishun=300;//止损
extern int maxDC = 25;//最大承受点差
string mark = "Matrix_NJ_PL";//标识
extern bool isCPT = true;//悉尼时间
extern int dingShi = 5;//定时设置
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
      setTimer();
      int order = jy.CheckOrderByaSymbol(Symbol());
      if(order==0)
        {
         kaiCang();
        }

      alarm=Time[0];

     }


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(jy.CheckOrderByaSymbol(Symbol()==0))
     {
      kaiCang();

     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isExist=false;
void setTimer()
  {
   if(TimeHour(Time[0])>=XZ_H && !isExist)//等同于onInt
     {
      EventSetTimer(dingShi);
      isExist = true;
     }
   else
      if(TimeHour(Time[0])<XZ_H  && isExist)
        {
         if(!isCPT && TimeHour(Time[0])>XZ_H_2)

           {
            isExist = false;
            EventKillTimer();
           }
         else
            if(isCPT)
              {
               isExist = false;
               EventKillTimer();
              }


        }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+




int kshu;
double highP=iHigh(Symbol(),0,iHighest(Symbol(),0,MODE_HIGH,kshu,0));
double lowP = iLow(Symbol(),0,iLowest(Symbol(),0,MODE_LOW,kshu,0));
void kaiCang()
  {
   if(isTimeAstict)
     {
      if(TimeHour(Time[1])<XZ_H)
        {
         if(!isCPT && TimeHour(Time[1])>XZ_H_2) //非悉尼时间
           {
            return;
           }
         else
            if(isCPT)
              {
               return;
              }

        }
     }
   jsKShu();
   if(Open[10]-Open[0]>0)
     {
      if(highP-Open[0]>=openPoint*Point())
        {
         if(Ask-Bid>maxDC*Point())
            return;
         EventKillTimer();
         if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,Bid-zhishun*Point(),Ask+zhishun/3*Point(),mark,magic,clrRed)<0)
           {
            Alert("订单发送失败！");
            Print("OrderSend failed with error #",GetLastError());
           }
         EventSetTimer(dingShi);
         return;
        }
      else
        {
         printf("未达到最高价为："+highP);
        }

     }
   else
      if(Open[0]-Open[10]>0)
        {
         if(Open[0]-lowP>=openPoint*Point())
           {
            if(Ask-Bid>maxDC*Point())
               return;
            EventKillTimer();
            if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,Ask+zhishun*Point(),Bid-zhishun/3*Point(),mark,magic,clrRed)<0)
              {
               Alert("订单发送失败！");
               Print("OrderSend failed with error #",GetLastError());
              }
            EventSetTimer(dingShi);
            return;
           }
         else
           {
            printf("未达到最低价为："+lowP);
           }

        }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void jsKShu()
  {
   int thisH = TimeHour(Time[0]);
   if(isCPT)
     {
      kshu=(thisH-XZ_H)*60+TimeMinute(Time[0]);
     }
   else
     {
      if(thisH<=XZ_H_2)
        {
         kshu = (thisH+24-XZ_H)*60+TimeMinute(Time[0]);
        }
      else
         if(thisH>=XZ_H)
           {
            kshu=(thisH-XZ_H)*60+TimeMinute(Time[0]);
           }
     }


  }
//+------------------------------------------------------------------+
