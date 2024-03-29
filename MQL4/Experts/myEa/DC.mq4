//+------------------------------------------------------------------+
//|                                                           DC.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
datetime alarm=0;
extern double profit=2;//初始出仓利润
extern  string mark = "Matrix_SJ";//标识
extern int magic=1;//魔术号
input int profitPoint=300;//盈利点
input int huiCeDian=100;//回撤点
input int jiaCdian=300;//加仓点
input double volume=0.02;//起始手数
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
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

      if(OrdersTotal()<100)
        {
         magic=magic+1;
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic);
         OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic);
        }

      jy.mobileStopLoss(Symbol(),magic,profitPoint,huiCeDian);



      int totals = OrdersHistoryTotal();
      int tot = OrdersTotal();
      // if(tot==1){
      for(int j=0; j<tot; j++)
        {
         //当前订单筛选
         if(OrderSelect(j,SELECT_BY_POS))
           {
            if(OrderSymbol()==Symbol() && mark==OrderComment())
              {
               int t_magic= OrderMagicNumber();
               double t_profit = OrderProfit()+OrderCommission()+OrderSwap();

               int ticket=OrderTicket();
               printf("市价单号："+ticket);
               double lot = OrderLots();
               int type =OrderType();
               bool ls = true;
               for(int k=0; k<tot; k++)
                 {
                  //筛选是否有对冲单
                  if(OrderSelect(k,SELECT_BY_POS))
                    {
                     if(OrderSymbol()==Symbol() && mark==OrderComment())
                       {
                        if(t_magic==OrderMagicNumber() && ticket!=OrderTicket())
                          {

                           //printf("存在对冲单");
                           ls=false;
                           break;
                          }

                       }
                    }
                 }


               //if(totals>200)
               // totals=200;

               if(ls)
                 {
                  for(int i=totals-1; i>=0; i--)
                    {
                     if(OrderSelect(i,SELECT_BY_POS, MODE_HISTORY))
                       {

                        /*if(TimeDay(OrderCloseTime())<TimeDay(TimeLocal())-1){
                          break;
                        }*/
                        if(OrderSymbol()==Symbol() &&  t_magic==OrderMagicNumber())
                          {
                           printf("进入历史订单筛选");
                           printf("历史订单号："+OrderTicket());
                           int h_magic = OrderMagicNumber();
                           double h_profit = OrderProfit()+OrderCommission()+OrderSwap();
                           printf("总体利润："+(t_profit+h_profit));
                           if(t_profit+h_profit>profit)
                             {
                              printf("订单号："+ticket);
                              printf("手数："+lot);
                              if(type==OP_BUY) //关闭买单
                                {

                                 if(!OrderClose(ticket,lot,Bid,3,Red))
                                   {
                                    Print("OrderClose failed with error #",GetLastError());
                                   }

                                }
                              if(type==OP_SELL) //关闭卖单
                                {
                                 if(!OrderClose(ticket,lot,Ask,3,Red))
                                   {
                                    Print("OrderClose failed with error #",GetLastError());
                                   }
                                }
                              break;
                             }
                           if(tot<200)
                             {
                              if(OrderType()==OP_BUY && Ask-OrderClosePrice()>jiaCdian*Point())
                                {
                                 printf("当前订单数："+tot);
                                 OrderSend(Symbol(),OP_BUY,2*OrderLots(),Ask,3,0,0,OrderComment(),t_magic);
                                 break;
                                }
                              if(OrderType()==OP_SELL && OrderClosePrice()-Bid>jiaCdian*Point())
                                {
                                 printf("当前订单数："+tot);
                                 OrderSend(Symbol(),OP_SELL,2*OrderLots(),Bid,3,0,0,OrderComment(),t_magic);
                                 break;
                                }
                             }
                           break;
                          }
                       }
                    }
                 }




              }
           }

        }
      // }




      alarm=Time[0];
     }
  }
//+------------------------------------------------------------------+
