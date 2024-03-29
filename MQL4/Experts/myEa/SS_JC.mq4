//+------------------------------------------------------------------+
//|                                                       SNS_JC.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
datetime alarm=0;
input double volume=0.01;//起始手数
input double fengKong = 1;//风控比列
extern double profit=2;//顺势出仓利润
input double min_unit=0.01;//最小计量单位
input int jiShu=30;//顺势加仓点位
input int huiCeDian=100;//回撤顺势点
input int guaDian=50;//挂单点位
input double accountType=1;//账户类型（美元:1;美角:0.1）
string mark = "Matrix_SS";//标识
int magic=612973;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+-
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {


  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//jy.closeHandMovement();
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      close();
     // jy.mobileStopLoss(Symbol(),magic,200,100);
      jy.deleteGuanDanByPrice(Symbol(),(huiCeDian+guaDian),magic);
      if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
        {
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic);
         OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic);

        }
      shunShiJC();
      alarm=Time[0];
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   int rt;
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>profit)
     {
      profit=2*accountType;
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      rt = jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY);
      if(rt==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>profit)
     {
      profit=2*accountType;
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      rt = jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL);
      if(rt==0)
         Alert("关闭空单交易出错！");
     }

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void shunShiJC()
  {
   int totals = OrdersTotal();
   string symbol = Symbol();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber() && OrderType()==OP_SELL)
           {
            double s = OrderLots();
            if(OrderOpenPrice()-Bid>jiShu*Point())
              {
               if(s<0.07)
                 {
                  if(0.03<s && s<=0.05)
                     profit=6;
                  int sellNum = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);
                  double sellLots;
                  if(sellNum<4)
                    {
                     sellLots = s+0.01;
                    }
                  else
                    {
                     sellLots = sellNum*0.01+s;
                    }
                  if(OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开空单失败！");
                    }


                 }

              }
            if(Bid-OrderOpenPrice()>huiCeDian*Point())
              {
               int buyNum = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
               int buyNumGua = jy.CheckOrderByaSymbol(symbol,magic,OP_BUYSTOP);
               if(buyNum==0 && buyNumGua==0)
                 {
                  if(OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+guaDian*Point(),3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("挂多单失败！");
                    }
                 }
               else
                 {
                  for(int j=totals-1; j>=0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==symbol && magic==OrderMagicNumber() && OrderType()==OP_BUY)
                          {
                           double b = OrderLots();
                           double buyLots ;
                           if(buyNum<4)
                             {
                              buyLots = b+0.01;
                             }
                           else
                             {
                              buyLots =  buyNum*0.01+b;
                             }
                           if(AccountFreeMargin()<=0)
                             {
                              if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)>jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL))
                                 return;//保证金小于0停止继续加仓
                             }
                           if(OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,mark,magic)<0)
                             {
                              Print("OrderSend failed with error #",GetLastError());
                              Alert("开多单失败！");
                             }


                           break;
                          }

                       }

                    }

                 }

              }
            break;
           }
         if(OrderSymbol()==symbol && magic==OrderMagicNumber() && OrderType()==OP_BUY)
           {
            double b = OrderLots();
            if(Ask-OrderOpenPrice()>jiShu*Point())
              {
               if(b<0.07)
                 {
                  if(0.03<b && b<=0.05)
                     profit=6;
                  int buyNum = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
                  double buyLots;
                  if(buyNum<4)
                    {
                     buyLots = b+0.01;
                    }
                  else
                    {
                     buyLots = buyNum*0.01+b;
                    }
                  if(OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开多单失败！");
                    }


                 }

              }
            if(OrderOpenPrice()-Ask>huiCeDian*Point())
              {
               int sellNum = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);
               int sellNumGua = jy.CheckOrderByaSymbol(symbol,magic,OP_SELLSTOP);
               if(sellNum==0 && sellNumGua==0)
                 {
                  if(OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-guaDian*Point(),3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("挂多单失败！");
                    }
                 }
               else
                 {
                  for(int j=totals-1; j>=0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==symbol && magic==OrderMagicNumber() && OrderType()==OP_SELL)
                          {
                           double s = OrderLots();
                           double sellLots;
                           if(sellNum<4)
                             {
                              sellLots = s+0.01;
                             }
                           else
                             {
                              sellLots = sellNum*0.01+s;
                             }
                           if(AccountFreeMargin()<=0)
                             {
                              if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)<jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL))
                                 return;//保证金小于0停止继续加仓
                             }
                           if(OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,mark,magic)<0)
                             {
                              Print("OrderSend failed with error #",GetLastError());
                              Alert("开空单失败！");
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
   jy.deleteGuanDanByPrice(Symbol(),(huiCeDian+guaDian),magic);
   close();
  }


