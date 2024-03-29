//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright    "Copyright © 2017 Expert Advisor RoboFibo v.11 By Yonif"
#property description  "www.hobiheboh.com"


#property description  "https://soehoe.id/expert-advisor-robofibo-v-10.t8337/page-6"

//=================================================================================================================================================
#import "stdlib.ex4"
string ErrorDescription(int a0); // DA69CBAFF4D38B87377667EEC549DE5A
#import

#import "stdlib.ex4"
string ErrorDescription(int a0); // DA69CBAFF4D38B87377667EEC549DE5A
#import
#define READURL_BUFFER_SIZE 100

#import "Wininet.dll"
int InternetOpenW(string,int,string,string,int);
int InternetConnectW(int,string,int,string,string,int,int,int);
int HttpOpenRequestW(int,string,string,int,string,int,string,int);
int InternetOpenUrlW(int,string,string,int,int,int);
int InternetReadFile(int,uchar & arr[],int,int& OneInt[]);
int InternetCloseHandle(int);
#import
//=================================================================================================================================================

enum ENUM_Trading_Mode
  {
   PendingLimitFollow,
   PendingLimitReverse,
   PendingStopFollow,
   PendingStopReverse,
  };


enum Corner
  {
   left  = 0, //Left side
   right = 1, //Right side
  };

enum ENUM_MinimumImpact
  {
   LowImpact,
   MediumImpact,
   HighImpact,
  };

input ENUM_Trading_Mode 交易模式 = PendingStopReverse;
extern bool 按资金比例开关 = False;
extern double 资金比例 = 0.1;
extern double 固定手数 = 0.01;
extern double 加仓倍数 = 1.1;
extern bool 每单止盈开关 = False;
extern bool 可视化止盈开关 = False;
extern int 止盈点数 = 500;
extern bool 每单止损开关 = False;
extern bool 可视化止损开关 = False;
extern int 止损点数 = 500;
extern bool 整体止盈开关 = True;
extern int 整体止盈点数 = 20;
extern bool 整组止盈开关 = False;
extern double 整组止盈点数 = 20.0;
extern double 整组止盈金额    = 0.0;
extern bool 整组止损开关 = False;
extern double 整组止损点数  = 0.0;
extern double 整组止损金额  = 0.0;
extern bool 移动止损开关 = False;
extern int 移动止损点数 = 20;
extern int 盈利多少点开始移动止盈 = 20;
extern bool 可视化移动止盈开关 = False;
extern int 可视化开始移动止盈点数 = 10;
extern int 可视化移动止盈点数 = 10;
extern int 可视化移动止盈步长 = 0;
extern int 单根K线波动点数 = 500;
extern int 最大多单开单量 = 30;
extern int 最大空单开单量 = 30;
extern int 挂单间距 = 20;
extern int 加仓间距 = 50;
extern double 加仓间距倍数 = 1.5;
input ENUM_TIMEFRAMES IClose = PERIOD_H1;
input ENUM_TIMEFRAMES IRSI = PERIOD_H1;
input ENUM_TIMEFRAMES ma1 = PERIOD_H1;
extern int RSI指标参数 = 14;
extern int 均线指标参数 = 60;
extern double 开单点差限制 = 50.0;
extern double 斐波那契高点 = 76.4;
extern double 斐波那契低点 = 23.6;
extern int 斐波那契取值开始K线 = 0;
extern int 斐波那契取值结束K线 = 20;
extern bool 重大新闻过滤 = true;
extern int 重大新闻更新间隔 = 4;   // Update every (in hours)
extern int 重大新闻前多少分钟禁止交易 = 60;
extern int 重大新闻后多少分钟开始交易   = 60;



int MinimumImpact; // 1= low impact, 2= medium impact, 3= high impact
input ENUM_MinimumImpact MinimumImpactNews = HighImpact;
extern bool ForceALL = true;
extern bool ForceAUD = true;
extern bool ForceCAD = true;
extern bool ForceCHF = true;
extern bool ForceCNY = true;
extern bool ForceEUR = true;
extern bool ForceGBP = true;
extern bool ForceJPY = true;
extern bool ForceNZD = true;
extern bool ForceUSD = true;
double MaxLots = 100.0;
double  totalProfits=0;
double  totalProfits2=0;
bool CloseSignal=false;
bool CloseSignal2=false;
int MagicNumber2 = 0;
extern Corner Side                 = left;
extern color  Textcolor            = clrBlack;
extern color  Backgroundcolor      = clrDarkOrchid;
extern color  Backgroundcolor2      = clrBlue;
extern color  Backgroundcolor3      = clrRed;
extern color  Backgroundcolor4      = clrYellow;
extern color  Backgroundcolor5      = clrGreen;
extern int Slippage = 10;
extern int MagicNumber = 1;
extern string TradeComment = "EA RoboFibo v.11";

enum type {buy=OP_BUY,sell=OP_SELL,all=3};
extern type this_type=all;//做单方向
int Size1 = 10;
int Size2 = 40;
int Size3 = 125;
int Size4 = 250;
int Size5 = 385;
int StartHour = 0;
int StartMinute = 0;
int EndHour = 23;
int EndMinute = 59;
int cnt_Hilo =0;
int Maxtrade=0;
int Maxtrade2=0;
int totalbuy;
int totalsell;
bool HighToLow  = true;
double Fibo_Level_0 = 0.000;
double Fibo_Level_6 = 1.000;
color VerticalLinesColor = Blue;
color FiboLinesColors = DarkGray;
double f_1[];
double f_2[];
double f_3[];
double f_4[];
double f_5[];
double f_6[];
double f_7[];
double f_8[];
double Fibo_Level_1 = 0.236;
double Fibo_Level_2 = 0.382;
double Fibo_Level_3 = 0.500;
double Fibo_Level_4 = 0.618;
double Fibo_Level_5 = 0.764;
double   TrallB = 0;
double   TrallS = 0;
//=================================================================================================================================================
double Gda_280[30];
int G_digits_192 = 0;
double G_point_196 = 0.0;
int Gi_204;
double Gd_208;
double Gd_216;
double Gd_224;
double Gd_232;
double Gd_240;
double Gd_241;
double Gd_242;
double Gd_243;
double Gd_256;
double Gd_sl;
double Gd_tp;
bool Gi_268;
double Gd_272;
int Gi_284 = 0;
double G_pips_184 = 0.0;
bool Gi_404 = TRUE;
double G_timeframe_396 = 240.0;
double Gd_420;
int Gi_180 = 0;
double Gd_460;
double lot1;
double stoplevel;
double sellstop;

bool  NewsTime;
string comment="";
int minutesSincePrevEvent,minutesUntilNextEvent;
string next,prev;
int prevnews=0;
int nextnews0=0;
//int prevnews=0;
int nextnews=0;
string comment1="",comment2="";
string news="";
string s1="",s2="";
int country1[150],country2[150];
string country[150],country0="",countryx="";
int title1[150],title2[150];
string title[150],title0="",titlex="";
int date1[150],date2[150];
string date[150],dateread[150],dateday[150],datemonth[150],dateyear[150],date0="",datex="";
datetime dategmt,datefinal[150];
int time1[150],time2[150],time3[150];
string time[150],timeread[150],timeap[150];
string hour[150],hour1[150],hour2[150];
int impact3[150],impactfinal[150],impact0,impactx;
string impactz[150];
int bufferlen,n,h,previ=150,nexti=150,zx=0,totalx;
datetime barw1;
string innercommentnews="";
string innercommentnews2="";
string innercommentnews3="";
string innercommentnews4="";
bool resx=false;
string status="";
string timecomment="";
int gmthour;
int gmtminute;
datetime timegmt; // Gmt time
datetime timecurrent; // Current time
int gmtoffset=0;

datetime newbar2;
string geturl(string url)
  {
   int HttpOpen=InternetOpenW(" ",0," "," ",0);
   int HttpConnect=InternetConnectW(HttpOpen,"",80,"","",3,0,1);
   int HttpRequest=InternetOpenUrlW(HttpOpen,url,NULL,0,0,0);

   int read[1];
   uchar Buffer[];
   ArrayResize(Buffer,READURL_BUFFER_SIZE+1);
   string page="";

   while(true)
     {
      InternetReadFile(HttpRequest,Buffer,READURL_BUFFER_SIZE,read);
      string strThisRead=CharArrayToString(Buffer,0,read[0],CP_UTF8);
      if(read[0]>0)
         page=page+strThisRead;
      else
         break;
     }
   if(HttpRequest>0)
      InternetCloseHandle(HttpRequest);
   if(HttpConnect>0)
      InternetCloseHandle(HttpConnect);
   if(HttpOpen>0)
      InternetCloseHandle(HttpOpen);
   return page;

  }

//=================================================================================================================================================
int init()
  {

//--- check for DLL
   if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED))
     {
      Alert("EA Robofibo v.11"+": Please Allow DLL Imports!");
      return(INIT_FAILED);
     }
   timegmt=TimeGMT();
   timecurrent=TimeCurrent();

   gmthour=StringToDouble(StringSubstr(TimeToStr(timegmt),11,2));
   gmtminute=StringToDouble(StringSubstr(TimeToStr(timegmt),14,2));
   gmtoffset=TimeHour(timecurrent)-gmthour;
   if(gmtoffset<0)
      gmtoffset=24+gmtoffset;



   int timeframe_8;
   ArrayInitialize(Gda_280, 0);
   G_digits_192 = MarketInfo(NULL,MODE_DIGITS);
   G_point_196 = MarketInfo(NULL,MODE_POINT);
   Print("Digits: " + G_digits_192 + " Point: " + DoubleToStr(G_point_196, G_digits_192));

   double lotstep_0 = MarketInfo(Symbol(), MODE_LOTSTEP);
   Gi_204 = MathLog(lotstep_0) / MathLog(0.1);
   Gd_208 = MathMax(固定手数, MarketInfo(Symbol(), MODE_MINLOT));
   Gd_216 = MathMin(MaxLots, MarketInfo(Symbol(), MODE_MAXLOT));
   switch(MinimumImpactNews)
     {
      case LowImpact:
         MinimumImpact = 1;
         break;
      case MediumImpact:
         MinimumImpact = 2;
         break;
      case HighImpact:
         MinimumImpact = 3;
         break;
     }

   Gd_224 = 资金比例 / 100.0;
   Gd_232 = NormalizeDouble(开单点差限制 * G_point_196, G_digits_192 + 1);
   Gd_241 = NormalizeDouble(挂单间距 * G_point_196, G_digits_192);
   Gd_sl = NormalizeDouble(止损点数 * G_point_196, G_digits_192);
   Gd_tp = NormalizeDouble(止盈点数 * G_point_196, G_digits_192);
   stoplevel = MarketInfo(Symbol(),MODE_STOPLEVEL);
   sellstop = NormalizeDouble((MarketInfo(Symbol(), MODE_STOPLEVEL)*Point), G_digits_192);
   Gd_256 = NormalizeDouble(G_point_196 * 单根K线波动点数, G_digits_192);
   Gi_268 = FALSE;
   Gd_272 = NormalizeDouble(G_pips_184 * G_point_196, G_digits_192 + 1);
   if(!IsTesting())
     {
      //f0_8();
      if(Gi_404)
        {
         timeframe_8 = Period();
         switch(timeframe_8)
           {
            case PERIOD_M1:
               G_timeframe_396 = 5;
               break;
            case PERIOD_M5:
               G_timeframe_396 = 15;
               break;
            case PERIOD_M15:
               G_timeframe_396 = 30;
               break;
            case PERIOD_M30:
               G_timeframe_396 = 60;
               break;
            case PERIOD_H1:
               G_timeframe_396 = 240;
               break;
            case PERIOD_H4:
               G_timeframe_396 = 1440;
               break;
            case PERIOD_D1:
               G_timeframe_396 = 10080;
               break;
            case PERIOD_W1:
               G_timeframe_396 = 43200;
               break;
            case PERIOD_MN1:
               G_timeframe_396 = 43200;
           }
        }
      Gd_420 = 0.0001;
     }

   DeleteAllObjects();

   SetIndexBuffer(0,f_1);
   SetIndexBuffer(1,f_2);
   SetIndexBuffer(2,f_3);
   SetIndexBuffer(3,f_4);
   SetIndexBuffer(4,f_5);
   SetIndexBuffer(5,f_6);
   SetIndexBuffer(6,f_7);
   SetIndexBuffer(7,f_8);
   SetIndexLabel(0,"Fibo_"+DoubleToStr(Fibo_Level_0,4));
   SetIndexLabel(1,"Fibo_"+DoubleToStr(Fibo_Level_1,4));
   SetIndexLabel(2,"Fibo_"+DoubleToStr(Fibo_Level_2,4));
   SetIndexLabel(3,"Fibo_"+DoubleToStr(Fibo_Level_3,4));
   SetIndexLabel(4,"Fibo_"+DoubleToStr(Fibo_Level_4,4));
   SetIndexLabel(5,"Fibo_"+DoubleToStr(Fibo_Level_5,4));
   SetIndexLabel(7,"Fibo_"+DoubleToStr(Fibo_Level_6,4));


   return (0);
  }
//=================================================================================================================================================
int deinit()
  {
   Comment("");
   DeleteAllObjects();
   ObjectDelete("Background");
   ObjectDelete("Background_2");
   ObjectDelete("Background_3");
   ObjectDelete("Background_4");
   ObjectDelete("Background_5");
   ObjectDelete("Info_1");
   ObjectDelete("Info_2");
   ObjectDelete("Info_3");
   ObjectDelete("Info_4");
   ObjectDelete("Info_5");
   ObjectDelete("Info_6");
   ObjectDelete("Info_7");
   ObjectDelete("Info_8");
   ObjectDelete("Info_9");
   ObjectDelete("Info_10");
   ObjectDelete("Info_11");
   ObjectDelete("Info_12");
   ObjectDelete("Info_13");
   ObjectDelete("Info_14");
   ObjectDelete("Info_15");
   ObjectDelete("Info_16");
   ObjectDelete("Info_17");
   ObjectDelete("Info_18");
   ObjectDelete("Info_19");
   ObjectDelete("Info_20");
   ObjectDelete("Info_21");
   ObjectDelete("Info_22");

   return (0);
  }
//=================================================================================================================================================
int start()
  {

   CalcFibo();
   ChartComment();
   if(CountTradesBuy()==0)
      CloseSignal=false;
   if(CountTradesSell()==0)
      CloseSignal2=false;


   TotalProfitbuy();
   TotalProfitsell();
   startBalanceD1();


     {
      if((TPbuy>0 && totalProfits >= TPbuy) || (-SLbuy < 0 && totalProfits <= -SLbuy))
         CloseSignal=true;

     }



   if(CloseSignal)
      OpenOrdClose();

     {
      if((TPsell>0 && totalProfits2 >= TPsell) || (-SLsell < 0 && totalProfits2 <= -SLsell))
         CloseSignal2=true;

     }



   if(CloseSignal2)
      OpenOrdClose2();


   if(整体止盈开关)
      if(整体止盈点数>=stoplevel)
         MoveTP();
      else
         MoveTP2();
   if(移动止损开关)
      if(移动止损点数>=stoplevel)
         Move移动止损点数();
      else
         Move移动止损点数2();
   if(可视化移动止盈开关)
      VirtualTrailing();




   double 加仓间距2 = NormalizeDouble(加仓间距 * MathPow(加仓间距倍数, CountTradesBuy()), 0);
   double 加仓间距3 = NormalizeDouble(加仓间距 * MathPow(加仓间距倍数, CountTradesSell()), 0);

   double lastsell = FindLastSellPrice_Hilo();
   double lastbuy = FindLastBuyPrice_Hilo();


   int error_8;
   string Ls_12;
   int ticket_20;
   double price_24;
   double Ld_112;
   int Li_180;
   int cmd_188;
   bool bool_32;
   double Ld_36;
   double Ld_196;
   double Ld_204;
   double Ld_205;
   double price_60;
   double price_61;
   double tp2;
   double sl2;


   double ihigh = iHigh(NULL,0,0);
   double ilow = iLow(NULL,0,0);
   double ihigh2 = iHigh(NULL,0,1);
   double ilow2 = iLow(NULL,0,1);


//signal


   close1 = iClose(NULL,IClose,1);
   close2 = iClose(NULL,IClose,2);
   rsia = iRSI(NULL,IRSI,RSI指标参数,PRICE_CLOSE,0);
   rsib = iRSI(NULL,IRSI,RSI指标参数,PRICE_CLOSE,1);
   ma = iMA(NULL,ma1,均线指标参数,0,MODE_EMA,PRICE_CLOSE,1);


   if(close1>close2)
      sign="BUY Signal";
   else
      if(close1<close2)
         sign="SELL Signal";
      else
         sign = "No Signal";

   if(rsia > 70.0 || rsib > 70.0)
      sign2 = "RSI is OVERBOUGH";
   else
      if(rsia < 30.0 || rsib < 30.0)
         sign2 = "RSI is OVERSOLD";
      else
         sign2 = "RSI is Ranging";

   if(Bid>ma)
      sign3 = "BULLISH";
   else
      if(Bid<ma)
         sign3 = "BEARISH";
      else
         sign3 = "RANGING";


//perhitungan fibo

   int LowBar = 0, HighBar= 0;
   double LowValue = 0,HighValue = 0;

   int lowest_bar = iLowest(NULL,0,MODE_LOW,斐波那契取值结束K线,斐波那契取值开始K线);
   int highest_bar = iHighest(NULL,0,MODE_HIGH,斐波那契取值结束K线,斐波那契取值开始K线);

   double higher_point = 0;
   double lower_point = 0;
   HighValue=High[highest_bar];
   LowValue=Low[lowest_bar];
   Gd_460 = HighValue - LowValue;

   double pricein0 = (斐波那契低点/100)*Gd_460 + LowValue;
   double pricein1 = (23.6/100)*Gd_460 + LowValue;
   double pricein2 = (38.2/100)*Gd_460 + LowValue;
   double pricein3 = (50.0/100)*Gd_460 + LowValue;
   double pricein4 = (61.8/100)*Gd_460 + LowValue;
   double pricein5 = (76.4/100)*Gd_460 + LowValue;
   double pricein6 = (斐波那契高点/100)*Gd_460 + LowValue;



   if(!Gi_268)
     {
      for(int pos_108 = OrdersHistoryTotal() - 1; pos_108 >= 0; pos_108--)
        {
         if(OrderSelect(pos_108, SELECT_BY_POS, MODE_HISTORY))
           {
            if(OrderProfit() != 0.0)
              {
               if(OrderClosePrice() != OrderOpenPrice())
                 {
                  if(OrderSymbol() == Symbol())
                    {
                     Gi_268 = TRUE;
                     Ld_112 = MathAbs(OrderProfit() / (OrderClosePrice() - OrderOpenPrice()));
                     Gd_272 = (-OrderCommission()) / Ld_112;
                     break;
                    }
                 }
              }
           }
        }
     }
//---------------------------------------------------------------------------


   Ld_196 = NormalizeDouble((AccountBalance() * AccountLeverage() * Gd_224)/ MarketInfo(Symbol(), MODE_LOTSIZE), Gi_204);
   if(!按资金比例开关)
      Ld_196 = 固定手数;



   TPsell = Ld_196 * 整组止盈点数 * CountTradesSell()*加仓倍数;
   if(!整组止盈开关)
      TPsell = 整组止盈金额;


   TPbuy = Ld_196 * 整组止盈点数 * CountTradesBuy()*加仓倍数;
   if(!整组止盈开关)
      TPbuy = 整组止盈金额;


   SLsell = Ld_196 * 整组止损点数 * CountTradesSell()*加仓倍数;
   if(!整组止损开关)
      SLsell = 整组止损金额;


   SLbuy = Ld_196 * 整组止损点数 * CountTradesBuy()*加仓倍数;
   if(!整组止损开关)
      SLbuy = 整组止损金额;


   double Ld_120 = Ask - Bid;
   ArrayCopy(Gda_280, Gda_280, 0, 1, 29);
   Gda_280[29] = Ld_120;
   if(Gi_284 < 30)
      Gi_284++;
   double Ld_128 = 0;
   pos_108 = 29;
   for(int count_136 = 0; count_136 < Gi_284; count_136++)
     {
      Ld_128 += Gda_280[pos_108];
      pos_108--;
     }
   double Ld_140 = Ld_128 / Gi_284;
   double Ld_148 = NormalizeDouble(Ask + Gd_272, G_digits_192);
   double Ld_156 = NormalizeDouble(Bid - Gd_272, G_digits_192);
   double Ld_164 = NormalizeDouble(Ld_140 + Gd_272, G_digits_192 + 1);
   double highlow = ihigh - ilow;
   double highlow2 = ihigh2 - ilow2;




   switch(交易模式)
     {


      case PendingLimitFollow:
         //buy
        {
         if(highlow <= Gd_256 && highlow2 <= Gd_256)
            if(CountTradesBuy()>0 && CountTradesBuy()<最大多单开单量 && (lastbuy - Ask >= (挂单间距+加仓间距2) * Point))
               Maxtrade = CountTradesBuy();
            else
               Maxtrade = CountTradesBuy()-100;

         if(CountTradesBuy() == 0 && close1 > close2 && Ask > ma && Ask > pricein6 && rsia < 70.0 && rsib < 70.0)
            Li_180 = -1;
         else
            if(CountTradesBuy() == Maxtrade && close1 > close2 && Ask > ma && rsia < 70.0 && rsib < 70.0)
               Li_180 = -1;

        }

         //sell
        {
         if(highlow <= Gd_256 && highlow2 <= Gd_256)
            if(CountTradesSell()>0 && CountTradesSell()<最大空单开单量 && (Bid - lastsell >= (挂单间距+加仓间距3) * Point))
               Maxtrade2 = CountTradesSell();
            else
               Maxtrade2 = CountTradesSell()-100;

         if(CountTradesSell() == 0  && close1 < close2 && Bid < ma && Bid < pricein0 && rsia > 30.0 && rsib > 30.0)
            Li_180 = 1;
         else
            if(CountTradesSell() == Maxtrade2 && close1 < close2 && Bid < ma && rsia > 30.0 && rsib > 30.0)
               Li_180 = 1;

        }
      break;


      case PendingLimitReverse:
         //buy
        {
         if(highlow <= Gd_256 && highlow2 <= Gd_256)
            if(CountTradesBuy()>0 && CountTradesBuy()<最大多单开单量 && (lastbuy - Ask >= (挂单间距+加仓间距2) * Point))
               Maxtrade = CountTradesBuy();
            else
               Maxtrade = CountTradesBuy()-100;

         if(CountTradesBuy() == 0 && close1 > close2 && Ask > ma && Ask < pricein0 && rsia < 70.0 && rsib < 70.0)
            Li_180 = 1;
         else
            if(CountTradesBuy() == Maxtrade && close1 > close2 && Ask > ma && Ask < pricein0 && rsia < 70.0 && rsib < 70.0)
               Li_180 = 1;

        }

         //sell
        {
         if(highlow <= Gd_256 && highlow2 <= Gd_256)
            if(CountTradesSell()>0 && CountTradesSell()<最大空单开单量 && (Bid - lastsell >= (挂单间距+加仓间距3) * Point))
               Maxtrade2 = CountTradesSell();
            else
               Maxtrade2 = CountTradesSell()-100;

         if(CountTradesSell() == 0  && close1 < close2 && Bid < ma && Bid > pricein6 && rsia > 30.0 && rsib > 30.0)
            Li_180 = -1;
         else
            if(CountTradesSell() == Maxtrade2 && close1 < close2 && Bid < ma && rsia > 30.0 && rsib > 30.0)
               Li_180 = -1;

        }

      break;

      case PendingStopFollow:

         //buy
        {
         if(highlow <= Gd_256 && highlow2 <= Gd_256)
            if(CountTradesBuy()>0 && CountTradesBuy()<最大多单开单量 && (lastbuy - Ask >= (挂单间距+加仓间距2) * Point))
               Maxtrade = CountTradesBuy();
            else
               Maxtrade = CountTradesBuy()-100;

         if(CountTradesBuy() == 0)
            Li_180 = -1;
         else
            if(CountTradesBuy() == Maxtrade)
               Li_180 = -1;

        }

         //sell
        {
         if(highlow <= Gd_256 && highlow2 <= Gd_256)
            if(CountTradesSell()>0 && CountTradesSell()<最大空单开单量 && (Bid - lastsell >= (挂单间距+加仓间距3) * Point))
               Maxtrade2 = CountTradesSell();
            else
               Maxtrade2 = CountTradesSell()-100;

         if(CountTradesSell() == 0  && close1 < close2 && Bid < ma && Bid < pricein0 && rsia > 30.0 && rsib > 30.0)
            Li_180 = 1;
         else
            if(CountTradesSell() == Maxtrade2 && close1 < close2 && Bid < ma && rsia > 30.0 && rsib > 30.0)
               Li_180 = 1;
        }
      break;

      case PendingStopReverse:

         //buy
        {
         if(highlow <= Gd_256 && highlow2 <= Gd_256)
            if(CountTradesBuy()>0 && CountTradesBuy()<最大多单开单量 && (lastbuy - Ask >= (挂单间距+加仓间距2) * Point))
               Maxtrade = CountTradesBuy();
            else
               Maxtrade = CountTradesBuy()-100;

         if(CountTradesBuy() == 0 && Ask < pricein0)
            Li_180 = 1;
         else
            if(CountTradesBuy() == Maxtrade)
               Li_180 = 1;

        }

         //sell
        {
         if(highlow <= Gd_256 && highlow2 <= Gd_256)
            if(CountTradesSell()>0 && CountTradesSell()<最大空单开单量 && (Bid - lastsell >= (挂单间距+加仓间距3) * Point))
               Maxtrade2 = CountTradesSell();
            else
               Maxtrade2 = CountTradesSell()-100;

         if(CountTradesSell() == 0 && Bid > pricein6)
            Li_180 = -1;
         else
            if(CountTradesSell() == Maxtrade2)
               Li_180 = -1;

        }

      break;

     }


   int count_184 = 0;

//---------------------------------------------------------------------------


   for(pos_108 = 0; pos_108 < OrdersTotal(); pos_108++)
     {
      if(OrderSelect(pos_108, SELECT_BY_POS, MODE_TRADES))
        {
         if(OrderMagicNumber() == MagicNumber)


           {
            cmd_188 = OrderType();

            if(cmd_188 == OP_BUY || cmd_188 == OP_SELL)
               continue;


            if(OrderSymbol() == Symbol())
              {
               count_184++;



               switch(cmd_188)
                 {
                  case OP_BUYSTOP:
                     Ld_36 = NormalizeDouble(OrderOpenPrice(), G_digits_192);
                     if(挂单间距 <= stoplevel)
                        Gd_240 = sellstop;
                     else
                        Gd_240 = Gd_241;

                     if(止损点数 <= stoplevel)
                        Gd_242 = sellstop;
                     else
                        Gd_242 = Gd_sl;

                     if(止盈点数 <= stoplevel)
                        Gd_243 = sellstop;
                     else
                        Gd_243 = Gd_tp;

                     price_24 = NormalizeDouble(Ask + Gd_240, G_digits_192);
                     if(!((price_24 < Ld_36)))
                        break;
                     price_60 = NormalizeDouble(price_24 - Gd_242, G_digits_192);
                     price_61 = NormalizeDouble(price_24 + Gd_243, G_digits_192);

                     if(!每单止损开关)
                        sl2 = 0;
                     else
                        sl2 = price_60;

                     if(!每单止盈开关)
                        tp2 = 0;
                     else
                        tp2 = price_61;


                     // Added check for matching magic number and symbol before modifying order
                     if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
                        bool_32 = OrderModify(OrderTicket(), price_24, sl2, tp2, 0, clrBlue);
                     if(!(!bool_32))
                        break;
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("BUYSTOP Modify Error Code: " + error_8 + " Message: " + Ls_12 + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " + DoubleToStr(sl2, G_digits_192) + " TP: " + DoubleToStr(tp2, G_digits_192)+
                           " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                     break;
                  case OP_SELLSTOP:
                     Ld_36 = NormalizeDouble(OrderOpenPrice(), G_digits_192);
                     if(挂单间距 <= stoplevel)
                        Gd_240 = sellstop;
                     else
                        Gd_240 = Gd_241;

                     if(止损点数 <= stoplevel)
                        Gd_242 = sellstop;
                     else
                        Gd_242 = Gd_sl;

                     if(止盈点数 <= stoplevel)
                        Gd_243 = sellstop;
                     else
                        Gd_243 = Gd_tp;;

                     price_24 = NormalizeDouble(Bid - Gd_240, G_digits_192);
                     if(!((price_24 > Ld_36)))
                        break;
                     price_60 = NormalizeDouble(price_24 + Gd_242, G_digits_192);
                     price_61 = NormalizeDouble(price_24 - Gd_243, G_digits_192);

                     if(!每单止损开关)
                        sl2 = 0;
                     else
                        sl2 = price_60;

                     if(!每单止盈开关)
                        tp2 = 0;
                     else
                        tp2 = price_61;

                     // Added check for matching magic number and symbol before modifying order
                     if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
                        bool_32 = OrderModify(OrderTicket(), price_24, sl2, tp2, 0, clrRed);
                     if(!(!bool_32))
                        break;
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("SELLSTOP Modify Error Code: " + error_8 + " Message: " + Ls_12 + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " + DoubleToStr(sl2, G_digits_192)+ " TP: " + DoubleToStr(tp2, G_digits_192) +
                           " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                     break;
                  case OP_SELLLIMIT:
                     Ld_36 = NormalizeDouble(OrderOpenPrice(), G_digits_192);
                     if(挂单间距 <= stoplevel)
                        Gd_240 = sellstop;
                     else
                        Gd_240 = Gd_241;

                     if(止损点数 <= stoplevel)
                        Gd_242 = sellstop;
                     else
                        Gd_242 = Gd_sl;

                     if(止盈点数 <= stoplevel)
                        Gd_243 = sellstop;
                     else
                        Gd_243 = Gd_tp;

                     price_24 = NormalizeDouble(Bid + Gd_240, G_digits_192);
                     if(!((price_24 < Ld_36)))
                        break;
                     price_60 = NormalizeDouble(price_24 + Gd_242, G_digits_192);
                     price_61 = NormalizeDouble(price_24 - Gd_243, G_digits_192);

                     if(!每单止损开关)
                        sl2 = 0;
                     else
                        sl2 = price_60;

                     if(!每单止盈开关)
                        tp2 = 0;
                     else
                        tp2 = price_61;

                     if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
                        bool_32 = OrderModify(OrderTicket(), price_24, sl2, tp2, 0, clrRed);
                     if(!(!bool_32))
                        break;
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("SELLLIMIT Modify Error Code: " + error_8 + " Message: " + Ls_12 + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " + DoubleToStr(sl2, G_digits_192) + " TP: " + DoubleToStr(tp2, G_digits_192) +
                           " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                     break;
                  case OP_BUYLIMIT:
                     Ld_36 = NormalizeDouble(OrderOpenPrice(), G_digits_192);
                     if(挂单间距 <= stoplevel)
                        Gd_240 = sellstop;
                     else
                        Gd_240 = Gd_241;

                     if(止损点数 <= stoplevel)
                        Gd_242 = sellstop;
                     else
                        Gd_242 = Gd_sl;

                     if(止盈点数 <= stoplevel)
                        Gd_243 = sellstop;
                     else
                        Gd_243 = Gd_tp;

                     price_24 = NormalizeDouble(Ask - Gd_240, G_digits_192);
                     if(!((price_24 > Ld_36)))
                        break;
                     price_60 = NormalizeDouble(price_24 - Gd_242, G_digits_192);
                     price_61 = NormalizeDouble(price_24 + Gd_243, G_digits_192);

                     if(!每单止损开关)
                        sl2 = 0;
                     else
                        sl2 = price_60;

                     if(!每单止盈开关)
                        tp2 = 0;
                     else
                        tp2 = price_61;

                     if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
                        bool_32 = OrderModify(OrderTicket(), price_24, sl2, tp2, 0, clrBlue);
                     if(!(!bool_32))
                        break;
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("BUYLIMIT Modify Error Code: " + error_8 + " Message: " + Ls_12 + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " + DoubleToStr(sl2, G_digits_192) + " TP: " + DoubleToStr(tp2, G_digits_192) +
                           " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                     break;

                 }
              }
           }
        }
     }


//---------------------------------------------------------------------------

     {

      //if(newbar2!=iTime(NULL,1,0)){

      timegmt=TimeGMT();
      gmthour=StringToDouble(StringSubstr(TimeToStr(timegmt),11,2));
      gmtminute=StringToDouble(StringSubstr(TimeToStr(timegmt),14,2));

      if(重大新闻过滤==true && EventSetTimer(重大新闻更新间隔*3600))
         news();


      dategmt=TimeGMT();

      previ=150;
      nexti=150;
      for(n=0; n<=150; n++)
        {
         if(dategmt<datefinal[n])
            break;
         if(impactfinal[n]>=MinimumImpact && (s1==country[n] || s2==country[n] || (ForceALL==true && "ALL"==country[n])
                                              || (ForceUSD==true && "USD"==country[n]) || (ForceCNY==true && "CNY"==country[n]) || (ForceGBP==true && "GBP"==country[n])
                                              || (ForceJPY==true && "JPY"==country[n]) || (ForceAUD==true && "AUD"==country[n]) || (ForceCAD==true && "CAD"==country[n])
                                              || (ForceCHF==true && "CHF"==country[n]) || (ForceEUR==true && "EUR"==country[n]) || (ForceNZD==true && "NZD"==country[n])))
            if(dategmt>datefinal[n] && datefinal[n]!=0)
               previ=n;
        }
      for(n=0; n<=150; n++)
        {
         if(nexti!=150)
            break;
         if(impactfinal[n]>=MinimumImpact && (s1==country[n] || s2==country[n] || (ForceALL==true && "ALL"==country[n])
                                              || (ForceUSD==true && "USD"==country[n]) || (ForceCNY==true && "CNY"==country[n]) || (ForceGBP==true && "GBP"==country[n])
                                              || (ForceJPY==true && "JPY"==country[n]) || (ForceAUD==true && "AUD"==country[n]) || (ForceCAD==true && "CAD"==country[n])
                                              || (ForceCHF==true && "CHF"==country[n]) || (ForceEUR==true && "EUR"==country[n]) || (ForceNZD==true && "NZD"==country[n])))
            if(dategmt<datefinal[n])
               nexti=n;
        }

      title0=title[previ];
      impact0=impactfinal[previ];
      country0=country[previ];
      date0=TimeToStr(datefinal[previ]);

      titlex=title[nexti];
      impactx=impactfinal[nexti];
      countryx=country[nexti];
      datex=TimeToStr(datefinal[nexti]);


      prevnews=(dategmt-datefinal[previ])/60;//(dategmt-datefinal[previ])/60;//(datefinal[previ]-dategmt)/60;
      nextnews=(datefinal[nexti]-dategmt)/60;//(datefinal[nexti]-dategmt)/60;



     }
   if(重大新闻过滤==true && (prevnews<重大新闻后多少分钟开始交易 || (nextnews>=0 && nextnews<=重大新闻前多少分钟禁止交易)))
      status1 = "News Time Trade Is Disabled";
   else
      status1 = "Trade Is Active";

   if(重大新闻过滤==true && (prevnews<重大新闻后多少分钟开始交易 || (nextnews>=0 && nextnews<=重大新闻前多少分钟禁止交易)))
      return(0);

   switch(交易模式)
     {

      case PendingLimitFollow:

         if(count_184 == 0 && Li_180 != 0 && Ld_164 <= Gd_232 && f0_4())
           {
            Ld_196 = AccountBalance() * AccountLeverage() * Gd_224 / MarketInfo(Symbol(), MODE_LOTSIZE);
            if(!按资金比例开关)
               Ld_196 = 固定手数;

            Ld_204 = NormalizeDouble(Ld_196 * MathPow(加仓倍数,CountTradesBuy()), G_digits_192);
            Ld_204 = MathMax(Gd_208, Ld_204);
            Ld_204 = MathMin(Gd_216, Ld_204);


            Ld_205 = NormalizeDouble(Ld_196 * MathPow(加仓倍数,CountTradesSell()), G_digits_192);
            Ld_205 = MathMax(Gd_208, Ld_205);
            Ld_205 = MathMin(Gd_216, Ld_205);



            if(Li_180 < 0)
              {

               if(挂单间距 <= stoplevel)
                  Gd_240 = sellstop;
               else
                  Gd_240 = Gd_241;

               if(止损点数 <= stoplevel)
                  Gd_242 = sellstop;
               else
                  Gd_242 = Gd_sl;

               if(止盈点数 <= stoplevel)
                  Gd_243 = sellstop;
               else
                  Gd_243 = Gd_tp;

               price_24 = NormalizeDouble(Ask - Gd_240, G_digits_192);
               price_60 = NormalizeDouble(price_24 - Gd_242, G_digits_192);
               price_61 = NormalizeDouble(price_24 + Gd_243, G_digits_192);

               if(!每单止损开关)
                  sl2 = 0;
               else
                  sl2 = price_60;

               if(!每单止盈开关)
                  tp2 = 0;
               else
                  tp2 = price_61;
               if(this_type==OP_BUY || this_type==3)
                 {
                  ticket_20 = OrderSend(Symbol(), OP_BUYLIMIT, Ld_204, price_24, Slippage, sl2, tp2, TradeComment, MagicNumber, 0, clrBlue);
                  if(ticket_20 <= 0)
                    {
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("BUYLIMIT Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_204, G_digits_192) + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " +
                           DoubleToStr(sl2, G_digits_192) + " TP: " + DoubleToStr(tp2, G_digits_192)+ " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));

                    }
                 }
              }
            else
              {
               if(挂单间距 <= stoplevel)
                  Gd_240 = sellstop;
               else
                  Gd_240 = Gd_241;

               if(止损点数 <= stoplevel)
                  Gd_242 = sellstop;
               else
                  Gd_242 = Gd_sl;

               if(止盈点数 <= stoplevel)
                  Gd_243 = sellstop;
               else
                  Gd_243 = Gd_tp;

               price_24 = NormalizeDouble(Bid + Gd_240, G_digits_192);
               price_60 = NormalizeDouble(price_24 + Gd_242, G_digits_192);
               price_61 = NormalizeDouble(price_24 - Gd_243, G_digits_192);

               if(!每单止损开关)
                  sl2 = 0;
               else
                  sl2 = price_60;

               if(!每单止盈开关)
                  tp2 = 0;
               else
                  tp2 = price_61;
               if(this_type==OP_SELL || this_type==3)
                 {
                  ticket_20 = OrderSend(Symbol(), OP_SELLLIMIT, Ld_205, price_24, Slippage, sl2, tp2, TradeComment, MagicNumber, 0, clrRed);
                  if(ticket_20 <= 0)
                    {
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("SELLLIMIT Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_205, G_digits_192) + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " +
                           DoubleToStr(sl2, G_digits_192)+ " TP: " + DoubleToStr(tp2, G_digits_192) + " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                    }
                 }

              }
           }
         break;



      case PendingLimitReverse:
         if(count_184 == 0 && Li_180 != 0 && Ld_164 <= Gd_232 && f0_4())
           {

            Ld_196 = AccountBalance() * AccountLeverage() * Gd_224 / MarketInfo(Symbol(), MODE_LOTSIZE);
            if(!按资金比例开关)
               Ld_196 = 固定手数;

            Ld_204 = NormalizeDouble(Ld_196 * MathPow(加仓倍数,CountTradesBuy()),G_digits_192);
            Ld_204 = MathMax(Gd_208, Ld_204);
            Ld_204 = MathMin(Gd_216, Ld_204);


            Ld_205 = NormalizeDouble(Ld_196 * MathPow(加仓倍数,CountTradesSell()), G_digits_192);
            Ld_205 = MathMax(Gd_208, Ld_205);
            Ld_205 = MathMin(Gd_216, Ld_205);


            if(Li_180 < 0)
              {

               if(挂单间距 <= stoplevel)
                  Gd_240 = sellstop;
               else
                  Gd_240 = Gd_241;

               if(止损点数 <= stoplevel)
                  Gd_242 = sellstop;
               else
                  Gd_242 = Gd_sl;

               if(止盈点数 <= stoplevel)
                  Gd_243 = sellstop;
               else
                  Gd_243 = Gd_tp;

               price_24 = NormalizeDouble(Bid + Gd_240, G_digits_192);
               price_60 = NormalizeDouble(price_24 + Gd_242, G_digits_192);
               price_61 = NormalizeDouble(price_24 - Gd_243, G_digits_192);

               if(!每单止损开关)
                  sl2 = 0;
               else
                  sl2 = price_60;

               if(!每单止盈开关)
                  tp2 = 0;
               else
                  tp2 = price_61;
               if(this_type==OP_SELL || this_type==3)
                 {
                  ticket_20 = OrderSend(Symbol(), OP_SELLLIMIT, Ld_205, price_24, Slippage, sl2, tp2, TradeComment, MagicNumber, 0, clrRed);
                  if(ticket_20 <= 0)
                    {
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("SELLLIMIT Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_205, G_digits_192) + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " +
                           DoubleToStr(sl2, G_digits_192)+ " TP: " + DoubleToStr(tp2, G_digits_192) + " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                    }
                 }

              }
            else
              {
               if(挂单间距 <= stoplevel)
                  Gd_240 = sellstop;
               else
                  Gd_240 = Gd_241;

               if(止损点数 <= stoplevel)
                  Gd_242 = sellstop;
               else
                  Gd_242 = Gd_sl;

               if(止盈点数 <= stoplevel)
                  Gd_243 = sellstop;
               else
                  Gd_243 = Gd_tp;

               price_24 = NormalizeDouble(Ask - Gd_240, G_digits_192);
               price_60 = NormalizeDouble(price_24 - Gd_242, G_digits_192);
               price_61 = NormalizeDouble(price_24 + Gd_243, G_digits_192);

               if(!每单止损开关)
                  sl2 = 0;
               else
                  sl2 = price_60;

               if(!每单止盈开关)
                  tp2 = 0;
               else
                  tp2 = price_61;
               if(this_type==OP_BUY || this_type==3)
                 {
                  ticket_20 = OrderSend(Symbol(), OP_BUYLIMIT, Ld_204, price_24, Slippage, sl2, tp2, TradeComment, MagicNumber, 0, clrBlue);
                  if(ticket_20 <= 0)
                    {
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("BUYLIMIT Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_204, G_digits_192) + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " +
                           DoubleToStr(sl2, G_digits_192) + " TP: " + DoubleToStr(tp2, G_digits_192)+ " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                    }
                 }

              }
           }

         break;





      case PendingStopFollow:

         if(count_184 == 0 && Li_180 != 0 && Ld_164 <= Gd_232 && f0_4())
           {
            Ld_196 = AccountBalance() * AccountLeverage() * Gd_224/ MarketInfo(Symbol(), MODE_LOTSIZE);
            if(!按资金比例开关)
               Ld_196 = 固定手数;

            Ld_204 = NormalizeDouble(Ld_196 * MathPow(加仓倍数,CountTradesBuy()), G_digits_192);
            Ld_204 = MathMax(Gd_208, Ld_204);
            Ld_204 = MathMin(Gd_216, Ld_204);


            Ld_205 = NormalizeDouble(Ld_196 * MathPow(加仓倍数,CountTradesSell()), G_digits_192);
            Ld_205 = MathMax(Gd_208, Ld_205);
            Ld_205 = MathMin(Gd_216, Ld_205);



            if(Li_180 < 0)
              {

               if(挂单间距 <= stoplevel)
                  Gd_240 = sellstop;
               else
                  Gd_240 = Gd_241;

               if(止损点数 <= stoplevel)
                  Gd_242 = sellstop;
               else
                  Gd_242 = Gd_sl;

               if(止盈点数 <= stoplevel)
                  Gd_243 = sellstop;
               else
                  Gd_243 = Gd_tp;

               price_24 = NormalizeDouble(Ask + Gd_240, G_digits_192);
               price_60 = NormalizeDouble(price_24 - Gd_242, G_digits_192);
               price_61 = NormalizeDouble(price_24 + Gd_243, G_digits_192);

               if(!每单止损开关)
                  sl2 = 0;
               else
                  sl2 = price_60;

               if(!每单止盈开关)
                  tp2 = 0;
               else
                  tp2 = price_61;
               if(this_type==OP_BUY || this_type==3)
                 {
                  ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, Ld_204, price_24, Slippage, sl2, tp2, TradeComment, MagicNumber, 0, clrBlue);
                  if(ticket_20 <= 0)
                    {
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("BUYSTOP Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_204, G_digits_192) + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " +
                           DoubleToStr(sl2, G_digits_192) + " TP: " + DoubleToStr(tp2, G_digits_192)+ " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                    }
                 }

              }
            else
              {
               if(挂单间距 <= stoplevel)
                  Gd_240 = sellstop;
               else
                  Gd_240 = Gd_241;

               if(止损点数 <= stoplevel)
                  Gd_242 = sellstop;
               else
                  Gd_242 = Gd_sl;

               if(止盈点数 <= stoplevel)
                  Gd_243 = sellstop;
               else
                  Gd_243 = Gd_tp;

               price_24 = NormalizeDouble(Bid - Gd_240, G_digits_192);
               price_60 = NormalizeDouble(price_24 + Gd_242, G_digits_192);
               price_61 = NormalizeDouble(price_24 - Gd_243, G_digits_192);

               if(!每单止损开关)
                  sl2 = 0;
               else
                  sl2 = price_60;

               if(!每单止盈开关)
                  tp2 = 0;
               else
                  tp2 = price_61;

               if(this_type==OP_SELL || this_type==3)
                 {
                  ticket_20 = OrderSend(Symbol(), OP_SELLSTOP, Ld_205, price_24, Slippage, sl2, tp2, TradeComment, MagicNumber, 0, clrRed);
                  if(ticket_20 <= 0)
                    {
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("SELLSTOP Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_205, G_digits_192) + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " +
                           DoubleToStr(sl2, G_digits_192)+ " TP: " + DoubleToStr(tp2, G_digits_192) + " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                    }
                 }

              }
           }
         break;



      case PendingStopReverse:
         if(count_184 == 0 && Li_180 != 0 && Ld_164 <= Gd_232 && f0_4())
           {

            Ld_196 = AccountBalance() * AccountLeverage() * Gd_224/ MarketInfo(Symbol(), MODE_LOTSIZE);
            if(!按资金比例开关)
               Ld_196 = 固定手数;

            Ld_204 = NormalizeDouble(Ld_196 * MathPow(加仓倍数,CountTradesBuy()), G_digits_192);
            Ld_204 = MathMax(Gd_208, Ld_204);
            Ld_204 = MathMin(Gd_216, Ld_204);


            Ld_205 = NormalizeDouble(Ld_196 * MathPow(加仓倍数,CountTradesSell()), G_digits_192);
            Ld_205 = MathMax(Gd_208, Ld_205);
            Ld_205 = MathMin(Gd_216, Ld_205);



            if(Li_180 < 0)
              {

               if(挂单间距 <= stoplevel)
                  Gd_240 = sellstop;
               else
                  Gd_240 = Gd_241;

               if(止损点数 <= stoplevel)
                  Gd_242 = sellstop;
               else
                  Gd_242 = Gd_sl;

               if(止盈点数 <= stoplevel)
                  Gd_243 = sellstop;
               else
                  Gd_243 = Gd_tp;

               price_24 = NormalizeDouble(Bid - Gd_240, G_digits_192);
               price_60 = NormalizeDouble(price_24 + Gd_242, G_digits_192);
               price_61 = NormalizeDouble(price_24 - Gd_243, G_digits_192);

               if(!每单止损开关)
                  sl2 = 0;
               else
                  sl2 = price_60;

               if(!每单止盈开关)
                  tp2 = 0;
               else
                  tp2 = price_61;
               if(this_type==OP_SELL || this_type==3)
                 {
                  ticket_20 = OrderSend(Symbol(), OP_SELLSTOP, Ld_205, price_24, Slippage, sl2, tp2, TradeComment, MagicNumber, 0, clrRed);
                  if(ticket_20 <= 0)
                    {
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("SELLSTOP Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_205, G_digits_192) + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " +
                           DoubleToStr(sl2, G_digits_192)+ " TP: " + DoubleToStr(tp2, G_digits_192) + " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                    }
                 }

              }
            else
              {
               if(挂单间距 <= stoplevel)
                  Gd_240 = sellstop;
               else
                  Gd_240 = Gd_241;

               if(止损点数 <= stoplevel)
                  Gd_242 = sellstop;
               else
                  Gd_242 = Gd_sl;

               if(止盈点数 <= stoplevel)
                  Gd_243 = sellstop;
               else
                  Gd_243 = Gd_tp;

               price_24 = NormalizeDouble(Ask + Gd_240, G_digits_192);
               price_60 = NormalizeDouble(price_24 - Gd_242, G_digits_192);
               price_61 = NormalizeDouble(price_24 + Gd_243, G_digits_192);

               if(!每单止损开关)
                  sl2 = 0;
               else
                  sl2 = price_60;

               if(!每单止盈开关)
                  tp2 = 0;
               else
                  tp2 = price_61;
               if(this_type==OP_SELL || this_type==3)
                 {

                  ticket_20 = OrderSend(Symbol(), OP_BUYSTOP, Ld_204, price_24, Slippage, sl2, tp2, TradeComment, MagicNumber, 0, clrBlue);
                  if(ticket_20 <= 0)
                    {
                     error_8 = GetLastError();
                     Ls_12 = ErrorDescription(error_8);
                     Print("BUYSTOP Send Error Code: " + error_8 + " Message: " + Ls_12 + " LT: " + DoubleToStr(Ld_204, G_digits_192) + " OP: " + DoubleToStr(price_24, G_digits_192) + " SL: " +
                           DoubleToStr(sl2, G_digits_192) + " TP: " + DoubleToStr(tp2, G_digits_192)+ " Bid: " + DoubleToStr(Bid, G_digits_192) + " Ask: " + DoubleToStr(Ask, G_digits_192));
                    }
                 }
              }
           }

         break;


     }
//---------------------------------------------------------------------------
   string Ls_212 = "AvgSpread:" + DoubleToStr(Ld_140, G_digits_192) + "  Commission rate:" + DoubleToStr(Gd_272, G_digits_192 + 1) + "  Real avg. spread:" + DoubleToStr(Ld_164, G_digits_192 + 1);
   if(Ld_164 > Gd_232)
     {
      Ls_212 = Ls_212
               + "\n"
               + "The EA can not run with this spread ( " + DoubleToStr(Ld_164, G_digits_192 + 1) + " > " + DoubleToStr(Gd_232, G_digits_192 + 1) + " )";
     }
   return(0);
  }
//=================================================================================================================================================
int f0_4()
  {
   if((Hour() > StartHour && Hour() < EndHour) || (Hour() == StartHour && Minute() >= StartMinute) || (Hour() == EndHour && Minute() < EndMinute))
      return (1);
   return (0);
  }

//=================================================================================================================================================
//+------------------------------------------------------------------+
//| trailing functions                                               |
//+------------------------------------------------------------------+
void Move移动止损点数()
  {


   double AveragePrice = 0;
   double Count = 0;
   for(int cnt2 = OrdersTotal() - 1; cnt2 >= 0; cnt2--)
     {
      if(!OrderSelect(cnt2, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_BUY)
           {
            AveragePrice += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
           }
        }
     }


   double total2 = CountTradesSell();
   double AveragePrice2 = 0;
   double Count2 = 0;
   for(int cnt22 = OrdersTotal() - 1; cnt22 >= 0; cnt22--)
     {
      if(!OrderSelect(cnt22, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_SELL)
           {
            AveragePrice2 += OrderOpenPrice() * OrderLots();
            Count2 += OrderLots();
           }
        }
     }

   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderType()<=OP_SELL&& OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         if(OrderType()==OP_BUY)
           {
            if(移动止损点数>0&&NormalizeDouble(Ask-盈利多少点开始移动止盈*Point,Digits)>NormalizeDouble(OrderOpenPrice()+移动止损点数*Point,Digits))
               if(NormalizeDouble(Ask-盈利多少点开始移动止盈*Point,Digits)>NormalizeDouble((AveragePrice/Count)+移动止损点数*Point,Digits))

                 {
                  if((NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(Bid-移动止损点数*Point,Digits))||(OrderStopLoss()==0))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-移动止损点数*Point,Digits),OrderTakeProfit(),0,clrBlue))
                        continue;
                     if(GetLastError()==0)
                        Print(Symbol()+ ": Trailing Buy OrderModify ok ");

                    }
                 }
           }
         else
           {
            if(移动止损点数>0&&NormalizeDouble(Bid+盈利多少点开始移动止盈*Point,Digits)<NormalizeDouble(OrderOpenPrice()-移动止损点数*Point,Digits))
               if(NormalizeDouble(Bid+盈利多少点开始移动止盈*Point,Digits)<NormalizeDouble((AveragePrice2/Count2)-移动止损点数*Point,Digits))

                 {
                  if((NormalizeDouble(OrderStopLoss(),Digits)>(NormalizeDouble(Ask+移动止损点数*Point,Digits)))||(OrderStopLoss()==0))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+移动止损点数*Point,Digits),OrderTakeProfit(),0,clrRed))
                        continue;
                     if(GetLastError()==0)
                        Print(Symbol()+ ": Trailing Sell OrderModify ok ");

                    }
                 }
           }
        }
     }
  }


//+------------------------------------------------------------------+
//| trailing functions                                               |
//+------------------------------------------------------------------+
void Move移动止损点数2()
  {


   double AveragePrice = 0;
   double Count = 0;
   for(int cnt2 = OrdersTotal() - 1; cnt2 >= 0; cnt2--)
     {
      if(!OrderSelect(cnt2, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_BUY)
           {
            AveragePrice += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
           }
        }
     }


   double total2 = CountTradesSell();
   double AveragePrice2 = 0;
   double Count2 = 0;
   for(int cnt22 = OrdersTotal() - 1; cnt22 >= 0; cnt22--)
     {
      if(!OrderSelect(cnt22, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_SELL)
           {
            AveragePrice2 += OrderOpenPrice() * OrderLots();
            Count2 += OrderLots();
           }
        }
     }

   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderType()<=OP_SELL&& OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         if(OrderType()==OP_BUY)
           {
            if(移动止损点数>0&&NormalizeDouble(Ask-盈利多少点开始移动止盈*Point,Digits)>NormalizeDouble(OrderOpenPrice()+stoplevel*Point,Digits))
               if(NormalizeDouble(Ask-盈利多少点开始移动止盈*Point,Digits)>NormalizeDouble((AveragePrice/Count)+stoplevel*Point,Digits))

                 {
                  if((NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(Bid-stoplevel*Point,Digits))||(OrderStopLoss()==0))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Bid-stoplevel*Point,Digits),OrderTakeProfit(),0,clrBlue))
                        continue;
                     if(GetLastError()==0)
                        Print(Symbol()+ ": Trailing Buy OrderModify ok ");

                    }
                 }
           }
         else
           {
            if(移动止损点数>0&&NormalizeDouble(Bid+盈利多少点开始移动止盈*Point,Digits)<NormalizeDouble(OrderOpenPrice()-stoplevel*Point,Digits))
               if(NormalizeDouble(Bid+盈利多少点开始移动止盈*Point,Digits)<NormalizeDouble((AveragePrice2/Count2)-stoplevel*Point,Digits))

                 {
                  if((NormalizeDouble(OrderStopLoss(),Digits)>(NormalizeDouble(Ask+stoplevel*Point,Digits)))||(OrderStopLoss()==0))
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(Ask+stoplevel*Point,Digits),OrderTakeProfit(),0,clrRed))
                        continue;
                     if(GetLastError()==0)
                        Print(Symbol()+ ": Trailing Sell OrderModify ok ");

                    }
                 }
           }
        }
     }
  }

//+--------------------------------------------------------------------------------------------------------------+
//TPall
//+------------------------------------------------------------------+
void MoveTP()
  {
   double total = CountTradesBuy();
   double AveragePrice = 0;
   double Count = 0;
   for(int cnt2 = OrdersTotal() - 1; cnt2 >= 0; cnt2--)
     {
      if(!OrderSelect(cnt2, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_BUY)
           {
            AveragePrice += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
           }
        }
     }


   double total2 = CountTradesSell();
   double AveragePrice2 = 0;
   double Count2 = 0;
   for(int cnt22 = OrdersTotal() - 1; cnt22 >= 0; cnt22--)
     {
      if(!OrderSelect(cnt22, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_SELL)
           {
            AveragePrice2 += OrderOpenPrice() * OrderLots();
            Count2 += OrderLots();
           }
        }
     }

   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderType()<=OP_SELL&& OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         if(OrderType()==OP_BUY)
           {
            if(整体止盈开关)
               if(整体止盈点数>0 && OrderTakeProfit()!=NormalizeDouble(AveragePrice/Count + 整体止盈点数*Point,Digits))
                 {
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(AveragePrice/Count + 整体止盈点数*Point,Digits),0,clrBlue))
                        continue;
                     if(GetLastError()==0)
                        Print(Symbol()+ ": TP Buy Modify ok ");

                    }
                 }
           }
         else
           {
            if(整体止盈开关)
               if(整体止盈点数>0 && OrderTakeProfit()!=NormalizeDouble(AveragePrice2/Count2 - 整体止盈点数*Point,Digits))
                 {
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(AveragePrice2/Count2 - 整体止盈点数*Point,Digits),0,clrRed))
                        continue;
                     if(GetLastError()==0)
                        Print(Symbol()+ ": TP Sell Modify ok ");

                    }
                 }
           }
        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MoveTP2()
  {

   double total = CountTradesBuy();
   double AveragePrice = 0;
   double Count = 0;
   for(int cnt2 = OrdersTotal() - 1; cnt2 >= 0; cnt2--)
     {
      if(!OrderSelect(cnt2, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_BUY)
           {
            AveragePrice += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
           }
        }
     }


   double total2 = CountTradesSell();
   double AveragePrice2 = 0;
   double Count2 = 0;
   for(int cnt22 = OrdersTotal() - 1; cnt22 >= 0; cnt22--)
     {
      if(!OrderSelect(cnt22, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_SELL)
           {
            AveragePrice2 += OrderOpenPrice() * OrderLots();
            Count2 += OrderLots();
           }
        }
     }

   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderType()<=OP_SELL&& OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
        {
         if(OrderType()==OP_BUY)
           {
            if(整体止盈开关)
               if(OrderTakeProfit()!=NormalizeDouble(AveragePrice/Count + stoplevel*Point,Digits))
                 {
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(AveragePrice/Count + stoplevel*Point,Digits),0,clrBlue))
                        continue;
                     if(GetLastError()==0)
                        Print(Symbol()+ ": TP Buy Modify ok ");

                    }
                 }
           }
         else
           {
            if(整体止盈开关)
               if(OrderTakeProfit()!=NormalizeDouble(AveragePrice2/Count2 - stoplevel*Point,Digits))
                 {
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(AveragePrice2/Count2 - stoplevel*Point,Digits),0,clrRed))
                        continue;
                     if(GetLastError()==0)
                        Print(Symbol()+ ": TP Sell Modify ok ");

                    }
                 }
           }
        }
     }
  }


//+--------------------------------------------------------------------------------------------------------------+
// ---- Scan Open Trades
int ScanOpenTrades()
  {
   int total = OrdersTotal();
   int numords = 0;

   for(int cnt=0; cnt<=total-1; cnt++)
     {
      if(!OrderSelect(cnt, SELECT_BY_POS))
         continue;
      if(OrderType()<=OP_SELL)
        {
         if(MagicNumber2 > 0)
            if(OrderMagicNumber() == MagicNumber2)
               numords++;
         if(MagicNumber2 == 0)
            numords++;
        }
     }
   return(numords);
  }

// ---- Scan Open Trades
int ScanOpenTradessymbol()
  {
   int total = OrdersTotal();
   int numords = 0;

   for(int cnt=0; cnt<=total-1; cnt++)
     {
      if(!OrderSelect(cnt, SELECT_BY_POS))
         continue;
      if(OrderType()<=OP_SELL)
        {
         if(OrderSymbol() == Symbol() && MagicNumber2 > 0)
            if(OrderMagicNumber() == MagicNumber2)
               numords++;
         if(OrderSymbol() == Symbol() && MagicNumber2 == 0)
            numords++;
        }
     }
   return(numords);
  }

// Closing of Open Orders


void OpenOrdClose()

  {
   int total=OrdersTotal();
   for(int cnt=0; cnt<total; cnt++)
     {
      if(!OrderSelect(cnt, SELECT_BY_POS))
         continue;
      int mode=OrderType();
      bool res = false;
      bool condition = false;
      if(OrderSymbol() == Symbol() && MagicNumber>0 && OrderMagicNumber()==MagicNumber)
         condition = true;
      else
         if(OrderSymbol() == Symbol() && MagicNumber==0)
            condition = true;
      if(condition)
        {

         switch(mode)
           {
            case OP_BUY :
               res = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),Slippage,clrBlue);
               break;
            case OP_BUYLIMIT:
               if(!OrderDelete(OrderTicket()))
                  continue;
               break;
            case OP_BUYSTOP:
               if(!OrderDelete(OrderTicket()))
                  continue;
               break;

           }

         if(!res)
           {
            Print(" OrderClose failed with error #",GetLastError());
            Sleep(3000);
           }
        }
     }
  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrdClose2()
  {
   int total=OrdersTotal();
   for(int cnt=0; cnt<total; cnt++)
     {
      if(!OrderSelect(cnt, SELECT_BY_POS))
         continue;
      int mode=OrderType();
      bool res = false;
      bool condition = false;
      if(OrderSymbol() == Symbol() && MagicNumber>0 && OrderMagicNumber()==MagicNumber)
         condition = true;
      else
         if(OrderSymbol() == Symbol() && MagicNumber==0)
            condition = true;
      if(condition)
        {

         switch(mode)
           {


            case OP_SELL:
               res = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),Slippage,clrRed);
               break;

            case OP_SELLLIMIT:
               if(!OrderDelete(OrderTicket()))
                  continue;
               break;
            case OP_SELLSTOP:
               if(!OrderDelete(OrderTicket()))
                  continue;
               break;

           }

         if(!res)
           {
            Print(" OrderClose failed with error #",GetLastError());
            Sleep(3000);
           }
        }
     }
  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TotalProfitbuy()
  {
   int total=OrdersTotal();
   totalProfits = 0;
   for(int cnt=0; cnt<total; cnt++)
     {
      if(!OrderSelect(cnt, SELECT_BY_POS))
         continue;
      int mode=OrderType();
      bool condition = false;
      if(OrderSymbol() == Symbol() && MagicNumber>0 && OrderMagicNumber()==MagicNumber)
         condition = true;
      else
         if(OrderSymbol() == Symbol() && MagicNumber==0)
            condition = true;
      if(condition)
        {
         switch(mode)
           {
            case OP_BUY:

               totalProfits += OrderProfit() + OrderCommission() + OrderSwap();
               break;

           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TotalProfitsell()
  {
   int total=OrdersTotal();
   totalProfits2 = 0;
   for(int cnt=0; cnt<total; cnt++)
     {
      if(!OrderSelect(cnt, SELECT_BY_POS))
         continue;
      int mode=OrderType();
      bool condition = false;
      if(OrderSymbol() == Symbol() && MagicNumber>0 && OrderMagicNumber()==MagicNumber)
         condition = true;
      else
         if(OrderSymbol() == Symbol() && MagicNumber==0)
            condition = true;
      if(condition)
        {
         switch(mode)
           {
            case OP_SELL:

               totalProfits2 += OrderProfit() + OrderCommission() + OrderSwap();
               break;
           }
        }
     }
  }







//+--------------------------------------------------------------------------------------------------------------+
//=============================
double FindLastBuyPrice_Hilo()
  {
   double oldorderopenprice_Hilo;
   int oldticketnumber_Hilo;
   double unused_Hilo = 0;
   int ticketnumber_Hilo = 0;
   for(cnt_Hilo = OrdersTotal() - 1; cnt_Hilo >= 0; cnt_Hilo--)
     {
      if(!OrderSelect(cnt_Hilo, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY)
        {
         oldticketnumber_Hilo = OrderTicket();
         if(oldticketnumber_Hilo > ticketnumber_Hilo)
           {
            oldorderopenprice_Hilo = OrderOpenPrice();
            unused_Hilo = oldorderopenprice_Hilo;
            ticketnumber_Hilo = oldticketnumber_Hilo;
           }
        }
     }
   return (oldorderopenprice_Hilo);
  }

//=============================
double FindLastSellPrice_Hilo()
  {
   double oldorderopenprice_Hilo;
   int oldticketnumber_Hilo;
   double unused_Hilo = 0;
   int ticketnumber_Hilo = 0;
   for(cnt_Hilo = OrdersTotal() - 1; cnt_Hilo >= 0; cnt_Hilo--)
     {
      if(!OrderSelect(cnt_Hilo, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL)
        {
         oldticketnumber_Hilo = OrderTicket();
         if(oldticketnumber_Hilo > ticketnumber_Hilo)
           {
            oldorderopenprice_Hilo = OrderOpenPrice();
            unused_Hilo = oldorderopenprice_Hilo;
            ticketnumber_Hilo = oldticketnumber_Hilo;
           }
        }
     }
   return (oldorderopenprice_Hilo);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountTradesSell()
  {
   int count_Hilo = 0;
   for(int trade_Hilo = OrdersTotal() - 1; trade_Hilo >= 0; trade_Hilo--)
     {
      if(!OrderSelect(trade_Hilo, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if(OrderType() == OP_SELL)
            count_Hilo++;
     }
   return (count_Hilo);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountTradesBuy()
  {
   int count_Hilo = 0;
   for(int trade_Hilo = OrdersTotal() - 1; trade_Hilo >= 0; trade_Hilo--)
     {
      if(!OrderSelect(trade_Hilo, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if(OrderType() == OP_BUY)
            count_Hilo++;
     }
   return (count_Hilo);
  }


//=============================
double startBalanceD1()
  {
   double vProfit=0;
   int HisCountTmp = OrdersHistoryTotal();
   datetime nTime=iTime(NULL,PERIOD_D1,0);
   for(int cnt = HisCountTmp; cnt >=0; cnt--)
     {
      if(!OrderSelect(cnt, SELECT_BY_POS, MODE_HISTORY))
         continue;
      if(OrderCloseTime()>= nTime)
        {
         vProfit+=OrderProfit()+OrderCommission()+OrderSwap();
        }
     }
   double stBalance=NormalizeDouble(AccountBalance()-vProfit,2);
   return (stBalance);
  }



double TP;
double TPbuy;
double TPsell;
double SLbuy;
double SLsell;
double open0;
double close0;
double close1;
double close2;
double rsia;
double rsib;
double ma;
string sign;
string sign2;
string sign3;
string status1;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteAllObjects()
  {
   int objs = ObjectsTotal();
   string name;
   for(int cnt=ObjectsTotal()-1; cnt>=0; cnt--)
     {
      if(HighToLow)
        {
         name=ObjectName(cnt);
         if(StringFind(name,"v_u_hl",0)>-1)
            ObjectDelete(name);
         if(StringFind(name,"v_l_hl",0)>-1)
            ObjectDelete(name);
         if(StringFind(name,"Fibo_hl",0)>-1)
            ObjectDelete(name);
         if(StringFind(name,"trend_hl",0)>-1)
            ObjectDelete(name);
         WindowRedraw();
        }
      else
        {
         name=ObjectName(cnt);
         if(StringFind(name,"v_u_lh",0)>-1)
            ObjectDelete(name);
         if(StringFind(name,"v_l_lh",0)>-1)
            ObjectDelete(name);
         if(StringFind(name,"Fibo_lh",0)>-1)
            ObjectDelete(name);
         if(StringFind(name,"trend_lh",0)>-1)
            ObjectDelete(name);
         WindowRedraw();
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalcFibo()
  {

//DeleteAllObjects();

   int LowBar = 0, HighBar= 0;
   double LowValue = 0,HighValue = 0;

   int lowest_bar = iLowest(NULL,0,MODE_LOW,斐波那契取值结束K线,斐波那契取值开始K线);
   int highest_bar = iHighest(NULL,0,MODE_HIGH,斐波那契取值结束K线,斐波那契取值开始K线);

   double higher_point = 0;
   double lower_point = 0;
   HighValue=High[highest_bar];
   LowValue=Low[lowest_bar];

   if(HighToLow)
     {
      DrawVerticalLine("v_u_hl",highest_bar,VerticalLinesColor);
      DrawVerticalLine("v_l_hl",lowest_bar,VerticalLinesColor);

      if(ObjectFind("trend_hl")==-1)
         ObjectCreate("trend_hl",OBJ_TREND,0,Time[highest_bar],HighValue,Time[lowest_bar],LowValue);
      ObjectSet("trend_hl",OBJPROP_TIME1,Time[highest_bar]);
      ObjectSet("trend_hl",OBJPROP_TIME2,Time[lowest_bar]);
      ObjectSet("trend_hl",OBJPROP_PRICE1,HighValue);
      ObjectSet("trend_hl",OBJPROP_PRICE2,LowValue);
      ObjectSet("trend_hl",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("trend_hl",OBJPROP_RAY,false);

      if(ObjectFind("Fibo_hl")==-1)
         ObjectCreate("Fibo_hl",OBJ_FIBO,0,0,HighValue,0,LowValue);
      ObjectSet("Fibo_hl",OBJPROP_PRICE1,HighValue);
      ObjectSet("Fibo_hl",OBJPROP_PRICE2,LowValue);
      ObjectSet("Fibo_hl",OBJPROP_LEVELCOLOR,FiboLinesColors);
      ObjectSet("Fibo_hl",OBJPROP_FIBOLEVELS,8);
      ObjectSet("Fibo_hl",OBJPROP_FIRSTLEVEL+0,Fibo_Level_0);
      ObjectSetFiboDescription("Fibo_hl",0,"SWING LOW (0.0) - %$");
      ObjectSet("Fibo_hl",OBJPROP_FIRSTLEVEL+1,Fibo_Level_1);
      ObjectSetFiboDescription("Fibo_hl",1,"BREAKOUT AREA (23.6) -  %$");
      ObjectSet("Fibo_hl",OBJPROP_FIRSTLEVEL+2,Fibo_Level_2);
      ObjectSetFiboDescription("Fibo_hl",2,"CRITICAL AREA (38.2) -  %$");
      ObjectSet("Fibo_hl",OBJPROP_FIRSTLEVEL+3,Fibo_Level_3);
      ObjectSetFiboDescription("Fibo_hl",3,"CRITICAL AREA (50.0) -  %$");
      ObjectSet("Fibo_hl",OBJPROP_FIRSTLEVEL+4,Fibo_Level_4);
      ObjectSetFiboDescription("Fibo_hl",4,"CRITICAL AREA (61.8) -  %$");
      ObjectSet("Fibo_hl",OBJPROP_FIRSTLEVEL+5,Fibo_Level_5);
      ObjectSetFiboDescription("Fibo_hl",5,"BREAKOUT AREA (76.4) -  %$");
      ObjectSet("Fibo_hl",OBJPROP_FIRSTLEVEL+7,Fibo_Level_6);
      ObjectSetFiboDescription("Fibo_hl",7,"SWING HIGH (100.0) - %$");
      ObjectSet("Fibo_hl",OBJPROP_RAY,true);
      WindowRedraw();


      for(int i=0; i<100; i++)
        {
         f_7[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_6,Digits);
         f_6[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_5,Digits);
         f_5[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_4,Digits);
         f_4[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_3,Digits);
         f_3[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_2,Digits);
         f_2[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_1,Digits);
         f_1[i] = NormalizeDouble(LowValue+(HighValue-LowValue)*Fibo_Level_0,Digits);
        }
     }
   else
     {
      DrawVerticalLine("v_u_lh",highest_bar,VerticalLinesColor);
      DrawVerticalLine("v_l_lh",lowest_bar,VerticalLinesColor);

      if(ObjectFind("trend_hl")==-1)
         ObjectCreate("trend_lh",OBJ_TREND,0,Time[lowest_bar],LowValue,Time[highest_bar],HighValue);
      ObjectSet("trend_lh",OBJPROP_TIME1,Time[lowest_bar]);
      ObjectSet("trend_lh",OBJPROP_TIME2,Time[highest_bar]);
      ObjectSet("trend_lh",OBJPROP_PRICE1,LowValue);
      ObjectSet("trend_lh",OBJPROP_PRICE2,HighValue);
      ObjectSet("trend_lh",OBJPROP_STYLE,STYLE_DOT);
      ObjectSet("trend_lh",OBJPROP_RAY,false);


      if(ObjectFind("Fibo_lh")==-1)
         ObjectCreate("Fibo_lh",OBJ_FIBO,0,0,LowValue,0,HighValue);
      ObjectSet("Fibo_lh",OBJPROP_PRICE1,LowValue);
      ObjectSet("Fibo_lh",OBJPROP_PRICE2,HighValue);
      ObjectSet("Fibo_lh",OBJPROP_LEVELCOLOR,FiboLinesColors);
      ObjectSet("Fibo_lh",OBJPROP_FIBOLEVELS,8);
      ObjectSet("Fibo_lh",OBJPROP_FIRSTLEVEL+0,Fibo_Level_0);
      ObjectSetFiboDescription("Fibo_lh",0,"SWING LOW (0.0) - %$");
      ObjectSet("Fibo_lh",OBJPROP_FIRSTLEVEL+1,Fibo_Level_1);
      ObjectSetFiboDescription("Fibo_lh",1,"BREAKOUT AREA (23.6) -  %$");
      ObjectSet("Fibo_lh",OBJPROP_FIRSTLEVEL+2,Fibo_Level_2);
      ObjectSetFiboDescription("Fibo_lh",2,"CRITICAL AREA (38.2) -  %$");
      ObjectSet("Fibo_lh",OBJPROP_FIRSTLEVEL+3,Fibo_Level_3);
      ObjectSetFiboDescription("Fibo_lh",3,"CRITICAL AREA (50.0) -  %$");
      ObjectSet("Fibo_lh",OBJPROP_FIRSTLEVEL+4,Fibo_Level_4);
      ObjectSetFiboDescription("Fibo_lh",4,"CRITICAL AREA (61.8) -  %$");
      ObjectSet("Fibo_lh",OBJPROP_FIRSTLEVEL+5,Fibo_Level_5);
      ObjectSetFiboDescription("Fibo_lh",5,"BREAKOUT AREA (76.4) -  %$");
      ObjectSet("Fibo_lh",OBJPROP_FIRSTLEVEL+7,Fibo_Level_6);
      ObjectSetFiboDescription("Fibo_lh",7,"SWING HIGH (100.0) - %$");
      ObjectSet("Fibo_lh",OBJPROP_RAY,true);
      WindowRedraw();

      for(i=0; i<100; i++)
        {
         f_1[i] = NormalizeDouble(HighValue,4);
         f_2[i] = NormalizeDouble(HighValue-((HighValue-LowValue)*Fibo_Level_1),Digits);
         f_3[i] = NormalizeDouble(HighValue-((HighValue-LowValue)*Fibo_Level_2),Digits);
         f_4[i] = NormalizeDouble(HighValue-((HighValue-LowValue)*Fibo_Level_3),Digits);
         f_5[i] = NormalizeDouble(HighValue-((HighValue-LowValue)*Fibo_Level_4),Digits);
         f_6[i] = NormalizeDouble(HighValue-((HighValue-LowValue)*Fibo_Level_5),Digits);
         f_7[i] = NormalizeDouble(LowValue,4);
        }

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawVerticalLine(string name, int bar, color clr)
  {
   if(ObjectFind(name)==-1)
     {
      ObjectCreate(name,OBJ_VLINE,0,Time[bar],0);
      ObjectSet(name,OBJPROP_COLOR,clr);
      ObjectSet(name,OBJPROP_STYLE,STYLE_DASH);
      ObjectSet(name,OBJPROP_WIDTH,1);
      WindowRedraw();
     }
   else
     {
      ObjectDelete(name);
      ObjectCreate(name,OBJ_VLINE,0,Time[bar],0);
      ObjectSet(name,OBJPROP_COLOR,clr);
      ObjectSet(name,OBJPROP_STYLE,STYLE_DASH);
      ObjectSet(name,OBJPROP_WIDTH,1);
      WindowRedraw();
     }

  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void VirtualTrailing()
  {

   double total = CountTradesBuy();
   double AveragePrice = 0;
   double Count = 0;
   for(int cnt2 = OrdersTotal() - 1; cnt2 >= 0; cnt2--)
     {
      if(!OrderSelect(cnt2, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_BUY)
           {
            AveragePrice += OrderOpenPrice() * OrderLots();
            Count += OrderLots();
           }
        }
     }


   double total2 = CountTradesSell();
   double AveragePrice2 = 0;
   double Count2 = 0;
   for(int cnt22 = OrdersTotal() - 1; cnt22 >= 0; cnt22--)
     {
      if(!OrderSelect(cnt22, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber)
         continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         if(OrderType() == OP_SELL)
           {
            AveragePrice2 += OrderOpenPrice() * OrderLots();
            Count2 += OrderLots();
           }
        }
     }




   double OOP,SLB,SLS;
   int b=0,s=0,tip,TicketB=0,TicketS=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol()&& OrderMagicNumber()==MagicNumber)
           {
            tip = OrderType();
            OOP = NormalizeDouble(OrderOpenPrice(),Digits);

            if(tip==OP_BUY)
              {
               b++;
               TicketB=OrderTicket();
               if(可视化止损开关==True && 止损点数!=0   && Ask<=OOP - 止损点数   * Point)
                 {
                  if(OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),Slippage,clrNONE))
                     continue;
                 }
               if(可视化止盈开关==True && 止盈点数!=0 && Ask>=OOP + 止盈点数 * Point)
                 {
                  if(OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),Slippage,clrNONE))
                     continue;
                 }
               if(可视化移动止盈点数>0)
                 {
                  SLB=NormalizeDouble(Ask-可视化移动止盈点数*Point,Digits);
                  //if(SLB>=NormalizeDouble(AveragePrice/Count,Digits))
                  if(NormalizeDouble(Ask-可视化移动止盈点数*Point,Digits)>NormalizeDouble((AveragePrice/Count)+可视化开始移动止盈点数*Point,Digits))
                     if(SLB>=OOP+可视化开始移动止盈点数*Point && (TrallB==0 || TrallB+可视化移动止盈步长*Point<SLB))
                        TrallB=SLB;
                 }
              }
            if(tip==OP_SELL)
              {
               s++;
               if(可视化止损开关==True && 止损点数!=0   && Bid>=OOP + 止损点数   * Point)
                 {
                  if(OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),Slippage,clrNONE))
                     continue;
                 }
               if(可视化止盈开关==True && 止盈点数!=0 && Bid<=OOP - 止盈点数 * Point)
                 {
                  if(OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),Slippage,clrNONE))
                     continue;
                 }
               TicketS=OrderTicket();
               if(可视化移动止盈点数>0)
                 {
                  SLS=NormalizeDouble(Bid+可视化移动止盈点数*Point,Digits);
                  //if(SLS<=NormalizeDouble(AveragePrice2/Count2,Digits))
                  if(NormalizeDouble(Bid+可视化移动止盈点数*Point,Digits)<NormalizeDouble((AveragePrice2/Count2)-可视化开始移动止盈点数*Point,Digits))
                     if(SLS<=OOP-可视化开始移动止盈点数*Point && (TrallS==0 || TrallS-可视化移动止盈步长*Point>SLS))
                        TrallS=SLS;
                 }
              }
           }
        }
     }
   if(b!=0)
     {

      if(TrallB!=0)
        {

         DrawHline("SL Buy",TrallB,clrYellow,1);
         if(Bid<=TrallB)
           {
            if(OrderSelect(TicketB,SELECT_BY_TICKET))
               if(OrderProfit()>0)
                  if(!OrderClose(TicketB,OrderLots(),NormalizeDouble(Ask,Digits),Slippage,clrYellow))
                     Comment("Virtual Trailing Buy",GetLastError());
           }
        }
     }
   else
     {
      TrallB=0;
      ObjectDelete("SL Buy");
     }
//---
   if(s!=0)
     {

      if(TrallS!=0)
        {

         DrawHline("SL Sell",TrallS,clrYellow,1);
         if(Ask>=TrallS)
           {
            if(OrderSelect(TicketS,SELECT_BY_TICKET))
               if(OrderProfit()>0)
                  if(!OrderClose(TicketS,OrderLots(),NormalizeDouble(Ask,Digits),Slippage,clrYellow))
                     Comment("Virtual Trailing Sell",GetLastError());
           }
        }
     }
   else
     {
      TrallS=0;
      ObjectDelete("SL Sell");
     }

   return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawHline(string name,double P,color clr,int WIDTH)
  {
   if(ObjectFind(name)!=-1)
      ObjectDelete(name);
   ObjectCreate(name,OBJ_HLINE,0,0,P,0,0,0,0);
   ObjectSet(name,OBJPROP_COLOR,clr);
   ObjectSet(name,OBJPROP_STYLE,2);
   ObjectSet(name,OBJPROP_WIDTH,WIDTH);
  }
//+------------------------------------------------------------------+
//+--------------------------------------------------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ChartComment()
  {
   ObjectCreate("Background",OBJ_LABEL,0,0,0);
   ObjectSetText("Background","g",160,"Webdings",Backgroundcolor);
   ObjectSet("Background",OBJPROP_CORNER,Side);
   ObjectSet("Background",OBJPROP_XDISTANCE,0);
   ObjectSet("Background",OBJPROP_YDISTANCE,Size1);

   ObjectCreate("Background_2",OBJ_LABEL,0,0,0);
   ObjectSetText("Background_2","g",160,"Webdings",Backgroundcolor2);
   ObjectSet("Background_2",OBJPROP_CORNER,Side);
   ObjectSet("Background_2",OBJPROP_XDISTANCE,0);
   ObjectSet("Background_2",OBJPROP_YDISTANCE,Size2);

   ObjectCreate("Background_3",OBJ_LABEL,0,0,0);
   ObjectSetText("Background_3","g",160,"Webdings",Backgroundcolor3);
   ObjectSet("Background_3",OBJPROP_CORNER,Side);
   ObjectSet("Background_3",OBJPROP_XDISTANCE,0);
   ObjectSet("Background_3",OBJPROP_YDISTANCE,Size3);

   ObjectCreate("Background_4",OBJ_LABEL,0,0,0);
   ObjectSetText("Background_4","g",160,"Webdings",Backgroundcolor4);
   ObjectSet("Background_4",OBJPROP_CORNER,Side);
   ObjectSet("Background_4",OBJPROP_XDISTANCE,0);
   ObjectSet("Background_4",OBJPROP_YDISTANCE,Size4);


   ObjectCreate("Background_5",OBJ_LABEL,0,0,0);
   ObjectSetText("Background_5","g",160,"Webdings",Backgroundcolor5);
   ObjectSet("Background_5",OBJPROP_CORNER,Side);
   ObjectSet("Background_5",OBJPROP_XDISTANCE,0);
   ObjectSet("Background_5",OBJPROP_YDISTANCE,Size5);

   ObjectCreate("Info_1",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_1","Expert Advisor Robofibo v.11",10,"Tahoma",Textcolor);
   ObjectSet("Info_1",OBJPROP_CORNER,Side);
   ObjectSet("Info_1",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_1",OBJPROP_YDISTANCE,20);



   ObjectCreate("Info_2",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_2","Name = "+AccountName(),10,"Tahoma",Textcolor);
   ObjectSet("Info_2",OBJPROP_CORNER,Side);
   ObjectSet("Info_2",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_2",OBJPROP_YDISTANCE,45);

   ObjectCreate("Info_3",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_3","Broker =  "+AccountCompany(),10,"Tahoma",Textcolor);
   ObjectSet("Info_3",OBJPROP_CORNER,Side);
   ObjectSet("Info_3",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_3",OBJPROP_YDISTANCE,60);

   ObjectCreate("Info_4",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_4","Account Balance = "+DoubleToStr(AccountBalance(),2),10,"Tahoma",Textcolor);
   ObjectSet("Info_4",OBJPROP_CORNER,Side);
   ObjectSet("Info_4",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_4",OBJPROP_YDISTANCE,75);

   ObjectCreate("Info_5",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_5","Account Equity = "+DoubleToStr(AccountEquity(),2),10,"Tahoma",Textcolor);
   ObjectSet("Info_5",OBJPROP_CORNER,Side);
   ObjectSet("Info_5",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_5",OBJPROP_YDISTANCE,90);

   ObjectCreate("Info_6",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_6","Day Profit = "+DoubleToStr(AccountBalance()-startBalanceD1(),2),10,"Tahoma",Textcolor);
   ObjectSet("Info_6",OBJPROP_CORNER,Side);
   ObjectSet("Info_6",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_6",OBJPROP_YDISTANCE,105);



   ObjectCreate("Info_7",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_7","Open ALL Positions = "+ ScanOpenTrades(),10,"Tahoma",Textcolor);
   ObjectSet("Info_7",OBJPROP_CORNER,Side);
   ObjectSet("Info_7",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_7",OBJPROP_YDISTANCE,130);

   ObjectCreate("Info_8",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_8",Symbol()+" ALL Order = "+ ScanOpenTradessymbol(),10,"Tahoma",Textcolor);
   ObjectSet("Info_8",OBJPROP_CORNER,Side);
   ObjectSet("Info_8",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_8",OBJPROP_YDISTANCE,145);

   ObjectCreate("Info_9",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_9","Open Buy  = "+ CountTradesBuy(),10,"Tahoma",Textcolor);
   ObjectSet("Info_9",OBJPROP_CORNER,Side);
   ObjectSet("Info_9",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_9",OBJPROP_YDISTANCE,160);

   ObjectCreate("Info_10",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_10","Open Sell = "+ CountTradesSell(),10,"Tahoma",Textcolor);
   ObjectSet("Info_10",OBJPROP_CORNER,Side);
   ObjectSet("Info_10",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_10",OBJPROP_YDISTANCE,175);


   ObjectCreate("Info_11",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_11","Signal  = "+ sign,10,"Tahoma",Textcolor);
   ObjectSet("Info_11",OBJPROP_CORNER,Side);
   ObjectSet("Info_11",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_11",OBJPROP_YDISTANCE,200);


   ObjectCreate("Info_12",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_12","RSI = "+ sign2,10,"Tahoma",Textcolor);
   ObjectSet("Info_12",OBJPROP_CORNER,Side);
   ObjectSet("Info_12",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_12",OBJPROP_YDISTANCE,215);


   ObjectCreate("Info_13",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_13","Trend = "+  sign3,10,"Tahoma",Textcolor);
   ObjectSet("Info_13",OBJPROP_CORNER,Side);
   ObjectSet("Info_13",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_13",OBJPROP_YDISTANCE,230);


   ObjectCreate("Info_14",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_14",date0,10,"Tahoma",Textcolor);
   ObjectSet("Info_14",OBJPROP_CORNER,Side);
   ObjectSet("Info_14",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_14",OBJPROP_YDISTANCE,255);


   ObjectCreate("Info_15",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_15",title0+" "+country0,10,"Tahoma",Textcolor);
   ObjectSet("Info_15",OBJPROP_CORNER,Side);
   ObjectSet("Info_15",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_15",OBJPROP_YDISTANCE,270);


   ObjectCreate("Info_16",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_16",prevnews+" Minutes ago",10,"Tahoma",Textcolor);
   ObjectSet("Info_16",OBJPROP_CORNER,Side);
   ObjectSet("Info_16",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_16",OBJPROP_YDISTANCE,285);


   ObjectCreate("Info_17",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_17",datex,10,"Tahoma",Textcolor);
   ObjectSet("Info_17",OBJPROP_CORNER,Side);
   ObjectSet("Info_17",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_17",OBJPROP_YDISTANCE,310);


   ObjectCreate("Info_18",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_18",titlex+" "+countryx,10,"Tahoma",Textcolor);
   ObjectSet("Info_18",OBJPROP_CORNER,Side);
   ObjectSet("Info_18",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_18",OBJPROP_YDISTANCE,325);


   ObjectCreate("Info_19",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_19","In "+nextnews+" Minutes",10,"Tahoma",Textcolor);
   ObjectSet("Info_19",OBJPROP_CORNER,Side);
   ObjectSet("Info_19",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_19",OBJPROP_YDISTANCE,340);


   ObjectCreate("Info_20",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_20",status1,10,"Tahoma",Textcolor);
   ObjectSet("Info_20",OBJPROP_CORNER,Side);
   ObjectSet("Info_20",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_20",OBJPROP_YDISTANCE,365);



   ObjectCreate("Info_21",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_21","Buy Profit(USD) = "+  DoubleToStr(totalProfits,2),10,"Tahoma",Textcolor);
   ObjectSet("Info_21",OBJPROP_CORNER,Side);
   ObjectSet("Info_21",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_21",OBJPROP_YDISTANCE,390);


   ObjectCreate("Info_22",OBJ_LABEL,0,0,0);
   ObjectSetText("Info_22","Sell Profit(USD) = "+  DoubleToStr(totalProfits2,2),10,"Tahoma",Textcolor);
   ObjectSet("Info_22",OBJPROP_CORNER,Side);
   ObjectSet("Info_22",OBJPROP_XDISTANCE,10);
   ObjectSet("Info_22",OBJPROP_YDISTANCE,405);





  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void news()
  {



   if(barw1!=iTime(NULL,10080,0))
     {

      s1=StringSubstr(Symbol(),0,3);
      s2=StringSubstr(Symbol(),3,3);

      news=geturl("http://www.forexfactory.com/ffcal_week_this.xml"+"?"+TimeToString(iTime(NULL,1,0),0));

      bufferlen=StringBufferLen(news);

      h=0;
      for(n=0; n<=bufferlen; n++)
        {
         if(StringFind(news,"<country>",n)!=-1)
           {
            country1[h]=StringFind(news,"<country>",n);
            h++;
            n=StringFind(news,"<country>",n)+1;
           }
        }
      h=0;
      for(n=0; n<=bufferlen; n++)
        {
         if(StringFind(news,"</country>",n)!=-1)
           {
            country2[h]=StringFind(news,"</country>",n);
            h++;
            n=StringFind(news,"</country>",n)+1;
           }
        }
      for(n=0; n<=150; n++)
        {
         country[n]=StringSubstr(news,country1[n]+9,country2[n]-(country1[n]+9));
        }

      h=0;
      for(n=0; n<=bufferlen; n++)
        {
         if(StringFind(news,"<title>",n)!=-1)
           {
            title1[h]=StringFind(news,"<title>",n);
            h++;
            n=StringFind(news,"<title>",n)+1;
           }
        }
      h=0;
      for(n=0; n<=bufferlen; n++)
        {
         if(StringFind(news,"</title>",n)!=-1)
           {
            title2[h]=StringFind(news,"</title>",n);
            h++;
            n=StringFind(news,"</title>",n)+1;
           }
        }
      for(n=0; n<=150; n++)
        {
         title[n]=StringSubstr(news,title1[n]+7,title2[n]-(title1[n]+7));
        }

      h=0;
      for(n=0; n<=bufferlen; n++)
        {
         if(StringFind(news,"<date>",n)!=-1)
           {
            date1[h]=StringFind(news,"<date>",n);
            h++;
            n=StringFind(news,"<date>",n)+1;
           }
        }
      h=0;
      for(n=0; n<=bufferlen; n++)
        {
         if(StringFind(news,"</date>",n)!=-1)
           {
            date2[h]=StringFind(news,"</date>",n);
            h++;
            n=StringFind(news,"</date>",n)+1;
           }
        }
      for(n=0; n<=150; n++)
        {
         date[n]=StringSubstr(news,date1[n]+15,date2[n]-(date1[n]+18));
        }
      for(n=0; n<=150; n++)
        {
         dateread[n]=StringSubstr(date[n],0,10);
        }
      for(n=0; n<=150; n++)
        {
         dateday[n]=StringSubstr(dateread[n],3,2);
         if(StringSubstr(dateday[n],0,1)=="0")
            dateday[n]=StringSubstr(dateday[n],1,1);
        }
      for(n=0; n<=150; n++)
        {
         datemonth[n]=StringSubstr(dateread[n],0,2);
         if(StringSubstr(datemonth[n],0,1)=="0")
            datemonth[n]=StringSubstr(datemonth[n],1,1);
        }
      for(n=0; n<=150; n++)
        {
         dateyear[n]=StringSubstr(dateread[n],6,4);
        }

      h=0;
      for(n=0; n<=bufferlen; n++)
        {
         if(StringFind(news,"<time>",n)!=-1)
           {
            time1[h]=StringFind(news,"<time>",n);
            h++;
            n=StringFind(news,"<time>",n)+1;
           }
        }
      h=0;
      for(n=0; n<=bufferlen; n++)
        {
         if(StringFind(news,"</time>",n)!=-1)
           {
            time2[h]=StringFind(news,"</time>",n);
            h++;
            n=StringFind(news,"</time>",n)+1;
           }
        }
      for(n=0; n<=150; n++)
        {
         time[n]=StringSubstr(news,time1[n]+15,time2[n]-(time1[n]+18));
        }
      for(n=0; n<=150; n++)
         time3[n]=StringFind(time[n],":",0);
      for(n=0; n<=150; n++)
        {
         if(time3[n]==1)
            timeap[n]=StringSubstr(time[n],4,2);
         else
            timeap[n]=StringSubstr(time[n],5,2);
        }
      for(n=0; n<=150; n++)
        {
         if(time3[n]==1)
            timeread[n]=StringSubstr(time[n],0,4);
         else
            timeread[n]=StringSubstr(time[n],0,5);
        }
      for(n=0; n<=150; n++)
        {
         if(time3[n]==1)
           {
            if(timeap[n]=="am")
              {
               hour1[n]=StringSubstr(timeread[n],0,1);
               if(hour1[n]=="1")
                  hour1[n]="01";
               if(hour1[n]=="2")
                  hour1[n]="02";
               if(hour1[n]=="3")
                  hour1[n]="03";
               if(hour1[n]=="4")
                  hour1[n]="04";
               if(hour1[n]=="5")
                  hour1[n]="05";
               if(hour1[n]=="6")
                  hour1[n]="06";
               if(hour1[n]=="7")
                  hour1[n]="07";
               if(hour1[n]=="8")
                  hour1[n]="08";
               if(hour1[n]=="9")
                  hour1[n]="09";
               hour2[n]=StringSubstr(timeread[n],2,2);
               hour[n]=hour1[n]+":"+hour2[n];
              }
            if(timeap[n]=="pm")
              {
               hour1[n]=StringSubstr(timeread[n],0,1);
               if(hour1[n]=="1")
                  hour1[n]="13";
               if(hour1[n]=="2")
                  hour1[n]="14";
               if(hour1[n]=="3")
                  hour1[n]="15";
               if(hour1[n]=="4")
                  hour1[n]="16";
               if(hour1[n]=="5")
                  hour1[n]="17";
               if(hour1[n]=="6")
                  hour1[n]="18";
               if(hour1[n]=="7")
                  hour1[n]="19";
               if(hour1[n]=="8")
                  hour1[n]="20";
               if(hour1[n]=="9")
                  hour1[n]="21";
               hour2[n]=StringSubstr(timeread[n],2,2);
               hour[n]=hour1[n]+":"+hour2[n];
              }
           }
         else
           {
            if(timeap[n]=="am")
              {
               hour1[n]=StringSubstr(timeread[n],0,2);
               if(hour1[n]=="12")
                  hour1[n]="00";
               hour2[n]=StringSubstr(timeread[n],3,2);
               hour[n]=hour1[n]+":"+hour2[n];
              }
            if(timeap[n]=="pm")
              {
               hour1[n]=StringSubstr(timeread[n],0,2);
               if(hour1[n]=="10")
                  hour1[n]="22";
               if(hour1[n]=="11")
                  hour1[n]="23";
               hour2[n]=StringSubstr(timeread[n],3,2);
               hour[n]=hour1[n]+":"+hour2[n];
              }
           }
        }

      for(n=0; n<=150; n++)
         datefinal[n]=StrToTime(dateyear[n]+"."+datemonth[n]+"."+dateday[n]+" "+hour[n]);

      for(n=0; n<=150; n++)
        {
         impactz[n]=StringSubstr(news,time2[n]+27,6);
        }
      for(n=0; n<=150; n++)
        {
         if(impactz[n]=="Low]]>")
            impactfinal[n]=1;
         if(impactz[n]=="Medium")
            impactfinal[n]=2;
         if(impactz[n]=="High]]")
            impactfinal[n]=3;
        }


     }
  }
//+------------------------------------------------------------------+
