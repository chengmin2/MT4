//+------------------------------------------------------------------+
//|                                                      CCI_RSI.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
extern int k=10;
void OnStart()
  {
  EMPTY_VALUE;
   Alert(iCustom(Symbol(),0,"Superrow",5,12,12,1,10,0,0.5,50,50,true,10,0,24),"-- ",iCustom(Symbol(),0,"Superrow",5,12,12,1,10,0,0.5,50,50,true,10,1,24));
 
  }
//+------------------------------------------------------------------+
