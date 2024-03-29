//+------------------------------------------------------------------+
//|                                          OBJ_RECTANGLE_LABEL.mq4 |
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
st();
 anNiu("duo",50,80,"多单",100,20);
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
#property description "Script creates \"Rectangle Label\" graphical object." 
//--- display window of the input parameters during the script's launch 
#property script_show_inputs 
//--- input parameters of the script 
input string           InpName="RectLabel";         // Label name 
input color            InpBackColor=clrSkyBlue;     // Background color 
input ENUM_BORDER_TYPE InpBorder=BORDER_FLAT;       // Border type 
input ENUM_BASE_CORNER InpCorner=CORNER_LEFT_UPPER; // Chart corner for anchoring 
input color            InpColor=clrDarkBlue;        // Flat border color (Flat) 
input ENUM_LINE_STYLE  InpStyle=STYLE_SOLID;        // Flat border style (Flat) 
input int              InpLineWidth=3;              // Flat border width (Flat) 
input bool             InpBack=false;               // Background object 
input bool             InpSelection=true;           // Highlight to move 
input bool             InpHidden=true;              // Hidden in the object list 
input long             InpZOrder=0;                 // Priority for mouse click 
//+------------------------------------------------------------------+ 
//| Create rectangle label                                           | 
//+------------------------------------------------------------------+ 
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID 
                     const string           name="RectLabel",         // label name 
                     const int              sub_window=0,             // subwindow index 
                     const int              x=0,                      // X coordinate 
                     const int              y=0,                      // Y coordinate 
                     const int              width=300,                 // width 
                     const int              height=360,                // height 
                     const color            back_clr=C'236,233,216',  // background color 
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // border type 
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring 
                     const color            clr=clrRed,               // flat border color (Flat) 
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style 
                     const int              line_width=1,             // flat border width 
                     const bool             back=false,               // in the background 
                     const bool             selection=false,          // highlight to move 
                     const bool             hidden=true,              // hidden in the object list 
                     const long             z_order=0)                // priority for mouse click 
  { 
//--- reset the error value 
   ResetLastError(); 
//--- create a rectangle label 
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0)) 
     { 
      Print(__FUNCTION__, 
            ": failed to create a rectangle label! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- set label coordinates 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y); 
//--- set label size 
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width); 
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height); 
//--- set background color 
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr); 
//--- set border type 
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border); 
//--- set the chart's corner, relative to which point coordinates are defined 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner); 
//--- set flat border color (in Flat mode) 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
//--- set flat border line style 
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style); 
//--- set flat border width 
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width); 
//--- display in the foreground (false) or background (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
//--- enable (true) or disable (false) the mode of moving the label by mouse 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
//--- hide (true) or display (false) graphical object name in the object list 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
//--- set the priority for receiving the event of a mouse click in the chart 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
//--- successful execution 
   return(true); 
  } 

void OnTick() 
  { 

  }
void st(){

   int x=0; 
   int y=0; 
//--- set label size 
   int width=300; 
   int height=360; 
//--- create a rectangle label 
   if(!RectLabelCreate(0,InpName,0,x,y,width,height,InpBackColor,InpBorder,InpCorner, 
      InpColor,InpStyle,InpLineWidth,InpBack,InpSelection,InpHidden,InpZOrder)) 
     { 
      return; 
     } 


}

void anNiu(string name,int x,int y,string text,int width,int high)                // priority for mouse click
  {
   const long              chart_ID=0;               // chart's ID
   const int               sub_window=0;             // subwindow index
// text
   const string            font="Arial";             // font
   const int               font_size=10;             // font size
   const color             clr=clrDarkTurquoise;             // text color
   const color             back_clr=C'236,233,216';  // background color
   const color             border_clr=clrNONE;       // border color
   const bool              state=false;              // pressed/released
   const bool              back=false;               // in the background
   const bool              selection=false;          // highlight to move
   const bool              hidden=true;             // hidden in the object list
   const long              z_order=0;
   Alert( WindowsTotal());
   ObjectCreate(ChartID(),name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set button size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,high);
//--- set the chart's corner, relative to which point coordinates are defined
//ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution

  }