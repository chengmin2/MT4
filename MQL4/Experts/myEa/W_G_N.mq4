//+------------------------------------------------------------------+
//|                                                         test.mq4 |
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
extern double profit=0.6;//出仓利润
input int magic=612973;//魔术号
input double volume=0.01;//初始手数
input int points=100;//挂单点位
input int ZS_P_S= 200;//移动止损点位
input int ZS_P_E =100;//移动止损点数
input double JC_Volume = 0.01;//加仓层数
input int  JC_POIT = 20;//挂单加仓因子
input int C_CW_2 = 1000;//止损点
input int D_S = 30;//定时器
input int centre = 200;//中间点
input int Y_J = -1000;//预警线
input double accountType=0.01;//账户类型（美元:0.01;美角:0.1;美分:1）
string S_C = "Matrix_G_D_S";//锁仓标识
string mark = "Matrix_G_D";//标识
string S_C_2 = "Matrix_G_D_S_2";//锁仓标识
extern int no_M=0;//普通锁变量标识
int s = 0;//自动解锁标识
bool isF_B=true;//是否第一次买单
bool isF_S=true;//是否第一次卖单
datetime time=0;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
double nFk;
double maxFk;
double price_a;//价格变量
double price_b;//价格变量
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   anNiu("suoCang",30,80,"锁仓(移动止盈线)",130,30);
   anNiu("jieSuo",170,80,"解锁(移)",100,30);
   anNiu("suoCang_2",30,120,"锁仓(止盈线不变)",130,30);
   anNiu("jieSuo_2",170,120,"解锁(不移)",100,30);
   createLabel();
   price_a=Ask;
   price_b=Bid;
   EventSetTimer(D_S);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);
   if(s==0 && no_M==0)
     {
      close();
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(time!=Time[0])
     {
      if(no_M==1)
        {
         if(jy.isLocked(Symbol(),magic,S_C_2))
           {
            return;
           }
         no_M=0;
        }

      if(jy.isLocked(Symbol(),magic,S_C))
        {
         s=1;   //锁仓不做处理；
         return;
        }
      if(s==1)
        {
         Alert("自动解锁成功！");
         int totals = OrdersHistoryTotal();
         for(int i=totals-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS, MODE_HISTORY))
              {
               if(OrderSymbol()==Symbol() && magic==OrderMagicNumber() && S_C ==OrderComment())
                 {
                  double proit_h = OrderProfit()+OrderSwap()+OrderCommission();
                  int orderType;
                  if(OrderType()==OP_BUY)
                     orderType=OP_SELL;
                  if(OrderType()==OP_SELL)
                     orderType=OP_BUY;

                  if(!jy.stopProfit(OrderSymbol(),profit*2-proit_h,magic,orderType))
                    {
                     Alert("移动止损失败！");
                     Print("OrderSend failed with error #",GetLastError());
                    }
                  break;
                 }
              }
           }
         SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"币种："+Symbol()+"自动解锁成功！");
         s=0;
        }
      if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
        {
         if(price_b-Bid>=points*Point())
           {
            OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic);
            price_b = Bid;
            price_a = Ask;
           }
         if(Ask-price_a>=points*Point())
           {
            OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic);
            price_a = Ask;
            price_b = Bid;
           }

        }
      if(Ask-price_a>=points*Point() && isF_B)
        {
         //if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL)==0 && haveOrderUS(OP_BUY)) return;
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic);
         price_a = Ask;
         price_b = Bid;
         isF_B = false;
        }
      if(price_b-Bid>=points*Point() && isF_S)
        {
         //if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)==0 && haveOrderUS(OP_SELL)) return;

         OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic);
         price_b = Bid;
         price_a = Ask;
         isF_S = false;
        }
      int total=OrdersTotal();
      for(int i=total-1; i>=0; i--)//加仓
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
              {
               if(OrderType()==OP_BUY)
                 {
                  if(Ask-OrderOpenPrice()>Point()*(points+JC_POIT))
                    {
                     if(OrderSend(OrderSymbol(),OP_BUY,OrderLots()+JC_Volume,Ask,3,0,0,mark,magic)<0)
                       {
                        Print("OrderSend OP_BUY 加仓失败",GetLastError());
                       }

                    }
                 }
               if(OrderType()==OP_SELL)
                 {
                  if(OrderOpenPrice()-Bid>Point()*(points+JC_POIT))
                    {
                     if(OrderSend(OrderSymbol(),OP_SELL,OrderLots()+JC_Volume,Bid,3,0,0,mark,magic)<0)
                       {
                        Print("OrderSend OP_SELL 加仓失败",GetLastError());
                       }

                    }
                 }
               break;
              }
           }
        }

      fuKui();
      close();
      cent();
      if(jy.profitBySymbolTotal(Symbol(),magic)<Y_J)
        {

         SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+" 预警");
        }
      time=Time[0];
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void label(string name,int x,int y,string text)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSetText(name,text,20,"Arial",clrRed);
   ObjectSet(name,OBJPROP_CORNER,0);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void fuKui()
  {
   nFk=AccountProfit();
   if(maxFk>nFk)
     {
      maxFk=nFk;
     }
   ObjectSetText("Max_FuKui",maxFk,20,"Arial",clrRed);
   ObjectSetText("N_FuKui",nFk,20,"Arial",clrRed);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void createLabel()
  {
   label("最大浮亏",20,20,"最大浮亏:");
   label("Max_FuKui",140,20,"0");
   label("当前浮亏",500,20,"当前浮亏:");
   label("N_FuKui",620,20,"0");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {

   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>profit)
     {

      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY)==0)
        {
         Alert("盈利出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      price_a = Ask;
      price_b= Bid;
      isF_B=true;
      isF_S=true;
     }

   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
        {
         Alert("盈利出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }

      price_a = Ask;
      price_b= Bid;
      isF_B=true;
      isF_S=true;
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  cent()
  {
   int total=OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
           {
            if(OrderType()==OP_BUY)
              {

               if(OrderOpenPrice()-Ask>centre*Point())
                 {
                  string w_OrderSymbol = OrderSymbol();
                  for(int j=total-1; j>=0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==Symbol() && w_OrderSymbol == OrderSymbol() && OrderMagicNumber()==magic)
                          {
                           if(OrderType()==OP_SELL && Bid-OrderOpenPrice()>centre*Point())
                             {
                              if(price_b-Bid>points*Point() && Ask-price_a>points*Point())
                                {
                                 // Print("进入中间");
                                 OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic);
                                 OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic);
                                 price_a = Ask;
                                 price_b =Bid;
                                }

                             }
                           break;
                          }

                       }
                    }


                 }
              }
            if(OrderType()==OP_SELL)
              {
               if(Bid-OrderOpenPrice()>centre*Point())
                 {
                  string w_OrderSymbol = OrderSymbol();
                  for(int j=total-1; j>0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==Symbol() && w_OrderSymbol == OrderSymbol() && OrderMagicNumber()==magic)
                          {
                           if(OrderType()==OP_BUY && OrderOpenPrice()-Ask>centre*Point())
                             {
                              if(price_b-Bid>points*Point() && Ask-price_a>points*Point())
                                {
                                 // Print("进入中间");
                                 OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic);
                                 OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic);
                                 price_a = Ask;
                                 price_b =Bid;

                                }
                             }
                           break;
                          }
                       }
                    }
                 }
              }

           }
        }
     }

  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   double volume= StringToDouble(ObjectGetString(0,"volume",OBJPROP_TEXT));
   int LossPoint=StringToInteger(ObjectGetString(0,"stopLoss",OBJPROP_TEXT));
   int profitPoint=StringToInteger(ObjectGetString(0,"takeProfit",OBJPROP_TEXT));
   int point=StringToInteger(ObjectGetString(0,"guaDanDian",OBJPROP_TEXT));
   double stopLoss;
   double takeProfit;
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      //非整数时初始为值设置为0
      ObjectSetString(0,"stopLoss",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"stopLoss",OBJPROP_TEXT))) ;
      ObjectSetString(0,"takeProfit",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"takeProfit",OBJPROP_TEXT))) ;
      ObjectSetString(0,"guaDanDian",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"guaDanDian",OBJPROP_TEXT))) ;
      ObjectSetString(0,"volume",OBJPROP_TEXT,NormalizeDouble(StringToDouble(ObjectGetString(0,"volume",OBJPROP_TEXT)),2)) ;

     }
   if(id==CHARTEVENT_OBJECT_CLICK)
     {

      if(sparam=="jieSuo")
        {
         if(MessageBox("确认进行解锁？","确认",4)==6)
           {
            if(jy.ColseOrderBySymbol(Symbol(),magic,S_C)==0)
              {
               Alert("解锁失败！");
               Print("OrderSend failed with error #",GetLastError());
              }
            else
              {
               Alert("解锁成功！");
               int totals = OrdersHistoryTotal();
               for(int i=totals-1; i>=0; i--)
                 {
                  if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
                    {
                     if(OrderSymbol()==Symbol() && magic==OrderMagicNumber() && S_C ==OrderComment())
                       {
                        double proit_h = OrderProfit()+OrderSwap()+OrderCommission();
                        int orderType;
                        if(OrderType()==OP_BUY)
                           orderType=OP_SELL;
                        if(OrderType()==OP_SELL)
                           orderType=OP_BUY;
                        if(!jy.stopProfit(OrderSymbol(),profit*2-proit_h,magic,orderType))
                          {
                           Alert("移动止损失败！");
                           Print("OrderSend failed with error #",GetLastError());
                          }
                        break;
                       }
                    }
                 }
               s=0;
              }
           }

        }
      if(sparam=="suoCang")
        {

         if(MessageBox("确认进行锁仓？","确认",4)==6)
           {
            double buyVolume = jy.totalVolumeBySymbol(Symbol(),magic,OP_BUY);
            double sellVolume = jy.totalVolumeBySymbol(Symbol(),magic,OP_SELL);

            if(buyVolume == sellVolume)
              {
               Alert("已锁仓/当前处于平衡，操作失败！");
              }
            else
               if(buyVolume>sellVolume)
                 {

                  if(OrderSend(Symbol(),OP_SELL,buyVolume-sellVolume,Bid,2,0,0,S_C,magic)<0)
                    {
                     Alert("锁仓失败！");
                     Print("OrderSend failed with error #",GetLastError());

                    }
                  else
                    {
                     Alert("锁仓成功！");
                     jy.ColseOrderGuaBySymbol(Symbol(),magic);
                    }

                 }
               else
                  if(buyVolume<sellVolume)
                    {
                     if(OrderSend(Symbol(),OP_BUY,sellVolume-buyVolume,Ask,2,0,0,S_C,magic)<0)
                       {

                        Alert("锁仓失败！");
                        Print("OrderSend failed with error #",GetLastError());
                       }
                     else
                       {
                        Alert("锁仓成功！");
                        jy.ColseOrderGuaBySymbol(Symbol(),magic);
                       }
                    }

           }

        }
      if(sparam=="jieSuo_2")
        {
         if(MessageBox("确认进行解锁？","确认",4)==6)
           {
            if(jy.ColseOrderBySymbol(Symbol(),magic,S_C_2)==0)
              {
               Alert("解锁失败！");
               Print("OrderSend failed with error #",GetLastError());
              }
            else
              {
               Alert("解锁成功！");
               no_M=0;
              }
           }

        }
      if(sparam=="suoCang_2")
        {

         if(MessageBox("确认进行锁仓？","确认",4)==6)
           {
            double buyVolume = jy.totalVolumeBySymbol(Symbol(),magic,OP_BUY);
            double sellVolume = jy.totalVolumeBySymbol(Symbol(),magic,OP_SELL);

            if(buyVolume == sellVolume)
              {
               Alert("已锁仓/当前处于平衡，操作失败！");
              }
            else
               if(buyVolume>sellVolume)
                 {

                  if(OrderSend(Symbol(),OP_SELL,buyVolume-sellVolume,Bid,2,0,0,S_C_2,magic)<0)
                    {
                     Alert("锁仓失败！");
                     Print("OrderSend failed with error #",GetLastError());

                    }
                  else
                    {
                     Alert("锁仓成功！");
                     jy.ColseOrderGuaBySymbol(Symbol(),magic);
                     no_M=1;
                    }

                 }
               else
                  if(buyVolume<sellVolume)
                    {
                     if(OrderSend(Symbol(),OP_BUY,sellVolume-buyVolume,Ask,2,0,0,S_C_2,magic)<0)
                       {

                        Alert("锁仓失败！");
                        Print("OrderSend failed with error #",GetLastError());
                       }
                     else
                       {
                        Alert("锁仓成功！");
                        jy.ColseOrderGuaBySymbol(Symbol(),magic);
                        no_M=1;
                       }
                    }

           }

        }

     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void anNiu(string name,int x,int y,string text,int width,int high)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrAqua);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,high);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrDarkGreen);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool haveOrderUS(int type)
  {

   int total = OrdersTotal();
   for(int j=total-1; j>0; j--)
     {
      if(OrderSelect(j, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol() &&  OrderMagicNumber()==magic)
           {
            bool a=false;
            bool b=false;
            if(OrderType()==type && type==OP_BUY)
              {
               if(OrderOpenPrice()>Ask)
                 {
                  bool a = true;
                 }
               if(OrderOpenPrice()<Ask)
                 {
                  bool b = true;
                 }
              }
            if(OrderType()==type && type==OP_SELL)
              {
               if(OrderOpenPrice()>Bid)
                 {
                  bool a = true;
                 }
               if(OrderOpenPrice()<Bid)
                 {
                  bool b = true;
                 }
              }
            if(a && b)
              {
               return true;
              }

           }
        }
     }
   return false;
  }
//+------------------------------------------------------------------+
