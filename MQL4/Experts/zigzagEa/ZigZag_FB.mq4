//+------------------------------------------------------------------+
//|                                                    ZigZag_FB.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
extern double profit=0.6;//出仓利润
input int magic=612973;//魔术号
input double volume=0.01;//初始手数
input int points=100;//挂单点位
extern int ZS_P_S= 200;//移动止损点位
extern  int ZS_P_E =100;//移动止损点数
input double JC_Volume = 0.01;//加仓层数
input int  JC_POIT = 20;//挂单加仓因子
input int C_CW_2 = 1000;//止损点
input int G_D_D = 200;//删除挂单点位
input int D_S = 30;//定时器
input int centre = 200;//中间点
input int Y_J = -1000;//预警线
input double accountType=0.01;//账户类型（美元:0.01;美角:0.1;美分:1）
string S_C = "Matrix_G_D_S";//锁仓标识
string S_C_2 = "Matrix_G_D_S_2";//锁仓标识
string mark = "Matrix_G_D";//标识
extern int s = 0;//自动解锁标识
extern int no_M=0;//普通锁变量标识
datetime time=0;
extern int time_zq=30;//时间间隔大小
input int kshu=30;//k线数
bool start_fb=true;//是否加载斐波那契数组
double nFk;
double maxFk;
bool is_fx=false;//反向加仓标识
extern int fx_point=1000;//趋势突破点
string fx_bs = "Matrix_G_D_F_x";
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
datetime alarm=0;
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
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])
     {
      if(start_fb)
        {

         zigZag_f();  //加载斐波那契时间间隔数组

        }
      //if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
      // {
      // fb_xd();
      // }

      //if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
      //{
      for(int i=0; i<ArraySize(time_fb); i++)
        {
         // printf("斐波时间数组："+time_fb[i]);
         //printf("价格单位："+kj_level);
         if(Time[0]==time_fb[i])
           {
            if(Time[0]>time_fb[7])
               return;

            double bfb_S=NormalizeDouble((Bid-l_b_p)/kj_level,2);
            double bfb_b=NormalizeDouble((Ask-l_b_p)/kj_level,2);
            if(High[1]>High[2])
              {
               int ticket = OrderSend(Symbol(),OP_SELL,0.5,Bid,3,0,0,mark,magic);
               for(int j=1; j<ArraySize(price_fb); j++)
                 {
                  double s_l;
                  double s_s;
                  if(price_fb[j-1]<bfb_S && price_fb[j]>bfb_S)
                    {
                     if(price_fb[j]==0.5 || price_fb[j]==0.618  || price_fb[j]==1)
                       {
                        s_l = l_b_p+price_fb[j]*kj_level;
                       }
                     s_l = l_b_p+price_fb[j]*kj_level;
                     s_s = l_b_p+price_fb[j-1]*kj_level;


                    }

                  if(OrderSelect(ticket,SELECT_BY_TICKET))
                    {

                     OrderModify(OrderTicket(),OrderOpenPrice(),s_l,s_s,0);
                    }

                 }

              }
            else
               if(Low[1]<Low[2] || (Low[1]>Low[2] && High[1]<High[2]))
                 {
                  int ticket=OrderSend(Symbol(),OP_BUY,0.5,Ask,3,0,0,"buy",0);
                  for(int j=1; j<ArraySize(price_fb); j++)
                    {
                     double b_s ;
                     double b_l;
                     if(price_fb[j-1]<bfb_b && price_fb[j]>bfb_b)
                       {
                        if(price_fb[j-1]==0.5 || price_fb[j-1]==0.618 || price_fb[j-1]==0)
                          {
                           b_l =l_b_p+price_fb[j-1]*kj_level;
                          }
                        b_l =l_b_p+price_fb[j-1]*kj_level;
                        b_s =l_b_p+price_fb[j]*kj_level;

                       }

                     if(OrderSelect(ticket,SELECT_BY_TICKET))
                       {
                        OrderModify(OrderTicket(),OrderOpenPrice(),b_l,b_s,0);
                       }
                    }

                 }
            start_fb=true;
           }
        }
      // }
      alarm = Time[0];
     }


  }
int zg_k=13;
datetime time_fb[8];//时间间隔数组
double price_fb[8]= {0,0.236,0.382,0.5,0.618,0.764,0.868,1};//价格间隔数组
int sj_kShu;//k线数筛选
double kj_level;//价格单位
int time_fb_js[8]= {0,1,2,3,5,8,13,21};//时间间隔数组
double h_b_p;//最高价
double l_b_p;//最低价
datetime time_DW;//时间单位

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zigZag_f()
  {
   double zigZag[3];
   int shij_bar[3];
   int jishu=0;
   for(int i=0; i<10000; i++)
     {
      double zigZagZhi = iCustom(Symbol(),PERIOD_H4,"ZigZag",zg_k,0,i);
      if(zigZagZhi>0)
        {
         printf("zigZagZhi："+zigZagZhi);
         zigZag[jishu]=zigZagZhi;
         shij_bar[jishu]=i;
         printf("i："+i);
         jishu++;
        }
      if(jishu>=ArraySize(zigZag))
        {
         break;
        }
     }
   datetime h_t;//最高价时间
   datetime l_t;//最低价时间
   time_DW = Time[shij_bar[0]]-Time[shij_bar[1]];

   if(zigZag[0]>zigZag[1] && iCustom(Symbol(),PERIOD_H4,"ZigZag",zg_k,0,0)==0) //当前价格向下
     {
      h_b_p=zigZag[0];
      l_b_p=zigZag[1];
      h_t=Time[shij_bar[0]];
      l_t=Time[shij_bar[1]];
      kj_level = zigZag[0]-zigZag[1];
     }
   if(zigZag[0]<zigZag[1] && iCustom(Symbol(),PERIOD_H4,"ZigZag",zg_k,0,0)==0) //当前价格向上
     {
      h_b_p=zigZag[1];
      l_b_p=zigZag[0];
      h_t=Time[shij_bar[1]];
      l_t=Time[shij_bar[0]];
      kj_level = zigZag[1]-zigZag[0];
     }
   for(int i=0; i<ArraySize(time_fb_js); i++)
     {
      if(l_t>h_t)
        {
         time_fb[i]=h_t+time_fb_js[i]*time_DW;
        }
      if(l_t<h_t)
        {
         time_fb[i]=l_t+time_fb_js[i]*time_DW;
        }
     }
   start_fb=false;
   printf("时间单位："+time_DW);
   printf("空间单位："+kj_level);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void fb_xd()
  {

   if(jy.CheckOrderByaSymbol(Symbol(),magic)==0)
     {
      for(int i=0; i<ArraySize(time_fb); i++)
        {
         if(Time[0]>time_fb[7])
           {
            start_fb=true;
            return;
           }
         if(Time[0]==time_fb[i])
           {

            //double bfb_S=NormalizeDouble((Bid-l_b_p)/kj_level,3);
            //double bfb_b=NormalizeDouble((Ask-l_b_p)/kj_level,3);
            if(High[1]>High[2])
              {
               int ticket = OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,"sell",magic);

               printf("斐波那契指标开仓");

              }
            else
               if(Low[1]<Low[2] || (Low[1]>Low[2] && High[1]<High[2]))
                 {
                  int ticket=OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,"buy",magic);
                  printf("斐波那契指标开仓");

                 }
            start_fb=true;

           }
        }
     }

  }
//+------------------------------------------------------------------+
