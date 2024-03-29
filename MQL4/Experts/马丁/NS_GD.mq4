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
input double cc_profit=10;//出仓利润
input int jc_point=100;//加仓点位
extern int jc_point_js=200;//加仓计算位
string mark = "Matrix_NJ";//标识
#include <myInclude\ZhiNengJiaoYi.mqh>

ZhiNengJiaoYi jy;
int OnInit()
  {
   EventSetTimer(5);
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
   nsGD();
   close();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      nsGD();
      close();
      shouDan();
      alarm=Time[0];

     }


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {

   if(jy.profitBySymbolTotal(Symbol())>cc_profit)
     {
      jy.ColseOrderGuaBySymbol(Symbol());
      if(jy.ColseOrderBySymbol(Symbol())==0)
         Alert("关闭定单交易出错！");
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

double jiaCangBS = 1.3;
void nsGD()
  {
   int bGua = jy.CheckOrderByaSymbolType(Symbol(),OP_BUYSTOP);
   int sGua = jy.CheckOrderByaSymbolType(Symbol(),OP_SELLSTOP);
   int  total=OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {

            if(bGua==0  && sGua==0)
              {
               int  type = OrderType();
               double lots = OrderLots();
               double opPrice = OrderOpenPrice();
               if(type==OP_BUY && opPrice-Ask>=jc_point_js*Point())
                 {

                  if(OrderSend(Symbol(),OP_BUYSTOP,jiaCangBS*lots,Ask+jc_point*Point(),3,0,0,mark,magic)<0)
                    {

                     Alert("挂涨单失败！");
                     Print("OrderSend failed with error #",GetLastError());
                    }
                 }
               if(type==OP_SELL && Bid-opPrice>=jc_point_js*Point())
                 {

                  if(OrderSend(Symbol(),OP_SELLSTOP,jiaCangBS*lots,Bid-jc_point*Point(),3,0,0,mark,magic)<0)
                    {

                     Alert("挂跌单失败！");
                     Print("OrderSend failed with error #",GetLastError());
                    }
                 }
              }
            else
              {
               if(bGua!=0)
                 {
                  for(int j=total-1; j>=0; j--)
                    {
                     if(OrderSelect(j,SELECT_BY_POS))
                       {
                        if(OrderSymbol()==Symbol())
                          {
                           int guaOrderTicket = OrderTicket();
                           if(OrderOpenPrice()-Ask>=jc_point_js*Point())
                             {

                              if(OrderSend(Symbol(),OP_BUYSTOP,OrderLots(),Ask+jc_point*Point(),3,0,0,mark,magic)<0)
                                {

                                 Alert("挂涨单失败！");
                                 Print("OrderSend failed with error #",GetLastError());
                                }
                              else
                                {
                                 OrderDelete(guaOrderTicket);
                                }

                             }

                           break;
                          }
                       }
                    }

                 }

               else
                  if(sGua!=0)
                    {

                     for(int j=total-1; j>=0; j--)
                       {
                        if(OrderSelect(j,SELECT_BY_POS))
                          {
                           if(OrderSymbol()==Symbol())
                             {
                              int guaOrderTicket = OrderTicket();

                              if(Bid-OrderOpenPrice()>=jc_point_js*Point())
                                {

                                 if(OrderSend(Symbol(),OP_SELLSTOP,OrderLots(),Bid-jc_point*Point(),3,0,0,mark,magic)<0)
                                   {
                                    Alert("挂跌单失败！");
                                    Print("OrderSend failed with error #",GetLastError());

                                   }
                                 else
                                   {
                                    OrderDelete(guaOrderTicket);
                                   }

                                }
                              break;
                             }
                          }
                       }
                    }





              }

            break;
           }

        }
     }


  }

//+------------------------------------------------------------------+
void shouDan()
  {
   if(jy.CheckOrderByaSymbol(Symbol())==0)
     {
      jy.ColseOrderGuaBySymbol(Symbol());
      if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic)<0)
        {
         Alert("发送订单失败！");
         Print("OrderSend failed with error #",GetLastError());
        }


     }
  }
//+------------------------------------------------------------------+
