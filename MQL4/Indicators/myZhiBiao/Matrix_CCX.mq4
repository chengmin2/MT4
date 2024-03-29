//+------------------------------------------------------------------+
//|                                                   Matrix_CCX.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots   3
//--- plot UP
#property indicator_label1  "UP"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot DW
#property indicator_label2  "DW"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot CL
#property indicator_label3  "CL"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrYellow
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- indicator buffers
double         UPBuffer[];
double         DWBuffer[];
double         CLBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
extern  int weiXin=1;//微型账户1标准手缩小倍数
bool isJS = false;//是否解锁
bool isSuoCang = false;//是否锁仓
extern bool isRGJS=false;//是否人工解锁
extern int cc_profit_points=100;//出仓利润点
extern double volumes=0.01;//起始手数
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,UPBuffer);
   SetIndexBuffer(1,DWBuffer);
   SetIndexBuffer(2,CLBuffer);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  int limt;
   if(prev_calculated==0){
    limt = rates_total;
   }else{
    limt=rates_total-prev_calculated+1;
   }
    double totalVolume =MathAbs(jy.totalVolumeBySymbol(Symbol(),OP_BUY)-jy.totalVolumeBySymbol(Symbol(),OP_SELL));
   if(totalVolume==volumes || totalVolume==2*volumes
   )
     {
      totalVolume=3*volumes;
     }
   double thisProfit= totalVolume*cc_profit_points/weiXin-jieSuoProfit();
   double buyLots = jy.totalVolumeBySymbol(Symbol(),OP_BUY);
   double sellLots = jy.totalVolumeBySymbol(Symbol(),OP_SELL);
   double nowProfit = jy.profitBySymbolTotal(Symbol());
   printf("当前利润："+nowProfit);
   printf("点位利润："+thisProfit);
   printf("买单手数："+buyLots);
   printf("卖单手数："+sellLots);
   double price;
  if(buyLots>sellLots){      
        price = Ask+(thisProfit-nowProfit)/(buyLots-sellLots)*Point();
  }else if(buyLots<sellLots){
         price = Bid-(thisProfit-nowProfit)/(sellLots-buyLots)*Point();
  }
   for(int i=0;i<limt;i++){
       CLBuffer[i]=price;
        
   }
   return(rates_total);
  }
//+------------------------------------------------------------------+
double jieSuoProfit()
  {
   double thisProfit=0;
   if(isJS || isRGJS)
     {
      int total = OrdersHistoryTotal();
      for(int i=total-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS,MODE_HISTORY))
           {
            if(OrderSymbol()==Symbol())
              {
               thisProfit = OrderProfit()+OrderCommission()+OrderSwap();
               break;
              }
           }
        }
      printf("解锁利润："+thisProfit);
     }
   return thisProfit;
  }