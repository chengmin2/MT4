//+------------------------------------------------------------------+
//|                                                         test.mq4 |
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
extern double profit=0.6;//出仓利润
input int magic=0;//魔术号
input double volume=0.01;//初始手数
input int points=100;//挂单点位
input int ZS_P_S= 200;//移动止损点位
input int ZS_P_E =100;//移动止损点数
input double JC_Volume = 0.01;//加仓层数
input int  JC_POIT = 20;//挂单加仓因子
input int C_CW_2 = 1000;//止损点
input int G_D_D = 200;//删除挂单点位
input int D_S = 30;//定时器
input int centre = 200;//中间点
input int Y_J = -1000;//预警线
double min_unit = 0.01;//最小单位
input double accountType=0.01;//账户类型（美元:0.01;美角:0.1;美分:1）
string mark = "Matrix_G_D_B";//标识
string S_C = "Matrix_G_D_B_S";//锁仓标识
string S_C_2 = "Matrix_G_D_S_2";//锁仓标识
extern int s = 0;//解锁标识
extern int no_M=0;//普通锁变量标识
datetime time=0;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
double nFk;
double maxFk;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   anNiu("suoCang",30,80,"锁仓(移动止盈线)",130,30);
   anNiu("jieSuo",170,80,"解锁(移)",100,30);
   anNiu("suoCang_2",30,120,"锁仓(止盈线不变)",130,30);
   anNiu("jieSuo_2",170,120,"解锁(不移)",100,30);
   createLabel();
   EventSetTimer(D_S);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

// jy.ColseOrderGuaBySymbol(Symbol(),magic);
   EventKillTimer();

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(time!=Time[0])
     {
      if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUY)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELL)==0)
        {
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic);
         OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic);
        }
      close();
      JC();

      time=Time[0];
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void JC()
  {
   int total=OrdersTotal();
   int buyOrder = jy.CheckOrderByaSymbolType(Symbol(),OP_BUY);
   int sellOrder= jy.CheckOrderByaSymbolType(Symbol(),OP_SELL);
   int buyOrderGD = jy.CheckOrderByaSymbolType(Symbol(),OP_BUYSTOP);
   int sellOrderGD= jy.CheckOrderByaSymbolType(Symbol(),OP_SELLSTOP);
   double thisLots;
   double op;
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
           {
            double openP = OrderOpenPrice(); 
            if(OrderType()==OP_BUY)
              {
            
               if(buyOrderGD==0)
                 {
                  if(buyOrder==sellOrder)
                    { 
                     thisLots = jsLots(OP_BUY,OrderLots(),buyOrder);
                     double  op = openP+50*Point();
                     if(Ask>=op){
                        OrderSend(Symbol(),OP_BUY,thisLots,Ask,3,0,0,mark,magic);
                     }else{
                       OrderSend(Symbol(),OP_BUYSTOP,thisLots,op,3,0,0,mark,magic);
                     }
                    
                    }

                 }
               if(sellOrderGD==0)
                 {
                  for(int j=total-1; j>=0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                          {
                           if(OrderType()==OP_SELL)
                             { 
                              double thisOpenP=OrderOpenPrice();                       
                                 if(buyOrder==sellOrder)
                                   {
                                    printf("进入挂单");
                                    thisLots = jsLots(OP_SELL,OrderLots(),sellOrder);
                                    double  op = thisOpenP-50*Point();
                                    if(Bid<=op){
                                     OrderSend(Symbol(),OP_SELL,thisLots,Bid,3,0,0,mark,magic);
                                    }else{
                                     OrderSend(Symbol(),OP_SELLSTOP,thisLots,op,3,0,0,mark,magic);
                                    }
                                    
                                   }
                                
                                break;
                             }
                          }
                       }



                    }
                 }
              }
            else
               if(OrderType()==OP_SELL)
                 {
                  
                  if(sellOrderGD==0)
                    {
                     if(buyOrder==sellOrder)
                       {
                        printf("进入挂单");
                        thisLots = jsLots(OP_SELL,OrderLots(),sellOrder);
                        op=openP-50*Point();
                        if(Bid<=op){
                        OrderSend(Symbol(),OP_SELL,thisLots,Bid,3,0,0,mark,magic);
                        }else{
                        OrderSend(Symbol(),OP_SELLSTOP,thisLots,op,3,0,0,mark,magic);
                        }
                        
                       }
                    }
                  if(buyOrderGD==0)
                    {

                     for(int j=total-1; j>=0; j--)
                       {
                        if(OrderSelect(j, SELECT_BY_POS))
                          {
                           if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                             {
                              if(OrderType()==OP_BUY)
                                {
                          
                                 double thisOpenP = OrderOpenPrice();
                                    if(buyOrder==sellOrder)
                                      {
                                       printf("进入挂单");
                                       thisLots = jsLots(OP_BUY,OrderLots(),buyOrder);
                                       op = thisOpenP+50*Point();
                                       if(Ask>=op){
                                          OrderSend(Symbol(),OP_BUY,thisLots,Ask,3,0,0,mark,magic);
                                       }else{
                                         OrderSend(Symbol(),OP_BUYSTOP,thisLots,op,3,0,0,mark,magic);
                                       }
                                       
                                      }

                                   
                                   break;
                                }
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
bool isSecondByType(int type)
  {
   int totals = OrdersTotal();
   bool returnIS = false;
   for(int i=totals-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(i==totals-2)
           {
            if(OrderType()==type)
              {
               returnIS=true;

              }
            else
              {
               returnIS=false;
              }
            break;
           }

        }
     }
   return returnIS;
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



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  cent()
  {
   int total=OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
           {
            if(OrderType()==OP_BUY)
              {

               if(OrderOpenPrice()-Ask>centre*Point())
                 {
                  string w_OrderSymbol = OrderSymbol();
                  for(int j=total-1; j>=0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==Symbol() && w_OrderSymbol == OrderSymbol() && OrderMagicNumber()==magic)
                          {
                           if(OrderType()==OP_SELL && Bid-OrderOpenPrice()>centre*Point())
                             {
                              if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUYSTOP)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELLSTOP)==0)
                                {
                                 // Print("进入中间");
                                 OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
                                 OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+points*Point(),3,0,0,mark,magic);
                                }

                             }
                           break;
                          }

                       }
                    }


                 }
              }
            if(OrderType()==OP_SELL)
              {
               if(Bid-OrderOpenPrice()>centre*Point())
                 {
                  string w_OrderSymbol = OrderSymbol();
                  for(int j=total-1; j>0; j--)
                    {
                     if(OrderSelect(j, SELECT_BY_POS))
                       {
                        if(OrderSymbol()==Symbol() && w_OrderSymbol == OrderSymbol() && OrderMagicNumber()==magic)
                          {
                           if(OrderType()==OP_BUY && OrderOpenPrice()-Ask>centre*Point())
                             {
                              if(jy.CheckOrderByaSymbol(Symbol(),magic,OP_BUYSTOP)==0 && jy.CheckOrderByaSymbol(Symbol(),magic,OP_SELLSTOP)==0)
                                {
                                 //Print("进入中间");
                                 OrderSend(Symbol(),OP_SELLSTOP,volume,Bid-points*Point(),3,0,0,mark,magic);
                                 OrderSend(Symbol(),OP_BUYSTOP,volume,Ask+points*Point(),3,0,0,mark,magic);
                                }

                             }
                           break;
                          }
                       }
                    }
                 }
              }

           }
        }
     }

  }
//+------------------------------------------------------------------+
void anNiu(string name,int x,int y,string text,int width,int high)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrAqua);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,high);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrDarkGreen);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
