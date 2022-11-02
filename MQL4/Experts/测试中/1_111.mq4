
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


extern   int   magic=7777;
extern string EAComment= "VV3";
extern   double 手数=0.1;
extern   int    止损=200;
extern   int    止盈=1000;
input int     risk= 0;//risk: 0-->fixed lots
extern   bool   移动止损开关=true;
extern   int    移损启动点数=400;
extern   double  移损间隔=100;
extern   bool    减仓开关=true;
extern   int     减仓启动点数=300;
extern   double  减仓百分比=50;
extern   bool    实时均线平仓开关=true;
extern   bool    收盘均线平仓开关=true;
extern   int     均线周期=100;
extern   double  加仓倍数=1.1;
extern   int     加仓次数=5;
extern   int     加仓间隔=100;
extern   int     确认秒数=10;
extern   int     nk=10;   // 止损后多少K线不开仓






bool  up()
   {
     double a=iCustom(Symbol(),0,"Arrow_Alert",".....CO_TRADING_SYSTEM_FOREX.....",".....Powered_Trend_Signal_Arrow_Alert.....",12,0,3,Aqua,Yellow,233,234,0,"alert2.wav",1,True,True,True,True,0,1);
     double b=iCustom(Symbol(),0,"ADF",50,200,14,True,0,1);
     if(a!=0 && a!=EMPTY_VALUE)
     Alert("Arrow_Alert up="+a);
     if(b!=EMPTY_VALUE)
     Alert("ADF up="+b);
     if(a!=0 && a!=EMPTY_VALUE && b!=EMPTY_VALUE)
     return true;
     else return false;
   }
     
bool  down()
   {
     
     double a=iCustom(Symbol(),0,"Arrow_Alert",".....CO_TRADING_SYSTEM_FOREX.....",".....Powered_Trend_Signal_Arrow_Alert.....",12,0,3,Aqua,Yellow,233,234,0,"alert2.wav",1,True,True,True,True,1,1);
     double b=iCustom(Symbol(),0,"ADF",50,200,14,True,1,1);
     if(a!=0 && a!=EMPTY_VALUE)
     Alert("Arrow_Alert down="+a);
     if(b!=EMPTY_VALUE)
     Alert("ADF down="+b);
     if( a!=0 && a!=EMPTY_VALUE && b!=EMPTY_VALUE)
     return true;
     else return false;
   } 
 
 
double ma(int i)
    {
      return(iMA(NULL,0,均线周期,0,0,0,i));
    }  
  
int OnInit()
  {

   EventSetTimer(1);
   
//---
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
datetime alarm=0;
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
      int shu=danshu(0)+danshu(1);
     
     double buyopying,buylotsying;
     int buydanshuying=buydanshu(buyopying,buylotsying,magic);// 
     double sellopying,selllotsying;
     int selldanshuying=selldanshu(sellopying,selllotsying,magic);//

      if(up()  && shu==0 && last_time()) //指标出现涨单的信号，目前持仓数为0
        { 
          buy(GetLots(),止损,止盈,EAComment,magic);
        }
      if(danshu(1)>0 && up())
          {
           buytime=Time[0];
          }
      if(buydanshuying<加仓次数  && (buyopying-Bid)>=加仓间隔*Point() && up()  && last_time() )
        {
          if(buy(NormalizeDouble(last_lot(0)*加仓倍数,2),止损,止盈,EAComment+IntegerToString(danshu(0)),magic)>0)
              {
                 修改止损(last_sl(0));
              }
        }  
        
    
       
       if(down()  && shu==0 && last_time())   
         {
            sell(GetLots(),止损,止盈,EAComment,magic);
         }
       if(danshu(0)>0)
             {
              selltime=Time[0];
             }
       if(selldanshuying<加仓次数  && (Bid-sellopying)>=加仓间隔*Point  && down() && last_time())
         {
           if(sell(NormalizeDouble(last_lot(1)*加仓倍数,2),止损,止盈,EAComment+IntegerToString(danshu(1)),magic)>0)
              {
                 修改止损(last_sl(1));
              }
         }


     if(移动止损开关==true) 移动止损();  
     if(减仓开关==true) 减仓();
     
     alarm=Time[0];

     }
  }

int  upshu=0;
int  downshu=0;

void OnTimer()
  {
    
     
  }
  
int danshu(int ty)
    {
      int  a=0;
       for(int i=0;i<OrdersTotal();i++)
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
    
    
    
double last_lot(int ty)
    {
     double  a=0;
     if(OrderSelect(tk(ty),SELECT_BY_TICKET)==true)
        {
          a=OrderLots(); 
        }
             
      return a;
    } 
    
double last_sl(int ty)
    {
     double  a=0;
     if(OrderSelect(tk(ty),SELECT_BY_TICKET)==true)
        {
          a=OrderStopLoss(); 
        }
             
      return a;
    }     
  
bool last_time()
    {
     bool  a=false;
     int time=0;
     int order_hs = OrdersHistoryTotal();
     for(int i=order_hs-1;i>=0;i--)
         {
           if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)
              {
                 if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && StringFind(OrderComment(),"sl")>=0)  
                    {
                       time=iBarShift(NULL,0,OrderCloseTime());
                       break;
                    }
                if(OrderCloseTime()>Time[nk]) break;
              }
         }           
      if(time!=0 && time>nk)//距离nk跟k线之后
        {
          a=true;
        }
      if(time==0)
        {
          a=true;
        }  
             
      return a;
    }        
    

int tk(int ty)
    {
       int  a=0;
       for(int i=OrdersTotal()-1;i>=0;i--)
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
    
    
      
    
  
double yingkui(int ty)
    {
      double  a=0;
       for(int i=0;i<OrdersTotal();i++)
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
  
void 修改止损(double sl)
    {
        for(int i=0;i<OrdersTotal();i++)
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
  
void 移动止损()
    {
         for(int i=0;i<OrdersTotal();i++)
            {
              if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
                 {
                   if(OrderSymbol()==Symbol() && OrderType()==0 && OrderMagicNumber()==magic)
                      {
                         if(OrderClosePrice()-OrderOpenPrice()>=移损启动点数*Point)
                           {
                               double 移损= OrderOpenPrice()+移损间隔*Point;
                               if( OrderStopLoss()==0 || NormalizeDouble(OrderStopLoss(),Digits)<NormalizeDouble(移损,Digits))
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
                               if( OrderStopLoss()==0 || NormalizeDouble(OrderStopLoss(),Digits)>NormalizeDouble(移损,Digits))
                                   {
                                     bool a= OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(移损,Digits),OrderTakeProfit(),0);
                                   }
                           }        
                      }      
                 }
            }     
    }


void  减仓()
    {
       for(int i=0;i<OrdersTotal();i++)
            {
              if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
                 {
                   if(OrderSymbol()==Symbol() && OrderType()==0 && OrderMagicNumber()==magic && 
                      (OrderComment()=="箭头" ||  OrderComment()=="圆点" || OrderComment()=="MA_BBands" || OrderComment()=="join" || OrderComment()=="super")  )
                      {
                         if(OrderClosePrice()-OrderOpenPrice()>=减仓启动点数*Point )
                           {
                               double 减仓手数=NormalizeDouble(OrderLots()-OrderLots()*(减仓百分比/100),2);
                               
                               if(OrderClose(OrderTicket(),减仓手数,OrderClosePrice(),50)==true)
                               Print("减仓成功");
                           }        
                      }  
                      
                   if(OrderSymbol()==Symbol() && OrderType()==1 && OrderMagicNumber()==magic && 
                     (OrderComment()=="箭头" ||  OrderComment()=="圆点" || OrderComment()=="MA_BBands" || OrderComment()=="join" || OrderComment()=="super") )
                      {
                         if(OrderOpenPrice()-OrderClosePrice()>=减仓启动点数*Point)
                           {
                               double 减仓手数=NormalizeDouble(OrderLots()-OrderLots()*(减仓百分比/100),2);
                               
                               if(OrderClose(OrderTicket(),减仓手数,OrderClosePrice(),50)==true)
                               Print("减仓成功"); 
                           }        
                      }      
                 }
            }     
    }


int op()
    {
       int op=-1;
       datetime objtime=0;
       string  name="";
       string  a="";
       int tishi=0;
       for(int i=ObjectsTotal()-1;i>=0;i--)
          {
             name=ObjectName(i);
             objtime=(datetime)ObjectGet(name,OBJPROP_TIME1);
             if( objtime==Time[1] && StringFind(name,"vtsbh")>=0)
                {
                  a=name;
                  break;
                }
             if( StringFind(name,"vtsbh")>=0)
                {
                  tishi++;
                }  
          }
       if(tishi==0)  Alert("请在图表加载指标");   
      
       if(ObjectGet(a,OBJPROP_ARROWCODE)==233) op=0;
       if(ObjectGet(a,OBJPROP_ARROWCODE)==234) op=1;
       return op;
    }
    
datetime  buytime,selltime;    
    
int buy(double lots,double sl,double tp,string com,int buymagic)
  {
    int a=0;
    bool zhaodan=false;
     for(int i=0;i<OrdersTotal();i++)
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
         if(buytime!=Time[0])
           {
              if(sl!=0 && tp==0)
               {
                a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point(),0,com,buymagic,0,Red);
               }
              if(sl==0 && tp!=0)
               {
                a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,Ask+tp*Point(),com,buymagic,0,Red);
               }
              if(sl==0 && tp==0)
               {
                a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,0,0,com,buymagic,0,Red);
               }
              if(sl!=0 && tp!=0)
               {
                a=OrderSend(Symbol(),OP_BUY,lots,Ask,50,Ask-sl*Point(),Ask+tp*Point(),com,buymagic,0,Red);
               } 
               buytime=Time[0];  
            }    
      }
    return(a);
  }
  
int sell(double lots,double sl,double tp,string com,int sellmagic)
  {
    int a=0;
    bool zhaodan=false;
     for(int i=0;i<OrdersTotal();i++)
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


void 平仓(int ty)
     {
        for(int i=OrdersTotal()-1;i>=0;i--)
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
  int buydanshu(double &op,double &lots,int bmagic,string com="")
  {
     int a=0;
     op=0;
     lots=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && OrderMagicNumber()==bmagic)
              {
                if(com=="")
                  {
                    a++;
                    op=OrderOpenPrice();
                    lots=OrderLots()+lots;
                  }
                else if(OrderComment()=="1" || (com=="ying" && StringFind(OrderComment(),"ying")>=0))
                  {
                     a++;
                     op=OrderOpenPrice();
                     lots=OrderLots()+lots; 
                  }
              }
          }
      }
    return(a);
  }
  
 int selldanshu(double &op,double &lots,int smagic,string com="")
  {
     int a=0;
     op=0;
     lots=0;
     for(int i=0;i<OrdersTotal();i++)
      {
        if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
          {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && OrderMagicNumber()==smagic)
              {
                if(com=="")
                  {
                    a++;
                    op=OrderOpenPrice();
                    lots=OrderLots()+lots;
                  }
                else if(OrderComment()=="1" || (com=="ying" &&  StringFind(OrderComment(),"ying")>=0))
                  {
                     a++;
                     op=OrderOpenPrice();
                     lots=OrderLots()+lots; 
                  }
              }
          }
      }
    return(a);
  }
  
  double GetLots()
{
   double lot;
   double minlot=MarketInfo(Symbol(),MODE_MINLOT);
   double maxlot=MarketInfo(Symbol(),MODE_MAXLOT);
   if(risk!=0)
   {
      lot=NormalizeDouble(AccountBalance()*risk/100/10000,2);
      if(lot<minlot)   lot=minlot;
      if(lot>maxlot)   lot=maxlot;
   }
   else   lot=手数;
   return(lot);
}
    