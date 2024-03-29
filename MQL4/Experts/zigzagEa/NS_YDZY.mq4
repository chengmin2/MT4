//+------------------------------------------------------------------+
//|                                                      NS_YDZY.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
datetime alarm=0;
extern int magic=123456;//魔术号
extern bool isJC=false;//是否开启逆势加仓
input double volume=0.02;//起始手数
input double m_volume=0.01;//最小单位
extern double cc_profit=4;//出仓利润
input int jc_point=100;//逆势加仓点位
string mark = "Matrix_NS_YDZY";//标识

extern int jc_points =700;//趋势加仓点位
extern  int weiXin=100;//微型账户1标准手缩小倍数
extern int jc_jisu=2;//加仓基数
int jc_cs = 1;//加仓计数
extern int cc_profit_points=100;//出仓利润点
extern int qiDong = 20;//启动趋势单量
extern double kuiSun = -200;//亏损启动
extern int time_zq=1;//时间间隔大小
extern  int kshu=30;//k线数
bool start_fb=true;//是否加载斐波那契数组
input double accountType=1;//账户类型（美元:1;美角:0.1）
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
//---

//---
   EventSetTimer(1);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTimer()
  {

   touchYJPD();
   getMagic();//获取魔术号


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      shouDan();
      nsJY();
      alarm=Time[0];
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double openP;
void nsJY()
  {
   int totals = OrdersTotal();
   double thisLots = volume;
   int thisOrder = jy.CheckOrderByaSymbol(Symbol());
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            double lots = OrderLots();
            double openPrice = OrderOpenPrice();
            double ticket = OrderTicket();
            if(jc_cs==1){
              closeNs();
            if(OrderType()==OP_BUY && openPrice-Ask>=jc_point*Point())
              {
               Print("上一单订单号："+ticket);
               Print("上一单开盘价："+openPrice);
               if(thisOrder>7 && isJC)
                 {
                  thisLots=thisOrder*m_volume+lots;
                 }
               OrderSend(Symbol(),OP_BUY,thisLots,Ask,3,0,0,mark,magic,0,clrRed);
              }
            else
               if(OrderType()==OP_SELL && Bid-openPrice>=jc_point*Point())
                 {
                  Print("上一单订单号："+ticket);
                  Print("上一单开盘价："+openPrice);
                  if(thisOrder>7 && isJC)
                    {
                     thisLots=thisOrder*m_volume+lots;
                    }
                  OrderSend(Symbol(),OP_SELL,thisLots,Bid,3,0,0,mark,magic,0,clrRed);
                 }
            
            }
             if(AccountProfit()<kuiSun)
               {
                if(jc_cs==1)
                  {
                   firstJC();
                  }

               }
             if(jc_cs!=1)
               {
                jiaCang();
                close();
               }
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
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
   else
      if(buy_lots<sell_lots)
        {
         OrderSend(Symbol(),OP_BUY,2*sell_lots,Ask,3,0,0,mark,magic,0,clrRed);
         jc_cs++;
        }
   Print("买单手数："+jy.totalVolumeBySymbol(Symbol(),OP_BUY));
   Print("跌单手数："+jy.totalVolumeBySymbol(Symbol(),OP_SELL));
   Print("当前利润为："+jy.profitBySymbolTotal(Symbol()));
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
void closeNs()
  {
   double thisProfit = jy.profitBySymbolTotal(Symbol());
   if(thisProfit>cc_profit)
     {
      zhiSun(thisProfit/2);
      cc_profit = thisProfit;
     }
   double thisVolume = jy.totalVolumeBySymbol(Symbol(),OP_BUY)+jy.totalVolumeBySymbol(Symbol(),OP_SELL);
   if(jy.profitBySymbolTotal(Symbol())>thisVolume*cc_profit_points/weiXin)
     {
      jy.ColseOrderBySymbol(Symbol());
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void getMagic()
  {
   if(jy.CheckOrderByaSymbol(Symbol())==0)
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
   if(start_fb)
     {
      /* if(ObjectFind("斐波那奇_时间_1"))
         {

          ObjectDelete(ObjectName("斐波那奇_时间_1"));
         }*/
      fb_kj();  //加载斐波那契时间间隔数组

     }

   if(jy.CheckOrderByaSymbol(Symbol())==0)
     {
      fb_xd();
     }

  }


//+------------------------------------------------------------------+
datetime time_fb[5];//时间间隔数组
double price_fb[8]= {0,0.236,0.382,0.5,0.618,0.764,0.868,1};//价格间隔数组
int sj_kShu;//k线数筛选
double kj_level;//高低两点空间间隔价格
int time_fb_js[5]= {0,1,2,3,5};//时间间隔数组

int h_b;//获取kshu数种最高价的bar柱位置
int l_b;//获取kshu数种最低价的bar柱数位置
double h_b_p;//最高价
double l_b_p;//最低价
void  fb_kj()
  {

   for(int i=2; i<10000; i++)
     {

      h_b = iHighest(Symbol(),time_zq,MODE_HIGH,kshu,i);
      l_b = iLowest(Symbol(),time_zq,MODE_LOW,kshu,i);
      if(h_b!=0 && l_b!=0 && h_b!=l_b)
        {
         h_b_p=iHigh(Symbol(),time_zq,h_b);
         l_b_p=iLow(Symbol(),time_zq,l_b);
         break;
        }

     }
   datetime h_t = Time[h_b];//最高价时间
   datetime l_t = Time[l_b];//最低价时间
   if(h_t<l_t)//高价在前
     {
      // ObjectCreate("斐波那奇_回调_1",OBJ_FIBO,0,h_t,h_b_p,l_t,l_b_p);
      ObjectCreate("斐波那奇_时间_1",OBJ_FIBOTIMES,0,h_t,h_b_p,l_t,l_b_p);

     }
   if(h_t>l_t)//低价在前
     {
      //ObjectCreate("斐波那奇_回调_1",OBJ_FIBO,0,l_t,l_b_p,h_t,h_b_p);
      ObjectCreate("斐波那奇_时间_1",OBJ_FIBOTIMES,0,l_t,l_b_p,h_t,h_b_p);
     }
   for(int i=0; i<ArraySize(time_fb_js); i++)
     {
      if(l_t>h_t)
        {
         time_fb[i]=h_t+time_fb_js[i]*time_zq*60*MathAbs(h_b-l_b);
        }
      if(l_t<h_t)
        {
         time_fb[i]=l_t+time_fb_js[i]*time_zq*60*MathAbs(h_b-l_b);
        }
     }
   start_fb=false;

  }
//+------------------------------------------------------------------+
void fb_xd()
  {
   if(jy.CheckOrderByaSymbol(Symbol())==0)
     {
      for(int i=0; i<ArraySize(time_fb); i++)
        {
         if(Time[1]>time_fb[4])
           {
            start_fb=true;
            return;
           }
         if(time_fb[i]==Time[0])
           {

            //double bfb_S=NormalizeDouble((Bid-l_b_p)/kj_level,3);
            //double bfb_b=NormalizeDouble((Ask-l_b_p)/kj_level,3);
            int h1= iHighest(Symbol(),time_zq,MODE_HIGH,time_zq,time_zq);
            int h2= iHighest(Symbol(),time_zq,MODE_HIGH,time_zq,2*time_zq);
            int h3= iHighest(Symbol(),time_zq,MODE_HIGH,time_zq,3*time_zq);
            double  h1_p=iHigh(Symbol(),time_zq,h1);
            double  h2_p=iHigh(Symbol(),time_zq,h2);
            double  h3_p=iHigh(Symbol(),time_zq,h3);

            int l1= iLowest(Symbol(),time_zq,MODE_LOW,time_zq,time_zq);
            int l2= iLowest(Symbol(),time_zq,MODE_LOW,time_zq,2*time_zq);
            int l3= iLowest(Symbol(),time_zq,MODE_LOW,time_zq,3*time_zq);
            double  l1_p=iLow(Symbol(),time_zq,l1);
            double  l2_p=iLow(Symbol(),time_zq,l2);
            double  l3_p=iLow(Symbol(),time_zq,l3);

            double o1= Open[time_zq];
            double o2= Open[2*time_zq];
            double o3= Open[3*time_zq];

            double c1= Close[time_zq];
            double c2= Close[2*time_zq];
            double c3= Close[3*time_zq];
            if(h1_p>h2_p>h3_p || (c1>o1 && c2>o2 && c3>o3))
              {
               int ticket = OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic);

               printf("斐波那契指标开仓");

              }
            else
               if(l1_p<l2_p<l3_p || (c1<o1 && c2<o2 && c3<o3))
                 {
                  int ticket=OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic);
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
void touchYJPD()
  {
   int total = OrdersHistoryTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderMagicNumber()==magic && magic!=0)
              {
               jy.ColseOrderBySymbol(Symbol());
              }
            break;
           }

        }
     }
  }
//+------------------------------------------------------------------+
void close()
  {
   double totalVolume =MathAbs(jy.totalVolumeBySymbol(Symbol(),OP_BUY)-jy.totalVolumeBySymbol(Symbol(),OP_SELL));
   double thisProfit= totalVolume*cc_profit_points/weiXin;

   if(jy.profitBySymbolTotal(Symbol())>thisProfit)
     {
      ColseOrderBySymbol();
     }
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

                 }

               if(OrderType()==OP_SELL)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,Red))
                    {
                     Print("OrderClose failed with error #",GetLastError());
                     Alert("关闭订单"+OrderTicket()+"失败："+GetLastError());
                     SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"关闭订单"+OrderTicket()+"失败");
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

  }
//+------------------------------------------------------------------+
