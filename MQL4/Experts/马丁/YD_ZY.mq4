//+------------------------------------------------------------------+
//|                                                    qushitupo.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
datetime alarm=0;
extern int magic=612973;//魔术号
string mark = "Matrix_ydzy";//标识
extern int ZS_P_S= 200;//移动止损点位
extern  int ZS_P_E =100;//移动止损点数
//input double accountType=1;//账户类型（美元:1;美角:0.1）
#include <myInclude\ZhiNengJiaoYi.mqh>
ZhiNengJiaoYi jy;
double nFk;
double maxFk;
int OnInit()
  {
   createLabel();
   背景("主面板",10,10);
   label("止损",10,20,"止损:");
   shuRuKuang("stopLoss",50,20,"200",40,20);
   label("止盈",95,20,"止盈:");
   shuRuKuang("takeProfit",135,20,"200",40,20);
   label("zsje",180,20,"止损金额:");
   shuRuKuang("zhiSunMoney",250,20,"-200",50,20);

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

   EventSetTimer(1);
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
   EventKillTimer();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTimer()
  {
    jy.mobileStopLoss(Symbol(),ZS_P_S,ZS_P_E);
     zhiShun();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(alarm!=Time[0])   //datetime格式变量alarm在全局变量中定义，保证同一根K线只执 p 行一遍代码。
     {
     jy.mobileStopLoss(Symbol(),ZS_P_S,ZS_P_E);
     zhiShun();
      alarm=Time[0];
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int guDingZhiShunDian = 3000;
void zhiShun(){
  int total = OrdersTotal();
   for(int i=total-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(OrderSymbol()==Symbol())
              {
               if(OrderType()==OP_BUY && OrderStopLoss()==0)
                 {
                   OrderModify(OrderTicket(),OrderOpenPrice(),Bid-guDingZhiShunDian*Point(),OrderTakeProfit(),0,clrNONE);
                 }
                  if(OrderType()==OP_SELL && OrderStopLoss()==0)
                 {
                   OrderModify(OrderTicket(),OrderOpenPrice(),Ask+guDingZhiShunDian*Point(),OrderTakeProfit(),0,clrNONE);
                 }
                 
                 }}}
}

void ColseOrderBySymbol()
  {
   int total = OrdersTotal();
   while(jy.CheckOrderByaSymbol(Symbol())>0)
     {
      for(int i=total-1; i>=0; i--)
        {
         if(OrderSelect(i, SELECT_BY_POS))
           {
            if(OrderSymbol()==Symbol())
              {
               if(OrderType()==OP_BUY)
                 {

                  if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,Red))
                    {

                     Print("OrderClose failed with error #",GetLastError());
                     Alert("关闭订单"+OrderTicket()+"失败："+GetLastError());
                     SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"关闭订单"+OrderTicket()+"失败");
                    }
                 
                 }

               if(OrderType()==OP_SELL)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,Red))
                    {
                     Print("OrderClose failed with error #",GetLastError());
                     Alert("关闭订单"+OrderTicket()+"失败："+GetLastError());
                     SendNotification("平台:"+AccountCompany()+","+"账号："+AccountNumber()+","+"账户名："+AccountName()+"关闭订单"+OrderTicket()+"失败");
                    }
                  

                 }
      

              }

           }
        }
      Sleep(800);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void anNiu(string name,int x,int y,string text,int width,int high)
  {
   ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrOrangeRed);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,clrDarkOliveGreen);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,high);
   ObjectSetString(0,name,OBJPROP_FONT,"Arial");
   ObjectSetString(0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrForestGreen);
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
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrYellow);
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
   ObjectSetInteger(0,name,OBJPROP_YSIZE,360);
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
   ObjectSetText(name,text,10,"Arial",clrLightSeaGreen);
   ObjectSet(name,OBJPROP_CORNER,0);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void label2(string name,int x,int y,string text)
  {
   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSetText(name,text,20,"Arial",clrLightGoldenrod);
   ObjectSet(name,OBJPROP_CORNER,0);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);

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
   double zhiSunMoney=StringToDouble(ObjectGetString(0,"zhiSunMoney",OBJPROP_TEXT));
   double stopLoss;
   double takeProfit;
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      //非整数时初始为值设置为0
      ObjectSetString(0,"stopLoss",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"stopLoss",OBJPROP_TEXT))) ;
      ObjectSetString(0,"takeProfit",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"takeProfit",OBJPROP_TEXT))) ;
      ObjectSetString(0,"guaDanDian",OBJPROP_TEXT,StringToInteger(ObjectGetString(0,"guaDanDian",OBJPROP_TEXT))) ;
      ObjectSetString(0,"volume",OBJPROP_TEXT,NormalizeDouble(StringToDouble(ObjectGetString(0,"volume",OBJPROP_TEXT)),2)) ;
      ObjectSetString(0,"zhiSunMoney",OBJPROP_TEXT,NormalizeDouble(StringToDouble(ObjectGetString(0,"zhiSunMoney",OBJPROP_TEXT)),2)) ;

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
            jy.ColseOrderBySymbol(Symbol());
           }

        }
      if(sparam=="pingduo")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderBySymbolType(Symbol(),OP_BUY);
           }

        }
      if(sparam=="pingkong")
        {
         if(MessageBox("确认该操作？","确认",4)==6)
           {
            jy.ColseOrderBySymbolType(Symbol(),OP_SELL);
           }

        }
      
        }
     


     

  }




void createLabel()
  {
   label2("最大浮亏",340,20,"最大浮亏:");
   label2("Max_FuKui",460,20,"0");
   label2("当前浮亏",560,20,"当前浮亏:");
   label2("N_FuKui",680,20,"0");

   label2("多单手数",340,50,"多单手数:");
   label2("Buy_lots",460,50,"0");
   label2("空单手数",560,50,"空单手数:");
   label2("Sell_lots",680,50,"0");

   label2("总手数",340,80,"总 手 数:");
   label2("All_Lots",460,80,"0");
   label2("净值/余额",560,80,"净值/余额:");
   label2("BL",690,80,"0");

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void fuKui()
  {

   nFk= NormalizeDouble(AccountProfit(),2);

   if(maxFk>nFk)
     {
      maxFk=nFk;
     }
   ObjectSetText("Max_FuKui",maxFk,20,"Arial",clrLightGoldenrod);
   ObjectSetText("N_FuKui",nFk,20,"Arial",clrLightGoldenrod);
  }



