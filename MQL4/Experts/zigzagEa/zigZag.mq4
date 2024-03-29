//+------------------------------------------------------------------+
//|                                              zhiNengJiaoYi_3.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
extern double volume=0.1;
extern int zhiShunDian = 3000;//止损点数
extern int ZS_P_S= 200;//移动止损点位
extern  int ZS_P_E =100;//移动止损点数
datetime alarm=0;
string mark = "Matrix_ZIGZAG";
input int magic=612973;//魔术号
input double profit = 5;//出仓利润
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
//---

//---
 EventSetTimer(5);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
  }
 void OnTimer()
  {
   jy.mobileStopLoss(Symbol(),ZS_P_S,ZS_P_E); 
    zigZag();
    zhiShun();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执行一遍代码。
     {
     jy.mobileStopLoss(Symbol(),ZS_P_S,ZS_P_E);
      //close();
      //buy();
      zigZag();
      zhiShun();
      alarm=Time[0];
     }

  }
bool isJSZigZag = true;
double zigZag[3];
double zigZag_HC[3];
void zigZag(){
  int jishu=0;
   for(int i=1; i<1000; i++)
     {
      double zigZagZhi = iCustom(Symbol(),0,"ZigZag",13,0,i);
      if(i==1 && zigZagZhi==0)
         return;
      if(zigZagZhi>0)
        {
         zigZag[jishu]=zigZagZhi;
         jishu++;
        }
      if(jishu>=ArraySize(zigZag))
        {
         break;
        }
     }
   
    if(zigZag_HC[1]!=zigZag[1]){
     xiaDan(zigZag,zigZag_HC);
     /* int buyOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_BUY);
      int sellOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_SELL);
      if(buyOrder!=0 || sellOrder!=0){
         jy.ColseOrderGuaBySymbol(Symbol());
        
      }
      double buyPrice=Ask;
      double sellPrice=Bid;
      if(zigZag[0]>=zigZag[1]){
          buyPrice = zigZag[2]+100*Point();
          if(Ask>buyPrice){
          buyPrice=Ask+20*Point();
          }
          sellPrice = zigZag[1]-100*Point();
         if(Bid<sellPrice){
          sellPrice=Bid-20*Point();
         }
      } 
      if(zigZag[0]<zigZag[1]){
          buyPrice = zigZag[1]+100*Point();
          sellPrice = zigZag[2]-100*Point();
          if(Ask>buyPrice){
          buyPrice=Ask+20*Point();
          }
          if(Bid<sellPrice){
          sellPrice=Bid-20*Point();
         }
      }
        printf("买价="+buyPrice);
        printf("卖价="+sellPrice);
       OrderSend(Symbol(),OP_BUYSTOP,volume,buyPrice,3,0,0,mark,magic);
       OrderSend(Symbol(),OP_SELLSTOP,volume,sellPrice,3,0,0,mark,magic);*/
   
      ArrayCopy(zigZag_HC,zigZag);
        
    }
   
  }

void xiaDan(double &zigZag[],double &zigZag_HC[]){
   if(zigZag[1]!=zigZag_HC[1]){
      int buyOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_BUYSTOP);
      int sellOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_SELLSTOP);
      if(buyOrder!=0 || sellOrder!=0){
         jy.ColseOrderGuaBySymbol(Symbol());
        
      }
      double buyPrice;
      double sellPrice;
      if(zigZag[0]>zigZag[1]){
          buyPrice = zigZag[2]+100*Point();
          sellPrice = zigZag[1]-100*Point();
        
      } 
      if(zigZag[0]<zigZag[1]){
          buyPrice = zigZag[1]+100*Point();
          sellPrice = zigZag[2]-100*Point();
      }
       OrderSend(Symbol(),OP_BUYSTOP,volume,buyPrice,3,0,0,mark,magic);
       OrderSend(Symbol(),OP_SELLSTOP,volume,sellPrice,3,0,0,mark,magic);
   }
 
}

//+------------------------------------------------------------------+
void close()
  {

   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>profit)
     {

      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY)==0)
        {
         Alert("盈利出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }


     }

   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
        {
         Alert("盈利出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }


     }
  }
  int guDingZhiShunDian=3000;
  void zhiShun()
  {
   int total = OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY && OrderStopLoss()==0)
              {
               OrderModify(OrderTicket(),OrderOpenPrice(),Bid-guDingZhiShunDian*Point(),OrderTakeProfit(),0,clrNONE);
              }
            if(OrderType()==OP_SELL && OrderStopLoss()==0)
              {
               OrderModify(OrderTicket(),OrderOpenPrice(),Ask+guDingZhiShunDian*Point(),OrderTakeProfit(),0,clrNONE);
              }

           }
        }
     }
  }