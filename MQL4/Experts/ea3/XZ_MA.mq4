//+------------------------------------------------------------------+
//|                                                           MA.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input int magic=612973;//魔术号
input double volume=0.01;//初始手数
input double mallUnits=0.01;//最小单位
double thisVolume;//当前手数
double thisVolume2;//当前手数
string mark = "Matrix_MA";
input int da_zhouqi=30;//大周期
input int xiao_zhouqi=10;//小周期
input double profit = 5;//出仓利润
input int time=0;//时间周期
datetime 限制运行时间 = D'2022.02.24 00:00';  
#include <ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
datetime alarm=0;
#import "matrix.dll"
  double ma_thisVolume(double c_mallUnits,double c_Orders);
  int maBorS(double xiao1_ma, double xiao2_ma, double da1_ma, double da2_ma);
#import
int OnInit()
  {
   datetime time = TimeCurrent();
  if(time>限制运行时间){
   MessageBox("该EA已过使用日期，请联系作者15708448760","过期");
   ExpertRemove();
  }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
printf("总手数："+totalVolume);

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
double totalVolume=0;
void OnTick()
  {
   if(alarm!=Time[0])
     {

      close();
      //jy.mobileStopLoss(Symbol(),magic,200,100);

      double da1_ma=jy.ima(Symbol(),da_zhouqi,0,time);
      double da2_ma=jy.ima(Symbol(),da_zhouqi,1,time);
      double xiao1_ma=jy.ima(Symbol(),xiao_zhouqi,0,time);
      double xiao2_ma=jy.ima(Symbol(),xiao_zhouqi,1,time);
      int returnBS=maBorS(xiao1_ma,xiao2_ma,da1_ma,da2_ma);
      if(returnBS==1) //上
        {

         int buyOrder = jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY);
         thisVolume = ma_thisVolume(mallUnits,buyOrder);
      
         OrderSend(Symbol(),OP_BUY,thisVolume,Ask,3,0,0,mark,magic);
         totalVolume = volume*(buyOrder+1)+totalVolume;
        }
      if(returnBS==0) //下
        {
         int sellOrder = jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL);
   
         thisVolume = ma_thisVolume(mallUnits,sellOrder);
         OrderSend(Symbol(),OP_SELL,thisVolume,Bid,3,0,0,mark,magic);
         totalVolume = volume*(sellOrder+1)+totalVolume;
        }
      alarm=Time[0];
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
//+------------------------------------------------------------------+
