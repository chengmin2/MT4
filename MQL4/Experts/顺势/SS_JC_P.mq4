//+------------------------------------------------------------------+
//|                                                        SS_JC.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
datetime alarm=0;
input int magic=123456;//魔术号
input double volume=0.02;//起始手数
extern int jiShu=30;//顺势加仓点位
input int guaDian=50;//挂单点位
input double fengKong=0.99;//风控比列
extern double profit=2;//初始出仓利润
input double accountType=0.01;//账户类型（美元:0.01;美角:0.1;美分:1）
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
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
   jy.stopProfit(Symbol(),profit,magic,accountType);
   SendNotification("tinyun");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//jy.closeHandMovement();
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      if(jy.riskMangement(fengKong))
        {
         Alert("达到风控值,已停运EA！");
         SendNotification("tinyun");
         ExpertRemove();
        }
      if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL)==0)
        {
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic);
         OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,"sell",magic);
        }
      close();     
      shunShiJC();
      jy.deleteGuanDanByPrice(Symbol(),(2*jiShu+guaDian),magic);
      alarm=Time[0];
     }

  }
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
                  if(OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,"sell",magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开空单失败！");
                    }
                 }

              }            
            if(Bid-OrderOpenPrice()>3*jiShu*Point())
              {
              if(s>1) return;
               int buyNum = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
               int buyNumGua = jy.CheckOrderByaSymbol(symbol,magic,OP_BUYSTOP);
               if(buyNum==0 && buyNumGua==0)
                 {
                  if(OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+guaDian*Point(),3,0,0,"buyStop",magic)<0)
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
                           if(OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,"buy",magic)<0)
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
                  if(OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,"buy",magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开多单失败！");
                    }
                 }

              }
            if(OrderOpenPrice()-Ask>3*jiShu*Point())
              {
              if(b>1) return;
               int sellNum = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);
               int sellNumGua = jy.CheckOrderByaSymbol(symbol,magic,OP_SELLSTOP);
               if(sellNum==0 && sellNumGua==0)
                 {
                  if(OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-guaDian*Point(),3,0,0,"sellStop",magic)<0)
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
                           if(OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,"sell",magic)<0)
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

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>profit)
     {
      profit=2;
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY)==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>profit)
     {
      profit=2;
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
         Alert("关闭空单交易出错！");
     }

  }
