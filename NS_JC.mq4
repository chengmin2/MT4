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
input int magic=123456;//魔术号
input double volume=0.01;//起始手数
input double cc_profit=2;//出仓利润
input int jc_point=100;//加仓点位
input double fengKong = 0.1;//风控比列
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
   if(AccountProfit()<0)
     {
       if(jy.riskMangement(fengKong)){
            Alert("达到风控值,已停运EA！");
         ExpertRemove();
         }

     }
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
        {
         if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic)<0)
           {
            Alert("发送订单失败！");
            Print("OrderSend failed with error #",GetLastError());
           }
        }
      if(jy.niSiJiaCang(Symbol(),volume,magic,jc_point)==0)
        {
         Alert("加仓交易出错！");
         Print("OrderSend failed with error #",GetLastError());
        }

      alarm=Time[0];
      Sleep(800);
     }
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>cc_profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY)==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>cc_profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
         Alert("关闭空单交易出错！");
     }

  }


//+------------------------------------------------------------------+
