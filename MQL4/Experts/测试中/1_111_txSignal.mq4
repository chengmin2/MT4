//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


extern   int   magic=512332;
extern string EAComment= "tx_signal";
extern   double 手数=0.1;
extern   int    止损=200;
extern   int    止盈=1000;
input int     risk= 0;//risk: 0-->fixed lots
extern   bool   移动止损开关=true;
extern   int    移损启动点数=400;
extern   double  移损间隔=100;
extern   double  加仓倍数=1.1;
extern   int     加仓次数=5;
extern   int     加仓间隔=100;
extern   double  profit=10;//出仓利润
extern   int     nk=10;   // 止损后多少K线不开仓
extern int signal = 6;//同向信号间隔小于_跟K线开仓

int buySignal=0;
int sellSignal=0;
bool  up(int i)
  {
   //double a=iCustom(Symbol(),0,"Arrow_Alert",".....CO_TRADING_SYSTEM_FOREX.....",".....Powered_Trend_Signal_Arrow_Alert.....",12,0,3,Aqua,Yellow,233,234,0,"alert2.wav",1,True,True,True,True,0,1);
   //double b=iCustom(Symbol(),0,"ADF",50,200,14,True,0,1);
   double a;
   double b;
   int Arrow_Alert;
   int ADF;
   if(signal>=1)
     {
      for(int j=1; j<signal+1; j++)
        {
         if(a==0 || a==EMPTY_VALUE)
            a = iCustom(Symbol(),0,"Arrow_Alert",".....CO_TRADING_SYSTEM_FOREX.....",".....Powered_Trend_Signal_Arrow_Alert.....",12,0,3,Aqua,Yellow,233,234,0,"alert2.wav",1,True,True,True,True,0,j);
         if(b==EMPTY_VALUE)
            b=iCustom(Symbol(),0,"ADF",50,200,14,True,0,j);
            if(a!=0 && a!=EMPTY_VALUE && j==1){
             Arrow_Alert=j;
            }
            if(b!=EMPTY_VALUE && j==1){
            ADF=j;
            }
         if(a!=0 && a!=EMPTY_VALUE && b!=EMPTY_VALUE)
           {
            printf("买涨信号");
            if(buySignal==0)
               buySignal++;
            break;
           }
        }
     }
   if(a!=0 && a!=EMPTY_VALUE && b!=EMPTY_VALUE && buySignal==1 && (Arrow_Alert==1 || ADF==1)){
   Arrow_Alert =0;
      return true;
   }
   
   else{
   ADF=0;
    return false;
   }
      
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool  down(int i)
  {
   //double a=iCustom(Symbol(),0,"Arrow_Alert",".....CO_TRADING_SYSTEM_FOREX.....",".....Powered_Trend_Signal_Arrow_Alert.....",12,0,3,Aqua,Yellow,233,234,0,"alert2.wav",1,True,True,True,True,1,1);
   //double b=iCustom(Symbol(),0,"ADF",50,200,14,True,1,1);
      int Arrow_Alert;
   int ADF;
   double a;
   double b;
   if(signal>=1)
     {
      for(int j=1; j<signal+1; j++)
        {
         if(a==0 || a==EMPTY_VALUE)
            a = iCustom(Symbol(),0,"Arrow_Alert",".....CO_TRADING_SYSTEM_FOREX.....",".....Powered_Trend_Signal_Arrow_Alert.....",12,0,3,Aqua,Yellow,233,234,0,"alert2.wav",1,True,True,True,True,1,j);
         if(b==EMPTY_VALUE)
            b=iCustom(Symbol(),0,"ADF",50,200,14,True,0,j);
            
            if(a!=0 && a!=EMPTY_VALUE && j==1){
             Arrow_Alert=j;
            }
            if(b!= EMPTY_VALUE && j==1){
            ADF=j;
            }
         if(a!=0 && a!=EMPTY_VALUE && b!=EMPTY_VALUE)
           {
              printf("买跌信号");
            if(sellSignal==0)
               sellSignal++;
            break;
           }
        }
     }
   if(a!=0 && a!=EMPTY_VALUE && b!=EMPTY_VALUE && buySignal==1 && (Arrow_Alert==1 || ADF==1)){
   Arrow_Alert =0;
      return true;
   }
   
   else{
   ADF=0;
    return false;
   }
  }


int OnInit()
  {

   EventSetTimer(1);

//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();

  }
datetime alarm=0;
void OnTick()
  {
   if(alarm!=Time[0])
     {
      close();
      if(buySignal>=signal)
        {
         buySignal=0;
        }
      else if(buySignal>0)
        {
         buySignal++;
        }
      if(sellSignal>=signal)
        {
         sellSignal=0;
        }
      else if(sellSignal>0)
        {
         sellSignal++;
        }

      int shu=danshu(OP_BUY)+danshu(OP_SELL);
      double buyopying,buylotsying;
      int buydanshuying=buydanshu(buyopying,buylotsying,magic);//
      double sellopying,selllotsying;
      int selldanshuying=selldanshu(sellopying,selllotsying,magic);//
      if(up(1) && last_time())
        {
        printf("涨单开仓");
         if(shu==0) //指标出现涨单的信号，目前持仓数为0，
           {
            buy(GetLots(),止损,止盈,EAComment,magic);
           }
        
        }else

      if(down(1) && last_time())
        {
         if(shu==0)
           {
              printf("跌单开仓");
            sell(GetLots(),止损,止盈,EAComment,magic);
           }
         

        }

            if((buyopying-Ask)>=加仓间隔*Point())
              {
               if(buy(NormalizeDouble(last_lot(OP_BUY)*加仓倍数,2),止损,止盈,EAComment+IntegerToString(danshu(OP_BUY)),magic)>0)
                 {
                  修改止损(last_sl(OP_BUY));
                 }
              }

            if( (Bid-sellopying)>=加仓间隔*Point())
              {
               if(sell(NormalizeDouble(last_lot(OP_SELL)*加仓倍数,2),止损,止盈,EAComment+IntegerToString(danshu(OP_SELL)),magic)>0)
                 {
                  修改止损(last_sl(OP_SELL));
                 }
              }



      if(移动止损开关==true)
         移动止损();

      alarm=Time[0];

     }
  }

int  upshu=0;
int  downshu=0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   int orderTotal = OrdersTotal();
   if(yingkui(OP_BUY)>profit)
     {
      while(totalOrderByType(OP_BUY)>0)
        {
         for(int i=orderTotal-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(Symbol()==OrderSymbol() && OrderType()==OP_BUY)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Bid,3,clrRed);
                 }

              }
           }
        }

     }
   if(yingkui(OP_SELL)>profit)
     {
      while(totalOrderByType(OP_SELL)>0)
        {
         for(int i=orderTotal-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(Symbol()==OrderSymbol() && OrderType()==OP_SELL)
                 {
                  OrderClose(OrderTicket(),OrderLots(),Ask,3,clrRed);
                 }

              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int totalOrderByType(int type)
  {
   int orderTotal = OrdersTotal();
   for(int i=orderTotal-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(Symbol()==OrderSymbol() && OrderType()==type && OrderMagicNumber()==magic)
           {
            return 1;
           }

        }
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int danshu(int ty)
  {
   int  a=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==ty)
           {
            a++;
           }
        }
     }
   return a;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double last_lot(int ty)
  {
   double  a=0;
   if(OrderSelect(tk(ty),SELECT_BY_TICKET)==true)
     {
      a=OrderLots();
     }

   return a;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double last_sl(int ty)
  {
   double  a=0;
   if(OrderSelect(tk(ty),SELECT_BY_TICKET)==true)
     {
      a=OrderStopLoss();
     }

   return a;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool last_time()
  {
   bool  a=false;
   int time=0;
   int order_h = OrdersHistoryTotal();
   for(int i=order_h-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
           {
            time=iBarShift(NULL,0,OrderCloseTime());
            break;
           }
        }
      if(OrderCloseTime()<Time[nk])
         break;
     }
   if(time>nk)//距离nk跟k线之后
     {
      a=true;
     }
   if(time==0)
     {
      a=true;
     }

   return a;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int tk(int ty)
  {
   int  a=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==ty)
           {
            a=OrderTicket();
            break;
           }
        }
     }
   return a;
  }





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double yingkui(int ty)
  {
   double  a=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==ty)
           {
            a=OrderProfit()+OrderCommission()+OrderSwap();
           }
        }
     }
   return a;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 修改止损(double sl)
  {
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderStopLoss()!=NormalizeDouble(sl,Digits))
           {
            bool a=OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(sl,Digits),OrderTakeProfit(),0);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 移动止损()
  {
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==0 && OrderMagicNumber()==magic)
           {
            if(OrderClosePrice()-OrderOpenPrice()>=移损启动点数*Point)
              {
               double 移损= OrderOpenPrice()+移损间隔*Point;
               if(OrderStopLoss()==0 || NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(移损,Digits))
                 {
                  bool a= OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(移损,Digits),OrderTakeProfit(),0);
                 }
              }
           }

         if(OrderSymbol()==Symbol() && OrderType()==1 && OrderMagicNumber()==magic)
           {
            if(OrderOpenPrice()-OrderClosePrice()>=移损启动点数*Point)
              {
               double 移损=OrderOpenPrice()-移损间隔*Point;
               if(OrderStopLoss()==0 || NormalizeDouble(OrderStopLoss(),Digits)>NormalizeDouble(移损,Digits))
                 {
                  bool a= OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(移损,Digits),OrderTakeProfit(),0);
                 }
              }
           }
        }
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int op()
  {
   int op=-1;
   datetime objtime=0;
   string  name="";
   string  a="";
   int tishi=0;
   for(int i=ObjectsTotal()-1; i>=0; i--)
     {
      name=ObjectName(i);
      objtime=(datetime)ObjectGet(name,OBJPROP_TIME1);
      if(objtime==Time[1] && StringFind(name,"vtsbh")>=0)
        {
         a=name;
         break;
        }
      if(StringFind(name,"vtsbh")>=0)
        {
         tishi++;
        }
     }
   if(tishi==0)
      Alert("请在图表加载指标");

   if(ObjectGet(a,OBJPROP_ARROWCODE)==233)
      op=0;
   if(ObjectGet(a,OBJPROP_ARROWCODE)==234)
      op=1;
   return op;
  }

datetime  buytime,selltime;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int buy(double lots,double sl,double tp,string com,int buymagic)
  {
   int a=0;
   bool zhaodan=false;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         string zhushi=OrderComment();
         int ma=OrderMagicNumber();
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && zhushi==com && ma==buymagic)
           {
            zhaodan=true;
            break;
           }
        }
     }
   if(zhaodan==false)
     {
      if(sl!=0 && tp==0)
        {
         a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,0,com,buymagic,0,Red);
        }
      if(sl==0 && tp!=0)
        {
         a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,Ask+tp*Point,com,buymagic,0,Red);
        }
      if(sl==0 && tp==0)
        {
         a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,0,com,buymagic,0,Red);
        }
      if(sl!=0 && tp!=0)
        {
         a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point,Ask+tp*Point,com,buymagic,0,Red);
        }


     }
   return(a);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int sell(double lots,double sl,double tp,string com,int sellmagic)
  {
   int a=0;
   bool zhaodan=false;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         string zhushi=OrderComment();
         int ma=OrderMagicNumber();
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && zhushi==com && ma==sellmagic)
           {
            zhaodan=true;
            break;
           }
        }
     }
   if(zhaodan==false)
     {
      if(selltime!=Time[0])
        {
         if(sl==0 && tp!=0)
           {
            a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,0,Bid-tp*Point,com,sellmagic,0,Green);
           }
         if(sl!=0 && tp==0)
           {
            a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,0,com,sellmagic,0,Green);
           }
         if(sl==0 && tp==0)
           {
            a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,0,0,com,sellmagic,0,Green);
           }
         if(sl!=0 && tp!=0)
           {
            a=OrderSend(Symbol(),OP_SELL,lots,Bid,50,Bid+sl*Point,Bid-tp*Point,com,sellmagic,0,Green);
           }
         selltime=Time[0];
        }
     }
   return(a);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 平仓(int ty)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==ty)
           {
            bool a=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int buydanshu(double &op,double &lots,int bmagic)
  {
   int a=0;
   op=0;
   lots=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==bmagic)
           {
       
               a++;
               op=OrderOpenPrice();
               lots=OrderLots()+lots;
             
           }
        }
     }
   return(a);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int selldanshu(double &op,double &lots,int smagic)
  {
   int a=0;
   op=0;
   lots=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==smagic)
           {

           
               a++;
               op=OrderOpenPrice();
               lots=OrderLots()+lots;
              
           }
        }
     }
   return(a);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetLots()
  {
   double lot;
   double minlot=MarketInfo(Symbol(),MODE_MINLOT);
   double maxlot=MarketInfo(Symbol(),MODE_MAXLOT);
   if(risk!=0)
     {
      lot=NormalizeDouble(AccountBalance()*risk/100/10000,2);
      if(lot<minlot)
         lot=minlot;
      if(lot>maxlot)
         lot=maxlot;
     }
   else
      lot=手数;
   return(lot);
  }
//+------------------------------------------------------------------+
