//+------------------------------------------------------------------+
//|                                                 niShiJiaCnag.mq4 |
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
datetime alarm=0;
input int magic=612973;//魔术号
input double volume=0.1;//起始手数
extern bool isTimeAstict = true;//是否开启时间段限制
extern int XZ_H = 21;//时间分割线
extern int XZ_H_2 = 24;//时间分割线2
extern int jiaCangJianGe=50;//加仓间隔
extern int zhishun=300;//止损
extern int maxDC = 25;//最大承受点差
string mark = "Matrix_NJ_PL";//标识
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {

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
double totalVolume=0;
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      close();
      kaiCang();




      alarm=Time[0];

     }


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input int ZS_P_S= 200;//移动止损点位
input int ZS_P_E =100;//移动止损点数
void close()
  {
  if(iCustom(Symbol(),0,"CCI",14,0,1)>200){
   jy.ColseOrderBySymbolType(Symbol(),OP_BUY);
  }
  if(iCustom(Symbol(),0,"CCI",14,0,1)<-200){
   jy.ColseOrderBySymbolType(Symbol(),OP_SELL);
  }
   if(TimeHour(Time[0])==0) {
     jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);
   return;}
   int order = jy.CheckOrderByaSymbol(Symbol());
   int od = OrdersTotal();
   if(order>1)
     {
      if(jy.profitBySymbolTotal(Symbol())>profit)
        {
         if(jy.ColseOrderBySymbol(Symbol())==0)
           {
            Print("OrderSend failed with error #",GetLastError());
            Alert("关闭交易出错！");
           }
        }
     }
   else
      if(order==1)
        {
         for(int i=od-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderSymbol()==Symbol())
                 {
                  if((OrderType()==OP_BUY && OrderProfit()>profit
                           && (iCustom(Symbol(),0,"CCI",14,0,1)>100 || iCustom(Symbol(),0,"RSI",14,0,1))>70)
                    
                    || OrderProfit()>zhiYin*volume)
                    {
                     if(jy.ColseOrderBySymbol(Symbol())==0)
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("关闭交易出错！");
                       }
                     break;

                    }
                  else
                     if((OrderType()==OP_SELL && OrderProfit()>profit && 
                            (iCustom(Symbol(),0,"CCI",14,0,1)<-100 ||  iCustom(Symbol(),0,"RSI",14,0,1)<30))
                      || OrderProfit()>zhiYin*volume)
                       {
                        if(jy.ColseOrderBySymbol(Symbol())==0)
                          {
                           Print("OrderSend failed with error #",GetLastError());
                           Alert("关闭交易出错！");
                          }
                        break;
                       }
                 }
              }

           }
        
        }

  }
extern double profit = 5;//利润
extern int zhiYin = 100;//止盈点
extern int jiaCangCiShu = 2;//加仓次数
void kaiCang()
  {
  if(TimeDayOfWeek(Time[0])==5 && TimeHour(Time[0])>=23) return;
   double  rsi_1 =  iCustom(Symbol(),0,"RSI",14,0,1);
   double  rsi_2 =  iCustom(Symbol(),0,"RSI",14,0,2);
   double  cci_1 =  iCustom(Symbol(),0,"CCI",14,0,1);
   double  cci_2 =  iCustom(Symbol(),0,"CCI",14,0,2);
   int od = OrdersTotal();
   if(isTimeAstict)
     {
      if(TimeHour(Time[0])<XZ_H || TimeHour(Time[0])>XZ_H_2)
        {
         return;
        }
     }
   if(rsi_2>30 && rsi_1<30 && cci_1<-100)
     {
      if(Ask-Bid>maxDC*Point())
         return;
      int buyOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_BUY);
      if(buyOrder<jiaCangCiShu)
        {
         if(buyOrder==0)
           {
            if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,Bid-zhishun*Point(),0,mark,magic,clrRed)<0)
              {
               Alert("订单发送失败！");
               Print("OrderSend failed with error #",GetLastError());
              }
           }
         for(int i=od-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
              {
               if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                 {
                  if(OrderOpenPrice()-Ask>jiaCangJianGe*Point())
                    {
                     if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,Bid-zhishun*Point(),0,mark,magic,clrRed)<0)
                       {
                        Alert("订单发送失败！");
                        Print("OrderSend failed with error #",GetLastError());
                       }
                    }

                  break;
                 }
              }
           }


        }



     }
   else
      if(rsi_2<70 && rsi_1>70 && cci_1>100)//sell
        {
         if(Ask-Bid>maxDC*Point())
            return;
         int sellOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_SELL);
         if(sellOrder<jiaCangCiShu)
           {
            if(sellOrder==0)
              {
               if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,Ask+zhishun*Point(),0,mark,magic,clrRed)<0)
                 {
                  Alert("订单发送失败！");
                  Print("OrderSend failed with error #",GetLastError());

                 }
              }
            for(int i=od-1; i>=0; i--)
              {
               if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                 {
                  if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                    {
                     if(Bid-OrderOpenPrice()>jiaCangJianGe*Point())
                       {
                        if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,Ask+zhishun*Point(),0,mark,magic,clrRed)<0)
                          {
                           Alert("订单发送失败！");
                           Print("OrderSend failed with error #",GetLastError());

                          }
                       }
                     break;
                    }
                 }
              }

           }


        }







  }
//+------------------------------------------------------------------+
