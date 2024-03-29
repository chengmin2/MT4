//+------------------------------------------------------------------+
//|                                                 niShiJiaCnag.mq4 |
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
datetime alarm=0;
input int magic=612973;//魔术号
input double volume=0.1;//起始手数
input int jc_point=300;//加仓点位
extern bool isTimeAstict = true;//是否开启时间段限制
extern int XZ_H = 18;//时间分割线
extern int XZ_H_2 = 3;//时间分割线2
extern int openPoint=300;//开仓点位
extern int zhiSun=300;//止损
extern int zhiYing=300;//止赢
extern int maxDC = 25;//最大承受点差
string mark = "Matrix_NJ_PL";//标识
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double totalVolume=0;
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      int order = jy.CheckOrderByaSymbol(Symbol());
      if(order==0)
        {
         xiaDan();
        
        }
        if(TimeHour(Time[0])!=0) {
          close();
        }
      
      alarm=Time[0];

     }


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
extern double profit = 10;//出仓利润
extern double profit_2 = -10;//出仓利润
void close()
  {
 
      if(jy.profitBySymbolTotalType(Symbol(),OP_BUY)>profit || jy.profitBySymbolTotalType(Symbol(),OP_BUY)<profit_2)
        {
         if(jy.ColseOrderBySymbolType(Symbol(),OP_BUY)==0)
           {
            Print("OrderSend failed with error #",GetLastError());
            Alert("关闭多单交易出错！");

           }
        }
     
   
      if(jy.profitBySymbolTotalType(Symbol(),OP_SELL)>profit || jy.profitBySymbolTotalType(Symbol(),OP_SELL)<profit_2)
        {
         if(jy.ColseOrderBySymbolType(Symbol(),OP_SELL)==0)
           {
            Print("OrderSend failed with error #",GetLastError());
            Alert("关闭空单交易出错！");
           }

        }
     
  }

void xiaDan()
  {
   double thisLots;
   double cci_1 =  iCustom(Symbol(),0,"CCI",14,0,1);
   double rsi_1 = iCustom(Symbol(),0,"RSI",14,0,1);

   if((TimeHour(Time[0])<XZ_H && TimeHour(Time[0])>XZ_H_2) || TimeHour(Time[0])==0) return;
   if(Ask-Bid>maxDC*Point())
      return;
   if(cci_1<-200 && rsi_1<30)
     {
    
        
            if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,Ask-zhiSun*Point(),Ask+zhiYing*Point(),mark,magic,0,clrRed)<0)
              {
               Print("OrderSend failed with error #",GetLastError());
               Alert("小时首单涨单发送失败："+GetLastError());
              }
           


     }

   if(cci_1>200 && rsi_1>70)
     {
         
            if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,Bid+zhiSun*Point(),zhiYing*Point()
            ,mark,magic,0,clrRed)<0)
              {
               Print("OrderSend failed with error #",GetLastError());
               Alert("小时首单跌单发送失败："+GetLastError());
              }

           

     }

  }
//+------------------------------------------------------------------+
