//+------------------------------------------------------------------+
//|                                                   L_H_xinhao.mq4 |
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
          // double bei =   iCustom(Symbol(),0,"myZhiBiao/ztr_zf_3bei_LH",10,3,2,6);
           // double bei2 =   iCustom(Symbol(),0,"myZhiBiao/ztr_zf_3bei_LH",10,3,3,6);
            // double bei3 =   iCustom(Symbol(),0,"myZhiBiao/ztr_zf_3bei_LH",10,3,4,6);
    //Alert(bei);
    // Alert(bei2);
    // Alert(bei3);
  double  t =   iCustom(Symbol(),60,"顺势箭头aa",
   1,2);
   Alert(t);
  }
//+------------------------------------------------------------------+
