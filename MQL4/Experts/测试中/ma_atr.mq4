//+------------------------------------------------------------------+
//|                                                       ma_atr.mq4 |
//|                                                       ChinaCheng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ChinaCheng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
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
datetime alarm=0;
void OnTick()
  {

   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {  
      xiaDan();
      alarm=Time[0];

     }
  }
extern int k_shu = 15;//计算K线根数
extern double volume = 0.1;//起始手数
extern int magic=612973;//魔术号
extern string mark = "Matrix_ma_atr";//标识
extern int zhiSun_move = 1;//移动止损倍数
extern int zhiSun_start = 3;//初始止损倍数
void xiaDan()
  {
   double ma_5_0 = iMA(NULL,0,5,0,MODE_SMA,PRICE_CLOSE,1);
   double ma_5_1 = iMA(NULL,0,5,0,MODE_SMA,PRICE_CLOSE,2);
   double ma_13_0 = iMA(NULL,0,13,0,MODE_SMA,PRICE_CLOSE,1);
   double ma_13_1 = iMA(NULL,0,13,0,MODE_SMA,PRICE_CLOSE,2);
  
   double a;
   double avr;
   for(int i=1; i<k_shu; i++)
     {
      a=a+High[i]-Low[i];
     }
   avr=a/k_shu;
   
   int totals = OrdersTotal();
   int thisOrder = jy.CheckOrderByaSymbol(Symbol());
   int sellOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_SELL);
   int buyOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_BUY);
    int buyOrderGua = jy.CheckOrderByaSymbolType(Symbol(),OP_BUYSTOP);
     int sellOrderGua = jy.CheckOrderByaSymbolType(Symbol(),OP_SELLSTOP);
   
   if(ma_5_1<ma_13_1 && ma_5_0>ma_13_0) //金叉 buy
     { 
   
     jy.ColseOrderGuaBySymbol(Symbol());
     if(buyOrder==0){
        if(OrderSend(Symbol(),OP_BUYSTOP,volume,NormalizeDouble(Ask+2*avr,Digits),3,Ask-zhiSun_start*avr,0,mark,magic,0,clrRed)<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         Alert("涨单挂发送失败："+GetLastError());
        }
     }
      for(int i=totals-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(Symbol()==OrderSymbol() && OrderType()==OP_SELL)
              {
               bool res=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid+zhiSun_move*avr,Digits),0,0,Blue);
               if(!res)
                  Print("修改止损位失败=",GetLastError());
               else
                  Print("Order modified successfully.");



              }
           }
        }
     }
   else
      if(ma_5_1>ma_13_1 && ma_5_0<ma_13_0) //死叉 sell
        {
        
        jy.ColseOrderGuaBySymbol(Symbol());
        if(sellOrder==0){
         if(OrderSend(Symbol(),OP_SELLSTOP,volume, NormalizeDouble(Bid-2*avr,Digits),3,Bid+zhiSun_start*avr,0,mark,magic,0,clrRed)<0)
           {
            Print("OrderSend failed with error #",GetLastError());
            Alert("跌单挂发送失败："+GetLastError());
           }
        }   
         for(int i=totals-1; i>=0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS))
              {
               if(Symbol()==OrderSymbol() && OrderType()==OP_BUY)
                 {
                  bool res=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask-zhiSun_move*avr,Digits),0,0,Blue);
                  if(!res)
                     Print("修改止损位失败=",GetLastError());
                  else
                     Print("Order modified successfully.");


                 }
              }
           }
        }
  }

