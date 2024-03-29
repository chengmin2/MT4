//+------------------------------------------------------------------+
//|                                                    Matrix_JC.mq4 |
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
extern int jc_points =700;//加仓点位
string mark = "Matrix_pro";//标识
extern int magic=612973;//魔术号
extern int jc_jisu=2;//加仓基数
extern int jc_change=4;//加仓基数改变为2的最大订单量
int OnInit()
  {
//--- create timer
   EventSetTimer(1);
   
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
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   jiaCang();//加仓
  }
//+------------------------------------------------------------------+
void jiaCang()
  {
   int totals = OrdersTotal();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            double thisOrderOpen = OrderOpenPrice();
            double thisLots = OrderLots();
            int thisType = OrderType();
            int orders = CheckOrderByaSymbol(Symbol());
            if(orders>=jc_change)
              {
               thisLots=2*thisLots;
              }
            else
              {
               thisLots=jc_jisu*thisLots;
              }
            if(thisType==OP_BUY)
              {             
               if(thisOrderOpen-Bid>=jc_points*Point())
                 {
                  EventKillTimer();
                  if(OrderSend(Symbol(),OP_SELL,thisLots,Bid,3,0,0,mark,magic,0,clrGreen)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("加仓失败："+GetLastError());
                    }
                  EventSetTimer(1);
                 }
              }

            if(thisType==OP_SELL)
              {
               
               if(Ask-thisOrderOpen>=jc_points*Point())
                 {
                  EventKillTimer();
                  if(OrderSend(Symbol(),OP_BUY,thisLots,Ask,3,0,0,mark,magic,0,clrGreen)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("加仓失败："+GetLastError());
                    }
                  EventSetTimer(1);
                 }
              }
            break;
           }

        }

     }

  }
int CheckOrderByaSymbol(string symbol) //检查订单中当前货币的单数
  {
   int  total=OrdersTotal();
   int rt=0;
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol)
            rt++;
        }
     }
   return rt;
  }
