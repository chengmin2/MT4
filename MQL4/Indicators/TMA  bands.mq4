

#property indicator_chart_window
#property indicator_buffers 9
#property indicator_color1  clrYellow
#property indicator_color2  clrCrimson
#property indicator_color3  clrCrimson
#property indicator_color4  clrCrimson
#property indicator_color5  clrWhite
#property indicator_color6  clrDarkGreen
#property indicator_color7  clrDarkGreen
#property indicator_color8  clrYellow
#property indicator_color9  clrRed
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  3
#property indicator_width4  2
#property indicator_width5  2
#property indicator_width6  2
#property indicator_width7  2
#property indicator_width8  1
#property indicator_width9  1
#property strict

//
//
//
//
//

enum enPrices
{
   pr_close,      // Close
   pr_open,       // Open
   pr_high,       // High
   pr_low,        // Low
   pr_median,     // Median
   pr_typical,    // Typical
   pr_weighted,   // Weighted
   pr_average,    // Average (high+low+open+close)/4
   pr_medianb,    // Average median body (open+close)/2
   pr_tbiased,    // Trend biased price
   pr_tbiased2,   // Trend biased (extreme) price
   pr_haclose,    // Heiken ashi close
   pr_haopen ,    // Heiken ashi open
   pr_hahigh,     // Heiken ashi high
   pr_halow,      // Heiken ashi low
   pr_hamedian,   // Heiken ashi median
   pr_hatypical,  // Heiken ashi typical
   pr_haweighted, // Heiken ashi weighted
   pr_haaverage,  // Heiken ashi average
   pr_hamedianb,  // Heiken ashi median body
   pr_hatbiased,  // Heiken ashi trend biased price
   pr_hatbiased2, // Heiken ashi trend biased (extreme) price
   pr_habclose,   // Heiken ashi (better formula) close
   pr_habopen ,   // Heiken ashi (better formula) open
   pr_habhigh,    // Heiken ashi (better formula) high
   pr_hablow,     // Heiken ashi (better formula) low
   pr_habmedian,  // Heiken ashi (better formula) median
   pr_habtypical, // Heiken ashi (better formula) typical
   pr_habweighted,// Heiken ashi (better formula) weighted
   pr_habaverage, // Heiken ashi (better formula) average
   pr_habmedianb, // Heiken ashi (better formula) median body
   pr_habtbiased, // Heiken ashi (better formula) trend biased price
   pr_habtbiased2 // Heiken ashi (better formula) trend biased (extreme) price
};
enum enCalcType
{
   st_atr, // Use atr
   st_std, // Use standard deviation 
   st_ste, // Use standard error
   st_sam, // Custom standard deviation - with sample correction
   st_nos  // Custom standard deviation - without sample correction
   
};

extern int                HalfLength   = 12;           // TMA centered period
extern enPrices           Price        = pr_close;     // Price to use
extern int                period       = 50;           // TMA centered bands deviation period
extern double             Multiplier   = 1.3;          // TMA centered bands deviation
extern enCalcType         Type         = st_atr;       // Deviation calculation type
extern int                DevLookBack  = 0;            // Lookback bars only for Atr & Std deviation

double buffer1[],buffer2[],buffer3[],prices[],smBufDa[],smBufDb[],trend[],high[],low[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//

int init()
{
   HalfLength=fmax(HalfLength,1);
   IndicatorBuffers(9);
   SetIndexBuffer(0,buffer1); SetIndexDrawBegin(0,HalfLength);
   SetIndexBuffer(1,smBufDa); SetIndexDrawBegin(1,HalfLength);
   SetIndexBuffer(2,smBufDb); SetIndexDrawBegin(2,HalfLength);
   SetIndexBuffer(3,buffer2); SetIndexDrawBegin(3,HalfLength);
   SetIndexBuffer(4,buffer3); SetIndexDrawBegin(4,HalfLength);
   SetIndexBuffer(5,prices);
   SetIndexBuffer(6,trend);
     //SetIndexBuffer(7,high); SetIndexDrawBegin(7,HalfLength);
       //SetIndexBuffer(8,low); SetIndexDrawBegin(8,HalfLength);
        SetIndexBuffer(7,high);
   SetIndexStyle(7,DRAW_ARROW); 
   SetIndexLabel(7,"LowArr");
   SetIndexArrow(7,234);
   SetIndexBuffer(8,low);
   SetIndexStyle(8,DRAW_ARROW); 
   
   SetIndexLabel(8,"UpArr");
   SetIndexArrow(8,233);
return(0);
}
int deinit() { return(0); }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int start()
{
   int counted_bars=IndicatorCounted();
   int i,j,k,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit=fmin(Bars-1,fmax(Bars-counted_bars,HalfLength));

   //
   //
   //
   //
   //
   
   if (trend[limit] == -1)  CleanPoint(limit,smBufDa,smBufDb);
   for (i=limit; i>=0; i--) prices[i] = getPrice(Price,Open,Close,High,Low,i,Bars);
   for (i=limit; i>=0; i--)
   {   
      if (i<Bars-1)
      {
        double sum  = (HalfLength+1)*prices[i];
        double sumw = (HalfLength+1);
        for(j=1, k=HalfLength; j<=HalfLength && (i+j)<Bars; j++, k--)
        {
           sum  += prices[i+j]*k;
           sumw += k;

           if (j<=i)
           {
              sum  += prices[i-j]*k;
              sumw += k;
            }
            buffer1[i] = sum/sumw;
         }
      }

      //
      //
      //
      //
      //
      
         double val=0;
         switch (Type)
         {
            case st_atr : val = iATR(NULL,0,period,i+DevLookBack);                           break;
            case st_std : val = iStdDev(NULL,0,period,0,MODE_SMA,PRICE_CLOSE,i+DevLookBack); break;
            case st_ste : val = iStdError(prices[i],period,i);                               break;
            default :     val = iDeviation(prices[i],period,Type==st_sam,i);
         }                       
         buffer2[i] = buffer1[i]+val*Multiplier;
         if(High[i]>buffer2[i]) high[i]=buffer2[i];
         buffer3[i] = buffer1[i]-val*Multiplier;
         if(Low[i]<buffer3[i]) low[i]=buffer3[i];
         smBufDa[i] = EMPTY_VALUE;
         smBufDb[i] = EMPTY_VALUE;
         trend[i] = (i<Bars-1) ? (buffer1[i]>buffer1[i+1]) ? 1 : (buffer1[i]<buffer1[i+1]) ? -1 : trend[i+1] : 0;
         if (trend[i] == -1) PlotPoint(i,smBufDa,smBufDb,buffer1);
   }
return(0);
}

//------------------------------------------------------------------
//                                                                  
//------------------------------------------------------------------
// 
//
//
//
//

#define _devInstances 1
double workDev[][_devInstances];
double iDeviation(double value, int length, bool isSample, int i, int instanceNo=0)
{
   if (ArrayRange(workDev,0)!=Bars) ArrayResize(workDev,Bars); i=Bars-i-1; workDev[i][instanceNo] = value;
                 
   //
   //
   //
   //
   //
   
      double oldMean   = value;
      double newMean   = value;
      double squares   = 0; int k;
      for (k=1; k<length && (i-k)>=0; k++)
      {
         newMean  = (workDev[i-k][instanceNo]-oldMean)/(k+1)+oldMean;
         squares += (workDev[i-k][instanceNo]-oldMean)*(workDev[i-k][instanceNo]-newMean);
         oldMean  = newMean;
      }
      return(MathSqrt(squares/fmax(k-isSample,1)));
}

//
//
//
//
//

double workErr[][_devInstances];
double iStdError(double value, int length,int i, int instanceNo=0)
{
   if (ArrayRange(workErr,0)!=Bars) ArrayResize(workErr,Bars); i = Bars-i-1; workErr[i][instanceNo] = value;
                        
      //
      //
      //
      //
      //
                              
      double avgY     = workErr[i][instanceNo]; int j; for (j=1; j<length && (i-j)>=0; j++) avgY += workErr[i-j][instanceNo]; avgY /= j;
      double avgX     = length * (length-1) * 0.5 / length;
      double sumDxSqr = 0.00;
      double sumDySqr = 0.00;
      double sumDxDy  = 0.00;
   
      for (int k=0; k<length && (i-k)>=0; k++)
      {
         double dx = k-avgX;
         double dy = workErr[i-k][instanceNo]-avgY;
            sumDxSqr += (dx*dx);
            sumDySqr += (dy*dy);
            sumDxDy  += (dx*dy);
      }
      double err2 = (sumDySqr-(sumDxDy*sumDxDy)/sumDxSqr)/(length-2); 
      
   //
   //
   //
   //
   //
         
   if (err2 > 0)
         return(MathSqrt(err2));
   else  return(0.00);       
}

//
//
//
//
//

#define _prHABF(_prtype) (_prtype>=pr_habclose && _prtype<=pr_habtbiased2)
#define _priceInstances     1
#define _priceInstancesSize 4
double workHa[][_priceInstances*_priceInstancesSize];
double getPrice(int tprice, const double& open[], const double& close[], const double& high[], const double& low[], int i, int bars, int instanceNo=0)
{
  if (tprice>=pr_haclose)
   {
      if (ArrayRange(workHa,0)!= Bars) ArrayResize(workHa,Bars); instanceNo*=_priceInstancesSize; int r = bars-i-1;
         
         //
         //
         //
         //
         //
         
         double haOpen  = (r>0) ? (workHa[r-1][instanceNo+2] + workHa[r-1][instanceNo+3])/2.0 : (open[i]+close[i])/2;;
         double haClose = (open[i]+high[i]+low[i]+close[i]) / 4.0;
         if (_prHABF(tprice))
               if (high[i]!=low[i])
                     haClose = (open[i]+close[i])/2.0+(((close[i]-open[i])/(high[i]-low[i]))*fabs((close[i]-open[i])/2.0));
               else  haClose = (open[i]+close[i])/2.0; 
         double haHigh  = fmax(high[i], fmax(haOpen,haClose));
         double haLow   = fmin(low[i] , fmin(haOpen,haClose));

         //
         //
         //
         //
         //
         
         if(haOpen<haClose) { workHa[r][instanceNo+0] = haLow;  workHa[r][instanceNo+1] = haHigh; } 
         else               { workHa[r][instanceNo+0] = haHigh; workHa[r][instanceNo+1] = haLow;  } 
                              workHa[r][instanceNo+2] = haOpen;
                              workHa[r][instanceNo+3] = haClose;
         //
         //
         //
         //
         //
         
         switch (tprice)
         {
            case pr_haclose:
            case pr_habclose:    return(haClose);
            case pr_haopen:   
            case pr_habopen:     return(haOpen);
            case pr_hahigh: 
            case pr_habhigh:     return(haHigh);
            case pr_halow:    
            case pr_hablow:      return(haLow);
            case pr_hamedian:
            case pr_habmedian:   return((haHigh+haLow)/2.0);
            case pr_hamedianb:
            case pr_habmedianb:  return((haOpen+haClose)/2.0);
            case pr_hatypical:
            case pr_habtypical:  return((haHigh+haLow+haClose)/3.0);
            case pr_haweighted:
            case pr_habweighted: return((haHigh+haLow+haClose+haClose)/4.0);
            case pr_haaverage:  
            case pr_habaverage:  return((haHigh+haLow+haClose+haOpen)/4.0);
            case pr_hatbiased:
            case pr_habtbiased:
               if (haClose>haOpen)
                     return((haHigh+haClose)/2.0);
               else  return((haLow+haClose)/2.0);        
            case pr_hatbiased2:
            case pr_habtbiased2:
               if (haClose>haOpen)  return(haHigh);
               if (haClose<haOpen)  return(haLow);
                                    return(haClose);        
         }
   }
   
   //
   //
   //
   //
   //
   
   switch (tprice)
   {
      case pr_close:     return(close[i]);
      case pr_open:      return(open[i]);
      case pr_high:      return(high[i]);
      case pr_low:       return(low[i]);
      case pr_median:    return((high[i]+low[i])/2.0);
      case pr_medianb:   return((open[i]+close[i])/2.0);
      case pr_typical:   return((high[i]+low[i]+close[i])/3.0);
      case pr_weighted:  return((high[i]+low[i]+close[i]+close[i])/4.0);
      case pr_average:   return((high[i]+low[i]+close[i]+open[i])/4.0);
      case pr_tbiased:   
               if (close[i]>open[i])
                     return((high[i]+close[i])/2.0);
               else  return((low[i]+close[i])/2.0);        
      case pr_tbiased2:   
               if (close[i]>open[i]) return(high[i]);
               if (close[i]<open[i]) return(low[i]);
                                     return(close[i]);        
   }
   return(0);
}

//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------
//
//
//
//
//

void CleanPoint(int i,double& first[],double& second[])
{
   if (i>=Bars-3) return;
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (i>=Bars-2) return;
   if (first[i+1] == EMPTY_VALUE)
      if (first[i+2] == EMPTY_VALUE) 
            { first[i]  = from[i]; first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
      else  { second[i] = from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else     { first[i]  = from[i];                          second[i] = EMPTY_VALUE; }
}


