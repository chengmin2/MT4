//+------------------------------------------------------------------+
//|                                                       locked.mq4 |
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
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
extern int magic=612973;//魔术号
extern string  sc_mark="Matrix_sc";//锁仓标识
void OnStart()
  {
    suoCang();

  }
//+------------------------------------------------------------------+
 void suoCang()
  {

   double buyVolume = jy.totalVolumeBySymbol(Symbol(),OP_BUY);
   double sellVolume = jy.totalVolumeBySymbol(Symbol(),OP_SELL);

   if(buyVolume == sellVolume)
     {
      Alert("已锁仓/当前处于平衡，操作失败！");
     }
   else
      if(buyVolume>sellVolume)
        {

         if(OrderSend(Symbol(),OP_SELL,buyVolume-sellVolume,Bid,2,0,0,sc_mark,magic)<0)
           {
            Alert("锁仓失败！");
            Print("OrderSend failed with error #",GetLastError());

           }
        

        }
      else
         if(buyVolume<sellVolume)
           {
            if(OrderSend(Symbol(),OP_BUY,sellVolume-buyVolume,Ask,2,0,0,sc_mark,magic)<0)
              {

               Alert("锁仓失败！");
               Print("OrderSend failed with error #",GetLastError());
              }
            
           }
  }