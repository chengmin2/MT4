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
input double volume=0.01;//起始手数
input int jiShu=30;//顺势加仓点位
input int huiCeDian=100;//回撤顺势点
input int guaDian=100;//挂单点位
input double fengKong=0.5;//风控比列
extern int ZS_P_S= 200;//移动止损点位
extern  int ZS_P_E =100;//移动止损点数
extern double profit=2;//初始出仓利润
input double min_unit=0.01;//最小计量单位
string mark = "Matrix_SJ";//标识
input double accountType=1;//账户类型（美元:1;美角:0.1）
extern double stopEa = -50000;//爆仓值
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
   createLabel();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  printf("总手数："+totalVolume);
//jy.stopProfit(Symbol(),profit,magic,accountType);

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
double totalVolume=0;
void OnTick()
  {
//jy.closeHandMovement();
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      if(!jy.riskMangement(fengKong))
        {

         if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL)==0)
           {
            OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic);
            OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic);
            totalVolume = totalVolume+2*volume;
           }

         shunShiJC();

        }
      else
        {
         Alert("达到风控值,已停止加仓！");

        }
         bc();
      //zhiSun();
      fuKui();
     // jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);
      jy.deleteGuanDanByPrice(Symbol(),(huiCeDian+guaDian),magic);
      close();
      alarm=Time[0];

     }

  }
void bc(){
  double  lr = jy.profitBySymbolTotal(Symbol());
  printf("利润值："+lr);
  if(lr<=stopEa){
      printf("浮亏达到爆仓值");
      jy.ColseOrderGuaBySymbol(Symbol());
      jy.ColseOrderBySymbol(Symbol());     
      ExpertRemove();
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

double getLastLots(int type){
return volume;
int totals = OrdersTotal();
    for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol()  && OrderType()==type)
           {
            
                  return OrderLots();
            
           }}}
return volume;
}
void shunShiJC()
  {
   int totals = OrdersTotal();
   string symbol = Symbol();
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==symbol && magic==OrderMagicNumber() && OrderType()==OP_SELL)
           {
            double s = OrderLots();
            if(OrderOpenPrice()-Bid>jiShu*Point())
              {
               //if(s<7*min_unit)
                // {
                  if(3*min_unit<s && s<=5*min_unit)
                     profit=6*accountType;
               //   int sellNum = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);
                  double sellLots;
                 
                    sellLots = getLastLots(OP_SELL);
                    if(TimeHour(OrderOpenTime())!=TimeHour(Time[0])) sellLots =sellLots+min_unit;
                  if(OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开空单失败！");
                    }
                  totalVolume = totalVolume+sellLots;
      
                 //}

              }
            if(Bid-OrderOpenPrice()>huiCeDian*Point())
              {
               int buyNum = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
               int buyNumGua = jy.CheckOrderByaSymbol(symbol,magic,OP_BUYSTOP);
               if(buyNum==0 && buyNumGua==0)
                 {
                  if(OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+guaDian*Point(),3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("挂多单失败！");
                    }
                 }
               else
                 {
                  for(int j=totals-1; j>=0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==symbol && OrderType()==OP_BUY)
                          {
                           double b = OrderLots();
                           double buyLots ;
                         
                    buyLots = getLastLots(OP_BUY);
                    if(TimeHour(OrderOpenTime())!=TimeHour(Time[0])) buyLots =buyLots+min_unit;
                           if(OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,mark,magic)<0)
                             {
                              Print("OrderSend failed with error #",GetLastError());
                              Alert("开多单失败！");
                             }

                           totalVolume = totalVolume+buyLots;
                           break;
                          }

                       }

                    }

                 }

              }
            break;
           }
         if(OrderSymbol()==symbol  && OrderType()==OP_BUY)
           {
            double b = OrderLots();
            if(Ask-OrderOpenPrice()>jiShu*Point())
              {
              // if(b<7*min_unit)
                 //{
                  if(3*min_unit<b && b<=5*min_unit)
                     profit=6*accountType;
                 // int buyNum = jy.CheckOrderByaSymbol(symbol,magic,OP_BUY);
                  double buyLots;
                 
                             buyLots = getLastLots(OP_BUY);
                    if(TimeHour(OrderOpenTime())!=TimeHour(Time[0])) buyLots =buyLots+min_unit;
                  if(OrderSend(Symbol(),OP_BUY,buyLots,Ask,3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("开多单失败！");
                    }


                 //}

              }
            if(OrderOpenPrice()-Ask>huiCeDian*Point())
              {
               int sellNum = jy.CheckOrderByaSymbol(symbol,magic,OP_SELL);
               int sellNumGua = jy.CheckOrderByaSymbol(symbol,magic,OP_SELLSTOP);
               if(sellNum==0 && sellNumGua==0)
                 {
                  if(OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-guaDian*Point(),3,0,0,mark,magic)<0)
                    {
                     Print("OrderSend failed with error #",GetLastError());
                     Alert("挂多单失败！");
                    }
                 }
               else
                 {
                  for(int j=totals-1; j>=0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==symbol  && OrderType()==OP_SELL)
                          {
                           double s = OrderLots();
                           double sellLots;
                        
                         
                                      sellLots = getLastLots(OP_SELL);
                    if(TimeHour(OrderOpenTime())!=TimeHour(Time[0])) sellLots =sellLots+min_unit;
                           if(OrderSend(Symbol(),OP_SELL,sellLots,Bid,3,0,0,mark,magic)<0)
                             {
                              Print("OrderSend failed with error #",GetLastError());
                              Alert("开空单失败！");
                             }

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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_BUY)>profit)
     {
      profit=6*accountType;
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY)==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic,OP_SELL)>profit)
     {
      profit=6*accountType;
      jy.ColseOrderGuaBySymbol(Symbol(),magic);
      if(jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL)==0)
         Alert("关闭空单交易出错！");
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
