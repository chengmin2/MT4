//+------------------------------------------------------------------+
//|                                                        sbnr2.mq4 |
//|                                                       ChinaCheng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ChinaCheng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4
//--- plot G_ibuf_136
#property indicator_label1  "G_ibuf_136"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot G_ibuf_140
#property indicator_label2  "G_ibuf_140"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot G_ibuf_144
#property indicator_label3  "G_ibuf_144"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot B_S
#property indicator_label4  "B_S"
#property indicator_type4   DRAW_ARROW
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- indicator buffers

#define FLINESIZE 14 // размер записи файла равен 14 байт

//TimeFrame, RsiPeriod, MaType, MaPeriod
extern string TimeFrame = "H4";
extern int RsiPeriod = 4;
extern int MaType = 1;
extern int MaPeriod = 2;
extern bool Interpolate = TRUE;
extern string arrowsIdentifier = "tdi ssa arrows";
extern color arrowsUpColor = LimeGreen;
extern color arrowsDnColor = Red;
extern bool alertsOn = TRUE;
extern bool alertsSound = TRUE;
extern bool alertsOnCurrent = FALSE;
extern bool alertsMessage = FALSE;
extern bool alertsEmail = FALSE;
double G_ibuf_136[];
double G_ibuf_140[];
double G_ibuf_144[];
double B_S[];
string gs_148;
bool gi_156 = FALSE;
bool gi_160 = FALSE;
int g_timeframe_164;
string gs_nothing_168 = "nothing";
datetime g_time_176;

datetime lastArrTime = EMPTY;


extern int ArrowSize2Use = 3;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,G_ibuf_136);
   SetIndexBuffer(1,G_ibuf_140);
   SetIndexBuffer(2,G_ibuf_144);
   SetIndexBuffer(3,B_S);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,159);
   PlotIndexSetInteger(1,PLOT_ARROW,159);
   PlotIndexSetInteger(2,PLOT_ARROW,159);
   PlotIndexSetInteger(3,PLOT_ARROW,159);
   if (TimeFrame == "calculate") {
      gi_156 = TRUE;
      return (0);
   }
   if (TimeFrame == "returnBars") {
      gi_160 = TRUE;
      return (0);
   }
   g_timeframe_164 = f0_0(TimeFrame);
   gs_148 = WindowExpertName();
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
int shift_0;
   int datetime_4;
   double Ld_8;
   int Li_16;
   int Li_32 = IndicatorCounted();
   if (Li_32 < 0) return (-1);
   if (Li_32 > 0) Li_32--;
   int Li_36 = MathMin(Bars - Li_32, Bars - 1);
   if (gi_160) {
      G_ibuf_136[0] = Li_36 + 1;
      return (0);
   }
   if (g_timeframe_164 > Period()) Li_36 = MathMax(Li_36, MathMin(Bars - 1, iCustom(NULL, g_timeframe_164, gs_148, "returnBars", 0, 0) * g_timeframe_164 / Period()));
   int typeLastSignal = EMPTY;
   for (int Li_40 = Li_36; Li_40 >= 0; Li_40--) {
      shift_0 = iBarShift(NULL, g_timeframe_164, Time[Li_40]);
      G_ibuf_136[Li_40] = iCustom(NULL, g_timeframe_164, gs_148, "calculate", RsiPeriod, MaType, MaPeriod, 0, shift_0);
      G_ibuf_140[Li_40] = iCustom(NULL, g_timeframe_164, gs_148, "calculate", RsiPeriod, MaType, MaPeriod, 1, shift_0);
      G_ibuf_144[Li_40] = G_ibuf_144[Li_40 + 1];
      if (G_ibuf_136[Li_40] > G_ibuf_140[Li_40]) G_ibuf_144[Li_40] = 1; 
      if (G_ibuf_136[Li_40] < G_ibuf_140[Li_40]) G_ibuf_144[Li_40] = -1; 
    //  f0_4(Time[Li_40]);
      if (G_ibuf_144[Li_40] != G_ibuf_144[Li_40 + 1]) {
         if (G_ibuf_144[Li_40] == 1.0) { DrawArrowForBar(Li_40, arrowsUpColor, 233, 0); typeLastSignal = OP_BUY;  }
         if (G_ibuf_144[Li_40] == -1.0){ DrawArrowForBar(Li_40, arrowsDnColor, 234, 1); typeLastSignal = OP_SELL; }
      }
      if (g_timeframe_164 <= Period() || shift_0 == iBarShift(NULL, g_timeframe_164, Time[Li_40 - 1])) continue;
      if (Interpolate) {
         datetime_4 = iTime(NULL, g_timeframe_164, shift_0);
         for (int Li_44 = 1; Li_40 + Li_44 < Bars && Time[Li_40 + Li_44] >= datetime_4; Li_44++) {
         Ld_8 = 1.0 / Li_44;
           for (int Li_48 = 1; Li_48 < Li_44; Li_48++) {
            G_ibuf_136[Li_40 + Li_48] = Li_48 * Ld_8 * (G_ibuf_136[Li_40 + Li_44]) + (1.0 - Li_48 * Ld_8) * G_ibuf_136[Li_40];
            G_ibuf_140[Li_40 + Li_48] = Li_48 * Ld_8 * (G_ibuf_140[Li_40 + Li_44]) + (1.0 - Li_48 * Ld_8) * G_ibuf_140[Li_40];
         }
         }
        
      }
   }
   

   
   datetime curTime = iTime(NULL, g_timeframe_164, 0);
   string nameCurObj = arrowsIdentifier + ":" + iTime(NULL, g_timeframe_164, 0);      
   
   if( ObjectFind(nameCurObj) != EMPTY && curTime > lastArrTime )
   {
      if( typeLastSignal != EMPTY )
      {
         if( lastArrTime != EMPTY  )
         
         {
            datetime minuts = iTime(NULL, PERIOD_M1, 0);
            //SaveSignal(curTime, typeLastSignal, minuts);
            
            if( Period() < g_timeframe_164 )   
               if( typeLastSignal == OP_BUY )
                  {DrawArrowForTime(minuts, arrowsUpColor, 233, typeLastSignal);  
                  // B_S[Li_32]=OP_BUY;
                  }
               else
                 { DrawArrowForTime(minuts, arrowsDnColor, 234, typeLastSignal); 
                     //B_S[Li_32]=OP_SELL;
                  }
         }                     
      }
      Print("Try save signal");
      lastArrTime = curTime;
   }
   
   if( lastArrTime == EMPTY ) lastArrTime = curTime - 1;
   
   
   return(rates_total);
  }
//+------------------------------------------------------------------+
void DrawArrowForBar(int ai_0, color a_color_4, int ai_8, bool ai_12) {
   printf("信号"+ai_12+TimeToString(Time[ai_0]));
   B_S[ai_0]=ai_12;
   string name_16 = arrowsIdentifier + ":" + Time[ai_0];
   double Ld_24 = 3.0 * iATR(NULL, 0, 20, ai_0) / 4.0;
   ObjectCreate(name_16, OBJ_ARROW, 0, Time[ai_0], 0);
   ObjectSet(name_16, OBJPROP_ARROWCODE, ai_8);
   ObjectSet(name_16, OBJPROP_COLOR, a_color_4);
   ObjectSet(name_16, OBJPROP_WIDTH, ArrowSize2Use);
   if (ai_12) {
      ObjectSet(name_16, OBJPROP_PRICE1, High[ai_0] + Ld_24);
      return;
   }
   ObjectSet(name_16, OBJPROP_PRICE1, Low[ai_0] - Ld_24);
}

void DrawArrowForTime(datetime time, color a_color_4, int arrowCode, bool isDnArr) {
   int bar = iBarShift(NULL, 0, time);
   string name_16 = arrowsIdentifier + ":" + time;
   double Ld_24 = 3.0 * iATR(NULL, 0, 20, bar) / 4.0;
   ObjectCreate(name_16, OBJ_ARROW, 0, time, 0);
   ObjectSet(name_16, OBJPROP_ARROWCODE, arrowCode);
   ObjectSet(name_16, OBJPROP_COLOR, a_color_4);
   ObjectSet(name_16, OBJPROP_WIDTH, ArrowSize2Use);
   if (isDnArr) {
      ObjectSet(name_16, OBJPROP_PRICE1, High[bar] + Ld_24);
      return;
   }
   ObjectSet(name_16, OBJPROP_PRICE1, Low[bar] - Ld_24);
}

void f0_2() {
   string name_0;
   string ls_8 = arrowsIdentifier + ":";
   int str_len_16 = StringLen(ls_8);
   for (int Li_20 = ObjectsTotal() - 1; Li_20 >= 0; Li_20--) {
      name_0 = ObjectName(Li_20);
      if (StringSubstr(name_0, 0, str_len_16) == ls_8) ObjectDelete(name_0);
   }
}

void f0_4(int ai_0) {
   string name_4 = arrowsIdentifier + ":" + ai_0;
   ObjectDelete(name_4);
}

void f0_5(string as_0) {
   string str_concat_8;
   if (gs_nothing_168 != as_0 || g_time_176 != Time[0]) {
      gs_nothing_168 = as_0;
      g_time_176 = Time[0];
      str_concat_8 = StringConcatenate(Symbol(), " at ", TimeToStr(TimeLocal(), TIME_SECONDS), " Signal Arrow ", as_0);
      if (alertsMessage) Alert(str_concat_8);
      if (alertsEmail) SendMail(StringConcatenate(Symbol(), "Signal Arrow"), str_concat_8);
      if (alertsSound) PlaySound("alert2.wav");
   }
}

int f0_0(string as_0) {
   int Li_8;
   for (int Li_12 = StringLen(as_0) - 1; Li_12 >= 0; Li_12--) {
      Li_8 = StringGetChar(as_0, Li_12);
      if ((Li_8 > '`' && Li_8 < '{') || (Li_8 > 'Я' && Li_8 < 256)) as_0 = StringSetChar(as_0, Li_12, Li_8 - 32);
      else
         if (Li_8 > -33 && Li_8 < 0) as_0 = StringSetChar(as_0, Li_12, Li_8 + 224);
   }
   int timeframe_16 = 0;
   if (as_0 == "M1" || as_0 == "1") timeframe_16 = 1;
   if (as_0 == "M5" || as_0 == "5") timeframe_16 = 5;
   if (as_0 == "M15" || as_0 == "15") timeframe_16 = 15;
   if (as_0 == "M30" || as_0 == "30") timeframe_16 = 30;
   if (as_0 == "H1" || as_0 == "60") timeframe_16 = 60;
   if (as_0 == "H4" || as_0 == "240") timeframe_16 = 240;
   if (as_0 == "D1" || as_0 == "1440") timeframe_16 = 1440;
   if (as_0 == "W1" || as_0 == "10080") timeframe_16 = 10080;
   if (as_0 == "MN" || as_0 == "43200") timeframe_16 = 43200;
   if (timeframe_16 == 0 || timeframe_16 < Period()) timeframe_16 = Period();
   return (timeframe_16);
}

string f0_3() {
   switch (g_timeframe_164) {
   case PERIOD_M1:
      return ("M(1)");
   case PERIOD_M5:
      return ("M(5)");
   case PERIOD_M15:
      return ("M(15)");
   case PERIOD_M30:
      return ("M(30)");
   case PERIOD_H1:
      return ("H(1)");
   case PERIOD_H4:
      return ("H(4)");
   case PERIOD_D1:
      return ("D(1)");
   case PERIOD_W1:
      return ("W(1)");
   case PERIOD_MN1:
      return ("MN(1)");
   }
   return ("Unknown timeframe");
}


//+----------------------------------------------------------------+
//
string ErrorStr = "";

string WorckFileName = "indti_snbr2_save2_";

int hFile = EMPTY;