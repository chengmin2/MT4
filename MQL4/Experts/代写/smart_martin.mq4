//+------------------------------------------------------------------+
//|                                                      TIME_QC.mq4 |
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

extern double volume=0.01;//起始手数
input int dingshi = 1;//定时设置
extern double zhiYinJinE = 20;//止盈金额
extern double zhiSunJinE = -6;//止损金额
extern int jiaCangBeiShu = 2;//加仓倍数
extern double niShiJiaCangJinE = -5;//逆势加仓启动金额
extern double move_start = 5;//初始移动止损启动利润
extern double getMoney_start = 4;//初始移动止损保留利润
extern double move = 2;//移动止损启动利润
extern double getMoney = 1;//移动止损保留利润
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   EventSetTimer(dingshi);
   return(INIT_SUCCEEDED);

  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
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
//| Expert tick function                                             |
//+------------------------------------------------------------------+
datetime alarm=0;
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {

      OnTimer();

      alarm=Time[0];

     }

  }

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   shouDan();
   jiaCang();
   mobileStopLoss();
   close();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   int totals = OrdersTotal();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(Symbol()==OrderSymbol())
           {
            double thisProfit = OrderProfit()+OrderCommission()+OrderSwap();
            if(thisProfit>=zhiYinJinE || thisProfit<=zhiSunJinE)
              {
               if(OrderType()==OP_BUY)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,Red))
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("关闭多单交易出错！");

                    }
                 }
               else
                  if(OrderType()==OP_SELL)
                    {
                     if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,Red))
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("关闭空单交易出错！");
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void shouDan()
  {
   int buyOrder = CheckOrderByaSymbolType(Symbol(),OP_BUY);
   int sellOrder = CheckOrderByaSymbolType(Symbol(),OP_SELL);
   if(buyOrder==0 && sellOrder==0)
     {
      if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,0,0,0,clrRed)<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         Alert("首单涨单发送失败："+GetLastError());
        }
      if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,0,0,0,clrRed)<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         Alert("首单跌单发送失败："+GetLastError());
        }

     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CheckOrderByaSymbolType(string symbol,int type) //检查订单中当前货币的单数
  {
   int  total=OrdersTotal();
   int rt=0;
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && OrderType()==type)
            rt++;
        }
     }
   return rt;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void jiaCang()
  {
   jiaCangType(OP_BUY);
   jiaCangType(OP_SELL);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void jiaCangType(int ty)
  {
   int total = OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(Symbol()==OrderSymbol())
           {
            int type = OrderType();
            double lots = OrderLots();
            double thisVolume;
            double s =  OrderProfit()+OrderCommission()+OrderSwap();
            if(type==OP_BUY && type==ty)
              {

               if(s<=niShiJiaCangJinE)//逆势加仓
                 {
                  thisVolume = jiaCangBeiShu*lots;
                  if(OrderSend(Symbol(),OP_BUY,thisVolume,Ask,3,0,0,0,0,0,clrRed)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("涨单发送失败："+GetLastError());
                    }
                  if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,0,0,0,clrRed)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("跌单发送失败："+GetLastError());
                    }
                 }

               break;

              }
            else
               if(type==OP_SELL && type==ty)
                 {

                  if(s<=niShiJiaCangJinE)//逆势加仓
                    {
                     thisVolume = jiaCangBeiShu*lots;
                     if(OrderSend(Symbol(),OP_SELL,thisVolume,Bid,3,0,0,0,0,0,clrRed)<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("跌单发送失败："+GetLastError());
                       }
                     if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,0,0,0,clrRed)<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("涨单发送失败："+GetLastError());
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
void mobileStopLoss()//移动止损
  {

   int  total=OrdersTotal();
   int rt=0;
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            double thisLr =  OrderProfit();
            double oderOpenPrice = OrderOpenPrice();
            double  newStopLoss;
            double stopLoss = OrderStopLoss();
            double thisLots = OrderLots();
            if(OrderType()==OP_BUY)
              {
               if(stopLoss==0)
                 {
                  if(thisLr>=move_start)
                    {
                     newStopLoss =  oderOpenPrice+(Ask-oderOpenPrice)*getMoney_start/move_start;
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,0,0,clrNONE))
                       {
                        Print("Error in OrderModify. Error code=",GetLastError());

                       }
                    }

                 }
               else
                  if(stopLoss!=0)
                    {
                     double yg_stopLossProfit = move*((stopLoss-oderOpenPrice)/Point()*thisLots-getMoney_start);
                     double thisDuoProfit = thisLr-yg_stopLossProfit;
                     if(thisDuoProfit>=move)
                       {
                        newStopLoss =  stopLoss+(thisDuoProfit*getMoney/move)/thisLots*Point();
                        if(!OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,0,0,clrNONE))
                          {
                           Print("Error in OrderModify. Error code=",GetLastError());

                          }
                       }

                    }

              }

            if(OrderType()==OP_SELL)
              {
               if(stopLoss==0)
                 {
                  if(thisLr>=move_start)
                    {
                     newStopLoss =  oderOpenPrice-(oderOpenPrice-Bid)*getMoney_start/move_start;
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,0,0,clrNONE))
                       {
                        Print("Error in OrderModify. Error code=",GetLastError());

                       }
                    }

                 }
               else
                  if(stopLoss!=0)
                    {
                     double yg_stopLossProfit = move*((oderOpenPrice-stopLoss)/Point()*thisLots-getMoney_start);
                     double thisDuoProfit = thisLr-yg_stopLossProfit;
                     if(thisDuoProfit>=move)
                       {
                        newStopLoss =  stopLoss-(thisDuoProfit*getMoney/move)/thisLots*Point();
                        if(!OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,0,0,clrNONE))
                          {
                           Print("Error in OrderModify. Error code=",GetLastError());

                          }
                       }

                    }

              }
           }
        }
     }
  }







//+------------------------------------------------------------------+
