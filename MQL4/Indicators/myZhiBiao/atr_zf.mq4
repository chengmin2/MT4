//+------------------------------------------------------------------+
//|                                                       atr_zf.mq4 |
//|                                                       ChinaCheng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ChinaCheng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot atr
#property indicator_label1  "atr"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrYellow
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot zf
#property indicator_label2  "zf"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrDarkGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- indicator buffers
double         atrBuffer[];
double         zfBuffer[];
extern int k = 10;//k线数
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,atrBuffer);
   SetIndexBuffer(1,zfBuffer);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,159);
   PlotIndexSetInteger(1,PLOT_ARROW,159);
   
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
   double h;
   double l;
   for(int i=0;i<limt;i++){
       h=iHigh(Symbol(),0,iHighest(Symbol(),0,MODE_HIGH,k,i));
       l=iLow(Symbol(),0,iLowest(Symbol(),0,MODE_LOW,k,i));     
       zfBuffer[i]=h-l;
       atrBuffer[i]=iCustom(Symbol(),0,"ATR",k,0,i);
   }
   return(rates_total);
   

  }

//+------------------------------------------------------------------+
