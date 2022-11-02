//+------------------------------------------------------------------+
//|                                                        QS_DW.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
int magic=123456;
double volume=0.5;
int points=100;
datetime time=0;
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
  if(time!=Time[0]){
   if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)==0 &&
         jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL)==0)
        {
        
        double IMA_0=iMA(Symbol(),0,10,0,MODE_SMA,PRICE_OPEN,0);
   double IMA_OPRICE_0 = Open[0];
   double IMA_10=iMA(Symbol(),0,10,0,MODE_SMA,PRICE_OPEN,5);
   double IMA_OPRICE_10 = Open[10];
   double IMA_1H=iMA(Symbol(),0,10,0,MODE_SMA,PRICE_OPEN,PERIOD_H1);
   double IMA_OPRICE_1H = Open[60];
   /*if(IMA_0>IMA_10 && IMA_10>IMA_1H){
      OrderSend(Symbol(),OP_BUY,volume,Ask,3,Open[10],Open[10]-Open[60]+Open[0],"buy",magic);
   }
    if(IMA_1H<IMA_0 && IMA_0>IMA_10){
      OrderSend(Symbol(),OP_BUY,volume,Ask,3,Open[10],Open[60],"buy",magic);
   }
   if(IMA_0<IMA_10 && IMA_10<IMA_1H){
      OrderSend(Symbol(),OP_SELL,volume,Bid,3,Open[10],IMA_0-(IMA_1H-IMA_10),"sell",magic);
   }
   if(IMA_0<IMA_10 && IMA_0>IMA_1H){
      OrderSend(Symbol(),OP_SELL,volume,Bid,3,Open[10],Open[60],"sell",magic);
   }*/
     if(IMA_0<IMA_10){
     OrderSend(Symbol(),OP_SELL,volume,Bid,3,Bid+50*Point(),Bid-150*Point(),"sell",magic);
   }
    if(IMA_0>IMA_10){
    OrderSend(Symbol(),OP_BUY,volume,Ask,3,Ask-50*Point(),Ask+150*Point(),"buy",magic);
   }

        }
   
   time=Time[0];
   }
  }
//+------------------------------------------------------------------+
