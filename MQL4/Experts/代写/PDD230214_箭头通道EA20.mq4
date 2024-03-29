
#property description "-------------------------------"
#property version   "2.0"
#property strict

//0923 1

extern ENUM_TIMEFRAMES    periodK=PERIOD_CURRENT;                    //运行K线图表周期

input string            Comment2="======订单参数设置======";    //★
extern int                MagicN=202301;                       //订单识别码
extern int                xinhk=3;                              //信号间隔限k数
extern double             Lots=0.1;                             //下单手数
extern int                gapsg=100;                           //挂单距离点数
extern int                zhisun=0;                           //止损微点数
extern int                zhiying=0;                          //止盈微点数
extern int                qidong=200;                           //移动止损启动点数
extern int                yidong=100;                           //移动止损回调点数
extern int                dans=10;                             //加仓次数
extern double             Lotsb=1.5;                             //加仓倍数
extern int                gaps=100;                             //加仓间隔点数限制
extern double             kaojin=50;                             //靠近中轨比例
input string            Comment3="";    //★比例越小越靠近中轨
extern string             Commentt="EA";                        //订单注释
extern bool               Use_Sound=true;                       //交易声音开关
extern bool               AutoDelete=false;                     //自动清理下单标记
int slippage=600;
datetime Time0;
datetime Time1;
datetime Time2;
datetime Time3;
int l_count_0;
int l_count_1;
int l_countg_0;
int l_countg_1;
double c_count_0;
double c_count_1;
double openprice_0;
double openprice_1;
double openprice_00;
double openprice_11;
double t_count_0;
double t_count_1;
double p_count_0;
double p_count_1;
double Lotg0;
double Lotg1;
double STOPLEVEL;
bool aa;
int xiaoshu;
string OBName;
bool open0=true;
double  shangj(int shift)
  {
   double shan=iCustom(NULL,periodK,"Arrow_Alert",0,0);
   if(shan>100000){shan=0;}
   return(shan);
  }
double  xiaj(int shift)
  {
   double xia=iCustom(NULL,periodK,"Arrow_Alert",1,0);
   if(xia>100000){xia=0;}
   return(xia);
  }
double  shangj2(int shift)
  {
   double shan=iCustom(NULL,periodK,"VJV3",0,0); 
   if(shan>100000){shan=0;}
   return(shan);
  }
double  xiaj2(int shift)
  {
   double xia=iCustom(NULL,periodK,"VJV3",1,0); 
   if(xia>100000){xia=0;}
   return(xia);
  }

datetime time(int shift){
   return(iTime(NULL,periodK,shift));
  }
double  close(int shift)
  {
   return(iClose(NULL,periodK,shift));
  }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(MarketInfo(Symbol(),24)<10.0)
     {
      xiaoshu=0;
     }
   if(MarketInfo(Symbol(),24)<1.0)
     {
      xiaoshu=1;
     }
   if(MarketInfo(Symbol(),24)<0.1)
     {
      xiaoshu=2;
     }
   EventSetMillisecondTimer(500);
   STOPLEVEL=MarketInfo(Symbol(),MODE_STOPLEVEL);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

void OnDeinit(const int reason)
  {
  
/*
X根k内出现两个箭头（箭头指标+顺势箭头），收盘信号，且收盘价格在Y通道轨道内，下个k开盘开单

*/
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(IsTradeAllowed()==false && TimeCurrent()-Time2>20)
     {
      Alert("未打开智能交易开关或哭脸状态");//Alert("Experts not allowed");
      Alert("请先打开智能交易开关后再加载EA");//Alert("Please open the button");
      Time2=TimeCurrent();
     }
   if(AutoDelete)DeleteArrow();
   OnTimer();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   CountOrders();
   
   if(yidong>0)
     {
      if(yidong<STOPLEVEL)
        {
         if(TimeCurrent()-Time3>5)
           {
            Time3=TimeCurrent();
            Alert("整体移动止损设置太小,不得低于",DoubleToStr(MarketInfo(Symbol(),MODE_STOPLEVEL),0));
           }
         return;
        }
      ModifyOrdersZ();
     }
   double MaxLots=MarketInfo(Symbol(),MODE_MAXLOT); 
   if(MarketInfo(Symbol(),MODE_TRADEALLOWED) || IsTesting())
     {
      ModifyOrdersG();
      if(l_count_0==0 && l_countg_0>0 && Lotg0>Lots){DeleteOrders(4);}
      if(l_count_1==0 && l_countg_1>0 && Lotg1>Lots){DeleteOrders(5);}
      if(xinh0() && (shangj(1)>0 || shangj2(1)>0))
        {
         if(l_count_1>0){CloseOrders(1);}
         if(l_countg_0==0 && l_count_0<dans && Time0!=time(0) && (openprice_0-Ask>=gaps*Point || openprice_0==0))
           {
            open_buystop(MathMin(MaxLots,NormalizeDouble(Lots*MathPow(Lotsb,l_count_0),xiaoshu)),gapsg,zhisun,zhiying,Commentt,MagicN);
            Time0=time(0);
           }
        }
      if(xinh1() && (xiaj(1)>0 || xiaj2(1)>0))
        {
         if(l_count_0>0){CloseOrders(0);}
         if(l_countg_1==0 && l_count_1<dans && Time1!=time(0) && Bid-openprice_1>=gaps*Point)
           {
            open_sellstop(MathMin(MaxLots,NormalizeDouble(Lots*MathPow(Lotsb,l_count_1),xiaoshu)),gapsg,zhisun,zhiying,Commentt,MagicN);
            Time1=time(0);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CountOrders()
  {
   l_count_0 = 0;
   l_count_1 = 0;
   l_countg_0 = 0;
   l_countg_1 = 0;
   t_count_0 = 0;
   t_count_1 = 0;
   c_count_0 = 0;
   c_count_1 = 0;
   p_count_0 = 0;
   p_count_1 = 0;
   openprice_0 = 0;
   openprice_1 = 0;
   openprice_00 = 0;
   openprice_11 = 0;
   Lotg0=0;
   Lotg1=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicN || MagicN==0))
        {
         if(OrderType()==OP_BUY)
           {
            l_count_0++;
            t_count_0 += OrderLots();
            c_count_0 += OrderOpenPrice()*OrderLots();
            p_count_0 += OrderProfit() + OrderSwap() + OrderCommission();
            openprice_0= OrderOpenPrice();
           }
         if(OrderType()==OP_SELL)
           {
            l_count_1++;
            t_count_1 += OrderLots();
            c_count_1 += OrderOpenPrice()*OrderLots();
            p_count_1 += OrderProfit() + OrderSwap() + OrderCommission();
            openprice_1= OrderOpenPrice();
           }
         if(OrderType()==OP_BUYSTOP)
           {
            l_countg_0++;
            Lotg0=OrderLots();
           }
         if(OrderType()==OP_SELLSTOP)
           {
            l_countg_1++;
            Lotg1=OrderLots();
           }
        }
     }
   if(t_count_0>0) openprice_00=NormalizeDouble(c_count_0/t_count_0,Digits);
   if(t_count_1>0) openprice_11=NormalizeDouble(c_count_1/t_count_1,Digits);
  }
void ModifyOrdersZ()
  {
   if(l_count_0 > 0 && yidong > 0 && Bid - openprice_00 >= qidong*Point) ModifyOrdersZ0(0,Bid - yidong*Point);
   if(l_count_1 > 0 && yidong > 0 && openprice_11 - Ask >= qidong*Point) ModifyOrdersZ0(1,Ask + yidong*Point);
  }
void DeleteOrders(int type)
  {
   aa=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicN || MagicN==0))
        {
         if(OrderType()==type)
           {
            aa=OrderDelete(OrderTicket());
            if(!aa) Alert("删除定单错误 = ",iGetErrorInfo(GetLastError()));
            if(Use_Sound) PlaySound("ok.wav");
           }
        }
     }
   if(aa && AutoDelete) DeleteArrow();
  }
bool xinh0()
  {
   int value0=0;
   int value1=0;
   bool value=false;
   for(int i=1; i<=xinhk; i++)
     {
      if(shangj(i)>0)value0=1;
      if(shangj2(i)>0)value1=1;
     }
   if(value0+value1>1){value=true;}
   return(value);
  }
bool xinh1()
  {
   int value0=0;
   int value1=0;
   bool value=false;
   for(int i=1; i<=xinhk; i++)
     {
      if(xiaj(i)>0)value0=1;
      if(xiaj2(i)>0)value1=1;
     }
   if(value0+value1>1){value=true;}
   return(value);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ModifyOrdersZ0(int type,double STPrice0)
  {
   aa=false;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicN || MagicN==0))
        {
         if(OrderType()==type)
           {
            if(OrderType()==OP_BUY)
              {
               if(OrderStopLoss()<STPrice0)
                 {
                  aa=OrderModify(OrderTicket(),OrderOpenPrice(),STPrice0,OrderTakeProfit(),0,Yellow);
                  //if(!aa) Alert("修改定单错误 = ",GetLastError());
                 }
              }
            if(OrderType()==OP_SELL)
              {
               if(OrderStopLoss()==0 || OrderStopLoss()>STPrice0)
                 {
                  aa=OrderModify(OrderTicket(),OrderOpenPrice(),STPrice0,OrderTakeProfit(),0,Yellow);
                  //if(!aa) Alert("修改定单错误 = ",GetLastError());
                 }
              }
           }
        }
     }
   if(aa && AutoDelete) DeleteArrow();
  }
//+------------------------------------------------------------------+
int open_buy(double lots,double SLdian,double TPdian,string comment,int magic)
  {
   int Ticket=0;
   if((SLdian!=0) && (TPdian!=0))
     {Ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,slippage,Ask-SLdian*Point,Ask+TPdian*Point,comment,magic,0,Red);}
   if((SLdian==0) && (TPdian!=0))
     {Ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,slippage,0,Ask+TPdian*Point,comment,magic,0,Red);}
   if((SLdian!=0) && (TPdian==0))
     {Ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,slippage,Ask-SLdian*Point,0,comment,magic,0,Red);}
   if((SLdian==0) && (TPdian==0))
     {Ticket=OrderSend(Symbol(),OP_BUY,lots,Ask,slippage,0,0,comment,magic,0,Red);}
   if(Ticket>0 && Use_Sound) PlaySound("ok.wav");
   //if(Ticket<0)Alert(iGetErrorInfo(GetLastError()));
   return(Ticket);
  }
int open_sell(double lots,double SLdian,double TPdian,string comment,int magic)
  {
   int Ticket=0;
   if((SLdian!=0) && (TPdian!=0))
     {Ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,slippage,Bid+SLdian*Point,Bid-TPdian*Point,comment,magic,0,Green);}
   if((SLdian==0) && (TPdian!=0))
     {Ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,slippage,0,Bid-TPdian*Point,comment,magic,0,Green);}
   if((SLdian!=0) && (TPdian==0))
     {Ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,slippage,Bid+SLdian*Point,0,comment,magic,0,Green);}
   if((SLdian==0) && (TPdian==0))
     {Ticket=OrderSend(Symbol(),OP_SELL,lots,Bid,slippage,0,0,comment,magic,0,Green);}
   if(Ticket>0 && Use_Sound) PlaySound("ok.wav");
   //if(Ticket<0)Alert(iGetErrorInfo(GetLastError()));
   return(Ticket);
  }
int open_buystop(double lots,double guadanjuli,double SLdian,double TPdian,string comment,int magic)
    {int Ticket=0;
      if((SLdian!=0)&&(TPdian!=0))
        {Ticket=OrderSend(Symbol(),OP_BUYSTOP,lots,Ask+guadanjuli*Point,slippage,Ask+guadanjuli*Point-SLdian*Point,Ask+guadanjuli*Point+TPdian*Point,comment,magic,0,Red);}
      if((SLdian==0)&&(TPdian!=0))
        {Ticket=OrderSend(Symbol(),OP_BUYSTOP,lots,Ask+guadanjuli*Point,slippage,0,Ask+guadanjuli*Point+TPdian*Point,comment,magic,0,Red);}
      if((SLdian!=0)&&(TPdian==0))
        {Ticket=OrderSend(Symbol(),OP_BUYSTOP,lots,Ask+guadanjuli*Point,slippage,Ask+guadanjuli*Point-SLdian*Point,0,comment,magic,0,Red);}
      if((SLdian==0)&&(TPdian==0))
        {Ticket=OrderSend(Symbol(),OP_BUYSTOP,lots,Ask+guadanjuli*Point,slippage,0,0,comment,magic,0,Red);}
   if(Ticket>0 && Use_Sound) PlaySound("ok.wav");
   //if(Ticket<0)Alert(iGetErrorInfo(GetLastError()));
   return(Ticket);}
int open_sellstop(double lots,double guadanjuli,double SLdian,double TPdian,string comment,int magic)
    {int Ticket=0;
      if((SLdian!=0)&&(TPdian!=0))
        {Ticket=OrderSend(Symbol(),OP_SELLSTOP,lots,Bid-guadanjuli*Point,slippage,Bid-guadanjuli*Point+SLdian*Point,Bid-guadanjuli*Point-TPdian*Point,comment,magic,0,clrGreen);}
      if((SLdian==0)&&(TPdian!=0))
        {Ticket=OrderSend(Symbol(),OP_SELLSTOP,lots,Bid-guadanjuli*Point,slippage,0,Bid-guadanjuli*Point-TPdian*Point,comment,magic,0,clrGreen);}
      if((SLdian!=0)&&(TPdian==0))
        {Ticket=OrderSend(Symbol(),OP_SELLSTOP,lots,Bid-guadanjuli*Point,slippage,Bid-guadanjuli*Point+SLdian*Point,0,comment,magic,0,clrGreen);}
      if((SLdian==0)&&(TPdian==0))
        {Ticket=OrderSend(Symbol(),OP_SELLSTOP,lots,Bid-guadanjuli*Point,slippage,0,0,comment,magic,0,clrGreen);}
   if(Ticket>0 && Use_Sound) PlaySound("ok.wav");
   //if(Ticket<0)Alert(iGetErrorInfo(GetLastError()));
   return(Ticket);}
void DeleteArrow()
  {
   for(int i=ObjectsTotal()-1; i>=0; i--)
     {
      OBName=ObjectName(i);
      if(StringFind(OBName,"#",0)<0)
         continue;
      if(ObjectType(OBName)==OBJ_ARROW || ObjectType(OBName)==OBJ_TREND)
         ObjectDelete(OBName);
     }
  }
void ModifyOrdersG() {
aa = false;
for(int i = 0; i < OrdersTotal(); i++) {
   if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
   if(OrderSymbol() == Symbol() && (OrderMagicNumber() == MagicN || MagicN==0)) {
         if(OrderType()==OP_BUYSTOP  && OrderOpenPrice()-Ask>gapsg*Point)
           {
            double  op0,zhis0=0,zhiy0=0;
            op0=Ask+gapsg*Point;
            if(zhisun>0)zhis0=op0-zhisun*Point;
            if(zhiying>0)zhiy0=op0+zhiying*Point;
            aa=OrderModify(OrderTicket(),op0,zhis0,zhiy0,0);
           } 
         if(OrderType()==OP_SELLSTOP && Bid-OrderOpenPrice()>gapsg*Point)
           {
            double  op1,zhis1=0,zhiy1=0;
            op1=Bid-gapsg*Point;
            if(zhisun>0)zhis1=op1+zhisun*Point;
            if(zhiying>0)zhiy1=op1-zhiying*Point;
            aa=OrderModify(OrderTicket(),op1,zhis1,zhiy1,0);
           }
     }
  }
 if(aa && AutoDelete) DeleteArrow();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseOrders(int type)
  {
//return;
   aa=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()==Symbol() && (OrderMagicNumber()==MagicN))
        {
         if(OrderType()==type)
           {
            aa=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slippage,Yellow);
            if(aa && Use_Sound) PlaySound("ok.wav");
           }
        }
     }
   if(aa && AutoDelete) DeleteArrow();
  }
string iGetErrorInfo(int myErrorNum)
  {
   string myLastErrorStr;
   if(myErrorNum>0)
     {
      switch(myErrorNum)
        {
         case 0   :myLastErrorStr="交易报错:0  没有错误返回";break;
         case 1   :myLastErrorStr="交易报错:1  没有错误返回,可能是反复同价修改";break;
         case 2   :myLastErrorStr="交易报错:2  一般错误";break;
         case 3   :myLastErrorStr="交易报错:3  交易参数出错";break;
         case 4   :myLastErrorStr="交易报错:4  交易服务器繁忙";break;
         case 5   :myLastErrorStr="交易报错:5  客户终端软件版本太旧";break;
         case 6   :myLastErrorStr="交易报错:6  没有连接交易服务器";break;
         case 7   :myLastErrorStr="交易报错:7  操作权限不够";break;
         case 8   :myLastErrorStr="交易报错:8  交易请求过于频繁";break;
         case 9   :myLastErrorStr="交易报错:9  交易操作故障";break;
         case 64  :myLastErrorStr="交易报错:64  账户被禁用";break;
         case 65  :myLastErrorStr="交易报错:65  无效账户";break;
         case 128 :myLastErrorStr="交易报错:128  交易超时";break;
         case 129 :myLastErrorStr="交易报错:129  无效报价";break;
         case 130 :myLastErrorStr="交易报错:130  止损错误";break;
         case 131 :myLastErrorStr="交易报错:131  交易量错误";break;
         case 132 :myLastErrorStr="交易报错:132  休市";break;
         case 133 :myLastErrorStr="交易报错:133  禁止交易";break;
         case 134 :myLastErrorStr="交易报错:134  资金不足";break;
         case 135 :myLastErrorStr="交易报错:135  报价发生改变";break;
         case 136 :myLastErrorStr="交易报错:136  建仓价过期";break;
         case 137 :myLastErrorStr="交易报错:137  经纪商很忙";break;
         case 138 :myLastErrorStr="交易报错:138  需要重新报价";break;
         case 139 :myLastErrorStr="交易报错:139  定单被锁定";break;
         case 140 :myLastErrorStr="交易报错:140  只允许做买入类型操作";break;
         case 141 :myLastErrorStr="交易报错:141  请求过多";break;
         case 145 :myLastErrorStr="交易报错:145  过于接近报价，禁止修改";break;
         case 146 :myLastErrorStr="交易报错:146  交易繁忙";break;
         case 147 :myLastErrorStr="交易报错:147  交易期限被经纪商取消";break;
         case 148 :myLastErrorStr="交易报错:148  持仓单数量超过经纪商的规定";break;
         case 149 :myLastErrorStr="交易报错:149  禁止对冲";break;
         case 150 :myLastErrorStr="交易报错:150  FIFO禁则";break;
         case 4000:myLastErrorStr="运行报错:4000  没有错误返回";break;
         case 4001:myLastErrorStr="运行报错:4001  函数指针错误";break;
         case 4002:myLastErrorStr="运行报错:4002  数组越界";break;
         case 4003:myLastErrorStr="运行报错:4003  调用栈导致内存不足";break;
         case 4004:myLastErrorStr="运行报错:4004  递归栈溢出";break;
         case 4005:myLastErrorStr="运行报错:4005  堆栈参数导致内存不足";break;
         case 4006:myLastErrorStr="运行报错:4006  字符串参数导致内存不足";break;
         case 4007:myLastErrorStr="运行报错:4007  临时字符串导致内存不足";break;
         case 4008:myLastErrorStr="运行报错:4008  字符串变量缺少初始化赋值";break;
         case 4009:myLastErrorStr="运行报错:4009  字符串数组缺少初始化赋值";break;
         case 4010:myLastErrorStr="运行报错:4010  字符串数组空间不够";break;
         case 4011:myLastErrorStr="运行报错:4011  字符串太长";break;
         case 4012:myLastErrorStr="运行报错:4012  因除数为零导致的错误";break;
         case 4013:myLastErrorStr="运行报错:4013  除数为零";break;
         case 4014:myLastErrorStr="运行报错:4014  错误的命令";break;
         case 4015:myLastErrorStr="运行报错:4015  错误的跳转";break;
         case 4016:myLastErrorStr="运行报错:4016  数组没有初始化";break;
         case 4017:myLastErrorStr="运行报错:4017  禁止调用DLL ";break;
         case 4018:myLastErrorStr="运行报错:4018  库文件无法调用";break;
         case 4019:myLastErrorStr="运行报错:4019  函数无法调用";break;
         case 4020:myLastErrorStr="运行报错:4020  禁止调用智EA函数";break;
         case 4021:myLastErrorStr="运行报错:4021  函数中临时字符串返回导致内存不够";break;
         case 4022:myLastErrorStr="运行报错:4022  系统繁忙";break;
         case 4023:myLastErrorStr="运行报错:4023  DLL函数调用错误";break;
         case 4024:myLastErrorStr="运行报错:4024  内部错误";break;
         case 4025:myLastErrorStr="运行报错:4025  内存不够";break;
         case 4026:myLastErrorStr="运行报错:4026  指针错误";break;
         case 4027:myLastErrorStr="运行报错:4027  过多的格式定义";break;
         case 4028:myLastErrorStr="运行报错:4028  参数计数器越界";break;
         case 4029:myLastErrorStr="运行报错:4029  数组错误";break;
         case 4030:myLastErrorStr="运行报错:4030  图表没有响应";break;
         case 4050:myLastErrorStr="运行报错:4050  参数无效";break;
         case 4051:myLastErrorStr="运行报错:4051  参数值无效";break;
         case 4052:myLastErrorStr="运行报错:4052  字符串函数内部错误";break;
         case 4053:myLastErrorStr="运行报错:4053  数组错误";break;
         case 4054:myLastErrorStr="运行报错:4054  数组使用不正确";break;
         case 4055:myLastErrorStr="运行报错:4055  自定义指标错误";break;
         case 4056:myLastErrorStr="运行报错:4056  数组不兼容";break;
         case 4057:myLastErrorStr="运行报错:4057  全局变量处理错误";break;
         case 4058:myLastErrorStr="运行报错:4058  没有发现全局变量";break;
         case 4059:myLastErrorStr="运行报错:4059  测试模式中函数被禁用";break;
         case 4060:myLastErrorStr="运行报错:4060  函数未确认";break;
         case 4061:myLastErrorStr="运行报错:4061  发送邮件错误";break;
         case 4062:myLastErrorStr="运行报错:4062  String参数错误";break;
         case 4063:myLastErrorStr="运行报错:4063  Integer参数错误";break;
         case 4064:myLastErrorStr="运行报错:4064  Double参数错误";break;
         case 4065:myLastErrorStr="运行报错:4065  数组参数错误";break;
         case 4066:myLastErrorStr="运行报错:4066  刷新历史数据错误";break;
         case 4067:myLastErrorStr="运行报错:4067  交易内部错误";break;
         case 4068:myLastErrorStr="运行报错:4068  没有发现资源文件";break;
         case 4069:myLastErrorStr="运行报错:4069  不支持资源文件";break;
         case 4070:myLastErrorStr="运行报错:4070  重复的资源文件";break;
         case 4071:myLastErrorStr="运行报错:4071  自定义指标没有初始化";break;
         case 4099:myLastErrorStr="运行报错:4099  文件末尾";break;
         case 4100:myLastErrorStr="运行报错:4100  文件错误";break;
         case 4101:myLastErrorStr="运行报错:4101  文件名称错误";break;
         case 4102:myLastErrorStr="运行报错:4102  打开文件过多";break;
         case 4103:myLastErrorStr="运行报错:4103  不能打开文件";break;
         case 4104:myLastErrorStr="运行报错:4104  不兼容的文件";break;
         case 4105:myLastErrorStr="运行报错:4105  没有选择定单";break;
         case 4106:myLastErrorStr="运行报错:4106  未知的商品名称";break;
         case 4107:myLastErrorStr="运行报错:4107  价格无效";break;
         case 4108:myLastErrorStr="运行报错:4108  报价无效";break;
         case 4109:myLastErrorStr="运行报错:4109  禁止交易/请打开自动交易开关";break;
         case 4110:myLastErrorStr="运行报错:4110  禁止EA买入交易";break;
         case 4111:myLastErrorStr="运行报错:4111  禁止EA卖出交易";break;
         case 4112:myLastErrorStr="运行报错:4112  服务器禁止EA交易";break;
         case 4200:myLastErrorStr="运行报错:4200  对象已经存在";break;
         case 4201:myLastErrorStr="运行报错:4201  未知的对象属性";break;
         case 4202:myLastErrorStr="运行报错:4202  对象不存在";break;
         case 4203:myLastErrorStr="运行报错:4203  未知的对象类型";break;
         case 4204:myLastErrorStr="运行报错:4204  对象没有命名";break;
         case 4205:myLastErrorStr="运行报错:4205  对象坐标错误";break;
         case 4206:myLastErrorStr="运行报错:4206  没有指定副图窗口";break;
         case 4207:myLastErrorStr="运行报错:4207  图形对象错误";break;
         case 4210:myLastErrorStr="运行报错:4210  未知的图表属性";break;
         case 4211:myLastErrorStr="运行报错:4211  没有发现主图";break;
         case 4212:myLastErrorStr="运行报错:4212  没有发现副图";break;
         case 4213:myLastErrorStr="运行报错:4210  图表中没有发现指标";break;
         case 4220:myLastErrorStr="运行报错:4220  商品选择错误";break;
         case 4250:myLastErrorStr="运行报错:4250  消息传递错误";break;
         case 4251:myLastErrorStr="运行报错:4251  消息参数错误";break;
         case 4252:myLastErrorStr="运行报错:4252  消息被禁用";break;
         case 4253:myLastErrorStr="运行报错:4253  消息发送过于频繁";break;
         case 5001:myLastErrorStr="运行报错:5001  文件打开过多";break;
         case 5002:myLastErrorStr="运行报错:5002  错误的文件名";break;
         case 5003:myLastErrorStr="运行报错:5003  文件名过长";break;
         case 5004:myLastErrorStr="运行报错:5004  无法打开文件";break;
         case 5005:myLastErrorStr="运行报错:5005  文本文件缓冲区分配错误";break;
         case 5006:myLastErrorStr="运行报错:5006  文无法删除文件";break;
         case 5007:myLastErrorStr="运行报错:5007  文件句柄无效";break;
         case 5008:myLastErrorStr="运行报错:5008  文件句柄错误";break;
         case 5009:myLastErrorStr="运行报错:5009  文件必须设置为FILE_WRITE";break;
         case 5010:myLastErrorStr="运行报错:5010  文件必须设置为FILE_READ";break;
         case 5011:myLastErrorStr="运行报错:5011  文件必须设置为FILE_BIN";break;
         case 5012:myLastErrorStr="运行报错:5012  文件必须设置为FILE_TXT";break;
         case 5013:myLastErrorStr="运行报错:5013  文件必须设置为FILE_TXT或FILE_CSV";break;
         case 5014:myLastErrorStr="运行报错:5014  文件必须设置为FILE_CSV";break;
         case 5015:myLastErrorStr="运行报错:5015  读文件错误";break;
         case 5016:myLastErrorStr="运行报错:5016  写文件错误";break;
         case 5017:myLastErrorStr="运行报错:5017  二进制文件必须指定字符串大小";break;
         case 5018:myLastErrorStr="运行报错:5018  文件不兼容";break;
         case 5019:myLastErrorStr="运行报错:5019  目录名非文件名";break;
         case 5020:myLastErrorStr="运行报错:5020  文件不存在";break;
         case 5021:myLastErrorStr="运行报错:5021  文件不能被重复写入";break;
         case 5022:myLastErrorStr="运行报错:5022  错误的目录名";break;
         case 5023:myLastErrorStr="运行报错:5023  目录名不存在";break;
         case 5024:myLastErrorStr="运行报错:5024  指定文件而不是目录";break;
         case 5025:myLastErrorStr="运行报错:5025  不能删除目录";break;
         case 5026:myLastErrorStr="运行报错:5026  不能清空目录";break;
         case 5027:myLastErrorStr="运行报错:5027  改变数组大小错误";break;
         case 5028:myLastErrorStr="运行报错:5028  改变字符串大小错误";break;
         case 5029:myLastErrorStr="运行报错:5029  结构体包含字符串或者动态数组";break;
        }
     }
   return(myLastErrorStr);
  }