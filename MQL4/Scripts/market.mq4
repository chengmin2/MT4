//+------------------------------------------------------------------+
//|                                                       market.mq4 |
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
  Alert(MarketInfo("EURUSD",MODE_BID)); 
  }
//+------------------------------------------------------------------+
