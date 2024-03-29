//+------------------------------------------------------------------+
//|                                                   minutes_zf.mq4 |
//|                                                       ChinaCheng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ChinaCheng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot mark
#property indicator_label1  "mark"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- indicator buffers
double         markBuffer[];
extern int point=300;//振幅
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,markBuffer);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,159);
   SetIndexArrow(0,91);
   SetIndexStyle(0,DRAW_ARROW,EMPTY,2,clrMaroon);
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
       h=iHigh(Symbol(),0,i);
       l=iLow(Symbol(),0,i);     
       if(h-l>=point*Point()) markBuffer[i]=Close[i];
       }
  
   return(rates_total);
  }
//+------------------------------------------------------------------+
