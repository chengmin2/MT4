

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 DeepSkyBlue
#property indicator_color2 Gold
#property indicator_color3 Blue
#property indicator_color4 Yellow

extern int Sensetive = 4;

extern string pus1 = "/////////////////////////////////////////////////////////";
extern string p_set = "Picks style";
extern int main_Arrow_code1 = 108; 
extern int main_Arrow_code2 = 108; 
extern int main_Arrow_width = 4;

extern int Arrow_code1 = 238; 
extern int Arrow_code2 = 236; 
extern int Arrow_width = 2;
extern int Dot_from_candle = 3;

extern string pus2 = "/////////////////////////////////////////////////////////";
extern string l_set = "Lines style";
extern bool use_lines = false;
extern int Line_code = 1;
extern int Line_width = 1;
extern color Line_color1 = Aqua;
extern color Line_color2 = Aqua;

extern string pus3 = "/////////////////////////////////////////////////////////";
extern string al_set = "Alerts settings";
extern bool use_alert = false;
extern string up_arrow = "up arrow";
extern string down_arrow = "down arrow";

int bars_to_count;
double buf_92[];
double buf_93[];
double buf_94[];
double buf_95[];
int time = 0;
bool draw_up_down_dot = FALSE;

double high_11 = 0.0;
double high_13 = 0.0;
double low_12 = 0.0;
double low_14 = 0.0;


datetime ut1=0;
double   up1=0;
datetime dt1=0;
double   dp1=0;

double point;
int prevtime;
int last_bar_up,last_bar_down;
int count_once;
///////////////////////////////////////////////
void init() {
count_once=0;

bars_to_count=Bars-2;

point=Point;
if(Digits==3||Digits==5) point*=10;

   SetIndexStyle(0, DRAW_ARROW,0,Arrow_width);
   SetIndexArrow(0, Arrow_code1);
   SetIndexBuffer(0, buf_92);
   SetIndexEmptyValue(0, 0.0);
   
   SetIndexStyle(1, DRAW_ARROW,0,Arrow_width);
   SetIndexArrow(1, Arrow_code2);
   SetIndexBuffer(1, buf_93);
   SetIndexEmptyValue(1, 0.0);

   SetIndexStyle(2, DRAW_ARROW,0,main_Arrow_width);
   SetIndexArrow(2, main_Arrow_code1);
   SetIndexBuffer(2, buf_94);
   SetIndexEmptyValue(2, 0.0);
   
   SetIndexStyle(3, DRAW_ARROW,0,main_Arrow_width);
   SetIndexArrow(3, main_Arrow_code2);
   SetIndexBuffer(3, buf_95);
   SetIndexEmptyValue(3, 0.0);

  if(use_lines)
   {
   ObjectCreate("UpLine",OBJ_TREND,0,0,0,0,0);
   ObjectCreate("DownLine",OBJ_TREND,0,0,0,0,0);

   ObjectSet("UpLine",OBJPROP_COLOR,Line_color1);
   ObjectSet("UpLine",OBJPROP_WIDTH,Line_width);
   ObjectSet("UpLine",OBJPROP_STYLE,Line_code);

   ObjectSet("DownLine",OBJPROP_COLOR,Line_color2);
   ObjectSet("DownLine",OBJPROP_WIDTH,Line_width);
   ObjectSet("DownLine",OBJPROP_STYLE,Line_code);
   }
   
  
}

////////////////////////////////////////////////
void deinit() 
{
   ObjectDelete("UpLine");
   ObjectDelete("DownLine");
   
   for (int i = bars_to_count; i > 0; i--) 
   {
   if(buf_92[i]!=0) buf_92[i]=0;
   if(buf_93[i]!=0) buf_93[i]=0;
   if(buf_94[i]!=0) buf_94[i]=0;
   if(buf_95[i]!=0) buf_95[i]=0;
   }
   
}

/////////////////////////////////////////////////
void start() {
   if (Time[0] == prevtime) return;
   prevtime = Time[0];
   
    for (int i = bars_to_count; i > 0; i--) 
    {
    if(buf_92[i]!=0) buf_92[i]=0;
   if(buf_93[i]!=0) buf_93[i]=0;
   if(buf_94[i]!=0) buf_94[i]=0;
   if(buf_95[i]!=0) buf_95[i]=0;
    }
   
   for (i = bars_to_count - 1; i > 0; i--) {
      if (draw_up_down_dot == FALSE) {
         if (High[i + 1] < High[i + 2] && time == 0) {
            time = Time[i + 2];
            high_11 = High[i + 2];
            low_12 = Low[i + 1];
         }
         if (High[i] > high_11) {
            time = 0;
            high_11 = 0;
            low_12 = 0;
         }
         if (Close[i] < low_12-Sensetive*point && time != 0) {
            time = iBarShift(NULL, 0, time);
            draw_up_down_dot = TRUE;
            buf_92[time] = High[time] + Dot_from_candle*point;

           if(use_lines)
           {
            if(ut1>0)
               ObjectMove("UpLine",0,ut1,up1);
            ObjectMove("UpLine",1,Time[time],High[time] + Dot_from_candle*point);

            ut1=Time[time];
            up1=High[time] + Dot_from_candle*point;
            }
            
            time = 0;
         }
      }
      if (draw_up_down_dot == TRUE) {
         if (Low[i + 1] > Low[i + 2] && time == 0) {
            time = Time[i + 2];
            low_14 = Low[i + 2];
            high_13 = High[i + 1];
         }
         if (Low[i] < low_14) {
            time = 0;
            low_14 = 0;
            high_13 = 0;
         }
         if (Close[i] > high_13+Sensetive*point && time != 0) {
            time = iBarShift(NULL, 0, time);
            draw_up_down_dot = FALSE;
            buf_93[time] = Low[time] - Dot_from_candle*point;
            
           if(use_lines)
           {
            if(dt1>0)
               ObjectMove("DownLine",0,dt1,dp1);
            ObjectMove("DownLine",1,Time[time],Low[time] - Dot_from_candle*point);

            dt1=Time[time];
            dp1=Low[time] - Dot_from_candle*point;
            }
            
            time = 0;
         }
      }
   }
  
   


//

   
   //////////////////////////////////////////////main up dot
   int find_one_up;
   bool main_dot_up;
   int bar_found;
   
   for (int y = bars_to_count; y > 0; y--) 
   {
   //
   if(buf_92[y]!=0 && find_one_up==0)
   {
   bar_found=y;
   find_one_up++;
   }
   //
   if((buf_92[y]!=0) && find_one_up==1)
   {
   if(!main_dot_up)
   {
   if(buf_92[y]>buf_92[bar_found])
   buf_94[y]=High[y]+ Dot_from_candle*point;
   }
   if(main_dot_up)
   {
   if(buf_92[y]>buf_94[bar_found])
   {
   buf_94[y]=High[y]+ Dot_from_candle*point;
   buf_94[bar_found]=0;
   buf_92[bar_found]=High[bar_found]+ Dot_from_candle*point;
   }
   }
   find_one_up=0;
   }
   
    //
   if((buf_92[y]!=0 || buf_94[y]!=0) && find_one_up==0)
   {
   if(buf_92[y]!=0) main_dot_up=false;
   if(buf_94[y]!=0) main_dot_up=true;
   bar_found=y;
   find_one_up++;
   }
   
   }//end for2
   
   for (int x = bars_to_count; x > 0; x--) 
   {
   if(buf_94[x]!=0 && buf_92[x]!=0)
   buf_92[x]=0;
   }//end for3

//////////////////////////////////////////////main down dot
   int find_one_down;
   bool main_dot_down;
   int bar_found_d;
   
   for (int y2 = bars_to_count; y2 > 0; y2--) 
   {
   //
   if(buf_93[y2]!=0 && find_one_down==0)
   {
   bar_found_d=y2;
   find_one_down++;
   }
   //
   if((buf_93[y2]!=0) && find_one_down==1)
   {
   if(!main_dot_down)
   {
   if(buf_93[y2]<buf_93[bar_found_d])
   buf_95[y2]=Low[y2]- Dot_from_candle*point;
   }
   if(main_dot_down)
   {
   if(buf_93[y2]<buf_95[bar_found_d])
   {
   buf_95[y2]=Low[y2]- Dot_from_candle*point;
   buf_95[bar_found_d]=0;
   buf_93[bar_found_d]=Low[bar_found_d]- Dot_from_candle*point;
   }
   }
   find_one_down=0;
   }
   
    //
   if((buf_93[y2]!=0 || buf_95[y2]!=0) && find_one_down==0)
   {
   if(buf_93[y2]!=0) main_dot_down=false;
   if(buf_95[y2]!=0) main_dot_down=true;
   bar_found_d=y2;
   find_one_down++;
   }
   
   }//end for4
   
   for (int x2 = bars_to_count; x2 > 0; x2--) 
   {
   if(buf_95[x2]!=0 && buf_93[x2]!=0)
   buf_93[x2]=0;
   }//end for5
   
   if(count_once==0)
   once();
   
if(use_alert)
{
bool up_cheked=false;
bool down_cheked=false;
for (int c =1 ; c <=bars_to_count; c++) 
 {
 if((buf_92[c]!=0 || buf_94[c]!=0) && last_bar_up<Time[c] && !up_cheked)
 {
 Alert("PBF_SSM "+Symbol()+" "+Period()+" "+up_arrow);
 last_bar_up=Time[c];
 up_cheked=true;
 }
 if((buf_93[c]!=0 || buf_95[c]!=0) && last_bar_down<Time[c] && !down_cheked)
 {
 Alert("PBF_SSM "+Symbol()+" "+Period()+" "+down_arrow);
 last_bar_down=Time[c];
 down_cheked=true;
 }
 if(up_cheked && down_cheked)
 break;
 }//end for6
 

 
}//if alert


}//end start

////////////////////////////////////////////////////////////////////////
void once()
{
for (int c =1 ; c <=bars_to_count; c++) 
 {
 if(buf_92[c]!=0 || buf_94[c]!=0)
 {
 last_bar_up=Time[c];
 break;
 }
 }//end for-1
 
 for (int c2 =1 ; c2 <=bars_to_count; c2++) 
 {
if(buf_93[c2]!=0 || buf_95[c2]!=0)
 {
 last_bar_down=Time[c2];
 break;
 }
}//end for0

count_once++;
}