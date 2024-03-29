//+------------------------------------------------------------------+
//|                                                        study.mq4 |
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
input double volume=0.01;//起始手数
extern int points=600;//反向加仓点位
extern int jcNum = 4;//加仓次数
input int magic=123456;//魔术号
input double profit=10;//出仓利润
double fengKong = 0.3;//风控
datetime alarm=0;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执行一遍代码。
     {
      if(jy.riskMangement(fengKong))
        {
         Alert("达到风控值,已停运EA！");
         ExpertRemove();
        }
        jy.closeHandMovement();//半自动检测
      // if(TimeHour(TimeLocal())>=20 || 10<TimeHour(TimeLocal())<18){
      if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
        {
         if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic)<0)
           {
            Alert("发送订单失败！");
            Print("OrderSend failed with error #",GetLastError());
           }
        }
       close();
      if(jy.fanXianJC(Symbol(),magic,points,jcNum)==0)
        {
         Alert("反向加仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }


      alarm=Time[0];
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {

   if(jy.profitBySymbolTotal(Symbol(),magic)>profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic)==0)
        {
         Alert("盈利出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
     }
  }
//+------------------------------------------------------------------+
