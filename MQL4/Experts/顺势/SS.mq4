//+------------------------------------------------------------------+
//|                                                        SS_JC.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
datetime alarm=0;
input int magic=612973;//魔术号
input double volume=0.01;//起始手
input int duiChongDian=100;//对冲点
input int shuShiDian=200;//顺势点
input double fengKong=0.5;//风控比列
extern double profit=15;//初始出仓利润
input double min_unit=0.01;//最小计量单位
string mark_s = "Matrix_SJ";//标顺势识
string mark_n = "Matrix_NJ";//逆势标识
extern int ns_huice = 150;//逆势回撤
extern int ns_guadian = 30;//逆势挂点
extern int ss_huice = 150;//顺势点位
extern int ss_guadian = 30;//顺势挂点
input double accountType=0.1;//账户类型（美元:1;美角:0.1）
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
double nFk;
double maxFk;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   EventSetTimer(1);
   createLabel();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   printf("总手数："+totalVolume);
   EventKillTimer();
//jy.stopProfit(Symbol(),profit,magic,accountType);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   close();

  }
double totalVolume=0;
void OnTick()
  {
//jy.closeHandMovement();
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {

      close();
       main();
       duiChongJC();
      fuKui();
      //jy.deleteGuanDanByPrice(Symbol(),(ns_huice+ns_guadian),magic);
      alarm=Time[0];

     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void main()
  {
   if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL)==0
      && jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUYSTOP)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELLSTOP)==0)
     {
      OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+30*Point(),3,0,0,mark_n,magic);
      OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-30*Point(),3,0,0,mark_n,magic);

     }
   int totals = OrdersTotal();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         int type = OrderType();
         double oPrice = OrderOpenPrice();
         string symbol=OrderSymbol();
         double lots = OrderLots();
         string mark = OrderComment();
         int buyOrder = jy.CheckOrderByaSymbolType(symbol,OP_BUY);
         int sellOrder= jy.CheckOrderByaSymbolType(symbol,OP_SELL);
         int buyOrderGD = jy.CheckOrderByaSymbolType(symbol,OP_BUYSTOP);
         int sellOrderGD = jy.CheckOrderByaSymbolType(symbol,OP_SELLSTOP);
         double thisLot;
         if(mark==mark_s)
           {
            if(type==OP_BUY)
              {
               if(oPrice-Bid>=ns_huice*Point())
                 {
                  thisLot = jsLots(OP_SELL,lastLostByType(OP_SELL),sellOrder);//根据规则计算下单手数
                       if(buyOrder>5 && buyOrder<7 && buyOrderGD==0){
                       double bLots = jsLots(OP_BUY,lots,buyOrder);
                       OrderSend(Symbol(),OP_BUYSTOP,bLots,Ask+ss_guadian*Point(),3,0,0,mark_s,magic);
                     }else if(sellOrderGD==0){
                         if(OrderSend(Symbol(),OP_SELLSTOP,thisLot,Bid-ns_guadian*Point(),3,0,0,mark_n,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("逆势挂空单失败！");

                    }
                     }
               
                 }
              }
            else
               if(type==OP_SELL)
                 {
                  if(Ask-oPrice>=ns_huice*Point())
                    {
                     thisLot = jsLots(OP_BUY,lastLostByType(OP_BUY),buyOrder);//根据规则计算下单手数
                     if(sellOrder>5 && sellOrder<7 && sellOrderGD==0){
                       double sLots = jsLots(OP_SELL,lots,sellOrder);
                       OrderSend(Symbol(),OP_SELLSTOP,sLots,Bid-ss_guadian*Point(),3,0,0,mark_s,magic);
                     }else if(buyOrderGD==0){
                        if(OrderSend(Symbol(),OP_BUYSTOP,thisLot,Ask+ns_guadian*Point(),3,0,0,mark_n,magic)<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("逆势挂多单失败！");

                       }
                     }
                   
                    }

                 }

           }
         else
            if(mark==mark_n)
              {
               if(type==OP_BUY)
                 {    
                 
                  if(oPrice-Bid>=ss_huice*Point())
                    {
                     thisLot = jsLots(OP_SELL,lastLostByType(OP_SELL),sellOrder);//根据规则计算下单手数
                      if(buyOrder>3 && buyOrder<5 && buyOrderGD==0){
                       double bLots = jsLots(OP_BUY,lots,buyOrder);
                       OrderSend(Symbol(),OP_BUYSTOP,bLots,Ask+ns_guadian*Point(),3,0,0,mark_n,magic);
                     }else if(sellOrderGD==0){
                       if(OrderSend(Symbol(),OP_SELLSTOP,thisLot,Bid-ss_guadian*Point(),3,0,0,mark_s,magic)<0)
                       {
                        Print("OrderSend failed with error #",GetLastError());
                        Alert("顺势挂空单失败！");

                       }
                     }
                    
                    }
                 }
               else
                  if(type==OP_SELL)
                    {
                     if(Ask-oPrice>=ss_huice*Point())
                       {
                        thisLot = jsLots(OP_BUY,lastLostByType(OP_BUY),buyOrder);//根据规则计算下单手数
                        double sLots = jsLots(OP_SELL,lots,sellOrder);
                        if(sellOrder>3 && sellOrder<5 && sellOrderGD==0){
                       OrderSend(Symbol(),OP_SELLSTOP,sLots,Bid-ns_guadian*Point(),3,0,0,mark_n,magic);
                     }else if(buyOrderGD==0){
                      if(OrderSend(Symbol(),OP_BUYSTOP,thisLot,Ask+ss_guadian*Point(),3,0,0,mark_s,magic)<0)
                          {
                           Print("OrderSend failed with error #",GetLastError());
                           Alert("顺势挂多单失败！");

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

void duiChongJC()
  {
   double orderBuyLots = jy.CheckOrderByaSymbolType(Symbol(),OP_BUY);
   double orderSellLots = jy.totalVolumeBySymbol(Symbol(),OP_SELL);
   int totals = OrdersTotal();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         double lots = OrderLots();
         string mark = OrderComment();
         double type = OrderType();
         string symbol = OrderSymbol();
         int ticket = OrderTicket();
         double lastProfit = OrderProfit()+OrderSwap()+OrderCommission();
         if(Symbol()==OrderSymbol())
           {
            if(lots>=0.07 && orderBuyLots==orderSellLots)
              {
               if(mark==mark_s)
                 {
                  for(int j=totals-1; i>=0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(symbol == OrderSymbol() && OrderType()==type)
                          {
                           double thisProfit = OrderProfit()+OrderSwap()+OrderCommission();
                           thisProfit = thisProfit+lastProfit;
                           int thisTicket = OrderTicket();
                           if(thisProfit>2)
                             {
                              if(type==OP_BUY)
                                {
                                 OrderClose(ticket,lots,Bid,3,clrTeal);
                                 OrderClose(thisTicket,OrderLots(),Bid,3,clrTeal);
                                 break;
                                }
                              else
                                 if(type==OP_SELL)
                                   {
                                    OrderClose(ticket,lots,Ask,3,clrTeal);
                                    OrderClose(thisTicket,OrderLots(),Ask,3,clrTeal);
                                    break;
                                   }

                             }
                          }
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
//|                                                                  |
//+------------------------------------------------------------------+

bool isLXSS(int type)
  {
   bool returnB = false;
   int totals = OrdersTotal();
   int js = 2;
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(Symbol()==OrderSymbol())
           {
            if(type==OrderType())
              {
               returnB=true;
              }
            else
              {
               returnB=false;
              }
            js--;
            if(js==0)
              {
               break;
              }

           }
        }
     }
   return returnB;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getFirstOPprice(int type)
  {
   double returnPrice;
   int totals = OrdersTotal();
   for(int i=0; i<totals; i++)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(type==OrderType() && Symbol()==OrderSymbol())
           {
            returnPrice = OrderOpenPrice();
            break;
           }
        }
     }
   return returnPrice;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double jsLots(int type,double lot,int order)
  {
   double returnLot;
   if(0<order && order<4)
     {
      returnLot = lot+order*min_unit;
     }
   else
      if(order==6)
        {
         returnLot = lot+22*min_unit;
        }
      else
         if(order==7)
           {
            returnLot = lot+33*min_unit;
           }
         else
            if(order>7)
              {
               returnLot = lot;
              }
            else
               if(order>3 && order<6)
                 {
                  int totals = OrdersTotal();
                  double thisLot;
                  for(int i=totals-1; i>=0; i--)
                    {
                     if(OrderSelect(i, SELECT_BY_POS))
                       {
                        thisLot = OrderLots();
                        if(OrderType()==type && thisLot<lot)
                          {
                           returnLot=(lot-thisLot)*2+lot;
                           break;
                          }
                       }
                    }
                 }

   return returnLot;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*void shunShiJC()
  {
   int totals = OrdersTotal();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         int type = OrderType();
         double oPrice = OrderOpenPrice();
         string symbol=OrderSymbol();
         double lots = OrderLots();
         int buyOrder = jy.CheckOrderByaSymbolType(symbol,OP_BUY);
         int sellOrder= jy.CheckOrderByaSymbolType(symbol,OP_SELL);
         if(Symbol()==symbol  && type==OP_SELL)
           {
            if(oPrice-Bid>duiChongDian*Point())//顺势
              {
               duiChong(buyOrder,sellOrder,lots);

              }
            if(Bid-oPrice>duiChongDian*Point())
              {
               duiChong(buyOrder,sellOrder,lots);
              }
            if(oPrice-Bid>shuShiDian*Point())//顺势
              {

               shunShi(buyOrder,sellOrder,lots,type);
              }


            break;
           }
         if(Symbol()==symbol  && type==OP_BUY)
           {

            if(Ask-oPrice>duiChongDian*Point())
              {
               duiChong(buyOrder,sellOrder,lots);

              }
            if(oPrice-Ask>duiChongDian*Point())//顺势
              {
               duiChong(buyOrder,sellOrder,lots);

              }
            if(oPrice-Ask>shuShiDian*Point())//顺势
              {
               shunShi(buyOrder,sellOrder,lots,type);

              }


            break;
           }

        }


     }

  }
  */
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   if(jy.profitBySymbolTotal(Symbol())>profit)
     {
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      if(jy.ColseOrderBySymbol(Symbol())==0)
        {
         Print("OrderSend failed with error #",GetLastError());
         Alert("关闭订单失败！");
        }


     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
/*void duiChong(int buyOrder,int sellOrder,double lots)
  {
   if(0<buyOrder && buyOrder<4 && 0<sellOrder && sellOrder<4)
     {
      double thisLots = lots+buyOrder*min_unit;
      if(OrderSend(Symbol(),OP_SELL,thisLots,Bid,3,0,0,mark,magic)<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         Alert("开空单失败！");
        }
      if(OrderSend(Symbol(),OP_BUY,thisLots,Ask,3,0,0,mark,magic)<0)
        {
         Print("OrderSend failed with error #",GetLastError());
         Alert("开多单失败！");
        }


     }
  }*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*void shunShi(int buyOrder,int sellOrder,double lots,int type)
  {
   int totals = OrdersTotal();
   double thisLot;
   if(type==OP_BUY)
     {
      if(buyOrder>3 && buyOrder<6)
        {
         for(int i=totals-1; i>=0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS))
              {
               thisLot = OrderLots();
               if(OrderType()==type && thisLot<lots)
                 {
                  if(OrderSend(Symbol(),OP_BUY,(lots-thisLot)*2+lots,Ask,3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开多单失败！");
                    }
                  return;
                 }
              }
           }

        }
      else
         if(buyOrder==6)
           {
            thisLot = lots+22*min_unit;
           }
         else
            if(buyOrder==7)
              {
               thisLot = lots+33*min_unit;
              }
            else
               if(buyOrder>7)
                 {
                  thisLot = lots;
                 }
      if(OrderSend(Symbol(),OP_BUY,thisLot,Ask,3,0,0,mark,magic)<0)
        {
         printf("当前手数："+thisLot);
         Print("OrderSend failed with error #",GetLastError());
         Alert("开多单失败！");
        }


     }
   if(type==OP_SELL)
     {
      if(buyOrder>3 && buyOrder<6)
        {
         for(int i=totals-1; i>=0; i--)
           {
            if(OrderSelect(i, SELECT_BY_POS))
              {
               thisLot = OrderLots();
               if(OrderType()==type && thisLot!=lots)
                 {
                  if(OrderSend(Symbol(),OP_SELL,(lots-thisLot)*2+lots,Bid,3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开空单失败！");
                    }
                  return;
                 }
              }
           }

        }
      else
         if(sellOrder==6)
           {
            thisLot = lots+22*min_unit;
           }
         else
            if(sellOrder==7)
              {
               thisLot = lots+33*min_unit;
              }
            else
               if(sellOrder>7)
                 {
                  thisLot = lots;
                 }
      if(OrderSend(Symbol(),OP_SELL,thisLot,Bid,3,0,0,mark,magic)<0)
        {
         printf("当前手数："+thisLot);
         Print("OrderSend failed with error #",GetLastError());
         Alert("开空单失败！");
        }
     }

  }*/
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double lastLostByType(int type)
  {
   int totals = OrdersTotal();
   double returnLot;
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         double thisLot = OrderLots();
         if(OrderType()==type)
           {
            returnLot = OrderLots();
            break;
           }
        }
     }
   return returnLot;
  }
//+------------------------------------------------------------------+
