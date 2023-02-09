//+------------------------------------------------------------------+
//|                                                   L_H_xinhao.mq4 |
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
//--- plot arrow
#property indicator_label1  "arrowUp"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

#property indicator_label2  "arrowDown"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- indicator buffers
double         arrowUpBuffer[];
double         arrowDownBuffer[];
input int kshu=10;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,arrowUpBuffer);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   //PlotIndexSetInteger(0,PLOT_ARROW,159);
   SetIndexArrow(0,233);
   SetIndexStyle(0,DRAW_ARROW,EMPTY,2,clrDarkBlue);
   
      SetIndexBuffer(1,arrowDownBuffer);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   //PlotIndexSetInteger(1,PLOT_ARROW,159);
    SetIndexArrow(1,234);
    SetIndexStyle(1,DRAW_ARROW,EMPTY,2,clrYellow);
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
   double high_p;
   double low_p;
   for(int i=0;i<limt;i++){
       high_p=iHigh(Symbol(),0,iHighest(Symbol(),0,MODE_HIGH,kshu,i));
       low_p=iLow(Symbol(),0,iLowest(Symbol(),0,MODE_LOW,kshu,i)); 
       if(High[i]==high_p){
         arrowUpBuffer[i]=High[i];
        
       }else   
       if(Low[i]==low_p){
         arrowDownBuffer[i]=Low[i];
      
       }    
   }
   return(rates_total);
  }
//+------------------------------------------------------------------+
