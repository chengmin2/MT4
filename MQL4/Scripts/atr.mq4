//+------------------------------------------------------------------+
//|                                                          atr.mq4 |
//|                                                       ChinaCheng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ChinaCheng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
#include <WinUser32.mqh>

void OnStart()
  {
   SendMessageW(0,7,0,0);
  //Alert(iCustom(Symbol(),0,"ATR",3,0,1));
  }
//+------------------------------------------------------------------+
