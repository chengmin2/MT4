//+------------------------------------------------------------------+
//|                                                    qushitupo.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
extern int magic=612973;//魔术号

extern double volume=0.01;//起始计算手数
string mark = "Matrix_base";//标识
string sc_mark = "Matrix_base_SC";//锁仓标识
extern int jc_points =600;//加仓点位
extern  int weiXin=1;//微型账户1标准手缩小倍数
extern  bool isOpenSD = false;//是否开启自触发首单
extern int jc_jisu=2;//加仓基数
extern int cc_profit_points=100;//出仓利润点
extern int dinShi = 3;//定时设置
extern int maxDC = 300;//最大承受点差
enum types {buy=OP_BUY,sell=OP_SELL};
extern types  order_type = buy;//订单类型
double this_orderPrice = 0;//当前订单价格
input int firstPoint=300;//首单出仓利润点

input double real_lots = 0.1;//下单手数
input int loss_stop = 500;//止盈止损

bool isHave_order = false;//是否有订单标记
int nowType=9;
datetime alarm=0;
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
double nFk;
double maxFk;
int OnInit()
  {


   EventSetTimer(dinShi);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   /*int object = ObjectsTotal();
   for(int i=object-1; i>=0; i--)
     {
      ObjectDelete(ObjectName(i));
     }*/
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(checkDianCha())
      return;
   close();//盈利清仓
   if(isOpenSD)
     {
      shouDan_model();
     }
   jiaCang_model();


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {

      OnTimer();
      alarm=Time[0];
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool checkDianCha()
  {
   if(Ask-Bid>=maxDC*Point())
      return true;
   return false;
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void jiaCang_model()
  {
   if(isHave_order)
     {
      if(nowType == OP_BUY && this_orderPrice-Ask>=jc_points*Point()) //sell
        {
         volume = jc_jisu*volume;
         nowType=OP_SELL;
         this_orderPrice=Bid;      
         printf("当前订单开盘价："+this_orderPrice);
         printf("当前订单手数："+volume);
         printf("当前订单方向：OP_SELL");
         if(volume>=0.04 && volume<1.28)
           {
            real_xiaDan(OP_BUY);
           }

        }
      else
         if(nowType == OP_SELL && Bid-this_orderPrice>=jc_points*Point()) //buy
           {
            volume = jc_jisu*volume;
            nowType=OP_BUY;
            this_orderPrice=Ask;
            printf("当前订单开盘价："+this_orderPrice);
            printf("当前订单手数："+volume);
            printf("当前订单方向：OP_BUY");
            if(volume>=0.04 && volume<1.28)
              {
               real_xiaDan(OP_SELL);
              }
           }

     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void close()
  {
   if(isHave_order)
     {
      if(nowType==OP_BUY)
        {
         if(volume ==0.01 && Ask-this_orderPrice>=firstPoint*Point())
           {
            initCanShuBianLiang();
           }
         else
            if(volume >0.01 && Ask-this_orderPrice>(jc_points+cc_profit_points)*Point())
              {
               initCanShuBianLiang();
              }

        }
      else
         if(nowType==OP_SELL)
           {
            if(volume ==0.01 && this_orderPrice-Bid>=firstPoint*Point())
              {
               initCanShuBianLiang();
              }
            else
               if(volume >0.01 &&  this_orderPrice-Bid>(jc_points+cc_profit_points)*Point())
                 {
                  initCanShuBianLiang();
                 }

           }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void initCanShuBianLiang()
  {
   this_orderPrice=0;
   isHave_order=false;
   volume = 0.01;
   printf("关闭订单************");
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void shouDan_model()
  {
   if(!isHave_order)
     {
      if(order_type==OP_BUY)
        {
         nowType=order_type;
         this_orderPrice=Ask;
         printf("当前订单开盘价："+this_orderPrice);
         printf("当前订单手数："+volume);
         printf("当前订单方向：OP_BUY");
        }
      else
         if(order_type==OP_SELL)
           {
            this_orderPrice=Bid;
            nowType=order_type;
            printf("当前订单开盘价："+this_orderPrice);
            printf("当前订单手数："+volume);
            printf("当前订单方向：OP_SELL");
           }
      isHave_order=true;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void real_xiaDan(int type)
  {
   if(type==OP_BUY)
     {
      EventKillTimer();
      if(OrderSend(Symbol(),OP_BUY,real_lots,Ask,3,Ask-loss_stop*Point(),Ask+loss_stop*Point(),mark,magic,0,clrGreen)<0)
        {
         Alert("发送订单失败！");
         Print("OrderSend failed with error #",GetLastError());
        }
      EventSetTimer(dinShi);
     }
   else
      if(type==OP_SELL)
        {
         EventKillTimer();
         if(OrderSend(Symbol(),OP_SELL,real_lots,Bid,3,Bid+loss_stop*Point(),Bid-loss_stop*Point(),mark,magic,0,clrRed)<0)
           {
            Alert("发送订单失败！");
            Print("OrderSend failed with error #",GetLastError());

           }
         EventSetTimer(dinShi);
        }




  }
//+------------------------------------------------------------------+
void createObject(datetime time1,double price1)
  {
   long current_chart_id=ChartID();
   ObjectCreate(0,"震荡标记",OBJ_TREND,0,time1,price1);
   ObjectSetInteger(0,"震荡标记",OBJPROP_COLOR,clrBlack);

  }
//+------------------------------------------------------------------+
