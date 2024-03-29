//+------------------------------------------------------------------+
//|                                                      F_B_W_G.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
extern double profit=0.6;//出仓利润
input int magic=612973;//魔术号
input double volume=0.01;//初始手数
input int points=100;//挂单点位
extern int ZS_P_S= 200;//移动止损点位
extern  int ZS_P_E =100;//移动止损点数
input double JC_Volume = 0.01;//加仓层数
input int  JC_POIT = 20;//挂单加仓因子
input int C_CW_2 = 1000;//止损点
input int G_D_D = 200;//删除挂单点位
input int D_S = 30;//定时器
input int centre = 200;//中间点
input int Y_J = -1000;//预警线
input double accountType=0.01;//账户类型（美元:0.01;美角:0.1;美分:1）
string S_C = "Matrix_G_D_S";//锁仓标识
string S_C_2 = "Matrix_G_D_S_2";//锁仓标识
string mark = "Matrix_G_D";//标识
extern int s = 0;//自动解锁标识
extern int no_M=0;//普通锁变量标识
datetime time=0;
extern int time_zq=30;//时间间隔大小
input int kshu=30;//k线数
bool start_fb=true;//是否加载斐波那契数组
double nFk;
double maxFk;
bool is_fx=false;//反向加仓标识
extern int fx_point=1000;//趋势突破点
string fx_bs = "Matrix_G_D_F_x";
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
datetime alarm=0;
int OnInit()
  {
   anNiu("suoCang",30,80,"锁仓(移动止盈线)",130,30);
   anNiu("jieSuo",170,80,"解锁(移)",100,30);
   anNiu("suoCang_2",30,120,"锁仓(止盈线不变)",130,30);
   anNiu("jieSuo_2",170,120,"解锁(不移)",100,30);
   anNiu("qstp",30,160,"趋势突破",250,30);
   createLabel();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])
     {
      if(is_fx==true)
        {
         ZS_P_S=300;
         ZS_P_E=200;
        }
      else
        {
         ZS_P_S=200;
         ZS_P_E=100;
        }
      jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);
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
      if(jy.isLocked(Symbol(),magic,fx_bs))
        {
         close_fx();
         return;
        }
      if(start_fb)
        {
         if(ObjectFind("斐波那奇_回调_1") && ObjectFind("斐波那奇_时间_1"))
           {
            //ObjectDelete(ObjectName("斐波那奇_回调_1"));
            //ObjectDelete(ObjectName("斐波那奇_时间_1"));
           }
         fb_kj();  //加载斐波那契时间间隔数组

        }

      if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
        {
         fb_xd();
        }
      close();
      jy.deleteGuanDanByPrice(Symbol(),G_D_D,magic);
      cent();
      if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUYSTOP)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL)!=0)
        {
         OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+points*Point(),3,0,0,mark,magic);
        }
      if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELLSTOP)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)!=0)
        {
         OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
        }
      int total=OrdersTotal();
      for(int i=total-1; i>=0; i--)
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

      if(jy.profitBySymbolTotal(Symbol(),magic)<Y_J)
        {
         SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+" 预警");
        }
      alarm = Time[0];
     }


  }
//+------------------------------------------------------------------+

datetime time_fb[8];//时间间隔数组
double price_fb[8]= {0,0.236,0.382,0.5,0.618,0.764,0.868,1};//价格间隔数组
int sj_kShu;//k线数筛选
double kj_level;//高低两点空间间隔价格
int time_fb_js[8]= {0,1,2,3,5,8,13,21};//时间间隔数组

int h_b;//获取kshu数种最高价的bar柱位置
int l_b;//获取kshu数种最低价的bar柱数位置
double h_b_p;//最高价
double l_b_p;//最低价
void  fb_kj()
  {
   for(int i=2; i<=1000; i++)
     {
      h_b = iHighest(Symbol(),time_zq,MODE_HIGH,kshu,i);
      l_b = iLowest(Symbol(),time_zq,MODE_LOW,kshu,i);
      if(h_b!=0 && l_b!=0 && h_b!=l_b)
        {
         h_b_p=iHigh(Symbol(),time_zq,h_b);
         l_b_p=iLow(Symbol(),time_zq,l_b);
         if(Ask<h_b_p && Ask>l_b_p && Bid<h_b_p && Bid>l_b_p)
           {
            break;
           }
        }

     }
   datetime h_t = Time[h_b];//最高价时间
   datetime l_t = Time[l_b];//最低价时间
   if(h_t<l_t)//高价在前
     {
      ObjectCreate("斐波那奇_回调_1",OBJ_FIBO,0,h_t,h_b_p,l_t,l_b_p);
      ObjectCreate("斐波那奇_时间_1",OBJ_FIBOTIMES,0,h_t,h_b_p,l_t,l_b_p);

     }
   if(h_t>l_t)//低价在前
     {
      ObjectCreate("斐波那奇_回调_1",OBJ_FIBO,0,l_t,l_b_p,h_t,h_b_p);
      ObjectCreate("斐波那奇_时间_1",OBJ_FIBOTIMES,0,l_t,l_b_p,h_t,h_b_p);
     }
   for(int i=0; i<ArraySize(time_fb_js); i++)
     {
      if(l_t>h_t)
        {
         time_fb[i]=h_t+time_fb_js[i]*time_zq*60*(h_b-l_b);
        }
      if(l_t<h_t)
        {
         time_fb[i]=l_t+time_fb_js[i]*time_zq*60*(l_b-h_b);
        }
     }
   kj_level=h_b_p - l_b_p;
   start_fb=false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void fb_xd()
  {

   if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
     {
      for(int i=0; i<ArraySize(time_fb); i++)
        {
         if(Time[0]>time_fb[7])
           {
            start_fb=true;
            return;
           }
         if(Time[0]==time_fb[i])
           {

            //double bfb_S=NormalizeDouble((Bid-l_b_p)/kj_level,3);
            //double bfb_b=NormalizeDouble((Ask-l_b_p)/kj_level,3);
            if(High[1]>High[2])
              {
               int ticket = OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,"sell",magic);

               printf("斐波那契指标开仓");

              }
            else
               if(Low[1]<Low[2] || (Low[1]>Low[2] && High[1]<High[2]))
                 {
                  int ticket=OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic);
                  printf("斐波那契指标开仓");

                 }
            start_fb=true;

           }
        }
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
                              if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUYSTOP)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELLSTOP)==0)
                                {
                                 // Print("进入中间");
                                 OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
                                 OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+points*Point(),3,0,0,mark,magic);
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
                              if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUYSTOP)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELLSTOP)==0)
                                {
                                 //Print("进入中间");
                                 OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
                                 OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+points*Point(),3,0,0,mark,magic);
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

     }

   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
        {
         Alert("盈利出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
      jy.ColseOrderGuaBySymbol(Symbol(),magic);

     }
  }
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
      if(sparam=="qstp")
        {
         if(MessageBox("是否启动趋势突破？","确认",4)==6)
           {
            fanXiang();
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
void fanXiang()
  {
   int total=OrdersTotal();
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
           {
            if(OrderType()==OP_BUY && OrderOpenPrice()-Ask>Point()*fx_point)
              {
               double buyOrders = jy.totalVolumeBySymbol(Symbol(),magic,OP_BUY);
               if(OrderSend(Symbol(),OP_SELL,2*buyOrders,Bid,3,0,0,fx_bs,magic)<0)
                 {
                  Alert("启动失败！");
                  Print("OrderSend failed with error #",GetLastError());
                  return;
                 }
               Alert("启动成功！");
               is_fx=true;
               printf("趋势反向");
               return;
              }
            if(OrderType()==OP_SELL && Bid-OrderOpenPrice()>Point()*fx_point)
              {
               double sellOrders = jy.totalVolumeBySymbol(Symbol(),magic,OP_SELL);
               if(OrderSend(Symbol(),OP_BUY,2*sellOrders,Ask,3,0,0,fx_bs,magic)<0)
                 {
                  Alert("启动失败！");
                  Print("OrderSend failed with error #",GetLastError());
                  return;
                 }
               Alert("启动成功！");
               is_fx=true;
               printf("趋势反向");
               return;
              }
            is_fx=false;
            Alert("未达到趋势突破条件！");
           }
        }
     }


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close_fx()
  {

   if(jy.profitBySymbolTotal(Symbol(),magic)>profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic)==0)
        {
         Alert("盈利出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
     }
  }
//+------------------------------------------------------------------+
