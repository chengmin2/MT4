//+------------------------------------------------------------------+
//|                                                        feibo.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
extern int fibhulue6=6;//忽略6设置 忽略一个百分比位置挂单 0123456对应-23.6%--76.4%  数字8为不忽略
extern int fibhulue5=5;// 0,1,2,3,4,5,6分别对应-23.6% 0% 23.6% 38.2% 50% 61.8% 76.4% 数字8为不忽略
extern int fibhulue4=8;//忽略4设置50% 填相对应的忽略数字即为不在这个百分比位挂单
extern int fibhulue3=8;//忽略3设置38.2% 例如填8为不忽略38.2% 填3为忽略这个位置
extern int fibhulue2=8;//忽略2设置23.6%   O+f buylimit K+f selllimit
extern int fibhulue1=8;//忽略1设置0%
extern int fibhulue0=8;//忽略0设置 -23.6%位置带止损挂单 对付一些假突破行情
extern int fibGuadansl1=100;//-23.6%位置挂单止损点数 0不设止损 尽量设置上止损 以防真突破
extern int fibbuypianyiliang=-15;//buylimit偏移量 在计算结果的基础上整体上移或下移多少点
extern int fibsellpianyiliang=5;//sellimit偏移量 在计算结果的基础上整体上移或下移多少点
extern double fibGuadanlots=0.2;//挂单手数
extern int fibGuadangeshu=1;//开始时挂单个数  每增加一个百分比位置挂单数加一
extern int fibGuadanjianju=3;//挂单间距
extern int fibGuadanjuxianjia=20;//保险措施 距现价挂单的最小点数
extern int fibGuadansl=0;//挂单止损点数 0不设止损
extern int fibGuadantp=0;//挂单止盈点数 0不设止盈
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
//---
   
  }
void Fibguadan(int guadantype,double lowprice,double highprice)//guadantype=0 buylimit guadantype=1 selllimit 斐波那契挂单
  {
   int sl=fibGuadansl;
   int geshu=fibGuadangeshu;
   double fib[7]= {-0.236,0,0.236,0.382,0.5,0.618,0.764};
   if(guadantype==0)
     {

      for(int i=6; i>=0; i--)

        {
         if(i==fibhulue6 || i==fibhulue5 || i==fibhulue4 || i==fibhulue3 || i==fibhulue2 || i==fibhulue1 || i==fibhulue0)
            continue;
         double price=NormalizeDouble(lowprice+(highprice-lowprice)*fib[i]-fibbuypianyiliang*Point,Digits);
         Print("i=",i," 百分比位",fib[i]*100,"%"," 挂单个数=",geshu,"  挂单价位=",price);
         if(price>Ask)
            continue;
         if(i==0 && fibGuadansl1!=0)
            sl=fibGuadansl1;
         //Print(fibGuadansl);
         Guadanbuylimit(fibGuadanlots,price,geshu,fibGuadanjianju,sl,fibGuadantp,fibGuadanjuxianjia);
         geshu++;
        }
     }
     



   if(guadantype==1)
     {
      for(int i=6; i>=0; i--)



        {
         if(i==fibhulue6 || i==fibhulue5 || i==fibhulue4 || i==fibhulue3 || i==fibhulue2 || i==fibhulue1 || i==fibhulue0)
            continue;
         double price=NormalizeDouble(highprice-(highprice-lowprice)*fib[i]+fibsellpianyiliang*Point,Digits);
         Print("i=",i," 百分比位",fib[i]*100,"%"," 挂单个数=",geshu,"  挂单价位=",price);
         if(price<Bid)
            continue;
         if(i==0 && fibGuadansl1!=0)
            sl=fibGuadansl1;
         Guadanselllimit(fibGuadanlots,price,geshu,fibGuadanjianju,sl,fibGuadantp,fibGuadanjuxianjia);
         geshu++;
        }
     }

  }
  void Guadanselllimit(double lots,double price,int geshu,int jianju,double sl,double tp,int juxianjia)//委卖单
  {
   double guadansl=0,guadantp=0;
   double sl1=sl,tp1=tp;
   if(Bid+juxianjia*Point>price)
      price=Bid+juxianjia*Point;
   for(int i=geshu; i>0; i--)
     {
      if(sl==MathRound(sl))
        {
         if(sl==0.0)
           {
            guadansl=0;
           }
         else
           {
            guadansl=price+sl*Point;
           }
        }
      else
        {
         guadansl=sl1;
        }
      if(tp==MathRound(tp))
        {
         if(tp==0.0)
           {
            guadantp=0;
           }
         else
           {
            guadantp=price-tp*Point;
           }
        }
      else
        {
         guadantp=tp1;
        }
      //if(sl!=0) guadansl=price+sl*Point;
      //if(tp!=0) guadantp=price-tp*Point;
      int ticket=OrderSend(Symbol(),OP_SELLLIMIT,lots,price,3,guadansl,guadantp,NULL,0,0,CLR_NONE);



      if(ticket>0)
        {
         price+=jianju*Point;
         sl1+=jianju*Point;
         tp1+=jianju*Point;
        }
      else
        {
         PlaySound("timeout.wav");
        }
     }
   PlaySound("ok.wav");
  }
  void Guadanbuylimit(double lots,double price,int geshu,int jianju,double sl,double tp,int juxianjia)//委买单
  {
   double guadansl=0.0,guadantp=0.0;
   double sl1=sl,tp1=tp;
   if(Ask-juxianjia*Point<price)
      price=Ask-juxianjia*Point;
   for(int i=geshu; i>0; i--)
     {
      if(sl==MathRound(sl))
        {
         if(sl==0.0)
           {
            guadansl=0;
           }
         else
           {
            guadansl=price-sl*Point;
           }
        }
      else
        {
         guadansl=sl1;
        }



      if(tp==MathRound(tp))
        {
         if(tp==0.0)
           {
            guadantp=0;
           }
         else
           {
            guadantp=price+tp*Point;
           }
        }
      else
        {
         guadantp=tp1;
        }
      // if(sl!=0) guadansl=price-sl*Point;
      // if(tp!=0) guadantp=price+tp*Point;
      int ticket=OrderSend(Symbol(),OP_BUYLIMIT,lots,price,3,guadansl,guadantp,NULL,0,0,CLR_NONE);



      if(ticket>0)
        {
         price-=jianju*Point;
         sl1-=jianju*Point;
         tp1-=jianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
   PlaySound("ok.wav");
  }