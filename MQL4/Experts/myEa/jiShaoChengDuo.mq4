//+------------------------------------------------------------------+
//|                                               jiShaoChengDuo.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
datetime alarm=0;
int magic=123456;
double volume=0.01;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
   OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }

void OnTick()
  {
     if(alarm!=Time[0]){
       jy.JiLinWeiZheng(Symbol(),magic,volume);
      alarm=Time[0];
     }
     
  }
//+------------------------------------------------------------------+
