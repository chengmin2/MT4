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
void OnStart()
  {
   Alert(iCustom(Symbol(),0,"CCI",14,0,0)," ",iCustom(Symbol(),0,"RSI",14,0,0));
   Alert(iCustom(Symbol(),0,"CCI",14,0,1)," ",iCustom(Symbol(),0,"RSI",14,0,1));
  }
//+------------------------------------------------------------------+
