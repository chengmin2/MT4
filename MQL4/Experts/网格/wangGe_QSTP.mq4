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
extern int magic=612973;//魔术号
input double volume=0.1;//初始手数
input int huiCeDian=200;//回撤顺势点
input int points=100;//挂单点位
input int ZS_P_S= 200;//移动止损点位
input int ZS_P_E =100;//移动止损点数
input double JC_Volume = 0.1;//加仓层数
input int  JC_POIT = 20;//挂单加仓因子
input int G_D_D = 200;//删除挂单点位
input int centre = 150;//区间中间点
input int centre_g = 50;//区间挂单点
input double accountType=0.1;//账户类型（美元:0.01;美角:0.1;美分:1）

input string  kk="----------";//-------------
extern  bool isOpenQSTP=false;//是否开始趋势突破
input string ll="-----------";//-----------


extern int jc_points =700;//加仓点位
extern int jc_jisu=2;//加仓基数
extern  int weiXin=100;//微型账户1标准手缩小倍数
extern int startQS_profit=-800;//亏损启动趋势突破
extern double sc_fengKong=0.8;//自动锁仓当前亏损最大比例

extern int cc_profit_points=100;//出仓利润点
extern double equity=-500;//自动锁仓净利润值

string mark = "Matrix_G_D";//标识
string sc_mark = "Matrix_SJ_SC";//锁仓标识
extern double warning = 0.5;//净值/余额 不足50%进行警报
bool isBadRule=false;//是否已经存在破坏加仓规则
extern bool open_touch=false;//平单触发
extern  bool stopEa_jc=false;//停止加仓
extern  bool stopEa=false;//暂停EA
extern  bool isOpenGolden = false;//开启入金自动解锁标识
bool isJS = false;//是否解锁
bool isSuoCang = false;//是否锁仓
int jc_cs = 1;//加仓计数
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
   createLabel();
   背景("主面板",10,10);
   label("止损",10,20,"止损:");
   shuRuKuang("stopLoss",50,20,"200",40,20);
   label("止盈",95,20,"止盈:");
   shuRuKuang("takeProfit",135,20,"200",40,20);
   label("zsje",180,20,"止损金额:");
   shuRuKuang("zhiSunMoney",250,20,"-200",50,20);

   label("挂单",20,50,"挂单点位:");
   shuRuKuang("guaDanDian",100,50,"200",50,20);
   label("手数",160,50,"下单手数:");
   shuRuKuang("volume",240,50,"0.01",50,20);

   anNiu("duo",50,80,"多单",100,20);
   anNiu("kong",160,80,"空单",100,20);

   anNiu("buyStop",10,110,"buyTop",80,20);
   anNiu("buyLimit",95,110,"buyLimt",70,20);
   anNiu("sellStop",170,110,"sellTop",70,20);
   anNiu("sellLimit",250,110,"sellLimt",60,20);
   anNiu("pingcang",10,140,"平当前货币",80,20);
   anNiu("pingduo",95,140,"平多单",70,20);
   anNiu("pingkong",170,140,"平空单",70,20);
   anNiu("pingGua",250,140,"删挂单",60,20);

   anNiu("closeAll",15,170,"平所有货币",90,30);
   anNiu("suoCang",115,170,"锁仓",90,30);
   anNiu("yiDongZhiYing",215,170,"移动止盈",90,30);

   anNiu("stopEa_jc",15,210,"停止加仓",140,30);
   anNiu("stopEa",165,210,"暂停EA",140,30);

   anNiu("openTrig",15,250,"平单触发开",90,30);
   anNiu("zhiSunJE",115,250,"金额止损/赢",90,30);
   anNiu("clearZhiYing",215,250,"清除止损/赢",90,30);

   anNiu("closeBuyOrder",15,290,"平多单计算止盈",140,30);
   anNiu("closeSellOrder",165,290,"平空单计算止盈",140,30);

   anNiu("golden",15,330,"开启入金自动解锁",140,30);
   anNiu("shouDongJS",165,330,"解锁",140,30);

   EventSetTimer(1);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   int object = ObjectsTotal();
   for(int i=object-1; i>=0; i--)
     {
      ObjectDelete(ObjectName(i));
     }
   EventKillTimer();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   initialize();
   totalLost();
   getMagic();//获取魔术号
   if(isOpenQSTP)
     {
      if(jc_cs==1)
        {
         firstJC();
        }
      if(!stopEa)
        {
         closeHandMovement();//关闭手动下单不符合初始条件的订单
         close();//盈利清仓
         suoCangFK();//自动风控锁仓
         openTouch();//检测是否开启一键全平订单
         ziDongJieSuo(false);//入金自动解锁
         if(!stopEa_jc)
           {
            jiaCang();//加仓
           }


        }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(time!=Time[0])
     {

      getMagic();
      totalLost();
      if(AccountProfit()<startQS_profit)
        {
         isOpenQSTP=true;
        }
      if(!isOpenQSTP)
        {
         if(!stopEa)
           {
            closeGD();
            if(jy.CheckOrderByaSymbolType(Symbol(),OP_BUY)==0 && jy.CheckOrderByaSymbolType(Symbol(),OP_SELL)==0)
              {
               OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
               OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+points*Point(),3,0,0,mark,magic);
              }
            if(!stopEa_jc)
              {
               guaDanJC();
              }
            jy.mobileStopLoss(Symbol(),ZS_P_S,ZS_P_E);
            jy.deleteGuanDanByPrice(Symbol(),(huiCeDian+points));
           
           }

        }
      if(isOpenQSTP)
        {
         if(jc_cs==1)
           {
            firstJC();
           }

         if(!stopEa)
           {
            closeHandMovement();
            close();
            suoCangFK();
            if(!stopEa_jc)
               jiaCang();


           }


        }

      time=Time[0];
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void guaDanJC()
  {


   if(jy.CheckOrderByaSymbolType(Symbol(),OP_BUY)==0 && jy.CheckOrderByaSymbolType(Symbol(),OP_BUYSTOP)==0)
     {
      OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+points*Point(),3,0,0,mark,magic);
     }
   if(jy.CheckOrderByaSymbolType(Symbol(),OP_SELL)==0 && jy.CheckOrderByaSymbolType(Symbol(),OP_SELLSTOP)==0)
     {
      OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
     }
   int total=OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
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


   jy.deleteGuanDanByPrice(Symbol(),G_D_D,magic);
   cent();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void closeGD()
  {

   if(jy.profitBySymbolTotalType(Symbol(),OP_BUY)>profit)
     {

      if(jy.ColseOrderBySymbolType(Symbol(),OP_BUY)==0)
        {
         Alert("盈利出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
      jy.ColseOrderGuaBySymbol(Symbol());
      OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
      OrderSend(Symbol(),OP_BUYSTOP,volume,Bid+points*Point(),3,0,0,mark,magic);
     }

   if(jy.profitBySymbolTotalType(Symbol(),OP_SELL)>profit)
     {
      if(jy.ColseOrderBySymbolType(Symbol(),OP_SELL)==0)
        {
         Alert("盈利出仓操作失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
      jy.ColseOrderGuaBySymbol(Symbol());
      OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
      OrderSend(Symbol(),OP_BUYSTOP,volume,Bid+points*Point(),3,0,0,mark,magic);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


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
         if(OrderSymbol()==Symbol())
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
                        if(OrderSymbol()==Symbol() && w_OrderSymbol == OrderSymbol())
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
                        if(OrderSymbol()==Symbol() && w_OrderSymbol == OrderSymbol())
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
void qj_gd()
  {
   if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUYSTOP)!=0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELLSTOP)!=0)
      return;
   int total=OrdersTotal();
   double B_MaLL=0;
   double S_Max=0;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {

            if(OrderType()==OP_BUY)
              {
               if(OrderOpenPrice()<B_MaLL || B_MaLL==0)
                 {
                  B_MaLL = OrderOpenPrice();
                 }
              }
            if(OrderType()==OP_SELL)
              {
               if(OrderOpenPrice()>S_Max || S_Max==0)
                  S_Max = OrderOpenPrice();
              }

           }

        }
     }
   if(B_MaLL!=0 && S_Max!=0)
     {

      if(B_MaLL-Ask>=centre*Point() && Bid-S_Max>=centre*Point())
        {
         OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
         OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+points*Point(),3,0,0,mark,magic);
         printf("进行区间挂单操作");
        }
     }

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void firstJC()
  {
   double buy_lots=jy.totalVolumeBySymbol(Symbol(),OP_BUY);
   double sell_lots=jy.totalVolumeBySymbol(Symbol(),OP_SELL);
   if(buy_lots>sell_lots)
     {
      OrderSend(Symbol(),OP_SELL,2*buy_lots,Bid,3,0,0,mark,magic,0,clrRed);
      jc_cs++;
     }
   if(buy_lots<sell_lots)
     {
      OrderSend(Symbol(),OP_BUY,2*sell_lots,Ask,3,0,0,mark,magic,0,clrRed);
      jc_cs++;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void openTouch()
  {
   if(open_touch && isBadRule)
     {
      jy.ColseOrderBySymbol(Symbol());
      if(open_touch)
        {
         open_touch=false;
         ObjectSetString(0,"openTrig",OBJPROP_TEXT,"平单触发开") ;
         ObjectSetInteger(0,"openTrig",OBJPROP_BGCOLOR,clrDarkOliveGreen);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void getMagic()
  {
   if(jy.CheckOrderByaSymbol(Symbol())==1)
     {
      string s_magic = IntegerToString(TimeYear(TimeLocal()))+IntegerToString(TimeMonth(TimeLocal()))
                       +IntegerToString(TimeDay(TimeLocal()))+IntegerToString(TimeHour(TimeLocal()))
                       +IntegerToString(TimeMinute(TimeLocal()))+IntegerToString(TimeSeconds(TimeLocal()));
      magic = StringToInteger(s_magic);
     }


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void totalLost()
  {
   fuKui();
   double buyLosts =  jy.totalVolumeBySymbol(Symbol(),OP_BUY);
   double sellLosts =  jy.totalVolumeBySymbol(Symbol(),OP_SELL);
   double bl=NormalizeDouble(AccountEquity()/AccountBalance(),2);
   double totalLots = NormalizeDouble(sellLosts+buyLosts,2);
   ObjectSetText("Buy_lots",buyLosts,20,"Arial",clrLightGoldenrod);
   ObjectSetText("Sell_lots",sellLosts,20,"Arial",clrLightGoldenrod);
   ObjectSetText("All_Lots",totalLots,20,"Arial",clrLightGoldenrod);
   ObjectSetText("BL",bl,20,"Arial",clrLightGoldenrod);
   if(bl<warning)
     {
      SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"净值已不足50%");
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void suoCangFK()
  {

   if(AccountEquity()<equity || jy.riskMangement(sc_fengKong))
     {
      suoCang();
      Print("自动风控进行锁仓");
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void suoCang()
  {

   double buyVolume = jy.totalVolumeBySymbol(Symbol(),OP_BUY);
   double sellVolume = jy.totalVolumeBySymbol(Symbol(),OP_SELL);

   if(buyVolume == sellVolume)
     {
      Alert("已锁仓/当前处于平衡，操作失败！");
     }
   else
      if(buyVolume>sellVolume)
        {

         if(OrderSend(Symbol(),OP_SELL,buyVolume-sellVolume,Bid,2,0,0,sc_mark,magic)<0)
           {
            Alert("锁仓失败！");
            Print("OrderSend failed with error #",GetLastError());

           }
         else
           {

            jy.ColseOrderGuaBySymbol(Symbol(),magic);
            isSuoCang=true;
            ObjectSetString(0,"suoCang",OBJPROP_TEXT,"已锁仓") ;
            ObjectSetInteger(0,"suoCang",OBJPROP_BGCOLOR,clrRed);
            GlobalVariableSet(AccountNumber()+"balance",AccountBalance());
            Alert("缓存账户余额："+AccountBalance());

            stopEa_jc=true;
            ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"启动加仓") ;
            ObjectSetInteger(0,"stopEa_jc",OBJPROP_BGCOLOR,clrRed);

            stopEa=true;
            ObjectSetString(0,"stopEa",OBJPROP_TEXT,"启动EA") ;
            ObjectSetInteger(0,"stopEa",OBJPROP_BGCOLOR,clrRed);
            Alert("锁仓成功！");

           }

        }
      else
         if(buyVolume<sellVolume)
           {
            if(OrderSend(Symbol(),OP_BUY,sellVolume-buyVolume,Ask,2,0,0,sc_mark,magic)<0)
              {

               Alert("锁仓失败！");
               Print("OrderSend failed with error #",GetLastError());
              }
            else
              {

               jy.ColseOrderGuaBySymbol(Symbol(),magic);
               isSuoCang=true;
               ObjectSetString(0,"suoCang",OBJPROP_TEXT,"已锁仓") ;
               ObjectSetInteger(0,"suoCang",OBJPROP_BGCOLOR,clrRed);
               GlobalVariableSet(AccountNumber()+"balance",AccountBalance());
               Alert("缓存账户余额："+AccountBalance());
               stopEa_jc=true;
               ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"启动加仓") ;
               ObjectSetInteger(0,"stopEa_jc",OBJPROP_BGCOLOR,clrRed);
               stopEa=true;
               ObjectSetString(0,"stopEa",OBJPROP_TEXT,"启动EA") ;
               ObjectSetInteger(0,"stopEa",OBJPROP_BGCOLOR,clrRed);
               Alert("锁仓成功！");
              }
           }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  closeHandMovement()
  {
   double min=100000;
   double min_Lot=100000;

   int total = OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(Symbol()==OrderSymbol())
           {
            if(OrderLots()<min)
              {
               min=OrderLots();
               if(min_Lot==100000)
                 {
                  min_Lot=OrderLots();
                 }
               else
                 {
                  if(min_Lot/OrderLots()!=jc_jisu)
                    {
                     isBadRule=true;
                    }
                  min_Lot = OrderLots();
                 }

              }
            else
               if(min==OrderLots())
                 {
                    {
                     if(OrderType()==OP_SELL)
                       {
                        if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
                          {
                           Print("OrderClose failed with error #",GetLastError());
                           Alert("关闭下单(去重复)订单"+OrderTicket()+"失败："+GetLastError());
                           SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"关闭重复订单失败");
                          }
                       }
                     if(OrderType()==OP_BUY)
                       {
                        if(!OrderClose(OrderTicket(),OrderLots(),Bid,3))
                          {
                           Print("OrderClose failed with error #",GetLastError());
                           Alert("关闭手动下单(去重复)订单"+OrderTicket()+"失败："+GetLastError());
                           SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"关闭重复手动订单失败");
                          }
                       }
                    }
                 }
            if(OrderLots()>volume && OrderMagicNumber()==0)
              {
               if(OrderType()==OP_BUY)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Bid,3);
                 }
               if(OrderType()==OP_SELL)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3))
                    {
                     Print("OrderClose failed with error #",GetLastError());
                     Alert("关闭手动下单订单"+OrderTicket()+"失败："+GetLastError());
                     SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"关闭手动订单失败");
                    }

                 }
               if(OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT
                  || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT)
                 {
                  OrderDelete(OrderTicket());
                 }
              }
           }

        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void jiaCang()
  {
   int totals = OrdersTotal();

   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            /*int guaBuyOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_BUYSTOP);
            int guaSellOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_SELLSTOP);
            int thisOrderType= OrderType();
            double thisOrderLots = OrderLots();
            if(guaBuyOrder==0 && guaBuyOrder==0)
              {
               if(thisOrderType==OP_BUY)
                 {
                  if(totals==1)
                    {
                     if(OrderSend(Symbol(),OP_SELLSTOP,jc_jisu*OrderLots(),Ask-jc_points*Point(),3,0,0,mark,magic,0,clrGreen)<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("挂单失败："+GetLastError());
                        SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"挂单失败");
                       }
                     break;
                    }
                  for(int j=0; j<totals; j++)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==Symbol())
                          {
                           if(OrderType()==OP_SELL)
                             {
                              if(OrderSend(Symbol(),OP_SELLSTOP,jc_jisu*thisOrderLots,OrderOpenPrice(),3,0,0,mark,magic,0,clrGreen)<0)
                                {
                                 Print("OrderSend failed with error #",GetLastError());
                                 Alert("挂单失败："+GetLastError());
                                 SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"挂单失败");
                                }
                              break;
                             }

                          }
                       }

                    }

                  break;

                 }
               if(OrderType()==OP_SELL)
                 {
                  if(totals==1)
                    {
                     if(OrderSend(Symbol(),OP_BUYSTOP,jc_jisu*OrderLots(),Bid+jc_points*Point(),3,0,0,mark,magic,0,clrGreen)<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("挂单失败："+GetLastError());
                        SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"挂单失败");
                       }
                     break;
                    }

                  for(int j=0; j<totals; j++)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==Symbol())
                          {
                           if(OrderType()==OP_BUY)
                             {
                              if(OrderSend(Symbol(),OP_BUYSTOP,jc_jisu*thisOrderLots,OrderOpenPrice(),3,0,0,mark,magic,0,clrGreen)<0)
                                {
                                 Print("OrderSend failed with error #",GetLastError());
                                 Alert("挂单失败："+GetLastError());
                                 SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"挂单失败");
                                }
                              break;
                             }

                          }
                       }

                    }
                  break;
                 }


              }*/
            if(OrderType()==OP_BUY && OrderOpenPrice()-Bid>=jc_points*Point())
              {
               EventKillTimer();
               if(OrderSend(Symbol(),OP_SELL,jc_jisu*OrderLots(),Bid,3,0,0,mark,magic,0,clrGreen)<0)
                 {
                  Print("OrderSend failed with error #",GetLastError());
                  Alert("加仓失败："+GetLastError());
                 }
               EventSetTimer(1);

              }
            if(OrderType()==OP_SELL && Ask-OrderOpenPrice()>=jc_points*Point())
              {
               EventKillTimer();
               if(OrderSend(Symbol(),OP_BUY,jc_jisu*OrderLots(),Ask,3,0,0,mark,magic,0,clrGreen)<0)
                 {
                  Print("OrderSend failed with error #",GetLastError());
                  Alert("加仓失败："+GetLastError());
                 }
               EventSetTimer(1);
              }
            break;
           }

        }

     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   double totalVolume =MathAbs(jy.totalVolumeBySymbol(Symbol(),OP_BUY)-jy.totalVolumeBySymbol(Symbol(),OP_SELL));
   double thisProfit= totalVolume*cc_profit_points/weiXin-jieSuoProfit();
   printf("解锁利润："+jieSuoProfit());
   printf("出仓利润："+thisProfit);
   if(jy.profitBySymbolTotal(Symbol())>thisProfit)
     {
      ColseOrderBySymbol();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double jieSuoProfit()
  {
   double thisProfit=0;
   if(isJS)
     {
      int total = OrdersHistoryTotal();
      for(int i=total-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS,MODE_HISTORY))
           {
            if(OrderSymbol()==Symbol())
              {
               if(sc_mark==OrderComment())
                 {
                  thisProfit = OrderProfit()+OrderCommission()+OrderSwap();
                 }

               break;
              }
           }
        }
     }
   return thisProfit;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ColseOrderBySymbol()
  {
   int total = OrdersTotal();
   while(jy.CheckOrderByaSymbol(Symbol())>0)
     {
      for(int i=total-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(OrderSymbol()==Symbol())
              {
               if(OrderType()==OP_BUY)
                 {

                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,Red))
                    {

                     Print("OrderClose failed with error #",GetLastError());
                     Alert("关闭订单"+OrderTicket()+"失败："+GetLastError());
                     SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"关闭订单"+OrderTicket()+"失败");
                    }
                  else
                    {
                     stopEa_jc=false;
                     open_touch = false;
                     isOpenGolden =false;
                     isJS=false;
                    }
                 }

               if(OrderType()==OP_SELL)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,Red))
                    {
                     Print("OrderClose failed with error #",GetLastError());
                     Alert("关闭订单"+OrderTicket()+"失败："+GetLastError());
                     SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"关闭订单"+OrderTicket()+"失败");
                    }
                  else
                    {
                     stopEa_jc=false;
                     open_touch = false;
                     isOpenGolden =false;
                     isJS=false;
                    }


                 }
               if(OrderType()==OP_SELLSTOP || OrderType()==OP_BUYSTOP)
                 {

                  if(!OrderDelete(OrderTicket()))
                    {
                     Alert("删除挂单"+OrderTicket()+"失败："+GetLastError());
                     SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"删除订单"+OrderTicket()+"失败");
                    }
                 }

              }

           }
        }
      Sleep(800);
     }
   jc_cs=1;
   isOpenQSTP=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void anNiu(string name,int x,int y,string text,int width,int high)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrOrangeRed);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrDarkOliveGreen);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,high);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrForestGreen);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void shuRuKuang(string name,int x,int y,string text,int width,int high)
  {
   ObjectCreate(0,name,OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrWhite);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,high);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
//ObjectSetInteger(0,name,OBJPROP_READONLY,20);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrYellow);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 背景(string name,int x,int y)
  {
   ObjectCreate(0,name,OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrBlack);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,true);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,300);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,360);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,"");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrLime);
   ObjectSetInteger(0,name,OBJPROP_ALIGN,ALIGN_LEFT);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void label(string name,int x,int y,string text)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSetText(name,text,10,"Arial",clrLightSeaGreen);
   ObjectSet(name,OBJPROP_CORNER,0);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void label2(string name,int x,int y,string text)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSetText(name,text,20,"Arial",clrLightGoldenrod);
   ObjectSet(name,OBJPROP_CORNER,0);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);

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
   double zhiSunMoney=StringToDouble(ObjectGetString(0,"zhiSunMoney",OBJPROP_TEXT));
   double stopLoss;
   double takeProfit;
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      //非整数时初始为值设置为0
      ObjectSetString(0,"stopLoss",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"stopLoss",OBJPROP_TEXT))) ;
      ObjectSetString(0,"takeProfit",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"takeProfit",OBJPROP_TEXT))) ;
      ObjectSetString(0,"guaDanDian",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"guaDanDian",OBJPROP_TEXT))) ;
      ObjectSetString(0,"volume",OBJPROP_TEXT,NormalizeDouble(StringToDouble(ObjectGetString(0,"volume",OBJPROP_TEXT)),2)) ;
      ObjectSetString(0,"zhiSunMoney",OBJPROP_TEXT,NormalizeDouble(StringToDouble(ObjectGetString(0,"zhiSunMoney",OBJPROP_TEXT)),2)) ;

     }
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(volume==0)
        {
         Alert("请输入正确的下单手数！");
         return;
        }
      if(sparam=="duo")
        {
         if(MessageBox("确认下"+volume+"手多单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Ask-LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Ask+takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_BUY,magic,stopLoss,takeProfit,0);
           }

        }
      if(sparam=="kong")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手空单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Bid+LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Bid-takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_SELL,magic,stopLoss,takeProfit,0);
           }

        }
      if(sparam=="buyStop")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(point==0)
           {
            Alert("挂单点请输入正确的整数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手buyStop单？","确认",4)==6)
           {

            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Ask+point*Point()-LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Ask+point*Point()+takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_BUYSTOP,magic,stopLoss,takeProfit,point);

           }

        }
      if(sparam=="buyLimit")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(point==0)
           {
            Alert("挂单点请输入正确的整数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手buyLimit单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Ask-point*Point()-LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Ask-point*Point()+takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_BUYSTOP,magic,stopLoss,takeProfit,point);
           }

        }
      if(sparam=="sellStop")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(point==0)
           {
            Alert("挂单点请输入正确的整数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手sellStop单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Bid-point*Point()+LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Bid-point*Point()-takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_SELLSTOP,magic,stopLoss,takeProfit,point);
           }

        }
      if(sparam=="sellLimit")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(point==0)
           {
            Alert("挂单点请输入正确的整数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手sellLimit单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Bid+point*Point()+LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Bid+point*Point()-takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_SELLSTOP,magic,stopLoss,takeProfit,point);
           }

        }
      if(sparam=="pingcang")
        {

         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderBySymbol(Symbol());
           }

        }
      if(sparam=="pingduo")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderBySymbolType(Symbol(),OP_BUY);
           }

        }
      if(sparam=="pingkong")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderBySymbolType(Symbol(),OP_SELL);
           }

        }
      if(sparam=="pingGua")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderGuaBySymbol(Symbol());
           }

        }

      if(sparam=="closeAll")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseAll();
           }
        }
      if(sparam=="suoCang")
        {
         if(MessageBox("确认进行锁仓？","确认",4)==6)
           {
            if(!stopEa_jc)
              {
               stopEa_jc=true;
               ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"启动加仓") ;
               ObjectSetInteger(0,"stopEa_jc",OBJPROP_BGCOLOR,clrRed);

               // Alert("操作成功！");

              }
            suoCang();

           }

        }
      if(sparam=="yiDongZhiYing")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.mobileStopLoss(Symbol(),ZS_P_S,ZS_P_E);
           }
        }
      if(sparam=="stopEa_jc")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            if(!stopEa_jc)
              {
               stopEa_jc=true;
               ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"启动加仓") ;
               ObjectSetInteger(0,"stopEa_jc",OBJPROP_BGCOLOR,clrRed);
               Alert("操作成功！");
               return;
              }
            if(stopEa_jc)
              {
               stopEa_jc=false;
               ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"停止加仓") ;
               ObjectSetInteger(0,"stopEa_jc",OBJPROP_BGCOLOR,clrDarkOliveGreen);
               Alert("操作成功！");
              }
           }
        }
      if(sparam=="stopEa")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            if(!stopEa)
              {
               stopEa=true;
               ObjectSetString(0,"stopEa",OBJPROP_TEXT,"启动EA") ;
               ObjectSetInteger(0,"stopEa",OBJPROP_BGCOLOR,clrRed);
               Alert("操作成功！");
               return;
              }
            else
               if(stopEa)
                 {
                  stopEa=false;
                  ObjectSetString(0,"stopEa",OBJPROP_TEXT,"暂停EA") ;
                  ObjectSetInteger(0,"stopEa",OBJPROP_BGCOLOR,clrDarkOliveGreen);
                  Alert("操作成功！");
                 }
           }
        }
      if(sparam=="openTrig")
        {

         if(MessageBox("确认该操作？","确认",4)==6)
           {
            if(!open_touch)
              {
               open_touch=true;
               ObjectSetString(0,"openTrig",OBJPROP_TEXT,"平单触发关") ;
               ObjectSetInteger(0,"openTrig",OBJPROP_BGCOLOR,clrRed);
               Alert("操作成功！");
               return;
              }
            else
               if(open_touch)
                 {
                  open_touch=false;
                  ObjectSetString(0,"openTrig",OBJPROP_TEXT,"平单触发开") ;
                  ObjectSetInteger(0,"openTrig",OBJPROP_BGCOLOR,clrDarkOliveGreen);

                  Alert("操作成功！");
                 }
           }
        }
      if(sparam=="zhiSunJE")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            if(!stopEa_jc)
              {
               stopEa_jc=true;
               ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"启动加仓") ;
               // Alert("操作成功！");

              }
            if(!stopEa)
              {
               stopEa=true;
               ObjectSetString(0,"stopEa",OBJPROP_TEXT,"启动EA") ;
               // Alert("操作成功！");

              }
            zhiSun(zhiSunMoney);
           }

        }
      if(sparam=="clearZhiYing")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {

            clearZY();
           }

        }
      if(sparam=="closeBuyOrder")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            if(!stopEa_jc)
              {
               stopEa_jc=true;
               ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"启动加仓") ;
               // Alert("操作成功！");

              }
            if(!stopEa)
              {
               stopEa=true;
               ObjectSetString(0,"stopEa",OBJPROP_TEXT,"启动EA") ;
               // Alert("操作成功！");

              }
            closeOrderZY(OP_BUY);
           }

        }
      if(sparam=="closeSellOrder")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            if(!stopEa_jc)
              {
               stopEa_jc=true;
               ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"启动加仓") ;
               // Alert("操作成功！");

              }
            if(!stopEa)
              {
               stopEa=true;
               ObjectSetString(0,"stopEa",OBJPROP_TEXT,"启动EA") ;
               // Alert("操作成功！");

              }
            closeOrderZY(OP_SELL);
           }

        }
      if(sparam=="golden")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            if(!stopEa_jc)
              {
               stopEa_jc=true;
               ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"启动加仓") ;
               ObjectSetInteger(0,"stopEa_jc",OBJPROP_BGCOLOR,clrRed);
               // Alert("操作成功！");

              }
            if(!isOpenGolden)
              {
               isOpenGolden=true;
               ObjectSetString(0,"golden",OBJPROP_TEXT,"关闭入金自动解锁");
               ObjectSetInteger(0,"golden",OBJPROP_BGCOLOR,clrRed);
               Alert("操作成功！");
              }
            else
               if(isOpenGolden)
                 {
                  isOpenGolden=false;
                  ObjectSetString(0,"golden",OBJPROP_TEXT,"开启入金自动解锁");
                  ObjectSetInteger(0,"golden",OBJPROP_BGCOLOR,clrDarkOliveGreen);
                  Alert("操作成功！");
                 }
           }

        }
      if(sparam=="shouDongJS")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            ziDongJieSuo(true);
           }

        }


     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  clearZY()
  {
   int total = OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderTakeProfit()!=0 || OrderStopLoss()!=0)
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),0,0,0,clrYellow))
                 {
                  Alert("清除止盈/损"+OrderTicket()+"失败");
                  Print("Error in OrderModify. Error code=",GetLastError());

                 }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeOrderZY(int type)
  {
   int total = OrdersTotal();
   double thisProfit=0;
   double t_lots = 0;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            thisProfit=thisProfit+OrderProfit()+OrderCommission()+OrderSwap();
            t_lots = OrderLots()+t_lots;
            if(OrderType()==type && type==OP_BUY)
              {
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,clrDimGray))
                 {
                  Alert("关闭订单"+OrderTicket()+"失败");
                  Print("Error in Close. Error code=",GetLastError());

                 }
              }
            if(OrderType()==type && type==OP_SELL)
              {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,clrDimGray))
                 {
                  Alert("关闭订单"+OrderTicket()+"失败");
                  Print("Error in Close. Error code=",GetLastError());

                 }
              }
           }
        }
     }
   if(thisProfit!=0)
     {
      thisProfit=t_lots*cc_profit_points-thisProfit;
      zhiSun(thisProfit);

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zhiSun(double jinE)
  {
   Alert(jinE);
   double this_pofit = jy.profitBySymbolTotal(Symbol());
   double buy_v = jy.totalVolumeBySymbol(Symbol(),OP_BUY);
   double sell_v=jy.totalVolumeBySymbol(Symbol(),OP_SELL);
   double n_profit;
   double this_v;
   int this_point;
   int total = OrdersTotal();
   if(buy_v>sell_v)
     {
      this_v=buy_v-sell_v;

      if(jinE>this_pofit) //止盈
        {
         n_profit = MathAbs(jinE-this_pofit);
         this_point = n_profit/this_v;
         Alert(this_point);
         for(int i=total-1; i>=0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS))
              {
               if(OrderSymbol()==Symbol())
                 {
                  if(OrderType()==OP_BUY)
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),0,Ask+this_point*Point(),0,clrDarkBlue))
                       {
                        Print("OrderModify failed with error #",GetLastError());
                        Alert("修改订单"+OrderTicket()+"失败："+GetLastError());
                       }
                    }
                  if(OrderType()==OP_SELL)
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid+this_point*Point(),0,0,clrDarkBlue))
                       {
                        Print("OrderModify failed with error #",GetLastError());
                        Alert("修改订单"+OrderTicket()+"失败："+GetLastError());
                       }
                    }
                 }
              }

           }
        }
      if(jinE<this_pofit) //止损
        {
         n_profit = MathAbs(this_pofit-jinE);
         this_point = n_profit/this_v;
         Alert(this_point);
         for(int i=total-1; i>=0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS))
              {
               if(OrderSymbol()==Symbol())
                 {
                  if(OrderType()==OP_BUY)
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask-this_point*Point(),0,0,clrDarkBlue))
                       {
                        Print("OrderModify failed with error #",GetLastError());
                        Alert("修改订单"+OrderTicket()+"失败："+GetLastError());
                       }
                    }
                  if(OrderType()==OP_SELL)
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),0,Bid-this_point*Point(),0,clrDarkBlue))
                       {
                        Print("OrderModify failed with error #",GetLastError());
                        Alert("修改订单"+OrderTicket()+"失败："+GetLastError());
                       }
                    }
                 }
              }

           }
        }
     }
   if(buy_v<sell_v)
     {
      this_v=sell_v-buy_v;

      if(jinE>this_pofit) //止盈
        {
         n_profit = MathAbs(jinE-this_pofit);
         this_point = n_profit/this_v;
         Alert(this_point);
         for(int i=total-1; i>=0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS))
              {
               if(OrderSymbol()==Symbol())
                 {
                  if(OrderType()==OP_BUY)
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask-this_point*Point(),0,0,clrDarkBlue))
                       {
                        Print("OrderModify failed with error #",GetLastError());
                        Alert("修改订单"+OrderTicket()+"失败："+GetLastError());
                       }
                    }
                  if(OrderType()==OP_SELL)
                    {
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),0,Bid-this_point*Point(),0,clrDarkBlue))
                       {
                        Print("OrderModify failed with error #",GetLastError());
                        Alert("修改订单"+OrderTicket()+"失败："+GetLastError());
                       }
                    }
                 }
              }

           }
        }
     }
   if(jinE<this_pofit) //止损
     {
      n_profit = MathAbs(this_pofit-jinE);
      this_point = n_profit/this_v;
      Alert(this_point);
      for(int i=total-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(OrderSymbol()==Symbol())
              {
               if(OrderType()==OP_BUY)
                 {
                  if(!OrderModify(OrderTicket(),OrderOpenPrice(),0,Ask+this_point*Point(),0,clrDarkBlue))
                    {
                     Print("OrderModify failed with error #",GetLastError());
                     Alert("修改订单"+OrderTicket()+"失败："+GetLastError());
                    }
                 }
               if(OrderType()==OP_SELL)
                 {
                  if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid+this_point*Point(),0,0,clrDarkBlue))
                    {
                     Print("OrderModify failed with error #",GetLastError());
                     Alert("修改订单"+OrderTicket()+"失败："+GetLastError());
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
void shouDan()
  {
   if(jy.CheckOrderByaSymbol(Symbol())==0)
     {
      if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,0)<0)
        {
         Alert("发送订单失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
      if(OrderSend(Symbol(),OP_BUY,0.02,Ask,3,0,0,mark,0)<0)
        {
         Alert("发送订单失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
      if(OrderSend(Symbol(),OP_BUY,0.01,Ask,3,0,0,mark,0)<0)
        {
         Alert("发送订单失败！");
         Print("OrderSend failed with error #",GetLastError());
        }

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void createLabel()
  {
   label2("最大浮亏",340,20,"最大浮亏:");
   label2("Max_FuKui",460,20,"0");
   label2("当前浮亏",560,20,"当前浮亏:");
   label2("N_FuKui",680,20,"0");

   label2("多单手数",340,50,"多单手数:");
   label2("Buy_lots",460,50,"0");
   label2("空单手数",560,50,"空单手数:");
   label2("Sell_lots",680,50,"0");

   label2("总手数",340,80,"总 手 数:");
   label2("All_Lots",460,80,"0");
   label2("净值/余额",560,80,"净值/余额:");
   label2("BL",690,80,"0");

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void fuKui()
  {

   nFk= NormalizeDouble(AccountProfit(),2);

   if(maxFk>nFk)
     {
      maxFk=nFk;
     }
   ObjectSetText("Max_FuKui",maxFk,20,"Arial",clrLightGoldenrod);
   ObjectSetText("N_FuKui",nFk,20,"Arial",clrLightGoldenrod);
  }
//+------------------------------------------------------------------+
void ziDongJieSuo(bool isShouDong)
  {
   if(isSuoCang && isOpenGolden)
     {
      double balance = AccountBalance();
      double old_balance = GlobalVariableGet(AccountNumber()+"balance");
      Alert("目前账户余额："+balance);
      Alert("缓存账户余额："+old_balance);
      if(balance>old_balance) //自动解仓
        {
         closeLastOrder();
        }

     }
   if(isShouDong && isSuoCang) //手动解仓
     {
      closeLastOrder();
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeLastOrder()
  {
   int totals = OrdersTotal();
   for(int i = totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderComment()==sc_mark)
              {
               if(OrderType()==OP_BUY)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,clrIndigo))
                    {
                     Alert("解锁订单失败！");
                     Print("OrderSend failed with error #",GetLastError());
                    }
                  else
                    {
                     isJS=true;
                     isSuoCang=false;
                     stopEa_jc=false;
                     ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"停止加仓") ;
                     ObjectSetInteger(0,"stopEa_jc",OBJPROP_BGCOLOR,clrDarkOliveGreen);
                     GlobalVariableDel(AccountNumber()+"balance");
                     ObjectSetString(0,"suoCang",OBJPROP_TEXT,"锁仓") ;
                     ObjectSetInteger(0,"suoCang",OBJPROP_BGCOLOR,clrDarkOliveGreen);
                     stopEa=false;
                     ObjectSetString(0,"stopEa",OBJPROP_TEXT,"暂停EA") ;
                     ObjectSetInteger(0,"stopEa",OBJPROP_BGCOLOR,clrDarkOliveGreen);
                    }


                 }
               if(OrderType()==OP_SELL)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,clrIndigo))
                    {
                     Alert("解锁订单失败！");
                     Print("OrderSend failed with error #",GetLastError());
                    }
                  else
                    {
                     isJS=true;
                     isSuoCang=false;
                     stopEa=false;
                     stopEa_jc=false;
                     ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"停止加仓") ;
                     ObjectSetInteger(0,"stopEa_jc",OBJPROP_BGCOLOR,clrDarkOliveGreen);
                     GlobalVariableDel(AccountNumber()+"balance");
                     ObjectSetString(0,"suoCang",OBJPROP_TEXT,"锁仓") ;
                     ObjectSetInteger(0,"suoCang",OBJPROP_BGCOLOR,clrDarkOliveGreen);
                     ObjectSetString(0,"stopEa",OBJPROP_TEXT,"暂停EA") ;
                     ObjectSetInteger(0,"stopEa",OBJPROP_BGCOLOR,clrDarkOliveGreen);
                    }

                 }
              }
            else
              {
               Alert("最新订单非锁仓订单，请检查订单");
              }
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
void initialize()
  {
   if(jy.CheckOrderByaSymbol(Symbol())==0)
     {
      isBadRule=false;//是否已经存在破坏加仓规则
      open_touch=false;//平单触发
      ObjectSetString(0,"openTrig",OBJPROP_TEXT,"平单触发开") ;
      ObjectSetInteger(0,"openTrig",OBJPROP_BGCOLOR,clrDarkOliveGreen);

      stopEa_jc=false;//停止加仓
      ObjectSetString(0,"stopEa_jc",OBJPROP_TEXT,"停止加仓") ;
      ObjectSetInteger(0,"stopEa_jc",OBJPROP_BGCOLOR,clrDarkOliveGreen);

      stopEa=false;//暂停EA
      ObjectSetString(0,"stopEa",OBJPROP_TEXT,"暂停EA") ;
      ObjectSetInteger(0,"stopEa",OBJPROP_BGCOLOR,clrDarkOliveGreen);

      isOpenGolden = false;//开启入金自动解锁标识
      ObjectSetString(0,"golden",OBJPROP_TEXT,"开启入金自动解锁") ;
      ObjectSetInteger(0,"golden",OBJPROP_BGCOLOR,clrDarkOliveGreen);

      isJS = false;//是否解锁
      isSuoCang = false;//是否锁仓
      ObjectSetString(0,"suoCang",OBJPROP_TEXT,"锁仓") ;
      ObjectSetInteger(0,"suoCang",OBJPROP_BGCOLOR,clrDarkOliveGreen);

      GlobalVariableDel(AccountNumber()+"balance");

     }
  }
  
//+------------------------------------------------------------------+
