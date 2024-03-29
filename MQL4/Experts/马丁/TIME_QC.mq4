//+------------------------------------------------------------------+
//|                                                      TIME_QC.mq4 |
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
string mark = "Matrix_NJ";//标识
extern double volume=0.01;//起始手数
extern int magic=612973;//魔术号
input int huiCeDian=200;//回撤顺势点
input int guaDian=100;//挂单点位
extern int ZS_P_S= 200;//移动止损点位
extern  int ZS_P_E =100;//移动止损点数
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
//--- create timer
   EventSetTimer(2);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();

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

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   xiaDan();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void xiaDan()
  {
   close();
   jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);
   if(Ask>=Open[0]+huiCeDian*Point())
     {
      if(!saiXuanHour())
        {
         OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-guaDian*Point(),3,0,0,mark,magic);
        }

     }
   else
      if(Bid<=Open[0]-huiCeDian*Point())
        {
         if(!saiXuanHour())
           {
            OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+guaDian*Point(),3,0,0,mark,magic);
           }
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool saiXuanHistoryHour()
  {
   bool isHaveOrder=false;
   int total = OrdersHistoryTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol()==Symbol())
           {
            datetime closeTime = OrderCloseTime();
            double closePrice = OrderClosePrice();
            int type = OrderType();
            int H = TimeHour(closeTime);
            int L_H =  Hour();
            if(H==L_H)
              {
               if(type == OP_BUY  && MathAbs(closePrice-Ask)<huiCeDian*Point())
                 {
                  isHaveOrder = true;
                  break;
                 }
               else
                  if(type == OP_SELL  && MathAbs(closePrice-Bid)<huiCeDian*Point())
                    {
                     isHaveOrder = true;
                     break;
                    }
              }
            else
               if(H<L_H)
                 {
                  break;
                 }

           }
        }
     }
   return isHaveOrder;

  }
 bool saiXuanHour(){
 
  bool isHaveOrder=false;
   int total = OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
           
            double openPrice = OrderOpenPrice();
            double openTime = OrderOpenTime();
            int type = OrderType();
            int H = TimeHour(openTime);
            int L_H =  Hour();
            if(H==L_H)
              {
               if((type == OP_BUY || type == OP_BUYSTOP) && MathAbs(openPrice-Ask)<huiCeDian*Point())
                 {
                  isHaveOrder = true;
                  break;
                 }
               else
                  if((type == OP_SELL || type == OP_SELLSTOP) && MathAbs(openPrice-Bid)<huiCeDian*Point())
                    {
                     isHaveOrder = true;
                     break;
                    }
              }
           }
        }
     }
   return isHaveOrder;
 }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   int totals = OrdersTotal();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         datetime openTime = OrderOpenTime();
         int tickt = OrderTicket();
         double lots = OrderLots();
         int type = OrderType();
         int H = TimeHour(openTime);
         int L_H =  Hour();
         if(OrderSymbol()==Symbol() && L_H!=H)
           {
            if(type==OP_BUY)
              {
               OrderClose(tickt,lots,Bid,3,clrRed);
              }
            else
               if(type==OP_SELL)
                 {
                  OrderClose(tickt,lots,Ask,3,clrRed);
                 }else if(type==OP_BUYSTOP || type==OP_SELLSTOP){
                   OrderDelete(tickt,clrRed);
                 }

           }
        }
     }

  }
//+------------------------------------------------------------------+
