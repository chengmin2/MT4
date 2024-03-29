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
extern bool isRealy = false;//实盘
extern bool isTimeAstict = true;//是否开启时间段限制
extern bool isSS = false;//是否顺
extern int zhishun = 300;//止损
extern bool restrict = true;//是否限制每天单数
extern int fly= 80;//跳动幅度
extern int timeLong = 8;//时间长短限制
extern int point = 100;//回头点位
bool isDayHaveOrder =  false;
string mark = "Matrix_YP";//标识
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
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      close();
      kaiDan();

      alarm=Time[0];

     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void kaiDan()
  {
   int order = jy.CheckOrderByaSymbol(Symbol());
   if(order==0)
     {
      timeAstrict();
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


void timeAstrict()
  {
   int  h;
   if(isRealy)
     {
      h=TimeHour(TimeLocal())-5;//盘面时间
     }
   else
     {
      h = TimeHour(TimeGMT());//盘面时间
     }
   int m=TimeMinute(TimeLocal());//分钟数
   if(isTimeAstict)
     {
      if(h>18 && h<timeLong)
        {
         if(restrict && isDayHaveOrder) //限制一天最多一单
           {
            return;
           }
         if(isSS)
           {
            if(Open[0]<Close[1]-fly*Point())
              {

               if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,Ask+zhishun*Point(),0,mark,magic,clrRed)<0)
                 {
                  Alert("订单发送失败！");
                  Print("OrderSend failed with error #",GetLastError());
                 }
               else
                 {
                  isDayHaveOrder=true;
                 }


              }
            else
               if(Open[0]>Close[1]+fly*Point())
                 {
                  if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,Bid-zhishun*Point(),0,mark,magic,clrRed)<0)
                    {
                     Alert("订单发送失败！");
                     Print("OrderSend failed with error #",GetLastError());
                    }
                  else
                    {
                     isDayHaveOrder=true;
                    }


                 }
           }
         else
           {
            if(Open[0]>Close[1]+fly*Point())
              {
               if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,Ask+zhishun*Point(),0,mark,magic,clrRed)<0)
                 {
                  Alert("订单发送失败！");
                  Print("OrderSend failed with error #",GetLastError());

                 }
               else
                 {
                  isDayHaveOrder=true;
                 }


              }
            else
               if(Open[0]<Close[1]-fly*Point())
                 {
                  if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,Bid-zhishun*Point(),0,mark,magic,clrRed)<0)
                    {
                     Alert("订单发送失败！");
                     Print("OrderSend failed with error #",GetLastError());
                    }
                  else
                    {
                     isDayHaveOrder=true;
                    }

                 }
               else
                  if(Close[1]-Open[1]>=fly*Point() || (Close[1]-Close[3]>point*Point()))
                    {
                     if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,Ask+zhishun*Point(),0,mark,magic,clrRed)<0)
                       {
                        Alert("订单发送失败！");
                        Print("OrderSend failed with error #",GetLastError());

                       }
                     else
                       {
                        isDayHaveOrder=true;
                       }

                    }
                  else
                     if(Open[1]-Close[1]>=fly*Point() || (Close[3]-Close[1]>point*Point()))
                       {
                        if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,Bid-zhishun*Point(),0,mark,magic,clrRed)<0)
                          {
                           Alert("订单发送失败！");
                           Print("OrderSend failed with error #",GetLastError());
                          }
                        else
                          {
                           isDayHaveOrder=true;
                          }

                       }

           }

        }
      if(h>timeLong-1)
        {
         isDayHaveOrder=false;

        }
     }

  }
//+------------------------------------------------------------------+
/*double zigZag[3];
double zigZag_HC[3];//zigZag缓存
void zigZag()
  {
   int jishu=0;
   for(int i=1; i<1000; i++)
     {
      //printf("i="+i);
      double zigZagZhi = iCustom(Symbol(),0,"ZigZag",13,0,i);

      if(zigZagZhi>0)
        {
         zigZag[jishu]=zigZagZhi;
         jishu++;
        }
      if(jishu>=ArraySize(zigZag))
        {
         break;
        }
     }

   if(zigZag_HC[1]!=zigZag[1] || zigZag_HC[0]!=zigZag[0])
     {
      close(zigZag,zigZag_HC);
      ArrayCopy(zigZag_HC,zigZag);

     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close(double &zigZag[],double &zigZag_HC[])
  {

      double thisLost;
      int order;
      if(zigZag[0]>zigZag[1] && zigZag[0]>zigZag_HC[0]  && type==OP_BUY)
        {
         printf("更新zigzag值");
         jy.ColseOrderBySymbol(Symbol());
        }
      else
         if(zigZag[0]<zigZag[1] && zigZag[0]<zigZag_HC[0] && type==OP_SELL  )
           {
            printf("更新zigzag值");
            jy.ColseOrderBySymbol(Symbol());

           }



  }
  */
extern double profit = 100;//利润值
void close()
  {
   double thisprofit = jy.profitBySymbolTotal(Symbol());
   printf("thisprofit="+thisprofit);
   if(thisprofit>=profit)
     {
      jy.ColseOrderBySymbol(Symbol());
     }


  }
//+------------------------------------------------------------------+
