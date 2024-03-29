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
input int magic=123456;//魔术号
input double volume=0.02;//起始手数
input double cc_profit=4;//出仓利润
input int jc_point=100;//加仓点位
string mark = "Matrix_NJ";//标识
input double fengKong = 0.5;//风控比列
input double fengKong2 = 0.7;//风控比列
input double min_unit=0.01;//最小计量单位
datetime 限制运行时间=D'2022.02.24 00:00';
#include <ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
    datetime time = TimeCurrent();
  if(time>限制运行时间){
   MessageBox("该EA已过使用日期，请联系作者1508448760","过期提示");
   ExpertRemove();
  }
   GlobalVariableDel(Symbol()+"suocang");
   GlobalVariableDel("suocangTicket");
   GlobalVariableDel(Symbol()+"yue");
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
 
 printf("总手数："+totalVolume);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double totalVolume=0;
void OnTick()
  {
   

   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
     int ticket;
//jy.closeHandMovement();
   if(!GlobalVariableCheck("suoscangTicket"))
     {
       jy.mobileStopLoss(Symbol(),magic,200,100);
      if(jy.riskMangement(fengKong))
        {
         Alert("达到风控值,进行第一次锁仓！");
         double totalVolume_buy = jy.totalVolumeBySymbol(Symbol(),magic,OP_BUY);
         double totalVolume_sell = jy.totalVolumeBySymbol(Symbol(),magic,OP_SELL);
         if(totalVolume_buy==0)
           {
            ticket=OrderSend(Symbol(),OP_BUY,totalVolume_sell,Ask,3,0,0,mark,magic);
            if(ticket<0)
              {
               Alert("锁仓失败"+GetLastError());
               Print("OrderSend failed with error #",GetLastError());
               return;
              }

            GlobalVariableSet("suocangTicket",ticket);

           }
         if(totalVolume_sell==0)
           {
            ticket = OrderSend(Symbol(),OP_SELL,totalVolume_buy,Bid,3,0,0,mark,magic);
            if(ticket<0)
              {
               Alert("锁仓失败"+GetLastError());
               Print("OrderSend failed with error #",GetLastError());
               return;
              }

            GlobalVariableSet("suoscangTicket",ticket);

           }
         GlobalVariableSet(Symbol()+"suocang",1);
         GlobalVariableSet(Symbol()+"yue",AccountBalance());
         // ExpertRemove();
         printf("锁仓成功");
        }
     }

      if(AccountBalance()>GlobalVariableGet(Symbol()+"yue"))
        {
         ticket= GlobalVariableGet("suocangTicket");
         OrderSelect(ticket,SELECT_BY_TICKET);
         if(OrderType()==OP_BUY)
           {
            OrderClose(ticket,OrderLots(),Bid,3);
           }
         if(OrderType()==OP_SELL)
           {
            OrderClose(ticket,OrderLots(),Ask,3);
           }
         GlobalVariableDel(Symbol()+"suocang");
         GlobalVariableDel("suocangTicket");
         GlobalVariableDel(Symbol()+"yue");
        }
      //自动解锁
      ticket= GlobalVariableGet("suocangTicket");
      OrderSelect(ticket,SELECT_BY_TICKET);
      if(OrderType()==OP_BUY)
        {
         if(OrderOpenPrice()<Bid && Time[0]-OrderOpenTime()>PERIOD_M30)
           {
            if(OrderClose(ticket,OrderLots(),Ask,3))
              {
               printf("解锁成功");
               GlobalVariableDel(Symbol()+"suocang");
               GlobalVariableDel("suocangTicket");
               GlobalVariableDel(Symbol()+"yue");
               return;
              }
            printf("解锁失败");
           }
        }
      if(OrderType()==OP_SELL)
        {
         if(OrderOpenPrice()>Ask && Time[0]-OrderOpenTime()>PERIOD_M30)
           {
            if(OrderClose(ticket,OrderLots(),Bid,3))
              {
               printf("解锁成功");
               GlobalVariableDel(Symbol()+"suocang");
               GlobalVariableDel("suocangTicket");
               GlobalVariableDel(Symbol()+"yue");
               return;
              }
            printf("解锁失败");
           }
        }

      if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
        {
         if(OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic)<0)
           {
            Alert("发送订单失败！");
            Print("OrderSend failed with error #",GetLastError());
           }
        }
      close();
      if(!GlobalVariableCheck(Symbol()+"suocang"))
        {
         if(jy.niSiJiaCang(Symbol(),volume,magic,jc_point,mark,min_unit,totalVolume)==0)
           {
            Alert("加仓交易出错！");
            Print("OrderSend failed with error #",GetLastError());
           }
        }
      alarm=Time[0];

     }


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>cc_profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY)==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>cc_profit)
     {
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
         Alert("关闭空单交易出错！");
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CheckOrderByaSymbol(string symbol,int magic) //检查订单中当前货币的单数
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
