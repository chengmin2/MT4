//+------------------------------------------------------------------+
//|                                                ZhiNengJiaoYi.mqh |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
class ZhiNengJiaoYi
  {
public:
                     ZhiNengJiaoYi();
                    ~ZhiNengJiaoYi();
   int               ColseOrderBySymbol(string symbol,int magic);//平市场单
   int               ColseOrderBySymbol(string symbol,int magic,int type);//平市场买单或卖单
   int               fanXianJC(string symbol,int magic,int points,int jcNum);//反向加仓
   double            profitBySymbolTotal(string  symbol,int magic);//统计货币利润
   double            profitBySymbolTotal(string  symbol,int magic,int type);//统计货币空或多单总利润
   int               iSendOrder(int mySingal,string symbol,double volum,int magic);
   int               iSingal(string symbol); //做空做多信号
   int               CheckOrderByaSymbol(string symbol,int magic);//统计市场订单数量
   int               CheckOrderByaSymbol(string symbol,int magic,int type);//统计市场订单卖单或买单数量
   void              mobileStopLoss(string symbol,int magic,int stopLossNum);//移动止损
   int               zigZag(string symbol,double volum, int magic);
   double            ima(string symbol,int zhouQi,int shift);
   int               niSiJiaCang(string symbol,double volume,int magic,int jc_point);
   void              niSiJiaCang2(string symbol,double volume,int magic);
   void              JiLinWeiZheng(string symbol,int magic,double volume);
   void              ColseOrderGuaBySymbol(string symbol,int magic);
   void              ColseAll();
   int               orderSend(string symbol,double volume,int type,int magic,double stoploss,double takeprofit, int points);
   bool              riskMangement(double value);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ZhiNengJiaoYi::ZhiNengJiaoYi()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ZhiNengJiaoYi::~ZhiNengJiaoYi()
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::iSingal(string symbol) //做空做多信号
  {
   int mySingal = 9;
   double myMa= iMA(symbol,0,14,0,MODE_SMA,PRICE_CLOSE,1);
   double iLow_0 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,1,0);
   double iLow_1 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,1,1);
   double iLow_2 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,1,2);
   double iHigh_0 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,0,0);
   double iHigh_1 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,0,1);
   double iHigh_2 = iCustom(symbol,0,"myZhiBiao\myZhiBiao",20,0,2);
   if(High[0]>myMa && iLow_0>iLow_1 && iLow_1 == iLow_2) //下方k线做多信号
     {
      mySingal= 0;
     }
   if(Low[0]<myMa && iHigh_0<iHigh_1 && iHigh_1==iHigh_2) //上方k线做空信号
     {
      mySingal= 1;
     }
   return mySingal;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int  ZhiNengJiaoYi::iSendOrder(int mySingal,string symbol,double volum,int magic)
  {
   int rt;
   if(mySingal==0)
     {
      rt=OrderSend(symbol,OP_BUY,volum,Ask,10,0,0,"Buy",magic);
      if(rt<0)
         Print("OrderSend failed with error #",GetLastError());
     }
   if(mySingal==1)
     {
      rt=OrderSend(symbol,OP_SELL,volum,Bid,10,0,0,"Sell",magic);
      if(rt<0)
         Print("OrderSend failed with error #",GetLastError());
     }
   return rt;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::fanXianJC(string symbol,int magic,int points,int jcNum)
  {
   ZhiNengJiaoYi jy;
   int total = OrdersTotal();
   int rt = 1;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber())
           {
            if(OrderType()==OP_BUY) //做多单
              {
               if((Bid-OrderOpenPrice())/Point()>points) //做多单盈利超过poins点
                 {
                  rt=jy.ColseOrderBySymbol(symbol,magic);//平仓该货币订单
                  if(rt==0)
                    {
                     printf("多单平仓出错！"+GetLastError());
                     return rt=0;
                    }
                  break;
                 }
               else
                  if((OrderOpenPrice()-Bid)/Point()>points) //做多单亏损超过poins点
                    {
                     rt=OrderSend(symbol,OP_SELL,3*OrderLots(),Bid,5,0,0,OrderComment(),OrderMagicNumber());
                     if(rt<0)
                       {
                        printf("多单加仓出错！"+GetLastError());
                        return rt=0;
                       }
                     break;
                    }
              }
            else
               if(OrderType()==OP_SELL) //做空单
                 {
                  if((OrderOpenPrice()-Ask)/Point()>points) //做空单盈利超过poins点
                    {
                     rt=jy.ColseOrderBySymbol(symbol,magic);//平仓该货币订单
                     if(rt==0)
                       {
                        printf("空单平仓出错！"+GetLastError());
                        return rt=0;
                       }
                     break;
                    }
                  else
                     if((Ask-OrderOpenPrice())/Point()>points) //做空单0亏损超过poins点
                       {
                        rt = OrderSend(symbol,OP_BUY,3*OrderLots(),Ask,5,0,0,OrderComment(),OrderMagicNumber());
                        if(rt<0)
                          {
                           printf("空单加仓出错！"+GetLastError());
                           return rt=0;
                          }
                        break;
                       }
                 }
            break;
           }
        }

     }
   return rt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::ColseOrderBySymbol(string symbol,int magic)
  {
   ZhiNengJiaoYi jy;
   int total = OrdersTotal();
   int rt = 0;
   bool isOk;
   while(jy.CheckOrderByaSymbol(symbol,magic)>0)
     {
      for(int i=total-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(OrderSymbol()==symbol && magic==OrderMagicNumber())
              {

               if(OrderType()==OP_BUY)
                 {
                  isOk=OrderClose(OrderTicket(),OrderLots(),Bid,5);
                  rt=1;
                  if(!isOk)
                    {
                     Print("关闭多单出错！"+GetLastError());
                     rt=0;
                    }

                 }

               if(OrderType()==OP_SELL)
                 {
                  isOk=OrderClose(OrderTicket(),OrderLots(),Ask,5);
                  rt=1;
                  if(!isOk)
                    {
                     Print("关闭空单出错！"+GetLastError());
                     rt=0;
                    }

                 }

              }
           }
        }
      Sleep(800);
     }
   return rt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::ColseOrderBySymbol(string symbol,int magic,int type)
  {
   ZhiNengJiaoYi jy;
   int total = OrdersTotal();


   int rt = 0;
   while(jy.CheckOrderByaSymbol(symbol,magic,type)>0)
     {
      for(int i=total-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(OrderSymbol()==symbol && magic==OrderMagicNumber()&& type==OrderType())
              {
               if(OrderType()==OP_BUY)
                 {
                  rt=OrderClose(OrderTicket(),OrderLots(),Bid,5);
                  if(!rt)
                     GetLastError();
                 }

               if(OrderType()==OP_SELL)
                 {
                  rt=OrderClose(OrderTicket(),OrderLots(),Ask,5);
                  if(!rt)
                     GetLastError();
                 }

              }

           }
        }
      Sleep(800);
     }
   return rt;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ZhiNengJiaoYi::profitBySymbolTotal(string  symbol,int magic) //计算当前货币的总利润
  {
   int total = OrdersTotal();
   double lr = 0;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol&& OrderMagicNumber()==magic)
           {
            lr = lr+OrderProfit()+OrderCommission()+OrderSwap();
           }
        }
     }
   return lr;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ZhiNengJiaoYi::profitBySymbolTotal(string  symbol,int magic,int type) //计算当前货币空单或多单利润
  {

   int total = OrdersTotal();
   double lr = 0;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol&& OrderType()==type && OrderMagicNumber()==magic)
           {
            lr = lr+OrderProfit()+OrderCommission()+OrderSwap();

           }
        }
     }
// printf("当前利润："+lr);

   return lr;
  }
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::CheckOrderByaSymbol(string symbol,int magic) //检查订单中当前货币的单数
  {
   int  total=OrdersTotal();
   int rt=0;
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && OrderMagicNumber()==magic)
            rt++;
        }
     }
   return rt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::CheckOrderByaSymbol(string symbol,int magic,int type) //检查订单中当前货币的单数
  {
   int  total=OrdersTotal();
   int rt=0;
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && OrderMagicNumber()==magic && OrderType()==type)
            rt++;
        }
     }
   return rt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ZhiNengJiaoYi::mobileStopLoss(string symbol,int magic,int stopLossNum)//移动止损
  {

   int  total=OrdersTotal();
   int rt=0;
   for(int i=0; i<total; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && OrderMagicNumber()==magic)
            if(OrderType()==OP_BUY)
              {
               if(Bid-stopLossNum*Point()>OrderOpenPrice())
                 {
                  if(OrderStopLoss()<Bid-stopLossNum*Point() || OrderStopLoss()==0)
                    {
                     bool res = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-stopLossNum*Point(),OrderTakeProfit(),0,clrNONE);
                     if(!res)
                        Print("Error in OrderModify. Error code=",GetLastError());
                    }

                 }
              }

         if(OrderType()==OP_SELL)
           {
            if(OrderOpenPrice()-Ask>stopLossNum*Point())
              {
               if(OrderStopLoss()>Ask+stopLossNum*Point() || OrderStopLoss()==0)
                 {
                  bool res=OrderModify(OrderTicket(),OrderClosePrice(),Ask+stopLossNum*Point(),OrderTakeProfit(),0,clrNONE);
                  if(!res)
                     Print("Error in OrderModify. Error code=",GetLastError());
                 }

              }

           }
        }

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::zigZag(string symbol,double volum, int magic)
  {
   ZhiNengJiaoYi jy;
   int trend=0;
   double zigZag[3];
   int jishu=0;
   for(int i=0; i<1000; i++)
     {
      double zigZagZhi = iCustom(symbol,0,"ZigZag",13,0,i);
      if(zigZagZhi>0)
        {
         zigZag[jishu]=zigZagZhi;
         jishu++;
        }
      if(jishu>=ArraySize(zigZag))
        {
         break;
        }
     }
   if(zigZag[0]>zigZag[1])
     {
      Print("前一根k线zigzag值："+iCustom(symbol,0,"ZigZag",13,0,1));
      trend=0;//趋势向上
      if(iCustom(symbol,0,"ZigZag",20,0,1)>0)
        {
         jy.ColseOrderBySymbol(symbol,magic,OP_SELL);
         if(jy.CheckOrderByaSymbol(symbol,magic,OP_BUY)==0)
           {
            int   rt = OrderSend(symbol,OP_BUY,volum,Ask,5,0,0,"buy",magic);
            if(rt<0)
               Print("OrderSend failed with error #",GetLastError());
           }


        }
     }
   if(zigZag[0]<zigZag[1])
     {
      trend=1;//趋势向下
      if(iCustom(symbol,0,"ZigZag",13,0,1)>0)
        {
         jy.ColseOrderBySymbol(symbol,magic,OP_BUY);
         if(jy.CheckOrderByaSymbol(symbol,magic,OP_SELL)==0)
           {
            int rt=OrderSend(symbol,OP_SELL,volum,Bid,5,0,0,"Sell",magic);
            if(rt<0)
               Print("OrderSend failed with error #",GetLastError());
           }


        }


     }
   return  trend;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ZhiNengJiaoYi:: ima(string symbol,int zhouQi,int shift)
  {
   return iMA(symbol,0,zhouQi,0,MODE_SMA,PRICE_CLOSE,shift);
  }
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::niSiJiaCang(string symbol,double volume,int magic,int jc_point)
  {
   int ticket=1;
   ZhiNengJiaoYi jy;
   int totals = OrdersTotal();

   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber())
           {
            double lots = OrderLots();
            double openPrice = OrderOpenPrice();
            //最近一单为多单
            if(OrderType()==OP_BUY)
              {
               if((openPrice-Bid)/Point()>jc_point)//多单亏损加仓
                 {
                  int buyNum = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
                  double buyLots = buyNum/4*2*0.01+0.01+lots;
                  ticket=OrderSend(symbol,OP_BUY,buyLots,Ask,3,0,0,"buy",magic);
                  if(ticket<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());

                    }
                  break;
                 }
               if((Bid-openPrice)/Point()>jc_point)//多单盈利 空单加仓
                 {
                  int sellDan = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);
                  if(sellDan==0)
                    {
                     ticket=OrderSend(symbol,OP_SELL,volume,Bid,3,0,0,"sell",magic);
                     if(ticket<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());

                       }
                    }
                  else
                     if(sellDan>0)
                       {
                        for(int j=totals-1; j>=0; j--)
                          {
                           if(OrderSelect(j, SELECT_BY_POS))
                             {
                              if(OrderSymbol()==symbol && OrderType()==OP_SELL && OrderMagicNumber()==magic)
                                {
                                 double sellLots = sellDan/4*2*0.01+0.01+OrderLots();
                                 ticket=OrderSend(symbol,OP_SELL,sellLots,Bid,3,0,0,"sell",magic);
                                 if(ticket<0)
                                   {
                                    Print("OrderSend failed with error #",GetLastError());

                                   }
                                 break;
                                }
                             }
                          }
                        break;

                       }
                  break;
                 }

              }
            //最新一单为空单
            if(OrderType()==OP_SELL)
              {
               if((Ask-openPrice)/Point()>jc_point)//空单亏损 加仓
                 {
                  int sellNum = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);
                  double sellLots = sellNum/4*2*0.01+0.01+lots;
                  ticket = OrderSend(symbol,OP_SELL,sellLots,Bid,3,0,0,"sell",magic);
                  if(ticket<0)
                     Print("OrderSend failed with error #",GetLastError());


                 }
               if((openPrice-Ask)/Point()>jc_point)//空单盈利  多单加仓
                 {

                  // printf("进入空单盈利");
                  int buyDan = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
                  if(buyDan==0)
                    {
                     ticket=OrderSend(symbol,OP_BUY,volume,Ask,3,0,0,"buy",magic);
                     if(ticket<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());

                       }
                    }
                  else
                     if(buyDan>0)
                       {
                        for(int j=totals-1; j>=0; j--)
                          {
                           if(OrderSelect(j, SELECT_BY_POS))
                             {
                              if(OrderSymbol()==symbol && OrderType()==OP_BUY)
                                {
                                 double buylLots = buyDan/4*2*0.01+0.01+OrderLots();
                                 ticket= OrderSend(symbol,OP_BUY,buylLots,Ask,3,0,0,"buy",magic);
                                 if(ticket<0)
                                   {
                                    Print("OrderSend failed with error #",GetLastError());

                                   }
                                 break;
                                }
                             }
                          }
                       }

                  break;
                 }
               break;
              }
            break;
           }


        }

     }
   return ticket;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ZhiNengJiaoYi::niSiJiaCang2(string symbol,double volume,int magic)
  {
// if(TimeHour(TimeLocal())>=20 || 10<TimeHour(TimeLocal())<18){
   ZhiNengJiaoYi jy;
   int totals = OrdersTotal();

   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber())
           {

            //最近一单为多单
            if(OrderType()==OP_BUY)
              {
               if((OrderOpenPrice()-Bid)/Point()>100)//多单亏损加仓
                 {

                  int buyNum = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
                  double buyLots = buyNum/4*2*0.01+0.01+buyNum*0.01;
                  int ticket=OrderSend(symbol,OP_BUY,buyLots,Ask,3,0,0,"buy",magic);
                  if(ticket<0)
                     Print("OrderSend failed with error #",GetLastError());
                 }
               if((Bid-OrderOpenPrice())/Point()>100)//多单盈利 空单加仓
                 {

                  int sellDan = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);
                  if(sellDan==0)
                    {
                     int ticket=OrderSend(symbol,OP_SELL,volume,Bid,3,0,0,"sell",magic);
                     if(ticket<0)
                        Print("OrderSend failed with error #",GetLastError());

                    }
                  else
                    {
                     double sellLots = sellDan/4*2*0.01+0.01+sellDan*0.01;

                     int ticket=OrderSend(symbol,OP_SELL,sellLots,Bid,3,0,0,"sell",magic);
                     if(ticket<0)
                        Print("OrderSend failed with error #",GetLastError());
                    }
                 }
               break;

              }
            //最新一单为空单
            if(OrderType()==OP_SELL)
              {
               // printf("币种=="+symbol+(Ask-OrderOpenPrice())/Point());
               if((Ask-OrderOpenPrice())/Point()>100)//空单亏损 加仓
                 {
                  int sellNum = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);

                  double sellLots = sellNum/4*2*0.01+0.01+sellNum*0.01;

                  int ticket = OrderSend(symbol,OP_SELL,sellLots,Bid,3,0,0,"sell",magic);
                  if(ticket<0)
                     Print("OrderSend failed with error #",GetLastError());
                 }
               if((OrderOpenPrice()-Ask)/Point()>100)//空单盈利  多单加仓
                 {
                  int buyDan = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
                  if(buyDan==0)
                    {
                     int ticket=OrderSend(symbol,OP_BUY,volume,Ask,3,0,0,"buy",magic);
                     if(ticket<0)
                        Print("OrderSend failed with error #",GetLastError());
                    }
                  else
                    {
                     double buylLots = buyDan/4*2*0.01+0.01+buyDan*0.01;
                     int ticket= OrderSend(symbol,OP_BUY,buylLots,Ask,3,0,0,"buy",magic);
                     if(ticket<0)
                        Print("OrderSend failed with error #",GetLastError());
                    }
                 }

               break;
              }
            break;
           }


        }

     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ZhiNengJiaoYi::JiLinWeiZheng(string symbol,int magic,double volume)
  {
   ZhiNengJiaoYi jy;
   int total = OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && OrderMagicNumber()==magic)
           {
            if(OrderType()==OP_BUY)
              {
               if((Bid-OrderOpenPrice())/Point()>300) //盈利
                 {
                  jy.ColseOrderBySymbol(symbol,magic,OP_BUY);
                  OrderSend(symbol,OP_BUY,volume,Ask,3,0,0,"buy",magic);

                 }
               else
                 {
                  jy.ColseOrderBySymbol(symbol,magic,OP_BUY);
                  OrderSend(symbol,OP_SELL,volume,Bid,3,0,0,"sell",magic);
                 }
              }
            if(OrderType()==OP_SELL)
              {
               if(Ask-OrderOpenPrice()<0) //盈利
                 {
                  jy.ColseOrderBySymbol(symbol,magic,OP_SELL);
                  OrderSend(symbol,OP_SELL,volume,Bid,3,0,0,"sell",magic);
                 }
               else
                 {
                  jy.ColseOrderBySymbol(symbol,magic,OP_SELL);
                  OrderSend(symbol,OP_BUY,volume,Ask,3,0,0,"buy",magic);
                 }
              }
            break;
           }
        }

     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ZhiNengJiaoYi::ColseOrderGuaBySymbol(string symbol,int magic)
  {
   ZhiNengJiaoYi jy;
   int total = OrdersTotal();
   bool rt;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber())
           {
            if(OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT)
              {
               rt=OrderDelete(OrderTicket());
               if(!rt)
                  Print("OrderDelete failed with error #",GetLastError());

              }

           }

        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ZhiNengJiaoYi::ColseAll()
  {
   int total = OrdersTotal();
   bool rt;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderType()==OP_BUY)
           {
            rt=OrderClose(OrderTicket(),OrderLots(),Bid,5);
            if(!rt)
               Print("OrdercClose failed with error #",GetLastError());
           }

         if(OrderType()==OP_SELL)
           {
            rt=OrderClose(OrderTicket(),OrderLots(),Ask,5);
            if(!rt)
               Print("OrdercClose failed with error #",GetLastError());
           }
         if(OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT
            || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT)
           {
            rt = OrderDelete(OrderTicket());
            if(!rt)
               Print("OrderDelete failed with error #",GetLastError());
           }

        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ZhiNengJiaoYi::orderSend(string symbol,double volume,int type,int magic,double stoploss,double takeprofit, int points)
  {

   int rt =1;
   if(type==OP_BUY)
     {
      rt = OrderSend(symbol,type,volume,Ask,2,stoploss,takeprofit,"buy",magic);
      if(rt<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         rt = 0;
        }
     }
   if(type==OP_BUYSTOP)
     {
      rt = OrderSend(symbol,type,volume,Ask+points*Point(),2,stoploss,takeprofit,"buyStop",magic);
      if(rt<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         rt = 0;
        }
     }
   if(type==OP_BUYLIMIT)
     {
      rt = OrderSend(symbol,type,volume,Ask-points*Point(),2,stoploss,takeprofit,"buyLimit",magic);
      if(rt<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         rt = 0;
        }
     }
   if(type==OP_SELL)
     {
      rt = OrderSend(symbol,type,volume,Bid,2,stoploss,takeprofit,"sell",magic);
      if(rt<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         rt = 0;
        }
     }
   if(type==OP_SELLSTOP)
     {
      rt = OrderSend(symbol,type,volume,Bid-points*Point(),2,stoploss,takeprofit,"sellStop",magic);
      if(rt<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         rt = 0;
        }
     }
   if(type==OP_SELLLIMIT)
     {
      rt = OrderSend(symbol,type,volume,Bid+points*Point(),2,stoploss,takeprofit,"sellLimit",magic);
      if(rt<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         rt = 0;
        }
     }
   return rt;
  }
bool  ZhiNengJiaoYi::riskMangement(double value){
   if(AccountProfit()<0)
      {
      return (MathAbs(AccountProfit())/AccountBalance()>value);     
     }
   return  false;
}
//+------------------------------------------------------------------+
