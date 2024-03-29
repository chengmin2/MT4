//+------------------------------------------------------------------+
//|                                                       timeJC.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
    Alert("本地服务器时间："+TimeLocal());
    Alert("盘面时间："+TimeGMT());
    Alert("本地服务器时间星期："+TimeDayOfWeek(TimeLocal()));
    int week = TimeDayOfWeek(TimeLocal());//本地服务器当天星期
    int h = TimeHour(TimeLocal());//本地服务器时间 h
    if(week==6){//周六
       if(h>=7){//凌晨7点后
          return;
       }
    }else if(week==7){//星期天
       return;
    }else if(week==1){//星期一
       if(h<5){//凌晨5点之前
        return;
       }
    }
   
  }
//+------------------------------------------------------------------+
