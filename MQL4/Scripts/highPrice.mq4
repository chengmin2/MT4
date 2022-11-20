//+------------------------------------------------------------------+
//|                                                    highPrice.mq4 |
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
void OnStart()
  {
//---
 Alert(iHigh(Symbol(),0,iHighest(Symbol(),0,MODE_HIGH,24,0)));
   
  }
//+------------------------------------------------------------------+
