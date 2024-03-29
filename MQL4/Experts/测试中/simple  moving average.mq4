//+------------------------------------------------------------------+
//|                                               Moving Average.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Moving Average sample expert advisor"

#define MAGICMA  20131111
//--- Inputs
input double Lots          =0.1;
input double MaximumRisk   =0.02;
input double DecreaseFactor=3;
input int    MovingPeriod  =60;
input int    MovingShift   =6;
//+------------------------------------------------------------------+
//| Calculate open positions                                         |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Calculate optimal lot size                                       |
//+------------------------------------------------------------------+
double LotsOptimized()
  {
   double lot=Lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//--- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
//--- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1;i>=0;i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
           {
            Print("Error in history!");
            break;
           }
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL)
            continue;
         //---
         if(OrderProfit()>0) break;
         if(OrderProfit()<0) losses++;
        }
      if(losses>1)
         lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
     }
//--- return lot size
   if(lot<0.1) lot=0.1;
   return(lot);
  }
//+------------------------------------------------------------------+
//| Check for open order conditions                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   double Kma;
   double Mma;
   int    res;
   int buys;
   int sells;
   int buystop;
   int sellstop;
   double a;
   double avr;
    double Kma1;
    double Mma1;
//--- go trading only for first tiks of new bar
   if(Volume[0]>1) return;
   
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
         if(OrderType()==OP_SELLSTOP) sellstop++;
         if(OrderType()==OP_BUYSTOP) buystop++;
        }
     }
//--- get Moving Average 
  Kma=iMA(NULL,0,5,0,MODE_SMA,PRICE_CLOSE,1);
  Mma=iMA(NULL,0,13,0,MODE_SMA,PRICE_CLOSE,1);
  Kma1=iMA(NULL,0,5,0,MODE_SMA,PRICE_CLOSE,2);
  Mma1=iMA(NULL,0,13,0,MODE_SMA,PRICE_CLOSE,2);

//--- sell conditions

for(i=1;i<15;i++)
    {
      a=a+High[i]-Low[i];
     }
 avr=a/14;
 
 //buy  condition===============
 
   if(Mma<Kma && Kma1>Mma1 )      //buy
     {
          if(buys==0 && buystop==0)
              res=OrderSend(Symbol(),OP_BUYSTOP,LotsOptimized(),High[1],3,High[1]-2*avr,0,"",MAGICMA,0,Red);
           
                 for(i=OrdersTotal()-1; i>=0; i--)
                   {
                      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
                         break;
                     if( OrderSymbol()==Symbol()  &&  OrderMagicNumber()==MAGICMA)
                      {
                       if(OrderType()==OP_BUYSTOP && OrderOpenPrice()!=High[1])
                          {  
                              res=OrderModify(OrderTicket(),High[1],High[1]-2*avr,0,0,Yellow); 
                           } 
                        
                        if(OrderType()==OP_SELL && OrderStopLoss()!=Low[1]+2*avr)
                        res=OrderModify(OrderTicket(),OrderOpenPrice(),Low[1]+2*avr,0,0,Yellow);  
                     }
                 
              }  
        }
    
  if(Mma>Kma &&Kma1<Mma1 )      //sell
     {
      
           if(sells==0 && sellstop==0)
             {
                res=OrderSend(Symbol(),OP_SELLSTOP,LotsOptimized(),Low[1],3,Low[1]+2*avr,0,"",MAGICMA,0,Red);
                              
                }
              
          
                 for(i=OrdersTotal()-1; i>=0; i--)
                   {
                      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
                         break;
                       if( OrderSymbol()==Symbol()  &&  OrderMagicNumber()==MAGICMA)
                        {
                         if(OrderType()==OP_SELLSTOP && OrderOpenPrice()!=Low[1])
                            {  
                              res=OrderModify(OrderTicket(),Low[1],Low[1]+2*avr,0,0,Yellow); 
                             } 
                          if(OrderType()==OP_BUY && OrderStopLoss()!=High[1]-2*avr)
                          res=OrderModify(OrderTicket(),OrderOpenPrice(),High[1]-2*avr,0,0,Yellow);
                         
                          }
                       }
         
        } 
  } 

      
    
  

