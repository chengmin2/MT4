//+------------------------------------------------------------------+
//|                                              zhiNengJiaoYi_2.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
extern double volume=0.01;
datetime alarm=0;
extern int xiaoZhouQi=10;
extern int daZhouQi =20;
extern int magic=5131148;
extern int zhiSunNum = 300;
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
  
  if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执行一遍代码。
     {
     if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
        {
          buy();
        }
        jy.mobileStopLoss(Symbol(),magic,zhiSunNum);
      jy.fanXianJC(Symbol(),magic,400,6);
      if(jy.profitBySymbolTotal(Symbol(),magic)>5)
        {
         jy.ColseOrderBySymbol(Symbol(),magic);
         jy.ColseOrderGuaBySymbol(Symbol(),magic);
        }
      alarm=Time[0];
     }
   
  }
  
  void buy(){
  
   
   double xiao_0 = iMA(NULL,0,xiaoZhouQi,0,MODE_SMA,PRICE_CLOSE,0);
   double xiao_1 = iMA(NULL,0,xiaoZhouQi,0,MODE_SMA,PRICE_CLOSE,1);
  

   double da_0 = iMA(NULL,0,daZhouQi,0,MODE_SMA,PRICE_CLOSE,0);
   double da_1 = iMA(NULL,0,daZhouQi,0,MODE_SMA,PRICE_CLOSE,1);


   
   

   if(xiao_0>da_0 && xiao_1<da_1 && xiao_0>xiao_1){//上升
    
         //jy.ColseOrderBySymbol(Symbol(),magic);
         int ticket=OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic);
         if(ticket<0)
           {
            Print("OrderSend failed with error #",GetLastError());
           }
   }
   if(xiao_0<da_0 && xiao_1>da_1 && xiao_0<xiao_1){//下降
         //jy.ColseOrderBySymbol(Symbol(),magic);
         int ticket=OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,"sell",magic);
         if(ticket<0)
           {
            Print("OrderSend failed with error #",GetLastError());
           }
   }
 
      
     
  }
  
  
//+------------------------------------------------------------------+
