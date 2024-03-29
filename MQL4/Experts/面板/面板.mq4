//+------------------------------------------------------------------+
//|                                                           面板.mq4 |
//|                                                       ChinaCheng |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "ChinaCheng"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int bj_width = 300;
int bj_high = 360;
int width;
int high=30;
int x=0;
int y=50;
int OnInit()
  {
   createLabel();
   背景("主面板",0,0,bj_width,bj_high);
   label("面板",0,0,"Matrix Panel");
   width = NormalizeDouble(bj_width/4,0);
   anNiu("止损",x,y,"止损",width,high);
   shuRuKuang("stopLoss",x+width,y,"200",width,high);
   anNiu("止盈",x+2*width,y,"止盈",width,high);
   shuRuKuang("takeProfit",x+3*width,y,"200",width,high);
   y=y+high;
   width = NormalizeDouble(bj_width/4,0);
   anNiu("挂单",x,y,"挂单点位:",width,high);
   shuRuKuang("guaDanDian",x+width,y,"200",width,high);
   anNiu("手数",x+2*width,y,"下单手数",width,high);
   shuRuKuang("volume",x+3*width,y,"0.01",width,high);
   y=y+high;
   width = NormalizeDouble(bj_width/2,0);
   anNiu("duo",x,y,"多单",width,high);
   anNiu("kong",x+width,y,"空单",width,high);
   y=y+high;
   width = NormalizeDouble(bj_width/4,0);
   anNiu("buyStop",x,y,"buyTop",width,high);
   anNiu("buyLimit",x+width,y,"buyLimt",width,high);
   anNiu("sellStop",x+2*width,y,"sellTop",width,high);
   anNiu("sellLimit",x+3*width,y,"sellLimt",width,high);
   y=y+high;
   width = NormalizeDouble(bj_width/4,0);
   anNiu("pingcang",x,y,"平当前货币",width,high);
   anNiu("pingduo",x+width,y,"平多单",width,high);
   anNiu("pingkong",x+2*width,y,"平空单",width,high);
   anNiu("pingGua",x+3*width,y,"删挂单",width,high);
   y=y+high;
   width = NormalizeDouble(bj_width/3,0);
   anNiu("closeAll",x,y,"平所有货币",width,high);
   anNiu("suoCang",x+width,y,"锁仓",width,high);
   anNiu("yiDongZhiYing",x+2*width,y,"移动止盈",width,high);
   y=y+high;
   width = NormalizeDouble(bj_width/2,0);
   anNiu("stopEa_jc",x,y,"停止加仓",width,high);
   anNiu("stopEa",x+width,y,"暂停EA",width,high);
   y=y+high;
   width = NormalizeDouble(bj_width/3,0);
   anNiu("openTrig",x,y,"平单触发开",width,high);
   anNiu("zhiSunJE",x+width,y,"金额止损/赢",width,high);
   anNiu("clearZhiYing",x+2*width,y,"清除止损/赢",width,high);
   y=y+high;
   width = NormalizeDouble(bj_width/2,0);
   anNiu("closeBuyOrder",x,y,"平多单计算止盈",width,high);
   anNiu("closeSellOrder",x+width,y,"平空单计算止盈",width,high);
   y=y+high;
   width = NormalizeDouble(bj_width/2,0);
   anNiu("golden",x,y,"开启入金自动解锁",width,high);
   anNiu("shouDongJS",x+width,y,"解锁",width,high);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
extern double volume=0.01;//起始手数
extern int magic=612973;//魔术号
input int SS_D=100;//顺势点
extern double profit=5;//初始出仓利润
input double min_unit=0.01;//最小计量单位
extern int ZS_P_S= 200;//移动止损点位
extern  int ZS_P_E =100;//移动止损点数
extern int maxDC = 100;//最大承受点差
string mark = "Matrix_pro";//标识
string sc_mark = "Matrix_pro_sc";//锁仓标识

extern bool isRGJS=false;//是否人工解锁
extern double sc_fengKong=0.8;//自动锁仓当前亏损最大比例
extern double equity=-500;//自动锁仓净利润值
extern double warning = 0.5;//净值/余额 报警值
extern bool open_touch=false;//平单触发
extern  bool stopEa_jc=false;//停止加仓
extern  bool stopEa=false;//暂停EA
extern  bool isOpenGolden = false;//开启入金自动解锁标识
extern int dingshi = 5;//定时设置
bool isJS = false;//是否解锁
bool isSuoCang = false;//是否锁仓
double nFk;
double maxFk;
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
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
      thisProfit=profit-thisProfit;
      zhiSun(thisProfit);

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
void 背景(string name,int x,int y,int width,int high)
  {
   ObjectCreate(0,name,OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrBlack);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,true);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,high);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,"");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrBlack);
   ObjectSetInteger(0,name,OBJPROP_ALIGN,ALIGN_LEFT);

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
void label(string name,int x,int y,string text)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSetText(name,text,30,"Arial",clrRed);
   ObjectSet(name,OBJPROP_CORNER,0);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void anNiu(string name,int x,int y,string text,int width,int high)                // priority for mouse click
  {
   const long              chart_ID=0;               // chart's ID
   const int               sub_window=0;             // subwindow index
// text
   const string            font="Arial";             // font
   const int               font_size=10;             // font size
   const color             clr=clrLightSeaGreen;             // text color
   const color             back_clr=C'236,233,216';  // background color
   const color             border_clr=clrNONE;       // border color
   const bool              state=false;              // pressed/released
   const bool              back=false;               // in the background
   const bool              selection=false;          // highlight to move
   const bool              hidden=true;             // hidden in the object list
   const long              z_order=0;
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set button size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,high);
//--- set the chart's corner, relative to which point coordinates are defined
//ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void shuRuKuang(string name,int x,int y,string text,int width,int high)                // priority for mouse click
  {
   const long             chart_ID=0;               // chart's ID
// const string           name="Edit",              // object name
// const int              sub_window=0;            // subwindow index
// const string           text="Text";              // text
   const string           font="Arial";             // font
   const int              font_size=10;             // font size
   const ENUM_ALIGN_MODE  align=ALIGN_CENTER;       // alignment type
   const bool             read_only=false;          // ability to edit
   const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER; // chart corner for anchoring
   const color            clr=clrBlack;             // text color
   const color            back_clr=clrWhite;        // background color
   const color            border_clr=clrNONE;       // border color
   const bool             back=false;               // in the background
   const bool             selection=false;          // highlight to move
   const bool             hidden=true;            // hidden in the object list
   const long             z_order=0;
   ObjectCreate(0,name,OBJ_EDIT,0,0,0);
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set object size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,high);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the type of text alignment in the object
   ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
//--- enable (true) or cancel (false) read-only mode
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
//--- set the chart's corner, relative to which object coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);

   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);

   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);

  }
//+------------------------------------------------------------------+
