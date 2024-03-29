//+------------------------------------------------------------------+
//|                                                       ANC_SS.mq4 |
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
extern int jcPoint = 200;//开仓点位
extern int bar = 12;//K线数
extern double volume = 0.02;//起始手数
extern double min_unit = 0.01;//最小单位
extern double profit = 5;//出仓利润
string mark = "Matrix_ANC";//标识
input int magic=612973;//魔术号
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
datetime alarm=0;
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
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      close();
      JC();
      alarm=Time[0];
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JC()
  {
   int total = OrdersTotal();
   string symbol = Symbol();
   int buyOrder = jy.CheckOrderByaSymbolType(symbol,OP_BUY);
   int sellOrder = jy.CheckOrderByaSymbolType(symbol,OP_SELL);

   for(int i=2; i<bar; i++)
     {
      if(buyOrder==0)
        {
         if(Close[1]-Open[i]>=jcPoint*Point())
           {
            if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic,0,clrRed)<0)
              {
               Print("OrderSend failed with error #",GetLastError());
               Alert("开多单失败！");
              }
            return;
           }
        }
      if(sellOrder==0)
        {
         if(Open[i]-Close[1]>=jcPoint*Point())
           {
            if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic,0,clrRed)<0)
              {
               Print("OrderSend failed with error #",GetLastError());
               Alert("开空单失败！");
              }
            return;
           }
        }

     }
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         string thisSymbol=OrderSymbol();
         int type = OrderType();
         double lots = OrderLots();
         if(thisSymbol==symbol)
           {
            double close_p_1 = Close[1];
            for(int i=2; i<bar; i++)
              {
               if(close_p_1-Open[i]>=jcPoint*Point() && type==OP_SELL)
                 {
                  int buyNum = jy.CheckOrderByaSymbolType(symbol,OP_BUY);
                  double buy_Lots=lastLostByType(OP_BUY);
                  if(buyNum<4)
                    {
                     buy_Lots = buy_Lots+min_unit;
                    }
                  else
                    {
                     buy_Lots = buyNum*min_unit+buy_Lots;
                    }

                  if(OrderSend(Symbol(),OP_BUY,buy_Lots,Ask,3,0,0,mark,magic,0,clrRed)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开多单失败！");
                    }

                  break;
                 }
               else
                  if(Open[i]-close_p_1>=jcPoint*Point() && type==OP_BUY)
                    {
                     int sellNum = jy.CheckOrderByaSymbolType(symbol,OP_SELL);
                     double sell_Lots=lastLostByType(OP_SELL);

                     if(sellNum<4)
                       {
                        sell_Lots = sell_Lots+min_unit;
                       }
                     else
                       {
                        sell_Lots = sellNum*min_unit+sell_Lots;
                       }

                     if(OrderSend(Symbol(),OP_SELL,sell_Lots,Bid,3,0,0,mark,magic,0,clrRed)<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("开空单失败！");
                       }
                     break;

                    }

              }
            break;
           }
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY)==0)
         Alert("关闭多单交易出错！");
      return;
     }
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
         Alert("关闭空单交易出错！");
      return;
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lastLostByType(int type)
  {
   int totals = OrdersTotal();
   double returnLot;
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         double thisLot = OrderLots();
         if(OrderType()==type)
           {
            returnLot = OrderLots();
            break;
           }
        }
     }
   return returnLot;
  }
//+------------------------------------------------------------------+
