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
input double volume=0.02;//起始手数
string mark = "Matrix_NJ_PL";//标识
input double min_unit=0.01;//最小计量单位
extern int openPoint=300;//开仓点位
extern bool isTimeAstict = true;//是否开启时间段限制
extern int XZ_H = 18;//时间分割线
extern int profitPoint = 100;//利润点
extern int JC_POINT = 200;//加仓点
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
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      close();
      jiaCang();
      xiaDan();

      alarm=Time[0];

     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int buyOrder;
int sellOrder;
double lastBuyOprice;
double lastSellOprice;
void xiaDan()
  {
   buyOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_BUY);
   sellOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_SELL);
   if(buyOrder==0)
     {
      kaiCang(OP_BUY);
     }
   if(sellOrder==0)
     {
      kaiCang(OP_SELL);
     }

  }

void close()
  {

   double  buyLots = jy.totalVolumeBySymbol(Symbol(),OP_BUY);
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>buyLots*profitPoint)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY)==0)
         Alert("关闭多单交易出错！");

     }
   double  sellLots = jy.totalVolumeBySymbol(Symbol(),OP_SELL);
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>sellLots*profitPoint)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
         Alert("关闭空单交易出错！");
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void jiaCang()
  {
   if(buyOrder>0)
     {
      double lastBuyLots =  lastLotsByType(OP_BUY);
      if(lastBuyOprice-Ask>=JC_POINT*Point())
        {
         double buyLots;
         if(buyOrder<4)
           {
            buyLots = lastBuyLots+min_unit;
           }
         else
           {
            buyLots = buyOrder*min_unit+lastBuyLots;
           }
         if(OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,mark,magic,clrRed)<0)
           {
            Alert("订单发送失败！");
            Print("OrderSend failed with error #",GetLastError());
           }

        }
     }

   if(sellOrder>0)
     {
      double lastSellLots =  lastLotsByType(OP_SELL);
      if(Bid-lastSellOprice>=JC_POINT*Point())
        {

         double sellLots;
         if(sellOrder<4)
           {
            sellLots =lastSellLots+min_unit;
           }
         else
           {
            sellLots = sellOrder*min_unit+lastSellLots;
           }
         if(OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,mark,magic,clrRed)<0)
           {
            Alert("订单发送失败！");
            Print("OrderSend failed with error #",GetLastError());

           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lastLotsByType(int type)
  {
   int order = OrdersTotal();
   double lots;
   for(int i=order-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(Symbol()==OrderSymbol() && type == OrderType())
           {
            lots = OrderLots();
            if(type==OP_BUY)
              {
               lastBuyOprice = OrderOpenPrice();
              }
            else
               if(type==OP_SELL)
                 {
                  lastSellOprice = OrderOpenPrice();
                 }
            break;
           }
        }
     }
   return lots;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void kaiCang(int type)
  {
   double oprice = Open[0];
   for(int i=1; i<1000; i++)
     {
      if(isTimeAstict)
        {
         if(TimeHour(Time[i])<XZ_H)
           {
            return;
           }
        }
      if(type==OP_BUY)
        {
         if(Open[10]-Open[0]>0) //行情跌
           {
            if(Open[i]-Open[0]>=openPoint*Point())
              {
               if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic,clrRed)<0)
                 {
                  Alert("订单发送失败！");
                  Print("OrderSend failed with error #",GetLastError());
                 }
               return;
              }

           }
        }
      else
         if(type==OP_SELL)
           {
            if(Open[0]-Open[10]>0)
              {
               if(Open[0]-Open[i]>=openPoint*Point())
                 {
                  if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic,clrRed)<0)
                    {
                     Alert("订单发送失败！");
                     Print("OrderSend failed with error #",GetLastError());

                    }
                  return;
                 }


              }
           }
     }

  }

//+------------------------------------------------------------------+
