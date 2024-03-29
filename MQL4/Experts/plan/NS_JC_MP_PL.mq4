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
input double volume=0.02;//起始手数
input int jc_point=100;//加仓点位
string mark = "Matrix_NJ_PL";//标识
input double min_unit=0.01;//最小计量单位
extern int openPoint=300;//开仓点位
extern bool isTimeAstict = true;//是否开启时间段限制
extern int XZ_H = 18;//时间分割线
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
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      close();
      jiaCang();
      int order = jy.CheckOrderByaSymbol(Symbol());
      if(order==0)
        {
         kaiCang();

        }

      alarm=Time[0];

     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
extern int profitPoint = 100;//利润点
void close()
  {
   double  thisVolume = jy.totalVolumeBySymbol(Symbol());
   if(thisVolume>0)
     {
      double thisProfit = jy.profitBySymbolTotal(Symbol());
      if(thisProfit>thisVolume*profitPoint)
        {
         if(jy.ColseOrderBySymbol(Symbol())==0)
           {
            Alert("关闭定单交易出错！");
           }
        }
     }

  }
extern int JC_POINT = 200;//加仓点
void jiaCang()
  {
   int order = OrdersTotal();
   for(int i=order-1;i>=0;i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol())
           {
            int type = OrderType();
            double orderOprice = OrderOpenPrice();
            double s = OrderLots();
            if(type==OP_BUY && orderOprice-Ask>=JC_POINT*Point())
              {
               int buyNum = jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY);

               double buyLots;
               if(buyNum<4)
                 {
                  buyLots = s+min_unit;
                 }
               else
                 {
                  buyLots = buyNum*min_unit+s;
                 }
               if(OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,mark,magic,clrRed)<0)
                 {
                  Alert("订单发送失败！");
                  Print("OrderSend failed with error #",GetLastError());
                 }

              }
            else
               if(type==OP_SELL && Bid-orderOprice>=JC_POINT*Point())
                 {

                  int sellNum = jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL);

                  double sellLots;
                  if(sellNum<4)
                    {
                     sellLots =s+min_unit;
                    }
                  else
                    {
                     sellLots = sellNum*min_unit+s;
                    }
                  if(OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,mark,magic,clrRed)<0)
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


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lastLotsBuyType(int type)
  {
   int order = OrdersTotal();
   double lots;
   for(int i=order-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(Symbol()==OrderSymbol() && type == OrderType())
           {
            lots = OrderLots();
            break;
           }
        }
     }
   return lots;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void kaiCang()
  {
   double oprice = Open[0];
   for(int i=1; i<1000; i++) //行情跌
     {
      if(isTimeAstict){
       if(TimeHour(Time[i])<XZ_H)
        {
         return;
        }
     }
      if(Open[10]-Open[0]>0)
        {
         if(Open[i]-Open[0]>=openPoint*Point())
           {
            if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic,clrRed)<0)
              {
               Alert("订单发送失败！");
               Print("OrderSend failed with error #",GetLastError());
              }
            return;
           }
         /* else
            {
             if(Close[i]-Open[i]>0)
               {
                for(int j=i; j<1000-i; j++)
                  {

                   if(Close[i]-Open[j]>=openPoint/3)
                     {
                      return;//结束所有循环
                     }
                   else
                      if(Close[i]-Open[j]<0)
                        {
                         break;//结束当前循环
                        }
                  }
               }

            }*/
        }
      else
         if(Open[0]-Open[10]>0)
           {
            if(Open[0]-Open[i]>=openPoint*Point())
              {
               if(OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic,clrRed)<0)
                 {
                  Alert("订单发送失败！");
                  Print("OrderSend failed with error #",GetLastError());

                 }
               return;
              }
            /* else
               {
                if(Open[i]-Close[i]>0)
                  {
                   for(int j=i; j<1000-i; j++)
                     {

                      if(Open[j]-Close[i]>openPoint/3)
                        {
                         return;//结束所有循环
                        }
                      else
                         if(Open[j]-Close[i]<0)
                           {
                            break;//结束当前循环
                           }
                     }
                  }
               }*/

           }



     }



  }

//+------------------------------------------------------------------+
