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
extern double profit=-5;//出仓利润
input int magic=612973;//魔术号
input double volume=0.01;//初始手数
input int points=100;//挂单点位
input int ZS_P_S= 200;//移动止损点位
input int ZS_P_E =100;//移动止损点数
input double JC_Volume = 0.01;//加仓层数
input int  JC_POIT = 20;//挂单加仓因子
input int Z_S_D = 3000;//止损点
input int G_D_D = 200;//删除挂单点位
input int Y_J = -1000;//预警线
input double accountType=0.01;//账户类型（美元:0.01;美角:0.1;美分:1）
string S_C = "Matrix_G_D_S";//锁仓标识
string S_C_2 = "Matrix_G_D_S_2";//锁仓标识
string mark = "Matrix_G_D";//标识
extern int SS_D=100;//顺势加仓点
extern int dingshi = 5;//定时设置
extern int dianCha=0;//加入点差
extern int s = 0;//自动解锁标识
extern int no_M=0;//普通锁变量标识
datetime time=0;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
double nFk;
double maxFk;


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
   EventSetTimer(dingshi);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
// jy.ColseOrderGuaBySymbol(Symbol(),magic);
   EventKillTimer();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);
   jiaCang();
   jy.deleteGuanDanByPrice(Symbol(),G_D_D,magic);
   close();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(time!=Time[0])
     {
      jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);
      shouDan();
      time=Time[0];
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void shouDan()
  {
   if(jy.CheckOrderByaSymbol(Symbol())==0)
     {
      OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
      OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+points*Point(),3,0,0,mark,magic);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void jiaCang()
  {
   if(!isExitDD())
     {
      int totals = OrdersTotal();
      for(int i=totals-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(Symbol()==OrderSymbol())
              {
               double oprice = OrderOpenPrice();
               double lots;
               if(OrderType()==OP_BUY)
                 {
                  if(Ask-SS_D*Point()>=oprice) //顺势涨
                    {

                     EventKillTimer();
                     if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic,0,clrRed)<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("涨单加仓失败："+GetLastError());
                       }
                     EventSetTimer(dingshi);

                    }
                  else
                     if(oprice-SS_D*Point()>=Ask) //顺势跌
                       {

                        EventKillTimer();
                        if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic,0,clrRed)<0)
                          {
                           Print("OrderSend failed with error #",GetLastError());
                           Alert("跌单加仓失败："+GetLastError());
                          }
                        EventSetTimer(dingshi);


                       }

                 }
               else
                  if(OrderType()==OP_SELL)
                    {
                     if(Bid-SS_D*Point()>=oprice) //顺势涨
                       {

                        EventKillTimer();
                        if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic,0,clrRed)<0)
                          {
                           Print("OrderSend failed with error #",GetLastError());
                           Alert("涨单加仓失败："+GetLastError());
                          }
                        EventSetTimer(dingshi);
                       }
                     else
                        if(oprice-SS_D*Point()>=Bid) //顺势跌
                          {

                           EventKillTimer();
                           if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic,0,clrRed)<0)
                             {
                              Print("OrderSend failed with error #",GetLastError());
                              Alert("跌单加仓失败："+GetLastError());
                             }
                           EventSetTimer(dingshi);
                          }

                    }
               break;
              }
           }
        }
     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isExitDD()
  {
   bool isExit=false;
   int totals = OrdersTotal();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(Symbol()==OrderSymbol())
           {
            double price = OrderOpenPrice();

            if(OrderType()==OP_BUY && MathAbs(Ask-price)<=SS_D*Point())
              {
               isExit=TRUE;
               break;

              }
            else
               if(OrderType()==OP_SELL && MathAbs(Bid-price)<=SS_D*Point())
                 {
                  isExit=TRUE;
                  break;
                 }
           }
        }
     }
   return isExit;

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

   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)<profit-dianCha*Point())
     {

      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY)==0)
        {
         Alert("涨单出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }

     }

   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)<profit-dianCha*Point())
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
        {
         Alert("跌单出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zhiSun()
  {

   int total=OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
           {
            if(OrderOpenTime()<iTime(OrderSymbol(),PERIOD_W1,0))
              {
               if(OrderType()==OP_BUY && OrderOpenPrice()-Bid>5000*Point())
                 {
                  OrderClose(OrderTicket(),OrderLots(),Bid,3);
                  printf(OrderTicket()+"订单止损");
                 }
               if(OrderType()==OP_SELL && Ask-OrderOpenPrice()>5000*Point())
                 {
                  OrderClose(OrderTicket(),OrderLots(),Ask,3);
                  printf(OrderTicket()+"订单止损");
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
void zhiShun()
  {
   int total = OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY && OrderStopLoss()==0)
              {
               OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Z_S_D*Point(),OrderTakeProfit(),0,clrNONE);
              }
            if(OrderType()==OP_SELL && OrderStopLoss()==0)
              {
               OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Z_S_D*Point(),OrderTakeProfit(),0,clrNONE);
              }

           }
        }
     }
  }
//+------------------------------------------------------------------+
