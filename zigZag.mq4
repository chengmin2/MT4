//+------------------------------------------------------------------+
//|                                              zhiNengJiaoYi_3.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
extern double volume=0.1;
datetime alarm=0;
extern int xiaoZhouQi=10;
extern int daZhouQi =20;
int magic=123456;
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
if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执行一遍代码。
     {
  
          buy();
     
     
      alarm=Time[0];
     }
   
  }
//+------------------------------------------------------------------+
 void buy(){      
     jy.zigZag(Symbol(),volume,magic);
   
   }