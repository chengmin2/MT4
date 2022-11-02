#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Lime
#property indicator_color2 SlateBlue
#property indicator_color3 Orange
#property indicator_color4 SlateBlue
#property indicator_color5 Orange

extern int    RSIPeriod        = 14;
extern int    BandPeriod       = 20;
extern double BandDeviation    = 1.3185;
extern bool   alertsOn         = true;
bool   alertsOnCurrent  = false;
bool   alertsMessage    = true;
bool   alertsSound      = true;
bool   alertsNotify     = false;
bool   alertsEmail      = false;
string soundFile        = "alert2.wav";
bool   arrowsVisible    = true;
string arrowsIdentifier = "rsiBolArrows1";
double arrowsUpperGap   = 1.0;
double arrowsLowerGap   = 1.0;
color  arrowsUpColor    = LimeGreen;
color  arrowsDnColor    = Red;
int    arrowsUpCode     = 233;
int    arrowsDnCode     = 234;

double RSIBuf[],UpZone[],DnZone[],trend[],UpArrow[],DnArrow[];

int init()
{
   IndicatorBuffers(6);
   SetIndexBuffer(0,RSIBuf);
   SetIndexStyle(0,DRAW_NONE);
   SetIndexBuffer(1,UpZone);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexBuffer(2,DnZone); 
   SetIndexStyle(2,DRAW_NONE); 
    
   SetIndexBuffer(3,UpArrow);
   SetIndexStyle(3,DRAW_ARROW); 
   SetIndexLabel(3,"UpArr");
   SetIndexArrow(3,233);
   SetIndexBuffer(4,DnArrow);
   SetIndexStyle(4,DRAW_ARROW); 
   SetIndexLabel(4,"DnArr");
   SetIndexArrow(4,234);
   
   IndicatorDigits(Digits);
   SetIndexBuffer(5,trend);
   return(0);
}
int deinit()
{
   string lookFor       = arrowsIdentifier+":";
   int    lookForLength = StringLen(lookFor);
   for (int i=ObjectsTotal()-1; i>=0; i--)
   {
      string objectName = ObjectName(i);
         if (StringSubstr(objectName,0,lookForLength) == lookFor) ObjectDelete(objectName);
   }
   return(0); 
}

int start()
{
   int counted_bars=IndicatorCounted();
      if(counted_bars < 0) return(-1);
      if(counted_bars>0) counted_bars--;
         int limit = MathMin(Bars-counted_bars,Bars-1);
   
   for(int i=limit; i>=0; i--) RSIBuf[i] = iRSI(NULL,0,RSIPeriod,PRICE_WEIGHTED,i);
   for(    i=limit; i>=0; i--) 
   {
      double ma  = iMAOnArray(RSIBuf,0,BandPeriod,0,MODE_SMA,i);
      double dev = iStdDevOnArray(RSIBuf,0,BandPeriod,0,MODE_SMA,i);
         UpZone[i] = ma + BandDeviation * dev;
         DnZone[i] = ma - BandDeviation * dev;  

         trend[i] = 0;
           if (RSIBuf[i]>UpZone[i]) trend[i] = 1;
           if (RSIBuf[i]<DnZone[i]) trend[i] =-1;  
           if (arrowsVisible)
           {
               ObjectDelete(arrowsIdentifier+":"+Time[i]);
               if (trend[i] != trend[i+1])
               {
               //   if (trend[i+1] ==  1 && trend[i] != 1) drawArrow(i,arrowsDnColor,arrowsDnCode,true);
               //   if (trend[i+1] == -1 && trend[i] !=-1) drawArrow(i,arrowsUpColor,arrowsUpCode,false);
                  
                  if (trend[i] == -1) DnArrow[i]=High[i]+ 15*Point;//drawArrow(i,arrowsDnColor,arrowsDnCode,true);
                  if (trend[i] == 1)  UpArrow[i]=Low[i] - 15*Point;//drawArrow(i,arrowsUpColor,arrowsUpCode,false);
               }
            }
   }

   if (alertsOn)
   {
      if (alertsOnCurrent)
           int whichBar = 0;
      else     whichBar = 1;
      if (trend[whichBar] != trend[whichBar+1])
      {
        // if (trend[whichBar+1] ==  1 && trend[whichBar] != 1) doAlert(whichBar,"leaving up zone");
        // if (trend[whichBar+1] == -1 && trend[whichBar] !=-1) doAlert(whichBar,"leaving down zone");
         
         if ( trend[whichBar] == 1) doAlert(whichBar,"entering up zone");
         if ( trend[whichBar] == -1) doAlert(whichBar,"entering down zone");
      }         
   }
   return(0);
}

void doAlert(int forBar, string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[forBar]) {
       previousAlert  = doWhat;
       previousTime   = Time[forBar];
        message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," RSI + Bollinger bands ",doWhat);
          if (alertsMessage) Alert(message);
          if (alertsNotify)  SendNotification(message);
          if (alertsEmail)   SendMail(StringConcatenate(Symbol()," RSI + Bollinger bands "),message);
          if (alertsSound)   PlaySound(soundFile);
   }
}

void drawArrow(int i,color theColor,int theCode,bool up)
{
   string name = arrowsIdentifier+":"+Time[i];
   double gap  = iATR(NULL,0,20,i);   

      ObjectCreate(name,OBJ_ARROW,0,Time[i],0);
         ObjectSet(name,OBJPROP_ARROWCODE,theCode);
         ObjectSet(name,OBJPROP_COLOR,theColor);
         if (up)
               ObjectSet(name,OBJPROP_PRICE1,High[i] + arrowsUpperGap * gap);
         else  ObjectSet(name,OBJPROP_PRICE1,Low[i]  - arrowsLowerGap * gap);
}