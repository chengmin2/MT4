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
extern int XZ_H_2 = 3;//时间分割线2
extern int openPoint=300;//开仓点位
extern int zhishun=300;//止损
extern int maxDC = 20;//最大承受点差
extern int dingShi = 3;//定时设置
enum BB{
  Matrix_LITE_PL,
  Matrix_LITE_MINI
};
extern BB mark = Matrix_LITE_PL;//标识
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
      if(TimeHour(Time[0])<XZ_H)
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



extern bool isCPT = false;//悉尼时间
void kaiCang()
  {

   double oprice = Open[0];
   for(int i=1; i<1000; i++) //行情跌
     {
      if(isTimeAstict)
        {
         if(TimeHour(Time[i])<XZ_H)
           {              
            if(isCPT){
              return;
            }else
            if(!isCPT && TimeHour(Time[i])>XZ_H_2)
              {
               return;
              }

           }
        
        }
      if(Open[10]-Open[0]>0)
        {
         if(Open[i]-Open[0]>=openPoint*Point())
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
         /* else
            {
             if(Close[i]-Open[i]>0)
               {
                for(int j=i; j<1000-i; j++)
                  {

                   if(Close[i]-Open[j]>=openPoint/3)
                     {
                      return;//结束所有循环
                     }
                   else
                      if(Close[i]-Open[j]<0)
                        {
                         break;//结束当前循环
                        }
                  }
               }

            }*/
        }
      else
         if(Open[0]-Open[10]>0)
           {
            if(Open[0]-Open[i]>=openPoint*Point())
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
            /* else
               {
                if(Open[i]-Close[i]>0)
                  {
                   for(int j=i; j<1000-i; j++)
                     {

                      if(Open[j]-Close[i]>openPoint/3)
                        {
                         return;//结束所有循环
                        }
                      else
                         if(Open[j]-Close[i]<0)
                           {
                            break;//结束当前循环
                           }
                     }
                  }
               }*/

           }



     }



  }
//+------------------------------------------------------------------+
