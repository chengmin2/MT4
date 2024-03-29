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
input double cc_profit=10;//出仓利润
input int jc_point=100;//加仓点位
extern int jc_point_js=200;//加仓计算位
string mark = "Matrix_NJ";//标识
#include <myInclude\ZhiNengJiaoYi.mqh>

ZhiNengJiaoYi jy;
int OnInit()
  {
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {

      kaiDan();
      close();
      alarm=Time[0];

     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void kaiDan()
  {
   int order = jy.CheckOrderByaSymbol(Symbol());
   if(order==0)
     {
      zigZag();
      timeAstrict();
      
     }


  }
extern bool isTimeAstict = true;//是否开启时间段限制
extern bool isSS = false;//是否顺
extern int zhishun = 400;//止损
bool isDayHaveOrder =  false;
void timeAstrict()
  {
   int h = TimeHour(TimeGMT());//盘面时间
   if(isTimeAstict)
     {
      if(h>=0 && h<2 && !isDayHaveOrder)
        {
         if(isSS)
           {
            if(zigZag[0]<zigZag[1])
              {
               OrderSend(Symbol(),OP_SELL,volume,Bid,3,Ask+zhishun*Point(),0,mark,magic,clrRed);
               isDayHaveOrder=true;
              
              }
            else
               if(zigZag[0]>zigZag[1])
                 {
                  OrderSend(Symbol(),OP_BUY,volume,Ask,3,Bid-zhishun*Point(),0,mark,magic,clrRed);
                  isDayHaveOrder=true;
                 
                 }
           }
         else
           {
            if(zigZag[0]>zigZag[1])
              {
              if(!isKHaveZhi() || Open[0]>Close[1]+40*Point()){
                OrderSend(Symbol(),OP_SELL,volume,Bid,3,Ask+zhishun*Point(),0,mark,magic,clrRed);
                isDayHaveOrder=true;
             
              }
               
              }
            else
               if(zigZag[0]<zigZag[1])
                 {
                 if(!isKHaveZhi() || Open[0]<Close[1]-40*Point()){
                    OrderSend(Symbol(),OP_BUY,volume,Ask,3,Bid-zhishun*Point(),0,mark,magic,clrRed);
                   isDayHaveOrder=true;
                  }   
                 }

           }

        }
      if(h>1)
        {
         isDayHaveOrder=false;

        }
     }

  }
//+------------------------------------------------------------------+
double zigZag[3];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zigZag()
  {
   int jishu=0;
   for(int i=1; i<1000; i++)
     {
      //printf("i="+i);
      double zigZagZhi = iCustom(Symbol(),0,"ZigZag",13,0,i);

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
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
extern double profit = 100;//利润值
void close()
  {
   double thisprofit = jy.profitBySymbolTotal(Symbol());
   printf("thisprofit="+thisprofit);
   if(thisprofit>=profit)
     {
      jy.ColseOrderBySymbol(Symbol());
     }


  }
extern int k = 7;//K线数
bool isKHaveZhi(){

   for(int i=1; i<k; i++)
     {
      //printf("i="+i);
      double zigZagZhi = iCustom(Symbol(),0,"ZigZag",13,0,i);

      if(zigZagZhi>0)
        {
         return true;
        }
        
      
     }
     return false;

}
//+------------------------------------------------------------------+
