#property copyright ""
#property link      ""
#property version   "1.00"
#property strict
string 使用期限=""; //不填写则不限制，格式：2018.04.08 00:00
string 账号限制="";  //不填写则不限制，填写授权数字账号，|间隔，如：8888|9999|666

enum MYPERIOD{当前=PERIOD_CURRENT,M1=PERIOD_M1,M5=PERIOD_M5,M15=PERIOD_M15,M30=PERIOD_M30,H1=PERIOD_H1,H4=PERIOD_H4,D1=PERIOD_D1,W1=PERIOD_W1,MN1=PERIOD_MN1};
input MYPERIOD 时间周期=当前;

enum MY_OP2{BUY=OP_BUY,SELL=OP_SELL}; 

input bool __清仓时间段1_启用=0;
input string __清仓时间段1_开始="0";
input string __清仓时间段1_结束="0";
input bool __清仓时间段2_启用=0;
input string __清仓时间段2_开始="0";
input string __清仓时间段2_结束="0";
input int __双挂单多少分钟不进场撤销=600;
input int __最后进场单进场几分钟后保本清仓=600;
input int __进场几单后进行风险控制=5;
input int __风险控制_盈利大等于金额N清仓=0;
input int __自爆亏损金额=6000;
input bool __是否只挂一轮=0;
input bool __不挂单时间段1_启用=1;
input string __不挂单时间段1_开始="00:00";
input string __不挂单时间段1_结束="08:00";
input bool __不挂单时间段2_启用=0;
input string __不挂单时间段2_开始="0";
input string __不挂单时间段2_结束="0";
input int __首单挂单偏离点数=100;
input double __手数=0.1;
input int __止盈点数=500;
input double __倍数=2;
input int __挂单偏离点数=200;

input int 最大允许滑点=900;

#define _tn_int int
#define _m_int int
#define _p_int int

input _m_int _订单识别码=0;
_m_int _内码=0;
input string 订单注释="";
_m_int 子识别码=0;

_m_int 订单识别码=0;
_m_int 备份_分组码=0;
_m_int 备份_指定码=0;
int 强制判断识别码=0;

int 分组循环中=0;

int 指令执行了操盘=0;

_m_int 订单_R_识别码=0;

_m_int 备份_R_分组码=0;
_m_int 备份_R_指定码=0;

_tn_int _mPubTsIns[1000]={};
int _mPubTsInc=0;
_tn_int _mPubTsExs[1000]={};
int _mPubTsExc=0;
_tn_int _mPubTs2Ins[1000]={};

_tn_int _mPubTs2Exs[1000]={};

_tn_int _mPubTn0=0;

#define MYARC 20
#define MYPC 300
_p_int _mPubi[MYPC];
double _mPubv[MYPC];
datetime _mPubTime[MYPC];
double _mPubFs[MYARC][MYPC]={};
_p_int _mPubIs[MYARC][MYPC]={};
int _mPubIsc[MYARC]={};
int _mPubFsc[MYARC]={};

#define MYARR_DC 1
#define MYARR_IC 1

int mArrDc[MYARR_DC];
_p_int mArrIs[MYARR_IC][300];
int mArrIc[MYARR_IC];

int §=0;

_m_int gGa=0;
_m_int gGb=0;
_m_int gGa_bak=0;
_m_int gGb_bak=0;

string sym="";

int period=0;

string mPreCap="";
string mPreCapP=""; //此类变量会在修改参数后也删除重置
string mPreCapNoDel="";//此类变量如果是挂ea，则永不清除；若是回测，则清除
string _mInitCap_LoadTime="";
string _mCap_TimePos1=""; //时间标注点
int OnInit() {
   string hd=MQLInfoString(MQL_PROGRAM_NAME);
   mPreCap=hd+"_"+string(_订单识别码)+"_"+Symbol()+"_"; if (IsTesting()) mPreCap+="test_";
   if (StringLen(mPreCap)>26) mPreCap=StringSubstr(mPreCap,StringLen(mPreCap)-26);

   mPreCapNoDel=hd+"_"+string(_订单识别码)+"*_"+Symbol()+"_"; if (IsTesting()) mPreCapNoDel+="test_";
   if (StringLen(mPreCapNoDel)>26) mPreCapNoDel=StringSubstr(mPreCapNoDel,StringLen(mPreCapNoDel)-26);
   
   if (IsTesting()) {
      myObjectDeleteByPreCap(mPreCap);
      myDeleteGlobalVariableByPre(mPreCap);
      myObjectDeleteByPreCap(mPreCapNoDel);
      myDeleteGlobalVariableByPre(mPreCapNoDel);
   }   
   mPreCapP=mPreCap+"#_";
      
   _mInitCap_LoadTime=mPreCap+"_pub_loadtime";
   if (myGlobalVDateTimeCheck(_mInitCap_LoadTime)==false) myGlobalVDateTimeSet(_mInitCap_LoadTime,TimeCurrent());
   _mCap_TimePos1=mPreCap+"_pub_tmpos1";
   if (myGlobalVDateTimeCheck(_mCap_TimePos1)==false) myGlobalVDateTimeSet(_mCap_TimePos1,TimeCurrent());

   //显性复位   
   for (int i=0;i<MYPC;++i) {
      _mPubi[i]=0;
      _mPubv[i]=0;
      _mPubTime[i]=0;
   }
   for (int i=0;i<MYARC;++i) {
      for (int j=0;j<MYPC;++j) {
         _mPubFs[i][j]=0;
         _mPubIs[i][j]=0;
      }
      _mPubIsc[i]=0;
      _mPubFsc[i]=0;
   }
   
   ArrayInitialize(mArrDc,-1);
   ArrayInitialize(mArrIc,-1);
   
   _内码=_订单识别码; if (_内码==0) _内码=444;
   订单识别码=_内码;
   订单_R_识别码=_内码;
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {

   //if (IsTesting()==false) myObjectDeleteByPreCap(mPreCap);  //切换周期不能删除，否则按钮状态会改变
   if (reason==REASON_REMOVE || reason==REASON_CHARTCLOSE) {
      if (IsTesting()==false) {
         myObjectDeleteByPreCap(mPreCap);
         bool ok=true;

         if (ok) myDeleteGlobalVariableByPre(mPreCap);
      }
   }
   else if (reason==REASON_PARAMETERS) {
      myObjectDeleteByPreCap(mPreCapP);
      myDeleteGlobalVariableByPre(mPreCapP);
   }
}

void OnTick() {
   if (myTimeLimit(使用期限)==false) return;
   if (myAccountNumCheck()==false) return;
   if (_订单识别码==444 || _订单识别码==-444) { Alert("~~~~~~自定识别码不能设置为444和-444这两个数字"); ExpertRemove(); return; } 
   int _tmp_w_break=0;

   int _or=0;
   §=0; gGa=0; _mPubTsInc=_mPubTsExc=-1;
   period=时间周期; if (period==0) period=Period();
   sym=Symbol();

   int _ok0=-1;
   if (_ok0==-1) {
      int _ok1=-1;
      if (_ok1==-1) {
         int _ok2=myFun200_1();
         //r/ _ok1=_ok2;
         if (_ok2==1) { if (myFun5_1()==-2) _ok1=1; }
      }
      if (_ok1==-1) {
         int _ok3=myFun200_2();
         _ok1=_ok3;
         if (_ok3==1) { if (myFun5_2()==-2) _ok1=1; }
      }
      //r/ _ok0=_ok1;
      if (_ok1==1) {
         myFun44_1();
         if (myFun4_1()==-1) { return; }
      }
   }
   if (_ok0==-1) {
      int _ok4=-1;
      if (_ok4==-1) {
         int _ok5=myFun17_1();
         //r/ _ok4=_ok5;
         if (_ok5==0) { if (myFun6_1()==-3) _ok4=0; }
      }
      if (_ok4==-1) {
         int _ok6=myFun17_2();
         //r/ _ok4=_ok6;
         if (_ok6==0) { if (myFun6_2()==-3) _ok4=0; }
      }
      if (_ok4==-1) {
         int _ok7=myFun116_1();
         _ok4=_ok7;
         if (_ok7==0) { if (myFun6_3()==-3) _ok4=0; }
      }
      //r/ _ok0=_ok4;
      if (_ok4==1) { myFun44_2(); }
   }
   if (_ok0==-1) {
      int _ok8=-1;
      if (_ok8==-1) {
         int _ok9=myFun17_3();
         //r/ _ok8=_ok9;
         if (_ok9==0) { if (myFun6_4()==-3) _ok8=0; }
      }
      if (_ok8==-1) {
         int _ok10=myFun17_4();
         //r/ _ok8=_ok10;
         if (_ok10==0) { if (myFun6_5()==-3) _ok8=0; }
      }
      if (_ok8==-1) {
         int _ok11=myFun116_2();
         _ok8=_ok11;
         if (_ok11==0) { if (myFun6_6()==-3) _ok8=0; }
      }
      //r/ _ok0=_ok8;
      if (_ok8==1) {
         myFun44_3();
         myFun105_1();
      }
   }
   if (_ok0==-1) {
      int _ok12=myFun142_1();
      //r/ _ok0=_ok12;
      if (_ok12==1) { myFun32_1(); }
   }
   if (_ok0==-1) {
      int _ok13=-1;
      if (_ok13==-1) {
         int _ok14=myFun17_5();
         //r/ _ok13=_ok14;
         if (_ok14==0) { if (myFun6_7()==-3) _ok13=0; }
      }
      if (_ok13==-1) {
         int _ok15=myFun17_6();
         //r/ _ok13=_ok15;
         if (_ok15==0) { if (myFun6_8()==-3) _ok13=0; }
      }
      if (_ok13==-1) {
         int _ok16=myFun144_1();
         _ok13=_ok16;
         if (_ok16==0) { if (myFun6_9()==-3) _ok13=0; }
      }
      //r/ _ok0=_ok13;
      if (_ok13==1) {
         myFun44_4();
         myFun105_2();
      }
   }
   if (_ok0==-1) {
      int _ok17=-1;
      if (_ok17==-1) {
         int _ok18=myFun17_7();
         //r/ _ok17=_ok18;
         if (_ok18==0) { if (myFun6_10()==-3) _ok17=0; }
      }
      if (_ok17==-1) {
         int _ok19=myFun17_8();
         _ok17=_ok19;
         if (_ok19==0) { if (myFun6_11()==-3) _ok17=0; }
      }
      //r/ _ok0=_ok17;
      if (_ok17==1) {
         myFun44_5();
         myFun105_3();
      }
   }
   if (_ok0==-1) {
      int _ok20=-1;
      if (_ok20==-1) {
         int _ok21=myFun17_9();
         //r/ _ok20=_ok21;
         if (_ok21==0) { if (myFun6_12()==-3) _ok20=0; }
      }
      if (_ok20==-1) {
         int _ok22=myFun116_3();
         _ok20=_ok22;
         if (_ok22==0) { if (myFun6_13()==-3) _ok20=0; }
      }
      //r/ _ok0=_ok20;
      if (_ok20==1) {
         myFun44_6();
         myFun105_4();
      }
   }
   if (_ok0==-1) {
      int _ok23=-1;
      if (_ok23==-1) {
         int _ok24=myFun17_10();
         //r/ _ok23=_ok24;
         if (_ok24==0) { if (myFun6_14()==-3) _ok23=0; }
      }
      if (_ok23==-1) {
         int _ok25=myFun17_11();
         _ok23=_ok25;
         if (_ok25==0) { if (myFun6_15()==-3) _ok23=0; }
      }
      //r/ _ok0=_ok23;
      if (_ok23==1) { myFun44_7(); }
   }
   if (_ok0==-1) {
      int _ok26=-1;
      if (_ok26==-1) {
         int _ok27=myFun81_1();
         //r/ _ok26=_ok27;
         if (_ok27==0) { if (myFun6_16()==-3) _ok26=0; }
      }
      if (_ok26==-1) {
         int _ok28=myFun17_12();
         //r/ _ok26=_ok28;
         if (_ok28==0) { if (myFun6_17()==-3) _ok26=0; }
      }
      if (_ok26==-1) {
         int _ok29=myFun17_13();
         _ok26=_ok29;
         if (_ok29==0) { if (myFun6_18()==-3) _ok26=0; }
      }
      //r/ _ok0=_ok26;
      if (_ok26==1) {
         myFun105_5();
         myFun86_1();
         if (myFun4_2()==-1) { return; }
      }
   }
   if (_ok0==-1) {
      int _ok30=-1;
      if (_ok30==-1) {
         int _ok31=-1;
         if (_ok31==-1) {
            int _ok32=myFun200_3();
            //r/ _ok31=_ok32;
            if (_ok32==1) { if (myFun5_3()==-2) _ok31=1; }
         }
         if (_ok31==-1) {
            int _ok33=myFun200_4();
            _ok31=_ok33;
            if (_ok33==1) { if (myFun5_4()==-2) _ok31=1; }
         }
         //r/ _ok30=_ok31;
         if (_ok31==1) { if (myFun6_19()==-3) _ok30=0; }
      }
      if (_ok30==-1) {
         int _ok34=myFun17_14();
         _ok30=_ok34;
         if (_ok34==0) { if (myFun6_20()==-3) _ok30=0; }
      }
      //r/ _ok0=_ok30;
      if (_ok30==1) {
         myFun96_1();
         myFun96_2();
         myFun32_2();
      }
   }
   if (_ok0==-1) {
      int _ok35=myFun17_15();
      //r/ _ok0=_ok35;
      if (_ok35==1) { myFun44_8(); }
   }
   if (_ok0==-1) {
      int _ok36=-1;
      if (_ok36==-1) {
         int _ok37=myFun17_16();
         //r/ _ok36=_ok37;
         if (_ok37==0) { if (myFun6_21()==-3) _ok36=0; }
      }
      if (_ok36==-1) {
         int _ok38=myFun17_17();
         _ok36=_ok38;
         if (_ok38==0) { if (myFun6_22()==-3) _ok36=0; }
      }
      //r/ _ok0=_ok36;
      if (_ok36==1) {
         myFun32_3();
         myFun96_3();
      }
   }
   if (_ok0==-1) {
      int _ok39=-1;
      if (_ok39==-1) {
         int _ok40=myFun17_18();
         //r/ _ok39=_ok40;
         if (_ok40==0) { if (myFun6_23()==-3) _ok39=0; }
      }
      if (_ok39==-1) {
         int _ok41=myFun17_19();
         _ok39=_ok41;
         if (_ok41==0) { if (myFun6_24()==-3) _ok39=0; }
      }
      //r/ _ok0=_ok39;
      if (_ok39==1) {
         myFun32_4();
         myFun96_4();
      }
   }
   if (_ok0==-1) {
      int _ok42=myFun17_20();
      //r/ _ok0=_ok42;
      if (_ok42==1) { myFun73_1(); }
   }
   if (_ok0==-1) {
      int _ok43=myFun17_21();
      _ok0=_ok43;
      if (_ok43==1) { myFun73_2(); }
   }

}

int mMaxX=0;
int mMaxY=0;

datetime myTimeVar(int tid) {
   datetime tm=0;
   if (tid<100) tm=_mPubTime[tid];
   else if (tid==101) tm=myGlobalVDateTimeGet(_mInitCap_LoadTime); //ea加载时间
   else if (tid==102) tm=StrToTime(TimeToStr(TimeCurrent(),TIME_DATE)+" 00:00");
   else if (tid==103) tm=0;
   else if (tid==104) tm=9999999999;
   else if (tid==105) {
      string cap=mPreCap+"f170903_t";
      if (GlobalVariableCheck(cap)) tm=(datetime)(GlobalVariableGet(cap)*1000.0);   
      else tm=myGlobalVDateTimeGet(_mInitCap_LoadTime); //ea加载时间
   }
   else if (tid==106) tm=iTime(sym,period,0);
   else if (tid==107) tm=iTime(sym,period,1);
   else if (tid==108) tm=myGlobalVDateTimeGet(_mCap_TimePos1);
   else if (tid>=201 && tid<=210) tm=iTime(sym,period,int(_mPubIs[0][tid-201]));
   else if (tid>=211 && tid<=220) tm=iTime(sym,period,int(_mPubIs[1][tid-211]));
   return tm;
}

datetime myGlobalVDateTimeGet(string vcap) {
   string hcap=vcap+"__h";
   string lcap=vcap+"__l";
   double h=GlobalVariableGet(hcap);
   double l=GlobalVariableGet(lcap);
   double r=h*1000000+l;
   return (datetime)r;
}

void myGlobalVDateTimeSet(string vcap,datetime t) {
   string hcap=vcap+"__h";
   string lcap=vcap+"__l";
   double f=(double)t;
   double h=int(f/1000000);
   double l=int(f)%1000000;
   GlobalVariableSet(hcap,h);
   GlobalVariableSet(lcap,l);
}

bool myGlobalVDateTimeCheck(string vcap) {
   return GlobalVariableCheck(vcap+"__h");
}

bool myIsOpenByThisEA(_m_int om) {
  if (订单识别码==0 && 强制判断识别码==0)  return true;
  if (_订单识别码==0 && 强制判断识别码==0)  return true; //用户接口参数直接设置为0表示忽略识别码（判断的是“_订单识别码”，而非“订单识别码”，因此不影响区分手工单）
  if (分组循环中==1) return om==订单识别码;

   return om==订单识别码;
}

bool myIsOpenByThisEA2(_m_int om,int incSub) {
  if (订单识别码==0 && 强制判断识别码==0)  return true; 
  if (_订单识别码==0 && 强制判断识别码==0)  return true; //用户接口参数直接设置为0表示忽略识别码（判断的是“_订单识别码”，而非“订单识别码”，因此不影响区分手工单）
  if (分组循环中==1) return om==订单识别码;

   if (订单识别码==0) return om==订单识别码 || (incSub && int(om/100000)==444); //避免将其它ea的小于100000的识别码误认为是手工单
   return om==订单识别码 || (incSub && int(om/100000)==订单识别码);
}

void myCreateLabel(string str="mylabel",string ID="def_la1",long chartid=0,int xdis=20,int ydis=20,int fontsize=12,color clr=clrRed,int corner=CORNER_LEFT_UPPER) {
    ObjectCreate(chartid,ID,OBJ_LABEL,0,0,0);
    ObjectSetInteger(chartid,ID,OBJPROP_XDISTANCE,xdis);
    ObjectSetInteger(chartid,ID,OBJPROP_YDISTANCE,ydis);
    ObjectSetString(chartid,ID,OBJPROP_FONT,"Trebuchet MS");
    ObjectSetInteger(chartid,ID,OBJPROP_FONTSIZE,fontsize);
    ObjectSetInteger(chartid,ID,OBJPROP_CORNER,corner);
    ObjectSetInteger(chartid,ID,OBJPROP_SELECTABLE,true);
    ObjectSetString(chartid,ID,OBJPROP_TOOLTIP,"\n");
    ObjectSetString(chartid,ID,OBJPROP_TEXT,str);
   ObjectSetInteger(chartid,ID,OBJPROP_COLOR,clr);
}

double myLotsValid(string sym0,double lots,bool returnMin=false) {
   double step=MarketInfo(sym0,MODE_LOTSTEP);
   if (step<0.000001) { Alert("品种【",sym0,"】数据读取失败，请检查此品种是否存在。若有后缀，请包含后缀。");  return lots; }
   int v=(int)MathRound(lots/step); lots=v*step;
   double min=MarketInfo(sym0,MODE_MINLOT);
   double max=MarketInfo(sym0,MODE_MAXLOT);
   if (lots<min) {
      if (returnMin) return min;
      Alert("手数太小，不符合平台要求"); lots=-1;
   }
   if (lots>max) lots=max;
   return lots;
}

string 时间限制_时间前缀="使用期限：";
string 时间限制_时间后缀="";
string 时间过期_时间前缀="~~~~~~~已过使用期限：";
string 时间过期_时间后缀="";
bool myTimeLimit(string timestr) {
   if (timestr=="") return true;
   datetime t=StringToTime(timestr);
   if (TimeCurrent()<t) {
      myCreateLabel(时间限制_时间前缀+timestr+时间限制_时间后缀,mPreCap+"myTimeLimit",0,20,20,10,255,CORNER_LEFT_LOWER);
      return true;
   }
   else {
      myCreateLabel(时间过期_时间前缀+timestr+时间过期_时间后缀,mPreCap+"myTimeLimit",0,20,20,10,255,CORNER_LEFT_LOWER);
      return false;
   }
}

bool myAccountNumCheck() {
   if (账号限制=="") return true;
   
   ushort u_sep=StringGetCharacter("|",0);
   string ss[1000]; int c=StringSplit(账号限制,u_sep,ss);
   if (c>=1000) Alert("授权列表数量太大");
   
   string s=string(AccountNumber());
   for (int i=0;i<c;++i) if (s==ss[i]) return true;
     
   myCreateLabel("非授权账户账号:"+s,mPreCap+"onlyuser2"); 
   return false; 
}

void myDeleteGlobalVariableByPre(string pre) {
   int len=StringLen(pre);
   for (int i=GlobalVariablesTotal()-1;i>=0;--i) {
      string cap=GlobalVariableName(i);
      if (StringSubstr(cap,0,len)==pre)
   GlobalVariableDel(cap);
   }
}

void myObjectDeleteByPreCap(string PreCap) {
//删除指定名称前缀的对象
   int len=StringLen(PreCap);
   for (int i=ObjectsTotal()-1;i>=0;--i) {
      string cap=ObjectName(i);
      if (StringSubstr(cap,0,len)==PreCap)
         ObjectDelete(cap);
   }
}

string myPeriodStr(int p0) {
   int pid=0; if (p0==0) p0=Period();
   string pstr;
   switch (p0) {
      case 1: pid=0; pstr="M1"; break;
      case 5: pid=1; pstr="M5"; break;
      case 15: pid=2; pstr="M15"; break;
      case 30: pid=3; pstr="M30"; break;
      case 60: pid=4; pstr="H1"; break;
      case 240: pid=5; pstr="H4"; break;
      case 1440: pid=6; pstr="D1"; break;
      case 10080: pid=7; pstr="W1"; break;
      case 43200: pid=8; pstr="MN"; break;
      default: pstr=string(p0);
   }
   return pstr;
}

string myStrParse(string str) { 
   if (StringFind(str,"%")<0) return str;
   string pstr=myPeriodStr(period);
   StringReplace(str,"%商品%",sym);
   StringReplace(str,"%周期%",pstr);
   StringReplace(str,"%K线起始时间%",TimeToStr(iTime(sym,period,0)));

   {  string jg="%T";
      string ss[]; ArrayResize(ss,100); int sc=0;
      while (true) {
         int ps=StringFind(str,jg); if (ps<0) break;
         if (sc==0 && ps==0) ss[sc++]=""; if (ps>0)
         ss[sc++]=StringSubstr(str,0,ps); str=StringSubstr(str,ps+2);
      }
      if (sc>0) ss[sc++]=str;
      if (sc>1) {
         str=ss[0];
         for (int i=1;i<sc;++i) {
            string s=ss[i];
            int ps=StringFind(s,"%"); if (ps<=0) { str+=jg+ss[i]; continue; }
            int n=(int)StringToInteger(s);
            if (n<=0 || n>=300) { str+=jg+ss[i]; continue; }
            s=StringSubstr(s,ps+1);
            str+=TimeToStr(_mPubTime[n-1])+s;
         }
      }
   }

   {  string jg="%Fs";
      string ss[]; ArrayResize(ss,100); int sc=0;
      while (true) {
         int ps=StringFind(str,jg); if (ps<0) break;
         if (sc==0 && ps==0) ss[sc++]=""; if (ps>0)
         ss[sc++]=StringSubstr(str,0,ps); str=StringSubstr(str,ps+3);
      }
      if (sc>0) ss[sc++]=str;
      if (sc>1) {
         str=ss[0];
         for (int i=1;i<sc;++i) {
            string s=ss[i];
            int ps=StringFind(s,"%"); if (ps<=0) { str+=jg+ss[i]; continue; }
            int n=(int)StringToInteger(s);
            if (n<=0 || n>=20) { str+=jg+ss[i]; continue; }
            s=StringSubstr(s,ps+1);
            int len=-1;
            if (s!="" && s[0]>='0' && s[0]<='9') {
               len=s[0]-'0'; s=StringSubstr(s,1);
            }
            string vstr=""; for (int j=0;j<_mPubIsc[n-1];++j) {
               if (len==-1) vstr+=string(_mPubFs[n-1][j])+" ";
               else vstr+=DoubleToStr(_mPubFs[n-1][j],len)+" ";
            }
            s=StringSubstr(s,ps+1);
            str+=vstr+s;
         }
      }
   }

   {  string jg="%F";
      string ss[]; ArrayResize(ss,100); int sc=0;
      while (true) {
         int ps=StringFind(str,jg); if (ps<0) break;
         if (sc==0 && ps==0) ss[sc++]=""; if (ps>0)
         ss[sc++]=StringSubstr(str,0,ps); str=StringSubstr(str,ps+2);
      }
      if (sc>0) ss[sc++]=str;
      if (sc>1) {
         str=ss[0];
         for (int i=1;i<sc;++i) {
            string s=ss[i];
            int ps=StringFind(s,"%"); if (ps<=0) { str+=jg+ss[i]; continue; }
            int n=(int)StringToInteger(s);
            if (n<=0 || n>=300) { str+=jg+ss[i]; continue; }
            double v=_mPubv[n-1];
            s=StringSubstr(s,ps+1);
            if (s!="" && s[0]>='0' && s[0]<='9') {
               int len=s[0]-'0'; s=StringSubstr(s,1);
               str+=DoubleToString(v,len)+s;    
            }
            else str+=string(v)+s;
         }
      }
   }

   {  string jg="%Ns";
      string ss[]; ArrayResize(ss,100); int sc=0;
      while (true) {
         int ps=StringFind(str,jg); if (ps<0) break;
         if (sc==0 && ps==0) ss[sc++]=""; if (ps>0)
         ss[sc++]=StringSubstr(str,0,ps); str=StringSubstr(str,ps+3);
      }
      if (sc>0) ss[sc++]=str;
      if (sc>1) {
         str=ss[0];
         for (int i=1;i<sc;++i) {
            string s=ss[i];
            int ps=StringFind(s,"%"); if (ps<=0) { str+=jg+ss[i]; continue; }
            int n=(int)StringToInteger(s);
            if (n<=0 || n>=20) { str+=jg+ss[i]; continue; }
            string vstr=""; for (int j=0;j<_mPubIsc[n-1];++j) vstr+=string(_mPubIs[n-1][j])+" ";
            s=StringSubstr(s,ps+1);
            str+=vstr+s;
         }
      }
   }

   {  string jg="%N";
      string ss[]; ArrayResize(ss,100); int sc=0;
      while (true) {
         int ps=StringFind(str,jg); if (ps<0) break;
         if (sc==0 && ps==0) ss[sc++]=""; if (ps>0)
         ss[sc++]=StringSubstr(str,0,ps); str=StringSubstr(str,ps+2);
      }
      if (sc>0) ss[sc++]=str;
      if (sc>1) {
         str=ss[0];
         for (int i=1;i<sc;++i) {
            string s=ss[i];
            int ps=StringFind(s,"%"); if (ps<=0) { str+=jg+ss[i]; continue; }
            int n=(int)StringToInteger(s);
            if (n<=0 || n>=300) { str+=jg+ss[i]; continue; }
            long v=_mPubi[n-1];
            s=StringSubstr(s,ps+1);
            str+=string(v)+s;
         }
      }
   }
   
   {  string jg="%G";
      string ss[]; ArrayResize(ss,100); int sc=0;
      while (true) {
         int ps=StringFind(str,jg); if (ps<0) break;
         if (sc==0 && ps==0) ss[sc++]=""; if (ps>0)
         ss[sc++]=StringSubstr(str,0,ps); str=StringSubstr(str,ps+2);
      }
      if (sc>0) ss[sc++]=str;
      if (sc>1) {
         str=ss[0];
         for (int i=1;i<sc;++i) {
            string s=ss[i];
            int ps=StringFind(s,"%"); if (ps<=0) { str+=jg+ss[i]; continue; }
            int n=(int)StringToInteger(s);
            if (n<=0 || n>=300) { str+=jg+ss[i]; continue; }
            string cap=mPreCap+"_pubv"+string(订单识别码)+"_"+string(n-1);
            double v=0; if (GlobalVariableCheck(cap)) v=GlobalVariableGet(cap);
            s=StringSubstr(s,ps+1);
            if (s!="" && s[0]>='0' && s[0]<='9') {
               int len=s[0]-'0'; s=StringSubstr(s,1);
               str+=DoubleToString(v,len)+s;    
            }
            else str+=string(v)+s;
         }
      }
   }
   
   return str;
}

bool myOrderOks(_tn_int tn) {
   if (_mPubTsExc>0) { for (int i=0;i<_mPubTsExc;++i) { if (_mPubTsExs[i]==tn) return false; }  }
   if (_mPubTsInc>=0){ 
      int i=0; for (;i<_mPubTsInc;++i) { if (_mPubTsIns[i]==tn) break; } 
      if (i>=_mPubTsInc) return false;  
   }
   return true;
}

bool myFun200_1() {
   if (__清仓时间段1_启用==false) return 0;
   datetime cur=TimeCurrent();
   datetime tm1=0,tm2=0;
   {  string tmstr=string(__清仓时间段1_开始);
      int c=StringLen(tmstr);
      if (c>=10) tm1=StrToTime(tmstr);
      else tm1=StrToTime(TimeToStr(cur,TIME_DATE)+" "+tmstr);
   }
   {  string tmstr=string(__清仓时间段1_结束);
      int c=StringLen(tmstr);
      if (c>=10) tm2=StrToTime(tmstr);
      else tm2=StrToTime(TimeToStr(cur,TIME_DATE)+" "+tmstr);
   }
   if (tm2<tm1) 
      return (cur>=tm1 && cur<=tm2+60*60*24) || (cur>=tm1-60*60*24 && cur<=tm2);
   else return cur>=tm1 && cur<=tm2;

}

_p_int myFun5_1() {
   return -2;

}

bool myFun200_2() {
   if (__清仓时间段2_启用==false) return 0;
   datetime cur=TimeCurrent();
   datetime tm1=0,tm2=0;
   {  string tmstr=string(__清仓时间段2_开始);
      int c=StringLen(tmstr);
      if (c>=10) tm1=StrToTime(tmstr);
      else tm1=StrToTime(TimeToStr(cur,TIME_DATE)+" "+tmstr);
   }
   {  string tmstr=string(__清仓时间段2_结束);
      int c=StringLen(tmstr);
      if (c>=10) tm2=StrToTime(tmstr);
      else tm2=StrToTime(TimeToStr(cur,TIME_DATE)+" "+tmstr);
   }
   if (tm2<tm1) 
      return (cur>=tm1 && cur<=tm2+60*60*24) || (cur>=tm1-60*60*24 && cur<=tm2);
   else return cur>=tm1 && cur<=tm2;

}

_p_int myFun5_2() {
   return -2;

}

_p_int myFun44_1() {
   指令执行了操盘=0;
   string sym0=string("#");
   int slip=最大允许滑点;

   int magic=1; 
   if (0==0) magic=-2;
   else magic=0;
   if (sym0=="*") sym0=""; 
   else if (sym0=="#") sym0=sym; 
   
   int ts[10]={}; ArrayInitialize(ts,0);
   int t=8;
   if (t<=5) ts[t]=1;
   else if (t==6) ts[OP_BUY]=ts[OP_SELL]=1;
   else if (t==7) ts[OP_BUYLIMIT]=ts[OP_SELLLIMIT]=ts[OP_BUYSTOP]=ts[OP_SELLSTOP]=1;
   else ArrayInitialize(ts,1);

for (int z=0;z<5;++z) { if (z>0) { Sleep(2000); RefreshRates(); } int errc=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;
      if (sym0!="" && OrderSymbol()!=sym0) continue;
      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         if (OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slip)==false) { errc++; Print("~#",OrderTicket(),"~~~~~~~平仓错误,",GetLastError()); }
         else 指令执行了操盘=1;
      }
      else {
         if (OrderDelete(OrderTicket())==false) { errc++; Print("~~~~~~删除挂单错误",GetLastError()); }
         else 指令执行了操盘=1;
      }
   }
if (errc==0) break; }
   
   return 0;

}
_p_int myFun4_1() {
   return -1;

}

double myFun25_1() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=1;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_1() {
   double a=double(myFun25_1());
   double b=double(0);

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_1() {
   return -3;

}

double myFun25_2() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_2() {
   double a=double(myFun25_2());
   double b=double(0);

   return a>b;

}

_p_int myFun6_2() {
   return -3;

}

double myFun160_1() {
   return (double)TimeCurrent();

}

double myFun158_1() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_SELL]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime();  } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return (double)tmo;

}
bool myFun116_1() {
   double a=0,b=0;
   a=double(myFun160_1());
   b=double(myFun158_1());
   double v1=double(a-b);
   a=double(int(__双挂单多少分钟不进场撤销));
   double v2=double(a*60);

   return v1>v2;

}

_p_int myFun6_3() {
   return -3;

}

_p_int myFun44_2() {
   指令执行了操盘=0;
   string sym0=string("#");
   int slip=最大允许滑点;

   int magic=1; 
   if (0==0) magic=-2;
   else magic=0;
   if (sym0=="*") sym0=""; 
   else if (sym0=="#") sym0=sym; 
   
   int ts[10]={}; ArrayInitialize(ts,0);
   int t=8;
   if (t<=5) ts[t]=1;
   else if (t==6) ts[OP_BUY]=ts[OP_SELL]=1;
   else if (t==7) ts[OP_BUYLIMIT]=ts[OP_SELLLIMIT]=ts[OP_BUYSTOP]=ts[OP_SELLSTOP]=1;
   else ArrayInitialize(ts,1);

for (int z=0;z<5;++z) { if (z>0) { Sleep(2000); RefreshRates(); } int errc=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;
      if (sym0!="" && OrderSymbol()!=sym0) continue;
      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         if (OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slip)==false) { errc++; Print("~#",OrderTicket(),"~~~~~~~平仓错误,",GetLastError()); }
         else 指令执行了操盘=1;
      }
      else {
         if (OrderDelete(OrderTicket())==false) { errc++; Print("~~~~~~删除挂单错误",GetLastError()); }
         else 指令执行了操盘=1;
      }
   }
if (errc==0) break; }
   
   return 0;

}

double myFun25_3() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=1;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_3() {
   double a=double(myFun25_3());
   double b=double(0);

   return a>b;

}

_p_int myFun6_4() {
   return -3;

}

double myFun104_1() {
   if (OrdersTotal()<=0) return 0;
   _m_int magic=订单识别码; 
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_SELL]=0;
   if (ts[OP_BUY]+ts[OP_SELL]==0) ArrayInitialize(ts,1);
   double v=0;
   int t=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;

     if (magic!=444 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     
     double v1=OrderProfit();

     v1+=OrderSwap();

     v1+=OrderCommission();

     if (t==1 && v1<0) continue;
     else if (t==2 && v1>0) continue;
     
     v+=v1;
   }
   return v;

}

bool myFun17_4() {
   double a=double(myFun104_1());
   double b=double(0);

   return a+0.00000001>=b;

}

_p_int myFun6_5() {
   return -3;

}

double myFun160_2() {
   return (double)TimeCurrent();

}

double myFun158_2() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_SELL]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime();  } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return (double)tmo;

}
bool myFun116_2() {
   double a=0,b=0;
   a=double(myFun160_2());
   b=double(myFun158_2());
   double v1=double(a-b);
   a=double(int(__最后进场单进场几分钟后保本清仓));
   double v2=double(a*60);

   return v1>v2;

}

_p_int myFun6_6() {
   return -3;

}

_p_int myFun44_3() {
   指令执行了操盘=0;
   string sym0=string("#");
   int slip=最大允许滑点;

   int magic=1; 
   if (0==0) magic=-2;
   else magic=0;
   if (sym0=="*") sym0=""; 
   else if (sym0=="#") sym0=sym; 
   
   int ts[10]={}; ArrayInitialize(ts,0);
   int t=8;
   if (t<=5) ts[t]=1;
   else if (t==6) ts[OP_BUY]=ts[OP_SELL]=1;
   else if (t==7) ts[OP_BUYLIMIT]=ts[OP_SELLLIMIT]=ts[OP_BUYSTOP]=ts[OP_SELLSTOP]=1;
   else ArrayInitialize(ts,1);

for (int z=0;z<5;++z) { if (z>0) { Sleep(2000); RefreshRates(); } int errc=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;
      if (sym0!="" && OrderSymbol()!=sym0) continue;
      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         if (OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slip)==false) { errc++; Print("~#",OrderTicket(),"~~~~~~~平仓错误,",GetLastError()); }
         else 指令执行了操盘=1;
      }
      else {
         if (OrderDelete(OrderTicket())==false) { errc++; Print("~~~~~~删除挂单错误",GetLastError()); }
         else 指令执行了操盘=1;
      }
   }
if (errc==0) break; }
   
   return 0;

}

_p_int myFun105_1() {
   string str=myStrParse(string("~~~~~时间清仓"));
   Print(str);
   return 0;

}

double myFun25_4() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

double myFun25_5() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=1;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun142_1() {
   double a=double(myFun25_4());
   int c=0;
   double b=double(0);

   c+=a>b;

   a=myFun25_5();
   b=0;

   c+=a>b;

   if (c==2) return true;
   return false;

}
_p_int myFun32_1() {
   _m_int magic=订单识别码;

   double a=0;
   a=double(1);
   double v=double(a);
   GlobalVariableSet(mPreCap+"_pubv"+string(订单识别码)+"_"+string(1209-1200),v);

   return 0;

}

double myFun107_1() {
   double v=0;
   string cap=mPreCap+"_pubv"+string(订单识别码)+"_"+string(9);
   if (GlobalVariableCheck(cap)) v=GlobalVariableGet(cap);
   return v;

}

bool myFun17_5() {
   double a=double(myFun107_1());
   double b=double(1);

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_7() {
   return -3;

}

double myFun25_6() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=1;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_6() {
   double a=double(myFun25_6());
   double b=double(0);

   return a>b;

}

_p_int myFun6_8() {
   return -3;

}

double myFun25_7() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

double myFun25_8() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=1;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}
bool myFun144_1() {
   int _c=0;
   double a=0;
   a=double(myFun25_7());
   double v1=double(a);
   a=double(0);
   double v2=double(a);

   _c+=MathAbs(v1-v2)<0.00000001;

   a=double(myFun25_8());
   v1=a;
   a=double(0);
   v2=a;

   _c+=MathAbs(v1-v2)<0.00000001;

   if (_c>0) return true;
   return false;

}

_p_int myFun6_9() {
   return -3;

}

_p_int myFun44_4() {
   指令执行了操盘=0;
   string sym0=string("#");
   int slip=最大允许滑点;

   int magic=1; 
   if (0==0) magic=-2;
   else magic=0;
   if (sym0=="*") sym0=""; 
   else if (sym0=="#") sym0=sym; 
   
   int ts[10]={}; ArrayInitialize(ts,0);
   int t=8;
   if (t<=5) ts[t]=1;
   else if (t==6) ts[OP_BUY]=ts[OP_SELL]=1;
   else if (t==7) ts[OP_BUYLIMIT]=ts[OP_SELLLIMIT]=ts[OP_BUYSTOP]=ts[OP_SELLSTOP]=1;
   else ArrayInitialize(ts,1);

for (int z=0;z<5;++z) { if (z>0) { Sleep(2000); RefreshRates(); } int errc=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;
      if (sym0!="" && OrderSymbol()!=sym0) continue;
      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         if (OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slip)==false) { errc++; Print("~#",OrderTicket(),"~~~~~~~平仓错误,",GetLastError()); }
         else 指令执行了操盘=1;
      }
      else {
         if (OrderDelete(OrderTicket())==false) { errc++; Print("~~~~~~删除挂单错误",GetLastError()); }
         else 指令执行了操盘=1;
      }
   }
if (errc==0) break; }
   
   return 0;

}

_p_int myFun105_2() {
   string str=myStrParse(string("浮动点差平台,多单和空单未能同时出场,补充清仓"));
   Print(str);
   return 0;

}

double myFun25_9() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=1;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_7() {
   double a=double(myFun25_9());
   double b=double(int(__进场几单后进行风险控制));

   return a+0.00000001>=b;

}

_p_int myFun6_10() {
   return -3;

}

double myFun104_2() {
   if (OrdersTotal()<=0) return 0;
   _m_int magic=订单识别码; 
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_SELL]=0;
   if (ts[OP_BUY]+ts[OP_SELL]==0) ArrayInitialize(ts,1);
   double v=0;
   int t=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;

     if (magic!=444 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     
     double v1=OrderProfit();

     v1+=OrderSwap();

     v1+=OrderCommission();

     if (t==1 && v1<0) continue;
     else if (t==2 && v1>0) continue;
     
     v+=v1;
   }
   return v;

}

bool myFun17_8() {
   double a=double(myFun104_2());
   double b=double(int(__风险控制_盈利大等于金额N清仓));

   return a>b;

}

_p_int myFun6_11() {
   return -3;

}

_p_int myFun44_5() {
   指令执行了操盘=0;
   string sym0=string("#");
   int slip=最大允许滑点;

   int magic=1; 
   if (0==0) magic=-2;
   else magic=0;
   if (sym0=="*") sym0=""; 
   else if (sym0=="#") sym0=sym; 
   
   int ts[10]={}; ArrayInitialize(ts,0);
   int t=8;
   if (t<=5) ts[t]=1;
   else if (t==6) ts[OP_BUY]=ts[OP_SELL]=1;
   else if (t==7) ts[OP_BUYLIMIT]=ts[OP_SELLLIMIT]=ts[OP_BUYSTOP]=ts[OP_SELLSTOP]=1;
   else ArrayInitialize(ts,1);

for (int z=0;z<5;++z) { if (z>0) { Sleep(2000); RefreshRates(); } int errc=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;
      if (sym0!="" && OrderSymbol()!=sym0) continue;
      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         if (OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slip)==false) { errc++; Print("~#",OrderTicket(),"~~~~~~~平仓错误,",GetLastError()); }
         else 指令执行了操盘=1;
      }
      else {
         if (OrderDelete(OrderTicket())==false) { errc++; Print("~~~~~~删除挂单错误",GetLastError()); }
         else 指令执行了操盘=1;
      }
   }
if (errc==0) break; }
   
   return 0;

}

_p_int myFun105_3() {
   string str=myStrParse(string("~~~风险控制离场"));
   Print(str);
   return 0;

}

double myFun25_10() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=1;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_9() {
   double a=double(myFun25_10());
   double b=double(0);

   return a>b;

}

_p_int myFun6_12() {
   return -3;

}

double myFun104_3() {
   if (OrdersTotal()<=0) return 0;
   _m_int magic=订单识别码; 
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_SELL]=0;
   if (ts[OP_BUY]+ts[OP_SELL]==0) ArrayInitialize(ts,1);
   double v=0;
   int t=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;

     if (magic!=444 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     
     double v1=OrderProfit();

     v1+=OrderSwap();

     v1+=OrderCommission();

     if (t==1 && v1<0) continue;
     else if (t==2 && v1>0) continue;
     
     v+=v1;
   }
   return v;

}
bool myFun116_3() {
   double a=0;
   a=double(myFun104_3());
   double v1=double(a);
   a=double(int(__自爆亏损金额));
   double v2=double(-MathAbs(a));

   return v1<=v2+0.00000001;

}

_p_int myFun6_13() {
   return -3;

}

_p_int myFun44_6() {
   指令执行了操盘=0;
   string sym0=string("#");
   int slip=最大允许滑点;

   int magic=1; 
   if (0==0) magic=-2;
   else magic=0;
   if (sym0=="*") sym0=""; 
   else if (sym0=="#") sym0=sym; 
   
   int ts[10]={}; ArrayInitialize(ts,0);
   int t=8;
   if (t<=5) ts[t]=1;
   else if (t==6) ts[OP_BUY]=ts[OP_SELL]=1;
   else if (t==7) ts[OP_BUYLIMIT]=ts[OP_SELLLIMIT]=ts[OP_BUYSTOP]=ts[OP_SELLSTOP]=1;
   else ArrayInitialize(ts,1);

for (int z=0;z<5;++z) { if (z>0) { Sleep(2000); RefreshRates(); } int errc=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;
      if (sym0!="" && OrderSymbol()!=sym0) continue;
      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         if (OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slip)==false) { errc++; Print("~#",OrderTicket(),"~~~~~~~平仓错误,",GetLastError()); }
         else 指令执行了操盘=1;
      }
      else {
         if (OrderDelete(OrderTicket())==false) { errc++; Print("~~~~~~删除挂单错误",GetLastError()); }
         else 指令执行了操盘=1;
      }
   }
if (errc==0) break; }
   
   return 0;

}

_p_int myFun105_4() {
   string str=myStrParse(string("~~~自爆"));
   Print(str);
   return 0;

}

double myFun25_11() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=1;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_10() {
   double a=double(myFun25_11());
   double b=double(0);

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_14() {
   return -3;

}

double myFun25_12() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=1;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=1;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_11() {
   double a=double(myFun25_12());
   double b=double(1);

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_15() {
   return -3;

}

_p_int myFun44_7() {
   指令执行了操盘=0;
   string sym0=string("#");
   int slip=最大允许滑点;

   int magic=1; 
   if (0==0) magic=-2;
   else magic=0;
   if (sym0=="*") sym0=""; 
   else if (sym0=="#") sym0=sym; 
   
   int ts[10]={}; ArrayInitialize(ts,0);
   int t=7;
   if (t<=5) ts[t]=1;
   else if (t==6) ts[OP_BUY]=ts[OP_SELL]=1;
   else if (t==7) ts[OP_BUYLIMIT]=ts[OP_SELLLIMIT]=ts[OP_BUYSTOP]=ts[OP_SELLSTOP]=1;
   else ArrayInitialize(ts,1);

for (int z=0;z<5;++z) { if (z>0) { Sleep(2000); RefreshRates(); } int errc=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;
      if (sym0!="" && OrderSymbol()!=sym0) continue;
      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         if (OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slip)==false) { errc++; Print("~#",OrderTicket(),"~~~~~~~平仓错误,",GetLastError()); }
         else 指令执行了操盘=1;
      }
      else {
         if (OrderDelete(OrderTicket())==false) { errc++; Print("~~~~~~删除挂单错误",GetLastError()); }
         else 指令执行了操盘=1;
      }
   }
if (errc==0) break; }
   
   return 0;

}

bool myFun81_1() {
   bool a=__是否只挂一轮;
   bool b=1;
   return a==b;

}

_p_int myFun6_16() {
   return -3;

}

double myFun25_13() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_12() {
   double a=double(myFun25_13());
   double b=double(0);

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_17() {
   return -3;

}

double myFun34_1() {
   //custom_v
   int magic=1; 
   if (0==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   int excHis=0;
   int c=0;
   if (excHis==0) {
      int hc=OrdersHistoryTotal();
      for (int h=hc-1;h>=0;--h) {
         if (OrderSelect(h,SELECT_BY_POS,MODE_HISTORY)==false) continue;

         if (sym!="" && OrderSymbol()!=sym) continue;

         if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
         if (OrderCloseTime()<begtime) break;
         if (ts[OrderType()]==0) continue;
         if (OrderOpenTime()>=begtime)
            c+=1;
      }
   }
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (OrderOpenTime()>=begtime)
         c+=1;
   }
   return c;

}

bool myFun17_13() {
   double a=double(myFun34_1());
   double b=double(0);

   return a>b;

}

_p_int myFun6_18() {
   return -3;

}

_p_int myFun105_5() {
   string str=myStrParse(string("~~~~~~只挂一轮"));
   Print(str);
   return 0;

}

_p_int myFun86_1() {

   myDeleteGlobalVariableByPre(mPreCap);

   myObjectDeleteByPreCap(mPreCap);

   ExpertRemove();
   return 0;

}
_p_int myFun4_2() {
   return -1;

}

bool myFun200_3() {
   if (__不挂单时间段1_启用==false) return 0;
   datetime cur=TimeCurrent();
   datetime tm1=0,tm2=0;
   {  string tmstr=string(__不挂单时间段1_开始);
      int c=StringLen(tmstr);
      if (c>=10) tm1=StrToTime(tmstr);
      else tm1=StrToTime(TimeToStr(cur,TIME_DATE)+" "+tmstr);
   }
   {  string tmstr=string(__不挂单时间段1_结束);
      int c=StringLen(tmstr);
      if (c>=10) tm2=StrToTime(tmstr);
      else tm2=StrToTime(TimeToStr(cur,TIME_DATE)+" "+tmstr);
   }
   if (tm2<tm1) 
      return (cur>=tm1 && cur<=tm2+60*60*24) || (cur>=tm1-60*60*24 && cur<=tm2);
   else return cur>=tm1 && cur<=tm2;

}

_p_int myFun5_3() {
   return -2;

}

bool myFun200_4() {
   if (__不挂单时间段2_启用==false) return 0;
   datetime cur=TimeCurrent();
   datetime tm1=0,tm2=0;
   {  string tmstr=string(__不挂单时间段2_开始);
      int c=StringLen(tmstr);
      if (c>=10) tm1=StrToTime(tmstr);
      else tm1=StrToTime(TimeToStr(cur,TIME_DATE)+" "+tmstr);
   }
   {  string tmstr=string(__不挂单时间段2_结束);
      int c=StringLen(tmstr);
      if (c>=10) tm2=StrToTime(tmstr);
      else tm2=StrToTime(TimeToStr(cur,TIME_DATE)+" "+tmstr);
   }
   if (tm2<tm1) 
      return (cur>=tm1 && cur<=tm2+60*60*24) || (cur>=tm1-60*60*24 && cur<=tm2);
   else return cur>=tm1 && cur<=tm2;

}

_p_int myFun5_4() {
   return -2;

}

_p_int myFun6_19() {
   return -3;

}

double myFun25_14() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_14() {
   double a=double(myFun25_14());
   double b=double(0);

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_20() {
   return -3;

}

double myFun69_1() {
   return MarketInfo(sym,MODE_ASK);

}

_p_int myFun96_1() {
   _m_int magic=订单识别码;
   string comm=订单注释;
   double pnt=MarketInfo(sym,MODE_POINT);
   int type=0; 

   double op=myFun69_1(); if (op<Point) return 0;
   int t0=int(0);
   int jg=int(int(__首单挂单偏离点数));
   double lots=myLotsValid(sym,double(__手数),true);
   int slt=0; double sl=0;
   int tpt=0; double tp=int(__止盈点数);
   int err=0;

   if (t0==0) op+=jg*pnt;
   else op-=jg*pnt;
   
   int tt=type;
   if (op>Bid) {
      if (type==OP_BUY) type=OP_BUYSTOP;
      else type=OP_SELLLIMIT;
   }
   else {
      if (type==OP_BUY) type=OP_BUYLIMIT;
      else type=OP_SELLSTOP;
   }
   
   int stoplevel=(int)MarketInfo(sym,MODE_STOPLEVEL);
   if (err==0) {
      if (type==OP_BUYLIMIT || type==OP_SELLLIMIT) return 0;
      if (type==OP_BUYSTOP && op<Ask+stoplevel*pnt) return 0;
      if (type==OP_SELLSTOP && op>Bid-stoplevel*pnt) return 0;
   }
   else if (err==2) {
      if (type==OP_BUYSTOP || type==OP_SELLSTOP) return 0;
      if (type==OP_BUYLIMIT && op>Bid-stoplevel*pnt) return 0;
      if (type==OP_SELLLIMIT && op<Ask+stoplevel*pnt) return 0;
   }

   bool xj=0;
   if (err==1 || err==2) {   
      if (type==OP_BUYSTOP && op<Ask+stoplevel*pnt) xj=1;
      else if (type==OP_SELLSTOP && op>Bid-stoplevel*pnt) xj=1;
      else if (type==OP_BUYLIMIT && op>Bid-stoplevel*pnt) xj=1;
      else if (type==OP_SELLLIMIT && op<Ask+stoplevel*pnt) xj=1;
   }   

   if (xj==1) {
      if (tt==OP_BUY) op=Ask;
      else op=Bid;
   }
   
   if (tt==OP_BUY) {
      if (slt==0 && sl>0.001) sl=op-sl*pnt;
      if (tpt==0 && tp>0.001) tp=op+tp*pnt;
   }
   else {
      if (slt==0 && sl>0.001) sl=op+sl*pnt;
      if (tpt==0 && tp>0.001) tp=op-tp*pnt;
   }
   
   _tn_int tn=0;
   if (xj==1) {
      tn=OrderSend(sym,tt,lots,op,最大允许滑点,sl,tp,comm,magic);
      if (tn<=0) Print("~~~~~~~~~~建仓错误：",GetLastError());
   }
   else {
      tn=OrderSend(sym,type,lots,op,0,sl,tp,comm,magic);
      if (tn<=0) Print("~~~~~~~~~~挂单错误：",GetLastError());
   }
   return tn;

}

double myFun70_1() {
   return MarketInfo(sym,MODE_BID);

}

_p_int myFun96_2() {
   _m_int magic=订单识别码;
   string comm=订单注释;
   double pnt=MarketInfo(sym,MODE_POINT);
   int type=1; 

   double op=myFun70_1(); if (op<Point) return 0;
   int t0=int(1);
   int jg=int(int(__首单挂单偏离点数));
   double lots=myLotsValid(sym,double(__手数),true);
   int slt=0; double sl=0;
   int tpt=0; double tp=int(__止盈点数);
   int err=0;

   if (t0==0) op+=jg*pnt;
   else op-=jg*pnt;
   
   int tt=type;
   if (op>Bid) {
      if (type==OP_BUY) type=OP_BUYSTOP;
      else type=OP_SELLLIMIT;
   }
   else {
      if (type==OP_BUY) type=OP_BUYLIMIT;
      else type=OP_SELLSTOP;
   }
   
   int stoplevel=(int)MarketInfo(sym,MODE_STOPLEVEL);
   if (err==0) {
      if (type==OP_BUYLIMIT || type==OP_SELLLIMIT) return 0;
      if (type==OP_BUYSTOP && op<Ask+stoplevel*pnt) return 0;
      if (type==OP_SELLSTOP && op>Bid-stoplevel*pnt) return 0;
   }
   else if (err==2) {
      if (type==OP_BUYSTOP || type==OP_SELLSTOP) return 0;
      if (type==OP_BUYLIMIT && op>Bid-stoplevel*pnt) return 0;
      if (type==OP_SELLLIMIT && op<Ask+stoplevel*pnt) return 0;
   }

   bool xj=0;
   if (err==1 || err==2) {   
      if (type==OP_BUYSTOP && op<Ask+stoplevel*pnt) xj=1;
      else if (type==OP_SELLSTOP && op>Bid-stoplevel*pnt) xj=1;
      else if (type==OP_BUYLIMIT && op>Bid-stoplevel*pnt) xj=1;
      else if (type==OP_SELLLIMIT && op<Ask+stoplevel*pnt) xj=1;
   }   

   if (xj==1) {
      if (tt==OP_BUY) op=Ask;
      else op=Bid;
   }
   
   if (tt==OP_BUY) {
      if (slt==0 && sl>0.001) sl=op-sl*pnt;
      if (tpt==0 && tp>0.001) tp=op+tp*pnt;
   }
   else {
      if (slt==0 && sl>0.001) sl=op+sl*pnt;
      if (tpt==0 && tp>0.001) tp=op-tp*pnt;
   }
   
   _tn_int tn=0;
   if (xj==1) {
      tn=OrderSend(sym,tt,lots,op,最大允许滑点,sl,tp,comm,magic);
      if (tn<=0) Print("~~~~~~~~~~建仓错误：",GetLastError());
   }
   else {
      tn=OrderSend(sym,type,lots,op,0,sl,tp,comm,magic);
      if (tn<=0) Print("~~~~~~~~~~挂单错误：",GetLastError());
   }
   return tn;

}
_p_int myFun32_2() {
   _m_int magic=订单识别码;

   double a=0;
   a=double(0);
   double v=double(a);
   GlobalVariableSet(mPreCap+"_pubv"+string(订单识别码)+"_"+string(1209-1200),v);

   return 0;

}

double myFun162_1() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_SELL]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=0; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderLots(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}

double myFun162_2() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_SELL]=0;
   ts[OP_BUYLIMIT]=1;
   ts[OP_SELLLIMIT]=1;
   ts[OP_BUYSTOP]=1;
   ts[OP_SELLSTOP]=1;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=0; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderLots(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}

bool myFun17_15() {
   double a=double(myFun162_1());
   double b=double(myFun162_2());

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun44_8() {
   指令执行了操盘=0;
   string sym0=string("#");
   int slip=最大允许滑点;

   int magic=1; 
   if (0==0) magic=-2;
   else magic=0;
   if (sym0=="*") sym0=""; 
   else if (sym0=="#") sym0=sym; 
   
   int ts[10]={}; ArrayInitialize(ts,0);
   int t=7;
   if (t<=5) ts[t]=1;
   else if (t==6) ts[OP_BUY]=ts[OP_SELL]=1;
   else if (t==7) ts[OP_BUYLIMIT]=ts[OP_SELLLIMIT]=ts[OP_BUYSTOP]=ts[OP_SELLSTOP]=1;
   else ArrayInitialize(ts,1);

for (int z=0;z<5;++z) { if (z>0) { Sleep(2000); RefreshRates(); } int errc=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;
      if (sym0!="" && OrderSymbol()!=sym0) continue;
      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderType()==OP_BUY || OrderType()==OP_SELL) {
         if (OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),slip)==false) { errc++; Print("~#",OrderTicket(),"~~~~~~~平仓错误,",GetLastError()); }
         else 指令执行了操盘=1;
      }
      else {
         if (OrderDelete(OrderTicket())==false) { errc++; Print("~~~~~~删除挂单错误",GetLastError()); }
         else 指令执行了操盘=1;
      }
   }
if (errc==0) break; }
   
   return 0;

}

double myFun192_1() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_SELL]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=-1; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (OrderOpenTime()<begtime) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderType(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}

double myFun194_1() {
   return OP_SELL;

}

bool myFun17_16() {
   double a=double(myFun192_1());
   double b=double(myFun194_1());

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_21() {
   return -3;

}

double myFun25_15() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=1;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=1;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_17() {
   double a=double(myFun25_15());
   double b=double(0);

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_22() {
   return -3;

}

double myFun162_3() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_SELL]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=0; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderLots(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}
_p_int myFun32_3() {
   _m_int magic=订单识别码;

   double a=0,b=0;
   a=double(myFun162_3());
   b=double(double(__倍数));
   _mPubv[0]=double(a*b);

   return 0;

}

double myFun175_1() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_SELL]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);

   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=0; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderOpenPrice(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}

_p_int myFun96_3() {
   _m_int magic=订单识别码;
   string comm=订单注释;
   double pnt=MarketInfo(sym,MODE_POINT);
   int type=0; 

   double op=myFun175_1(); if (op<Point) return 0;
   int t0=int(0);
   int jg=int(int(__挂单偏离点数));
   double lots=myLotsValid(sym,_mPubv[0],true);
   int slt=0; double sl=0;
   int tpt=0; double tp=int(__止盈点数);
   int err=0;

   if (t0==0) op+=jg*pnt;
   else op-=jg*pnt;
   
   int tt=type;
   if (op>Bid) {
      if (type==OP_BUY) type=OP_BUYSTOP;
      else type=OP_SELLLIMIT;
   }
   else {
      if (type==OP_BUY) type=OP_BUYLIMIT;
      else type=OP_SELLSTOP;
   }
   
   int stoplevel=(int)MarketInfo(sym,MODE_STOPLEVEL);
   if (err==0) {
      if (type==OP_BUYLIMIT || type==OP_SELLLIMIT) return 0;
      if (type==OP_BUYSTOP && op<Ask+stoplevel*pnt) return 0;
      if (type==OP_SELLSTOP && op>Bid-stoplevel*pnt) return 0;
   }
   else if (err==2) {
      if (type==OP_BUYSTOP || type==OP_SELLSTOP) return 0;
      if (type==OP_BUYLIMIT && op>Bid-stoplevel*pnt) return 0;
      if (type==OP_SELLLIMIT && op<Ask+stoplevel*pnt) return 0;
   }

   bool xj=0;
   if (err==1 || err==2) {   
      if (type==OP_BUYSTOP && op<Ask+stoplevel*pnt) xj=1;
      else if (type==OP_SELLSTOP && op>Bid-stoplevel*pnt) xj=1;
      else if (type==OP_BUYLIMIT && op>Bid-stoplevel*pnt) xj=1;
      else if (type==OP_SELLLIMIT && op<Ask+stoplevel*pnt) xj=1;
   }   

   if (xj==1) {
      if (tt==OP_BUY) op=Ask;
      else op=Bid;
   }
   
   if (tt==OP_BUY) {
      if (slt==0 && sl>0.001) sl=op-sl*pnt;
      if (tpt==0 && tp>0.001) tp=op+tp*pnt;
   }
   else {
      if (slt==0 && sl>0.001) sl=op+sl*pnt;
      if (tpt==0 && tp>0.001) tp=op-tp*pnt;
   }
   
   _tn_int tn=0;
   if (xj==1) {
      tn=OrderSend(sym,tt,lots,op,最大允许滑点,sl,tp,comm,magic);
      if (tn<=0) Print("~~~~~~~~~~建仓错误：",GetLastError());
   }
   else {
      tn=OrderSend(sym,type,lots,op,0,sl,tp,comm,magic);
      if (tn<=0) Print("~~~~~~~~~~挂单错误：",GetLastError());
   }
   return tn;

}

double myFun192_2() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_SELL]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=-1; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (OrderOpenTime()<begtime) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderType(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}

double myFun193_1() {
   return OP_BUY;

}

bool myFun17_18() {
   double a=double(myFun192_2());
   double b=double(myFun193_1());

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_23() {
   return -3;

}

double myFun25_16() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=1;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=1;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_19() {
   double a=double(myFun25_16());
   double b=double(0);

   return MathAbs(a-b)<0.00000001;

}

_p_int myFun6_24() {
   return -3;

}

double myFun162_4() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_SELL]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=0; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderLots(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}
_p_int myFun32_4() {
   _m_int magic=订单识别码;

   double a=0,b=0;
   a=double(myFun162_4());
   b=double(double(__倍数));
   _mPubv[0]=double(a*b);

   return 0;

}

double myFun175_2() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_SELL]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);

   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=0; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (myOrderOks(OrderTicket())==false) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderOpenPrice(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}

_p_int myFun96_4() {
   _m_int magic=订单识别码;
   string comm=订单注释;
   double pnt=MarketInfo(sym,MODE_POINT);
   int type=1; 

   double op=myFun175_2(); if (op<Point) return 0;
   int t0=int(1);
   int jg=int(int(__挂单偏离点数));
   double lots=myLotsValid(sym,_mPubv[0],true);
   int slt=0; double sl=0;
   int tpt=0; double tp=int(__止盈点数);
   int err=0;

   if (t0==0) op+=jg*pnt;
   else op-=jg*pnt;
   
   int tt=type;
   if (op>Bid) {
      if (type==OP_BUY) type=OP_BUYSTOP;
      else type=OP_SELLLIMIT;
   }
   else {
      if (type==OP_BUY) type=OP_BUYLIMIT;
      else type=OP_SELLSTOP;
   }
   
   int stoplevel=(int)MarketInfo(sym,MODE_STOPLEVEL);
   if (err==0) {
      if (type==OP_BUYLIMIT || type==OP_SELLLIMIT) return 0;
      if (type==OP_BUYSTOP && op<Ask+stoplevel*pnt) return 0;
      if (type==OP_SELLSTOP && op>Bid-stoplevel*pnt) return 0;
   }
   else if (err==2) {
      if (type==OP_BUYSTOP || type==OP_SELLSTOP) return 0;
      if (type==OP_BUYLIMIT && op>Bid-stoplevel*pnt) return 0;
      if (type==OP_SELLLIMIT && op<Ask+stoplevel*pnt) return 0;
   }

   bool xj=0;
   if (err==1 || err==2) {   
      if (type==OP_BUYSTOP && op<Ask+stoplevel*pnt) xj=1;
      else if (type==OP_SELLSTOP && op>Bid-stoplevel*pnt) xj=1;
      else if (type==OP_BUYLIMIT && op>Bid-stoplevel*pnt) xj=1;
      else if (type==OP_SELLLIMIT && op<Ask+stoplevel*pnt) xj=1;
   }   

   if (xj==1) {
      if (tt==OP_BUY) op=Ask;
      else op=Bid;
   }
   
   if (tt==OP_BUY) {
      if (slt==0 && sl>0.001) sl=op-sl*pnt;
      if (tpt==0 && tp>0.001) tp=op+tp*pnt;
   }
   else {
      if (slt==0 && sl>0.001) sl=op+sl*pnt;
      if (tpt==0 && tp>0.001) tp=op-tp*pnt;
   }
   
   _tn_int tn=0;
   if (xj==1) {
      tn=OrderSend(sym,tt,lots,op,最大允许滑点,sl,tp,comm,magic);
      if (tn<=0) Print("~~~~~~~~~~建仓错误：",GetLastError());
   }
   else {
      tn=OrderSend(sym,type,lots,op,0,sl,tp,comm,magic);
      if (tn<=0) Print("~~~~~~~~~~挂单错误：",GetLastError());
   }
   return tn;

}

double myFun25_17() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELL]=1;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=1;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_20() {
   double a=double(myFun25_17());
   double b=double(0);

   return a>b;

}

double myFun195_1() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=0;
   ts[OP_SELL]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=0;
   ts[OP_SELLSTOP]=1;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=-1; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderTakeProfit(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}

double myFun161_1() {
   double pnt=MarketInfo(sym,MODE_POINT); if (pnt<0.0000001) { Print("读取商品点值失败：",sym); return 0; }
   double x=MarketInfo(sym,MODE_ASK)-MarketInfo(sym,MODE_BID);

   x/=pnt;

   return x;

}

_p_int myFun73_1() {
   指令执行了操盘=0;
   if (OrdersTotal()<=0) return 0;
   int onlylast=0;
   int type=0;
   double pnt=MarketInfo(sym,MODE_POINT);
   double sl=0,off=0;

   sl=double(myFun195_1());
   off=double(myFun161_1());
   if (sl>Point) {
      if (1==0) sl+=off*pnt;
      else sl-=off*pnt;
   }
   if (sl<0) sl=0;

   double ask=MarketInfo(sym,MODE_ASK);
   double bid=MarketInfo(sym,MODE_BID);
   int stoplevel=(int)MarketInfo(sym,MODE_STOPLEVEL);
   double ask2=ask+stoplevel*pnt;
   double bid2=bid-stoplevel*pnt;
   int digit=(int)MarketInfo(sym,MODE_DIGITS);
   for(int pos=OrdersTotal()-1;pos>=0;pos--) {
      if (OrderSelect(pos,SELECT_BY_POS)==false) continue;

      if (myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;
      if (OrderType()!=type) continue;
      if (myOrderOks(OrderTicket())==false) continue;

      if (MathAbs(OrderStopLoss()-sl)<pnt) continue;

      if (sl<Point) continue;
      if (OrderType()==OP_BUY && OrderStopLoss()>pnt && sl<OrderStopLoss()) continue;
      if (OrderType()==OP_SELL && OrderStopLoss()>pnt && sl>OrderStopLoss()) continue;

      if (sl>Point) {
         if ((OrderType()==OP_BUY && sl>bid2) || (OrderType()==OP_SELL && sl<ask2)) {
            static datetime pt0=0; 
            if (TimeCurrent()-pt0>10800) { pt0=TimeCurrent(); 
               string s="";
               if (OrderType()==OP_BUY) s="bid2="+DoubleToStr(bid2,digit);
               else s="ask2="+DoubleToStr(ask2,digit);
               Print("~~~~~~~~要设置的止损价离现价太近，无法设置，稍后再试。#",OrderTicket(),", 平台要求偏离点数：",stoplevel,", 要设置的止损价：",DoubleToStr(sl,digit),",  ",s); 
            }
            continue;
         } 
      }
      if (OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),OrderExpiration())==false) 
         Print("止损修改失败#",OrderTicket(),",",OrderSymbol(),",",GetLastError());
      else 指令执行了操盘=1;
      if (onlylast) break;
   }
   return 0;

}

double myFun25_18() {
   if (OrdersTotal()<=0) return 0;
   int magic=1; if (0==1) magic=0;   
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_BUYLIMIT]=0;
   ts[OP_BUYSTOP]=1;
   ts[OP_SELL]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   int c=0;
   for (int cnt=OrdersTotal()-1;cnt>=0;cnt--) {
     if (OrderSelect(cnt,SELECT_BY_POS)==false) continue;
     if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

     if (sym!="" && OrderSymbol()!=sym) continue;

     if (ts[OrderType()]==0) continue;
     if (myOrderOks(OrderTicket())==false) continue;
     c+=1;
   }
   return c;

}

bool myFun17_21() {
   double a=double(myFun25_18());
   double b=double(0);

   return a>b;

}

double myFun195_2() {
   int magic=0; 
   if (magic==0) magic=-2;
   else magic=0;
   int ts[10]={}; ArrayInitialize(ts,0);
   ts[OP_BUY]=1;
   ts[OP_SELL]=0;
   ts[OP_BUYLIMIT]=0;
   ts[OP_SELLLIMIT]=0;
   ts[OP_BUYSTOP]=1;
   ts[OP_SELLSTOP]=0;
   if (ts[OP_BUY]+ts[OP_BUYLIMIT]+ts[OP_BUYSTOP]+ts[OP_SELL]+ts[OP_SELLLIMIT]+ts[OP_SELLSTOP]==0) ArrayInitialize(ts,1);
   datetime begtime=myTimeVar(101);
   datetime tmo=0; double v=-1; _tn_int tn0=0;
   for (int h=OrdersTotal()-1;h>=0;--h) {
      if (OrderSelect(h,SELECT_BY_POS)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;

      if (magic!=0 && myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;
      if (ts[OrderType()]==0) continue;
      if (OrderOpenTime()<begtime) continue;
      if (OrderOpenTime()>tmo || (OrderOpenTime()==tmo && OrderTicket()>tn0)) { tn0=OrderTicket(); tmo=OrderOpenTime(); v=OrderTakeProfit(); } //不能用tn判断，因为挂单入场时间变，单号不变
   }

   return v;

}

double myFun161_2() {
   double pnt=MarketInfo(sym,MODE_POINT); if (pnt<0.0000001) { Print("读取商品点值失败：",sym); return 0; }
   double x=MarketInfo(sym,MODE_ASK)-MarketInfo(sym,MODE_BID);

   x/=pnt;

   return x;

}

_p_int myFun73_2() {
   指令执行了操盘=0;
   if (OrdersTotal()<=0) return 0;
   int onlylast=0;
   int type=1;
   double pnt=MarketInfo(sym,MODE_POINT);
   double sl=0,off=0;

   sl=double(myFun195_2());
   off=double(myFun161_2());
   if (sl>Point) {
      if (0==0) sl+=off*pnt;
      else sl-=off*pnt;
   }
   if (sl<0) sl=0;

   double ask=MarketInfo(sym,MODE_ASK);
   double bid=MarketInfo(sym,MODE_BID);
   int stoplevel=(int)MarketInfo(sym,MODE_STOPLEVEL);
   double ask2=ask+stoplevel*pnt;
   double bid2=bid-stoplevel*pnt;
   int digit=(int)MarketInfo(sym,MODE_DIGITS);
   for(int pos=OrdersTotal()-1;pos>=0;pos--) {
      if (OrderSelect(pos,SELECT_BY_POS)==false) continue;

      if (myIsOpenByThisEA2(OrderMagicNumber(),1)==false) continue;

      if (sym!="" && OrderSymbol()!=sym) continue;
      if (OrderType()!=type) continue;
      if (myOrderOks(OrderTicket())==false) continue;

      if (MathAbs(OrderStopLoss()-sl)<pnt) continue;

      if (sl<Point) continue;
      if (OrderType()==OP_BUY && OrderStopLoss()>pnt && sl<OrderStopLoss()) continue;
      if (OrderType()==OP_SELL && OrderStopLoss()>pnt && sl>OrderStopLoss()) continue;

      if (sl>Point) {
         if ((OrderType()==OP_BUY && sl>bid2) || (OrderType()==OP_SELL && sl<ask2)) {
            static datetime pt0=0; 
            if (TimeCurrent()-pt0>10800) { pt0=TimeCurrent(); 
               string s="";
               if (OrderType()==OP_BUY) s="bid2="+DoubleToStr(bid2,digit);
               else s="ask2="+DoubleToStr(ask2,digit);
               Print("~~~~~~~~要设置的止损价离现价太近，无法设置，稍后再试。#",OrderTicket(),", 平台要求偏离点数：",stoplevel,", 要设置的止损价：",DoubleToStr(sl,digit),",  ",s); 
            }
            continue;
         } 
      }
      if (OrderModify(OrderTicket(),OrderOpenPrice(),sl,OrderTakeProfit(),OrderExpiration())==false) 
         Print("止损修改失败#",OrderTicket(),",",OrderSymbol(),",",GetLastError());
      else 指令执行了操盘=1;
      if (onlylast) break;
   }
   return 0;

}
