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
#property indicator_buffers 5
#property indicator_plots   5
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

#property indicator_label3  "beishu"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrDarkGreen
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

#property indicator_label4  "newHigh"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrDarkGreen
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1

#property indicator_label5  "newLow"
#property indicator_type5   DRAW_ARROW
#property indicator_color5  clrDarkGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1


//--- indicator buffers
double         atrBuffer[];
double         zfBuffer[];
double         beishuBuffer[];
double         newHighBuffer[];
double         newLowBuffer[];
extern int k = 10;//k线数
extern int beiShu = 3;//倍数
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,atrBuffer);
   SetIndexBuffer(1,zfBuffer);

//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
  // PlotIndexSetInteger(0,PLOT_ARROW,159);
  // PlotIndexSetInteger(1,PLOT_ARROW,159);

   //--- indicator buffers mapping
   SetIndexBuffer(2,beishuBuffer);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
  // PlotIndexSetInteger(2,PLOT_ARROW,159);
   SetIndexArrow(2,91);
   SetIndexStyle(2,DRAW_ARROW,EMPTY,2,clrMaroon);
   SetIndexBuffer(3,newHighBuffer);
   SetIndexArrow(3,233);
   SetIndexStyle(3,DRAW_ARROW,EMPTY,2,clrGreen);
   SetIndexBuffer(4,newLowBuffer);
   SetIndexArrow(4,234);
   SetIndexStyle(4,DRAW_ARROW,EMPTY,2,clrRed);
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
       if(3*atrBuffer[i]>zfBuffer[i]){
         beishuBuffer[i]=Close[i];
       }
       if(High[i]>=h){
        newHighBuffer[i]=High[i];
       }else if(Low[i]<=l){
        newLowBuffer[i] = Low[i];
       }
   }
   
   return(rates_total);
   

  }

//+------------------------------------------------------------------+
