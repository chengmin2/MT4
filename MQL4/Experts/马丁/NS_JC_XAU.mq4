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
input double min_unit=0.01;//最小计量单位
extern double stopEa = -50000;//爆仓值
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
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
      bc();
     int ticket;  
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


