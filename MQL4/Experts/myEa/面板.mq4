//+------------------------------------------------------------------+
//|                                                           面板.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
input int magic=612973;
string S_C = "matrix_SC";
extern int ZS_P_S= 200;//移动止损点位
extern  int ZS_P_E =100;//移动止损点数
datetime 限制运行时间 = D'2028.10.01 00:00';  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
  /*if(AccountNumber()!=51311148){
  MessageBox("该账号未授权！请联系作者15708448760","未授权");
  ExpertRemove();
  }*/
  datetime time = TimeCurrent();
  if(time>限制运行时间){
   MessageBox("该EA已过使用日期，请联系作者15708448760","过期");
  ExpertRemove();
  }
   背景("主面板",10,10);
   label("止损",20,20,"止损:");
   shuRuKuang("stopLoss",60,20,"200",50,20);
   label("止盈",120,20,"止盈:");
   shuRuKuang("takeProfit",160,20,"200",50,20);

   label("挂单",20,50,"挂单点位:");
   shuRuKuang("guaDanDian",100,50,"200",50,20);
   label("手数",160,50,"下单手数:");
   shuRuKuang("volume",240,50,"0.01",50,20);

   anNiu("duo",50,80,"多单",100,20);
   anNiu("kong",160,80,"空单",100,20);

   anNiu("buyStop",10,110,"buyTop",80,20);
   anNiu("buyLimit",95,110,"buyLimt",70,20);
   anNiu("sellStop",170,110,"sellTop",70,20);
   anNiu("sellLimit",250,110,"sellLimt",60,20);

   anNiu("pingcang",10,140,"平当前货币",80,20);
   anNiu("pingduo",95,140,"平多单",70,20);
   anNiu("pingkong",170,140,"平空单",70,20);
   anNiu("pingGua",250,140,"删挂单",60,20);
   anNiu("closeAll",15,170,"平所有货币",90,30);
   anNiu("suoCang",115,170,"锁仓",90,30);
   anNiu("yiDongZhiYing",215,170,"移动止盈",90,30);

   EventSetTimer(60);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   int object = ObjectsTotal();
   for(int i=object-1;i>=0;i--){
     ObjectDelete(ObjectName(i));
   }
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   double volume= StringToDouble(ObjectGetString(0,"volume",OBJPROP_TEXT));
   int LossPoint=StringToInteger(ObjectGetString(0,"stopLoss",OBJPROP_TEXT));
   int profitPoint=StringToInteger(ObjectGetString(0,"takeProfit",OBJPROP_TEXT));
   int point=StringToInteger(ObjectGetString(0,"guaDanDian",OBJPROP_TEXT));
   double stopLoss;
   double takeProfit;
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      //非整数时初始为值设置为0
      ObjectSetString(0,"stopLoss",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"stopLoss",OBJPROP_TEXT))) ;
      ObjectSetString(0,"takeProfit",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"takeProfit",OBJPROP_TEXT))) ;
      ObjectSetString(0,"guaDanDian",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"guaDanDian",OBJPROP_TEXT))) ;
      ObjectSetString(0,"volume",OBJPROP_TEXT,NormalizeDouble(StringToDouble(ObjectGetString(0,"volume",OBJPROP_TEXT)),2)) ;

     }
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(volume==0)
        {
         Alert("请输入正确的下单手数！");
         return;
        }
      if(sparam=="duo")
        {
         if(MessageBox("确认下"+volume+"手多单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Ask-LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Ask+takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_BUY,magic,stopLoss,takeProfit,0);
           }

        }
      if(sparam=="kong")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手空单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Bid+LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Bid-takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_SELL,magic,stopLoss,takeProfit,0);
           }

        }
      if(sparam=="buyStop")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(point==0)
           {
            Alert("挂单点请输入正确的整数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手buyStop单？","确认",4)==6)
           {

            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Ask+point*Point()-LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Ask+point*Point()+takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_BUYSTOP,magic,stopLoss,takeProfit,point);

           }

        }
      if(sparam=="buyLimit")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(point==0)
           {
            Alert("挂单点请输入正确的整数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手buyLimit单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Ask-point*Point()-LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Ask-point*Point()+takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_BUYSTOP,magic,stopLoss,takeProfit,point);
           }

        }
      if(sparam=="sellStop")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(point==0)
           {
            Alert("挂单点请输入正确的整数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手sellStop单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Bid-point*Point()+LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Bid-point*Point()-takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_SELLSTOP,magic,stopLoss,takeProfit,point);
           }

        }
      if(sparam=="sellLimit")
        {
         if(volume==0)
           {
            Alert("请输入正确的下单手数！");
            return;
           }
         if(point==0)
           {
            Alert("挂单点请输入正确的整数！");
            return;
           }
         if(MessageBox("确认下"+volume+"手sellLimit单？","确认",4)==6)
           {
            if(LossPoint==0)
              {
               stopLoss=0;
              }
            else
              {
               stopLoss=Bid+point*Point()+LossPoint*Point();
              };
            if(profitPoint==0)
              {
               takeProfit=0;
              }
            else
              {
               takeProfit=Bid+point*Point()-takeProfit*Point();
              };

            jy.orderSend(Symbol(),volume,OP_SELLSTOP,magic,stopLoss,takeProfit,point);
           }

        }
      if(sparam=="pingcang")
        {

         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderBySymbol(Symbol(),magic);
           }

        }
      if(sparam=="pingduo")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderBySymbol(Symbol(),magic,OP_BUY);
           }

        }
      if(sparam=="pingkong")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderBySymbol(Symbol(),magic,OP_SELL);
           }

        }
      if(sparam=="pingGua")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderGuaBySymbol(Symbol(),magic);
           }

        }

      if(sparam=="closeAll")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseAll();
           }
        }
          if(sparam=="suoCang")
        {

         if(MessageBox("确认进行锁仓？","确认",4)==6)
           {
            double buyVolume = jy.totalVolumeBySymbol(Symbol(),magic,OP_BUY);
            double sellVolume = jy.totalVolumeBySymbol(Symbol(),magic,OP_SELL);

            if(buyVolume == sellVolume)
              {
               Alert("已锁仓/当前处于平衡，操作失败！");
              }
            else
               if(buyVolume>sellVolume)
                 {

                  if(OrderSend(Symbol(),OP_SELL,buyVolume-sellVolume,Bid,2,0,0,S_C,magic)<0)
                    {
                     Alert("锁仓失败！");
                     Print("OrderSend failed with error #",GetLastError());

                    }
                  else
                    {
                     Alert("锁仓成功！");
                     jy.ColseOrderGuaBySymbol(Symbol(),magic);
                    }

                 }
               else
                  if(buyVolume<sellVolume)
                    {
                     if(OrderSend(Symbol(),OP_BUY,sellVolume-buyVolume,Ask,2,0,0,S_C,magic)<0)
                       {

                        Alert("锁仓失败！");
                        Print("OrderSend failed with error #",GetLastError());
                       }
                     else
                       {
                        Alert("锁仓成功！");
                        jy.ColseOrderGuaBySymbol(Symbol(),magic);
                       }
                    }

           }

        }
        if(sparam=="yiDongZhiYing")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
             jy.mobileStopLoss(Symbol(),magic,ZS_P_S,ZS_P_E);
           }
        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void anNiu(string name,int x,int y,string text,int width,int high)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrDarkBlue);
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
//|                                                                  |
//+------------------------------------------------------------------+
void shuRuKuang(string name,int x,int y,string text,int width,int high)
  {
   ObjectCreate(0,name,OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrWhite);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,high);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
//ObjectSetInteger(0,name,OBJPROP_READONLY,20);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrBlack);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void 背景(string name,int x,int y)
  {
   ObjectCreate(0,name,OBJ_EDIT,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrBlack);
   ObjectSetInteger(0,name,OBJPROP_SELECTED,true);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,300);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,200);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,"");
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrLime);
   ObjectSetInteger(0,name,OBJPROP_ALIGN,ALIGN_LEFT);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void label(string name,int x,int y,string text)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSetText(name,text,10,"Arial",clrRed);
   ObjectSet(name,OBJPROP_CORNER,0);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);

  }
//+------------------------------------------------------------------+
