
#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1  clrLimeGreen
#property indicator_color2  clrPaleVioletRed
#property indicator_color3  clrLimeGreen
#property indicator_color4  clrPaleVioletRed
#property indicator_color5  clrLimeGreen
#property indicator_color6  clrPaleVioletRed
#property indicator_color7  clrLimeGreen
#property indicator_color8  clrPaleVioletRed
#property indicator_minimum 0
#property indicator_maximum 5

extern string TimeFrame1                  = "Current time frame";
extern string TimeFrame2                  = "next1";
extern string TimeFrame3                  = "next2";
extern string TimeFrame4                  = "next3";
//extern string note1="----------------------------------------------"; do not put this line here; strange; will crash
extern int    CciPeriod                   = 8;
extern int    CciPrice                    = PRICE_TYPICAL;
extern double T3Period                    = 1;
extern double T3Hot                       = 0.618;
extern bool   T3Original                  = true;
extern string UniqueID                    = "4TF T3 CCI";
extern string note2="----------------------------------------------";
extern int    LinesWidth                  = 0;
extern color  LabelsColor                 = clrDarkGray;
extern int    LabelsHorizontalShift       = 5;
extern double LabelsVerticalShift         = 1.5;
extern string note3="----------------------------------------------";
extern bool   alertsOn                    = false;
extern int    alertsHowManyTimeFrameAligned                 = 3;
extern bool   alertsMessage               = true;
extern bool   alertsSound                 = false;
extern bool   alertsEmail                 = false;
input bool    alertsNotify                = false;
extern string note4="----------------------------------------------";
extern bool   DisplayArrows               = true;
extern int    DrawArrowsWhenTimeFrameAligned      = 4;
extern int    ArrowGap                    = 0; 
extern int    ArrowWidth                  = 1;
extern int    UpArrowWingDingsFontCode    = 233;
extern int    DownArrowWingDingsFontCode  = 234;
extern color  UpArrowColor                = clrLime;
extern color  DownArrowColor              = clrRed;
extern string note5="----------------------------------------------";
extern int    TimeFrame1WingdingsFontCode = 110;
extern int    TimeFrame2WingdingsFontCode = 110;
extern int    TimeFrame3WingdingsFontCode = 108;
extern int    TimeFrame4WingdingsFontCode = 108;
extern int    MaximumCandlesToDisplay     = 500;
extern string note6="----------------------------------------------";

double trends[], ForexStation1Up[], ForexStation1Down[], ForexStation2Up[], ForexStation2Down[], ForexStation3Up[], ForexStation3Down[], ForexStation4Up[], ForexStation4Down[];

int    timeFrames[4];
bool   returnBars, calculateValue;
string indicatorFileName;

//------------------------------------------------------------------
int OnInit()
{
      IndicatorBuffers(9);
   
      SetIndexBuffer(0,ForexStation1Up);
      SetIndexBuffer(1,ForexStation1Down);
      SetIndexBuffer(2,ForexStation2Up);
      SetIndexBuffer(3,ForexStation2Down);
      SetIndexBuffer(4,ForexStation3Up);
      SetIndexBuffer(5,ForexStation3Down);
      SetIndexBuffer(6,ForexStation4Up);
      SetIndexBuffer(7,ForexStation4Down);
      SetIndexBuffer(8,trends);
   
      indicatorFileName = WindowExpertName();
      returnBars        = (TimeFrame1=="returnBars");     if (returnBars)     return(0);
      calculateValue    = (TimeFrame1=="calculateValue"); if (calculateValue) return(0);
      
      SetIndexStyle(0,DRAW_ARROW,EMPTY,LinesWidth); SetIndexArrow(0,TimeFrame1WingdingsFontCode); 
      SetIndexStyle(1,DRAW_ARROW,EMPTY,LinesWidth); SetIndexArrow(1,TimeFrame1WingdingsFontCode); 
      SetIndexStyle(2,DRAW_ARROW,EMPTY,LinesWidth); SetIndexArrow(2,TimeFrame2WingdingsFontCode); 
      SetIndexStyle(3,DRAW_ARROW,EMPTY,LinesWidth); SetIndexArrow(3,TimeFrame2WingdingsFontCode); 
      SetIndexStyle(4,DRAW_ARROW,EMPTY,LinesWidth); SetIndexArrow(4,TimeFrame3WingdingsFontCode); 
      SetIndexStyle(5,DRAW_ARROW,EMPTY,LinesWidth); SetIndexArrow(5,TimeFrame3WingdingsFontCode); 
      SetIndexStyle(6,DRAW_ARROW,EMPTY,LinesWidth); SetIndexArrow(6,TimeFrame4WingdingsFontCode); 
      SetIndexStyle(7,DRAW_ARROW,EMPTY,LinesWidth); SetIndexArrow(7,TimeFrame4WingdingsFontCode); 
      
      timeFrames[0] = stringToTimeFrame(TimeFrame1);
      timeFrames[1] = stringToTimeFrame(TimeFrame2);
      timeFrames[2] = stringToTimeFrame(TimeFrame3);
      timeFrames[3] = stringToTimeFrame(TimeFrame4);
      alertsHowManyTimeFrameAligned = MathMin(MathMax(alertsHowManyTimeFrameAligned,2),4);
      IndicatorShortName(UniqueID);
   return(0);
}
//------------------------------------------------------------------
int deinit()
{
   for (int t=0; t<4; t++) ObjectDelete(UniqueID+t);
   for (int i = ObjectsTotal()-1; i >= 0; i--)   
   if (StringSubstr(ObjectName(i), 0, StringLen(UniqueID)) == UniqueID)
       ObjectDelete(ObjectName(i)); 
   return(0); 
}
//------------------------------------------------------------------
double trend[][2];
#define _up 0
#define _dn 1
int start()
{
   int i,r,counted_bars=IndicatorCounted();
      if(counted_bars < 0) return(-1);
      if(counted_bars>0) counted_bars--;
         int limit = MathMin(Bars-counted_bars,Bars-1);
         if (limit>MaximumCandlesToDisplay) limit = MaximumCandlesToDisplay;
         if (returnBars)     { ForexStation1Up[0] = limit+1;  return(0); }
         if (calculateValue) { calculateByTC(limit); return(0); }

         if (timeFrames[0] != Period()) limit = MathMax(limit,MathMin(MaximumCandlesToDisplay,iCustom(NULL,timeFrames[0],indicatorFileName,"returnBars",0,0)*timeFrames[0]/Period()));
         if (timeFrames[1] != Period()) limit = MathMax(limit,MathMin(MaximumCandlesToDisplay,iCustom(NULL,timeFrames[1],indicatorFileName,"returnBars",0,0)*timeFrames[1]/Period()));
         if (timeFrames[2] != Period()) limit = MathMax(limit,MathMin(MaximumCandlesToDisplay,iCustom(NULL,timeFrames[2],indicatorFileName,"returnBars",0,0)*timeFrames[2]/Period()));
         if (timeFrames[3] != Period()) limit = MathMax(limit,MathMin(MaximumCandlesToDisplay,iCustom(NULL,timeFrames[3],indicatorFileName,"returnBars",0,0)*timeFrames[3]/Period()));
         if (ArrayRange(trend,0)!=Bars) ArrayResize(trend,Bars);
        
         static bool initialized = false;
         if (!initialized)
         {
            initialized = true;
            int window = WindowFind(UniqueID);
            for (int t=0; t<4; t++)
            {
               string label = timeFrameToString(timeFrames[t]);
               ObjectCreate (UniqueID+t,OBJ_TEXT,window,0,0);
               ObjectSet    (UniqueID+t,OBJPROP_COLOR,LabelsColor);
               ObjectSet    (UniqueID+t,OBJPROP_PRICE1,t+LabelsVerticalShift);
               ObjectSetText(UniqueID+t,label,8,"Arial");
            }               
         }
         for (t=0; t<4; t++) ObjectSet(UniqueID+t,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
    
   for(i = limit, r=Bars-i-1; i >= 0; i--,r++)
   {
      trend[r][_up] = 0;
      trend[r][_dn] = 0;
      for (int k=0; k<4; k++)
      {
         int    y     = iBarShift(NULL,timeFrames[k],Time[i]);
// ----- Start of replacing this area -----
         double spanA = iCustom(NULL,timeFrames[k],indicatorFileName,"calculateValue","","","",CciPeriod,CciPrice,T3Period,T3Hot,T3Original,0,y);
         bool   isUp  = (spanA>0);
// ----- End of replacing this area -----
                     
         switch (k)
         {
            case 0 : if (isUp) { ForexStation1Up[i] = k+1; ForexStation1Down[i] = EMPTY_VALUE;}  else { ForexStation1Down[i] = k+1; ForexStation1Up[i] = EMPTY_VALUE; } break;
            case 1 : if (isUp) { ForexStation2Up[i] = k+1; ForexStation2Down[i] = EMPTY_VALUE;}  else { ForexStation2Down[i] = k+1; ForexStation2Up[i] = EMPTY_VALUE; } break;
            case 2 : if (isUp) { ForexStation3Up[i] = k+1; ForexStation3Down[i] = EMPTY_VALUE;}  else { ForexStation3Down[i] = k+1; ForexStation3Up[i] = EMPTY_VALUE; } break;
            case 3 : if (isUp) { ForexStation4Up[i] = k+1; ForexStation4Down[i] = EMPTY_VALUE;}  else { ForexStation4Down[i] = k+1; ForexStation4Up[i] = EMPTY_VALUE; } break;
         }
         if (isUp)
                  trend[r][_up] += 1;
            else  trend[r][_dn] += 1;
      }
     
     trends[i]=trends[i+1];
     
     if (DrawArrowsWhenTimeFrameAligned == 4)
        {
         if(trends[i]!=1 && ForexStation1Up[i]!=EMPTY_VALUE && ForexStation2Up[i]!=EMPTY_VALUE && ForexStation3Up[i]!=EMPTY_VALUE && ForexStation4Up[i]!=EMPTY_VALUE) 
         {
           trends[i] = 1;
           if (DisplayArrows) arrows_wind(i,"Up",ArrowGap ,UpArrowWingDingsFontCode,UpArrowColor,ArrowWidth,false);   
           }else{
           ObjectDelete(UniqueID+"Up"+TimeToStr(Time[i]));
         } 
         if(trends[i]!=-1 && ForexStation1Down[i]!=EMPTY_VALUE && ForexStation2Down[i]!=EMPTY_VALUE && ForexStation3Down[i]!=EMPTY_VALUE && ForexStation4Down[i]!=EMPTY_VALUE) 
         {
           trends[i] =-1;
           if (DisplayArrows) arrows_wind(i,"Dn",ArrowGap ,DownArrowWingDingsFontCode,DownArrowColor,ArrowWidth,true);
           }else{
           ObjectDelete(UniqueID + "Dn" + TimeToStr(Time[i],TIME_DATE|TIME_SECONDS));
           }  
           if(trends[i]== 1 && (ForexStation1Up[i]  ==EMPTY_VALUE || ForexStation2Up[i]  ==EMPTY_VALUE || ForexStation3Up[i]  ==EMPTY_VALUE || ForexStation4Up[i]  ==EMPTY_VALUE)) trends[i] = 0;
           if(trends[i]==-1 && (ForexStation1Down[i]==EMPTY_VALUE || ForexStation2Down[i]==EMPTY_VALUE || ForexStation3Down[i]==EMPTY_VALUE || ForexStation4Down[i]==EMPTY_VALUE)) trends[i] = 0;
         }  //      if (alertsHowManyTimeFrameAligned == 4)
     else 
     if (DrawArrowsWhenTimeFrameAligned == 3)
        {
         if(trends[i]!=1 && ForexStation1Up[i]!=EMPTY_VALUE && ForexStation2Up[i]!=EMPTY_VALUE && ForexStation3Up[i]!=EMPTY_VALUE) 
         {
           trends[i] = 1;
           if (DisplayArrows) arrows_wind(i,"Up",ArrowGap ,UpArrowWingDingsFontCode,UpArrowColor,ArrowWidth,false);   
           }else{
           ObjectDelete(UniqueID+"Up"+TimeToStr(Time[i]));
         } 
         if(trends[i]!=-1 && ForexStation1Down[i]!=EMPTY_VALUE && ForexStation2Down[i]!=EMPTY_VALUE && ForexStation3Down[i]!=EMPTY_VALUE) 
         {
           trends[i] =-1;
           if (DisplayArrows) arrows_wind(i,"Dn",ArrowGap ,DownArrowWingDingsFontCode,DownArrowColor,ArrowWidth,true);
           }else{
           ObjectDelete(UniqueID + "Dn" + TimeToStr(Time[i],TIME_DATE|TIME_SECONDS));
           }  
           if(trends[i]== 1 && (ForexStation1Up[i]  ==EMPTY_VALUE || ForexStation2Up[i]  ==EMPTY_VALUE || ForexStation3Up[i]  ==EMPTY_VALUE )) trends[i] = 0;
           if(trends[i]==-1 && (ForexStation1Down[i]==EMPTY_VALUE || ForexStation2Down[i]==EMPTY_VALUE || ForexStation3Down[i]==EMPTY_VALUE )) trends[i] = 0;
         } //      else if (alertsHowManyTimeFrameAligned == 3)
     else 
     if (DrawArrowsWhenTimeFrameAligned == 2)
        {
         if(trends[i]!=1 && ForexStation1Up[i]!=EMPTY_VALUE && ForexStation2Up[i]!=EMPTY_VALUE) 
         {
           trends[i] = 1;
           if (DisplayArrows) arrows_wind(i,"Up",ArrowGap ,UpArrowWingDingsFontCode,UpArrowColor,ArrowWidth,false);   
           }else{
           ObjectDelete(UniqueID+"Up"+TimeToStr(Time[i]));
         } 
         if(trends[i]!=-1 && ForexStation1Down[i]!=EMPTY_VALUE && ForexStation2Down[i]!=EMPTY_VALUE) 
         {
           trends[i] =-1;
           if (DisplayArrows) arrows_wind(i,"Dn",ArrowGap ,DownArrowWingDingsFontCode,DownArrowColor,ArrowWidth,true);
           }else{
           ObjectDelete(UniqueID + "Dn" + TimeToStr(Time[i],TIME_DATE|TIME_SECONDS));
           }  
           if(trends[i]== 1 && (ForexStation1Up[i]  ==EMPTY_VALUE || ForexStation2Up[i]  ==EMPTY_VALUE )) trends[i] = 0;
           if(trends[i]==-1 && (ForexStation1Down[i]==EMPTY_VALUE || ForexStation2Down[i]==EMPTY_VALUE )) trends[i] = 0;
         } //      else if (alertsHowManyTimeFrameAligned == 2)
     
   }   
   manageAlerts();
   return(0);
}
//+------------------------------------------------------------------+
void arrows_wind(int k, string N,int ots,int Code,color clr, int ArrowSize,bool up)                 
{           
   string objName = UniqueID+N+TimeToStr(Time[k]);
   double gap = ots*Point;
   
   ObjectCreate(objName, OBJ_ARROW,0,Time[k],0);
   ObjectSet   (objName, OBJPROP_COLOR, clr);  
   ObjectSet   (objName, OBJPROP_ARROWCODE,Code);
   ObjectSet   (objName, OBJPROP_WIDTH,ArrowSize);  
  if (up)
    {
      ObjectSet(objName, OBJPROP_ANCHOR,ANCHOR_BOTTOM);
      ObjectSet(objName,OBJPROP_PRICE1,High[k]+gap);
    } else {  
      ObjectSet(objName, OBJPROP_ANCHOR,ANCHOR_TOP);
      ObjectSet(objName,OBJPROP_PRICE1,Low[k]-gap);
    }
}
//-------------------------------------------------------------------
void calculateByTC(int limit)
{
   for (int i=limit; i>=0; i--) 
   {
         
      ForexStation2Up[i]    = iMA(NULL,0,1,0,MODE_SMA,CciPrice,i);
      double avg = 0; for(int k=0; k<CciPeriod; k++) avg +=         ForexStation2Up[i+k];      avg /= CciPeriod;
      double dev = 0; for(    k=0; k<CciPeriod; k++) dev += MathAbs(ForexStation2Up[i+k]-avg); dev /= CciPeriod;
          if (dev!=0)
                ForexStation4Up[i] = iT3((ForexStation2Up[i]-avg)/(0.015*dev),T3Period,T3Hot,T3Original,i);
          else  ForexStation4Up[i] = iT3(0,                        T3Period,T3Hot,T3Original,i); 
          
          ForexStation1Up[i] = ForexStation1Up[i+1];
          if (ForexStation4Up[i] > 0)   ForexStation1Up[i] =  1;
          if (ForexStation4Up[i] < 0)   ForexStation1Up[i] = -1;
   }
}
//+-------------------------------------------------------------------
void manageAlerts()
{
   if (alertsOn)
   {
      int whichBar = Bars-1;
      if (trend[whichBar][_up] >= alertsHowManyTimeFrameAligned || trend[whichBar][_dn] >= alertsHowManyTimeFrameAligned)
      {
         if (trend[whichBar][_up] >= alertsHowManyTimeFrameAligned) doAlert("up"  ,trend[whichBar][_up]);
         if (trend[whichBar][_dn] >= alertsHowManyTimeFrameAligned) doAlert("down",trend[whichBar][_dn]);
      }
   }
}
//-------------------------------------------------------------------
void doAlert(string doWhat, int howMany)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[0]) {
       previousAlert  = doWhat;
       previousTime   = Time[0];

       message =  Symbol()+" at "+TimeToStr(TimeLocal(),TIME_SECONDS)+" "+howMany+" time frames of T3 CCI are aligned "+doWhat;
          if (alertsMessage) Alert(message);
          if (alertsEmail)   SendMail(Symbol()+" 4TF T3 CCI",message);
          if (alertsNotify)  SendNotification(message);
          if (alertsSound)   PlaySound("alert2.wav");
   }
}
//-------------------------------------------------------------------
string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

int toInt(double value) { return(value); }
int stringToTimeFrame(string tfs)
{
   tfs = stringUpperCase(tfs);
   int max = ArraySize(iTfTable)-1, add=0;
   int nxt = (StringFind(tfs,"NEXT1")>-1); if (nxt>0) { tfs = ""+Period(); add=1; }
       nxt = (StringFind(tfs,"NEXT2")>-1); if (nxt>0) { tfs = ""+Period(); add=2; }
       nxt = (StringFind(tfs,"NEXT3")>-1); if (nxt>0) { tfs = ""+Period(); add=3; }
       nxt = (StringFind(tfs,"NEXT4")>-1); if (nxt>0) { tfs = ""+Period(); add=4; }
       nxt = (StringFind(tfs,"NEXT5")>-1); if (nxt>0) { tfs = ""+Period(); add=5; }
       nxt = (StringFind(tfs,"NEXT6")>-1); if (nxt>0) { tfs = ""+Period(); add=6; }
       nxt = (StringFind(tfs,"NEXT7")>-1); if (nxt>0) { tfs = ""+Period(); add=7; }
         
      for (int i=max; i>=0; i--)
         if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) return(MathMax(iTfTable[toInt(MathMin(max,i+add))],Period()));
                                                      return(Period());
}
//-------------------------------------------------------------------
string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}
//-------------------------------------------------------------------
string stringUpperCase(string str)
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--)
   {
      int tchar = StringGetChar(s, length);
         if((tchar > 96 && tchar < 123) || (tchar > 223 && tchar < 256))
                     s = StringSetChar(s, length, tchar - 32);
         else if(tchar > -33 && tchar < 0)
                     s = StringSetChar(s, length, tchar + 224);
   }
   return(s);
}
//-------------------------------------------------------------------
double workT3[][6];
double workT3Coeffs[][6];
#define _period 0
#define _c1     1
#define _c2     2
#define _c3     3
#define _c4     4
#define _alpha  5

//
//
//
//
//

double iT3(double price, double period, double hot, bool original, int i, int forInstance=0)
{
   if (ArrayRange(workT3,0) !=Bars)                  ArrayResize(workT3,Bars);
   if (ArrayRange(workT3Coeffs,0) < (forInstance+1)) ArrayResize(workT3Coeffs,forInstance+1);

   if (workT3Coeffs[forInstance][_period] != period)
   {
     workT3Coeffs[forInstance][_period] = period;
        double a = hot;
            workT3Coeffs[forInstance][_c1] = -a*a*a;
            workT3Coeffs[forInstance][_c2] = 3*a*a+3*a*a*a;
            workT3Coeffs[forInstance][_c3] = -6*a*a-3*a-3*a*a*a;
            workT3Coeffs[forInstance][_c4] = 1+3*a+a*a*a+3*a*a;
            if (original)
                 workT3Coeffs[forInstance][_alpha] = 2.0/(1.0 + period);
            else workT3Coeffs[forInstance][_alpha] = 2.0/(2.0 + (period-1.0)/2.0);
   }
   
   //
   //
   //
   //
   //
   
   int buffer = forInstance*6;
   int r = Bars-i-1;
   if (r == 0)
      {
         workT3[r][0+buffer] = price;
         workT3[r][1+buffer] = price;
         workT3[r][2+buffer] = price;
         workT3[r][3+buffer] = price;
         workT3[r][4+buffer] = price;
         workT3[r][5+buffer] = price;
      }
   else
      {
         workT3[r][0+buffer] = workT3[r-1][0+buffer]+workT3Coeffs[forInstance][_alpha]*(price              -workT3[r-1][0+buffer]);
         workT3[r][1+buffer] = workT3[r-1][1+buffer]+workT3Coeffs[forInstance][_alpha]*(workT3[r][0+buffer]-workT3[r-1][1+buffer]);
         workT3[r][2+buffer] = workT3[r-1][2+buffer]+workT3Coeffs[forInstance][_alpha]*(workT3[r][1+buffer]-workT3[r-1][2+buffer]);
         workT3[r][3+buffer] = workT3[r-1][3+buffer]+workT3Coeffs[forInstance][_alpha]*(workT3[r][2+buffer]-workT3[r-1][3+buffer]);
         workT3[r][4+buffer] = workT3[r-1][4+buffer]+workT3Coeffs[forInstance][_alpha]*(workT3[r][3+buffer]-workT3[r-1][4+buffer]);
         workT3[r][5+buffer] = workT3[r-1][5+buffer]+workT3Coeffs[forInstance][_alpha]*(workT3[r][4+buffer]-workT3[r-1][5+buffer]);
      }

   //
   //
   //
   //
   //
   
   return(workT3Coeffs[forInstance][_c1]*workT3[r][5+buffer] + 
          workT3Coeffs[forInstance][_c2]*workT3[r][4+buffer] + 
          workT3Coeffs[forInstance][_c3]*workT3[r][3+buffer] + 
          workT3Coeffs[forInstance][_c4]*workT3[r][2+buffer]);
}
//-------------------------------------------------------------------
