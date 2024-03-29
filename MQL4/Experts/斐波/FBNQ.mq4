//+------------------------------------------------------------------+
//|                                                         FBNQ.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
datetime alarm=0;
input int magic=123456;//魔术号
input double volume=0.02;//起始手数
double start_fb_price;
double  end_fb_price;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
//---

//---
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

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
bool start_fb=true;
void OnTick()
  {
   if(alarm!=Time[0])
     {
      if(start_fb)
         fb_kj();//加载斐波那契时间间隔数组
      if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
        {
         for(int i=0; i<ArraySize(time_fb); i++)
           {
            if(Time[0]==time_fb[i])
              {
              printf("start_fb_price:"+start_fb_price);
               printf("kj_level:"+kj_level); 
               double bfb_S=(Bid-start_fb_price)/kj_level;
               double bfb_b=(Ask-start_fb_price)/kj_level;
               if(Close[1]>Open[1])
                 {
int ticket = OrderSend(Symbol(),OP_SELL,0.5,Bid,3,Ask-400*Point(),Bid-400*Point(),"sell",0);
                  for(int j=0; j<ArraySize(price_fb)-1; j++)
                    {
                    
                     if(price_fb[j]<bfb_S && price_fb[j+1]>=bfb_S)
                       {
                        double s_l = end_fb_price;
                        double s_s = start_fb_price;
                        
                        OrderSelect(ticket,SELECT_BY_TICKET); 
                        OrderModify(ticket,Bid,Ask-400*Point(),s_s,0);
                        
                       }

                    }


                 }
               if(Close[1]<Open[1])
                 {
                  int ticket=OrderSend(Symbol(),OP_BUY,0.5,Ask,3,Ask-400*Point(),Ask+400*Point(),"buy",0);
                  for(int j=0; j<ArraySize(price_fb)-1; j++)
                    {
                    
                     if(price_fb[j]<bfb_b && price_fb[j+1]>bfb_b)
                       {
                        double b_s =start_fb_price;
                        double b_l = end_fb_price;
                        OrderSelect(ticket,SELECT_BY_TICKET); 
                        OrderModify(ticket,Ask,Ask-400*Point(),b_l,0);
                       }

                    }

                 }
              }
           }
        }
      alarm = Time[0];
     }

  }
int time_zq=30;
datetime time_fb[9];
double price_fb[8]={-0.236,0,0.236,0.382,0.5,0.618,0.764,0.868};
int sj_kShu;
double kj_level;

void  fb_kj()
  {
   int kshu=30;
   int h1_bar;
   int h2_bar;
   int l_bar;
   int h_total;

   for(int i=10; i<=1000; i++)
     {
      h1_bar = iHighest(Symbol(),0,MODE_HIGH,kshu,i);
      h2_bar = iHighest(Symbol(),0,MODE_HIGH,kshu,h1_bar+1);
      if(h2_bar-h1_bar<20)
        {
         h1_bar=0;
         h2_bar =0;
        }
      if(h1_bar!=0 && h2_bar!=0)
        {
         break;
        }
     }
   l_bar = iLowest(Symbol(),0,MODE_LOW,h2_bar-h1_bar,h1_bar);

   double h1_p=iHigh(Symbol(),0,h1_bar);
   double h2_p=iHigh(Symbol(),0,h2_bar);
   double l_p=iLow(Symbol(),0,l_bar);
   datetime h1_t=Time[h1_bar];
   datetime h2_t=Time[h2_bar];
   datetime l_t=Time[l_bar];

   sj_kShu = l_bar-h1_bar;
   ObjectCreate("斐波那奇_回调_1",OBJ_FIBO,0,l_t,l_p,h1_t,h1_p);
   /*ObjectCreate("斐波那奇_回调_2",OBJ_FIBO,0,h2_t,h2_p,l_t,l_p);
   ObjectCreate("斐波那奇_回调_3",OBJ_FIBO,0,h2_t,h2_p,h1_t,h1_p);*/

   ObjectCreate("斐波那奇_时间_1",OBJ_FIBOTIMES,0,l_t,l_p,h1_t,h1_p);
// ObjectCreate("斐波那奇_时间_2",OBJ_FIBOTIMES,0,h2_t,h2_p,l_t,l_p);

//ObjectCreate("斐波那奇_时间_3",OBJ_FIBOTIMES,0,h2_t,h2_p,h1_t,h1_p);
   int time_fb_js[8]= {0,1,2,3,5,8,13,21};

   for(int i=0; i<ArraySize(time_fb_js); i++)
     {
      time_fb[i]=Time[l_bar]+time_fb_js[i]*time_zq*60;

     }
  // kj_level=High[h1_bar] -Low[l_bar];
   start_fb_price=Low[l_bar];
   end_fb_price=High[h1_bar];
   kj_level=end_fb_price - start_fb_price;

   printf("start_fb_price="+start_fb_price);
    printf("end_fb_price="+end_fb_price);
    printf("kj_level="+kj_level);
//printf(l_t+","+h2_t+","+h1_p);
//Alert(ObjectGetFiboDescription("斐波那奇_时间_3",5));
//ObjectGet("斐波那奇_时间_3",OBJPROP_FIBOLEVELS);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  fb_sj()
  {
//ObjectCreate(0,"斐波那奇_时间",OBJ_FIBOTIMES,0,);
  }
//+------------------------------------------------------------------+
