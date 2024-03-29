//+------------------------------------------------------------------+
//|                                                       SNS_JC.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
datetime alarm=0;
int magic_s=123456;
int magic_n=654321;
input double volume=0.01;//起始手数
input double fengKong = 1;//风控比列
input int jiShu_s=30;//顺势加仓点位
input int ss_guaDian=100;//顺势挂仓点
input int jiShu_n=100;//逆势加仓点
extern double ns_profit=4;//逆势出仓利润
extern double ss_profit=2;//顺势出仓利润
input int huiCeDian=200;//回撤顺势点
string mark = "Matrix_SNS";//标识
input double min_unit=0.01;//最小计量单位
input double accountType=0.1;//账户类型（美元:1;美角:0.1）
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+-
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
    
     
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//jy.closeHandMovement();
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
       close();
       jy.mobileStopLoss(Symbol(),magic_s,200,100);
       //jy.mobileStopLoss(Symbol(),magic_n,200,100);
       jy.deleteGuanDanByPrice(Symbol(),(huiCeDian+ss_guaDian),magic_s);
       jy.deleteGuanDanByPrice(Symbol(),(huiCeDian+ss_guaDian),magic_n);
      if(jy.CheckOrderByaSymbol(Symbol(),magic_s)==0)
        {       
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic_s);
         OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic_s);

        }
      if(jy.CheckOrderByaSymbol(Symbol(),magic_n)==0)
        {       
         OrderSend(Symbol(),OP_BUY,volume,Ask,3,0,0,mark,magic_n);
         OrderSend(Symbol(),OP_SELL,volume,Bid,3,0,0,mark,magic_n);

        }
           
      if(jy.niSiJiaCang(Symbol(),volume,magic_n,jiShu_n,mark,min_unit)==0){
          Alert("逆势加仓出错！");
          Print("OrderSend failed with error逆势加仓出错 #",GetLastError());
      }
      if(jy.shunShiJC(Symbol(),volume,jiShu_s,ss_guaDian,magic_s,min_unit,accountType,mark,ss_profit)==0){
         Alert("顺势加仓出错！");
         Print("OrderSend failed with error 顺势加仓出错#",GetLastError());
      }       
      alarm=Time[0];
     }
  }


void close()
  {
  
   int rt;
   if(jy.profitBySymbolTotal(Symbol(),magic_n,OP_BUY)>ns_profit)
     {
      rt = jy.ColseOrderBySymbol(Symbol(),magic_n,OP_BUY);
      if(rt==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic_n,OP_SELL)>ns_profit)
     {
      rt = jy.ColseOrderBySymbol(Symbol(),magic_n,OP_SELL);
      if(rt==0)
         Alert("关闭空单交易出错！");
     }
   if(jy.profitBySymbolTotal(Symbol(),magic_s,OP_BUY)>ss_profit)
     {
      ss_profit=2*accountType;
      jy.ColseOrderGuaBySymbol(Symbol(),magic_s);
      rt = jy.ColseOrderBySymbol(Symbol(),magic_s,OP_BUY);
      if(rt==0)
         Alert("关闭多单交易出错！");

     }
   if(jy.profitBySymbolTotal(Symbol(),magic_s,OP_SELL)>ss_profit)
     {
      ss_profit=2*accountType;
      jy.ColseOrderGuaBySymbol(Symbol(),magic_s);
      rt = jy.ColseOrderBySymbol(Symbol(),magic_s,OP_SELL);
      if(rt==0)
         Alert("关闭空单交易出错！");
     }

  }
//+------------------------------------------------------------------+
