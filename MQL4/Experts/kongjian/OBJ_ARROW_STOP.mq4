//+------------------------------------------------------------------+
//|                                               OBJ_ARROW_STOP.mq4 |
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

//+------------------------------------------------------------------+
#property strict 
//--- description 
#property description "Script draws \"Stop\" sign." 
#property description "Anchor point coordinate is set in" 
#property description "percentage of the chart window size." 
//--- display window of the input parameters during the script's launch 
#property script_show_inputs 
//--- input parameters of the script 
input string            InpName="ArrowStop";     // Sign name 
input int               InpDate=10;              // Anchor point date in % 
input int               InpPrice=50;             // Anchor point price in % 
input ENUM_ARROW_ANCHOR InpAnchor=ANCHOR_BOTTOM; // Anchor type 
input color             InpColor=clrRed;         // Sign color 
input ENUM_LINE_STYLE   InpStyle=STYLE_DOT;      // Border line style 
input int               InpWidth=5;              // Sign size 
input bool              InpBack=false;           // Background sign 
input bool              InpSelection=false;      // Highlight to move 
input bool              InpHidden=true;          // Hidden in the object list 
input long              InpZOrder=0;             // Priority for mouse click 
//+------------------------------------------------------------------+ 
//| Create Stop sign                                                 | 
//+------------------------------------------------------------------+ 
bool ArrowStopCreate(const long              chart_ID=0,           // chart's ID 
                     const string            name="ArrowStop",     // sign name 
                     const int               sub_window=0,         // subwindow index 
                     datetime                time=0,               // anchor point time 
                     double                  price=0,              // anchor point price 
                     const ENUM_ARROW_ANCHOR anchor=ANCHOR_BOTTOM, // anchor type 
                     const color             clr=clrRed,           // sign color 
                     const ENUM_LINE_STYLE   style=STYLE_SOLID,    // border line style 
                     const int               width=3,              // sign size 
                     const bool              back=false,           // in the background 
                     const bool              selection=true,       // highlight to move 
                     const bool              hidden=true,          // hidden in the object list 
                     const long              z_order=0)            // priority for mouse click 
  { 
//--- set anchor point coordinates if they are not set 
   ChangeArrowEmptyPoint(time,price); 
//--- reset the error value 
   ResetLastError(); 
//--- create the sign 
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW_STOP,sub_window,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": failed to create \"Stop\" sign! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- set anchor type 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
//--- set a sign color 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- set the border line style 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- set the sign size 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- enable (true) or disable (false) the mode of moving the sign by mouse 
//--- when creating a graphical object using ObjectCreate function, the object cannot be 
//--- highlighted and moved by default. Inside this method, selection parameter 
//--- is true by default making it possible to highlight and move the object 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Move the anchor point                                            | 
//+------------------------------------------------------------------+ 
bool ArrowStopMove(const long   chart_ID=0,       // chart's ID 
                   const string name="ArrowStop", // object name 
                   datetime     time=0,           // anchor point time coordinate 
                   double       price=0)          // anchor point price coordinate 
  { 
//--- if point position is not set, move it to the current bar having Bid price 
   if(!time) 
      time=TimeCurrent(); 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- reset the error value 
   ResetLastError(); 
//--- move the anchor point 
   if(!ObjectMove(chart_ID,name,0,time,price)) 
     { 
      Print(__FUNCTION__, 
            ": failed to move the anchor point! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Change Stop sign anchor type                                     | 
//+------------------------------------------------------------------+ 
bool ArrowStopAnchorChange(const long              chart_ID=0,        // chart's ID 
                           const string            name="ArrowStop",  // object name 
                           const ENUM_ARROW_ANCHOR anchor=ANCHOR_TOP) // anchor point position 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- change anchor type 
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor)) 
     { 
      Print(__FUNCTION__, 
            ": failed to change anchor type! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Delete Stop sign                                                 | 
//+------------------------------------------------------------------+ 
bool ArrowStopDelete(const long   chart_ID=0,       // chart's ID 
                     const string name="ArrowStop") // label name 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- delete the sign 
   if(!ObjectDelete(chart_ID,name)) 
     { 
      Print(__FUNCTION__, 
            ": failed to delete \"Stop\" sign! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Check anchor point values and set default values                 | 
//| for empty ones                                                   | 
//+------------------------------------------------------------------+ 
void ChangeArrowEmptyPoint(datetime &time,double &price) 
  { 
//--- if the point's time is not set, it will be on the current bar 
   if(!time) 
      time=TimeCurrent(); 
//--- if the point's price is not set, it will have Bid value 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
  } 
//+------------------------------------------------------------------+ 
//| Script program start function                                    | 
//+------------------------------------------------------------------+ 
void OnTick() 
  { 
//--- check correctness of the input parameters 
   if(InpDate<0 || InpDate>100 || InpPrice<0 || InpPrice>100) 
     { 
      Print("Error! Incorrect values of input parameters!"); 
      return; 
     } 
//--- number of visible bars in the chart window 
   int bars=(int)ChartGetInteger(0,CHART_VISIBLE_BARS); 
//--- price array size 
   int accuracy=1000; 
//--- arrays for storing the date and price values to be used 
//--- for setting and changing sign anchor point coordinates 
   datetime date[]; 
   double   price[]; 
//--- memory allocation 
   ArrayResize(date,bars); 
   ArrayResize(price,accuracy); 
//--- fill the array of dates 
   ResetLastError(); 
   if(CopyTime(Symbol(),Period(),0,bars,date)==-1) 
     { 
      Print("Failed to copy time values! Error code = ",GetLastError()); 
      return; 
     } 
//--- fill the array of prices 
//--- find the highest and lowest values of the chart 
   double max_price=ChartGetDouble(0,CHART_PRICE_MAX); 
   double min_price=ChartGetDouble(0,CHART_PRICE_MIN); 
//--- define a change step of a price and fill the array 
   double step=(max_price-min_price)/accuracy; 
   for(int i=0;i<accuracy;i++) 
      price[i]=min_price+i*step; 
//--- define points for drawing the sign 
   int d=InpDate*(bars-1)/100; 
   int p=InpPrice*(accuracy-1)/100; 
//--- create Stop sign on the chart 
   if(!ArrowStopCreate(0,InpName,0,date[d],price[p],InpAnchor,InpColor, 
      InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder)) 
     { 
      return; 
     } 
//--- redraw the chart and wait for 1 second 
   ChartRedraw(); 
   Sleep(1000); 
//--- now, move the anchor point and change its position relative to the sign 
//--- loop counter 
   int h_steps=bars*2/5; 
//--- move the anchor point 
   for(int i=0;i<h_steps;i++) 
     { 
      //--- use the following value 
      if(d<bars-1) 
         d+=1; 
      //--- move the point 
      if(!ArrowStopMove(0,InpName,date[d],price[p])) 
         return; 
      //--- check if the script's operation has been forcefully disabled 
      if(IsStopped()) 
         return; 
      //--- redraw the chart 
      ChartRedraw(); 
      // 0.025 seconds of delay 
      Sleep(25); 
     } 
//--- change anchor point location relative to the sign 
   ArrowStopAnchorChange(0,InpName,ANCHOR_TOP); 
//--- redraw the chart 
   ChartRedraw(); 
//--- loop counter 
   h_steps=bars*2/5; 
//--- move the anchor point 
   for(int i=0;i<h_steps;i++) 
     { 
      //--- use the following value 
      if(d<bars-1) 
         d+=1; 
      //--- move the point 
      if(!ArrowStopMove(0,InpName,date[d],price[p])) 
         return; 
      //--- check if the script's operation has been forcefully disabled 
      if(IsStopped()) 
         return; 
      //--- redraw the chart 
      ChartRedraw(); 
      // 0.025 seconds of delay 
      Sleep(25); 
     } 
//--- 1 second of delay 
   Sleep(1000); 
//--- delete the sign from the chart 
   ArrowStopDelete(0,InpName); 
   ChartRedraw(); 
//--- 1 second of delay 
   Sleep(1000); 
//--- 
  }