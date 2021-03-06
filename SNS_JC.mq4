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
int magic_s=123456;
int magic_n=654321;
input double volume=0.01;//起始手数
input double fengKong = 0.1;//风控比列
input int jiShu_s=40;//顺势加仓点位
input int ss_guaDian=50;//顺势挂仓点
input int jishu_n=130;//逆势加仓点
extern double ns_profit=2;//逆势出仓利润
extern double ss_profit=4;//顺势出仓利润
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
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      if(jy.riskMangement(fengKong))
        {
         Alert("达到风控值,已停运EA！");
         ExpertRemove();
        }
      if(jy.CheckOrderByaSymbol(Symbol(),magic_s,OP_BUY)==0 &&
         jy.CheckOrderByaSymbol(Symbol(),magic_s,OP_SELL)==0)
        {
         //jy.iSendOrder(jy.iSingal(Symbol()),Symbol(),volume,magic_s);
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic_s);

        }
      if(jy.CheckOrderByaSymbol(Symbol(),magic_n,OP_SELL)==0
         && jy.CheckOrderByaSymbol(Symbol(),magic_n,OP_BUY)==0)
        {
         // jy.iSendOrder(jy.iSingal(Symbol()),Symbol(),volume,magic_n);
         OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,"sell",magic_n);

        }

      niShiJC();
      shunShiJC();
      close();
      alarm=Time[0];
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void niShiJC()
  {
   int totals = OrdersTotal();
   string symbol = Symbol();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic_n==OrderMagicNumber())
           {
            double lots = OrderLots();
            double openPrice = OrderOpenPrice();
            //最近一单为多单
            if(OrderType()==OP_BUY)
              {
               if((openPrice-Bid)/Point()>jishu_n)//多单亏损加仓
                 {
                  int buyNum = jy.CheckOrderByaSymbol(symbol,magic_n,OP_BUY);
                  double buyLots = buyNum/4*2*0.01+0.01+lots;
                  if(OrderSend(symbol,OP_BUY,buyLots,Ask,3,0,0,"buy",magic_n)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());

                    }
                  break;
                 }
               if((Bid-openPrice)/Point()>jishu_n)//多单盈利 空单加仓
                 {
                  int sellDan = jy.CheckOrderByaSymbol(symbol,magic_n,OP_SELL);
                  if(sellDan==0)
                    {
                     if(OrderSend(symbol,OP_SELL,volume,Bid,3,0,0,"sell",magic_n)<0)
                       {

                        Print("OrderSend failed with error #",GetLastError());

                       }
                    }
                  else
                     if(sellDan>0)
                       {
                        for(int j=totals-1; j>=0; j--)
                          {
                           if(OrderSelect(j, SELECT_BY_POS))
                             {
                              if(OrderSymbol()==symbol && OrderType()==OP_SELL && OrderMagicNumber()==magic_n)
                                {
                                 double sellLots = sellDan/4*2*0.01+0.01+OrderLots();
                                 if(OrderSend(symbol,OP_SELL,sellLots,Bid,3,0,0,"sell",magic_n)<0)
                                   {
                                    Print("OrderSend failed with error #",GetLastError());

                                   }
                                 break;
                                }
                             }
                          }
                        break;

                       }
                  break;
                 }

              }
            //最新一单为空单
            if(OrderType()==OP_SELL)
              {
               if((Ask-openPrice)/Point()>jishu_n)//空单亏损 加仓
                 {
                  int sellNum = jy.CheckOrderByaSymbol(symbol,magic_n,OP_SELL);
                  double sellLots = sellNum/4*2*0.01+0.01+lots;
                  if(OrderSend(symbol,OP_SELL,sellLots,Bid,3,0,0,"sell",magic_n)<0)
                     Print("OrderSend failed with error #",GetLastError());


                 }
               if((openPrice-Ask)/Point()>jishu_n)//空单盈利  多单加仓
                 {

                  // printf("进入空单盈利");
                  int buyDan = jy.CheckOrderByaSymbol(symbol,magic_n,OP_BUY);
                  if(buyDan==0)
                    {
                     if(OrderSend(symbol,OP_BUY,volume,Ask,3,0,0,"buy",magic_n)<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());

                       }
                    }
                  else
                     if(buyDan>0)
                       {
                        for(int j=totals-1; j>=0; j--)
                          {
                           if(OrderSelect(j, SELECT_BY_POS))
                             {
                              if(OrderSymbol()==symbol && OrderType()==OP_BUY)
                                {
                                 double buylLots = buyDan/4*2*0.01+0.01+OrderLots();
                                 if(OrderSend(symbol,OP_BUY,buylLots,Ask,3,0,0,"buy",magic_n)<0)
                                   {
                                    Print("OrderSend failed with error #",GetLastError());

                                   }
                                 break;
                                }
                             }
                          }
                       }

                  break;
                 }
               break;
              }
            break;
           }


        }

     }
  }


//+------------------------------------------------------------------+
void shunShiJC()
  {
   int totals = OrdersTotal();
   string symbol = Symbol();
   int ticket;
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic_s==OrderMagicNumber() && OrderType()==OP_SELL)
           {
            double s = OrderLots();
            if(OrderOpenPrice()-Bid>jiShu_s*Point())
              {
               if(s<0.07)
                 {
                  if(s==0.04)
                    {
                     ss_profit=7;
                    }
                  int sellNum = jy.CheckOrderByaSymbol(symbol,magic_s,OP_SELL);
                  double sellLots = sellNum/4*2*0.01+0.01+s;
                  ticket = OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,"sell",magic_s);
                  if(ticket<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开空单失败！");
                    }
                 }

              }
            if(Bid-OrderOpenPrice()>2*jiShu_s*Point())
              {
               int buyNum = jy.CheckOrderByaSymbol(symbol,magic_s,OP_BUY);
               int buyNumGua = jy.CheckOrderByaSymbol(symbol,magic_s,OP_BUYSTOP);
               if(buyNum==0 && buyNumGua==0)
                 {
                  ticket = OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+ss_guaDian*Point(),3,0,0,"buyStop",magic_s);
                  if(ticket<0)
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
                        if(OrderSymbol()==symbol && magic_s==OrderMagicNumber() && OrderType()==OP_BUY)
                          {
                           double b = OrderLots();
                           double buyLots = buyNum/4*2*0.01+0.01+b;
                           ticket= OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,"buy",magic_s);
                           if(ticket<0)
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
         if(OrderSymbol()==symbol && magic_s==OrderMagicNumber() && OrderType()==OP_BUY)
           {
            double b = OrderLots();
            if(Ask-OrderOpenPrice()>jiShu_s*Point())
              {
               if(b<0.07)
                 {
                  if(b==0.04)
                    {
                     ss_profit=7;
                    }
                  int buyNum = jy.CheckOrderByaSymbol(symbol,magic_s,OP_BUY);
                  double buyLots = buyNum/4*2*0.01+0.01+b;
                  ticket= OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,"buy",magic_s);
                  if(ticket<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开多单失败！");
                    }
                 }

              }
            if(OrderOpenPrice()-Ask>2*jiShu_s*Point())
              {
               int sellNum = jy.CheckOrderByaSymbol(symbol,magic_s,OP_SELL);
               int sellNumGua = jy.CheckOrderByaSymbol(symbol,magic_s,OP_SELLSTOP);
               if(sellNum==0 && sellNumGua==0)
                 {
                  ticket = OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-ss_guaDian*Point(),3,0,0,"sellStop",magic_s);
                  if(ticket<0)
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
                        if(OrderSymbol()==symbol && magic_s==OrderMagicNumber() && OrderType()==OP_SELL)
                          {
                           double s = OrderLots();
                           double sellLots = sellNum/4*2*0.01+0.01+s;
                           ticket= OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,"sell",magic_s);
                           if(ticket<0)
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
   int rt;
   if(jy.profitBySymbolTotal(Symbol(),magic_n,OP_BUY)>ns_profit)
     {
      rt = jy.ColseOrderBySymbol(Symbol(),magic_n,OP_BUY);
      if(rt==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic_n,OP_SELL)>ns_profit)
     {
      rt = jy.ColseOrderBySymbol(Symbol(),magic_n,OP_SELL);
      if(rt==0)
         Alert("关闭空单交易出错！");
     }
   if(jy.profitBySymbolTotal(Symbol(),magic_s,OP_BUY)>ss_profit)
     {
      ss_profit=4;
      jy.ColseOrderGuaBySymbol(Symbol(),magic_s);
      rt = jy.ColseOrderBySymbol(Symbol(),magic_s,OP_BUY);
      if(rt==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic_s,OP_SELL)>ss_profit)
     {
      ss_profit=4;
      jy.ColseOrderGuaBySymbol(Symbol(),magic_s);
      rt = jy.ColseOrderBySymbol(Symbol(),magic_s,OP_SELL);
      if(rt==0)
         Alert("关闭空单交易出错！");
     }

  }
