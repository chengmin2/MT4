//+------------------------------------------------------------------+
//|                                                         enum.mq4 |
//|                                                       ChinaCheng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ChinaCheng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+


enum project{base=1,pro=2,lite=3};

extern project fa;

void OnStart()

{

 Print(fa);

}

   
  
//+------------------------------------------------------------------+
