//+------------------------------------------------------------------+
//|                                                    localTime.mq4 |
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
  //Alert(TimeHour(TimeLocal()));
   Alert(TimeMinute(Time[1]-Time[2]));
  }
//+------------------------------------------------------------------+
