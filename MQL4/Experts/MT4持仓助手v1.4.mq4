//|                                                  MT4持仓助手.mq4 |
//|                                                              xyz |
//|                                                   xyz0217@qq.com |
#property copyright "EA更新地址"
#property link      "http://blog.sina.com.cn/s/blog_98c568c20102xma8.html"
#property version   "1.4"
#property description "使用前先打印EA快捷键说明文件 文件在网盘中 网盘地址在上面或者看EA的代码 在头部位置"
#property strict
#define TP_PRICE_LINE "OG TP Price Line"
#define SL_PRICE_LINE "OG SL Price Line"

//网盘地址 https://xyz0217.lanzoui.com/b02ccvfve  密码 1111 方便下载但更新可能不及时 临时
//网盘地址 https://pan.baidu.com/s/1H5vIu8YTcivl3eZ3qtjKLg 密码 pc1o 更新可能不及时
//网盘地址 https://1drv.ms/f/s!Ag12rv4UaBTFdk21qQ-u-7ViriU   更新及时相关文件全，但国内访问不稳定
//网盘地址 https://mega.nz/folder/uN9A1D5b#5_ou1D3moJMYyVZVDQnATQ 更新及时 相关文件全，但国内访问不稳定
//EA更新地址 http://blog.sina.com.cn/s/blog_98c568c20102xma8.html

//此代码是在GPL-3.0许可下发布的。
//This code is released under the GPL-3.0 license.

//搜索定位  ttt OnTick()  tttt  OnTimer()  1111 主数字键 1   Test 测试键
/*
V1.4
键盘右面的Shift sparam的值被官方改为了310 以前是54，造成键盘右面的Shift无法使用，已修复，mql4官方这是啥情况？ 2021.9.13
提前按B键再L+P触线只平buy单  提前按N键再L+P触线只平sell单 （S键被占用无法使用S键平空单）2021.9.13
增加一键反手开仓 Ctrl+Alt+F 触及横线 平仓后反手 2021.9.8
代码太多运行不流畅 优化了代码运行逻辑 没订单时停用了大部分功能 节约系统性能 2021.08.24
优化了横线模式 L+K 触及横线开仓的几种不同模式 2021.08.23
修改了一些错误 2021.08.19
增强划线代码部分功能 划线挂单 划线平仓 划线开仓 划线止盈止损 2018.05.31
增加全局变量 默认开启 限制EA最多可下的订单手数，防止盲目下单
由于笔记本小键盘开启不方便 先添加了两个笔记本上用的下单按键 buy单 p键右边第二个键 sell单L键右边第二个键 Ctrl+Alt+ } 开启 2018.01.11
修改了锁仓快捷键 换成了Shift+小键盘0 Tab+主键盘0 EA运行总开关临时关闭
增加了一些功能的快捷开关 Tab+主键盘1~6 划线和定时器的一些快捷开关 2017.11.10
增加了划线挂单模式 触及线开始挂单
增加了整数位设置止盈止损 V/A+T/F 2017.11.10
增加了可以灵活设置偏移量的按键 方向键的 上键和下键  程序会记录上键或者下键按下的次数 挂单前可以先按几次 程序会根据你按下的次数做更大的偏移 2017.10.31
增强了整数位挂单模块的能力 可以提前按几次T键进行更灵活更大的偏移 2017.10.29
增加了分批平仓的全局变量设置 为了节约电脑性能在一个MT4中相同货币对可以运行多个EA副本 但EA自动处理订单的功能只能在其中一个副本中使用 2017.10.18
增加不同的小数点位数，使用不同的止盈止损 而且参数不会再因为重新加载而丢失了 2017.10.16
划线平仓的代码里有布林带平仓 顺手整理了一下 解决了老代码提示警告的问题 2017.10.12
整体把划线平仓的代码移植到了EA中，由于代码比较复杂，而且写的比较早，有很多不兼容的地方，以后我会慢慢改的现在追求的是能用就好，哈哈 2017.10.07
添加一键平buy单 一键平sell单 2017.10.02
添加客户端全局变量 以应对重新加载EA时之前修改的参数丢失问题 以后会添加更多的参数为客户端全局变量 2017.09.30
第一次运行EA时要求修改适合自己的全局默认下单手数 修改后 参数不会再丢失了
修改接受BUG的邮箱，国外的邮箱由于国内总所周知的原因收发不稳定
添加默认下单量 四 五 六 倍的下单快捷键 Ctrl+小键盘9,8,7或6,5,4
V1.3
调整屏幕提示的方式和位置 2017.08.18
增加定时器5 6，计算不同的K线定时止盈止损 2017.05.25
增加整数位批量挂单抓回撤
增加智能计算最近的最低最高点以斐波那契百分比位挂单 2017.02.17
快捷键不够用 启用V和A代替B和S表示 buy单和sell单 以扩充快捷键。
增加快速设置止盈止损和快速设置挂单快捷键
正式启用定时器功能，处理简单的智能止盈止损
修改底层代码，加入部分自定义函数，为以后添加自动止盈止损自动加仓自动减仓功能做准备 2017.01.20
V1.2
增加批量移动当前止盈止损的快捷键 2017.01.12
优化了部分代码和设置。
增加了大量的快捷键，主要集中在止盈止损和挂单上，都集中在调试模块，适合在快速的行情中入场和出场，追单。2016.11.29
V1.1
修复了部分漏洞
增加键盘下单模式，使用了OnChartEvent()函数，它和脚本最大的区别就是它会记下快捷键按下的次数，自动重复的执行，如果想平几单，而不是全部订单
您可以快速的按几下平一单的快捷键，而不用担心有没有执行，它会一直执行完为止的，所以下单的时候一定要小心，不要按错次数了哦。
快捷键可以自定义 请先打开 测试键盘按钮状态的位掩码的字符串值 的开关，然后按下你想使用的快捷键，获取的sparam数值在EA的实时日志上。
组合键Ctrl+Alt+字母或数字也有自己的sparam的值，所以也可以使用组合键。
增加一键设置保本。
增加一键锁仓。
增加一键批量开反向单锁仓只有同向单时使用，使用说明在下面的自定义fanxiangsuodan函数里，必看！
增加批量挂单，主要用于追行情，突破行情时使用。
增加批量修改止盈止损点数或直接输入价位,第二次使用时之前设置的参数还在，记得先清零。
增加批量智能设置止损止盈，使用时，先设置参数，第二次使用时之前设置的参数还在，记得先清零。
增加快速平一单模式，可以按时间先后或者价格高低选择 2016.07.26
增加订单信息显示 2016.07.28
加入一些短线做单时使用的快捷键，在调试模块，正在完善中。。。 2016.09.08
快速修改EA参数时，可以使用“F7”快捷键。
V1.0
计时器平仓模式
设定多少秒运行一次平仓代码 行情波动大时，不那么迅速的平仓，能得到更多的利润，当然有得必有失，
如果回撤过于迅速,也可能会有到达分批平仓点位没平掉的情况。
Tick平仓模式
每个报价都会运行一次平仓代码，到达分批平仓点位时，基本都能平掉部分仓位。
minTP 分批平仓单子之间的最小间距，如果在行情波动不剧烈的时候出现一次在很近的位置平掉两单，这是因为在平仓的时候平台滑点造成的，可以稍微调大这个minTP值
刚接触mql4不久，有很多地方都不懂，只能七拼八凑哈，如果您对这个小EA有更好的修改和建议，请给我邮件发个副本哈xyz0217@qq.com 。
本EA参考了 自动止损、止盈、盈利后移动止损、分批出场.mq4  感谢原作者 龙德而隐者 。
*/
extern bool EAswitch=true;//EA运行总开关 EA不自动处理订单 快捷键可以用 Tab+0 临时关闭 按两次 分步平仓关闭
extern string  reminder39="Shift+G 平挂单 一键锁仓 Shift+小键盘0 详细快捷键请看网盘中的功能说明文档";//小键盘9开多单6开空单 平最近下的一单 PageDown键 全平 Ctrl+Alt+P键
extern string  reminder34="Tab+3~6 定时器 Tab+7 划线平仓 Tab+8 布林带平仓 1,2,7互斥 1和2一次有效";//EA部分功能快捷开关 Tab+主键盘0 临时关闭EA Tab+1 划线挂单 Tab+2 划线开仓
extern string  reminder36="P+L buystop L+L sellstop 以划线为基准批量止盈止损B/S+O/K 一次有效";//Tab+1划线挂单开关 默认触及线开始挂单 直接挂 O+L buylimit K+L selllimit
extern string EA更新网址在左上角的关于里请及时更新最新版本、默认手数的调整在最下面="客户端全局函数设置 在最下面 修改里面的参数后不会再因为断电死机或者重新加载EA而丢失了";//
extern string reminder10="调试模块 有待完善 谨慎使用 快捷下单的按键是小键盘数字单键 小心不要误按了 ";//参数必须设置成适合自己的 版本1.4 代码漏洞或建议请发邮件 xyz0217@qq.com
extern string reminder32="挂单或止盈止损前可以先按几次 程序会根据你按下的次数做更大的偏移 ";//可以灵活设置偏移量的按键 方向键的 上键和下键 默认按一次偏移20
extern string reminder20="整数位批量挂单抓回撤 O+t buylimit K+t selllimit 整数位设置止盈止损 V/A+T/F";//计算最近的最低最高点以斐波那契百分比位挂单 O+f buylimit K+f selllimit
extern string reminder22="Buylimit O+ Buystop P+ Selllimit K+ Sellstop L+ 小键盘0,1,2,3";// 快捷距当前价多少点挂单 智能挂单G+t/p G+s/l 智能止盈止损b/s+j/i或b/s+u/h
extern string reminder23="Buylimit O+ Buystop P+ Selllimit K+ Sellstop L+ 小键盘4,5,7,8";//计算最近多少K线的最高点和最低点挂单 有问题请先看下EA的日志 Tab+主键盘1~9-0快捷开关
extern string reminder24="Shift+T/P Buylimit Buystop Shift+S/L Selllimit Sellstop  Shift+G 批量平挂单";//快捷计算最近K线的最低最高价智能计算批量挂单 参数设置在下面
extern int piliangtpdianshu=5;//以均/现价基础批量设置止盈的基数  b/s+p/l+主键盘0-9均价
extern int piliangsldianshu=5;//以均/现价基础批量设置止损的基数  b/s+o/k+主键盘0-9现价
extern int piliangtpjianju=2;//以均/现价基础批量设置止盈间距 智能止盈止损 统一价位止盈止损v/a+i/j
extern int piliangsljianju=3;//以均/现价基础批量设置止损间距 计算结果的基础上再减去多少点止盈止损v/a+u/h
extern int moveSTTP=50;//紧急批量上移或下移止盈止损距当前多少个点 b/s+止盈y/g 止损t/f
extern string reminder27="=== 定时器模块 定时自动移动止盈止损 追单专用 ===";//一般在一分钟或五分钟上用
extern bool timeGMTYesNo3=false;//定时器3开关 定时批量智能移动止损位 一分钟上用  =========
extern int timeGMTSeconds3=60;//定时器3 多少秒运行一次
extern bool buytrue03=true;//定时器3 ture只处理多单 false只处理空单
extern bool timeGMTYesNo4=false;//定时器4开关 定时批量智能移动止盈位 一分钟上用
extern int timeGMTSeconds4=60;//定时器4 多少秒运行一次
extern bool buytrue04=true;//定时器4 ture只处理多单 false只处理空单
extern bool timeGMTYesNo5=false;//定时器5开关 定时批量智能移动止损位 五分钟上用  =========
extern int timeGMTSeconds5=300;//定时器5 多少秒运行一次
extern bool buytrue05=true;//定时器5 ture只处理多单 false只处理空单
extern bool timeGMTYesNo6=false;//定时器6开关 定时批量智能移动止盈位 五分钟上用
extern int timeGMTSeconds6=300;//定时器6 多少秒运行一次
extern bool buytrue06=true;//定时器6 ture只处理多单 false只处理空单
extern string reminder28="快捷止盈止损距离当前价的点数 如参数小于平台停止水平位直接在水平位设置 ===";//如果是V/A+小键盘数字既按均价基础计算
extern double zhinengSLTP1=40;//需要移动的点数
extern int zhinengSLTP2=80;//快捷止损b或s+小键盘1,4,7 双倍默认点数快捷止损b或s+小键盘3,6,9
extern int zhinengSLTP3=120;//快捷止盈b或s+小键盘,2,5,8 如果是V/A+小键盘数字既按均价基础计算
extern int zhinengSLTPjianju=1;//止盈止损间距
extern int zhinengSLTPjuxianjia=20;//保护措施 距现价的最小止盈止损距离
extern int zhinengSLTPdingdangeshu=10;//只处理最近下的多少单
extern string reminder17="=== 快速批量智能设置统一止盈止损位 ===";//默认以最小的小数点为基准
extern int timeframe06=0;//图表时间周期 v/a+i/j 止损是计算结果再增加双倍点差的位置
extern int bars06=13;//取图表多少根k线计算结果
extern int beginbar06=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju06=0;//止损止盈间距
extern int juxianjia06=10;//保护措施 距现价的最小止赢止损距离
extern int dingdangeshu06=100;//只处理最近下的多少单
extern int pianyiliang06=50;//止损在计算结果的基础上上移或下移几个点
extern int pianyiliang06tp=15;//止赢在计算结果的基础上上移或下移几个点智能设置统一止盈位
extern int selltp06=20;//sell单止盈加点差的基础上再上移多少点 防止平台恶意扩大点差而无法止盈
extern string reminder16="=== 快速批量智能计算在结果的基础上减去点差再减去多少点止盈止损 ===";//默认以最小的小数点为基准
extern int timeframe05=0;//图表时间周期 v/a+u/h
extern int bars05=13;//取图表多少根k线计算结果
extern int beginbar05=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju05=3;//止损止盈间距
extern int juxianjia05=30;//保护措施 距现价的最小止赢距离
extern int dingdangeshu05=300;//只处理最近下的多少单
extern int pianyiliang05=80;//止损在计算结果的基础上上移或下移几个点
extern int pianyiliang05tp=20;//止赢在计算结果的基础上上移或下移几个点
extern string reminder12="=== 快速智能设置止盈止损参数短线追单专用 ===";//默认以最小的小数点为基准
extern int timeframe10=0;//图表时间周期  止损是计算结果再增加双倍点差的位置
extern int bars10=13;//取图表多少根k线计算结果 B/S+I/J
extern int bars1010=7;//取图表多少根k线计算结果 B/S+U/H 计算K线数不同
extern int beginbar10=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju10=3;//止损间距 Tab+Q 移动止盈止损到5000点上 变相取消
extern int jianju10tp=2;//止盈间距
extern int juxianjia10=20;//保护措施 距现价的最小止赢止损距离
extern int dingdangeshu10=100;//只处理最近下的多少单
extern int pianyiliang10=50;//止损在计算结果的基础上上移或下移几个点
extern int pianyiliang10nom=50;//止损在计算结果的基础上上移或下移几个点 N/D+小键盘数字 快捷智能止损
extern int dingdangeshu10nom=10;//快捷 只处理最近下的多少单 N/D+小键盘数字 快捷智能止损
extern int pianyiliang10tp=20;//止赢在计算结果的基础上上移或下移几个点
extern int selltp10=20;//sell单止盈加点差的基础上再上移多少点 防止平台恶意扩大点差而无法止盈
extern string reminder15="=== 快捷距当前价或计算最近多少K线的最高点和最低点挂单 ===";//默认以最小的小数点为基准
extern int Guadanprice=10;//快捷距当前价多少点挂单 当挂单距离现价低于停止水平位时以停止水平位挂单
extern int Guadanprice1=40;//Buylimit o+ Buystop p+
extern int Guadanprice2=60;//Selllimit k+ Sellstop l+
extern int Guadanprice3=80;//  +小键盘0,1,2,3
extern int Guadanprice4=14;//快捷计算最近多少K线的最高点和最低点挂单
extern int Guadanprice5=5;//Buylimit o+ Buystop p+
extern int Guadanprice7=17;//Selllimit k+ Sellstop l+
extern int Guadanprice8=8;//   +小键盘4,5,7,8 分别对应设置的K线
extern int Guadanbuylimitpianyiliang=40;// Buylimit在计算结果的基础上 上移多少点
extern int Guadanselllimitpianyiliang=30;//Selllimit在计算结果的基础上 下移多少点
extern int Guadandianchabeishu=2;//挂Buystop和Sellstop时偏移多少倍点差以防假突破
extern double Guadanlots=0.3;//挂单手数
extern int Guadangeshu=5;//挂单个数
extern int Guadanjianju=3;//挂单间距
extern int Guadanjuxianjia=15;//保险措施 距现价挂单的最小点数
extern double Guadansl=0.0;//挂单止损点数 0不设止损
extern double Guadantp=0.0;//挂单止盈点数 0不设止盈
extern string  comment1="=== 快捷计算最近K线的最低最高价智能计算批量挂单 ===";//默认以最小的小数点为基准
extern int Guadanprice41=11;//快捷计算最近多少K线的最高点和最低点挂单
extern int Guadanbuylimitpianyiliang1=20;//Buylimit在计算结果的基础上 上移多少点
extern int Guadanselllimitpianyiliang1=10;//Selllimit在计算结果的基础上 下移多少点
extern int Guadandianchabeishubuylimit1=2;//挂Buylimit 向上偏移多少倍点差以防挂不上
extern int Guadandianchabeishuselllimit1=2;//挂Selllimt 向下偏移多少倍点差以防挂不上
extern int Guadandianchabeishu1=2;//挂Buystop和Sellstop时偏移多少倍点差以防假突破
extern double Guadanlots1=0.2;//挂单手数 挂单前可以先按几次T键 程序会根据你按下的次数做更大的偏移
extern int Guadangeshu1=5;//挂单个数 Shift+T/P Buylimit Buystop Shift+S/L Selllimit Sellstop
extern int Guadanjianju1=3;//挂单间距 Shift+G 批量平挂单
extern int Guadanjuxianjia1=15;//保险措施 距现价挂单的最小点数
extern double Guadansl1=0.0;//挂单止损点数 0不设止损 按一次T键偏移的默认值是20个基点
extern double Guadantp1=0.0;//挂单止盈点数 0不设止盈
extern string reminder11="=== 智能挂单参数设置短线追单专用 ===";//默认以最小的小数点为基准
extern int zhinengguadanjuxianjia=20;//挂单距当前价最小距离 智能挂单G+t buylimit G+s selllimit
extern int zhinenga=13;//取最近的多少根K线计算 G+p buystop G+l sellstop
extern double zhinengguadanlots=0.2;//挂单手数
extern int zhinengguadangeshu=5;//挂单个数
extern int zhinengguadanjianju=3;//挂单间距
extern int zhinengguadanSL=0;//挂单止损，0即为不设置
extern int zhinengguadanTP=0;//挂单止盈，0即为不设置
extern int zhinengguadanslippage=5;//挂单滑点数
extern int zhinengb=0;//从第几根k线开始计算，默认当前K线
extern int zhinengtimeframe=0;//K线的时间周期，默认当前图表时间周期
extern int zhinengguadanzengjiabuy=30;//上移几个点开始挂buylimit单 可以是负数
extern int zhinengguadanzengjiasell=15;//下移几个点开始挂selllimit单 可以是负数
extern int zhinengguadanzengjiabuystop=30;//上移几个点开始挂buystop单 可以是负数
extern int zhinengguadanzengjiasellstop=15;//下移几个点开始挂sellstop单 可以是负数
extern string reminder19="=== 计算最近的最低最高点以斐波那契百分比位挂单 ===";//默认以最小的小数点为基准
extern int timeframe07=0;//图表时间周期 数量多的K线计算参数
extern int bars07=31;//取图表多少根k线计算结果 O+f buylimit K+f selllimit
extern int beginbar07=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int timeframe08=0;//图表时间周期  数量少的K线计算参数    ====
extern int bars08=11;//取图表多少根k线计算结果 斐波那契需要两个点划线 这个模块就是找到这两个点
extern int beginbar08=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern string reminder18="=== 斐波那契百分比挂单参数 ===";//默认以最小的小数点为基准
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
extern string reminder21="=== 整数位批量挂单抓回撤 ===";//默认以最小的小数点为基准
extern int tenweishu=5;//报价从左到右包含整数部分(小数点也算一位)截取的的位数 之后的忽略
extern double tenmax=30;//当点差过大时 buylimit单在计算结果上加上这个点数 不再参考点差
extern double tenGuadanlots=0.3;//挂单手数 如果selllimit挂的价位偏差很大 请调整上面截取的位数
extern int tenGuadangeshu=5;//挂单个数 O+t buylimit K+t selllimit
extern int tenGuadanjianju=3;//挂单间距
extern int tenbuypianyiliang=30;//buylimit偏移量 在计算结果的基础上整体上移多少点
extern int tensellpianyiliang=25;//selllimit偏移量 在计算结果的基础上整体下移多少点
extern int tenGuadanjuxianjia=20;//保险措施 距现价挂单的最小点数
extern double tenGuadansl=0;//挂单止损点数 0不设止损
extern double tenGuadantp=0;//挂单止盈点数 0不设止盈
extern string reminder31="=== 整数位智能计算后批量止盈止损 ===";//默认以最小的小数点为基准
extern int tensltpweishu=5;//报价从左到右包含整数部分(小数点也算一位)截取的的位数 之后的忽略
extern double tensltpmax=30;//当点差过大时 在计算结果上加上这个点数 不再参考点差
extern int tensltppianyiliang=25;//止损偏移量 V/A+T/F
extern int tentppianyiliang=25;//止盈偏移量
extern int tensltpjianju=3;//间距
extern int tensltpjuxianjia=15;//保险措施 距现价挂单的最小点数
extern int tensltpdingdangeshu=10;//处理的订单数
extern string reminder05="=== 批量智能设置止盈止损参数设置 ===";//默认以最小的小数点为基准
extern int a=13;//取最近的多少根K线计算止损最低最高值
extern int b=0;//从第几根k线开始计算，默认当前K线
extern int timeframe=0;//K线的时间周期，默认当前图表时间周期
extern int c=5;//止损间距
extern int e=30;//距离现价的最小止损止盈点数
extern int d=10;//在计算结果的基础上增加几个点，可以是负整数
extern double SL=0.0;//或直接输入止损价格,价格优先
extern double TP=0.0;//或直接输入止盈价格，下次用时记得清零
extern string reminder13="=== 定时器3参数 定时批量智能移动止损位 ===";//默认以最小的小数点为基准
extern int timeframe03=0;//图表时间周期
extern int bars03=11;//取图表多少根k线计算结果
extern int beginbar03=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju03=3;//止损间距
extern int juxianjia03=30;//保护措施 距现价的最小止损距离
extern int pianyiliang03=50;//止损在计算结果的基础上上移或下移几个点
extern int dingdangeshu03=10;//只处理最近下的多少单
extern string reminder14="=== 定时器4参数 定时批量智能移动止盈位 ===";//默认以最小的小数点为基准
extern int timeframe04=0;//图表时间周期
extern int bars04=11;//取图表多少根k线计算结果
extern int beginbar04=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int jianju04=3;//止赢间距
extern int juxianjia04=15;//保护措施 距现价的最小止赢距离
extern int pianyiliang04tp=20;//止赢在计算结果的基础上上移或下移几个点
extern int dingdangeshu04=10;//只处理最近下的多少单
extern string reminder25="=== 定时器5参数 定时批量智能移动止损位 ===";//默认以最小的小数点为基准
extern int dingshitimeframe05=0;//图表时间周期
extern int dingshibars05=7;//取图表多少根k线计算结果
extern int dingshibeginbar05=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int dingshijianju05=3;//止损间距
extern int dingshijuxianjia05=30;//保护措施 距现价的最小止损距离
extern int dingshipianyiliang05=50;//止损在计算结果的基础上上移或下移几个点
extern int dingshidingdangeshu05=10;//只处理最近下的多少单
extern string reminder26="=== 定时器6参数 定时批量智能移动止盈位 ===";//默认以最小的小数点为基准
extern int dingshitimeframe06=0;//图表时间周期
extern int dingshibars06=7;//取图表多少根k线计算结果
extern int dingshibeginbar06=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int dingshijianju06=3;//止赢间距
extern int dingshijuxianjia06=15;//保护措施 距现价的最小止赢距离
extern int dingshipianyiliang06tp=20;//止赢在计算结果的基础上上移或下移几个点
extern int dingshidingdangeshu06=10;//只处理最近下的多少单
extern string reminder03=" ===  键盘下单参数设置  === ";//
extern bool keycode=true;//键盘下单默认开启
extern int buykey=73;//买单按键 默认小键盘数字键“9”
extern int sellkey=77;//卖单按键 默认小键盘数字键“6”
extern int buykeydouble=72;//买单按键 双倍默认手数 小键盘数字键“8”
extern int sellkeydouble=76;//卖单按键 双倍默认手数 小键盘数字键“5”
extern int buykey3=71;//买单按键 三倍默认手数 小键盘数字键“7”
extern int sellkey3=75;//卖单按键 三倍默认手数小键盘数字键“4”
extern int holdingtimemin=180;//下单前按一下Shift带止损下单按一下保持多少秒内有效 短时间
extern int holdingtimemax=1800;//下单前按一下Shift带止损下单 长时间有效 小键盘 小数点切换
extern int zuidaclose=338;//平价格最高的一单，默认“Insert”键
extern int zuixiaoclose=339;//平价格最低的一单，默认“Delete”键
extern int zuizaoclose=335;//平最早下的一单，默认“End”键
extern int zuijinclose=337;//平最近下的一单，默认“PageDown”键
extern int yijianPingcang=8217;//一键平仓，默认Ctrl+Alt+“P”键
extern int yijianPingbuydan=8240;//一键平buy单，默认Ctrl+Alt+“B”键
extern int yijianPingselldan=8223;//一键平sell单，默认Ctrl+Alt+“S”键
extern int baobenSL=8230;//批量设置止损位在保本线上,Ctrl+Alt+“L”键 默认处理多空单
extern int baobenTP=8212;//批量设置止盈位在保本线上,Ctrl+Alt+“T”键 如果提前按了B/S只处理一边
extern int piliangSLTP=1;//Tab+Esc 移动止盈止损到5000点上 变相取消 仅应急使用
//extern int zhinengSL=31;//批量智能设置止损 默认Tab+“S”键
//extern int zhinengTP=20;//批量智能设置止盈 默认Tab+“T”键
extern int suoCang=82;//一键锁仓，Shift+小键盘数字键“0” b/s+主键盘数字0 取消止盈止损
extern int fanxiangSuodan=82;//批量开反向单锁仓只有同向单时使用，Ctrl+小键盘数字键“0”
extern int timeframe09=0;//图表时间周期    带止损下单设置                       ====
extern int beginbar09=0;//0从当前K线开始 5就是距当前K线往左5根K线忽略不计
extern int bars097=7;//现价买一单然后取最近多少根k线计算最低价减去点差再减去偏移量的价位设置止损
extern int buypianyiliang=50;//buy单偏移量 止损在计算结果的基础上上移或下移几个点
extern int sellpianyiliang=50;//sell单偏移量 止损在计算结果的基础上上移或下移几个点  ====
extern int buypianyiliang9=30;//小偏移量 Ctrl+Alt+小键盘"9" buy单带止损 对应K线7 两倍点差偏移
extern int sellpianyiliang6=30;//小偏移量 Ctrl+Alt+小键盘"6" sell单带止损 快速带止损追单 如果反向直接止损出来
extern int bars096=4;//小偏移量 使用的取最近多少根k线计算最低价减去点差再减去偏移量的价位设置止损
extern double keylots=0.3;//键盘下单手数
extern int keyslippage=20;//键盘下单模式滑点数
extern string reminder01="=== 止盈止损移动止损参数设置 ===";//默认以最小的小数点为基准
extern bool autosttp=true;//止盈止损移动止损总开关 默认为计时器模式运行
extern bool timeGMTYesNo1=true;//自动止盈止损移动止损 定时器开关
extern int timeGMTSeconds1=180;//自动止盈止损移动止损多少秒运行一次
extern bool AutoStoploss=true;//止损开关
extern double stoploss=320;//止损点数
extern bool AutoTakeProfit=true;//止盈开关
extern double takeprofit=500;//止盈点数
extern bool AutoTrailingStop=true;//盈利后移动止损开关
extern double TrailingStop=340;//移动止损点数
extern string reminder02="=== 等比例分步平仓参数设置 ===";//默认以最小的小数点为基准
extern int GraduallyNum=5;//在移动止损位和止盈位之间分几次平仓 止盈减移动止损后除以次数等于平仓的间隔
extern int SetTimer=5;//计时器秒数 计时器模式下分批平仓多少秒运行一次
extern int minTP=4;//调试使用 分批平仓单子之间的最小间距
extern int slippage=5;//调试使用 滑点数
//---- input parameters
extern string reminder30="有很多不兼容的地方，以后我会慢慢改的现在追求的是能用就好 哈哈 ";//下面是划线平仓设置 整体把划线平仓的代码移植到了EA中，由于代码比较复杂 而且写的比较早
extern string  管理持仓单号="*";           // *为当前图标货币的全部持仓单 所有管理的持仓必须同方向 否则不工作。
//内容可以是一个或多个持仓单的ID，分割符随便，因为程序是判断每个持仓ID是不是这个变量的子串。所有管理的持仓必须同方向，否则不工作。
extern int     获利方式1制定2趋势线0无获利平仓=2;             // 获利方式：1-制定，2-趋势线，其它值-无获利平仓。
// 程序从图上搜索对象，可以是趋势线TrendLine、角度线TrendLine By Angel、等距离通道线Equidistant Channel。
extern int     止损方式1制定2趋势线3移动止损0无止损=2;             // 止损方式：1-制定，2-趋势线，3移动止损;其它值-无止损平仓。
extern int bandsA=20;//Bands指标参数1 时间周期 选择 1制定 时 为布林带平仓模式
extern int bandsB=0;//Bands指标参数2 平移 布林带会随着你选择的时间周期改变 小心EA触及布林带直接平仓了
extern int bandsC=2;//Bands指标参数3 偏移布林带的默认参数不熟悉一定谨慎修改 请修改下面的参数 止盈平仓默认偏移了两倍点差Tab+8启动
extern int bandsdianchabeishu=2;//点差偏移倍数 偏移
extern int bandsTPpianyi=10;//止盈线偏移点数 偏移
extern int bandsSLpianyi=20;//止损线偏移点数 偏移
extern string  移动止损止损方式参数="===移动止损止损方式参数===";
extern double   止损=270;
extern double   首次保护盈利止损=200;
extern double   保护盈利 = 10;
extern double   移动步长 = 100;
extern bool    是否显示示例线=true;          // 是否在图中显示获利止损价格线，方便观察是否设置正确。
extern color  获利价格示例线=C'108,108,0';     // 获利价格线颜色
extern color   止损价格示例线=C'90,0,0';           // 止损价格线颜色
extern string reminder33="划线挂单模块 触及趋势线开始挂单";//
extern double huaxianguadanlots=0.1;//挂单手数
extern int huaxianguadangeshu=3;//挂单个数
extern int huaxianguadanjianju=3;//挂单间距
extern double huaxianguadansl=220;//挂单止损
extern double huaxianguadantp=200;//挂单止盈
extern double hengxianguadansl=0.0;//横线挂单止损 横线模式时L+G 默认不设置止盈止损
extern double hengxianguadantp=0.0;//横线挂单止盈 横线模式时L+G
extern int jianju07=3;// 止损间距 划线止盈止损参数设置
extern int jianju07tp=1;// 止盈间距 划线止盈止损参数设置
extern int pianyiliang07=20;//止损偏移 正数是正向偏移 负数是反向偏移
extern int pianyiliang07tp=20;// 止盈偏移
extern int juxianjia07=30;//距现价最小距离 保护措施
extern int dingdangeshu07=20;//只处理最近的几笔订单
extern int huaxianguadanjuxianjia=5;//安全措施 挂单距现价
extern string reminder35="划线开仓模块 触及趋势线或横线开始开仓";//
extern int huaxiankaicanggeshu=3;//开仓次数 其他参数以EA基本开仓参数为准 横线模式L+K
extern int huaxiankaicangtime=1000;//开仓间隔 毫秒 1秒=1000毫秒 只参考时间 不管开仓价位 横线模式L+K
extern int huaxiankaicanggeshuT=3;//开仓次数 参考时间和价格 止损线止损X+L+K
extern int huaxiankaicangtimeT=2000;//开仓间隔 毫秒 1秒=1000毫秒  不带止损线ctrlR+L+K
extern int huaxiankaicanggeshuR=3;//开仓次数 参考横线的位置既参考价格  横线ShiftR模式
extern double timeseconds1P=2;//开仓时间间隔 秒 既参考时间又参考价格 横线ShiftR模式
extern double huaxiankaicanglotsT=0.1;//开仓手数  横线ShiftR模式 越线后间隔时间连续开仓直到价格返回
extern double huaxianzidongjiacanglots=0.1;// 自动加仓 开仓手数 ====== 测试五分钟自动追单
extern int huaxianzidongjiacanggeshu=3;// 自动加仓 开仓次数
extern int huaxianzidongjiacanggeshutime=2;//自动加仓 移动横线次数
extern int linezidongjiacangyidong=30;//自动加仓 移动横线 多少个点
extern int linebuyzidongjiacangpianyi=20;//自动加仓 Buy Line偏移
extern int linesellzidongjiacangpianyi=20;//自动加仓 Sell Line偏移 ======
//extern int linepingcangRTime=1000;//平仓时间间隔 横线模式 按一下右边的Shift L+P越线按时间间隔一单一单平仓
extern double timeseconds=2;//平仓时间间隔 横线模式 按一下右边的Shift L+P越线按时间间隔一单一单平仓
extern int linebar=5;//计算最近多少根K线的最高最低值划一根横线 横线模式
extern double linepianyi=20;//横线模式下W/S每次上移或下移多少基点 横线模式
extern double lineslpianyi=30;//横线模式 CtrlR+ L+P 定时器模式SL 距横线偏移多少设置SL
extern int linekaicangshiftRbars=7;//ShiftR横线带止损开仓时 取最近多少根K线计算最高最低点
extern double linekaicangshiftRpianyi=100;//ShiftR横线带止损开仓时 计算结果后再偏移多少 点差已经加进去了
extern string reminder37="自动追单短线加仓 快速止盈止损 剥头皮模块 测试中";//Tab+> 多单剥头皮 Tab+< 空单剥头皮
extern int SL5mtimeGMTSeconds1=30;//设置止盈止损的间隔时间
extern int SL5mlineGraduallyNum=2;//分批平仓
extern double SL5mlinestoploss=120;//止损
extern double SL5mlinetakeprofit=160;//止盈
extern double SL5mlineTrailingStop=130;//移动止损
extern int SL1mlinetimeframe=11;//一分钟止损横线 计算最近多少根K线的最高最低点加上下面的偏移
extern int SL5mlinetimeframe=4;//五分钟止损横线 计算最近多少根K线的最高最低点加上下面的偏移
extern int SL15mlinetimeframe=3;//十五分钟止损横线 计算最近多少根K线的最高最低点加上下面的偏移
extern int SLlinepingcangjishu=3;//触及止损线平掉最近下的部分仓位
extern double SLbuylinepianyi=30;//buy单止损偏移
extern double SLselllinepianyi=30;//sell单止损偏移
extern int SLlinepingcangtime=0;//止损平仓间隔 毫秒
extern int  SL5QTPpingcang=50;//Tab+P 均价止盈横线
extern int SL1mQlinetimeframe=3;// 小键盘 * 键批量下单 计算一分钟多少根K线的最低最高价   =====
extern int SLQNum=4;//批量下单个数
extern double SLQlots=0.1;//批量下单手数 左边的“/”键双倍 必须手动设置 独立于全局手数
extern int SLQbuylinepianyi=20;//buy单止损偏移
extern int SLQselllinepianyi=20;//sell单止损偏移
extern int SL5Qtp=40;// 小键盘 * 键 下单预设的止盈点数
extern int  SL5QTPpingcang1=30;// 均价止盈横线
extern int SLQlinepingcangSleep=1000;// 均价止盈横线平仓间隔时间
extern int SL5QTPtime=180;// 计数器秒数 保本平
extern int SL5QTPtime1=300;//计数器秒数 直接平   =====
extern string reminder38="reminder38";//根据指标的数值 自动执行计划任务
extern int  imbfxTmax=95;//MBFX指标 I+主键盘1启动 使用的自定义指标
extern int  imbfxTmin=5;//MBFX指标
extern double  iBSTrendmax=0.1;//BSTrend指标 I+主键盘2启动 测试阶段
extern double  iBSTrendmin=-0.1;//BSTrend指标
extern double linebuypingcangctrlRpianyi=40;//横线模式L+P 提前按Ctrl触及横线后距当前价多少设置止损 测试

extern string reminder07="=== 全局设置 ===";//
extern bool defaultlotstrue=true;//是否启用全局下单手数 默认启用
extern bool Testsparam=false;//自定义快捷键 测试按键对应的sparam值结果在EA的日志里
extern bool testtradeSLSP=true;//平台是否支持带上止盈止损开单 默认支持 如无法开单请改为false
extern bool dingdanxianshi=true;//订单信息显示在图表 默认开启
extern color dingdanxianshicolor=clrYellow;//订单信息显示颜色
extern int dingdanxianshiX=10;//订单信息显示位置 X轴 横向位置 左上起始位
extern int dingdanxianshiY=90;//订单信息显示位置 Y轴 纵向位置
extern int dingdanxianshiX1=800;//EA操作信息显示位置 X轴 横向位置 右上
extern int dingdanxianshiY1=30;// EA操作信息显示位置 Y轴 纵向位置
extern int dingdanxianshiX2=800;//EA操作信息显示位置 X轴 横向位置 右上 第二行
extern int dingdanxianshiY2=60;// EA操作信息显示位置 Y轴 纵向位置
extern bool timeGMTYesNo2=true;//定时器2开关 日志文字提示
extern int timeGMTSeconds2=15;//停留多少秒 增加了笔记本下单的两个按键buy/sell P/L键右边隔壁按键
extern int presspianyi=20;//方向键上键和下键按一次偏移的点数 挂单前可以先按几次 程序会根据你按下的次数做更大的偏移
extern int pianyiglo=20;//止盈止损全局偏移的点数
extern int expirationM=0;//挂单有效时间 分钟 0永久 有些平台必须手动取消挂单  ===========


extern string reminder29="=== 客户端全局函数设置 只在需要更新全局函数时使用一次 更新成功后请重新加载EA ===";//全局函数下的设置不会因为EA重新加载 MT4重启 意外断电关机而重置设置参数
extern bool globalVariablesDeleteAll=false;//删除全部的客户端全局函数 初始化客户端全局函数设置
extern bool glolotsture=false;//修改全局默认下单手数开关 请改为true后修改下一行的下单手数 保存即可 ===
extern double defaultlots=0.1;//全局默认下单手数 会修改EA所有的手数设定 请先打开上面的开关
extern bool gloGraduallytrue=false;//修改等比例分步平仓开关 请改为true后修改下一行的参数 保存即可       ===
extern bool Gradually=true;//等比例分步平仓 默认开启 下一行可以修改不同的分批平仓模式
extern bool gloTickmodetrue=false;//修改分批平仓模式开关 请改为true后修改下面的参数 保存即可           ===
extern bool Tickmode=false;//分批平仓模式默认false计时器模式 Ture是Tick平仓模式 为节约电脑资源默认计时器模式
extern bool glo5Digitsture=false;//修改五位小数点时 EA自动止盈止损参数开关 请改为true后修改下面的参数 保存即可 ===
extern int glo5TP=500;//五位小数点时止盈点数 由于到达移动止损位时EA就开始自动分批平仓的原因
extern int glo5SL=320;//五位小数点时止损点数 请确保止盈减移动止损后除以4得到的是整数
extern int glo5moveSL=340;//五位小数点时移动止损点数 EA默认是分五次分批平仓
extern bool glo3Digitsture=false;//修改三位小数点时 EA自动止盈止损参数开关 请改为true后修改下面的参数 保存即可 ===
extern int glo3TP=620;//三位小数点时止盈点数 如果是黄金相关的货币对 止盈止损放大10倍
extern int glo3SL=520;//三位小数点时止损点数
extern int glo3moveSL=400;//三位小数点时移动止损点数
extern bool glo2Digitsture=false;//修改两位小数点时 EA自动止盈止损参数开关 请改为true后修改下面的参数 保存即可 ===
extern int glo2TP=620;//两位小数点时止盈点数
extern int glo2SL=520;//两位小数点时止损点数
extern int glo2moveSL=400;//两位小数点时移动止损点数
extern bool glojianjuture=false;//设置全局间距开关 控制着EA全部的止盈止损间距 挂单间距                        ===
extern bool glojianju=false;//是否启用全局间距 启用后会以下面的参数修改整个EA的间距设定 默认不启用
extern int glojianjusl=3;//全局止损间距
extern int glojianjutp=1;//全局止盈间距
extern int glojianjuguadan=3;//全局挂单间距
extern bool glomaxTotallotsture=false;//设置全局单向最大下单总手数开关 请改为true后修改下面的参数 保存即可
extern double glomaxTotallots=5;//全局单向最大下单总手数 默认启动
extern bool glotickclosenumtrue=false;//设置Tick变化剧烈时自动平仓预设值开关 请改为true后修改下面的参数 保存即可
extern double glotickclosenum=40;//Tick变化剧烈时自动平仓预设值 B/S+Tab+9
extern bool gloxianshijunjiantrue=false;//图表订单信息是否显示均价 请改为true后修改下面的参数 保存即可
extern bool gloxianshijunjian=false;//图表订单信息是否显示均价 默认不显示
string TPObjName,SLObjName;   //字符串数据是用来存储文本串 找到的那两条线的名字
int    OrdersID[],OrdersCount,OpType;
double   建仓价,移动止损=0;
/*
一、采用趋势线计算获利止损价需要注意几点：

 1.图上有多条趋势线的情况：以管理多单为例，取距离当前价上方最近的一根趋势线作为止赢趋势线，止损线为下方最近的一根。
 2.运行中，用户可以随意改变趋势线的位置，程序会自动追踪。
 3.刚启动时，程序自动搜索到止赢止损趋势线后，不会再改变，即使用户把选中的线拖到别的线之外。
 4.更换当前图的时间周期会重新启动程序，再次搜索止赢止损线。
 5.如果用户删除原先选中的趋势线，程序会自动重新搜索。
 6.如果使用等距离通道线，则多单自动用上面一根作为止赢，下面的作为止损，空单相反。
 7.不建议使用角度线，因为角度线对于k线图不是固定的，坐标轴变化会影响线上价格的值。

二、建议操作方法：

 1.开仓
 2.在图中放置好平仓的止赢止损指标或趋势线
 3.把OrdersGuardian拖入图中，设置好相应的参数，建议把是否显示示例线设为true。在选项设置的common页Allow live trading先不要打勾，当前图的右上角应该出现一个叉。
 4.按下工具栏的Expert Advisors按钮，右上角的叉会变成一个哭脸，此时EA在工作，但不会平仓操作。
 5.如果图中显示的止赢止损线和预期一致，则按快捷键F7，选中Allow live trading，如果右上角图标变成一个笑脸，EA就开始正常工作监视持仓单了。
*/

/*
extern string reminder04="=== 批量挂单参数设置 临时废弃 ===";//默认以最小的小数点为基准
extern int guadanjuxianjia=50;//据现价多少挂单
extern double guadanlots=0.2;//挂单手数
extern int guadangeshu=5;//挂单个数
extern int guadanjianju=4;//挂单间距
extern int guadanSL=0;//挂单止损，0即为不设置
extern int guadanTP=0;//挂单止盈，0即为不设置
extern int guadanslippage=5;//挂单滑点数
*/
double buyline;
double sellline;
double slline;
double buylineOnTimer;
double selllineOnTimer;
double timebuyprice=0.0;
double timesellprice=10000.0;
double huaxianguadanlotsT=huaxianguadanlots;
int linebar01=linebar;
bool akey=false;
bool zkey=false;
bool ctrl=false;
bool ctrlR=false;
bool shift=false;
bool shiftR=false;
bool tab=false;
bool bkey=false;
bool skey=false;
bool pkey=false;
bool lkey=false;
bool tkey=false;
bool gkey=false;
bool okey=false;
bool kkey=false;
bool vkey=false;
bool fkey=false;
bool jkey=false;
bool dkey=false;
bool mkey=false;
bool nkey=false;
bool nakey=false;//主键盘数字1 左边的按键
bool ikey=false;
bool fansuoYes=false;
bool yijianFanshou=false;

bool huaxianSwitch=false;//划线平仓或锁仓
bool huaxianTimeSwitch=false;//划线平仓或锁仓
bool huaxiankaicang=false;
bool huaxianguadan=false;//划线挂单开关 Tab+主键盘1 调试阶段
bool SL1mbuyLine=false;
bool SL1msellLine=false;
bool SL5mbuyLine=false;
bool SL5msellLine=false;
bool SL15mbuyLine=false;
bool SL15msellLine=false;
double SL1mbuyLineprice=Ask-1000*Point;
double SL1msellLineprice=Bid+1000*Point;
double SL5mbuyLineprice=Ask-1000*Point;
double SL5msellLineprice=Bid+1000*Point;
double SL15mbuyLineprice=Ask-1000*Point;
double SL15msellLineprice=Bid+1000*Point;
double SL1mbuyLineprice1;
double SL1msellLineprice1;
double SL5mbuyLineprice1;
double SL5msellLineprice1;
double SL15mbuyLineprice1;
double SL15msellLineprice1;
bool SLbuylinepingcang=false;
bool SLselllinepingcang=false;
bool SLbuylineQpingcang=false;//Q键 短线触及平仓 定时器
bool SLselllineQpingcang=false;
bool SLbuylineQpingcangT=false;//Q键 短线触及平仓 Tick
bool SLselllineQpingcangT=false;
double SLsellQpengcangline=Bid+1000*Point;
double SLbuyQpengcangline=Ask-1000*Point;

double yijianfanshoubuylots=0.0;
double yijianfanshouselllots=0.0;

bool SLbuylinepingcang1=false;
bool SLselllinepingcang1=false;
bool SLbuylineQpingcang1=false;//Q键 短线触及平仓 定时器
bool SLselllineQpingcang1=false;
bool SLbuylineQpingcangT1=false;//Q键 短线触及平仓 Tick
bool SLselllineQpingcangT1=false;
double SLsellQpengcangline1=Bid+1000*Point;
double SLbuyQpengcangline1=Ask-1000*Point;

int SLlinepingcangjishu1=0;//
double SLQlotsT=SLQlots;

bool imbfxT=false;//
bool iBSTrend=false;//

datetime ctrltimeCurrent;
datetime ctrlRtimeCurrent;
datetime shifttimeCurrent;
datetime shiftRtimeCurrent;
datetime tabtimeCurrent;
datetime btimeCurrent;
datetime stimeCurrent;
datetime ptimeCurrent;
datetime ltimeCurrent;
datetime ttimeCurrent;
datetime shangtimeGMT=TimeGMT();//统计 键按下的次数时使用 计时器的一种
datetime xiatimeGMT=TimeGMT();
datetime atimeCurrent;
datetime ztimeCurrent;
datetime gtimeCurrent;
datetime otimeCurrent;
datetime ktimeCurrent;
datetime vtimeCurrent;
datetime ftimeCurrent;
datetime dtimeCurrent;
datetime mtimeCurrent;
datetime ntimeCurrent;
datetime natimeCurrent;//~
datetime falsetimeCurrent;
datetime itimeCurrent;
datetime SL5QTPtimeCurrent;
bool SL5QTPtimeCurrenttrue=false;
bool onlybuy=true;
bool onlysell=true;
bool onlystp=false;
bool onlytpt=false;
bool onlyup=false;
bool onlydown=false;
bool onlybuy1=false;
bool onlysell1=false;
bool buymaxTotallots=false;//限制最多下单总手数
bool sellmaxTotallots=false;//限制最多下单总手数
bool notebook=false;//笔记本模式
bool sellbaobenture=false;
bool buybaobenture=false;
bool tickclose=false;
bool huaxianShift=false;
bool huaxianCtrl=false;
bool tickShift=false;
bool linebuykaicang=false;
bool linekaicangshiftR=false;
bool OnTickswitch=true;//没订单时减少运行 节省系统性能
bool OnTimerswitch=true;//没订单时减少运行 节省系统性能
bool timertrue=false;//没订单时减少运行 节省系统性能
int huaxiankaicanggeshuR1=huaxiankaicanggeshuR;//
int huaxiankaicanggeshu1=huaxiankaicanggeshu;//延迟
int huaxiankaicanggeshuT1=huaxiankaicanggeshuT;//延迟
int huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
int huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
int huaxiankaicangtimeP=huaxiankaicangtime;//传导
int huaxiankaicangtimeTP=huaxiankaicangtimeT;//传导
bool linesellkaicang=false;
bool linebuyfansuo=false;
bool linesellfansuo=false;
bool linebuypingcang=false;
bool linebuypingcangR=false;//ShiftR
bool linebuypingcangC=false;//定时器模式运行
bool linebuypingcangctrlR=false;//触及横线后距当前价多少设置止损 薅羊毛用
bool linesellpingcang=false;
bool linesellpingcangR=false;
bool linesellpingcangC=false;
bool linesellpingcangctrlR=false;//触及横线后距当前价多少设置止损 薅羊毛用
bool linebuyzidongjiacang=false;
bool linesellzidongjiacang=false;
bool lineTime=false;
bool linefirsttime=true;
bool linekaicangT=false;//L+K 开仓标记 Tab 增加开仓次数和间隔时间开仓
bool dingshipingcang=false;//五分钟收线定时平仓
bool dingshipingcang15=false;//十五分钟收线定时平仓
bool linebuypingcangonly=false;//L+P时 提前B/S只平一边
bool linesellpingcangonly=false;//L+P时 提前B/S只平一边

int linetime;
int xunhuanMagic=0;//根据Magic循环平仓用

bool linelock=false;
int shangpress=0;//统计方向键上键按下的次数
int xiapress=0;//统计方向键下键按下的次数
int leftpress=0;//统计方向键上键按下的次数
int rightpress=0;//统计方向键下键按下的次数
int tickjishu=4;
bool tickbuyclose=false;
int dingdanshu=100;//主键盘0-9按下数字 处理最近的几单
int dingdanshu1=100;//主键盘0-9按下数字 处理最近的几单 N D 加小键盘数字使用
int dingdanshu2=100;//主键盘0-9按下数字 处理最近的几单
int dingdanshu3=100;//主键盘0-9按下数字 处理最近的几单
int dingdanshu4=100;//主键盘0-9按下数字 处理最近的几单
int pingcangdingdanshu=1000;//主键盘0-9按下数字 处理最近的几单
int guadangeshu=huaxianguadangeshu;//小键盘1 2 3 挂单个数
double tick4,tick3,tick2,tick1,tick0;
int buydangeshu=0;
int selldangeshu=0;
int timesecondstrue;
int xiaoshudian=2;//分批平仓 每次仓位保留到几位小数点
double keylotshalfT;
double keylotshalf;

double timeseconds1=timeseconds1P;//
int holdingtime=holdingtimemin;
//bool juxianjiadingshi03=false;
datetime expiration=TimeCurrent()+expirationM*60;
datetime timeGMT1=D'1970.01.01 00:00:00';
datetime timeGMT2=D'1970.01.01 00:00:00';
datetime timeGMT3=D'1970.01.01 00:00:00';
datetime timeGMT4=D'1970.01.01 00:00:00';
datetime timeGMT5=D'1970.01.01 00:00:00';
datetime timeGMT6=D'1970.01.01 00:00:00';
double OriginalLot;
string reminder06="=== 批量修改止盈止损点数或直接输入价位 ===";//默认以常用的点数为基准  临时弃用 隐藏参数
int StopLoss=0; // 止损点数设置 全为0时取消止盈止损
int TargetProfit=0; // 止盈点数设置 点数和价位可以混合使用
double FixedStopLoss=0.0; //或直接输入止损价位 价位优先 下次用时记得清零
double FixedTargetProfit=0.0; //或直接输入止盈价位 单独使用其中的一项不影响之前的设定

double diancha;
double pianyilingGlo;
double stoplevel=MarketInfo(Symbol(),MODE_STOPLEVEL);//当前货币的
double minlot=MarketInfo(Symbol(),MODE_MINLOT);//当前货币的最小下单量
string Exness="Exness Ltd.";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(linebuypingcangctrlRpianyi<stoplevel)
     {
      linebuypingcangctrlRpianyi=stoplevel+1;
     }
   if(IsDemo())
     {
      SL5QTPpingcang=20;  //测试用
     }
   if(MarketInfo(Symbol(),MODE_LOTSTEP)==0.1)
     {
      xiaoshudian=1;
     }
   if(ObjectFind(0,"Buy Line")==0)
      ObjectDelete(0,"Buy Line");
   if(ObjectFind(0,"Sell Line")==0)
      ObjectDelete(0,"Sell Line");
   if(ObjectFind(0,"SL1mbuyLine")==0)
      ObjectDelete(0,"SL1mbuyLine");
   if(ObjectFind(0,"SL5mbuyLine")==0)
      ObjectDelete(0,"SL5mbuyLine");
   if(ObjectFind(0,"SL15mbuyLine")==0)
      ObjectDelete(0,"SL15mbuyLine");
   if(ObjectFind(0,"SL1msellLine")==0)
      ObjectDelete(0,"SL1msellLine");
   if(ObjectFind(0,"SL5msellLine")==0)
      ObjectDelete(0,"SL5msellLine");
   if(ObjectFind(0,"SL15msellLine")==0)
      ObjectDelete(0,"SL15msellLine");
   if(ObjectFind(0,"SLsellQpengcangline")==0)
      ObjectDelete(0,"SLsellQpengcangline");
   if(ObjectFind(0,"SLbuyQpengcangline")==0)
      ObjectDelete(0,"SLbuyQpengcangline");
   if(ObjectFind(0,"SLsellQpengcangline1")==0)
      ObjectDelete(0,"SLsellQpengcangline1");
   if(ObjectFind(0,"SLbuyQpengcangline1")==0)
      ObjectDelete(0,"SLbuyQpengcangline1");
   if(ObjectFind(0,"iBSTrend")==0)
      ObjectDelete(0,"iBSTrend");
   if(ObjectFind(0,"MBFX")==0)
      ObjectDelete(0,"MBFX");

   EventSetTimer(SetTimer);//定时器 初始化
   if(gloxianshijunjiantrue)//
     {
      if(gloxianshijunjian)
        {
         GlobalVariableSet("gloxianshijunjian",1);
         Print("图表订单信息是否显示均价 显示 请重新加载EA或把对应的开关改为false");
         Alert("图表订单信息是否显示均价 显示 请重新加载EA或把对应的开关改为false");
        }
      else
        {
         GlobalVariableSet("gloxianshijunjian",0);
         Print("图表订单信息是否显示均价 不显示 请重新加载EA或把对应的开关改为false");
         Alert("图表订单信息是否显示均价 不显示 请重新加载EA或把对应的开关改为false");
        }
     }
   else
     {
      if(GlobalVariableCheck("gloxianshijunjian"))
        {
         if(GlobalVariableGet("gloxianshijunjian")==0)
           {
            gloxianshijunjian=false;
           }
         else
           {
            gloxianshijunjian=true;
           }
        }
      else
        {
         GlobalVariableSet("gloxianshijunjian",0);
        }
     }
   if(glotickclosenumtrue)
     {
      string num="glotickclosenum"+Symbol();

      GlobalVariableSet(num,glotickclosenum);
      Print("Tick变化剧烈时自动平仓预设值已更新 请重新加载EA或把对应的开关改为false");
      Alert("Tick变化剧烈时自动平仓预设值已更新 请重新加载EA或把对应的开关改为false");
     }
   else
     {
      string num="glotickclosenum"+Symbol();
      if(GlobalVariableCheck(num))
        {
         glotickclosenum=GlobalVariableGet(num);
        }
      else
        {
         GlobalVariableSet(num,glotickclosenum);
        }
     }
   if(glomaxTotallotsture)
     {
      GlobalVariableSet("glomaxTotallots",glomaxTotallots);
      Print("全局单向最多下单手数限制已更新 请重新加载EA或把对应的开关改为false");
      Alert("全局单向最多下单总手数限制已更新 请重新加载EA或把对应的开关改为false");
     }
   else
     {
      if(GlobalVariableCheck("glomaxTotallots"))
         Print("全局单向最多下单总手数限制启用 当前最大可下",GlobalVariableGet("glomaxTotallots"),"手");
      else
         GlobalVariableSet("glomaxTotallots",glomaxTotallots);
     }
   if(glojianjuture)//设置间距的全局函数
     {
      GlobalVariableSet("glojianjusl",glojianjusl);
      GlobalVariableSet("glojianjutp",glojianjutp);
      GlobalVariableSet("glojianjuguadan",glojianjuguadan);
      if(GlobalVariableCheck("glojianjusl"))
         Print("全局的间距函数设置成功");
      if(glojianju)
        {
         GlobalVariableSet("glojianju",1);
         Print("全局间距已启用 请重新加载EA或把对应的开关改为false");
         Alert("全局间距已启用 请重新加载EA或把对应的开关改为false");
        }
      else
        {
         GlobalVariableDel("glojianju");
         Print("全局间距已关闭 请重新加载EA或把对应的开关改为false");
         Alert("全局间距已关闭 请重新加载EA或把对应的开关改为false");
        }
     }
   if(GlobalVariableCheck("glojianju") && GlobalVariableCheck("glojianjusl"))//判断全局间距设置并执行
     {
      int sl=StrToInteger(DoubleToStr(GlobalVariableGet("glojianjusl"),0));
      int tp=StrToInteger(DoubleToStr(GlobalVariableGet("glojianjutp"),0));
      int gd=StrToInteger(DoubleToStr(GlobalVariableGet("glojianjuguadan"),0));
      jianju07=sl;
      jianju07tp=tp;
      jianju10=sl;
      jianju10tp=tp;
      piliangtpjianju=tp;
      piliangsljianju=sl;
      jianju03=sl;
      jianju04=tp;
      dingshijianju05=sl;
      dingshijianju06=tp;
      zhinengSLTPjianju=tp;
      jianju05=tp;
      Guadanjianju=gd;
      Guadanjianju1=gd;
      zhinengguadanjianju=gd;
      fibGuadanjianju=gd;
      tenGuadanjianju=gd;
      tensltpjianju=tp;
      huaxianguadanjianju=gd;
      Print("全局间距已启用 已修改间距为您的设定值 全局止损间距 ",sl," 全局止盈间距 ",tp," 全局挂单间距 ",gd," 如参数不对 请重新更新全局间距后加载");
     }
   if(globalVariablesDeleteAll)//初始化客户端全局函数设置
     {
      int Num=GlobalVariablesDeleteAll(NULL,0);
      if(Num>0)
        {
         Alert("删除全部的客户端全局函数成功 请重新加载EA");
         Print("删除全部的客户端全局函数成功 请重新加载EA");
        }
     }
   if(gloGraduallytrue)
     {
      if(Gradually)
        {
         GlobalVariableDel("gloGraduallyfalse");
         Print("分步平仓模式已启用 请重新加载EA或把对应的开关改为false");
         Alert("分步平仓模式已启用 请重新加载EA或把对应的开关改为false");
        }
      else
        {
         GlobalVariableSet("gloGraduallyfalse",1);
         Print("分步平仓模式已关闭 请重新加载EA或把对应的开关改为false");
         Alert("分步平仓模式已关闭 请重新加载EA或把对应的开关改为false");
        }
     }
   if(GlobalVariableCheck("gloGraduallyfalse"))
     {
      Gradually=false;
      Print("分步平仓模式已关闭");
     }
   else
     {
      Gradually=true;
     }

   if(gloTickmodetrue)
     {
      if(Tickmode)
        {
         GlobalVariableSet("gloTickmodetrue",1);
         Print("Tick分步平仓模式已启用 请重新加载EA或把对应的开关改为false");
         Alert("Tick分步平仓模式已启用 请重新加载EA或把对应的开关改为false");
        }
      else
        {
         GlobalVariableDel("gloTickmodetrue");
         Print("计时器分步平仓模式已启用 请重新加载EA或把对应的开关改为false");
         Alert("计时器分步平仓模式已启用 请重新加载EA或把对应的开关改为false");
        }
     }
   if(glo5Digitsture)
     {
      GlobalVariableSet("glo5tp",glo5TP);
      GlobalVariableSet("glo5sl",glo5SL);
      GlobalVariableSet("glo5movesl",glo5moveSL);
      Alert("五位小数点时自动止盈止损参数已更新 请重新加载EA或把对应的开关改为false");
      Print("五位小数点时自动止盈止损参数已更新 请重新加载EA或把对应的开关改为false");
     }
   else
     {
      if(!GlobalVariableCheck("glo5tp"))
        {
         GlobalVariableSet("glo5tp",glo5TP);
         GlobalVariableSet("glo5sl",glo5SL);
         GlobalVariableSet("glo5movesl",glo5moveSL);
         Print("五位小数点时EA止盈止损初始化完成");
        }
     }
   if(glo3Digitsture)
     {
      GlobalVariableSet("glo3tp",glo3TP);
      GlobalVariableSet("glo3sl",glo3SL);
      GlobalVariableSet("glo3movesl",glo3moveSL);
      Alert("三位小数点时自动止盈止损参数已更新 请重新加载EA或把对应的开关改为false");
      Print("三位小数点时自动止盈止损参数已更新 请重新加载EA或把对应的开关改为false");
     }
   else
     {
      if(!GlobalVariableCheck("glo3tp"))
        {
         GlobalVariableSet("glo3tp",glo3TP);
         GlobalVariableSet("glo3sl",glo3SL);
         GlobalVariableSet("glo3movesl",glo3moveSL);
         Print("三位小数点时EA止盈止损初始化完成");
        }
     }
   if(glo2Digitsture)
     {
      GlobalVariableSet("glo2tp",glo2TP);
      GlobalVariableSet("glo2sl",glo2SL);
      GlobalVariableSet("glo2movesl",glo2moveSL);
      Alert("两位小数点时自动止盈止损参数已更新 请重新加载EA或把对应的开关改为false");
      Print("两位小数点时自动止盈止损参数已更新 请重新加载EA或把对应的开关改为false");
     }
   else
     {
      if(!GlobalVariableCheck("glo2tp"))
        {
         GlobalVariableSet("glo2tp",glo2TP);
         GlobalVariableSet("glo2sl",glo2SL);
         GlobalVariableSet("glo2movesl",glo2moveSL);
         Print("两位小数点时EA止盈止损初始化完成");
        }
     }
   if(Digits==5 && GlobalVariableCheck("glo5tp"))
     {
      stoploss=GlobalVariableGet("glo5sl");
      takeprofit=GlobalVariableGet("glo5tp");
      TrailingStop=GlobalVariableGet("glo5movesl");
     }
   if(Digits==3 && GlobalVariableCheck("glo3tp"))
     {
      if(Bid<800)
        {
         stoploss=GlobalVariableGet("glo3sl");
         takeprofit=GlobalVariableGet("glo3tp");
         TrailingStop=GlobalVariableGet("glo3movesl");//不是黄金相关的货币对
        }
      else
        {
         stoploss=GlobalVariableGet("glo3sl")*10;
         takeprofit=GlobalVariableGet("glo3tp")*10;
         TrailingStop=GlobalVariableGet("glo3movesl")*10;//是黄金相关的货币对止盈止损放大10倍
         linepianyi=linepianyi*10;//横线偏移放大10倍
         Print("3位小数点 是黄金相关的货币对止盈止损放大10倍");
        }
     }
   if(Digits==2 && GlobalVariableCheck("glo2tp"))
     {
      stoploss=GlobalVariableGet("glo2sl");
      takeprofit=GlobalVariableGet("glo2tp");
      TrailingStop=GlobalVariableGet("glo2movesl");
     }
   if(GlobalVariableCheck("gloTickmodetrue"))
     {
      if(Gradually)
        {
         Tickmode=true;
         Print("Tick分步平仓模式启用");
        }
      else
        {
         Print("Tick分步平仓模式关闭");
        }
     }
   else
     {
      if(Gradually)
        {
         Tickmode=false;
         Print("计时器分步平仓模式启用 ","每次平仓的仓位保留到 ",xiaoshudian," 位小数点");
        }
      else
        {
         Print("计时器分步平仓模式 关闭");
        }
     }
   if(glolotsture)
     {
      GlobalVariableSet("glodefaultlots",defaultlots);
      Print("默认下单手数更新成功");
      Alert("默认下单手数更新成功 当前为",GlobalVariableGet("glodefaultlots"),"手 请重新加载EA或把对应的开关改为false");
      if(ObjectFind("firstPS")!=-1)
         ObjectDelete("firstPS");
     }
   if(MarketInfo(Symbol(),MODE_TRADEALLOWED)==0)
      Print(Symbol()," 当前品种不允许交易");
   Print("EA默认可以直接带止损下单，如果无法下单请在 全局设置 里修改");
   /* //FXTM现在已经支持带止损下单了
     string ForexTime="ForexTime";
     if(ForexTime==StringSubstr(AccountServer(),0,9))
       {
        if(!GlobalVariableCheck("ForexTime"))
          {
           GlobalVariableSet(StringSubstr(AccountServer(),0,9),1);
           testtradeSLSP=false;
           Print("根据外汇服务器类型 EA已修改为不能直接带止损下单");
          }
        else
          {
           testtradeSLSP=false;
           Print("根据外汇服务器类型 EA已修改为不能直接带止损下单");
          }
       }
       */
   if(defaultlotstrue)
     {
      if(GlobalVariableCheck("glodefaultlots"))
        {
         defaultlots=GlobalVariableGet("glodefaultlots");
        }
      else
        {
         Alert("中更新适合您的基本下单手数 默认0.1手 此消息只提示一次");
         Alert("检测到您是第一次加载MT4持仓助手 请在 客户端全局函数设置");
         Print("检测到您是第一次加载MT4持仓助手 请在 客户端全局函数设置 中更新适合您的基本下单手数 默认0.1手 此消息只提示一次");
         if(ObjectFind("firstPS")!=-1)
            ObjectDelete("firstPS");
           {
            ObjectCreate(0,"firstPS",OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,"firstPS",OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetInteger(0,"firstPS",OBJPROP_XDISTANCE,dingdanxianshiX);
            ObjectSetInteger(0,"firstPS",OBJPROP_YDISTANCE,dingdanxianshiY+160);
            ObjectSetText("firstPS","请按F7 客户端全局函数设置 中更新适合您的基本下单手数默认0.1手 ",18,"黑体",dingdanxianshicolor);
           }
         GlobalVariableSet("glodefaultlots",0.1);
         defaultlots=GlobalVariableGet("glodefaultlots");
        }
      //Print("glodefaultlots ",GlobalVariableCheck("glodefaultlots"));
      keylots=defaultlots;
      Guadanlots=defaultlots;
      Guadanlots1=defaultlots;
      zhinengguadanlots=defaultlots;
      fibGuadanlots=defaultlots;
      tenGuadanlots=defaultlots;
      huaxianguadanlots=defaultlots;
      huaxiankaicanglotsT=defaultlots;
      //Print("keylots= ",keylots);
      Print("当前EA通过键盘快捷键下单的基本仓位是 ",defaultlots," 手 请 客户端全局函数设置 中更新为适合自己的仓位下单");
     }
   else
     {
      Print("当前EA通过键盘快捷键下单的基本仓位是 ",keylots," 手 请修改为适合自己的仓位下单");
     }
   Print("当前货币 停止水平位: ",StrToInteger(DoubleToStr(stoplevel,0)),"，账户杠杆比例: ",AccountLeverage(),":1","，买一手保证金 ",MarketInfo(Symbol(),MODE_MARGINREQUIRED),AccountCurrency(),", 多单隔夜利息: ",MarketInfo(Symbol(),MODE_SWAPLONG),",空单隔夜利息: ",MarketInfo(Symbol(),MODE_SWAPSHORT),swaptype());

   int level=AccountStopoutLevel();
   if(AccountStopoutMode()==0)
     {
      Print("强行平仓止损水平= ",level,"% ,",Digits(),"位小数点"",一手波动一个基点盈亏 ",DoubleToString(MarketInfo(Symbol(),MODE_TICKVALUE),2),AccountCurrency()," 最小下单手数",MarketInfo(Symbol(),MODE_MINLOT),"  EAswitch= ",EAswitch);
     }
   else
     {
      Print("强行平仓止损水平= ",level," ",AccountCurrency());
     }
   keylotshalfT=MathFloor(keylots*0.5/MarketInfo(Symbol(),MODE_LOTSTEP))*MarketInfo(Symbol(),MODE_LOTSTEP);
   keylotshalf=keylots;
   if(Guadanprice<stoplevel)
      Guadanprice=StrToInteger(DoubleToStr(stoplevel,0))+2;
   if(Guadanjuxianjia<stoplevel)
      Guadanjuxianjia=StrToInteger(DoubleToStr(stoplevel,0))+2;
   if(Guadanjuxianjia1<stoplevel)
      Guadanjuxianjia1=StrToInteger(DoubleToStr(stoplevel,0))+2;
   if(zhinengSLTP1<stoplevel)
      zhinengSLTP1=stoplevel+2;
   if(minlot>defaultlots)
      Alert("EA默认下单手数小于当前货币最小下单手数 可能无法下单 请修改");
   if(EAswitch)
     {
      Print("当前图表",Digits,"位小数点"," EA自动设置止盈",takeprofit,"点 ","止损",stoploss,"点 ","移动止损",TrailingStop,"点");
      comment(StringFormat("%G位小数点 止盈%G点 止损%G点 移动止损%G点 默认下单仓位%G手",Digits,takeprofit,stoploss,TrailingStop,defaultlots));
      /*if(Digits==3 || Digits==2)
        {
         Gradually=false;
         Print("分步平仓模式已关闭");
         comment1(StringFormat("%G位小数点 分步平仓没调试好 暂时关闭",Digits));
        }*/
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
// ObjectsDeleteAll();
   if(ObjectFind(0,"buy")==0)
      ObjectDelete(0,"buy");
   if(ObjectFind(0,"sell")==0)
      ObjectDelete(0,"sell");
   if(ObjectFind(0,"buysell")==0)
      ObjectDelete(0,"buysell");
   if(ObjectFind(0,"AccountEquity")==0)
      ObjectDelete(0,"AccountEquity");
   if(ObjectFind(0,"AccountFreeMargin")==0)
      ObjectDelete(0,"AccountFreeMargin");
   if(ObjectFind(0,"zi")==0)
      ObjectDelete(0,"zi");
   if(ObjectFind(0,"zi1")==0)
      ObjectDelete(0,"zi1");
   if(ObjectFind(0,"botoupi")==0)
      ObjectDelete(0,"botoupi");
   if(ObjectFind(0,"firstPS")==0)
      ObjectDelete(0,"firstPS");
   if(ObjectFind(0,"Buy Line")==0)
      ObjectDelete(0,"Buy Line");
   if(ObjectFind(0,"Sell Line")==0)
      ObjectDelete(0,"Sell Line");
   if(ObjectFind(0,"SL Line")==0)
      ObjectDelete(0,"SL Line");
   if(ObjectFind(TPObjName)>=0)
      ObjectDelete(TPObjName);//反初始化。删除线
   if(ObjectFind(SLObjName)>=0)
      ObjectDelete(SLObjName);
   if(ObjectFind(TP_PRICE_LINE)>=0)
      ObjectDelete(TP_PRICE_LINE);
   if(ObjectFind(SL_PRICE_LINE)>=0)
      ObjectDelete(SL_PRICE_LINE);
   if(ObjectFind(0,"SL1mbuyLine")==0)
      ObjectDelete(0,"SL1mbuyLine");
   if(ObjectFind(0,"SL5mbuyLine")==0)
      ObjectDelete(0,"SL5mbuyLine");
   if(ObjectFind(0,"SL15mbuyLine")==0)
      ObjectDelete(0,"SL15mbuyLine");
   if(ObjectFind(0,"SL1msellLine")==0)
      ObjectDelete(0,"SL1msellLine");
   if(ObjectFind(0,"SL5msellLine")==0)
      ObjectDelete(0,"SL5msellLine");
   if(ObjectFind(0,"SL15msellLine")==0)
      ObjectDelete(0,"SL15msellLine");
   if(ObjectFind(0,"SLsellQpengcangline")==0)
      ObjectDelete(0,"SLsellQpengcangline");
   if(ObjectFind(0,"SLbuyQpengcangline")==0)
      ObjectDelete(0,"SLbuyQpengcangline");
   if(ObjectFind(0,"SLsellQpengcangline1")==0)
      ObjectDelete(0,"SLsellQpengcangline1");
   if(ObjectFind(0,"SLbuyQpengcangline1")==0)
      ObjectDelete(0,"SLbuyQpengcangline1");
   if(ObjectFind(0,"iBSTrend")==0)
      ObjectDelete(0,"iBSTrend");
   if(ObjectFind(0,"MBFX")==0)
      ObjectDelete(0,"MBFX");
   Comment("");
   EventKillTimer();
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_KEYDOWN && keycode)//检测键盘动作，触发指令
     {
      if(StrToInteger(sparam)==29 || StrToInteger(sparam)==16413)
        {
         ctrl=true;
         ctrltimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==285|| StrToInteger(sparam)==16669)
        {
         ctrlR=true;
         ctrlRtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==42 || StrToInteger(sparam)==16426)
        {
         shift=true;
         shifttimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==310 || StrToInteger(sparam)==16694)
        {
         shiftR=true;
         shiftRtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==15 || StrToInteger(sparam)==16399)
        {
         tab=true;
         tabtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==48 || StrToInteger(sparam)==16432)
        {
         bkey=true;
         btimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==31 || StrToInteger(sparam)==16415)
        {
         skey=true;
         stimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==25 || StrToInteger(sparam)==16409)
        {
         pkey=true;
         ptimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==38 || StrToInteger(sparam)==16422)
        {
         lkey=true;
         ltimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==20 || StrToInteger(sparam)==16404)
        {
         tkey=true;
         ttimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==30 || StrToInteger(sparam)==16414)
        {
         akey=true;
         atimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==44 || StrToInteger(sparam)==16428)
        {
         zkey=true;
         ztimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==34 || StrToInteger(sparam)==16418)
        {
         gkey=true;
         gtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==24 || StrToInteger(sparam)==16408)
        {
         okey=true;
         otimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==37 || StrToInteger(sparam)==16421)
        {
         kkey=true;
         ktimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==47 || StrToInteger(sparam)==16431)
        {
         vkey=true;
         vtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==33 || StrToInteger(sparam)==16417)
        {
         fkey=true;
         ftimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==32 || StrToInteger(sparam)==16416)
        {
         dkey=true;
         dtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==50 || StrToInteger(sparam)==16434)
        {
         mkey=true;
         mtimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==49 || StrToInteger(sparam)==16433)
        {
         nkey=true;
         ntimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==23 || StrToInteger(sparam)==16407)
        {
         ikey=true;
         itimeCurrent=TimeCurrent();
        }
      if(StrToInteger(sparam)==41 || StrToInteger(sparam)==16425)//Test
        {
         // PiliangTP(true,NormalizeDouble(buyline+linebuypingcangctrlRRpianyi*Point,Digits),0,0,0,dingdanshu);
         //PiliangTP(false,NormalizeDouble(buyline-linebuypingcangctrlRRpianyi*Point,Digits),0,0,0,dingdanshu);
         Print("dingdanshu,2,3,4= ",dingdanshu,dingdanshu2,dingdanshu3,dingdanshu4);
         Print("自动分批平仓= ",Gradually);
         Print("EA开关= ",EAswitch);
         Print("fansuoYes= ",fansuoYes);
         nakey=true;
         natimeCurrent=TimeCurrent();
         //Print("测试专用");
         Print("MODE_SPREAD ",MarketInfo(Symbol(),MODE_SPREAD));
         Print("MODE_LOTSTEP ",MarketInfo(Symbol(),MODE_LOTSTEP));
         Print("MODE_MINLOT ",MarketInfo(Symbol(),MODE_MINLOT));
         Print("Ask ",MarketInfo(Symbol(),MODE_ASK));
         Print("Bid ",MarketInfo(Symbol(),MODE_BID));
         Print("GetLastError=",GetLastError());
         shifttimeCurrent=D'1970.01.01 00:00:00';//清除Shift按键时间
         SL5QTPtimeCurrenttrue=false;//剥头皮定时处理订单关闭
         Print("剥头皮定时处理订单关闭");
         comment("剥头皮定时处理订单关闭");
         Print("多单均价= ",HoldingOrderbuyAvgPrice());
         Print("空单均价= ",HoldingOrdersellAvgPrice());
         Print("linelock= ",linelock);
         //  Print("0.0=",MathRound(0.0));
         // double bid=StrToDouble(DoubleToString(1.2498,3));

         //double bid1=NormalizeDouble(bid,3);
         // Print("bid",bid," Digits",Digits);
         //Tenguadan(false,3,30);
         //Fibguadan(0,1.2400,1.2500);
         //Fibguadan(1,1.25000,1.26000);
        }
      if(StrToInteger(sparam)==70)
        {
         Print("平最近下的一单 处理中 . . .");
         comment("平最近下的一单 处理中 . . .");
         zuijinkeyclose();
        }
      if(Testsparam)
         Print(" sparam的值 ",sparam," lparam的值 ",lparam," dparam的 值",dparam);//测试键盘按钮状态的位掩码的字符串值,方便自定义快捷键，组合键Ctrl+Alt+字母或数字也有自己的sparam的值，所以也可以使用。
      int Sparam=StrToInteger(sparam);
      switch(Sparam)
        {
         case 8219://开启笔记本下单按键 Ctrl+Alt+ } 开启
           {
            if(notebook)
              {
               notebook=false;
               Print("笔记本下单按键关闭");
               comment("笔记本下单按键关闭");
              }
            else
              {
               notebook=true;
               Print("笔记本下单按键开启buy或sell是P或L键右边第二个键");
               comment("笔记本下单按键开启buy或sell是P或L键右边第二个键");
              }
           }
         break;
         case 27:
           {
            if(notebook)
              {
               Print("市价买一单 处理中 . . .");
               comment("市价买一单 处理中 . . .");
               int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
               if(keybuy>0)
                  PlaySound("ok.wav");
               else
                 {
                  PlaySound("timeout.wav");
                  Print("Error=",GetLastError());
                 }
              }
            else
              {
               Print("笔记本下单按键未开启 Ctrl+Alt+ } 开启");
               comment("笔记本下单按键未开启 Ctrl+Alt+ } 开启");
              }
           }
         break;
         case 40:
           {
            if(notebook)
              {
               Print("市价卖一单 处理中 . . .");
               comment("市价卖一单 处理中 . . .");
               int keysell=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
               if(keysell>0)
                  PlaySound("ok.wav");
               else
                 {
                  PlaySound("timeout.wav");
                  Print("Error=",GetLastError());
                 }
              }
            else
              {
               Print("笔记本下单按键未开启 Ctrl+Alt+ } 开启");
               comment("笔记本下单按键未开启 Ctrl+Alt+ } 开启");
              }
           }
         break;
         case 328://方向键 上键
           {
            if(shangtimeGMT+10>=TimeGMT())
              {
               shangpress++;
               Print("方向键 上键按下次数+1 当前方向键 上键按下次数",shangpress);
               comment(StringFormat("方向键上键 按下次数+1 当前按下次数%G ",shangpress));
              }
            else
              {
               shangpress=1;
               Print("计时器10秒已过 方向键上键计数重置 当前方向键 上键按下次数",shangpress);
               comment(StringFormat("计时器10秒已过 方向键上键计数重置 当前按下次数%G ",shangpress));
              }
            shangtimeGMT=TimeGMT();
           }
         break;
         case 336://方向键 下键
           {
            if(xiatimeGMT+10>=TimeGMT())
              {
               xiapress++;
               Print("方向键 下键按下次数+1 当前方向键 下键按下次数",xiapress);
               comment(StringFormat("方向键下键 按下次数+1 当前按下次数%G ",xiapress));
              }
            else
              {
               xiapress=1;
               Print("计时器10秒已过 方向键下键计数重置 当前方向键 下键按下次数",xiapress);
               comment(StringFormat("计时器10秒已过 方向键下键计数重置 当前按下次数%G ",xiapress));
              }
            xiatimeGMT=TimeGMT();
           }
         break;
         case 331://方向键 左键
           {
            if(shangtimeGMT+10>=TimeGMT())
              {
               leftpress++;
               Print("方向键 左键按下次数+1 当前方向键 左键按下次数",leftpress);
               comment(StringFormat("方向键左键《== 按下次数+1 当前按下次数%G ",leftpress));
              }
            else
              {
               leftpress=1;
               Print("计时器10秒已过 方向键左键计数重置 当前方向键 左键按下次数",leftpress);
               comment(StringFormat("计时器10秒已过 方向键左键计数重置 当前按下次数%G ",leftpress));
              }
            shangtimeGMT=TimeGMT();
           }
         break;
         case 333://方向键 右键
           {
            if(xiatimeGMT+10>=TimeGMT())
              {
               rightpress++;
               Print("方向键 右键按下次数+1 当前方向键 右键按下次数",rightpress);
               comment(StringFormat("方向键右键 ==》 按下次数+1 当前按下次数%G ",rightpress));
              }
            else
              {
               rightpress=1;
               Print("计时器10秒已过 方向键右键计数重置 当前方向键 下键按下次数",rightpress);
               comment(StringFormat("计时器10秒已过 方向键右键计数重置 当前按下次数%G ",rightpress));
              }
            xiatimeGMT=TimeGMT();
           }
         break;
         case 2://主键盘1 1111
           {
            if(itimeCurrent+1>=TimeCurrent())
              {
               if(imbfxT==false)
                 {
                  imbfxT=true;
                  Print("当前图表参考MBFX指标 自动平仓 开启");
                  comment1("当前图表参考MBFX指标 自动平仓 开启");
                  return;
                 }
               else
                 {
                  imbfxT=false;
                  Print("当前图表参考MBFX指标 自动平仓 关闭");
                  comment1("当前图表参考MBFX指标 自动平仓 关闭");
                  return;
                 }
              }
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(huaxianguadan)
                 {
                  huaxianguadan=false;
                  if(ObjectFind(TPObjName)>=0)
                     ObjectDelete(TPObjName);
                  if(ObjectFind(SLObjName)>=0)
                     ObjectDelete(SLObjName);
                  if(ObjectFind(TP_PRICE_LINE)>=0)
                     ObjectDelete(TP_PRICE_LINE);
                  if(ObjectFind(SL_PRICE_LINE)>=0)
                     ObjectDelete(SL_PRICE_LINE);
                  Print("划线挂单模式关闭");
                  comment1("划线挂单模式关闭");
                 }
               else
                 {
                  huaxianguadan=true;
                  huaxianSwitch=false;
                  huaxiankaicang=false;
                  Print("触及划线挂单模式开启需要至少一个订单指引挂单方向");
                  comment1("触及划线挂单模式开启需要至少一个订单指引挂单方向");
                 }
               tab=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(10*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(10*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(10*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(10*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=1;
            dingdanshu1=1;
            dingdanshu2=1;
            dingdanshu3=1;
            dingdanshu4=1;
            guadangeshu=1;
            comment("主键盘数字键1 只处理最近下的一单 本提示消失按键失效");
           }
         break;
         case 3://主键盘2
           {
            if(itimeCurrent+1>=TimeCurrent())
              {
               if(iBSTrend==false)
                 {
                  iBSTrend=true;
                  Print("当前图表参考BSTrend指标 自动平仓 开启");
                  comment1("当前图表参考BSTrend指标 自动平仓 开启");
                  return;
                 }
               else
                 {
                  iBSTrend=false;
                  Print("当前图表参考BSTrend指标 自动平仓 关闭");
                  comment1("当前图表参考BSTrend指标 自动平仓 关闭");
                  return;
                 }
              }
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(huaxiankaicang)
                 {
                  huaxiankaicang=false;
                  if(ObjectFind(TPObjName)>=0)
                     ObjectDelete(TPObjName);
                  if(ObjectFind(SLObjName)>=0)
                     ObjectDelete(SLObjName);
                  if(ObjectFind(TP_PRICE_LINE)>=0)
                     ObjectDelete(TP_PRICE_LINE);
                  if(ObjectFind(SL_PRICE_LINE)>=0)
                     ObjectDelete(SL_PRICE_LINE);
                  Print("触及划线直接开仓模式关闭");
                  comment1("触及划线直接开仓模式关闭");
                 }
               else
                 {
                  huaxiankaicang=true;
                  huaxianSwitch=false;
                  huaxianguadan=false;
                  Print("触及划线直接开仓模式开启 需要至少一个订单指引开仓方向");
                  comment1("触及划线直接开仓模式开启 需要至少一个订单指引开仓方向");
                 }
               tab=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(20*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(20*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(20*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(20*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=2;
            dingdanshu1=2;
            dingdanshu2=2;
            dingdanshu3=2;
            dingdanshu4=2;
            guadangeshu=2;
            comment("主键盘数字键 2 只处理最近下的两单 本提示消失按键失效");
           }
         break;
         case 4://主键盘3
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(!timeGMTYesNo3)
                 {
                  if(tkey)
                    {
                     timeGMTYesNo3=true;
                     buytrue03=true;
                     Print("定时器3开启 定时批量智能移动止损位 只处理buy单");
                     comment1("定时器3开启 定时批量智能移动止损位 只处理buy单");
                     tkey=false;
                    }
                  else
                    {
                     if(fkey)
                       {
                        timeGMTYesNo3=true;
                        buytrue03=false;
                        Print("定时器3开启 定时批量智能移动止损位 只处理sell单");
                        comment1("定时器3开启 定时批量智能移动止损位 只处理sell单");
                        fkey=false;
                       }
                     else
                       {
                        Print("未检测到按下T或F键 定时器3需要在按Tab键前先选择处理的订单类型 buy单按T sell单按F");
                        comment1("定时器3按Tab键前先选择订单类型buy单按T sell单按F");
                       }
                    }
                 }
               else
                 {
                  timeGMTYesNo3=false;
                  buytrue03=true;
                  timebuyprice=0.0;
                  timesellprice=10000.0;
                  Print("定时器3关闭");
                  comment1("定时器3关闭");
                 }
               tab=false;
               tkey=false;
               fkey=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(30*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(30*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(30*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(30*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=3;
            dingdanshu1=3;
            dingdanshu2=3;
            dingdanshu3=3;
            dingdanshu4=3;
            guadangeshu=3;
            comment("主键盘数字键 3 只处理最近下的三单 本提示消失按键失效");
           }
         break;
         case 5://主键盘4
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(!timeGMTYesNo4)
                 {
                  if(tkey)
                    {
                     timeGMTYesNo4=true;
                     buytrue04=true;
                     Print("定时器4开启 定时批量智能移动止盈位 只处理buy单");
                     comment1("定时器4开启 定时批量智能移动止盈位 只处理buy单");
                     tkey=false;
                    }
                  else
                    {
                     if(fkey)
                       {
                        timeGMTYesNo4=true;
                        buytrue04=false;
                        Print("定时器4开启 定时批量智能移动止盈位 只处理sell单");
                        comment1("定时器4开启 定时批量智能移动止盈位 只处理sell单");
                        fkey=false;
                       }
                     else
                       {
                        Print("未检测到按下T或F键 定时器6需要在按Tab键前先选择处理的订单类型 buy单按T sell单按F");
                        comment1("定时器4按Tab键前先选择订单类型buy单按T sell单按F");
                       }
                    }
                 }
               else
                 {
                  timeGMTYesNo4=false;
                  buytrue04=true;
                  Print("定时器4关闭");
                  comment1("定时器4关闭");
                 }
               tab=false;
               tkey=false;
               fkey=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(40*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(40*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(40*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(40*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=4;
            dingdanshu1=4;
            dingdanshu2=4;
            dingdanshu3=4;
            dingdanshu4=4;
            guadangeshu=4;
            comment("主键盘数字键 4 本提示消失按键失效");
           }
         break;
         case 6://主键盘5
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(!timeGMTYesNo5)
                 {
                  if(tkey)
                    {
                     timeGMTYesNo5=true;
                     buytrue05=true;
                     Print("定时器5开启 定时批量智能移动止损位 只处理buy单");
                     comment1("定时器5开启 定时批量智能移动止损位 只处理buy单");
                     tkey=false;
                    }
                  else
                    {
                     if(fkey)
                       {
                        timeGMTYesNo5=true;
                        buytrue05=false;
                        Print("定时器5开启 定时批量智能移动止损位 只处理sell单");
                        comment1("定时器5开启 定时批量智能移动止损位 只处理sell单");
                        fkey=false;
                       }
                     else
                       {
                        Print("未检测到按下T或F键 定时器5需要在按Tab键前先选择处理的订单类型 buy单按T sell单按F");
                        comment1("定时器5按Tab键前先选择订单类型buy单按T sell单按F");
                       }
                    }
                 }
               else
                 {
                  timeGMTYesNo5=false;
                  buytrue05=true;
                  Print("定时器5关闭");
                  comment1("定时器5关闭");
                 }
               tab=false;
               tkey=false;
               fkey=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(50*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(50*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(50*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(50*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=5;
            dingdanshu1=5;
            dingdanshu2=5;
            dingdanshu3=5;
            dingdanshu4=5;
            guadangeshu=5;
            comment("主键盘数字键 5 本提示消失按键失效");
           }
         break;
         case 7://主键盘6
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(!timeGMTYesNo6)
                 {
                  if(tkey)
                    {
                     timeGMTYesNo6=true;
                     buytrue06=true;
                     Print("定时器6开启 定时批量智能移动止盈位 只处理buy单");
                     comment1("定时器6开启 定时批量智能移动止盈位 只处理buy单");
                     tkey=false;
                    }
                  else
                    {
                     if(fkey)
                       {
                        timeGMTYesNo6=true;
                        buytrue06=false;
                        Print("定时器6开启 定时批量智能移动止盈位 只处理sell单");
                        comment1("定时器6开启 定时批量智能移动止盈位 只处理sell单");
                        fkey=false;
                       }
                     else
                       {
                        Print("未检测到按下T或F键 定时器6需要在按Tab键前先选择处理的订单类型 buy单按T sell单按F");
                        comment1("定时器6按Tab键前先选择订单类型buy单按T sell单按F");
                       }
                    }
                 }
               else
                 {
                  timeGMTYesNo6=false;
                  buytrue06=true;
                  Print("定时器6关闭");
                  comment1("定时器6关闭");
                 }
               tab=false;
               tkey=false;
               fkey=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(60*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(60*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(60*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(60*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=6;
            dingdanshu1=6;
            dingdanshu2=6;
            dingdanshu3=6;
            dingdanshu4=6;
            guadangeshu=6;
            comment("主键盘数字键 6 本提示消失按键失效");
           }
         break;
         case 8://主键盘7
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(shiftR)
                 {
                  if(shift)
                    {
                     huaxianShift=true;
                     huaxianTimeSwitch=true;
                     huaxianguadan=false;
                     huaxiankaicang=false;
                     huaxianSwitch=false;
                     Print("划线反向锁仓定时器模式开启");
                     comment1("划线反向锁仓定时器模式开启");
                    }
                  else
                    {
                     if(ctrl)
                       {
                        huaxianCtrl=true;
                        huaxianTimeSwitch=true;
                        huaxianguadan=false;
                        huaxiankaicang=false;
                        huaxianSwitch=false;
                        Print("划线反向等量开仓变相锁仓定时器模式 开启");
                        comment1("划线反向等量开仓变相锁仓定时器模式 开启");
                       }
                     else
                       {
                        huaxianTimeSwitch=true;
                        huaxianguadan=false;
                        huaxiankaicang=false;
                        huaxianSwitch=false;
                        Print("划线平仓定时器模式开启");
                        comment1("划线平仓定时器模式开启");
                       }
                    }
                  shiftR=false;
                 }
               else
                 {
                  if(huaxianSwitch || huaxianTimeSwitch)
                    {
                     huaxianSwitch=false;
                     huaxianTimeSwitch=false;
                     huaxianShift=false;
                     huaxianCtrl=false;
                     if(ObjectFind(TPObjName)>=0)
                        ObjectDelete(TPObjName);
                     if(ObjectFind(SLObjName)>=0)
                        ObjectDelete(SLObjName);
                     if(ObjectFind(TP_PRICE_LINE)>=0)
                        ObjectDelete(TP_PRICE_LINE);
                     if(ObjectFind(SL_PRICE_LINE)>=0)
                        ObjectDelete(SL_PRICE_LINE);
                     Print("划线平仓或锁仓模式关闭");
                     comment1("划线平仓或锁仓模式关闭");
                    }
                  else
                    {
                     if(shift)
                       {
                        huaxianShift=true;
                        huaxianSwitch=true;
                        huaxianguadan=false;
                        huaxiankaicang=false;
                        Print("划线反向锁仓模式开启");
                        comment1("划线反向锁仓模式开启");
                       }
                     else
                       {
                        if(ctrl)
                          {
                           huaxianCtrl=true;
                           huaxianSwitch=true;
                           huaxianguadan=false;
                           huaxiankaicang=false;
                           Print("划线反向等量开仓变相锁仓模式 开启");
                           comment1("划线反向等量开仓变相锁仓模式 开启");
                          }
                        else
                          {
                           huaxianSwitch=true;
                           huaxianguadan=false;
                           huaxiankaicang=false;
                           Print("划线平仓模式开启");
                           comment1("划线平仓模式开启");
                          }
                       }

                    }
                  tab=false;
                  shift=false;
                  ctrl=false;
                 }
              }
            else
              {
               tab=false;
              }

            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(70*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(70*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(70*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(70*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=7;
            dingdanshu1=7;
            dingdanshu2=7;
            dingdanshu3=7;
            dingdanshu4=7;
            comment("主键盘数字键 7 本提示消失按键失效");
           }
         break;
         case 9://主键盘8
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(huaxianTimeSwitch)
                    {
                     huaxianTimeSwitch=false;
                     huaxianSwitch=false;
                     获利方式1制定2趋势线0无获利平仓=2;
                     止损方式1制定2趋势线3移动止损0无止损=2;
                     if(ObjectFind(TPObjName)>=0)
                        ObjectDelete(TPObjName);
                     if(ObjectFind(SLObjName)>=0)
                        ObjectDelete(SLObjName);
                     if(ObjectFind(TP_PRICE_LINE)>=0)
                        ObjectDelete(TP_PRICE_LINE);
                     if(ObjectFind(SL_PRICE_LINE)>=0)
                        ObjectDelete(SL_PRICE_LINE);
                     Print("布林带平仓 定时器模式 关闭");
                     comment1("布林带平仓 定时器模式 关闭");
                    }
                  else
                    {
                     huaxianTimeSwitch=true;
                     huaxianSwitch=false;
                     huaxianguadan=false;
                     huaxiankaicang=false;
                     获利方式1制定2趋势线0无获利平仓=1;
                     止损方式1制定2趋势线3移动止损0无止损=1;
                     Print("布林带平仓 定时器模式 开启 默认参数20");
                     comment1("布林带平仓 定时器模式 开启 默认参数20");
                    }
                  shiftR=false;
                 }
               else
                 {
                  if(huaxianSwitch || huaxianTimeSwitch)
                    {
                     huaxianSwitch=false;
                     huaxianTimeSwitch=false;
                     获利方式1制定2趋势线0无获利平仓=2;
                     止损方式1制定2趋势线3移动止损0无止损=2;
                     if(ObjectFind(TPObjName)>=0)
                        ObjectDelete(TPObjName);
                     if(ObjectFind(SLObjName)>=0)
                        ObjectDelete(SLObjName);
                     if(ObjectFind(TP_PRICE_LINE)>=0)
                        ObjectDelete(TP_PRICE_LINE);
                     if(ObjectFind(SL_PRICE_LINE)>=0)
                        ObjectDelete(SL_PRICE_LINE);
                     Print("布林带平仓模式关闭");
                     comment1("布林带平仓模式关闭");
                    }
                  else
                    {
                     huaxianSwitch=true;
                     huaxianguadan=false;
                     huaxiankaicang=false;
                     获利方式1制定2趋势线0无获利平仓=1;
                     止损方式1制定2趋势线3移动止损0无止损=1;
                     Print("布林带平仓模式开启 默认参数20");
                     comment1("布林带平仓模式开启 默认参数20");
                    }
                 }
               tab=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(80*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(80*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(80*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(80*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=8;
            dingdanshu1=8;
            dingdanshu2=8;
            dingdanshu3=8;
            dingdanshu4=8;
            comment("主键盘数字键 8 本提示消失按键失效");
           }
         break;
         case 10://主键盘9
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(tickclose)
                 {
                  tickclose=false;
                  tickShift=false;
                  Print("Tick数值变化剧烈时自动平仓 关闭");
                  comment1("Tick数值变化剧烈时自动平仓 关闭");
                 }
               else
                 {
                  if(bkey)
                    {
                     tickbuyclose=true;
                     if(shift)
                        tickShift=true;
                     tickclose=true;
                     Print("Buy单Tick数值变化剧烈时自动平仓 开启 最大变化预设值",glotickclosenum," 启用前按一下Shift进入调试模式","tickShift=",tickShift);
                     comment1("Buy单Tick数值变化剧烈时自动平仓 开启");
                     bkey=false;
                    }
                  if(skey)
                    {
                     if(shift)
                        tickShift=true;
                     tickclose=true;
                     Print("Sell单Tick数值变化剧烈时自动平仓 开启 最大变化预设值",glotickclosenum," 启用前按一下Shift进入调试模式","tickShift=",tickShift);
                     comment1("Sell单Tick数值变化剧烈时自动平仓 开启");
                     skey=false;
                    }
                 }
               tab=false;
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(90*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(90*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(90*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(90*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
            dingdanshu=9;
            dingdanshu1=9;
            dingdanshu2=9;
            dingdanshu3=9;
            dingdanshu4=9;
            comment("主键盘数字键 9 本提示消失按键失效");
           }
         break;
         case 11://主键盘0
           {
            if(tabtimeCurrent+2>=TimeCurrent() && tab==true)
              {
               if(EAswitch)
                 {
                  EAswitch=false;
                  Print("EA运行总开关 临时关闭 如需长时间关闭请按F7修改");
                  comment1("EA运行总开关 临时关闭 如需长时间关闭请按F7修改");
                 }
               else
                 {
                  if(Gradually)
                    {
                     Gradually=false;
                     EAswitch=true;
                     Print("EA运行总开关开启 但分步平仓模式临时关闭");
                     comment1("EA运行总开关开启 但分步平仓模式临时关闭");
                    }
                  else
                    {
                     EAswitch=true;
                     Gradually=true;
                     Print("EA运行总开关 开启");
                     comment1("EA运行总开关 开启");
                    }
                 }
               Print("Gradually=",Gradually);
               Print("EAswitch=",EAswitch);
              }
            else
              {
               tab=false;
              }
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey);
               piliangTPdianshu(0*piliangtpdianshu);
               pkey=false;
              }
            else
               pkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," l=",lkey);
               piliangSLdianshu(0*piliangsldianshu);
               lkey=false;
              }
            else
               lkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单取消止盈止损 处理中 . . . ");
               comment("多单取消止盈止损 处理中 . . . ");
               StopLoss=0;
               TargetProfit=0;
               FixedStopLoss=0.0;
               FixedTargetProfit=0.0;
               onlysell=false;
               piliangsltp();
               onlysell=true;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单取消止盈止损 处理中 . . . ");
               comment("空单取消止盈止损 处理中 . . . ");
               StopLoss=0;
               TargetProfit=0;
               FixedStopLoss=0.0;
               FixedTargetProfit=0.0;
               onlybuy=false;
               piliangsltp();
               onlybuy=true;
               skey=false;
              }
            else
               skey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey);
               piliangTPnowdianshu(0*piliangtpdianshu);
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey);
               piliangSLnowdianshu(0*piliangtpdianshu);
               kkey=false;
              }
            else
               kkey=false;
            bkey=false;
            skey=false;
           }
         break;
         case 309://小键盘  "/"键
           {
            if(SLQlotsT==SLQlots)
              {
               SLQlotsT=SLQlots*2;
               Print("小键盘 *键 双倍手数开仓");
               comment("小键盘 *键 双倍手数开仓");
              }
            else
              {
               SLQlotsT=SLQlots;
               Print("小键盘 *键 恢复正常手数开仓");
               comment("小键盘 *键 恢复正常手数开仓");
              }
           }
         break;
         case 55://小键盘 乘号键
           {
            if(Tickmode)
              {
               if(SL15mbuyLine)
                 {
                  double buysl;
                  double buysl1=iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,SL1mQlinetimeframe,0))-SLQbuylinepianyi*Point;
                  double buysl2=Ask-50*Point;
                  Print("buysl1=",buysl1," buysl2=",buysl2);
                  if(buysl2>buysl1)
                    {
                     buysl=buysl1;
                    }
                  else
                    {
                     buysl=buysl2;
                    }
                  for(int i=SLQNum; i>0; i--)
                    {
                     int ticket=OrderSend(Symbol(),OP_BUY,SLQlotsT,Ask,6,buysl,Ask+SL5Qtp*Point,NULL,1688,0,CLR_NONE);
                     if(ticket>0)
                        PlaySound("ok.wav");
                     else
                        PlaySound("timeout.wav");
                     buysl=buysl-3*Point;
                    }
                  SL5QTPtimeCurrent=TimeCurrent();
                  SL5QTPtimeCurrenttrue=true;

                  SLbuylineQpingcang1=true;
                  SLbuylineQpingcangT1=true;
                  SetLevel("SLsellQpengcangline1",Bid+200*Point,DarkSlateGray);
                  SLsellQpengcangline1=Bid+200*Point;
                  Print("剥头皮 Buy单短线平仓模式 价格越过横线一单一单止盈平仓  开启");
                  comment("剥头皮 Buy单短线平仓模式 价格越过横线一单一单止盈平仓 开启");
                 }
               else
                 {
                  double sellsl;
                  double sellsl1=iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,SL1mQlinetimeframe,0))+SLQselllinepianyi*Point;
                  double sellsl2=Bid+50*Point;
                  Print("sellsl1=",sellsl1," sellsl2=",sellsl2);
                  if(sellsl2<sellsl1)
                    {
                     sellsl=sellsl1;
                    }
                  else
                    {
                     sellsl=sellsl2;
                    }
                  for(int i=SLQNum; i>0; i--)
                    {
                     int ticket=OrderSend(Symbol(),OP_SELL,SLQlotsT,Bid,6,sellsl,Bid-SL5Qtp*Point,NULL,1688,0,CLR_NONE);
                     if(ticket>0)
                        PlaySound("ok.wav");
                     else
                        PlaySound("timeout.wav");
                     sellsl=sellsl+3*Point;
                    }
                  SL5QTPtimeCurrent=TimeCurrent();
                  SL5QTPtimeCurrenttrue=true;

                  SLselllineQpingcang1=true;
                  SLselllineQpingcangT1=true;
                  SetLevel("SLbuyQpengcangline1",Ask-200*Point,DarkSlateGray);
                  SLbuyQpengcangline1=Ask-200*Point;
                  Print("剥头皮 Sell单短线平仓模式 价格越过横线一单一单止盈平仓  开启");
                  comment("剥头皮 Sell单短线平仓模式 价格越过横线一单一单止盈平仓 开启");
                 }
              }
           }
         break;
         case 82://小键盘0
           {
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buystop单 处理中 . . .",Guadanprice));
               Guadanbuystop(huaxianguadanlotsT,Ask+Guadanprice*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
              }
            else
               pkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"距现价",Guadanprice,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buylimit单 处理中 . . .",Guadanprice));
               Guadanbuylimit(huaxianguadanlotsT,Ask-Guadanprice*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
              }
            else
               okey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂sellstop单 处理中 . . .",Guadanprice));
               Guadansellstop(huaxianguadanlotsT,Bid-Guadanprice*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
              }
            else
               lkey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"距现价",Guadanprice,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂selllimit单 处理中 . . .",Guadanprice));
               Guadanselllimit(huaxianguadanlotsT,Bid+Guadanprice*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
              }
            else
               kkey=false;
           }
         break;
         case 79://小键盘1 j  1111
           {

            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 1 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 1 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,1,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 1 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 1 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,1,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangSL(true,Bid-zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangSL(false,Ask+zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
              {
               Print("akey ",akey);
               akey=false;
              }

            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice1,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buystop单 处理中 . . .",Guadanprice1));
               Guadanbuystop(huaxianguadanlotsT,Ask+Guadanprice1*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
              }
            else
               pkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"距现价",Guadanprice1,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buylimit单 处理中 . . .",Guadanprice1));
               Guadanbuylimit(huaxianguadanlotsT,Ask-Guadanprice1*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
              }
            else
               okey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice1,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂sellstop单 处理中 . . .",Guadanprice1));
               Guadansellstop(huaxianguadanlotsT,Bid-Guadanprice1*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
              }
            else
               lkey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"距现价",Guadanprice1,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂selllimit单 处理中 . . .",Guadanprice1));
               Guadanselllimit(huaxianguadanlotsT,Bid+Guadanprice1*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
              }
            else
               kkey=false;
            guadangeshu=1;
            comment("小键盘数字键 1 本提示消失按键失效");
           }
         break;
         case 80://小键盘2 j
           {

            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 2 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 2 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,2,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 2 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 2 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,2,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止盈当前价上方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈当前价上方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangTP(true,Bid+zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止盈当前价下方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止盈当前价下方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangTP(false,Ask-zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止盈均价上方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈均价上方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangTP(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)+zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止盈均价下方",zhinengSLTP1,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷盈均价下方%G个点 处理中 . . .",zhinengSLTP1));
               PiliangTP(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)-zhinengSLTP1*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice2,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buystop单 处理中 . . .",Guadanprice2));
               Guadanbuystop(huaxianguadanlotsT,Ask+Guadanprice2*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
              }
            else
               pkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"距现价",Guadanprice2,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buylimit单 处理中 . . .",Guadanprice2));
               Guadanbuylimit(huaxianguadanlotsT,Ask-Guadanprice2*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
              }
            else
               okey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice2,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂sellstop单 处理中 . . .",Guadanprice2));
               Guadansellstop(huaxianguadanlotsT,Bid-Guadanprice2*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
              }
            else
               lkey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"距现价",Guadanprice2,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂selllimit单 处理中 . . .",Guadanprice2));
               Guadanselllimit(huaxianguadanlotsT,Bid+Guadanprice2*Point+press(),guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
              }
            else
               kkey=false;
            guadangeshu=2;
            comment("小键盘数字键 2 本提示消失按键失效");
           }
         break;
         case 81://小键盘3 j
           {

            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 3 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 3 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,3,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 3 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 3 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,3,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP1*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP1*2));
               PiliangSL(true,Bid-zhinengSLTP1*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP1*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP1*2));
               PiliangSL(false,Ask+zhinengSLTP1*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP1*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP1*2));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP1*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP1*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP1*2));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP1*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+2>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice3,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buystop单 处理中 . . .",Guadanprice3));
               Guadanbuystop(huaxianguadanlotsT,Ask+Guadanprice3*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
              }
            else
               pkey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"距现价",Guadanprice3,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂buylimit单 处理中 . . .",Guadanprice3));
               Guadanbuylimit(huaxianguadanlotsT,Ask-Guadanprice3*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
              }
            else
               okey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"距现价",Guadanprice3,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂sellstop单 处理中 . . .",Guadanprice3));
               Guadansellstop(huaxianguadanlotsT,Bid-Guadanprice3*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
              }
            else
               lkey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"距现价",Guadanprice3,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("距现价%G点批量挂selllimit单 处理中 . . .",Guadanprice3));
               Guadanselllimit(huaxianguadanlotsT,Bid+Guadanprice3*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
              }
            else
               kkey=false;
            guadangeshu=3;
            comment("小键盘数字键 3 本提示消失按键失效");
           }
         break;
         case 75://小键盘4
           {
            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 4 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 4 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,4,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 4 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 4 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,4,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangSL(true,Bid-zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangSL(false,Ask+zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+3>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiHighest(0,Guadanprice4,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buystop单 处理中 . . .",GetiHighest(0,Guadanprice4,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point));
               Guadanbuystop(Guadanlots,GetiHighest(0,Guadanprice4,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
               return;
              }
            else
               pkey=false;
            if(otimeCurrent+3>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"在",GetiLowest(0,Guadanprice4,0)+Guadanbuylimitpianyiliang*Point,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buylimit单 处理中 . . .",GetiLowest(0,Guadanprice4,0)+Guadanbuylimitpianyiliang*Point));
               Guadanbuylimit(Guadanlots,GetiLowest(0,Guadanprice4,0)+Guadanbuylimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
               return;
              }
            else
               okey=false;
            if(ltimeCurrent+3>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiLowest(0,Guadanprice4,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂sellstop单 处理中 . . .",GetiLowest(0,Guadanprice4,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point));
               Guadansellstop(Guadanlots,GetiLowest(0,Guadanprice4,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
               return;
              }
            else
               lkey=false;
            if(ktimeCurrent+3>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"在",GetiHighest(0,Guadanprice4,0)-Guadanselllimitpianyiliang*Point,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂selllimit单 处理中 . . .",GetiHighest(0,Guadanprice4,0)-Guadanselllimitpianyiliang*Point));
               Guadanselllimit(Guadanlots,GetiHighest(0,Guadanprice4,0)-Guadanselllimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 76://小键盘5
           {
            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 5 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 5 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,5,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 5 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 5 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,5,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止盈当前价上方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈当前价上方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangTP(true,Bid+zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止盈当前价下方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止盈当前价下方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangTP(false,Ask-zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止盈均价上方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈均价上方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangTP(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)+zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止盈均价下方",zhinengSLTP2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷盈均价下方%G个点 处理中 . . .",zhinengSLTP2));
               PiliangTP(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)-zhinengSLTP2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+3>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiHighest(0,Guadanprice5,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buystop单 处理中 . . .",GetiHighest(0,Guadanprice5,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadanbuystop(Guadanlots,GetiHighest(0,Guadanprice5,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
               return;
              }
            else
               pkey=false;
            if(otimeCurrent+3>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"在",GetiLowest(0,Guadanprice5,0)+Guadanbuylimitpianyiliang*Point,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buylimit单 处理中 . . .",GetiLowest(0,Guadanprice5,0)+Guadanbuylimitpianyiliang*Point));
               Guadanbuylimit(Guadanlots,GetiLowest(0,Guadanprice5,0)+Guadanbuylimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
               return;
              }
            else
               okey=false;
            if(ltimeCurrent+3>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiLowest(0,Guadanprice5,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂sellstop单 处理中 . . .",GetiLowest(0,Guadanprice5,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point));
               Guadansellstop(Guadanlots,GetiLowest(0,Guadanprice5,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
               return;
              }
            else
               lkey=false;
            if(ktimeCurrent+3>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"在",GetiHighest(0,Guadanprice5,0)-Guadanselllimitpianyiliang*Point,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂selllimit单 处理中 . . .",GetiHighest(0,Guadanprice5,0)-Guadanselllimitpianyiliang*Point+press()));
               Guadanselllimit(Guadanlots,GetiHighest(0,Guadanprice5,0)-Guadanselllimitpianyiliang*Point,Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 77://小键盘6
           {
            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 6 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 6 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,6,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 6 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 6 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,6,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP2*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP2*2));
               PiliangSL(true,Bid-zhinengSLTP2*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP2*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP2*2));
               PiliangSL(false,Ask+zhinengSLTP2*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP2*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP2*2));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP2*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP2*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP2*2));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP2*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
           }
         break;
         case 71://小键盘7
           {
            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 7 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 7 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,7,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 7 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 7 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,7,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangSL(true,Bid-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangSL(false,Ask+zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            if(ptimeCurrent+3>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiHighest(0,Guadanprice7,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buystop单 处理中 . . .",GetiHighest(0,Guadanprice7,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadanbuystop(Guadanlots,GetiHighest(0,Guadanprice7,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
               return;
              }
            else
               pkey=false;
            if(otimeCurrent+3>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"在",GetiLowest(0,Guadanprice7,0)+Guadanbuylimitpianyiliang*Point,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buylimit单 处理中 . . .",GetiLowest(0,Guadanprice7,0)+Guadanbuylimitpianyiliang*Point));
               Guadanbuylimit(Guadanlots,GetiLowest(0,Guadanprice7,0)+Guadanbuylimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
               return;
              }
            else
               okey=false;
            if(ltimeCurrent+3>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiLowest(0,Guadanprice7,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂sellstop单 处理中 . . .",GetiLowest(0,Guadanprice7,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadansellstop(Guadanlots,GetiLowest(0,Guadanprice7,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
               return;
              }
            else
               lkey=false;
            if(ktimeCurrent+3>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"在",GetiHighest(0,Guadanprice7,0)-Guadanselllimitpianyiliang*Point,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂selllimit单 处理中 . . .",GetiHighest(0,Guadanprice7,0)-Guadanselllimitpianyiliang*Point));
               Guadanselllimit(Guadanlots,GetiHighest(0,Guadanprice7,0)-Guadanselllimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 72://小键盘8 jian
           {
            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 8 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 8 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,8,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 8 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 8 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,8,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止盈当前价上方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈当前价上方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangTP(true,Bid+zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止盈当前价下方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止盈当前价下方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangTP(false,Ask-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止盈均价上方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止盈均价上方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangTP(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)+zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止盈均价下方",zhinengSLTP3,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷盈均价下方%G个点 处理中 . . .",zhinengSLTP3));
               PiliangTP(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
            // if(ctrltimeCurrent+1>=TimeCurrent() && ctrl==true){Print("市价三倍买一单 处理中 . . .");comment("市价三倍买一单 处理中 . . .");int om=OrderSend(Symbol(),OP_BUY,keylots*3,Ask,keyslippage,0,0,NULL,0);if(om>0) PlaySound("ok.wav");else PlaySound("timeout.wav");ctrl=false;return;}
            //else ctrl=false;
            if(ptimeCurrent+3>=TimeCurrent() && pkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiHighest(0,Guadanprice8,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂buystop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buystop单 处理中 . . .",GetiHighest(0,Guadanprice8,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadanbuystop(Guadanlots,GetiHighest(0,Guadanprice8,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               pkey=false;
               return;
              }
            else
               pkey=false;
            if(otimeCurrent+3>=TimeCurrent() && okey==true)
              {
               Print(" b=",bkey," s=",skey," o=",okey,"在",GetiLowest(0,Guadanprice8,0)+Guadanbuylimitpianyiliang*Point,"点批量挂buylimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂buylimit单 处理中 . . .",GetiLowest(0,Guadanprice8,0)+Guadanbuylimitpianyiliang*Point));
               Guadanbuylimit(Guadanlots,GetiLowest(0,Guadanprice8,0)+Guadanbuylimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               okey=false;
               return;
              }
            else
               okey=false;
            if(ltimeCurrent+3>=TimeCurrent() && lkey==true)
              {
               Print(" b=",bkey," s=",skey," p=",pkey,"在",GetiLowest(0,Guadanprice8,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point,"点批量挂sellstop单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂sellstop单 处理中 . . .",GetiLowest(0,Guadanprice8,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press()));
               Guadansellstop(Guadanlots,GetiLowest(0,Guadanprice8,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               lkey=false;
               return;
              }
            else
               lkey=false;
            if(ktimeCurrent+3>=TimeCurrent() && kkey==true)
              {
               Print(" b=",bkey," s=",skey," k=",kkey,"在",GetiHighest(0,Guadanprice8,0)-Guadanselllimitpianyiliang*Point,"点批量挂selllimit单 处理中 . . . ");
               comment(StringFormat("在%G点批量挂selllimit单 处理中 . . .",GetiHighest(0,Guadanprice8,0)-Guadanselllimitpianyiliang*Point));
               Guadanselllimit(Guadanlots,GetiHighest(0,Guadanprice8,0)-Guadanselllimitpianyiliang*Point+press(),Guadangeshu+rightpress,Guadanjianju+leftpress,Guadansl,Guadantp,Guadanjuxianjia);
               rightpress=0;
               leftpress=0;
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 73://小键盘9
           {
            if(ntimeCurrent+2>=TimeCurrent() && nkey==true)
              {
               Print("n=",nkey,"多单计算最近 9 根K线批量智能止损 处理中 . . . ");
               comment("多单计算最近 9 根K线批量智能止损 处理中 . . .");
               PiliangSL(true,GetiLowest(timeframe10,9,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               nkey=false;
               return;
              }
            else
               nkey=false;
            if(dtimeCurrent+2>=TimeCurrent() && dkey==true)
              {
               Print("d=",dkey,"空单计算最近 9 根K线批量智能止损 处理中 . . .");
               comment("空单计算最近 9 根K线批量智能止损 处理中 . . .");
               PiliangSL(false,GetiHighest(timeframe10,9,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10nom,juxianjia10,dingdanshu1);
               dkey=false;
               return;
              }
            else
               dkey=false;
            if(btimeCurrent+3>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单批量快捷止损当前价下方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损当前价下方%G点 处理中 . . .",zhinengSLTP3*2));
               PiliangSL(true,Bid-zhinengSLTP3*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               bkey=false;
               return;
              }
            else
               bkey=false;
            if(stimeCurrent+3>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单批量快捷止损当前价上方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损当前价上方%G个点 处理中 . . .",zhinengSLTP3*2));
               PiliangSL(false,Ask+zhinengSLTP3*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               skey=false;
               return;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP3*2));
               PiliangSL(true,NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-zhinengSLTP3*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP3*2));
               PiliangSL(false,NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+zhinengSLTP3*2*Point+press(),zhinengSLTPjianju,0,zhinengSLTPjuxianjia,dingdanshu2);
               akey=false;
               return;
              }
            else
               akey=false;
           }
         break;
         case 25://P jian
           {
            if(tabtimeCurrent+3>=TimeCurrent())
              {
               if(SLbuylineQpingcang==false && SLselllineQpingcang==false)
                 {
                  if(Tickmode)
                    {
                     if(SL15mbuyLine)
                       {
                        SLbuylineQpingcang=true;
                        SLbuylineQpingcangT=true;
                        timeseconds=1;
                        SetLevel("SLsellQpengcangline",Bid+200*Point,DarkSlateGray);
                        SLsellQpengcangline=Bid+200*Point;
                        Print("剥头皮 Buy单短线平仓模式 价格越过横线一单一单止盈平仓  开启");
                        comment("剥头皮 Buy单短线平仓模式 价格越过横线一单一单止盈平仓 开启");
                       }
                     else
                       {
                        if(SL15msellLine)
                          {
                           SLselllineQpingcang=true;
                           SLselllineQpingcangT=true;
                           timeseconds=1;
                           SetLevel("SLbuyQpengcangline",Ask-200*Point,DarkSlateGray);
                           SLbuyQpengcangline=Ask-200*Point;
                           Print("剥头皮 Sell单短线平仓模式 价格越过横线一单一单止盈平仓  开启");
                           comment("剥头皮 Sell单短线平仓模式 价格越过横线一单一单止盈平仓 开启");
                          }
                       }
                    }
                 }
               else
                 {
                  SLbuylineQpingcang=false;
                  SLselllineQpingcang=false;
                  SLbuylineQpingcangT=false;
                  SLselllineQpingcangT=false;
                  timeseconds=2;
                  if(ObjectFind(0,"SLsellQpengcangline")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  Print("剥头皮 短线平仓模式 价格越过横线一单一单止盈平仓 关闭 ");
                  comment("剥头皮 短线平仓模式 价格越过横线一单一单止盈平仓 关闭");
                 }
              }
            if(ltimeCurrent+3>=TimeCurrent() && lkey==true)
              {
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(ObjectFind("Buy Line")==0 && linesellpingcangR==false)
                    {
                     linesellpingcangR=true;
                     linelock=true;
                     pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                     Print("sell单越过横线一单一单平仓 开启 仅止盈用 buy单用 sell Line sell单用 buy Line");
                     comment("sell单 越过横线一单一单平仓 开启 仅止盈用 ");
                    }
                 }
               else
                 {
                  if(tab)
                    {
                     if(ObjectFind("Buy Line")==0 && linebuypingcang==false && linebuypingcangR==false)
                       {
                        PiliangSL(true,buyline-(MarketInfo(Symbol(),MODE_SPREAD)+lineslpianyi)*Point,jianju07,0,1,10);
                        linebuypingcangC=true;
                        linelock=true;
                        pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                        Print("触及横线全平仓 定时器模式 开启");
                        comment("触及横线全平仓 定时器模式 开启");
                        tab=false;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        if(ObjectFind("Buy Line")==0 && linebuypingcang==false && linebuypingcangR==false && linebuypingcangC==false)
                          {
                           linebuypingcang=true;
                           linelock=true;
                           linebuypingcangctrlR=true;
                           pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                           Print("触及横线后反向距横线多少设置止损止盈 开启 薅羊毛有风险");
                           comment("触及横线后反向距横线多少设置止损止盈 开启 薅羊毛有风险");
                          }
                       }
                     else
                       {
                        if(ObjectFind("Buy Line")==0 && linebuypingcang==false && linebuypingcangR==false && linebuypingcangC==false)//2222
                          {
                           if(btimeCurrent+3>=TimeCurrent())
                             {
                              linebuypingcang=true;
                              linebuypingcangonly=true;
                              linesellpingcangonly=false;
                              linelock=true;
                              pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                              Print("触及横线 只平buy单 开启");
                              comment("触及横线 只平buy单 开启");
                             }
                           else
                             {
                              if(ntimeCurrent+3>=TimeCurrent())
                                {
                                 linebuypingcang=true;
                                 linebuypingcangonly=false;
                                 linesellpingcangonly=true;
                                 linelock=true;
                                 pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                                 Print("触及横线 只平sell单 开启");
                                 comment("触及横线 只平sell单 开启");
                                }
                              else
                                {
                                 linebuypingcang=true;
                                 linelock=true;
                                 pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                                 Print("触及横线全平仓 开启");
                                 comment("触及横线全平仓 开启");
                                }

                             }

                          }
                        else
                          {
                           if(linebuypingcang || linebuypingcangR || linebuypingcangC || linebuypingcangctrlR)
                             {
                              linebuypingcang=false;
                              linebuypingcangR=false;
                              linebuypingcangC=false;
                              linebuypingcangctrlR=false;
                              linebuypingcangonly=false;
                              linesellpingcangonly=false;
                              linelock=false;
                              Print("触及横线平仓 关闭");
                              comment("触及横线平仓 关闭");
                             }
                          }
                       }
                    }
                 }
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(ObjectFind("Sell Line")==0 && linebuypingcangR==false)
                    {
                     linebuypingcangR=true;
                     linelock=true;
                     pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                     Print("buy单 越过横线一单一单平仓 开启 仅止盈用  buy单用 sell Line sell单用 buy Line");
                     comment("buy单 越过横线一单一单平仓 开启 仅止盈用");
                    }
                  shiftR=false;
                 }
               else
                 {
                  if(tab)
                    {
                     if(ObjectFind("Sell Line")==0 && linesellpingcang==false && linesellpingcangR==false)
                       {
                        PiliangSL(false,sellline+(MarketInfo(Symbol(),MODE_SPREAD)+lineslpianyi)*Point,jianju07,0,1,10);
                        linesellpingcangC=true;
                        linelock=true;
                        pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                        Print("触及横线全平仓 定时器模式 开启");
                        comment("触及横线全平仓 定时器模式 开启");
                        tab=false;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        if(ObjectFind("Sell Line")==0 && linesellpingcang==false && linesellpingcangR==false && linebuypingcangC==false)
                          {
                           linesellpingcang=true;
                           linesellpingcangctrlR=true;
                           linelock=true;
                           pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                           Print("触及横线后反向距横线多少设置止损止盈 开启 薅羊毛有风险");
                           comment("触及横线后反向距横线多少设置止损止盈 开启 薅羊毛有风险");
                          }
                       }
                     else
                       {
                        if(ObjectFind("Sell Line")==0 && linesellpingcang==false && linesellpingcangR==false && linebuypingcangC==false)
                          {
                           if(btimeCurrent+3>=TimeCurrent())
                             {
                              linesellpingcang=true;
                              linebuypingcangonly=true;
                              linesellpingcangonly=false;
                              linelock=true;
                              pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                              Print("触及横线 只平buy单 开启");
                              comment("触及横线 只平buy单 开启");
                             }
                           else
                             {
                              if(ntimeCurrent+3>=TimeCurrent())
                                {
                                 linesellpingcang=true;
                                 linebuypingcangonly=false;
                                 linesellpingcangonly=true;
                                 linelock=true;
                                 pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                                 Print("触及横线 只平sell单 开启");
                                 comment("触及横线 只平sell单 开启");
                                }
                              else
                                {
                                 linesellpingcang=true;
                                 linelock=true;
                                 pingcangdingdanshu=dingdanshu;//只处理最近下的多少单 提前主数字键
                                 Print("触及横线全平仓 开启");
                                 comment("触及横线全平仓 开启");
                                }

                             }
                          }
                        else
                          {
                           if(linesellpingcang || linesellpingcangR || linesellpingcangC || linesellpingcangctrlR)
                             {
                              linesellpingcang=false;
                              linesellpingcangR=false;
                              linesellpingcangC=false;
                              linesellpingcangctrlR=false;
                              linebuypingcangonly=false;
                              linesellpingcangonly=false;
                              linelock=false;
                              Print("触及横线平仓 关闭");
                              comment("触及横线平仓 关闭");
                             }
                          }
                       }
                    }
                 }
               lkey=false;
               pkey=false;
              }
            else
              {
               lkey=false;
              }
            if(gtimeCurrent+2>=TimeCurrent() && gkey==true)
              {
               Print("g=",gkey," 智能buystop单 处理中. . .");
               comment(" 智能buystop单 处理中. . .");
               zhinengguadanbuystop();
               gkey=false;
              }
            else
              {
               gkey=false;
              }
            if(mtimeCurrent+3>=TimeCurrent() && mkey==true)
              {
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(dingshipingcang15)
                    {
                     dingshipingcang15=false;
                     Print("mkey=",mkey," 当前十五分钟K线收线时平仓 关闭");
                     comment("当前十五分钟K线收线时平仓 关闭");
                     mkey=false;
                     pkey=false;
                    }
                  else
                    {
                     dingshipingcang15=true;
                     Print("mkey=",mkey," 当前十五分钟K线收线时平仓  开启");
                     comment("当前十五分钟K线收线时平仓 开启");
                     mkey=false;
                     pkey=false;
                    }
                 }
               else
                 {
                  if(dingshipingcang)
                    {
                     dingshipingcang=false;
                     Print("mkey=",mkey," 当前五分钟K线收线时平仓 关闭");
                     comment("当前五分钟K线收线时平仓 关闭");
                     mkey=false;
                     pkey=false;
                    }
                  else
                    {
                     dingshipingcang=true;
                     Print("mkey=",mkey," 当前五分钟K线收线时平仓  开启");
                     comment("当前五分钟K线收线时平仓 开启");
                     mkey=false;
                     pkey=false;
                    }
                 }
              }
            else
              {
               mkey=false;
              }
           }
         break;
         case 38://L jian
           {
            if(ObjectFind("Buy Line")==0 || ObjectFind("SL Line")==0)
              {

              }
            else
              {
               if(gtimeCurrent+2>=TimeCurrent() && gkey==true)
                 {
                  Print("g=",gkey," 智能sellstop单 处理中. . .");
                  comment(" 智能sellstop单 处理中. . .");
                  zhinengguadansellstop();
                  gkey=false;
                  lkey=false;
                 }
               else
                  gkey=false;
              }
           }
         break;
         case 21://Y jian
           {
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey," 多单批量上移当前止盈",moveSTTP,"个点");
               comment(StringFormat("多单批量上移当前止盈%G点",moveSTTP));
               onlybuy1=true;
               onlytpt=true;
               movesttp();
               onlybuy1=false;
               onlytpt=false;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey," 空单批量上移当前止盈",moveSTTP,"个点");
               comment(StringFormat("空单批量上移当前止盈%G个点",moveSTTP));
               onlysell1=true;
               onlyup=true;
               movesttp();
               onlybuy1=false;
               onlyup=false;
               skey=false;
              }
            else
               skey=false;
           }
         break;
         case 34://G jian
           {
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  if(shiftR)
                    {
                     if(ObjectFind("Buy Line")==0)
                       {
                        double sl=GetiLowest(0,7,0)-MarketInfo(Symbol(),MODE_SPREAD)*Point-50*Point;
                        Print("横线处挂Buylimit单带7K智能止损 处理中... ",sl);
                        comment("横线处挂Buylimit单带7K智能止损 处理中...");
                        Guadanbuylimit(huaxianguadanlotsT,NormalizeDouble(buyline,Digits),guadangeshu+rightpress,huaxianguadanjianju+leftpress,sl,huaxianguadantp,huaxianguadanjuxianjia);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        leftpress=0;
                        rightpress=0;
                       }
                     gkey=false;
                     lkey=false;
                     shiftR=false;
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        Print("buyline=",NormalizeDouble(buyline,Digits));
                        Print("横线处挂sellstop单 处理中... ");
                        comment("横线处挂sellstop单 处理中...");
                        Guadansellstop(huaxianguadanlotsT,NormalizeDouble(buyline,Digits),guadangeshu+rightpress,huaxianguadanjianju+leftpress,hengxianguadansl,hengxianguadantp,huaxianguadanjuxianjia);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        leftpress=0;
                        rightpress=0;
                        ctrl=false;
                       }
                     else
                       {
                        if(ObjectFind("SL Line")==0)
                          {
                           Print("横线处带止损挂Buylimit单在止损线止损  处理中... ",buyline);
                           comment("横线处带止损挂Buylimit单在止损线止损 处理中...");
                           Guadanbuylimit(huaxianguadanlotsT,NormalizeDouble(buyline,Digits),guadangeshu+rightpress,huaxianguadanjianju+leftpress,slline,huaxianguadantp,huaxianguadanjuxianjia);
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                           if(ObjectFind(0,"SL Line")==0)
                              ObjectDelete(0,"SL Line");
                           leftpress=0;
                           rightpress=0;
                           gkey=false;
                           lkey=false;
                           return;
                          }
                        else
                          {
                           Print("横线处带止损挂Buylimit单 X键可生成止损线  处理中... ",buyline);
                           comment("横线处带止损挂Buylimit单 X键可生成止损线 处理中...");
                           Guadanbuylimit(huaxianguadanlotsT,NormalizeDouble(buyline,Digits),guadangeshu+rightpress,huaxianguadanjianju+leftpress-xiapress,hengxianguadansl,hengxianguadantp,huaxianguadanjuxianjia);
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                           if(ObjectFind(0,"SL Line")==0)
                              ObjectDelete(0,"SL Line");
                           leftpress=0;
                           rightpress=0;
                           xiapress=0;
                           gkey=false;
                           lkey=false;
                           return;
                          }
                       }
                    }
                  return;
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  if(shiftR)
                    {
                     if(ObjectFind("Sell Line")==0)
                       {
                        double sl1=GetiHighest(0,7,0)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+50*Point;
                        Print("横线处挂Selllimit单带7K智能止损 处理中... ",sl1);
                        comment("横线处挂Selllimit单带7K智能止损 处理中...");
                        Guadanselllimit(huaxianguadanlotsT,NormalizeDouble(sellline,Digits),guadangeshu+rightpress,huaxianguadanjianju+leftpress,sl1,huaxianguadantp,huaxianguadanjuxianjia);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        leftpress=0;
                        rightpress=0;
                        gkey=false;
                        lkey=false;
                        shiftR=false;
                        return;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        Print("sellline=",NormalizeDouble(sellline,Digits));
                        Print("横线处挂buystop单 处理中... ");
                        comment("横线处挂buystop单 处理中...");
                        Guadanbuystop(huaxianguadanlotsT,NormalizeDouble(sellline,Digits),guadangeshu+rightpress,huaxianguadanjianju+leftpress,hengxianguadansl,hengxianguadantp,huaxianguadanjuxianjia);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        leftpress=0;
                        rightpress=0;
                        ctrl=false;
                        gkey=false;
                        lkey=false;
                        return;
                       }
                     else
                       {
                        if(ObjectFind("SL Line")==0)

                          {
                           Print("横线处挂Selllimit单在止损线止损 处理中... ",slline);
                           comment("横线处挂Selllimit单在止损线止损 处理中...");
                           Guadanselllimit(huaxianguadanlotsT,NormalizeDouble(sellline,Digits),guadangeshu+rightpress,huaxianguadanjianju+leftpress,slline,huaxianguadantp,huaxianguadanjuxianjia);
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                           if(ObjectFind(0,"SL Line")==0)
                              ObjectDelete(0,"SL Line");
                           leftpress=0;
                           rightpress=0;
                           gkey=false;
                           lkey=false;
                           return;
                          }
                        else
                          {
                           Print("横线处挂Selllimit单 X键可生成止损线 处理中... ",sellline);
                           comment("横线处挂Selllimit单 X键可生成止损线 处理中...");
                           Guadanselllimit(huaxianguadanlotsT,NormalizeDouble(sellline,Digits),guadangeshu+rightpress,huaxianguadanjianju+leftpress-xiapress,hengxianguadansl,hengxianguadantp,huaxianguadanjuxianjia);
                           if(ObjectFind(0,"Buy Line")==0)
                              ObjectDelete(0,"Buy Line");
                           if(ObjectFind(0,"Sell Line")==0)
                              ObjectDelete(0,"Sell Line");
                           if(ObjectFind(0,"SL Line")==0)
                              ObjectDelete(0,"SL Line");
                           leftpress=0;
                           rightpress=0;
                           xiapress=0;
                           gkey=false;
                           lkey=false;
                           return;
                          }
                       }
                    }
                 }
               return;
              }
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey," 多单批量下移当前止盈",moveSTTP,"个点");
               comment(StringFormat("多单批量下移当前止盈%G个点",moveSTTP));
               onlybuy1=true;
               onlydown=true;
               movesttp();
               onlybuy1=false;
               onlydown=false;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey," 空单批量下移当前止盈",moveSTTP,"个点");
               comment(StringFormat("空单批量下移当前止盈%G个点",moveSTTP));
               onlysell1=true;
               onlytpt=true;
               movesttp();
               onlybuy1=false;
               onlytpt=false;
               skey=false;
               gkey=false;
              }
            else
               skey=false;
           }
         break;
         case 20://T jian
           {
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  Print("buyline=",NormalizeDouble(buyline,Digits));
                  if(shiftRtimeCurrent+5>=TimeCurrent())
                    {
                     if(buyline<Bid && GetHoldingsellOrdersCount()>0)
                       {
                        Print("Sell单红线处设置统一止盈 处理中... ");
                        comment("Sell单红线处设置统一止盈 处理中...");
                        PiliangTP(false,NormalizeDouble(buyline,Digits),0,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("红线处在当前价上方 Sell单无法设置止盈 或没有sell单 ");
                        comment("红线处在当前价上方 Sell单无法设置止盈 或没有sell单");
                       }
                    }
                  else
                    {
                     if(buyline<Bid && GetHoldingsellOrdersCount()>0)
                       {
                        Print("Sell单红线处设置止盈 处理中... ");
                        comment("Sell单红线处设置止盈 处理中...");
                        PiliangTP(false,NormalizeDouble(buyline,Digits),jianju07tp,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("红线处在当前价上方 Sell单无法设置止盈 或没有sell单 ");
                        comment("红线处在当前价上方 Sell单无法设置止盈 或没有sell单");
                       }
                    }
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  Print("sellline=",NormalizeDouble(sellline,Digits));
                  if(shiftRtimeCurrent+5>=TimeCurrent())
                    {
                     if(sellline>Ask && GetHoldingbuyOrdersCount()>0)
                       {
                        Print("Buy单绿线处设置统一止盈 处理中... ");
                        comment("Buy单绿线处设置统一止盈 处理中...");
                        PiliangTP(true,NormalizeDouble(sellline,Digits),0,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("绿线处在当前价下方 Buy单无法设置止盈 或没有Buy单 ");
                        comment("绿线处在当前价下方 Buy单无法设置止盈 或没有Buy单");
                       }
                    }
                  else
                    {
                     if(sellline>Ask && GetHoldingbuyOrdersCount()>0)
                       {
                        Print("Buy单绿线处设置止盈 处理中... ");
                        comment("Buy单绿线处设置止盈 处理中...");
                        PiliangTP(true,NormalizeDouble(sellline,Digits),jianju07tp,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("绿线处在当前价下方 Buy单无法设置止盈 或没有Buy单 ");
                        comment("绿线处在当前价下方 Buy单无法设置止盈 或没有Buy单");
                       }
                    }
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                 }
               lkey=false;
               tkey=false;
              }
            else
              {
               lkey=false;
              }
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP3*2));
               Tensltp(true,false,tensltpweishu,tensltpmax);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP3*2));
               Tensltp(false,false,tensltpweishu,tensltpmax);
               akey=false;
               return;
              }
            else
               akey=false;
            if(gtimeCurrent+2>=TimeCurrent() && gkey==true)
              {
               Print("g=",gkey," 智能buylimit单 处理中. . .");
               comment(" 智能buylimit单 处理中. . .");
               zhinengguadanbuylimit();
               gkey=false;
               return;
              }
            else
               gkey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey," 多单批量上移当前止损",moveSTTP,"个点");
               comment(StringFormat("多单批量上移当前止损%G个点",moveSTTP));
               onlybuy1=true;
               onlyup=true;
               movesttp();
               onlybuy1=false;
               onlyup=false;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey," 空单批量上移当前止损",moveSTTP,"个点");
               comment(StringFormat("空单批量上移当前止损%G个点",moveSTTP));
               onlysell1=true;
               onlystp=true;
               movesttp();
               onlybuy1=false;
               onlystp=false;
               skey=false;
              }
            else
               skey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" o=",okey," 整数位批量挂buylimit单抓回撤 处理中 . . . ");
               comment("整数位批量挂buylimit单抓回撤 处理中 . . . ");
               Tenguadan(true,tenweishu,tenmax);
               okey=false;
               return;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" k=",kkey," 整数位批量挂selllimit单抓回撤 处理中 . . . ");
               comment("整数位批量挂selllimit单抓回撤 处理中 . . . ");
               Tenguadan(false,tenweishu,tenmax);
               kkey=false;
               return;
              }
            else
               kkey=false;
           }
         break;
         case 33://F jian
           {

            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey,"多单批量快捷止损均价下方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("多单批量快捷止损均价下方%G个点 处理中 . . .",zhinengSLTP3*2));
               Tensltp(true,true,tensltpweishu,tensltpmax);
               vkey=false;
               return;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey,"空单批量快捷止损均价上方",zhinengSLTP3*2,"个点 处理中 . . .");
               comment(StringFormat("空单批量快捷止损均价上方%G个点 处理中 . . .",zhinengSLTP3*2));
               Tensltp(false,true,tensltpweishu,tensltpmax);
               akey=false;
               return;
              }
            else
               akey=false;
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey," 多单批量下移当前止损",moveSTTP,"个点");
               comment(StringFormat("多单批量下移当前止损%G个点",moveSTTP));
               onlybuy1=true;
               onlystp=true;
               movesttp();
               onlybuy1=false;
               onlystp=false;
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey," 空单批量下移当前止损",moveSTTP,"个点");
               comment(StringFormat("空单批量下移当前止损%G个点",moveSTTP));
               onlysell1=true;
               onlydown=true;
               movesttp();
               onlybuy1=false;
               onlydown=false;
               skey=false;
              }
            else
               skey=false;
            if(otimeCurrent+2>=TimeCurrent() && okey==true)
              {
               Print(" o=",okey," 计算最近的最低最高点以斐波那契百分比位挂buylimit单");
               comment("计算最近的最低最高点以斐波那契百分比位挂buylimit单 处理中 . . .");
               Print("计算的最低价",GetiLowest(timeframe08,bars08,beginbar08)," 计算的最高价",GetiHighest(timeframe08,bars08,beginbar08)," 偏移量",fibbuypianyiliang);
               Fibguadan(0,GetiLowest(timeframe07,bars07,beginbar07),GetiHighest(timeframe08,bars08,beginbar08));
               okey=false;
              }
            else
               okey=false;
            if(ktimeCurrent+2>=TimeCurrent() && kkey==true)
              {
               Print(" k=",kkey," 计算最近的最低最高点以斐波那契百分比位挂selllimit单");
               comment("计算最近的最低最高点以斐波那契百分比位挂selllimit单 处理中 . . .");
               Print("计算的最低价",GetiLowest(timeframe08,bars08,beginbar08)," 计算的最高价",GetiHighest(timeframe07,bars07,beginbar07)," 偏移量",fibsellpianyiliang);
               Fibguadan(1,GetiLowest(timeframe08,bars08,beginbar08),GetiHighest(timeframe07,bars07,beginbar07));
               kkey=false;
              }
            else
               kkey=false;
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {

               if(ObjectFind("Buy Line")==0 && linebuyfansuo==false)
                 {
                  if(shiftRtimeCurrent+3>=TimeCurrent())
                    {
                     if(buyline>Bid)
                       {
                        int aa1=OrderSend(Symbol(),OP_SELLLIMIT,CGetbuyLots(),buyline,0,0,0,NULL,0,0,CLR_NONE);
                        if(aa1>0)
                          {
                           Print("订单编号= ",aa1);
                           PlaySound("ok.wav");
                           comment("反锁单挂单成功");
                          }
                        else
                          {
                           PlaySound("timeout.wav");
                           comment("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                          }
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        shiftR=false;
                       }
                     else
                       {
                        int aa1=OrderSend(Symbol(),OP_SELLSTOP,CGetbuyLots(),buyline,0,0,0,NULL,0,0,CLR_NONE);
                        if(aa1>0)
                          {
                           Print("订单编号= ",aa1);
                           PlaySound("ok.wav");
                           comment("反锁单挂单成功");
                          }
                        else
                          {
                           PlaySound("timeout.wav");
                           comment("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                          }
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        shiftR=false;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        yijianFanshou=true;
                        linelock=true;
                        Print("触及横线平仓后 反手开仓 开启");
                        comment("触及横线平仓后 反手开仓 开启");
                       }
                     else
                       {
                        linebuyfansuo=true;
                        linelock=true;
                        Print("触及横线开仓反锁 开启");
                        comment("触及横线开仓反锁 开启");
                       }
                    }
                 }
               else
                 {
                  if(linebuyfansuo)
                    {
                     linebuyfansuo=false;
                     linelock=false;
                     Print("触及横线开仓反锁 关闭");
                     comment("触及横线开仓反锁 关闭");
                    }
                 }
               if(ObjectFind("Sell Line")==0 && linesellfansuo==false)
                 {
                  if(shiftRtimeCurrent+3>=TimeCurrent())
                    {
                     if(sellline>Bid)
                       {
                        int aa2=OrderSend(Symbol(),OP_BUYSTOP,CGetsellLots(),sellline,0,0,0,NULL,0,0,CLR_NONE);
                        if(aa2>0)
                          {
                           Print("订单编号= ",aa2);
                           PlaySound("ok.wav");
                           comment("反锁单挂单成功");
                          }
                        else
                          {
                           PlaySound("timeout.wav");
                           comment("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                          }
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        shiftR=false;
                       }
                     else
                       {
                        int aa2=OrderSend(Symbol(),OP_BUYLIMIT,CGetsellLots(),sellline,0,0,0,NULL,0,0,CLR_NONE);
                        if(aa2>0)
                          {
                           Print("订单编号= ",aa2);
                           PlaySound("ok.wav");
                           comment("反锁单挂单成功");
                          }
                        else
                          {
                           PlaySound("timeout.wav");
                           comment("请注意BUY单用红线反锁 Sell单用蓝线反锁 反锁挂单失败");
                          }
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                        shiftR=false;
                       }
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        yijianFanshou=true;
                        linelock=true;
                        Print("触及横线平仓后 反手开仓 开启");
                        comment("触及横线平仓后 反手开仓 开启");
                       }
                     else
                       {
                        linesellfansuo=true;
                        linelock=true;
                        Print("触及横线开仓反锁 开启");
                        comment("触及横线开仓反锁 开启");
                       }
                    }
                 }
               else
                 {
                  if(linesellfansuo)
                    {
                     linesellfansuo=false;
                     linelock=false;
                     Print("触及横线开仓反锁 关闭");
                     comment("触及横线开仓反锁 关闭");
                    }
                 }
               lkey=false;
               fkey=false;
              }
            else
              {
               lkey=false;
              }
           }
         break;
         case 19://R jian
           {

           }
         break;
         case 30://A jian
           {
            if(linelock==false)
              {
               if(ctrltimeCurrent+20>=TimeCurrent())
                 {
                  Print("ctrl+A执行 bar=",linebar01);
                  if(ObjectFind("Buy Line")==0)
                    {
                     comment(StringFormat("当前K线%G 横线在开盘价",linebar01+1));
                     double buyline1=Open[linebar01+1];
                     ObjectMove(0,"Buy Line",0,Time[linebar01+1],buyline1);
                     buyline=buyline1;
                     akey=false;
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     comment(StringFormat("当前K线%G 横线在开盘价",linebar01+1));
                     double sellline1=Open[linebar01+1];
                     ObjectMove(0,"Sell Line",0,Time[linebar01+1],sellline1);
                     sellline=sellline1;
                     akey=false;
                    }
                  linebar01++;
                 }
               else
                 {
                  if(ctrlRtimeCurrent+15>=TimeCurrent())
                    {
                     Print("ctrlR+A执行 bar=",linebar01+1);
                     comment(StringFormat("当前K线%G 计算最高最低的中间值划线",linebar01+1));
                     if(ObjectFind("Buy Line")==0)
                       {
                        double buyline1=(Low[linebar01+1]+High[linebar01+1])/2;
                        ObjectMove(0,"Buy Line",0,Time[linebar01+1],buyline1);
                        buyline=buyline1;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        double sellline1=(Low[linebar01+1]+High[linebar01+1])/2;
                        ObjectMove(0,"Sell Line",0,Time[linebar01+1],sellline1);
                        sellline=sellline1;
                        akey=false;
                       }
                     linebar01++;
                    }
                  else
                    {
                     Print("A执行 bar=",linebar01);
                     if(ObjectFind("Buy Line")==0)
                       {
                        comment(StringFormat("当前K线%G 计算最低值划线",linebar01+1));
                        double buyline1=Low[linebar01+1];
                        ObjectMove(0,"Buy Line",0,Time[linebar01+1],buyline1);
                        buyline=buyline1;
                        akey=false;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        comment(StringFormat("当前K线%G 计算最高值划线",linebar01+1));
                        double sellline1=High[linebar01+1];
                        ObjectMove(0,"Sell Line",0,Time[linebar01+1],sellline1);
                        sellline=sellline1;
                        akey=false;
                       }
                     linebar01++;
                    }
                 }
              }
            else
              {
               Print("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               comment("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               akey=false;
              }
           }
         break;
         case 32://D jian
           {
            if(linelock==false)
              {
               if(ctrltimeCurrent+20>=TimeCurrent())
                 {
                  if(linebar01==0)
                     linebar01=1;
                  if(ObjectFind("Buy Line")==0)
                    {
                     Print("ctrl+D执行 bar=",linebar01-1);
                     comment(StringFormat("当前K线%G 横线在开盘价 ",linebar01-1));
                     double buyline2=Open[linebar01-1];
                     ObjectMove(0,"Buy Line",0,Time[linebar01-1],buyline2);
                     buyline=buyline2;
                     dkey=false;
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     Print("ctrl+D执行 bar=",linebar01-1);
                     comment(StringFormat("当前K线%G 横线在开盘价",linebar01-1));
                     double sellline2=Open[linebar01-1];
                     ObjectMove(0,"Sell Line",0,Time[linebar01-1],sellline2);
                     sellline=sellline2;
                     dkey=false;
                    }
                  linebar01--;
                 }
               else
                 {
                  if(ctrlRtimeCurrent+15>=TimeCurrent())
                    {
                     Print("ctrlR+D执行 bar=",linebar01-1);
                     comment(StringFormat("当前K线%G 计算最高最低的中间值划线",linebar01-1));
                     if(linebar01==0)
                        linebar01=1;
                     if(ObjectFind("Buy Line")==0)
                       {
                        double buyline2=(Low[linebar01-1]+High[linebar01-1])/2;
                        ObjectMove(0,"Buy Line",0,Time[linebar01-1],buyline2);
                        buyline=buyline2;
                        dkey=false;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        double sellline2=(Low[linebar01-1]+High[linebar01-1])/2;
                        ObjectMove(0,"Sell Line",0,Time[linebar01-1],sellline2);
                        sellline=sellline2;
                        dkey=false;
                       }
                     linebar01--;
                    }
                  else
                    {
                     if(linebar01==0)
                        linebar01=1;
                     if(ObjectFind("Buy Line")==0)
                       {
                        Print("D执行 bar=",linebar01-1);
                        comment(StringFormat("当前K线%G 计算最低值划线",linebar01-1));
                        double buyline2=Low[linebar01-1];
                        ObjectMove(0,"Buy Line",0,Time[linebar01-1],buyline2);
                        buyline=buyline2;
                        dkey=false;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        Print("D执行 bar=",linebar01-1);
                        comment(StringFormat("当前K线%G 计算最高值划线",linebar01-1));
                        double sellline2=High[linebar01-1];
                        ObjectMove(0,"Sell Line",0,Time[linebar01-1],sellline2);
                        sellline=sellline2;
                        dkey=false;
                       }
                     linebar01--;
                    }
                 }
              }
            else
              {
               Print("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               comment("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               dkey=false;
              }
           }
         break;
         case 17://W jian
           {
            if(linelock==false)
              {
               if(ctrltimeCurrent+5>=TimeCurrent())
                 {
                  if(ObjectFind("Buy Line")==0)
                    {
                     ObjectMove(0,"Buy Line",0,Time[linebar],buyline+linepianyi*0.5*Point);
                     buyline=buyline+linepianyi*0.5*Point;
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     ObjectMove(0,"Sell Line",0,Time[linebar],sellline+linepianyi*0.5*Point);
                     sellline=sellline+linepianyi*0.5*Point;
                    }
                 }
               else
                 {
                  if(ObjectFind("SL Line")==0)
                    {
                     if(ObjectFind("SL Line")==0)
                       {
                        ObjectMove(0,"SL Line",0,Time[linebar],slline+linepianyi*Point);
                        slline=slline+linepianyi*Point;
                       }
                    }
                  else
                    {
                     if(ObjectFind("Buy Line")==0)
                       {
                        ObjectMove(0,"Buy Line",0,Time[linebar],buyline+linepianyi*Point);
                        buyline=buyline+linepianyi*Point;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        ObjectMove(0,"Sell Line",0,Time[linebar],sellline+linepianyi*Point);
                        sellline=sellline+linepianyi*Point;
                       }
                    }
                 }
              }
            else
              {
               Print("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               comment("无法移动横线 当前有任务在监控中 请先关闭相应开关");
              }
           }
         break;
         case 18://E jian
           {
            if(ObjectFind("Buy Line")==0)
              {
               buyline=NormalizeDouble(buyline,Digits-1);
               Print("横线位置舍弃最后一位小数");
               comment("横线位置舍弃最后一位小数");
              }
            if(ObjectFind("Sell Line")==0)
              {
               sellline=NormalizeDouble(sellline,Digits-1);
               Print("横线位置舍弃最后一位小数");
               comment("横线位置舍弃最后一位小数");
              }
           }
         break;
         case 48://B jian
           {

           }
         break;
         case 52://> jian 多单剥头皮
           {
            if(tabtimeCurrent+1>TimeCurrent() && Tickmode==false)
              {
               Tickmode=true;
               timeGMTSeconds1=SL5mtimeGMTSeconds1;
               GraduallyNum=SL5mlineGraduallyNum;
               stoploss=SL5mlinestoploss;
               takeprofit=SL5mlinetakeprofit;
               TrailingStop=SL5mlineTrailingStop;
               SL1mbuyLine=true;
               SL5mbuyLine=true;
               SL15mbuyLine=true;
               SLbuylinepingcang=true;
               bars097=3;//Shift 带止损下单计算K线减小
               buypianyiliang=30;//  Shift 带止损下单偏移减小
               sellpianyiliang=30;// Shift 带止损下单偏移减小
               SL1mbuyLineprice=iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,SL1mlinetimeframe,0))-SLbuylinepianyi*Point;//初始化
               SL5mbuyLineprice=iLow(NULL,PERIOD_M5,iLowest(NULL,PERIOD_M5,MODE_LOW,SL5mlinetimeframe,0))-SLbuylinepianyi*Point;
               SL5mbuyLineprice=iLow(NULL,PERIOD_M15,iLowest(NULL,PERIOD_M15,MODE_LOW,SL5mlinetimeframe,0))-SLbuylinepianyi*Point;
               SL1mbuyLineprice=Ask-500*Point;
               SL5mbuyLineprice=Ask-500*Point;
               SL15mbuyLineprice=Ask-500*Point;
               Print("Tick分步平仓启动 多单 止盈止损已修改为剥头皮模式");
               comment("Tick分步平仓启动 多单 止盈止损已修改为剥头皮模式");
               return;
              }
            else
              {
               if(tabtimeCurrent+1>TimeCurrent())
                 {
                  Tickmode=false;
                  timeGMTSeconds1=180;
                  GraduallyNum=5;
                  stoploss=320;
                  takeprofit=500;
                  TrailingStop=340;
                  SL1mbuyLine=false;
                  SL5mbuyLine=false;
                  SL15mbuyLine=false;
                  SLbuylinepingcang=false;
                  SL1msellLine=false;
                  SL5msellLine=false;
                  SL15msellLine=false;
                  SLselllinepingcang=false;
                  bars097=7;//Shift 带止损下单计算K线减小
                  buypianyiliang=50;//  Shift 带止损下单偏移减小
                  sellpianyiliang=50;// Shift 带止损下单偏移减小

                  SLbuylineQpingcang=false;
                  SLselllineQpingcang=false;
                  SLbuylineQpingcangT=false;
                  SLselllineQpingcangT=false;
                  timeseconds=2;
                  if(ObjectFind(0,"SLsellQpengcangline")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  if(ObjectFind(0,"SLsellQpengcangline1")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");

                  if(ObjectFind(0,"SL1mbuyLine")==0)
                     ObjectDelete(0,"SL1mbuyLine");
                  if(ObjectFind(0,"SL5mbuyLine")==0)
                     ObjectDelete(0,"SL5mbuyLine");
                  if(ObjectFind(0,"SL15mbuyLine")==0)
                     ObjectDelete(0,"SL15mbuyLine");
                  if(ObjectFind(0,"SL1msellLine")==0)
                     ObjectDelete(0,"SL1msellLine");
                  if(ObjectFind(0,"SL5msellLine")==0)
                     ObjectDelete(0,"SL5msellLine");
                  if(ObjectFind(0,"SL15msellLine")==0)
                     ObjectDelete(0,"SL15msellLine");
                  if(ObjectFind(0,"botoupi")==0)
                     ObjectDelete(0,"botoupi");
                  Print("Tick分步平仓关闭  止盈止损已修改为正常模式");
                  comment("Tick分步平仓关闭  止盈止损已修改为正常模式");
                  return;
                 }
              }
            if(Tickmode)
              {
               if(SL1mbuyLine)
                 {
                  SL1mbuyLine=false;
                  SL1mbuyLineprice=Ask-1000*Point;
                  if(ObjectFind(0,"SL1mbuyLine")==0)
                     ObjectDelete(0,"SL1mbuyLine");
                  Print("一分钟止损横线取消 ");
                  comment("一分钟止损横线取消");
                 }
               else
                 {
                  if(SL5mbuyLine)
                    {
                     SL5mbuyLine=false;
                     SL5mbuyLineprice=Ask-1000*Point;
                     if(ObjectFind(0,"SL5mbuyLine")==0)
                        ObjectDelete(0,"SL5mbuyLine");
                     Print("五分钟止损横线取消 ");
                     comment("五分钟止损横线取消");
                    }
                  else

                    {
                     if(SL15mbuyLine)
                       {
                        SL15mbuyLine=false;
                        SL15mbuyLineprice=Ask-1000*Point;
                        if(ObjectFind(0,"SL15mbuyLine")==0)
                           ObjectDelete(0,"SL15mbuyLine");
                        Print("十五分钟止损横线取消 ");
                        comment("十五分钟止损横线取消");
                       }
                     else
                       {
                        Tickmode=false;
                        timeGMTSeconds1=100;
                        GraduallyNum=5;
                        stoploss=320;
                        takeprofit=500;
                        TrailingStop=340;
                        SL1mbuyLine=false;
                        SL5mbuyLine=false;
                        SL15mbuyLine=false;
                        SLbuylinepingcang=false;
                        SL1msellLine=false;
                        SL5msellLine=false;
                        SL15msellLine=false;
                        SLselllinepingcang=false;
                        bars097=7;//Shift 带止损下单计算K线减小
                        buypianyiliang=50;//  Shift 带止损下单偏移减小
                        sellpianyiliang=50;// Shift 带止损下单偏移减小
                        SLbuylineQpingcang=false;
                        SLselllineQpingcang=false;
                        SLbuylineQpingcangT=false;
                        SLselllineQpingcangT=false;
                        timeseconds=2;
                        if(ObjectFind(0,"SLsellQpengcangline")==0)
                           ObjectDelete(0,"SLsellQpengcangline");
                        if(ObjectFind(0,"SLbuyQpengcangline")==0)
                           ObjectDelete(0,"SLbuyQpengcangline");
                        if(ObjectFind(0,"SLsellQpengcangline1")==0)
                           ObjectDelete(0,"SLsellQpengcangline");
                        if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                           ObjectDelete(0,"SLbuyQpengcangline");
                        if(ObjectFind(0,"SL1mbuyLine")==0)
                           ObjectDelete(0,"SL1mbuyLine");
                        if(ObjectFind(0,"SL5mbuyLine")==0)
                           ObjectDelete(0,"SL5mbuyLine");
                        if(ObjectFind(0,"SL15mbuyLine")==0)
                           ObjectDelete(0,"SL15mbuyLine");
                        if(ObjectFind(0,"SL1msellLine")==0)
                           ObjectDelete(0,"SL1msellLine");
                        if(ObjectFind(0,"SL5msellLine")==0)
                           ObjectDelete(0,"SL5msellLine");
                        if(ObjectFind(0,"SL15msellLine")==0)
                           ObjectDelete(0,"SL15msellLine");
                        if(ObjectFind(0,"botoupi")==0)
                           ObjectDelete(0,"botoupi");
                        Print("Tick分步平仓关闭  止盈止损已修改为正常模式");
                        comment("Tick分步平仓关闭  止盈止损已修改为正常模式");
                       }
                    }
                 }
              }
           }
         break;
         case 51://< jian 空单剥头皮
           {
            if(tabtimeCurrent+1>=TimeCurrent() && Tickmode==false)
              {
               Tickmode=true;
               timeGMTSeconds1=SL5mtimeGMTSeconds1;
               GraduallyNum=SL5mlineGraduallyNum;
               stoploss=SL5mlinestoploss;
               takeprofit=SL5mlinetakeprofit;
               TrailingStop=SL5mlineTrailingStop;
               SL1msellLine=true;
               SL5msellLine=true;
               SL15msellLine=true;
               SLselllinepingcang=true;
               bars097=3;//Shift 带止损下单计算K线减小
               buypianyiliang=30;//  Shift 带止损下单偏移减小
               sellpianyiliang=30;// Shift 带止损下单偏移减小
               SL1msellLineprice=iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,SL1mlinetimeframe,0))+SLselllinepianyi*Point;//初始化
               SL5msellLineprice=iHigh(NULL,PERIOD_M5,iHighest(NULL,PERIOD_M5,MODE_HIGH,SL5mlinetimeframe,0))+SLselllinepianyi*Point;
               SL15msellLineprice=iHigh(NULL,PERIOD_M15,iHighest(NULL,PERIOD_M15,MODE_HIGH,SL15mlinetimeframe,0))+SLselllinepianyi*Point;
               SL1msellLineprice=Bid+500*Point;
               SL5msellLineprice=Bid+500*Point;
               SL15msellLineprice=Bid+500*Point;
               Print("Tick分步平仓启动 空单 止盈止损已修改为剥头皮模式");
               comment("Tick分步平仓启动 空单 止盈止损已修改为剥头皮模式");
               return;
              }
            else
              {
               if(tabtimeCurrent+1>=TimeCurrent())
                 {
                  Tickmode=false;
                  timeGMTSeconds1=100;
                  GraduallyNum=5;
                  stoploss=320;
                  takeprofit=500;
                  TrailingStop=340;
                  SL1mbuyLine=false;
                  SL5mbuyLine=false;
                  SL15mbuyLine=false;
                  SLbuylinepingcang=false;
                  SL1msellLine=false;
                  SL5msellLine=false;
                  SL15msellLine=false;
                  SLselllinepingcang=false;
                  bars097=7;//Shift 带止损下单计算K线减小
                  buypianyiliang=50;//  Shift 带止损下单偏移减小
                  sellpianyiliang=50;// Shift 带止损下单偏移减小
                  SLbuylineQpingcang=false;
                  SLselllineQpingcang=false;
                  SLbuylineQpingcangT=false;
                  SLselllineQpingcangT=false;
                  timeseconds=2;
                  if(ObjectFind(0,"SLsellQpengcangline")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  if(ObjectFind(0,"SLsellQpengcangline1")==0)
                     ObjectDelete(0,"SLsellQpengcangline");
                  if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                     ObjectDelete(0,"SLbuyQpengcangline");
                  if(ObjectFind(0,"SL1mbuyLine")==0)
                     ObjectDelete(0,"SL1mbuyLine");
                  if(ObjectFind(0,"SL5mbuyLine")==0)
                     ObjectDelete(0,"SL5mbuyLine");
                  if(ObjectFind(0,"SL15mbuyLine")==0)
                     ObjectDelete(0,"SL15mbuyLine");
                  if(ObjectFind(0,"SL1msellLine")==0)
                     ObjectDelete(0,"SL1msellLine");
                  if(ObjectFind(0,"SL5msellLine")==0)
                     ObjectDelete(0,"SL5msellLine");
                  if(ObjectFind(0,"SL15msellLine")==0)
                     ObjectDelete(0,"SL15msellLine");
                  if(ObjectFind(0,"botoupi")==0)
                     ObjectDelete(0,"botoupi");
                  Print("Tick分步平仓关闭  止盈止损已修改为正常模式");
                  comment("Tick分步平仓关闭  止盈止损已修改为正常模式");
                  return;
                 }
              }
            if(Tickmode)
              {
               if(SL1msellLine)
                 {
                  SL1msellLine=false;
                  SL1msellLineprice=Bid+1000*Point;
                  if(ObjectFind(0,"SL1msellLine")==0)
                     ObjectDelete(0,"SL1msellLine");
                  Print("一分钟止损横线取消 ");
                  comment("一分钟止损横线取消");
                 }
               else
                 {
                  if(SL5msellLine)
                    {
                     SL5msellLine=false;
                     SL5msellLineprice=Bid+1000*Point;
                     if(ObjectFind(0,"SL5msellLine")==0)
                        ObjectDelete(0,"SL5msellLine");
                     Print("五分钟止损横线取消 ");
                     comment("五分钟止损横线取消");
                    }
                  else
                    {
                     if(SL15msellLine)
                       {
                        SL15msellLine=false;
                        SL15msellLineprice=Bid+1000*Point;
                        if(ObjectFind(0,"SL15msellLine")==0)
                           ObjectDelete(0,"SL15msellLine");
                        Print("十五分钟止损横线取消 ");
                        comment("十五分钟止损横线取消");
                       }
                     else
                       {
                        Tickmode=false;
                        timeGMTSeconds1=100;
                        GraduallyNum=5;
                        stoploss=320;
                        takeprofit=500;
                        TrailingStop=340;
                        SL1mbuyLine=false;
                        SL5mbuyLine=false;
                        SL15mbuyLine=false;
                        SLbuylinepingcang=false;
                        SL1msellLine=false;
                        SL5msellLine=false;
                        SL15msellLine=false;
                        SLselllinepingcang=false;
                        bars097=7;//Shift 带止损下单计算K线减小
                        buypianyiliang=50;//  Shift 带止损下单偏移减小
                        sellpianyiliang=50;// Shift 带止损下单偏移减小
                        SLbuylineQpingcang=false;
                        SLselllineQpingcang=false;
                        SLbuylineQpingcangT=false;
                        SLselllineQpingcangT=false;
                        timeseconds=2;
                        if(ObjectFind(0,"SLsellQpengcangline")==0)
                           ObjectDelete(0,"SLsellQpengcangline");
                        if(ObjectFind(0,"SLbuyQpengcangline")==0)
                           ObjectDelete(0,"SLbuyQpengcangline");
                        if(ObjectFind(0,"SLsellQpengcangline1")==0)
                           ObjectDelete(0,"SLsellQpengcangline");
                        if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                           ObjectDelete(0,"SLbuyQpengcangline");
                        if(ObjectFind(0,"SL1mbuyLine")==0)
                           ObjectDelete(0,"SL1mbuyLine");
                        if(ObjectFind(0,"SL5mbuyLine")==0)
                           ObjectDelete(0,"SL5mbuyLine");
                        if(ObjectFind(0,"SL15mbuyLine")==0)
                           ObjectDelete(0,"SL15mbuyLine");
                        if(ObjectFind(0,"SL1msellLine")==0)
                           ObjectDelete(0,"SL1msellLine");
                        if(ObjectFind(0,"SL5msellLine")==0)
                           ObjectDelete(0,"SL5msellLine");
                        if(ObjectFind(0,"SL15msellLine")==0)
                           ObjectDelete(0,"SL15msellLine");
                        if(ObjectFind(0,"botoupi")==0)
                           ObjectDelete(0,"botoupi");
                        Print("Tick分步平仓关闭  止盈止损已修改为正常模式");
                        comment("Tick分步平仓关闭  止盈止损已修改为正常模式");
                       }
                    }
                 }
              }
           }
         break;
         case 16://Q jian
           {
            if(ObjectFind(0,"Sell Line")==0)
              {
               ObjectDelete(0,"Sell Line");
               ObjectDelete(0,"SL Line");
               linebar01=linebar;
               linebuykaicang=false;
               linebuypingcang=false;
               linebuyfansuo=false;
               linesellkaicang=false;
               linesellpingcang=false;
               linesellfansuo=false;
               yijianFanshou=false;
               linelock=false;
               lkey=false;
               linebuyzidongjiacang=false;
               linesellzidongjiacang=false;
               linebuypingcangR=false;
               linesellpingcangR=false;
               linebuypingcangC=false;
               linesellpingcangC=false;
               linebuypingcangctrlR=false;
               linesellpingcangctrlR=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               linekaicangT=false;
               timeseconds1=timeseconds1P;
               pingcangdingdanshu=1000;
               return;
              }
            if(ObjectFind("Buy Line")==0)
              {
               ObjectDelete(0,"Buy Line");
               sellline=High[iHighest(NULL,0,MODE_HIGH,linebar,0)];
               SetLevel("Sell Line",sellline,ForestGreen);
               selllineOnTimer=Bid;
              }
            else
              {
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               buyline=Low[iLowest(NULL,0,MODE_LOW,linebar,0)];
               SetLevel("Buy Line",buyline,Red);
               buylineOnTimer=Bid;
              }
           }
         break;
         case 45://X jian
           {
            if(ObjectFind("SL Line")==0)
              {
               ObjectDelete(0,"SL Line");
              }
            else
              {
               if(ObjectFind("Buy Line")==0)
                 {
                  slline=buyline-70*Point;
                  SetLevel("SL Line",slline,FireBrick);
                 }
               if(ObjectFind("Sell Line")==0)
                 {
                  slline=sellline+70*Point;
                  SetLevel("SL Line",slline,FireBrick);
                 }
              }
           }
         break;
         case 31://S jian
           {
            if(linelock==false)
              {
               if(ctrltimeCurrent+5>=TimeCurrent())
                 {
                  if(ObjectFind("Buy Line")==0)
                    {
                     ObjectMove(0,"Buy Line",0,Time[linebar],buyline-linepianyi*0.5*Point);
                     buyline=buyline-linepianyi*0.5*Point;
                     skey=false;
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     ObjectMove(0,"Sell Line",0,Time[linebar],sellline-linepianyi*0.5*Point);
                     sellline=sellline-linepianyi*0.5*Point;
                     skey=false;
                    }
                 }
               else
                 {
                  if(ObjectFind("SL Line")==0)
                    {
                     if(ObjectFind("SL Line")==0)
                       {
                        ObjectMove(0,"SL Line",0,Time[linebar],slline-linepianyi*Point);
                        slline=slline-linepianyi*Point;
                        skey=false;
                       }
                    }
                  else
                    {
                     if(ObjectFind("Buy Line")==0)
                       {
                        ObjectMove(0,"Buy Line",0,Time[linebar],buyline-linepianyi*Point);
                        buyline=buyline-linepianyi*Point;
                        skey=false;
                       }
                     if(ObjectFind("Sell Line")==0)
                       {
                        ObjectMove(0,"Sell Line",0,Time[linebar],sellline-linepianyi*Point);
                        sellline=sellline-linepianyi*Point;
                        skey=false;
                       }
                    }
                 }
              }
            else
              {
               Print("无法移动横线 当前有任务在监控中 请先关闭相应开关");
               comment("无法移动横线 当前有任务在监控中 请先关闭相应开关");
              }

            if(gtimeCurrent+1>=TimeCurrent() && gkey==true)
              {
               Print("g=",gkey," s=",skey," 智能selllimit单 处理中. . .");
               comment(" 智能selllimit单 处理中. . .");
               zhinengguadanselllimit();
               gkey=false;
               skey=false;
              }
            else
               gkey=false;
           }
         break;
         case 44://Z jian
           {
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               if(shiftRtimeCurrent+5>=TimeCurrent())
                 {
                  if(ObjectFind("Buy Line")==0)
                    {
                     if(buyline<Ask && GetHoldingbuyOrdersCount()>0)
                       {
                        Print("buyline=",NormalizeDouble(buyline,Digits));
                        Print("Buy单横线处设置统一止损 处理中... ");
                        comment("Buy单横线处设置统一止损 处理中...");
                        PiliangSL(true,NormalizeDouble(buyline,Digits),0,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("红线处在当前价上方 Buy单无法设置止损 或没有Buy单 ");
                        comment("红线处在当前价上方 Buy单无法设置止损 或没有Buy单");
                       }
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     if(sellline>Bid && GetHoldingsellOrdersCount()>0)
                       {
                        Print("sellline=",NormalizeDouble(sellline,Digits));
                        Print("Sell单横线处设置统一止损 处理中... ");
                        comment("Sell单横线处设置统一止损 处理中...");
                        PiliangSL(false,NormalizeDouble(sellline,Digits),0,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("绿线处在当前价下方 Sell单无法设置止损 或没有sell单 ");
                        comment("绿线处在当前价下方 Sell单无法设置止损 或没有sell单");
                       }
                    }
                 }
               else
                 {
                  if(ObjectFind("Buy Line")==0)
                    {
                     if(buyline<Ask && GetHoldingbuyOrdersCount()>0)
                       {
                        Print("buyline=",NormalizeDouble(buyline,Digits));
                        Print("Buy单横线处设置止损 处理中... ");
                        comment("Buy单横线处设置止损 处理中...");
                        PiliangSL(true,NormalizeDouble(buyline,Digits),jianju07,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("红线处在当前价上方 Buy单无法设置止损 或没有sell单 ");
                        comment("红线处在当前价上方 Buy单无法设置止损 或没有sell单");
                       }
                    }
                  if(ObjectFind("Sell Line")==0)
                    {
                     if(sellline>Bid && GetHoldingsellOrdersCount()>0)
                       {
                        Print("sellline=",NormalizeDouble(sellline,Digits));
                        Print("Sell单横线处设置止损 处理中... ");
                        comment("Sell单横线处设置止损 处理中...");
                        PiliangSL(false,NormalizeDouble(sellline,Digits),jianju07,0,juxianjia07,dingdanshu);
                        if(ObjectFind(0,"Buy Line")==0)
                           ObjectDelete(0,"Buy Line");
                        if(ObjectFind(0,"Sell Line")==0)
                           ObjectDelete(0,"Sell Line");
                       }
                     else
                       {
                        PlaySound("timeout.wav");
                        Print("绿线处在当前价下方 Sell单无法设置止损 或没有sell单 ");
                        comment("绿线处在当前价下方 Sell单无法设置止损 或没有sell单");
                       }
                    }
                 }
               lkey=false;
               zkey=false;
              }
            else
              {
               lkey=false;
               if(shiftRtimeCurrent+3>=TimeCurrent())
                 {
                  if(ObjectFind("SL15mbuyLine")==0)
                    {
                     Print("15分钟横线处设置止损 处理中... ");
                     comment("15分钟横线处设置止损 处理中...");
                     PiliangSL(true,NormalizeDouble(SL15mbuyLineprice,Digits),jianju07,0,juxianjia07,dingdanshu);
                    }
                  if(ObjectFind("SL15msellLine")==0)
                    {
                     Print("15分钟横线处设置止损 处理中... ");
                     comment("15分钟横线处设置止损 处理中...");
                     PiliangSL(false,NormalizeDouble(SL15msellLineprice,Digits),jianju07,0,juxianjia07,dingdanshu);
                    }
                 }
               else
                 {
                  if(ObjectFind("SL5mbuyLine")==0)
                    {
                     Print("5分钟横线处设置止损 处理中... ");
                     comment("5分钟横线处设置止损 处理中...");
                     PiliangSL(true,NormalizeDouble(SL5mbuyLineprice,Digits),jianju07,0,juxianjia07,dingdanshu);
                    }
                  if(ObjectFind("SL5msellLine")==0)
                    {
                     Print("5分钟横线处设置止损 处理中... ");
                     comment("5分钟横线处设置止损 处理中...");
                     PiliangSL(false,NormalizeDouble(SL5msellLineprice,Digits),jianju07,0,juxianjia07,dingdanshu);
                    }
                 }
              }
           }
         break;
         case 36://J jian
           {
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单计算最近",bars10,"根K线批量智能止损 处理中 . . . ");
               comment(StringFormat("多单计算最近%G根K线批量智能止损 处理中 . . . ",bars10));
               PiliangSL(true,GetiLowest(timeframe10,bars10,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10,juxianjia10,dingdanshu1);
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单计算最近",bars10,"根K线批量智能止损 处理中 . . .");
               comment(StringFormat("空单计算最近%G根K线批量智能止损 处理中 . . . ",bars10));
               PiliangSL(false,GetiHighest(timeframe10,bars10,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10,juxianjia10,dingdanshu1);
               skey=false;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print(" v=",vkey,"多单智能设置统一止损位 处理中 . . .");
               comment("多单智能设置统一止损位 处理中 . . . ");
               PiliangSL(true,GetiLowest(timeframe06,bars06,beginbar06)-MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju06,pianyiliang06,juxianjia06,dingdangeshu06);
               vkey=false;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print(" a=",akey,"空单智能设置统一止损位 处理中 . . .");
               comment("空单智能设置统一止损位 处理中 . . . ");
               PiliangSL(false,GetiHighest(timeframe06,bars06,beginbar06)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju06,pianyiliang06,juxianjia06,dingdangeshu06);
               akey=false;
              }
            else
               akey=false;
           }
         break;
         case 37://K jian
           {
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               if(ObjectFind("Buy Line")==0 && linebuykaicang==false)
                 {
                  //Print(shiftRtimeCurrent," ",TimeCurrent());
                  if(shiftRtimeCurrent+5>=TimeCurrent())
                    {
                     linekaicangshiftR=true;
                     linebuykaicang=true;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR+rightpress;
                     timeseconds1=timeseconds1P+leftpress;
                     linelock=true;
                     Print("触及横线开Buy单 开启 参考价格和时间 开仓",huaxiankaicanggeshuR1,"次");
                     comment(StringFormat("触及横线开Buy单 开启 越过价格%G开仓 间隔%G秒 开仓%G次",buyline,timeseconds1,huaxiankaicanggeshuR1));
                     shiftR=false;
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        linebuykaicang=true;
                        linekaicangT=true;
                        huaxiankaicanggeshuT1=huaxiankaicanggeshuT+rightpress;
                        huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*500;
                        if(huaxiankaicangtimeTP<0)
                           huaxiankaicangtimeTP=0;
                        shangpress=0;
                        xiapress=0;
                        linelock=true;
                        Print("触及横线开Buy单 不带止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
                        comment(StringFormat("触及不带止损开Buy单 参考时间和价位 开仓%G次 间隔%G毫秒",huaxiankaicanggeshuT1,huaxiankaicangtimeTP));
                        ctrlR=false;
                       }
                     else
                       {
                        if(ObjectFind(0,"SL Line")==0)
                          {
                           linebuykaicang=true;
                           linekaicangT=true;
                           huaxiankaicanggeshuT1=huaxiankaicanggeshuT+rightpress;
                           huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*500;
                           if(huaxiankaicangtimeTP<0)
                              huaxiankaicangtimeTP=0;
                           shangpress=0;
                           xiapress=0;
                           linelock=true;
                           Print("触及横线开Buy单止损线止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
                           comment(StringFormat("触及横线开Buy单止损线止损 开启 参考时间和价位 开仓%G次",huaxiankaicanggeshuT1));
                          }
                        else
                          {
                           linebuykaicang=true;
                           huaxiankaicanggeshu1=huaxiankaicanggeshu+rightpress;
                           huaxiankaicangtimeP=huaxiankaicangtime+(shangpress-xiapress)*500;
                           if(huaxiankaicangtimeP<0)
                              huaxiankaicangtimeP=0;
                           shangpress=0;
                           xiapress=0;
                           linelock=true;
                           Print("触及横线开Buy单 开启 只参考时间 开仓",huaxiankaicanggeshu1,"次");
                           comment(StringFormat("触及横线开Buy单 开启 只参考时间开仓间隔%G秒 开仓%G次",timeseconds1,huaxiankaicanggeshu1));
                          }

                       }
                    }
                 }
               else
                 {
                  if(linebuykaicang)
                    {
                     linebuykaicang=false;
                     linekaicangshiftR=false;
                     linekaicangT=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     huaxiankaicanggeshu1=huaxiankaicanggeshu;
                     huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
                     timeseconds1=timeseconds1P;
                     linelock=false;
                     Print("触及横线开Buy单 关闭");
                     comment("触及横线开Buy单 关闭");
                    }
                 }
               if(ObjectFind("Sell Line")==0 && linesellkaicang==false)
                 {
                  if(shiftRtimeCurrent+3>=TimeCurrent())
                    {
                     linekaicangshiftR=true;
                     linesellkaicang=true;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR+rightpress;
                     timeseconds1=timeseconds1P+leftpress;
                     linelock=true;
                     Print("触及横线开Sell单 开启 参考价格和时间 开仓",huaxiankaicanggeshuR1,"次");
                     comment(StringFormat("触及横线开Sell单 开启 越过价格%G开仓 间隔%G秒 开仓%G次",sellline,timeseconds1,huaxiankaicanggeshuR1));
                     shiftR=false;
                    }
                  else
                    {
                     if(ctrlRtimeCurrent+3>=TimeCurrent())
                       {
                        linesellkaicang=true;
                        linekaicangT=true;
                        huaxiankaicanggeshuT1=huaxiankaicanggeshuT+rightpress;
                        huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*500;
                        if(huaxiankaicangtimeTP<0)
                           huaxiankaicangtimeTP=0;
                        shangpress=0;
                        xiapress=0;
                        linelock=true;
                        Print("触及横线开sell单 不带止损 开启 参考时间和价位 开仓",huaxiankaicanggeshuT1,"次");
                        comment(StringFormat("触及不带止损开sell单 参考时间和价位 开仓%G次 间隔%G毫秒",huaxiankaicanggeshuT1,huaxiankaicangtimeTP));
                        ctrlR=false;
                       }
                     else
                       {
                        if(ObjectFind(0,"SL Line")==0)
                          {
                           linesellkaicang=true;
                           linekaicangT=true;
                           huaxiankaicanggeshuT1=huaxiankaicanggeshuT+rightpress;
                           huaxiankaicangtimeTP=huaxiankaicangtimeT+(shangpress-xiapress)*500;
                           if(huaxiankaicangtimeTP<0)
                              huaxiankaicangtimeTP=0;
                           shangpress=0;
                           xiapress=0;
                           linelock=true;
                           Print("触及横线开Sell单止损线止损 开启 参考时间和价格 开仓",huaxiankaicanggeshuT1,"次");
                           comment(StringFormat("触及横线开Sell单止损线止损 开启 参考时间和价格 开仓%G次",huaxiankaicanggeshuT1));
                          }
                        else
                          {
                           linesellkaicang=true;
                           huaxiankaicanggeshu1=huaxiankaicanggeshu+rightpress;
                           huaxiankaicangtimeP=huaxiankaicangtime+(shangpress-xiapress)*500;
                           if(huaxiankaicangtimeP<0)
                              huaxiankaicangtimeP=0;
                           shangpress=0;
                           xiapress=0;
                           linelock=true;
                           Print("触及横线开Sell单 开启 只参考时间 开仓",huaxiankaicanggeshu1,"次");
                           comment(StringFormat("触及横线开Sell单 开启 只参考时间开仓间隔%G秒 开仓%G次",timeseconds1,huaxiankaicanggeshu1));
                          }
                       }
                    }
                 }
               else
                 {
                  if(linesellkaicang)
                    {
                     linesellkaicang=false;
                     linekaicangshiftR=false;
                     linekaicangT=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     huaxiankaicanggeshu1=huaxiankaicanggeshu;
                     huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
                     timeseconds1=timeseconds1P;
                     linelock=false;
                     Print("触及横线开Sell单 关闭");
                     comment("触及横线开Sell单 关闭");
                    }
                 }
               lkey=false;
               kkey=false;
              }
            else
              {
               lkey=false;
              }
           }
         break;
         case 23://I j
           {
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单计算最近",bars10,"根K线批量智能止盈 处理中 . . .");
               comment(StringFormat("多单计算最近%G根K线批量智能止盈 处理中 . . . ",bars10));
               PiliangTP(true,GetiHighest(timeframe10,bars10,beginbar10)+press(),jianju10tp,pianyiliang10tp,juxianjia10,dingdanshu1);
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单计算最近",bars10,"根K线批量智能止盈 处理中 . . .");
               comment(StringFormat("空单计算最近%G根K线批量智能止盈 处理中 . . . ",bars10));
               PiliangTP(false,GetiLowest(timeframe10,bars10,beginbar10)+(MarketInfo(Symbol(),MODE_SPREAD)+selltp10)*Point+press(),jianju10tp,pianyiliang10tp,juxianjia10,dingdanshu1);
               skey=false;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print(" v=",vkey,"多单智能设置统一止盈位 处理中 . . .");
               comment("多单智能设置统一止盈位 处理中 . . . ");
               PiliangTP(true,GetiHighest(timeframe06,bars06,beginbar06)+press(),jianju06,pianyiliang06tp,juxianjia06,dingdangeshu06);
               vkey=false;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print(" a=",akey,"空单智能设置统一止盈位 处理中 . . .");
               comment("空单智能设置统一止盈位 处理中 . . . ");
               PiliangTP(false,GetiLowest(timeframe06,bars06,beginbar06)+(MarketInfo(Symbol(),MODE_SPREAD)+selltp06)*Point+press(),jianju06,pianyiliang06tp,juxianjia06,dingdangeshu06);
               akey=false;
              }
            else
               akey=false;
           }
         break;
         case 22://U j
           {
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单计算最近",bars1010,"根K线批量智能止盈 处理中 . . .");
               comment(StringFormat("多单计算最近%G根K线批量智能止盈 处理中 . . . ",bars1010));
               PiliangTP(true,GetiHighest(timeframe10,bars1010,beginbar10)+press(),jianju10tp,pianyiliang10tp,juxianjia10,dingdanshu1);
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单计算最近",bars1010,"根K线批量智能止盈 处理中 . . .");
               comment(StringFormat("空单计算最近%G根K线批量智能止盈 处理中 . . . ",bars1010));
               PiliangTP(false,GetiLowest(timeframe10,bars1010,beginbar10)+(MarketInfo(Symbol(),MODE_SPREAD)+selltp10)*Point+press(),jianju10tp,pianyiliang10tp,juxianjia10,dingdanshu1);
               skey=false;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey," 多单批量智能计算在结果的基础上减去点差再加上",pianyiliang05tp,"点止盈 处理中 . . .");
               comment(StringFormat("多单批量智能计算在结果的基础上减去点差再减去%G点止盈 处理中 . . .",pianyiliang05tp));
               PiliangTP(true,GetiHighest(timeframe05,bars05,beginbar05)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju05,pianyiliang05tp,juxianjia05,dingdangeshu05);
               vkey=false;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey," 空单批量智能计算在结果的基础上加上点差再加上",pianyiliang05tp,"点止盈 处理中 . . .");
               comment(StringFormat("空单批量智能计算在结果的基础上加上点差再加上%G点止盈 处理中 . . .",pianyiliang05tp));
               PiliangTP(false,GetiLowest(timeframe05,bars05,beginbar05)+MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju05,pianyiliang05tp,juxianjia05,dingdangeshu05);
               akey=false;
              }
            else
               akey=false;
           }
         break;
         case 35://H j
           {
            if(ltimeCurrent+2>=TimeCurrent() && lkey==true)
              {
               if(ObjectFind("Buy Line")==0 && linebuyzidongjiacang==false)
                 {
                  if(shiftR)
                    {
                     /*
                                          linekaicangshiftR=true;
                                          linebuykaicang=true;
                                          linelock=true;
                                          Print("触及横线开Buy单 开启 只参考价格");
                                          comment("触及横线开Buy单 开启 只参考价格");
                                          shiftR=false;*/
                    }
                  else
                    {
                     linebuyzidongjiacang=true;
                     linelock=true;
                     Print("五分钟自动加仓Buy单 开启 ");
                     comment("五分钟自动加仓Buy单 开启 ");
                    }
                 }
               else
                 {
                  if(linebuyzidongjiacang)
                    {
                     linebuyzidongjiacang=false;
                     linelock=false;
                     huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
                     huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
                     lineTime=false;
                     linetime=0;
                     linefirsttime=true;
                     Print("五分钟自动加仓Buy单 关闭");
                     comment("五分钟自动加仓Buy单 关闭");
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
               if(ObjectFind("Sell Line")==0 && linesellkaicang==false)
                 {
                  if(shiftR)
                    {
                     /*
                                          linekaicangshiftR=true;
                                          linesellkaicang=true;
                                          linelock=true;
                                          Print("触及横线开Sell单 开启 只参考价格");
                                          comment("触及横线开Sell单 开启 只参考价格");
                                          shiftR=false;*/
                    }
                  else
                    {
                     linesellzidongjiacang=true;
                     linelock=true;
                     Print("五分钟自动加仓Sell单 开启");
                     comment("五分钟自动加仓Sell单 开启");
                    }
                 }
               else
                 {
                  if(linesellzidongjiacang)
                    {
                     linesellzidongjiacang=false;
                     linelock=false;
                     Print("五分钟自动加仓Sell单 关闭");
                     comment("五分钟自动加仓Sell单 关闭");
                     huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
                     huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
                     lineTime=false;
                     linetime=0;
                     linefirsttime=true;
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
               lkey=false;
              }
            else
              {
               lkey=false;
              }
            if(btimeCurrent+2>=TimeCurrent() && bkey==true)
              {
               Print("b=",bkey,"多单计算最近",bars1010,"根K线批量智能止损 处理中 . . . ");
               comment(StringFormat("多单计算最近%G根K线批量智能止损 处理中 . . . ",bars1010));
               PiliangSL(true,GetiLowest(timeframe10,bars1010,beginbar10)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju10,pianyiliang10,juxianjia10,dingdanshu1);
               bkey=false;
              }
            else
               bkey=false;
            if(stimeCurrent+2>=TimeCurrent() && skey==true)
              {
               Print("s=",skey,"空单计算最近",bars1010,"根K线批量智能止损 处理中 . . .");
               comment(StringFormat("空单计算最近%G根K线批量智能止损 处理中 . . . ",bars1010));
               PiliangSL(false,GetiHighest(timeframe10,bars1010,beginbar10)+MarketInfo(Symbol(),MODE_SPREAD)*2*Point+press(),jianju10,pianyiliang10,juxianjia10,dingdanshu1);
               skey=false;
              }
            else
               skey=false;
            if(vtimeCurrent+2>=TimeCurrent() && vkey==true)
              {
               Print("v=",vkey," 多单批量智能计算在结果的基础上减去点差再减去",pianyiliang05,"点止损 处理中 . . .");
               comment(StringFormat("多单批量智能计算在结果的基础上减去点差再减去%G点止损 处理中 . . .",pianyiliang05));
               PiliangSL(true,GetiLowest(timeframe05,bars05,beginbar05)-MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju05,pianyiliang05,juxianjia05,dingdangeshu05);
               vkey=false;
              }
            else
               vkey=false;
            if(atimeCurrent+2>=TimeCurrent() && akey==true)
              {
               Print("a=",akey," 空单批量智能计算在结果的基础上加上点差再加上",pianyiliang05,"点止损 处理中 . . .");
               comment(StringFormat("空单批量智能计算在结果的基础上加上点差再加上%G点止损 处理中 . . .",pianyiliang05));
               PiliangSL(false,GetiHighest(timeframe05,bars05,beginbar05)+MarketInfo(Symbol(),MODE_SPREAD)*Point+press(),jianju05,pianyiliang05,juxianjia05,dingdangeshu05);
               akey=false;
              }
            else
               akey=false;
           }
         break;
         case 53://"? / 键"
           {
            huaxianguadanlotsT=MathFloor(huaxianguadanlots*0.5/MarketInfo(Symbol(),MODE_LOTSTEP))*MarketInfo(Symbol(),MODE_LOTSTEP);
            keylotshalf=keylotshalfT;
            Print("挂单默认仓位减半 本提示消失仓位恢复");
            comment(StringFormat("挂单默认仓位减半 %G 手 本提示消失仓位恢复 ",huaxianguadanlotsT));
           }
         break;
         case 83://小键盘 小数点
           {
            if(holdingtime==holdingtimemin)
              {
               holdingtime=holdingtimemax;
               Print("下单自动计算带止损 长时间有效");
               comment("下单自动计算带止损 长时间有效");
              }
            else
              {
               holdingtime=holdingtimemin;
               Print("下单自动计算带止损 短时间有效");
               comment("下单自动计算带止损 短时间有效");
              }
           }
         break;
         default:
            break;
        }
      if(StrToInteger(sparam)==buykey)//市价买一单
        {
         if(shifttimeCurrent+holdingtime>=TimeCurrent())
           {
            buysellnowSL(true,keylotshalf,timeframe09,bars097,beginbar09,buypianyiliang);
           }
         else
           {
            if(buymaxTotallots)
              {
               Print("多单超过EA总手数限制 请手动下单或调整全局参数");
               comment("多单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价买一单 处理中 . . .");
            comment("市价买一单 处理中 . . .");
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
               PlaySound("ok.wav");
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",GetLastError());
              }
           }
        }
      if(StrToInteger(sparam)==sellkey)
        {
         if(shifttimeCurrent+holdingtime>=TimeCurrent())
           {
            buysellnowSL(false,keylotshalf,timeframe09,bars097,beginbar09,sellpianyiliang);
           }
         else
           {
            if(sellmaxTotallots)
              {
               Print("空单超过EA总手数限制 请手动下单或调整全局参数");
               comment("空单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价卖一单 处理中 . . .");
            comment("市价卖一单 处理中 . . .");
            int keysell=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,0,0);
            if(keysell>0)
               PlaySound("ok.wav");
            else
              {
               PlaySound("timeout.wav");
               Print("GetLastError=",GetLastError());
              }
           }
        }
      if(StrToInteger(sparam)==buykeydouble)
        {
         if(shifttimeCurrent+holdingtime>=TimeCurrent())
           {
            buysellnowSL(true,keylotshalf*2,timeframe09,bars097,beginbar09,buypianyiliang);
           }
         else
           {
            if(buymaxTotallots)
              {
               Print("多单超过EA总手数限制 请手动下单或调整全局参数");
               comment("多单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价双倍买一单 处理中 . . .");
            comment("市价双倍买一单 处理中 . . .");
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots*2,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
           }
        }
      if(StrToInteger(sparam)==sellkeydouble)
        {
         if(shifttimeCurrent+holdingtime>=TimeCurrent())
           {
            buysellnowSL(false,keylotshalf*2,timeframe09,bars097,beginbar09,sellpianyiliang);
           }
         else
           {
            if(sellmaxTotallots)
              {
               Print("空单超过EA总手数限制 请手动下单或调整全局参数");
               comment("空单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价双倍卖一单 处理中 . . .");
            comment("市价双倍卖一单 处理中 . . .");
            int keysell=OrderSend(Symbol(),OP_SELL,keylots*2,Bid,keyslippage,0,0,NULL,0,0);
            if(keysell>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
           }
        }
      if(StrToInteger(sparam)==buykey3)
        {
         if(shifttimeCurrent+holdingtime>=TimeCurrent())
           {
            buysellnowSL(true,keylotshalf*3,timeframe09,bars097,beginbar09,buypianyiliang);
           }
         else
           {
            if(buymaxTotallots)
              {
               Print("多单超过EA总手数限制 请手动下单或调整全局参数");
               comment("多单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价三倍仓位买一单 处理中 . . .");
            comment("市价三倍仓位买一单 处理中 . . .");
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots*3,Ask,keyslippage,0,0,NULL,0,0);
            if(keybuy>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
           }
        }
      if(StrToInteger(sparam)==sellkey3)
        {
         if(shifttimeCurrent+holdingtime>=TimeCurrent())
           {
            buysellnowSL(false,keylotshalf*3,timeframe09,bars097,beginbar09,sellpianyiliang);
           }
         else
           {
            if(sellmaxTotallots)
              {
               Print("空单超过EA总手数限制 请手动下单或调整全局参数");
               comment("空单超过EA总手数限制 请手动下单或调整全局参数");
               PlaySound("timeout.wav");
               return;
              }
            Print("市价三倍仓位卖一单 处理中 . . .");
            comment("市价三倍仓位卖一单 处理中 . . .");
            int keysell=OrderSend(Symbol(),OP_SELL,keylots*3,Bid,keyslippage,0,0,NULL,0,0);
            if(keysell>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
           }
        }
      if(StrToInteger(sparam)==zuidaclose)
        {
         Print("平价格最高的一单 处理中 . . .");
         comment("平价格最高的一单 处理中 . . .");
         zuidakeyclose();
        }
      if(StrToInteger(sparam)==zuixiaoclose)
        {
         Print("平价格最低的一单 处理中 . . .");
         comment("平价格最低的一单 处理中 . . .");
         zuixiaokeyclose();
        }
      if(StrToInteger(sparam)==zuizaoclose)
        {
         Print("平最早下的一单 处理中 . . .");
         comment("平最早下的一单 处理中 . . .");
         zuizaokeyclose();
        }
      if(StrToInteger(sparam)==zuijinclose)
        {
         Print("平最近下的一单 处理中 . . .");
         comment("平最近下的一单 处理中 . . .");
         zuijinkeyclose();
        }
      if(StrToInteger(sparam)==8225)//Ctrl+Alt+F 一键反手
        {
         yijianfanshou();
        }
      if(StrToInteger(sparam)==8263)//Ctrl+Alt+小键盘7
        {
         buysellnowSL(true,keylotshalf*3,timeframe09,bars097,beginbar09,buypianyiliang);
        }
      if(StrToInteger(sparam)==8264)//Ctrl+Alt+小键盘8
        {
         buysellnowSL(true,keylotshalf*2,timeframe09,bars097,beginbar09,buypianyiliang);
        }
      if(StrToInteger(sparam)==8267)//Ctrl+Alt+小键盘4
        {
         buysellnowSL(false,keylotshalf*3,timeframe09,bars097,beginbar09,sellpianyiliang);
        }
      if(StrToInteger(sparam)==8268)//Ctrl+Alt+小键盘5
        {
         buysellnowSL(false,keylotshalf*2,timeframe09,bars097,beginbar09,sellpianyiliang);
        }
      if(StrToInteger(sparam)==8265)//Ctrl+Alt+小键盘9
        {
         buysellnowSL(true,keylotshalf,timeframe09,bars096,beginbar09,buypianyiliang9);
        }
      if(StrToInteger(sparam)==8269)//Ctrl+Alt+小键盘6
        {
         buysellnowSL(false,keylotshalf,timeframe09,bars096,beginbar09,sellpianyiliang6);
        }
      if(StrToInteger(sparam)==baobenSL)
        {
         Print("批量移动止损到保本线上 处理中 . . .");
         comment("批量移动止损到保本线上 处理中 . . .");
         double baobenbuySL=NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits);
         double baobensellSL=NormalizeDouble(HoldingOrdersellAvgPrice(),Digits);
         if(bkey)
            buybaobenture=true;
         if(skey)
            sellbaobenture=true;
         for(int  i=0; i<OrdersTotal(); i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
               if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                 {
                  if(sellbaobenture)
                    { }
                  else
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),baobenbuySL,OrderTakeProfit(),0);
                    }
                 }
               if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                 {
                  if(buybaobenture)
                     break;
                  bool om=OrderModify(OrderTicket(),OrderOpenPrice(),baobensellSL,OrderTakeProfit(),0);
                 }
              }
           }
         PlaySound("ok.wav");
         buybaobenture=false;
         sellbaobenture=false;
        }
      if(StrToInteger(sparam)==baobenTP)
        {
         Print("批量移动止盈到保本线上 处理中 . . .");
         comment("批量移动止盈到保本线上 处理中 . . .");
         double baobenbuyTP=NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits);
         double baobensellTP=NormalizeDouble(HoldingOrdersellAvgPrice(),Digits);
         if(bkey)
            buybaobenture=true;
         if(skey)
            sellbaobenture=true;
         for(int  i=0; i<OrdersTotal(); i++)
           {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
               if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                 {
                  if(sellbaobenture)
                    { }
                  else
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),baobenbuyTP,0);
                    }
                 }
               if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                 {
                  if(buybaobenture)
                     break;
                  bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),baobensellTP,0);
                 }
              }
           }
         PlaySound("ok.wav");
         buybaobenture=false;
         sellbaobenture=false;
        }
      if(StrToInteger(sparam)==20)//T
        {
         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("快捷计算最近K线的最低最高价智能计算批量挂BuyLimit单 处理中 . . .");
            comment("快捷计算最近K线的最低最高价智能计算批量挂BuyLimit单 处理中 . . .");
            Guadanbuylimit(Guadanlots1,GetiLowest(0,Guadanprice41,0)+Guadanbuylimitpianyiliang1*Point+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishubuylimit1*Point+press(),Guadangeshu1,Guadanjianju1,Guadansl1,Guadantp1,Guadanjuxianjia1);
            shift=false;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==31)//S
        {
         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("快捷计算最近K线的最低最高价智能计算批量挂SellLimit单 处理中 . . .");
            comment("快捷计算最近K线的最低最高价智能计算批量挂SellLimit单 处理中 . . .");
            Guadanselllimit(Guadanlots1,GetiHighest(0,Guadanprice41,0)-Guadanselllimitpianyiliang1*Point-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishuselllimit1*Point+press(),Guadangeshu1,Guadanjianju1,Guadansl1,Guadantp1,Guadanjuxianjia1);
            shift=false;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==25)//
        {
         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("快捷计算最近K线的最低最高价智能计算批量挂BuyStop单 处理中 . . .");
            comment("快捷计算最近K线的最低最高价智能计算批量挂BuyStop单 处理中 . . .");
            Guadanbuystop(Guadanlots1,GetiHighest(0,Guadanprice41,0)+MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu1*Point+press(),Guadangeshu1,Guadanjianju1,Guadansl1,Guadantp1,Guadanjuxianjia1);
            shift=false;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==38)//
        {
         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("快捷计算最近K线的最低最高价智能计算批量挂SellStop单 处理中 . . .");
            comment("快捷计算最近K线的最低最高价智能计算批量挂SellStop单 处理中 . . .");
            Guadansellstop(Guadanlots1,GetiLowest(0,Guadanprice41,0)-MarketInfo(Symbol(),MODE_SPREAD)*Guadandianchabeishu1*Point+press(),Guadangeshu1,Guadanjianju1,Guadansl1,Guadantp1,Guadanjuxianjia1);
            shift=false;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==34)//G 平挂单
        {

         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("批量平挂单 处理中 . . .");
            comment("批量平挂单 处理中 . . .");
            pingguadan();
            shift=false;
            shifttimeCurrent=shifttimeCurrent-500;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==suoCang)
        {

         if(shifttimeCurrent+1>=TimeCurrent() && shift==true)
           {
            Print("一键锁仓 处理中 . . .");
            comment("一键锁仓 处理中 . . .");
            suocang();
            shift=false;
           }
         else
            shift=false;
        }
      if(StrToInteger(sparam)==fanxiangSuodan)
        {
         if(ctrltimeCurrent+1>=TimeCurrent() && ctrl==true)
           {
            Print("开反向单锁仓 处理中 . . .");
            comment("开反向单锁仓 处理中 . . .");
            fanxiangsuodan();
            ctrl=false;
           }
         else
            ctrl=false;
        }
      if(StrToInteger(sparam)==piliangSLTP)
        {
         if(tabtimeCurrent+1>=TimeCurrent() && tab==true)
           {
            Gradually=false;
            Print("默认批量设置止盈止损5000点 变相取消 仅应急使用  处理中 . . .");
            comment("默认批量设置止盈止损5000点 变相取消 仅应急使用  处理中 . . .");
            StopLoss=5000;
            TargetProfit=5000;
            piliangsltp();
            tab=false;
            StopLoss=0;
            TargetProfit=0;
            FixedStopLoss=0.0;
            FixedTargetProfit=0.0;
            return;
           }
         else
            tab=false;
        }
      if(StrToInteger(sparam)==yijianPingcang)
        {
         Print("一键平仓 处理中 . . .");
         comment("一键平仓 处理中 . . .");
         xunhuanquanpingcang();
         ctrl=false;
        }
      if(StrToInteger(sparam)==yijianPingbuydan)
        {
         Print("一键平buy单 处理中 . . .");
         comment("一键平buy单 处理中 . . .");
         yijianpingbuydan();
         ctrl=false;
        }
      if(StrToInteger(sparam)==yijianPingselldan)
        {
         Print("一键平sell单 处理中 . . .");
         comment("一键平sell单 处理中 . . .");
         yijianpingselldan();
         ctrl=false;
        }
     }
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()//ttt
  {
   //Print(ctrlRtimeCurrent," ",TimeCurrent());
//Print("timertrue=",timertrue);
//Print("TICK ",TimeGMT());
//Print("Ask ",Ask);
//Print("Bid ",Bid);
//  Print(TimeSeconds(TimeGMT()));
   if(EAswitch==false)
     {
      return;
     }
   if(huaxianguadan)//划线挂单
     {
      Huaxianguadan();
     }
   if(huaxiankaicang)//触及线开仓
     {
      Huaxiankaicang();
     }
   if(huaxianSwitch)
     {
      HuaxianSwitch();
     }
   if(linebuykaicang && buyline>=Ask)//触及横线开仓 buy  L+K```
     {
      if(linekaicangshiftR)//参考时间和价格 带止损
        {
         if(buyline>=Ask)
           {
            if(TimeSeconds(TimeCurrent())/timeseconds1==MathRound(TimeSeconds(TimeCurrent())/timeseconds1))
              {
               if(timesecondstrue!=TimeSeconds(TimeCurrent()))
                 {
                  timesecondstrue=TimeSeconds(TimeCurrent());
                  Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
                  buysellnowSL(true,keylots,0,linekaicangshiftRbars,0,linekaicangshiftRpianyi);
                  if(falsetimeCurrent+1>TimeCurrent())
                    {
                     Print(TimeCurrent()," 自动开仓出错 剩余次数",huaxiankaicanggeshuR1);
                    }
                  else
                    {
                     huaxiankaicanggeshuR1--;
                     Print(TimeCurrent()," 自动开仓成功 剩余次数",huaxiankaicanggeshuR1);
                    }
                  if(huaxiankaicanggeshuR1==0)
                    {
                     linebuykaicang=false;
                     linekaicangshiftR=false;
                     linelock=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     timeseconds1=timeseconds1P;
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
              }
           }
        }
      else
        {
         if(linekaicangT && buyline>=Ask)//触及横线开仓 buy 参考时间和价格 X键提前生成止损线止损 无止损线不带止损
           {
            RefreshRates();
            Sleep(huaxiankaicangtimeTP);
            Print(TimeCurrent()," 开仓剩余个数 ",huaxiankaicanggeshuT1-1," 开仓时间间隔",huaxiankaicangtimeTP);
            // Print("市价买一单 处理中 . . .");comment("市价买一单 处理中 . . .");
            if(ObjectFind(0,"SL Line")==0)
              {
               int  keybuy10=OrderSend(Symbol(),OP_BUY,huaxiankaicanglotsT,Ask,keyslippage,slline,0,NULL,MathRand(),0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",GetLastError());
                 }
              }
            else
              {
               int  keybuy10=OrderSend(Symbol(),OP_BUY,huaxiankaicanglotsT,Ask,keyslippage,0,0,NULL,MathRand(),0);
               if(keybuy10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",GetLastError());
                 }
              }
            if(huaxiankaicanggeshuT1==0)
              {
               huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
               linebuykaicang=false;
               linelock=false;
               linekaicangT=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }
         else
           {
            for(int i=huaxiankaicanggeshu1; i>0; i--)//触及横线开仓 buy 只参考时间
              {
               RefreshRates();
               Sleep(huaxiankaicangtimeP);
               //Print(TimeCurrent(),"  ",i);
               //Print("市价买一单 处理中 . . .");comment("市价买一单 处理中 . . .");
               int  keybuy10=OrderSend(Symbol(),OP_BUY,keylots,Ask,keyslippage,0,0,NULL,MathRand(),0);
               if(keybuy10>0)
                  PlaySound("ok.wav");
               else
                 {
                  PlaySound("timeout.wav");
                  i++;
                  Print("GetLastError=",GetLastError());
                 }
              }
            huaxiankaicanggeshu1=huaxiankaicanggeshu;
            linebuykaicang=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
            if(ObjectFind(0,"SL Line")==0)
               ObjectDelete(0,"SL Line");
           }

        }
     }



   if(linesellkaicang && sellline<=Bid)//触及横线开仓 sell
     {
      if(linekaicangshiftR)
        {
         if(sellline<=Bid)
           {

            if(TimeSeconds(TimeCurrent())/timeseconds1==MathRound(TimeSeconds(TimeCurrent())/timeseconds1))
              {
               if(timesecondstrue!=TimeSeconds(TimeCurrent()))
                 {
                  timesecondstrue=TimeSeconds(TimeCurrent());
                  Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
                  buysellnowSL(false,keylots,0,linekaicangshiftRbars,0,linekaicangshiftRpianyi);
                  if(falsetimeCurrent+1>TimeCurrent())
                    {
                     Print(TimeCurrent()," 自动开仓出错 剩余次数",huaxiankaicanggeshuR1);
                    }
                  else
                    {
                     huaxiankaicanggeshuR1--;
                     Print(TimeCurrent()," 自动开仓成功 剩余次数",huaxiankaicanggeshuR1);
                    }
                  if(huaxiankaicanggeshuR1==0)
                    {
                     linekaicangshiftR=false;
                     linesellkaicang=false;
                     linelock=false;
                     huaxiankaicanggeshuR1=huaxiankaicanggeshuR;
                     timeseconds1=timeseconds1P;
                     if(ObjectFind(0,"Buy Line")==0)
                        ObjectDelete(0,"Buy Line");
                     if(ObjectFind(0,"Sell Line")==0)
                        ObjectDelete(0,"Sell Line");
                    }
                 }
              }
            //  Sleep(huaxiankaicangtimeshiftR);
           }
        }
      else
        {
         if(linekaicangT && sellline<=Bid)
           {
            RefreshRates();
            Sleep(huaxiankaicangtimeTP);
            // Print(TimeCurrent(),"  ",huaxiankaicanggeshuT1);
            Print(TimeCurrent()," 开仓剩余个数 ",huaxiankaicanggeshuT1-1," 开仓时间间隔",huaxiankaicangtimeTP);
            if(ObjectFind(0,"SL Line")==0)
              {
               int  keysell10=OrderSend(Symbol(),OP_SELL,huaxiankaicanglotsT,Bid,keyslippage,slline,0,NULL,MathRand(),0);
               if(keysell10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",GetLastError());
                 }
              }
            else
              {
               int  keysell10=OrderSend(Symbol(),OP_SELL,huaxiankaicanglotsT,Bid,keyslippage,0,0,NULL,MathRand(),0);
               if(keysell10>0)
                 {
                  PlaySound("ok.wav");
                  huaxiankaicanggeshuT1--;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("GetLastError=",GetLastError());
                 }
              }
            if(huaxiankaicanggeshuT1==0)
              {
               huaxiankaicanggeshuT1=huaxiankaicanggeshuT;
               linesellkaicang=false;
               linelock=false;
               linekaicangT=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               if(ObjectFind(0,"SL Line")==0)
                  ObjectDelete(0,"SL Line");
              }
           }
         else
           {
            for(int i=huaxiankaicanggeshu; i>0; i--)
              {
               RefreshRates();
               Sleep(huaxiankaicangtimeP);
               //Print(TimeCurrent(),"  ",i);
               //Print("市价卖一单 处理中 . . .");comment("市价卖一单 处理中 . . .");
               int keysell10=OrderSend(Symbol(),OP_SELL,keylots,Bid,keyslippage,0,0,NULL,MathRand(),0);
               if(keysell10>0)
                  PlaySound("ok.wav");
               else
                 {
                  PlaySound("timeout.wav");
                  i++;
                  Print("GetLastError=",GetLastError());
                 }
              }
            linesellkaicang=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
            if(ObjectFind(0,"SL Line")==0)
               ObjectDelete(0,"SL Line");
           }

        }
     }

   if(OnTickswitch==false)//没订单时 OnTick 模块不运行
     {
      return;
     }
   if(dingshipingcang)//当前五分钟K线收线时平仓
     {
      int m=TimeMinute(TimeGMT());
      if(m==4 || m==9 || m==14 || m==19 || m==24 || m==29 || m==34|| m==39|| m==44 || m==49|| m==54|| m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓触发时间 ",TimeCurrent());
            xunhuanquanpingcang();
            dingshipingcang=false;
            Print("五分钟K线收线时平仓 完成");
            comment("五分钟K线收线时平仓 完成");
           }
        }
     }
   if(dingshipingcang15)//当前十五分钟K线收线时平仓
     {
      int m=TimeMinute(TimeGMT());
      if(m==14 || m==29 || m==44 || m==59)
        {
         if(TimeSeconds(TimeGMT())>=55)
           {
            Print("定时平仓触发时间 ",TimeCurrent());
            xunhuanquanpingcang();
            dingshipingcang15=false;
            Print("十五分钟K线收线时平仓 完成");
            comment("十五分钟K线收线时平仓 完成");
           }
        }
     }
/////////////////////////////////////////////////////////////////////// 剥头皮开始
   if(SLbuylineQpingcangT1)//* buy单超过横线一单一单平仓 仅止盈用
     {
      if(SLsellQpengcangline<=Bid)
        {
         Sleep(SLQlinepingcangSleep);
         yijianpingcangMagic(1688);
         SLbuylineQpingcangT=false;
         SLbuylineQpingcang=false;
         SLsellQpengcangline1=Bid+1000*Point;
         ObjectMove(0,"SLsellQpengcangline1",0,Time[0],SLsellQpengcangline1);
        }
     }
   if(SLselllineQpingcangT1)//* sell单超过横线一单一单平仓 仅止盈用
     {
      if(SLbuyQpengcangline>=Bid)
        {
         Sleep(SLQlinepingcangSleep);
         yijianpingcangMagic(1688);
         SLselllineQpingcangT=false;
         SLselllineQpingcang=false;
         SLbuyQpengcangline1=Ask-1000*Point;
         ObjectMove(0,"SLbuyQpengcangline1",0,Time[0],SLbuyQpengcangline1);
        }
     }
   if(SLbuylineQpingcangT)//buy单超过横线一单一单平仓 仅止盈用
     {
      //    Sleep(linepingcangRTime);
      if(SLsellQpengcangline<=Bid)
        {
         if(TimeSeconds(TimeCurrent())/timeseconds==MathRound(TimeSeconds(TimeCurrent())/timeseconds))
           {
            if(timesecondstrue!=TimeSeconds(TimeCurrent()))
              {
               timesecondstrue=TimeSeconds(TimeCurrent());
               Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
               zuijinkeyclose();
              }
           }
         if(CGetbuyLots()==0.0)
           {
            SLsellQpengcangline=Bid+1000*Point;
            ObjectMove(0,"SLsellQpengcangline",0,Time[0],SLsellQpengcangline);
           }
        }
     }

   if(SLselllineQpingcangT)//sell单超过横线一单一单平仓 仅止盈用
     {
      //   Sleep(linepingcangRTime);
      if(SLbuyQpengcangline>=Bid)
        {
         if(TimeSeconds(TimeCurrent())/timeseconds==MathRound(TimeSeconds(TimeCurrent())/timeseconds))
           {
            if(timesecondstrue!=TimeSeconds(TimeCurrent()))
              {
               timesecondstrue=TimeSeconds(TimeCurrent());
               Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
               zuijinkeyclose();
              }
           }
         if(CGetsellLots()==0.0)
           {
            SLbuyQpengcangline=Ask-1000*Point;
            ObjectMove(0,"SLbuyQpengcangline",0,Time[0],SLbuyQpengcangline);
           }
        }
     }

   if(SLbuylinepingcang)//buy单越过横线一单一单止损平仓
     {
      if(SL1mbuyLineprice>=Ask || SL5mbuyLineprice>=Ask || SL15mbuyLineprice>=Ask)//触及止损线会平掉部分仓位
        {
         if(SL1mbuyLineprice>=Ask)
           {
            if(SLlinepingcangjishu>SLlinepingcangjishu1)
              {
               Sleep(SLlinepingcangtime);
               zuijinkeyclose();
               SLlinepingcangjishu1++;
              }
            else
              {
               SLlinepingcangjishu1=0;
               SL1mbuyLine=false;
               SL1mbuyLineprice=Ask-1000*Point;
               if(ObjectFind("SL1mbuyLine")==0)
                  ObjectDelete("SL1mbuyLine");
              }
           }
         else
           {
            if(SL5mbuyLineprice>=Ask)
              {
               if(SLlinepingcangjishu>SLlinepingcangjishu1)
                 {
                  Sleep(SLlinepingcangtime);
                  zuijinkeyclose();
                  SLlinepingcangjishu1++;
                 }
               else
                 {
                  SLlinepingcangjishu1=0;
                  SL5mbuyLine=false;
                  SL5mbuyLineprice=Ask-1000*Point;
                  if(ObjectFind("SL5mbuyLine")==0)
                     ObjectDelete("SL5mbuyLine");
                 }
              }
            else
              {
               Sleep(SLlinepingcangtime);
               zuijinkeyclose();
              }
           }
        }
     }
   if(SLselllinepingcang)//sell单越过横线一单一单止损平仓
     {
      if(SL1msellLineprice<=Bid || SL5msellLineprice<=Bid || SL15msellLineprice<=Bid)
        {
         if(SL1msellLineprice<=Bid)
           {
            if(SLlinepingcangjishu>SLlinepingcangjishu1)
              {
               Sleep(SLlinepingcangtime);
               zuijinkeyclose();
               SLlinepingcangjishu1++;
              }
            else
              {
               SLlinepingcangjishu1=0;
               SL1msellLine=false;
               SL1msellLineprice=Bid+1000*Point;
               if(ObjectFind("SL1msellLine")==0)
                  ObjectDelete("SL1msellLine");
              }
           }
         else
           {
            if(SL5msellLineprice<=Bid)
              {
               if(SLlinepingcangjishu>SLlinepingcangjishu1)
                 {
                  Sleep(SLlinepingcangtime);
                  zuijinkeyclose();
                  SLlinepingcangjishu1++;
                 }
               else
                 {
                  SLlinepingcangjishu1=0;
                  SL5msellLine=false;
                  SL5msellLineprice=Bid+1000*Point;
                  if(ObjectFind("SL5msellLine")==0)
                     ObjectDelete("SL5msellLine");
                 }
              }
            else
              {
               Sleep(SLlinepingcangtime);
               zuijinkeyclose();
              }
           }
        }
     }

////////////////////////////////////////////////////////////////////// 剥头皮结束
   if(linebuyfansuo)//触及横线buy单临时锁仓
     {
      if(buyline<buylineOnTimer && buyline>=Bid)//横线在当前价之下
        {
         Print("buyline=",buyline,"buylineOnTimer=",buylineOnTimer,"横线在当前价之下");
         suocang();
         linebuyfansuo=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }



      if(buyline>buylineOnTimer && buyline<=Bid)//横线在当前价之上
        {
         Print("buyline=",buyline,"buylineOnTimer=",buylineOnTimer,"横线在当前价之上");
         suocang();
         linebuyfansuo=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }



   if(linesellfansuo)//触及横线sell单临时锁仓
     {
      if(sellline>selllineOnTimer && sellline<=Bid)//横线在当前价之上
        {
         suocang();
         linesellfansuo=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }



      if(sellline<selllineOnTimer && sellline>=Bid)//横线在当前价之下
        {
         suocang();
         linesellfansuo=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }

   if(yijianFanshou  && ObjectFind(0,"Buy Line")==0)//触及横线全平后反手开仓
     {
      if(buyline<buylineOnTimer && buyline>=Bid)//横线在当前价之下
        {
         Print("buyline=",buyline,"buylineOnTimer=",buylineOnTimer,"横线在当前价之下");
         yijianfanshou();
         yijianFanshou=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }



      if(buyline>buylineOnTimer && buyline<=Bid)//横线在当前价之上
        {
         Print("buyline=",buyline,"buylineOnTimer=",buylineOnTimer,"横线在当前价之上");
         yijianfanshou();
         yijianFanshou=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }



   if(yijianFanshou  &&  ObjectFind(0,"Sell Line")==0)//触及横线全平后反手开仓
     {
      if(sellline>selllineOnTimer && sellline<=Bid)//横线在当前价之上
        {
         yijianfanshou();
         yijianFanshou=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }



      if(sellline<selllineOnTimer && sellline>=Bid)//横线在当前价之下
        {
         yijianfanshou();
         yijianFanshou=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }


   if(linebuypingcangR)////buy单超过横线一单一单平仓 仅止盈用
     {
      //    Sleep(linepingcangRTime);
      if(sellline<=Bid)
        {
         if(TimeSeconds(TimeCurrent())/timeseconds==MathRound(TimeSeconds(TimeCurrent())/timeseconds))
           {
            if(timesecondstrue!=TimeSeconds(TimeCurrent()))
              {
               timesecondstrue=TimeSeconds(TimeCurrent());
               Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
               zuijinkeyclose();
              }
           }
         if(CGetbuyLots()==0.0)
           {
            linebuypingcangR=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
            Print("超过横线一单一单平仓 关闭");
           }
        }
     }



   if(linesellpingcangR)//sell单超过横线一单一单平仓 仅止盈用
     {
      //   Sleep(linepingcangRTime);
      if(buyline>=Bid)
        {
         if(TimeSeconds(TimeCurrent())/timeseconds==MathRound(TimeSeconds(TimeCurrent())/timeseconds))
           {
            if(timesecondstrue!=TimeSeconds(TimeCurrent()))
              {
               timesecondstrue=TimeSeconds(TimeCurrent());
               Print("任务执行中 当前时间的秒数 ",TimeSeconds(TimeCurrent()));
               zuijinkeyclose();
              }
           }
         if(CGetsellLots()==0.0)
           {
            linesellpingcangR=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
            Print("超过横线一单一单平仓 关闭");
           }
        }
     }



   if(linebuypingcang)//触及横线全平仓
     {
      if(buyline<buylineOnTimer && buyline>=Bid)//横线在当前价之下
        {
         if(linebuypingcangctrlR)//如果是遇线止损按左ctrl反向移动几个点后全止盈薅羊毛有风险
           {
            PiliangTP(true,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
            PiliangTP(false,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
            PiliangSL(true,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
            PiliangSL(false,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
            linebuypingcang=false;
            linebuypingcangctrlR=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
         else
           {
            if(linebuypingcangonly  &&  linesellpingcangonly==false)//2222
              {
               yijianpingbuydan();
               linebuypingcang=false;
               linelock=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               Print("buy单平仓 完成");
               comment("buy单平仓 完成");
              }
            else
              {
               if(linebuypingcangonly==false  &&  linesellpingcangonly)
                 {
                  yijianpingselldan();
                  linebuypingcang=false;
                  linelock=false;
                  linebuypingcangonly=false;
                  linesellpingcangonly=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                  Print("sell单平仓 完成");
                  comment("sell单平仓 完成");
                 }
               else
                 {
                  xunhuanquanpingcang();
                  linebuypingcang=false;
                  linelock=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                 }

              }

           }
        }



      if(buyline>buylineOnTimer && buyline<=Bid)//横线在当前价之上
        {
         if(linebuypingcangctrlR)//如果是遇线止损按左ctrl反向移动几个点后全止盈薅羊毛有风险
           {
            PiliangTP(true,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
            PiliangTP(false,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
            PiliangSL(true,NormalizeDouble(buyline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
            PiliangSL(false,NormalizeDouble(buyline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
            linebuypingcang=false;
            linebuypingcangctrlR=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
         else
           {
            if(linebuypingcangonly  &&  linesellpingcangonly==false)//2222
              {
               yijianpingbuydan();
               linebuypingcang=false;
               linelock=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               Print("buy单平仓 完成");
               comment("buy单平仓 完成");
              }
            else
              {
               if(linebuypingcangonly==false  &&  linesellpingcangonly)
                 {
                  yijianpingselldan();
                  linebuypingcang=false;
                  linelock=false;
                  linebuypingcangonly=false;
                  linesellpingcangonly=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                  Print("sell单平仓 完成");
                  comment("sell单平仓 完成");
                 }
               else
                 {
                  xunhuanquanpingcang();
                  linebuypingcang=false;
                  linelock=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                 }

              }
           }
        }
     }



   if(linesellpingcang)//触及横线全平仓
     {
      if(sellline>selllineOnTimer && sellline<=Bid)//横线在当前价之上
        {
         if(linesellpingcangctrlR)//如果是遇线止损按左ctrl反向移动几个点后全止盈薅羊毛有风险
           {
            PiliangTP(true,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
            PiliangTP(false,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
            PiliangSL(true,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
            PiliangSL(false,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
            linesellpingcang=false;
            linesellpingcangctrlR=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
         else
           {
            if(linebuypingcangonly  &&  linesellpingcangonly==false)//2222
              {
               yijianpingbuydan();
               linesellpingcang=false;
               linelock=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               Print("buy单平仓 完成");
               comment("buy单平仓 完成");
              }
            else
              {
               if(linebuypingcangonly==false  &&  linesellpingcangonly)
                 {
                  yijianpingselldan();
                  linesellpingcang=false;
                  linelock=false;
                  linebuypingcangonly=false;
                  linesellpingcangonly=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                  Print("sell单平仓 完成");
                  comment("sell单平仓 完成");
                 }
               else
                 {
                  xunhuanquanpingcang();
                  linesellpingcang=false;
                  linelock=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                 }

              }
           }
        }



      if(sellline<selllineOnTimer && sellline>=Bid)//横线在当前价之下
        {
         if(linesellpingcangctrlR)//如果是遇线止损按左ctrl反向移动几个点后全止盈薅羊毛有风险
           {
            PiliangTP(true,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
            PiliangTP(false,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*Point,Digits),0,0,0,dingdanshu);
            PiliangSL(true,NormalizeDouble(sellline-linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
            PiliangSL(false,NormalizeDouble(sellline+linebuypingcangctrlRpianyi*2*Point,Digits),0,0,0,dingdanshu);
            linesellpingcang=false;
            linesellpingcangctrlR=false;
            linelock=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
         else
           {
            if(linebuypingcangonly  &&  linesellpingcangonly==false)//2222
              {
               yijianpingbuydan();
               linesellpingcang=false;
               linelock=false;
               linebuypingcangonly=false;
               linesellpingcangonly=false;
               if(ObjectFind(0,"Buy Line")==0)
                  ObjectDelete(0,"Buy Line");
               if(ObjectFind(0,"Sell Line")==0)
                  ObjectDelete(0,"Sell Line");
               Print("buy单平仓 完成");
               comment("buy单平仓 完成");
              }
            else
              {
               if(linebuypingcangonly==false  &&  linesellpingcangonly)
                 {
                  yijianpingselldan();
                  linesellpingcang=false;
                  linelock=false;
                  linebuypingcangonly=false;
                  linesellpingcangonly=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                  Print("sell单平仓 完成");
                  comment("sell单平仓 完成");
                 }
               else
                 {
                  xunhuanquanpingcang();
                  linesellpingcang=false;
                  linelock=false;
                  if(ObjectFind(0,"Buy Line")==0)
                     ObjectDelete(0,"Buy Line");
                  if(ObjectFind(0,"Sell Line")==0)
                     ObjectDelete(0,"Sell Line");
                 }

              }
           }
        }
     }

   if(linebuyzidongjiacang)//五分钟自动追Buy单
     {
      int T=TimeMinute(TimeCurrent());
      if(linefirsttime)//第一次开启时执行
        {
         if(Open[1]-Close[1]<0)
           {
            double p1=Close[1]-20*Point;
            double p2=Bid-20*Point;
            if(p2<p1)
              {
               buyline=p2;
               if(ObjectFind("Buy Line")==0)
                  ObjectMove(0,"Buy Line",0,Time[1],buyline);
              }
            else
              {
               buyline=p1;
               if(ObjectFind("Buy Line")==0)
                  ObjectMove(0,"Buy Line",0,Time[1],buyline);
              }
            linefirsttime=false;
           }
        }



      if(T==1 || T==5 || T==10 || T==15 || T==20 || T==25 || T==30 || T==35 || T==40 || T==45 || T==50 || T==55)//定时执行
        {
         if(linetime<T)
            lineTime=false;
         if(linetime==55 && T==1)
            lineTime=false;
         if(Open[1]-Close[1]<0 && lineTime==false)
           {
            buyline=Close[1]-linebuyzidongjiacangpianyi*Point;
            if(ObjectFind("Buy Line")==0)
              {
               bool T1=ObjectMove(0,"Buy Line",0,Time[1],buyline);
               if(T1)
                 {
                  lineTime=true;
                  linetime=T;
                 }
              }
           }
        }



      if(huaxianzidongjiacanggeshu1==0)
        {
         huaxianzidongjiacanggeshutime1--;
         if(huaxianzidongjiacanggeshutime1>0)
           {
            if(ObjectFind("Buy Line")==0)
               ObjectMove(0,"Buy Line",0,Time[1],buyline-linezidongjiacangyidong*Point);
            buyline=buyline-linezidongjiacangyidong*Point;
            huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
           }
         else
           {
            linebuyzidongjiacang=false;
            linelock=false;
            huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
            huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
            lineTime=false;
            linetime=0;
            linefirsttime=true;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
        }



      else
        {
         if(buyline>=Bid)
           {
            RefreshRates();
            Sleep(huaxiankaicangtime);
            buysellnowSL(true,huaxianzidongjiacanglots,5,7,0,50);
            huaxianzidongjiacanggeshu1--;
           }
        }
     }



   if(linesellzidongjiacang)//五分钟自动追Sell单
     {
      int T=TimeMinute(TimeCurrent());



      if(linefirsttime)//第一次开启时执行
        {
         if(Open[1]-Close[1]>0)
           {
            double p1=Close[1]+20*Point;
            double p2=Bid+20*Point;
            if(p2>p1)
              {
               sellline=p2;
               if(ObjectFind("Sell Line")==0)
                  ObjectMove(0,"Sell Line",0,Time[1],sellline);
              }
            else
              {
               sellline=p1;
               if(ObjectFind("Sell Line")==0)
                  ObjectMove(0,"Sell Line",0,Time[1],sellline);
              }
            linefirsttime=false;
           }
        }



      if(T==1 || T==5 || T==10 || T==15 || T==20 || T==25 || T==30 || T==35 || T==40 || T==45 || T==50 || T==55)//定时执行
        {
         if(linetime<T)
            lineTime=false;
         if(linetime==55 && T==1)
            lineTime=false;
         if(Open[1]-Close[1]>0 && lineTime==false)
           {
            sellline=Close[1]+linesellzidongjiacangpianyi*Point;
            if(ObjectFind("Sell Line")==0)
              {
               bool T1=ObjectMove(0,"Sell Line",0,Time[1],sellline);
               if(T1)
                 {
                  lineTime=true;
                  linetime=T;
                 }
              }
           }
        }



      if(huaxianzidongjiacanggeshu1==0)
        {
         huaxianzidongjiacanggeshutime1--;
         if(huaxianzidongjiacanggeshutime1>0)
           {
            if(ObjectFind("Sell Line")==0)
               ObjectMove(0,"Sell Line",0,Time[1],sellline+linezidongjiacangyidong*Point);
            sellline=sellline+linezidongjiacangyidong*Point;
            huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
           }
         else
           {
            linesellzidongjiacang=false;
            linelock=false;
            huaxianzidongjiacanggeshu1=huaxianzidongjiacanggeshu;
            huaxianzidongjiacanggeshutime1=huaxianzidongjiacanggeshutime;
            lineTime=false;
            linetime=0;
            linefirsttime=true;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
        }



      else
        {
         if(sellline<=Bid)
           {
            RefreshRates();
            Sleep(huaxiankaicangtime);
            buysellnowSL(false,huaxianzidongjiacanglots,5,7,0,50);
            huaxianzidongjiacanggeshu1--;
           }
        }
     }



   if(tickclose)//Tick数值变化剧烈 自动开始平仓
     {
      int jishu=tickjishu;
      double abs=0;



      switch(tickjishu)
        {
         case 4:
           {
            tick4=Bid;
            tickjishu--;
           }
         break;
         case 3:
           {
            tick3=Bid;
            tickjishu--;
           }
         break;
         case 2:
           {
            tick2=Bid;
            tickjishu--;
           }
         break;
         case 1:
           {
            tick1=Bid;
            tickjishu--;
           }
         break;
         case 0:
           {
            tick0=Bid;
            tickjishu=4;
           }
         break;
        }



      switch(jishu)
        {
         case 4:
           {
            abs=(NormalizeDouble(tick4-tick3,Digits)/Point);
           }
         break;
         case 3:
           {
            abs=(NormalizeDouble(tick3-tick2,Digits)/Point);
           }
         break;
         case 2:
           {
            abs=(NormalizeDouble(tick2-tick1,Digits)/Point);
           }
         break;
         case 1:
           {
            abs=(NormalizeDouble(tick1-tick0,Digits)/Point);
           }
         break;
         case 0:
           {
            abs=(NormalizeDouble(tick0-tick4,Digits)/Point);
           }
         break;
        }



      if(tickbuyclose)
        {
         if(tickShift)
            Print("Tick变化值= ",abs," 预设值",glotickclosenum,"  tickjishu=",jishu," tick4=",tick4," tick3=",tick3," tick2=",tick2," tick1=",tick1," tick0=",tick0);
         if(abs>glotickclosenum && MathAbs(abs)<500)
           {
            xunhuanquanpingcang();
            tickclose=false;
            Print("Tick数值变化剧烈 数值大于预设值",glotickclosenum,"自动开始平仓");
            comment1("Tick数值变化剧烈大于预设值自动开始平仓");
           }
        }



      else
        {
         if(tickShift)
            Print("Tick变化值= ",abs," 预设值",-glotickclosenum,"  tickjishu=",jishu," tick4=",tick4," tick3=",tick3," tick2=",tick2," tick1=",tick1," tick0=",tick0);
         if(abs<-glotickclosenum && MathAbs(abs)<500)
           {
            xunhuanquanpingcang();
            tickclose=false;
            Print("Tick数值变化剧烈 数值大于预设值",-glotickclosenum,"自动开始平仓");
            comment1("Tick数值变化剧烈大于预设值自动开始平仓");
           }
        }
     }
   if(Tickmode  && fansuoYes==false)//分步平仓
     {
      closecode();
     }
  }
///////////////////////////////////////////////////////////////////
void OnTimer()//tttt 定时器
  {
//int  m = TimeSeconds(TimeCurrent());
//Print(OrdersTotal());
//Print(GetHoldingguadanOrdersCount());
//
//Print(AccountProfit());
// Print(SL5QTPtimeCurrent+10);
//double mb=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",7,0.0,0,0),4);
//double bs=NormalizeDouble(iCustom(NULL,0,"Custom/bstrend-indicator",12,0,0),5);
//Print(mb);
//Print(bs);
// Print(TimeGMT());
//Print(iLow(NULL,PERIOD_M5,1));
// Print(iLow(NULL,PERIOD_M15,1));
//   Print(iLowest(NULL,PERIOD_M1,MODE_LOW,7,0));
//  Print("1=",SL1mbuyLineprice," ","5=",SL5mbuyLineprice," ","15=",SL15mbuyLineprice);
   if(GetHoldingdingdanguadanOrdersCount()==0 || Lots()==0.0)//没订单时 OnTick 模块不运行
     {
      OnTickswitch=false;
     }
   else
     {
      OnTickswitch=true;
     }
   if(ObjectFind(0,"Buy Line")==0)
     {
      buyline=NormalizeDouble(ObjectGet("Buy Line",1),Digits);   //定时更新横线的价格
      buylineOnTimer=Bid;
     }
   if(ObjectFind(0,"Sell Line")==0)
     {
      sellline=NormalizeDouble(ObjectGet("Sell Line",1),Digits);   //定时更新横线的价格
      selllineOnTimer=Bid;
     }

   if(CGetbuyLots()>=GlobalVariableGet("glomaxTotallots"))//限制EA最大下单量
     {
      buymaxTotallots=true;
     }
   else
     {
      buymaxTotallots=false;
     }
   if(CGetsellLots()>=GlobalVariableGet("glomaxTotallots"))
     {
      sellmaxTotallots=true;
     }
   else
     {
      sellmaxTotallots=false;
     }

   if(ObjectFind(0,"SL1mbuyLine")==0)
     {
      SL1mbuyLineprice=NormalizeDouble(ObjectGet("SL1mbuyLine",1),Digits);
     }
   if(ObjectFind(0,"SL5mbuyLine")==0)
     {
      SL5mbuyLineprice=NormalizeDouble(ObjectGet("SL5mbuyLine",1),Digits);
     }
   if(ObjectFind(0,"SL15mbuyLine")==0)
     {
      SL15mbuyLineprice=NormalizeDouble(ObjectGet("SL15mbuyLine",1),Digits);
     }
   if(ObjectFind(0,"SL1msellLine")==0)
     {
      SL1msellLineprice=NormalizeDouble(ObjectGet("SL1msellLine",1),Digits);
     }
   if(ObjectFind(0,"SL5msellLine")==0)
     {
      SL5msellLineprice=NormalizeDouble(ObjectGet("SL5msellLine",1),Digits);
     }
   if(ObjectFind(0,"SL15msellLine")==0)
     {
      SL15msellLineprice=NormalizeDouble(ObjectGet("SL15msellLine",1),Digits);
     }
//////////////////////////////////////////////////////////////////////////////////////////
   if(dingdanxianshi && timeGMTYesNo2 && timeGMT2==D'1970.01.01 00:00:00')//定时器2 日志文字提示 定时删除 Time0
     {
      timeGMT2=TimeGMT();
      //Print("定时器2启用 文字提示 ",TimeGMT());
     }
   else
     {
      if(timeGMTYesNo2 && TimeGMT()>=timeGMT2+timeGMTSeconds2)
        {
         //Print("定时器2时间到 处理中 . . . ",TimeGMT());
         /////////////////////////////////////////////////////////////////////////////////////////////////
         if(ObjectFind("zi")>=0)//日志文字提示 定时删除
            ObjectDelete("zi");
         if(ObjectFind("zi1")>=0)
            ObjectDelete("zi1");
         if(GetHoldingbuyOrdersCount()>0)
           {
            if(NormalizeDouble(CGetbuyLots(),2)==NormalizeDouble(CGetsellLots(),2))//如果订单反锁时 不执行止盈止损 自动分步平仓
              {
               fansuoYes=true;
              }
            else
              {
               fansuoYes=false;
              }
           }
         buydangeshu=0;
         selldangeshu=0;
         dingdanshu=100;//定时恢复默认值 dingdanshu3 dingdanshu4 空闲 备用
         dingdanshu1=dingdangeshu10;
         dingdanshu1=dingdangeshu10nom;
         dingdanshu2=zhinengSLTPdingdangeshu;
         guadangeshu=huaxianguadangeshu;
         huaxianguadanlotsT=huaxianguadanlots;

         diancha=MarketInfo(Symbol(),MODE_SPREAD)*Point;
         pianyilingGlo=pianyiglo*Point;//全局偏移量 不用*Point；

         //Print(diancha," ",pianyiling," ",Point);
         if(ObjectFind(0,"SLbuyQpengcangline")==0)
           {
            SLbuyQpengcangline=NormalizeDouble(ObjectGet("SLbuyQpengcangline",1),Digits);  //定时更新横线的价格
           }
         if(ObjectFind(0,"SLsellQpengcangline")==0)
           {
            SLsellQpengcangline=NormalizeDouble(ObjectGet("SLsellQpengcangline",1),Digits);  //定时更新横线的价格
           }
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         //---
         if(SLbuylineQpingcang)//
           {
            if(GetHoldingbuyOrdersCount()>0)
              {
               if(ObjectFind("SLsellQpengcangline")==0)
                 {
                  SLsellQpengcangline=HoldingOrderbuyAvgPrice()+SL5QTPpingcang*Point;
                  ObjectMove(0,"SLsellQpengcangline",0,Time[0],SLsellQpengcangline);
                 }
               else
                 {
                  SetLevel("SLsellQpengcangline",Bid+200*Point,DarkSlateGray);
                  SLsellQpengcangline=Bid+200*Point;
                 }
              }
           }
         if(SLselllineQpingcang)//
           {
            if(GetHoldingsellOrdersCount()>0)
              {
               if(ObjectFind("SLbuyQpengcangline")==0)
                 {
                  SLbuyQpengcangline=HoldingOrdersellAvgPrice()-SL5QTPpingcang*Point;
                  ObjectMove(0,"SLbuyQpengcangline",0,Time[0],SLbuyQpengcangline);
                 }
               else
                 {
                  SetLevel("SLbuyQpengcangline",Ask-200*Point,DarkSlateGray);
                  SLbuyQpengcangline=Ask-200*Point;
                 }
              }
           }
         //---<
         ////
         if(SLbuylineQpingcang1)//
           {
            if(GetHoldingbuyOrdersCount()>0)
              {
               if(ObjectFind("SLsellQpengcangline1")==0)
                 {
                  SLsellQpengcangline1=HoldingOrderbuyAvgPrice()+SL5QTPpingcang1*Point;
                  ObjectMove(0,"SLsellQpengcangline1",0,Time[0],SLsellQpengcangline1);
                 }
               else
                 {
                  SetLevel("SLsellQpengcangline1",Bid+200*Point,DarkSlateGray);
                  SLsellQpengcangline1=Bid+200*Point;
                 }
              }
           }
         if(SLselllineQpingcang1)//
           {
            if(GetHoldingsellOrdersCount()>0)
              {
               if(ObjectFind("SLbuyQpengcangline1")==0)
                 {
                  SLbuyQpengcangline1=HoldingOrdersellAvgPrice()-SL5QTPpingcang1*Point;
                  ObjectMove(0,"SLbuyQpengcangline1",0,Time[0],SLbuyQpengcangline1);
                 }
               else
                 {
                  SetLevel("SLbuyQpengcangline1",Ask-200*Point,DarkSlateGray);
                  SLbuyQpengcangline1=Ask-200*Point;
                 }
              }
           }

         ///

         if(SL1mbuyLine)//一分钟止损横线
           {
            RefreshRates();
            if(ObjectFind("SL1mbuyLine")==0)
              {
               SL1mbuyLineprice1=iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,SL1mlinetimeframe,0))-SLbuylinepianyi*Point;
               if(SL1mbuyLineprice1>=SL1mbuyLineprice)
                  SL1mbuyLineprice=SL1mbuyLineprice1;
               ObjectMove("SL1mbuyLine",0,Time[3],SL1mbuyLineprice);
              }
            else
              {
               SL1mbuyLineprice=iLow(NULL,PERIOD_M1,iLowest(NULL,PERIOD_M1,MODE_LOW,SL1mlinetimeframe,0))-SLbuylinepianyi*Point;
               SetLevel("SL1mbuyLine",SL1mbuyLineprice,Maroon);
              }
           }



         if(SL1msellLine)
           {
            RefreshRates();
            if(ObjectFind("SL1msellLine")==0)
              {
               SL1msellLineprice1=iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,SL1mlinetimeframe,0))+SLselllinepianyi*Point;
               if(SL1msellLineprice1<=SL1msellLineprice)
                  SL1msellLineprice=SL1msellLineprice1;
               ObjectMove("SL1msellLine",0,Time[3],SL1msellLineprice);
              }
            else
              {
               SL1msellLineprice=iHigh(NULL,PERIOD_M1,iHighest(NULL,PERIOD_M1,MODE_HIGH,SL1mlinetimeframe,0))+SLselllinepianyi*Point;
               SetLevel("SL1msellLine",SL1msellLineprice,Maroon);
              }
           }



         if(SL5mbuyLine)//五分钟止损横线
           {
            RefreshRates();
            if(ObjectFind("SL5mbuyLine")==0)
              {
               SL5mbuyLineprice1=iLow(NULL,PERIOD_M5,iLowest(NULL,PERIOD_M5,MODE_LOW,SL5mlinetimeframe,0))-SLbuylinepianyi*Point;
               if(SL5mbuyLineprice1>=SL5mbuyLineprice)
                  SL5mbuyLineprice=SL5mbuyLineprice1;
               ObjectMove("SL5mbuyLine",0,Time[3],SL5mbuyLineprice);
              }
            else
              {
               SL5mbuyLineprice=iLow(NULL,PERIOD_M5,iLowest(NULL,PERIOD_M5,MODE_LOW,SL5mlinetimeframe,0))-SLbuylinepianyi*Point;
               SetLevel("SL5mbuyLine",SL5mbuyLineprice,Maroon);
              }
           }



         if(SL5msellLine)
           {
            RefreshRates();
            if(ObjectFind("SL5msellLine")==0)
              {
               SL5msellLineprice1=iHigh(NULL,PERIOD_M5,iHighest(NULL,PERIOD_M5,MODE_HIGH,SL5mlinetimeframe,0))+SLselllinepianyi*Point;
               if(SL5msellLineprice1<=SL5msellLineprice)
                  SL5msellLineprice=SL5msellLineprice1;
               ObjectMove("SL5msellLine",0,Time[3],SL5msellLineprice);
              }
            else
              {
               SL5msellLineprice=iHigh(NULL,PERIOD_M5,iHighest(NULL,PERIOD_M5,MODE_HIGH,SL5mlinetimeframe,0))+SLselllinepianyi*Point;
               SetLevel("SL5msellLine",SL5msellLineprice,Maroon);
              }
           }



         if(SL15mbuyLine)//十五分钟止损横线
           {
            RefreshRates();
            if(ObjectFind("SL15mbuyLine")==0)
              {
               SL15mbuyLineprice1=iLow(NULL,PERIOD_M15,iLowest(NULL,PERIOD_M15,MODE_LOW,SL15mlinetimeframe,0))-SLbuylinepianyi*Point;
               if(SL15mbuyLineprice1>=SL15mbuyLineprice)
                  SL15mbuyLineprice=SL15mbuyLineprice1;
               ObjectMove("SL15mbuyLine",0,Time[3],SL15mbuyLineprice);
              }
            else
              {
               SL15mbuyLineprice=iLow(NULL,PERIOD_M15,iLowest(NULL,PERIOD_M15,MODE_LOW,SL15mlinetimeframe,0))-SLbuylinepianyi*Point;;
               SetLevel("SL15mbuyLine",SL15mbuyLineprice,Maroon);
              }
           }



         if(SL15msellLine)
           {
            RefreshRates();
            if(ObjectFind("SL15msellLine")==0)
              {
               SL15msellLineprice1=iHigh(NULL,PERIOD_M15,iHighest(NULL,PERIOD_M15,MODE_HIGH,SL15mlinetimeframe,0))+SLselllinepianyi*Point;
               if(SL15msellLineprice1<=SL15msellLineprice)
                  SL15msellLineprice=SL15msellLineprice1;
               ObjectMove("SL15msellLine",0,Time[3],SL15msellLineprice);
              }
            else
              {
               SL15msellLineprice=iHigh(NULL,PERIOD_M15,iHighest(NULL,PERIOD_M15,MODE_HIGH,SL15mlinetimeframe,0))+SLselllinepianyi*Point;
               SetLevel("SL15msellLine",SL15msellLineprice,Maroon);
              }
           }

         //---

         timeGMT2=TimeGMT();
        }
     }
   /*Print("timertrue2=",timertrue);
      if(huaxianSwitch && Lots()==0.0)//划线平仓上用的
        {
         // Print("删划线平仓的趋势线");
         if(ObjectFind(TPObjName)>=0) ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0) ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0) ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0) ObjectDelete(SL_PRICE_LINE);
        }
   // Print("Lots=",Lots());*/
// Print("计时器运行");
   if(GetHoldingdingdanguadanOrdersCount()==0)//没有订单或挂单时 终止运行
     {
      if(timertrue==true)
        {
         return;
        }
      else
        {
         if(ObjectFind("buy")>=0)//删左上角文字
            ObjectDelete("buy");
         if(ObjectFind("sell")>=0)
            ObjectDelete("sell");
         if(ObjectFind("buysell")>=0)
            ObjectDelete("buysell");
         if(ObjectFind("AccountEquity")>=0)
            ObjectDelete("AccountEquity");
         if(ObjectFind("AccountFreeMargin")>=0)
            ObjectDelete("AccountFreeMargin");
         if(ObjectFind("zi")>=0)
            ObjectDelete("zi");

         linebuypingcang=false;//订单手动平仓后 解除横线模式的触线平仓
         linebuypingcangR=false;
         linebuypingcangC=false;
         linebuypingcangctrlR=false;
         linesellpingcang=false;
         linesellpingcangR=false;
         linesellpingcangC=false;
         linesellpingcangctrlR=false;

         timertrue=true;
         return;
        }
     }
   else
     {
      timertrue=false;
     }
   if(timertrue)
     {
      return;
     }
   if(Lots()>0.0)
     {
      OnTimerswitch=true;
     }
   else
     {
      OnTimerswitch=false;
     }
   if(dingdanxianshi)//订单信息显示在图表
     {
      if(ObjectFind("buy")<0)
        {
         ObjectCreate(0,"buy",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"buy",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"buy",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"buy",OBJPROP_YDISTANCE,dingdanxianshiY);
         ObjectSetText("buy","多单:"+string(GetHoldingbuyOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetbuyLots(),2))+"手"+" 均价 "+string(NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)),12,"黑体",dingdanxianshicolor);
        }
      else
        {
         if(gloxianshijunjian)
           {
            ObjectSetText("buy","多单:"+string(GetHoldingbuyOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetbuyLots(),2))+"手"+" 均价 "+string(NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)),12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectSetText("buy","多单:"+string(GetHoldingbuyOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetbuyLots(),2))+"手",12,"黑体",dingdanxianshicolor);
           }

        }
      if(ObjectFind("sell")<0)
        {
         ObjectCreate(0,"sell",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"sell",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"sell",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"sell",OBJPROP_YDISTANCE,dingdanxianshiY+20);
         ObjectSetText("sell","空单:"+string(GetHoldingsellOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetsellLots(),2))+"手"+" 均价 "+string(NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)),12,"黑体",dingdanxianshicolor);
        }
      else
        {
         if(gloxianshijunjian)
           {
            ObjectSetText("sell","空单:"+string(GetHoldingsellOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetsellLots(),2))+"手"+" 均价 "+string(NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)),12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectSetText("sell","空单:"+string(GetHoldingsellOrdersCount())+"个"+" 共"+string(NormalizeDouble(CGetsellLots(),2))+"手",12,"黑体",dingdanxianshicolor);
           }

        }
      if(ObjectFind("buysell")<0)
        {
         ObjectCreate(0,"buysell",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"buysell",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"buysell",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"buysell",OBJPROP_YDISTANCE,dingdanxianshiY+40);
         ObjectSetText("buysell","buylimit "+string(GetHoldingguadanbuylimitOrdersCount())+" buystop "+string(GetHoldingguadanbuystopOrdersCount())+" selllimit "+string(GetHoldingguadanselllimitOrdersCount())+" sellstop "+string(GetHoldingguadansellstopOrdersCount()),12,"黑体",dingdanxianshicolor);
        }



      else
        {
         ObjectSetText("buysell","buylimit "+string(GetHoldingguadanbuylimitOrdersCount())+" buystop "+string(GetHoldingguadanbuystopOrdersCount())+" selllimit "+string(GetHoldingguadanselllimitOrdersCount())+" sellstop "+string(GetHoldingguadansellstopOrdersCount()),12,"黑体",dingdanxianshicolor);
        }
      /*
            if(ObjectFind("AccountEquity")<0)
              {
               ObjectCreate(0,"AccountEquity",OBJ_LABEL,0,0,0);
               ObjectSetInteger(0,"AccountEquity",OBJPROP_CORNER,CORNER_LEFT_UPPER);
               ObjectSetInteger(0,"AccountEquity",OBJPROP_XDISTANCE,dingdanxianshiX);
               ObjectSetInteger(0,"AccountEquity",OBJPROP_YDISTANCE,dingdanxianshiY+60);
               ObjectSetText("AccountEquity","账户净值:"+DoubleToString(NormalizeDouble(AccountEquity(),2),2)+" "+AccountCurrency(),12,"黑体",dingdanxianshicolor);
              }
            else
              {
               ObjectSetText("AccountEquity","账户净值:"+DoubleToString(NormalizeDouble(AccountEquity(),2),2)+" "+AccountCurrency(),12,"黑体",dingdanxianshicolor);
              }
              */
      if(ObjectFind("AccountFreeMargin")<0)
        {
         ObjectCreate(0,"AccountFreeMargin",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"AccountFreeMargin",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"AccountFreeMargin",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"AccountFreeMargin",OBJPROP_YDISTANCE,dingdanxianshiY+80);
         ObjectSetText("AccountFreeMargin","可用保证金:"+DoubleToString(NormalizeDouble(AccountFreeMargin(),2),2)+" "+AccountCurrency(),12,"黑体",dingdanxianshicolor);
        }
      else
        {
         ObjectSetText("AccountFreeMargin","可用保证金:"+DoubleToString(NormalizeDouble(AccountFreeMargin(),2),2)+" "+AccountCurrency(),12,"黑体",dingdanxianshicolor);
        }
      if(ObjectFind("botoupi")<0)
        {
         ObjectCreate(0,"botoupi",OBJ_LABEL,0,0,0);
         ObjectSetInteger(0,"botoupi",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"botoupi",OBJPROP_XDISTANCE,dingdanxianshiX);
         ObjectSetInteger(0,"botoupi",OBJPROP_YDISTANCE,dingdanxianshiY+100);
         if(Tickmode)
           {
            ObjectSetText("botoupi","剥头皮模式 启用",12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectDelete(0,"botoupi");
           }
        }
      else
        {
         if(Tickmode)
           {
            ObjectSetText("botoupi","剥头皮模式 启用",12,"黑体",dingdanxianshicolor);
           }
         else
           {
            ObjectDelete(0,"botoupi");
           }
        }

      if(imbfxT)
        {
         if(ObjectFind("MBFX")<0)
           {
            ObjectCreate(0,"MBFX",OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,"MBFX",OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetInteger(0,"MBFX",OBJPROP_XDISTANCE,dingdanxianshiX);
            ObjectSetInteger(0,"MBFX",OBJPROP_YDISTANCE,dingdanxianshiY+120);
            ObjectSetText("MBFX","MBFX指标平仓启用",12,"黑体",dingdanxianshicolor);
           }
        }
      else
        {
         if(ObjectFind(0,"MBFX")==0)
            ObjectDelete(0,"MBFX");
        }
      if(iBSTrend)
        {
         if(ObjectFind("iBSTrend")<0)
           {
            ObjectCreate(0,"iBSTrend",OBJ_LABEL,0,0,0);
            ObjectSetInteger(0,"iBSTrend",OBJPROP_CORNER,CORNER_LEFT_UPPER);
            ObjectSetInteger(0,"iBSTrend",OBJPROP_XDISTANCE,dingdanxianshiX);
            ObjectSetInteger(0,"iBSTrend",OBJPROP_YDISTANCE,dingdanxianshiY+140);
            ObjectSetText("iBSTrend","BSTrend指标平仓启用",12,"黑体",dingdanxianshicolor);
           }
        }
      else
        {
         if(ObjectFind(0,"iBSTrend")==0)
            ObjectDelete(0,"iBSTrend");
        }
     }

///////////////////////////////////////////////////////////////////////////////////////////
   if(OnTimerswitch==false)//没有订单时 终止运行
     {
      return;
     }
   if(EAswitch==false)
     {
      return;
     }
   if(huaxianTimeSwitch)//在定时器中使用划线平仓或反锁 布林带平仓
      HuaxianSwitch();
   if(SL5QTPtimeCurrenttrue)//剥头皮 测试中
     {
      if(SL5QTPtimeCurrent+SL5QTPtime<TimeCurrent())
        {
         SLQlotsT=SLQlots;
         if(SL5QTPtimeCurrent+SL5QTPtime1<TimeCurrent())
           {
            yijianpingcangMagic(1688);
            Print("剥头皮等待时间超过",SL5QTPtime1,"秒直接平仓 ",SL5QTPtimeCurrent);
            comment(StringFormat("剥头皮等待时间超过%G秒直接平仓",SL5QTPtime1));
            SL5QTPtimeCurrenttrue=false;
            SLbuylineQpingcangT=false;
            SLbuylineQpingcang=false;
            SLselllineQpingcangT=false;
            SLselllineQpingcang=false;
            if(ObjectFind(0,"SLsellQpengcangline1")==0)
               ObjectDelete(0,"SLsellQpengcangline1");
            if(ObjectFind(0,"SLbuyQpengcangline1")==0)
               ObjectDelete(0,"SLbuyQpengcangline1");
           }
         else
           {
            if(AccountProfit()>0.0)
              {
               yijianpingcangMagic(1688);
               Print("剥头皮等待时间超过",SL5QTPtime,"秒保本平仓 ",SL5QTPtimeCurrent);
               comment(StringFormat("剥头皮等待时间超过%G秒保本平仓",SL5QTPtime));
               SL5QTPtimeCurrenttrue=false;
               SLbuylineQpingcangT=false;
               SLbuylineQpingcang=false;
               SLselllineQpingcangT=false;
               SLselllineQpingcang=false;
               if(ObjectFind(0,"SLsellQpengcangline1")==0)
                  ObjectDelete(0,"SLsellQpengcangline1");
               if(ObjectFind(0,"SLbuyQpengcangline1")==0)
                  ObjectDelete(0,"SLbuyQpengcangline1");
              }
           }
        }
     }
//-----
   if(imbfxT)//依据指标自动平仓 测试阶段
     {
      double mbfx=NormalizeDouble(iCustom(NULL,0,"Custom/MBFX Timing",7,0.0,0,0),4);
      if(mbfx==0.0)
        {
         comment("MBFX指标没有找到 无法启用 请放到Indicators/Custom/MBFX Timing.ex4 ");
         imbfxT=false;
         return;
        }
      if(GetHoldingbuyOrdersCount()>0 && GetHoldingsellOrdersCount()==0.0)//
        {
         if(mbfx>imbfxTmax)
           {
            xunhuanquanpingcang();
            imbfxT=false;
            Print("MBFX指标 大于",imbfxTmax,"自动平仓 ",mbfx);
           }
        }
      else
        {
         if(GetHoldingbuyOrdersCount()==0.0 && GetHoldingsellOrdersCount()>0)//
           {
            if(mbfx<imbfxTmin)
              {
               xunhuanquanpingcang();
               imbfxT=false;
               Print("MBFX指标 小于",imbfxTmin,"自动平仓 ",mbfx);
              }
           }
         else
           {
            comment("没订单或多空单都有 无法启动指标平仓");
            Print("没订单或多空单都有 无法启动指标平仓");
           }
        }
     }
//----
//-----
   if(iBSTrend)//依据指标自动平仓 测试阶段
     {
      double bstrend=NormalizeDouble(iCustom(NULL,0,"Custom/bstrend-indicator",12,0,0),5);
      //Print(bstrend);
      if(bstrend==0.0)
        {
         comment("BSTrend指标没有找到 无法启用 请放到Indicators/Custom/bstrend-indicator.ex4 ");
         Print("BSTrend指标没有找到 无法启用 或刚好当前的数值等于0");
         iBSTrend=false;
         return;
        }
      if(GetHoldingbuyOrdersCount()>0 && GetHoldingsellOrdersCount()==0.0)//
        {
         if(bstrend<imbfxTmin)
           {
            xunhuanquanpingcang();
            iBSTrend=false;
            Print("BSTrend指标 小于",iBSTrendmin,"多单自动平仓 ",bstrend);
           }
        }
      else
        {
         if(GetHoldingbuyOrdersCount()==0.0 && GetHoldingsellOrdersCount()>0)//
           {
            if(bstrend>iBSTrendmax)
              {
               xunhuanquanpingcang();
               iBSTrend=false;
               Print("BSTrend指标 大于",iBSTrendmax,"空单自动平仓 ",bstrend);
              }
           }
         else
           {
            comment("没订单或多空单都有 无法启动指标平仓");
            Print("没订单或多空单都有 无法启动指标平仓");
           }
        }
     }

   if(linebuypingcangC)//触及横线全平仓 定时器
     {
      // Print("触及横线全平仓 定时器");
      if(buyline<buylineOnTimer && buyline>=Bid)//横线在当前价之下
        {
         xunhuanquanpingcang();
         linebuypingcangC=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }

      if(buyline>buylineOnTimer && buyline<=Bid)//横线在当前价之上
        {
         xunhuanquanpingcang();
         linebuypingcangC=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }

   if(linesellpingcangC)//触及横线全平仓 定时器
     {
      //Print("触及横线全平仓 定时器");
      if(sellline>selllineOnTimer && sellline<=Bid)//横线在当前价之上
        {
         xunhuanquanpingcang();
         linesellpingcangC=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
      if(sellline<selllineOnTimer && sellline>=Bid)//横线在当前价之下
        {
         xunhuanquanpingcang();
         linesellpingcangC=false;
         linelock=false;
         if(ObjectFind(0,"Buy Line")==0)
            ObjectDelete(0,"Buy Line");
         if(ObjectFind(0,"Sell Line")==0)
            ObjectDelete(0,"Sell Line");
        }
     }
   if(timeGMTYesNo1 && timeGMT1==D'1970.01.01 00:00:00')//定时器1 ea自动止盈止损主程序 Time1
     {
      timeGMT1=TimeGMT();
      //Print("定时器1启用 ",TimeGMT());
     }
   else
     {
      if(timeGMTYesNo1 && TimeGMT()>=timeGMT1+timeGMTSeconds1)
        {
         //Print("定时器1时间到 ea自动止盈止损主程序 处理中 . . . ",TimeGMT());
         ///////////////////////////////////////////////////////////////////////////////////// 挂靠定时器执行的相关代码
         if(linelock==false)//横线模式执行后 清场
           {
            linebuykaicang=false;
            linesellkaicang=false;
            linekaicangshiftR=false;
            linekaicangT=false;
            linebuypingcang=false;
            linebuypingcangR=false;
            linebuypingcangC=false;
            linebuypingcangctrlR=false;
            linesellpingcang=false;
            linesellpingcangR=false;
            linesellpingcangC=false;
            linesellpingcangctrlR=false;
           }
         shangpress=0;
         xiapress=0;
         leftpress=0;
         rightpress=0;//清除方向键按下次数 挂靠定时器1执行
         keylotshalf=keylots;
         SLlinepingcangjishu1=0;//
         buydangeshu=GetHoldingbuyOrdersCount();
         selldangeshu=GetHoldingsellOrdersCount();//定时更新订单个数 挂靠定时器1执行
         bkey=false;
         skey=false;
         tkey=false;
         lkey=false;
         pkey=false;
         kkey=false;
         okey=false;
         akey=false;
         shiftR=false;
         shift=false;
         ctrl=false;
         ctrlR=false;
         tab=false;//定时清除按键状态 挂靠定时器1执行
         ////////////////////////////////////////////////////////////////////////////////////////////////////
         if(GetLastError()==129)
           {
            linebuykaicang=false;
            linesellkaicang=false;
            if(ObjectFind(0,"Buy Line")==0)
               ObjectDelete(0,"Buy Line");
            if(ObjectFind(0,"Sell Line")==0)
               ObjectDelete(0,"Sell Line");
           }
         /////////////////////////////////////////////////////////////////////////////
         if(EAswitch==false)
            return;
         if(fansuoYes)
            return;//如果反锁订单时 不执行自动止盈止损
         for(int cnt=0; cnt<OrdersTotal(); cnt++) //ea止盈止损主程序
           {
            if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
              {
               if(OrderSymbol()==Symbol() && autosttp)
                 {
                  double stp=OrderStopLoss();
                  double tpt=OrderTakeProfit();
                  double OpenPrice=OrderOpenPrice();

                  if(OriginalLot==0)
                    {
                     OriginalLot=OrderLots();
                    }
                  if(OrderType()==OP_BUY)
                    {
                     if(AutoStoploss && AutoTakeProfit && stp==0 && tpt==0)
                        bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice-Point*stoploss,OpenPrice+Point*takeprofit,0,CLR_NONE);
                     else
                       {
                        if(AutoStoploss && stp==0)
                          {
                           bool a2=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice-Point*stoploss,OrderTakeProfit(),0,CLR_NONE);
                          }

                        if(AutoTakeProfit && tpt==0)
                          {
                           bool a3=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OpenPrice+Point*takeprofit,0,CLR_NONE);
                          }

                        if(AutoTrailingStop && ((Bid-OpenPrice)>Point*TrailingStop))
                          {
                           if((Bid-stp)>TrailingStop*Point)
                              bool a4=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*TrailingStop,OrderTakeProfit(),0,CLR_NONE);
                          }
                       }
                    }
                  if(OrderType()==OP_SELL)
                    {

                     if(AutoStoploss && AutoTakeProfit && stp==0 && tpt==0)
                        bool a5=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice+Point*stoploss,OpenPrice-Point*takeprofit,0,CLR_NONE);
                     else
                       {
                        if(AutoStoploss && stp==0)
                          {
                           bool a6=OrderModify(OrderTicket(),OrderOpenPrice(),OpenPrice+Point*stoploss,OrderTakeProfit(),0,CLR_NONE);
                          }
                        if(AutoTakeProfit && tpt==0)
                          {
                           bool a7=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OpenPrice-Point*takeprofit,0,CLR_NONE);
                          }

                        if(AutoTrailingStop && ((OpenPrice-Ask)>Point*TrailingStop))
                          {
                           if((stp-Ask)>TrailingStop*Point)
                              bool a8=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,OrderTakeProfit(),0,CLR_NONE);
                          }
                       }
                    }
                 }
              }
            else
              {
               OriginalLot=0;
              }
           }
         timeGMT1=TimeGMT();
        }
     }



   if(timeGMTYesNo3 && timeGMT3==D'1970.01.01 00:00:00')//定时器3
     {
      timeGMT3=TimeGMT();
      Print("定时器3启用 ",TimeLocal());
     }
   else
     {
      if(timeGMTYesNo3 && TimeGMT()>=timeGMT3+timeGMTSeconds3)
        {
         //Print("定时器3时间到 处理中 . . . ",TimeGMT());
         if(buytrue03)
           {
            if(GetiLowest(timeframe03,bars03,beginbar03)-pianyiliang03*Point<timebuyprice)
              {
               Print("不后移SL");
              }
            else
              {
               PiliangSL(buytrue03,GetiLowest(timeframe03,bars03,beginbar03),jianju03,pianyiliang03,juxianjia03,dingdangeshu03);
               timebuyprice=GetiLowest(timeframe03,bars03,beginbar03)-pianyiliang03*Point;
              }
           }
         else
           {
            if(GetiHighest(timeframe03,bars03,beginbar03)+pianyiliang03*Point>timesellprice)
              {
               Print("不后移SL");
              }
            else
              {
               PiliangSL(buytrue03,GetiHighest(timeframe03,bars03,beginbar03),jianju03,pianyiliang03,juxianjia03,dingdangeshu03);
               timesellprice=GetiHighest(timeframe03,bars03,beginbar03)+pianyiliang03*Point;
              }
           }
         //juxianjiadingshi03=true;
         timeGMT3=TimeGMT();
        }
     }



   if(timeGMTYesNo4 && timeGMT4==D'1970.01.01 00:00:00')//定时器4
     {
      timeGMT4=TimeGMT();
      Print("定时器4启用 ",TimeLocal());
     }



   else
     {
      if(timeGMTYesNo4 && TimeGMT()>=timeGMT4+timeGMTSeconds4)
        {
         Print("定时器4时间到 处理中 . . . ",TimeLocal());
         if(buytrue04)
           {
            PiliangTP(buytrue04,GetiHighest(timeframe04,bars04,beginbar04),jianju04,pianyiliang04tp,juxianjia04,dingdangeshu04);
           }
         else
           {
            PiliangTP(buytrue04,GetiLowest(timeframe04,bars04,beginbar04),jianju04,pianyiliang04tp,juxianjia04,dingdangeshu04);
           }
         //juxianjiadingshi03=true;
         timeGMT4=TimeGMT();
        }
     }



   if(timeGMTYesNo5 && timeGMT5==D'1970.01.01 00:00:00')//定时器5
     {
      timeGMT5=TimeGMT();
      Print("定时器5启用 ",TimeLocal());
     }



   else
     {
      if(timeGMTYesNo5 && TimeGMT()>=timeGMT5+timeGMTSeconds5)
        {
         Print("定时器5时间到 处理中 . . . ",TimeLocal());
         if(buytrue05)
           {
            PiliangSL(buytrue05,GetiLowest(dingshitimeframe05,dingshibars05,dingshibeginbar05),dingshijianju05,dingshipianyiliang05,dingshijuxianjia05,dingshidingdangeshu05);
           }
         else
           {
            PiliangSL(buytrue05,GetiHighest(dingshitimeframe05,dingshibars05,dingshibeginbar05),dingshijianju05,dingshipianyiliang05,dingshijuxianjia05,dingshidingdangeshu05);
           }
         //juxianjiadingshi03=true;
         timeGMT5=TimeGMT();
        }
     }



   if(timeGMTYesNo6 && timeGMT6==D'1970.01.01 00:00:00')//定时器6
     {
      timeGMT6=TimeGMT();
      Print("定时器6启用 ",TimeLocal());
     }



   else
     {
      if(timeGMTYesNo6 && TimeGMT()>=timeGMT6+timeGMTSeconds6)
        {
         Print("定时器6时间到 处理中 . . . ",TimeLocal());
         if(buytrue06)
           {
            PiliangTP(buytrue06,GetiHighest(dingshitimeframe06,dingshibars06,dingshibeginbar06),dingshijianju06,dingshipianyiliang06tp,dingshijuxianjia06,dingshidingdangeshu06);
           }
         else
           {
            PiliangTP(buytrue06,GetiLowest(dingshitimeframe06,dingshibars06,dingshibeginbar06),dingshijianju06,dingshipianyiliang06tp,dingshijuxianjia06,dingshidingdangeshu06);
           }
         //juxianjiadingshi03=true;
         timeGMT6=TimeGMT();
        }
     }

   if(Tickmode==true)//Tick模式如果启用
     {
      return;
     }
   else
     {
      if(EAswitch==false)
         return;
      if(fansuoYes)
         return;
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
           {
            int ti=OrderTicket();
            double open=OrderOpenPrice();
            string zhushi=OrderComment();
            if(Gradually==true && OrderSymbol()==Symbol() && OrderType()==OP_BUY && Bid>=OrderOpenPrice()+TrailingStop*Point)
              {
               string from=StringSubstr(OrderComment(),0,4);
               if(zhushi=="" || from!="from")
                 {
                  bool oc=OrderClose(OrderTicket(),NormalizeDouble(OrderLots()/GraduallyNum,xiaoshudian),Bid,slippage);
                  if(oc==true)
                     PlaySound("ok.wav");
                 }
               else
                 {
                  int ticket=StrToInteger(StringSubstr(OrderComment(),6,0));
                  if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)==true)
                    {
                     double hlot=OrderLots();
                     double hcp=OrderClosePrice();
                     double bid=open+TrailingStop*Point;
                     for(int n=GraduallyNum; n>0; n--)
                       {
                        bid+=NormalizeDouble((takeprofit-TrailingStop)/(GraduallyNum-1),0)*Point;
                        if(Bid>=bid && bid>=hcp+minTP*Point)
                          {
                           bool oc=OrderClose(ti,hlot,Bid,slippage,CLR_NONE);
                           if(oc==true)
                             {
                              PlaySound("ok.wav");
                              break;
                             }
                          }
                       }
                    }
                 }
              }
            if(Gradually==true && OrderSymbol()==Symbol() && OrderType()==OP_SELL && Ask<=OrderOpenPrice()-TrailingStop*Point)
              {
               string from=StringSubstr(OrderComment(),0,4);
               if(zhushi=="" || from!="from")
                 {
                  bool oc=OrderClose(OrderTicket(),NormalizeDouble(OrderLots()/GraduallyNum,xiaoshudian),Ask,slippage);
                  if(oc==true)
                     PlaySound("ok.wav");
                 }
               else
                 {
                  int ticket=StrToInteger(StringSubstr(OrderComment(),6,0));
                  if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)==true)
                    {
                     double hlot=OrderLots();
                     double hcp=OrderClosePrice();
                     double ask=open-TrailingStop*Point;
                     for(int n=GraduallyNum; n>0; n--)
                       {
                        ask-=NormalizeDouble((takeprofit-TrailingStop)/(GraduallyNum-1),0)*Point;
                        if(Ask<=ask && ask<=hcp-minTP*Point)
                          {
                           bool oc=OrderClose(ti,hlot,Ask,slippage,CLR_NONE);
                           if(oc==true)
                             {
                              PlaySound("ok.wav");
                              break;
                             }
                          }
                       }
                    }
                 }
              }
           }
        }
     }
  }
////////////////////////////////////////////////////////////////////////////////////////////////
//EA运行代码结束 下面是自定义函数
double Lots()//当前货币对的订单仓位总数 不含挂单 不区分反锁单
  {
   double lots=0.0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               lots+=OrderLots();
              }
           }
     }
   return(lots);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closecode()//分步平仓
  {
// Print("closecode函数运行");
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         int ti=OrderTicket();
         double open=OrderOpenPrice();
         string zhushi=OrderComment();
         if(Gradually==true && OrderSymbol()==Symbol() && OrderType()==OP_BUY && Bid>=OrderOpenPrice()+TrailingStop*Point)
           {
            string from=StringSubstr(OrderComment(),0,4);
            if(zhushi=="" || from!="from")
              {
               bool oc=OrderClose(OrderTicket(),NormalizeDouble(OrderLots()/GraduallyNum,xiaoshudian),Bid,slippage);
               if(oc==true)
                  PlaySound("ok.wav");
              }
            else
              {
               int ticket=StrToInteger(StringSubstr(OrderComment(),6,0));
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)==true)
                 {
                  double hlot=OrderLots();
                  double hcp=OrderClosePrice();
                  double bid=open+TrailingStop*Point;
                  for(int n=GraduallyNum; n>0; n--)
                    {
                     bid+=NormalizeDouble((takeprofit-TrailingStop)/(GraduallyNum-1),0)*Point;
                     if(Bid>=bid && bid>=hcp+minTP*Point)
                       {
                        bool oc=OrderClose(ti,hlot,Bid,slippage,CLR_NONE);
                        if(oc==true)
                          {
                           PlaySound("ok.wav");
                           break;
                          }
                       }
                    }
                 }
              }
           }
         if(Gradually==true && OrderSymbol()==Symbol() && OrderType()==OP_SELL && Ask<=OrderOpenPrice()-TrailingStop*Point)
           {
            string from=StringSubstr(OrderComment(),0,4);
            if(zhushi=="" || from!="from")
              {
               bool oc=OrderClose(OrderTicket(),NormalizeDouble(OrderLots()/GraduallyNum,xiaoshudian),Ask,slippage);
               if(oc==true)
                  PlaySound("ok.wav");
              }
            else
              {
               int ticket=StrToInteger(StringSubstr(OrderComment(),6,0));
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY)==true)
                 {
                  double hlot=OrderLots();
                  double hcp=OrderClosePrice();
                  double ask=open-TrailingStop*Point;
                  for(int n=GraduallyNum; n>0; n--)
                    {
                     ask-=NormalizeDouble((takeprofit-TrailingStop)/(GraduallyNum-1),0)*Point;
                     if(Ask<=ask && ask<=hcp-minTP*Point)
                       {
                        bool oc=OrderClose(ti,hlot,Ask,slippage,CLR_NONE);
                        if(oc==true)
                          {
                           PlaySound("ok.wav");
                           break;
                          }
                       }
                    }
                 }
              }
           }
        }
     }
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zuizaokeyclose()//平最早下的一单
  {
// for(int cnt=OrdersTotal()-1;cnt>=0;cnt--)
   for(int cnt=0; cnt<OrdersTotal(); cnt++)












     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY && OrderSymbol()==Symbol())
           {
            // Print(OrderTicket()," 订单选择成功");
            bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
            if(oc)
              {
               PlaySound("ok.wav");
               return;
              }
            else
              {
               PlaySound("timeout.wav");
               Print("Error=",GetLastError());
              }
           }
         else
           {
            if(OrderType()==OP_SELL && OrderSymbol()==Symbol())
              {
               //  Print(OrderTicket()," 订单选择成功");
               bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
               if(oc)
                 {
                  PlaySound("ok.wav");
                  return;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("Error=",GetLastError());
                 }
              }
           }
        }



      else
        {
         Print("订单选择失败");
         return;
        }
     }
  }


















//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zuijinkeyclose()//平最近下的一单
  {
   for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)












      //  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderType()==OP_BUY && OrderSymbol()==Symbol())
           {
            // Print(OrderTicket()," 订单选择成功");
            bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
            if(oc)
              {
               PlaySound("ok.wav");
               return;
              }
            else
              {
               PlaySound("timeout.wav");
               Print("Error=",GetLastError());
              }
           }
         else
           {
            if(OrderType()==OP_SELL && OrderSymbol()==Symbol())
              {
               //   Print(OrderTicket()," 订单选择成功");
               bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);
               if(oc)
                 {
                  PlaySound("ok.wav");
                  return;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("Error=",GetLastError());
                 }
              }
           }
        }



      else
        {
         Print("订单选择失败");
         return;
        }
     }
  }


















//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zuidakeyclose()//平最大价格的一单
  {
   int ti=0;
   int ty=0;
   int op=0;
   int ticket[200]= {};
   int type[200];
   double openprice[200];
   for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)












      //  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==0 || OrderType()==1)
              {
               ticket[ti]=OrderTicket();
               openprice[op]=OrderOpenPrice();
               type[ty]=OrderType();
               ti++;
               ty++;
               op++;
              }
           }
     }
   int maxopen=ArrayMaximum(openprice,op,0);
   int minopen=ArrayMinimum(openprice,op,0);
   int maxticket=ticket[maxopen];
   int minticket=ticket[minopen];






   if(OrderSelect(maxticket,SELECT_BY_TICKET)==true)
     {
      //Print(maxticket," 订单选择成功");
      bool oc=OrderClose(maxticket,OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);



      if(oc==true)
        {
         PlaySound("ok.wav");
         return;
        }
      else
        {
         PlaySound("timeout.wav");
         Print("Error=",GetLastError());
        }
     }
   /*
      if(OrderSelect(minticket,SELECT_BY_TICKET)==true)
        {
         Print(minticket," 订单选择成功");
         bool oc=OrderClose(minticket,OrderLots(),OrderClosePrice(),3,CLR_NONE);
         if(oc==true)
           {
            PlaySound("ok.wav");
            return;
           }
         else PlaySound("timeout.wav");
        }
   */
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zuixiaokeyclose()//平最小价格的一单
  {
   int ti=0;
   int ty=0;
   int op=0;
   int ticket[200]= {};
   int type[200];
   double openprice[200];
   for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
      //  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==0 || OrderType()==1)
              {
               ticket[ti]=OrderTicket();
               openprice[op]=OrderOpenPrice();
               type[ty]=OrderType();
               ti++;
               ty++;
               op++;
              }
           }
     }
   int maxopen=ArrayMaximum(openprice,op,0);
   int minopen=ArrayMinimum(openprice,op,0);
   int maxticket=ticket[maxopen];
   int minticket=ticket[minopen];






   /*
      if(OrderSelect(maxticket,SELECT_BY_TICKET)==true)
        {
         Print(maxticket," 订单选择成功");
         bool oc=OrderClose(maxticket,OrderLots(),OrderClosePrice(),3,CLR_NONE);
         if(oc==true)
           {
            PlaySound("ok.wav");
            return;
           }
         else PlaySound("timeout.wav");
        }
        */

   if(OrderSelect(minticket,SELECT_BY_TICKET)==true)
     {
      //Print(minticket," 订单选择成功");
      bool oc=OrderClose(minticket,OrderLots(),OrderClosePrice(),keyslippage,CLR_NONE);



      if(oc==true)
        {
         PlaySound("ok.wav");
         return;
        }
      else
        {
         PlaySound("timeout.wav");
         Print("Error=",GetLastError());
        }
     }

  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void xunhuanquanpingcang()//循环语句的当前货币对全平仓 没平完会一直平
  {
   int jishu=0;
   while(xunhuandingdanshu()!=0)
     {
      for(int cnt=OrdersTotal()-1; cnt>=0; cnt--)
         //  for(int cnt=0;cnt<OrdersTotal();cnt++)
        {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
           {
            if(OrderType()==OP_BUY && OrderSymbol()==Symbol())
              {
               // Print(OrderTicket()," 订单选择成功");
               bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
               if(oc)
                 {
                  PlaySound("ok.wav");
                  jishu++;
                 }
               else
                 {
                  PlaySound("timeout.wav");
                  Print("Error=",GetLastError());
                 }
              }
            else
              {
               if(OrderType()==OP_SELL && OrderSymbol()==Symbol())
                 {
                  //   Print(OrderTicket()," 订单选择成功");
                  bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
                  if(oc)
                    {
                     PlaySound("ok.wav");
                     jishu++;
                    }
                  else
                    {
                     PlaySound("timeout.wav");
                     Print("Error=",GetLastError());
                    }
                 }
              }
           }
         else
           {
            Print("订单选择失败");
           }
         if(jishu>=pingcangdingdanshu)
           {
            Print("已预定计划平仓最近的",jishu,"单 ");
            pingcangdingdanshu=1000;
            jishu=0;
            return;
           }
        }
     }
  }



/*
void xunhuanquanpingcangMagic(int xunhuanMagic)//循环语句的当前货币对全平仓 没平完会一直平
  {
   while(xunhuandingdanshu()!=0)
     {
      for(int cnt=OrdersTotal()-1;cnt>=0;cnt--)



         //  for(int cnt=0;cnt<OrdersTotal();cnt++)
        {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
           {
            if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==xunhuanMagic)
              {
               // Print(OrderTicket()," 订单选择成功");
               bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
               if(oc)
                 {
                  PlaySound("ok.wav");
                 }
               else{PlaySound("timeout.wav");Print("Error=",GetLastError());}
              }
            else
              {
               if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==xunhuanMagic)
                 {
                  //   Print(OrderTicket()," 订单选择成功");
                  bool oc=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE);
                  if(oc)
                    {
                     PlaySound("ok.wav");

                    }
                  else{PlaySound("timeout.wav");Print("Error=",GetLastError());}
                 }
              }
           }
         else
           {
            Print("订单选择失败");
           }
        }
     }
  }

  int xunhuandingdanshuMagic()
  {
   int aa=0;
   for(int cntt=OrdersTotal()-1;cntt>=0;cntt--)

     {
      if(OrderSelect(cntt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==xunhuanMagic)
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               aa++;
              }
           }
        }
     }
   if(aa==0)Print("全部平仓成功");else Print("当前货币对订单数 ",aa);
   return(aa);
  }


*/




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int xunhuandingdanshu()
  {
   int aa=0;
   for(int cntt=OrdersTotal()-1; cntt>=0; cntt--)

     {
      if(OrderSelect(cntt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               aa++;
              }
           }
        }
     }
   if(aa==0)
      Print("全部平仓成功");
   else
      Print("当前货币对订单数 ",aa);
   return(aa);
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getbuySL(double price,int bars) //price 当前的买价
  {
   double ATRSL;
   double LowSL;
   ATRSL=price-80*Point+(Ask-Bid); //ATRSL 当前的买价减去多少个点再加上点差，固定止损值，如果在一分钟五分钟 短周期图表上下单请修改成适合自己的止损值。
   LowSL=Low[iLowest(NULL,0,MODE_LOW,bars,0)]; //LowSL 当前图表时间周期下从最新的一个k线开始往后(也就是往左)数15根k线，取其中的最低点的价格作为止损值，也可以固定时间周期，修改NULL后面的数值0，15，60，240
//LowSL 如果想修改取最低值的参考K线范围，请修改倒数第二个数字，倒数第一个0就是从最新的k线开始，往左数到多少根k线结束。
//下面是做判断，根据不同的条件返回不同的止损值
   if((ATRSL<LowSL) && (ATRSL<=price))
     {
      return(ATRSL);  //如果市场处于震荡中，ATRSL<LowSL 直接取ATRSL 之前设定的固定止损值。
     }
   else
      if((ATRSL>LowSL) && (LowSL<=price))
        {
         return(LowSL-(Ask-Bid));  //如果处于单边市场中， ATRSL>LowSL 如果ATRSL预设的止损比较小，使用最频繁的就是这个 取LowSL的值再减个点差 作为止损值
        }
      else
         if((price<ATRSL) && (price<LowSL))
           {
            return(price-80*Point);  //当前点差过大，当前的买价小于预设的两个止损值，那就直接从当前买价price减去多少点作为新的止损值
           }
   return(price-200*Point);
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getsellSL(double price,int bars) //price 当前的卖价
  {
   double ATRSL;
   double HighSL;
   ATRSL=price+80*Point-(Ask-Bid); //ATRSL 当前的卖价加上多少个点再加个点差，固定止损值，如果在一分钟五分钟 短周期图表上下单请修改成适合自己的止损值。
   HighSL=High[iHighest(NULL,0,MODE_HIGH,bars,0)]; //HighSL 当前图表时间周期下从最新的一个k线开始往后(也就是往左)数15根k线，取其中的最高点的价格作为止损值，也可以固定时间周期，修改NULL后面的数值0，15，60，240
//HighSL 如果想修改取最高值的参考K线范围，请修改倒数第二个数字，倒数第一个0就是从最新的k线开始，往左数到多少根k线结束。
   if((ATRSL>HighSL) && (ATRSL>=price))
     {
      return(ATRSL);  //如果市场处于震荡中，ATRSL>HighSL 直接取ATRSL 之前设定的固定止损值。
     }
   else
      if((ATRSL<HighSL) && (HighSL>=price))
        {
         return(HighSL+Ask-Bid+5*Point);  //如果处于单边市场中， ATRSL<HighSL 如果ATRSL预设的止损比较小，使用最频繁的就是这个 取HighSL的值再加个点差 作为止损值
        }
      else
         if((price>ATRSL) && (price>HighSL))
           {
            return(price+80*Point);  //当前点差过大，当前的卖价大于预设的两个止损值，那就直接从当前卖价price加上多少点作为新的止损值
           }
   return(price+200*Point);
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double HoldingOrderbuyAvgPrice()//多单平均价
  {
   double Tmp=0;
   double TotalLots=0;
   for(int i=OrdersTotal()-1; i>=0; i--)












     {
      bool os=OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true;



      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
        {
         Tmp+=OrderOpenPrice()*OrderLots();
         TotalLots+=OrderLots();
        }
     }
   if(TotalLots==0)
      return(0);
   else
      return(Tmp/TotalLots);
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double HoldingOrdersellAvgPrice()//空单平均价
  {
   double Tmp=0;
   double TotalLots=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      bool os=OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true;



      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
        {
         Tmp+=OrderOpenPrice()*OrderLots();
         TotalLots+=OrderLots();
        }
     }
   if(TotalLots==0)
      return(0);
   else
      return(Tmp/TotalLots);
  }





















/* fanxiangsuodan
只能在只有单向订单情况下使用，如果有多空单，可能会进入死循环一直下单，切记！！！
如果不慎进入死循环一直开单，请立即关闭MT4上面的 自动交易 按钮，
原理：
按时间排序，从最早的一单开始依次判断订单类型，然后开反向的同手数订单，直到多空手数相等，
由于只是简单的从最早的一单开始对订单进行判断并处理，如果有多空单时，尤其是每单不同手数的
多空单，造成多空总手数一直不相等而进入死循环一直下单，最好的使用方法是在单向订单的情况下
使用，最好使用统一的下单手数，这样可以尽量避免进入死循环，而且可以解决部分同时有多空单的问题，
比如你下了很多 多单，行情不对，手动锁了几单之后，又想用这个脚本全锁，由于最早下的都是多单，
所以脚本运行之后一直在开空单，之前你手动锁的空单离现在最近，脚本运行不到你下空单的位置就因为
多空总手数相等而退出了。
*/
void fanxiangsuodan() //一键批量开反向单锁仓只有同向单时使用
  {
   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      if(buyLots()==sellLots())
        {
         Alert(Symbol(),"  已经处于锁仓状态 ");
         return;
        }



      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         double lots=OrderLots();
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
           {
            int b1=OrderSend(Symbol(),OP_SELL,lots,Bid,5,0,0,NULL,0,0,CLR_NONE);
            if(b1>0)
              {
               PlaySound("ok.wav");
               if(buyLots()==sellLots())
                 {
                  Alert(Symbol(),"  buy单锁仓成功 ");
                  return;
                 }
              }
           }
         else
           {
            if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
              {
               int s1=OrderSend(Symbol(),OP_BUY,lots,Ask,5,0,0,NULL,0,0,CLR_NONE);
               if(s1>0)
                 {
                  PlaySound("ok.wav");
                  if(buyLots()==sellLots())
                    {
                     Alert(Symbol(),"  sell单锁仓成功 ");
                     return;
                    }
                 }
              }
           }
        }
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double buyLots()
  {
   double buylots=0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_BUY)
              {
               buylots+=OrderLots();
              }
     }
   return(buylots);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double sellLots()
  {
   double selllots=0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_SELL)
              {
               selllots+=OrderLots();
              }
     }
   return(selllots);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zhinengguadanbuylimit()//智能buylimit单
  {
   if(expirationM==0)
      expiration=0;
   double guadansl=0,guadantp=0;
   double ask;
   ask=Low[iLowest(NULL,zhinengtimeframe,MODE_LOW,zhinenga,zhinengb)]+press();
   if(Ask<ask+zhinengguadanjuxianjia*Point)
      ask=Ask-zhinengguadanjuxianjia*Point;
   if(zhinengguadanzengjiabuy!=0)
      ask+=zhinengguadanzengjiabuy*Point;
   for(int i=zhinengguadangeshu; i>0; i--)












     {
      if(zhinengguadanSL!=0)
         guadansl=ask-zhinengguadanSL*Point;
      if(zhinengguadanTP!=0)
         guadantp=ask+zhinengguadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_BUYLIMIT,zhinengguadanlots,ask,zhinengguadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);



      if(ticket>0)
        {
         PlaySound("ok.wav");
         ask-=zhinengguadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zhinengguadanbuystop()//智能buystop单
  {
   if(expirationM==0)
      expiration=0;
   double guadansl=0,guadantp=0;
   double ask;
   ask=High[iHighest(NULL,zhinengtimeframe,MODE_HIGH,zhinenga,zhinengb)]+press();
   if(Ask>ask-zhinengguadanjuxianjia*Point)
      ask=Ask+zhinengguadanjuxianjia*Point;
   if(zhinengguadanzengjiabuystop!=0)
      ask+=zhinengguadanzengjiabuystop*Point;
   for(int i=zhinengguadangeshu; i>0; i--)












     {
      if(zhinengguadanSL!=0)
         guadansl=ask-zhinengguadanSL*Point;
      if(zhinengguadanTP!=0)
         guadantp=ask+zhinengguadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_BUYSTOP,zhinengguadanlots,ask,zhinengguadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);



      if(ticket>0)
        {
         PlaySound("ok.wav");
         ask+=zhinengguadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zhinengguadanselllimit()//智能selllimit单
  {
   if(expirationM==0)
      expiration=0;
   double guadansl=0,guadantp=0;
   double bid;
   bid=High[iHighest(NULL,zhinengtimeframe,MODE_HIGH,zhinenga,zhinengb)]+press();
   if(Bid>bid-zhinengguadanjuxianjia*Point)
      bid=Bid+zhinengguadanjuxianjia*Point;
   if(zhinengguadanzengjiasell!=0)
      bid-=zhinengguadanzengjiasell*Point;
   for(int i=zhinengguadangeshu; i>0; i--)


     {
      if(zhinengguadanSL!=0)
         guadansl=bid+zhinengguadanSL*Point;
      if(zhinengguadanTP!=0)
         guadantp=bid-zhinengguadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_SELLLIMIT,zhinengguadanlots,bid,zhinengguadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);



      if(ticket>0)
        {
         PlaySound("ok.wav");
         bid+=zhinengguadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void zhinengguadansellstop()//智能sellstop单
  {
   if(expirationM==0)
      expiration=0;
   double guadansl=0,guadantp=0;
   double bid;
   bid=Low[iLowest(NULL,zhinengtimeframe,MODE_LOW,zhinenga,zhinengb)]+press();
   if(Bid<bid+zhinengguadanjuxianjia*Point)
      bid=Bid-zhinengguadanjuxianjia*Point;
   if(zhinengguadanzengjiasellstop!=0)
      bid-=zhinengguadanzengjiasellstop*Point;
   for(int i=zhinengguadangeshu; i>0; i--)



     {
      if(zhinengguadanSL!=0)
         guadansl=bid+zhinengguadanSL*Point;
      if(zhinengguadanTP!=0)
         guadantp=bid-zhinengguadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_SELLSTOP,zhinengguadanlots,bid,zhinengguadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);



      if(ticket>0)
        {
         PlaySound("ok.wav");
         bid-=zhinengguadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }



/* 临时弃用
void guadanbuylimit()//委买单
  {
   if(expirationM==0) expiration=0;
   double guadansl=0,guadantp=0;
   double ask,bid;
   bid=Bid+guadanjuxianjia*Point;//距离现价的点数
   ask=Ask-guadanjuxianjia*Point;
   for(int i=guadangeshu;i>0;i--)



     {
      if(guadanSL!=0) guadansl=ask-guadanSL*Point;
      if(guadanTP!=0) guadantp=ask+guadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_BUYLIMIT,guadanlots,ask,guadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);
      if(ticket>0)
        {
         PlaySound("ok.wav");
         ask-=guadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }
void guadanselllimit()//委卖单
  {
   if(expirationM==0) expiration=0;
   double guadansl=0,guadantp=0;
   double ask,bid;
   bid=Bid+guadanjuxianjia*Point;//距离现价的点数
   ask=Ask-guadanjuxianjia*Point;
   for(int i=guadangeshu;i>0;i--)
     {
      if(guadanSL!=0) guadansl=bid+guadanSL*Point;
      if(guadanTP!=0) guadantp=bid-guadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_SELLLIMIT,guadanlots,bid,guadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);
      if(ticket>0)
        {
         PlaySound("ok.wav");
         bid+=guadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }
void guadanbuystop()//突破追买单
  {
   if(expirationM==0) expiration=0;
   double guadansl=0,guadantp=0;
   double ask,bid;
   bid=Bid+guadanjuxianjia*Point;//距离现价的点数
   ask=Ask+guadanjuxianjia*Point;
   for(int i=guadangeshu;i>0;i--)
     {
      if(guadanSL!=0) guadansl=ask-guadanSL*Point;
      if(guadanTP!=0) guadantp=ask+guadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_BUYSTOP,guadanlots,ask,guadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);
      if(ticket>0)
        {
         PlaySound("ok.wav");
         ask+=guadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }
void guadansellstop()//突破追卖单
  {
   if(expirationM==0) expiration=0;
   double guadansl=0,guadantp=0;
   double ask,bid;
   bid=Bid-guadanjuxianjia*Point;//距离现价的点数
   ask=Ask-guadanjuxianjia*Point;
   for(int i=guadangeshu;i>0;i--)
     {
      if(guadanSL!=0) guadansl=bid+guadanSL*Point;
      if(guadanTP!=0) guadantp=bid-guadanTP*Point;
      int ticket=OrderSend(Symbol(),OP_SELLSTOP,guadanlots,bid,guadanslippage,guadansl,guadantp,NULL,0,expiration,CLR_NONE);
      if(ticket>0)
        {
         PlaySound("ok.wav");
         bid-=guadanjianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
  }
  */
void pingguadan()//批量平挂单
  {
//---
   int tick[1000]= {-1};
   int pingFlag=0,slipPage=3;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }



   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)
        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUY) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
                         {
                          if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                            {pingFlag=1;Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
                          }
                     if(OrderSymbol()==Symbol() && cmd==OP_SELL)
                         {
                          if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                             {pingFlag=1;Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
                          }
             */
            if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
              {
               if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                 {pingFlag=1; Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
              }
            else
               if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                 {
                  if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                    {pingFlag=1; Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                 }
               else
                  if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                    {
                     if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                       {pingFlag=1; Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                    }
                  else
                     if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                       {
                        if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                          {pingFlag=1; Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                       }
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平挂单成功"); PlaySound("ok.wav");}
   else
     {Print("平仓失败，再来一次"); PlaySound("timeout.wav");}
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void yijianpingcang()//一键平仓
  {
   int tick[200]= {-1};
   int pingFlag=0,slipPage=5;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }
   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)
        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();

            if(OrderSymbol()==Symbol() && cmd==OP_BUY) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                 {pingFlag=1; Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
              }
            if(OrderSymbol()==Symbol() && cmd==OP_SELL)
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                 {pingFlag=1; Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
              }
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
            */
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平单成功"); PlaySound("ok.wav");}
   else
     {Alert("平仓失败，再来一次"); PlaySound("timeout.wav");}

  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void yijianpingcangMagic(int Magic)//一键平仓
  {
   int tick[200]= {-1};
   int pingFlag=0,slipPage=5;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }
   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)
        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();

            if(OrderSymbol()==Symbol() && cmd==OP_BUY && OrderMagicNumber()==Magic) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                 {pingFlag=1; Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
              }
            if(OrderSymbol()==Symbol() && cmd==OP_SELL && OrderMagicNumber()==Magic)
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                 {pingFlag=1; Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
              }
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
            */
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平单成功"); PlaySound("ok.wav");}
   else
     {Print("平仓失败，再来一次"); PlaySound("timeout.wav");}

  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void yijianpingbuydan()
  {
   int tick[200]= {-1};
   int pingFlag=0,slipPage=3;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)


     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }



   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)



        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();

            if(OrderSymbol()==Symbol() && cmd==OP_BUY) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                 {pingFlag=1; Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
              }
            /*            if(OrderSymbol()==Symbol() && cmd==OP_SELL)
                          {
                           if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                             {pingFlag=1;Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
                          }

                        if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
            */
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平单成功"); PlaySound("ok.wav");}
   else
     {Alert("平仓失败，再来一次"); PlaySound("timeout.wav");}

  }





















//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void yijianpingselldan()
  {
   int tick[200]= {-1};
   int pingFlag=0,slipPage=3;
   int j=0,i;
   for(i=0; i<OrdersTotal(); i++)


     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         j++;
         tick[j]=OrderTicket();
         // Print("全部平仓：",tick[j]);
        }
      else
        {
         Print("订单选择失败：",GetLastError());
        }
     }



   if(j!=0) //如果有持仓
     {
      for(i=1; i<=j; i++)



        {
         int ticket=tick[i];
         if(OrderSelect(ticket,SELECT_BY_TICKET)==true)
           {
            int cmd=OrderType();
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUY) //判定订单是否是当前图表商品和订单类型，如果需要所有订单平仓，请去掉  OrderSymbol() == Symbol() && ，下面类同。
                          {
                           if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),slipPage)==false)
                             {pingFlag=1;Print("多头平仓失败:",GetLastError()," 订单号：",ticket);}
                          }*/
            if(OrderSymbol()==Symbol() && cmd==OP_SELL)
              {
               if(OrderClose(ticket,OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),slipPage)==false)
                 {pingFlag=1; Print("空头平仓失败：",GetLastError()," 订单号：",ticket);}
              }
            /*
                        if(OrderSymbol()==Symbol() && cmd==OP_BUYLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLLIMIT)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Limit挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_BUYSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("多头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
                        else if(OrderSymbol()==Symbol() && cmd==OP_SELLSTOP)
                          {
                           if(OrderDelete(OrderTicket(),CLR_NONE)==false)
                             {pingFlag=1;Print("空头Stop挂单撤销失败：",GetLastError()," 订单号：",ticket);}
                          }
            */
           }
         else
           {Print("选择订单失败：",GetLastError()," 订单号：",ticket);}
        }
     }
   if(pingFlag==0)
     {Print("平单成功"); PlaySound("ok.wav");}
   else
     {Alert("平仓失败，再来一次"); PlaySound("timeout.wav");}

  }




















//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void yijianfanshou()//一键反手
  {
   if(GetHoldingbuyOrdersCount()>0 && GetHoldingsellOrdersCount()>0)
     {
      Print("当前订单方向不统一 无法一键反手开仓");
      comment("当前订单方向不统一 无法一键反手开仓");
     }
   else
     {
      Print("一键反手开仓执行 当前订单平仓处理中");
      comment("一键反手开仓执行 当前订单平仓处理中");
      if(CGetbuyLots()>0.0 &&CGetsellLots()==0.0)
        {
         yijianfanshouselllots=CGetbuyLots();
         xunhuanquanpingcang();
         int keysell=OrderSend(Symbol(),OP_SELL,yijianfanshouselllots,Bid,keyslippage,0,0,NULL,0,0);
         if(keysell>0)
           {
            PlaySound("ok.wav");
            Print("一键反手开仓成功");
            comment("一键反手开仓成功");
            yijianfanshouselllots=0.0;
            return;
           }
         else
           {
            PlaySound("timeout.wav");
           }
        }
      if(CGetbuyLots()==0.0 &&CGetsellLots()>0.0)
        {
         yijianfanshoubuylots=CGetsellLots();
         xunhuanquanpingcang();
         int keybuy=OrderSend(Symbol(),OP_BUY,yijianfanshoubuylots,Ask,keyslippage,0,0,NULL,0,0);
         if(keybuy>0)
           {
            PlaySound("ok.wav");
            Print("一键反手开仓成功");
            comment("一键反手开仓成功");
            yijianfanshoubuylots=0.0;
            return;
           }
         else
           {
            PlaySound("timeout.wav");
           }
        }
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void suocang()//一键锁仓
  {
   if(CGetbuyLots()==CGetsellLots())
     {
      Alert(Symbol()," 已经处于锁仓状态 或 空仓");
      return;
     }
   else
     {
      if(CGetbuyLots()>CGetsellLots())
         CLockOrder(OP_SELL);//If buy order lots>sell lots,send sell order to lock.如果多单大于空单，开空单锁仓
      if(CGetbuyLots()<CGetsellLots())
         CLockOrder(OP_BUY);//If buy order lots<sell lots,send buy order to lock.如果多单小于空单，开多单锁仓
     }
  }
//+----------------------------锁仓程序(Lock Order)-------------------+
void CLockOrder(int m_Ordertype)
  {

   if(m_Ordertype==OP_BUY)
     {
      //if(OrderSend(Symbol(),OP_BUY,CGetsellLots()-CGetbuyLots(),Ask,5,0,0,NULL,0,0))
      int keybuy=OrderSend(Symbol(),OP_BUY,CGetsellLots()-CGetbuyLots(),Ask,5,0,0,NULL,0,0);
      if(keybuy>0)
        {
         PlaySound("ok.wav");
         Alert(Symbol()," 锁仓成功");
        }
      else
        {
         PlaySound("timeout.wav");
         Print("Error=",GetLastError());
        }
     }

   if(m_Ordertype==OP_SELL)//rrr
     {
      // if(OrderSend(Symbol(),OP_SELL,CGetbuyLots()-CGetsellLots(),Bid,5,0,0,NULL,0,0))
      int keysell=OrderSend(Symbol(),OP_SELL,CGetbuyLots()-CGetsellLots(),Bid,5,0,0,NULL,0,0);
      if(keysell>0)
        {
         PlaySound("ok.wav");
         Alert(Symbol()," 锁仓成功");
        }
      else
        {
         PlaySound("timeout.wav");
         Print("GetLastError=",GetLastError());
        }
     }
// return(0);
  }

//+--------------计算buy下单量Calculate Buy Order Lots----------------+
double CGetbuyLots()
  {
   double m_buylots=0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_BUY)
              {
               m_buylots+=OrderLots();
              }
     }
   return(m_buylots);
  }
//+--------------------------------------------------------------------+
//+--------------计算sell下单量Calculate Sell Order Lots---------------+
double CGetsellLots()
  {
   double m_selllots=0;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol())
            if(OrderType()==OP_SELL)
              {
               m_selllots+=OrderLots();
              }
     }

   return(m_selllots);
  }
//+--------------------------------------------------------------------+
int GetHoldingbuyOrdersCount()//计算多单个数
  {
   int buyCount=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
           {
            buyCount+=1;
           }
     }
   return(buyCount);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingsellOrdersCount()//计算空单个数
  {
   int sellCount=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
           {
            sellCount+=1;
           }
     }
   return(sellCount);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingdingdanguadanOrdersCount()//计算顶单及挂单总个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)

     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUYLIMIT)
           {
            geshu+=1;
           }
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELLLIMIT)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL)
        {
         geshu+=1;
        }
     }
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadanOrdersCount()//计算挂单个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)

     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUYLIMIT)
           {
            geshu+=1;
           }
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELLLIMIT)
        {
         geshu+=1;
        }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP)
        {
         geshu+=1;
        }
     }
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadanbuylimitOrdersCount()//计算挂单buylimit个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUYLIMIT)
           {
            geshu+=1;
           }
     }
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadanbuystopOrdersCount()//计算挂单buystop个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUYSTOP)
           {
            geshu+=1;
           }
     }
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadanselllimitOrdersCount()//计算挂单selllimit个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELLLIMIT)
           {
            geshu+=1;
           }
     }
   return(geshu);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHoldingguadansellstopOrdersCount()//计算挂单sellstop个数
  {
   int geshu=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELLSTOP)
           {
            geshu+=1;
           }
     }
   return(geshu);
  }

/*
void zhinengsl()//批量智能设置止损
  {
   double bid=0,ask=0;



   if(SL==0.0)
     {
      bid=zhinenggetbuySL(Bid);
      ask=zhinenggetsellSL(Ask);
     }



   else
     {
      if(SL<Bid)
        {
         bid=SL;
         ask=zhinenggetsellSL(Ask);
        }
      else
        {
         ask=SL;
         bid=zhinenggetbuySL(Bid);
        }
     }
   for(int  i=0;i<OrdersTotal();i++)



     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && onlybuy)
           {
            bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),bid+press(),OrderTakeProfit(),0);
            bid-=c*Point;
           }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && onlysell)
        {
         bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),ask+press(),OrderTakeProfit(),0);
         ask+=c*Point;
        }
     }
   PlaySound("ok.wav");
  }



double zhinenggetbuySL(double price)
  {
   double ATRSL;
   double LowSL;
   ATRSL=price-(e+d)*Point;
   LowSL=Low[iLowest(NULL,timeframe,MODE_LOW,a,b)];
   if((ATRSL<LowSL) && (ATRSL<=price)) {return(ATRSL);}
   else if((ATRSL>LowSL) &&(LowSL<=price)) {return(LowSL-(Ask-Bid)-d*Point);}
   else if((price<ATRSL) && (price<LowSL)) {return(price-e*10*Point);}
   return(price-300*Point);
  }



double zhinenggetsellSL(double price)
  {
   double ATRSL;
   double HighSL;
   ATRSL=price+(e+d)*Point;
   HighSL=High[iHighest(NULL,timeframe,MODE_HIGH,a,b)];
   if((ATRSL>HighSL) && (ATRSL>=price)) {return(ATRSL);}
   else if((ATRSL<HighSL) && (HighSL>=price)) {return(HighSL+(Ask-Bid)+d*Point);}
   else if((price>ATRSL) && (price>HighSL)) {return(price+e*10*Point);}
   return(price+300*Point);
  }



void zhinengtp()//批量智能设置止盈
  {
   double bid=0,ask=0;



   if(TP==0.0)
     {
      bid=zhinenggetbuyTP(Ask);
      ask=zhinenggetsellTP(Bid);
     }
   else
     {
      if(TP>Bid)
        {
         ask=TP;
         bid=zhinenggetbuyTP(Ask);
        }
      else
        {
         bid=TP;
         ask=zhinenggetsellTP(Bid);
        }
     }
   for(int  i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && onlybuy)
           {
            bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ask+press(),0);
            ask+=c*Point;
           }
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && onlysell)
        {
         bool a1=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),bid+press(),0);
         bid-=c*Point;
        }
     }
   PlaySound("ok.wav");
  }



double zhinenggetbuyTP(double price)
  {
   double ATRSL;
   double LowSL;
   ATRSL=price-(e+d)*Point;
   LowSL=Low[iLowest(NULL,timeframe,MODE_LOW,a,b)];
   if((ATRSL<LowSL) && (ATRSL<=price)) {return(ATRSL);}
   else if((ATRSL>LowSL) &&(LowSL<=price)) {return(LowSL+(Ask-Bid)-d*Point);}
   else if((price<ATRSL) && (price<LowSL)) {return(price-e*10*Point);}
   return(price-300*Point);
  }



double zhinenggetsellTP(double price)
  {
   double ATRSL;
   double HighSL;
   ATRSL=price+(e+d)*Point;
   HighSL=High[iHighest(NULL,timeframe,MODE_HIGH,a,b)];
   if((ATRSL>HighSL) && (ATRSL>=price)) {return(ATRSL);}
   else if((ATRSL<HighSL) && (HighSL>=price)) {return(HighSL-(Ask-Bid)+d*Point);}
   else if((price>ATRSL) && (price>HighSL)) {return(price+e*10*Point);}
   return(price+300*Point);
  }

//| 本脚本参考了 批量设置止盈止损的脚本.mq4 感谢原作者 boolapi
//|   xyz  2016.07.09 xyz0217@live.cn

*/
void piliangsltp()//批量修改止盈止损点数或直接输入价位的脚本
  {
   int iTp=TargetProfit,iSl=StopLoss;
   bool bOrderModify;
   double dTargetProfit,cStopLoss;
   if(Digits==3 || Digits==5)
     {
      iTp*=10;
      iSl*=10;
     }

   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;



      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && onlybuy)
        {
         if(StopLoss==0 && TargetProfit==0 && FixedStopLoss==0.0 && FixedTargetProfit==0.0)
           {
            dTargetProfit=0;
            cStopLoss=0;
           }
         else
           {
            if(FixedTargetProfit!=0.0)
               dTargetProfit=FixedTargetProfit;
            else
              {
               if(iTp==0)
                  dTargetProfit=OrderTakeProfit();
               else
                  dTargetProfit=OrderOpenPrice()+Point*iTp;
              }
            if(FixedStopLoss!=0.0)
               cStopLoss=FixedStopLoss;
            else
              {
               if(iSl==0)
                  cStopLoss=OrderStopLoss();
               else
                  cStopLoss=OrderOpenPrice()-Point*iSl;
              }
           }
         bOrderModify=OrderModify(OrderTicket(),
                                  OrderOpenPrice(),
                                  cStopLoss,
                                  dTargetProfit,
                                  0);
         if(GetLastError()==4109)
           {
            MessageBox("请在\"工具\"->\"选项\"->\"EA交易\"里勾选\"启用EA交易系统\"","设置止盈止损",0);
            return;
           }
        }



      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && onlysell)
        {
         if(StopLoss==0 && TargetProfit==0 && FixedStopLoss==0.0 && FixedTargetProfit==0.0)
           {
            dTargetProfit=0;
            cStopLoss=0;
           }
         else
           {
            if(FixedTargetProfit!=0.0)
               dTargetProfit=FixedTargetProfit;
            else
              {
               if(iTp==0)
                  dTargetProfit=OrderTakeProfit();
               else
                  dTargetProfit=OrderOpenPrice()-Point*iTp;
              }
            if(FixedStopLoss!=0.0)
               cStopLoss=FixedStopLoss;
            else
              {
               if(iSl==0)
                  cStopLoss=OrderStopLoss();
               else
                  cStopLoss=OrderOpenPrice()+Point*iSl;
              }
           }
         bOrderModify=OrderModify(OrderTicket(),
                                  OrderOpenPrice(),
                                  cStopLoss,
                                  dTargetProfit,
                                  0);
         if(!bOrderModify)
            if(GetLastError()==4109)
              {
               MessageBox("请在\"工具\"->\"选项\"->\"EA交易\"里勾选\"启用EA交易系统\"","设置止盈止损",0);
               return;
              }
        }
     }
   PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void piliangTPdianshu(int dianshu)//
  {
   if(bkey)
     {
      Print("多单批量移动止盈到均价的",dianshu,"个基点上 处理中 . . .");
      comment(StringFormat("多单批量移动止盈到均价的%G个基点上 处理中 . . .",dianshu));
     }
   if(skey)
     {
      Print("空单批量移动止盈到均价的",dianshu,"个基点上 处理中 . . .");
      comment(StringFormat("空单批量移动止盈到均价的%G个基点上 处理中 . . .",dianshu));
     }
   double baobenbuyTP=NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)+dianshu*Point;
   double baobensellTP=NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)-dianshu*Point;
   for(int  i=0; i<OrdersTotal(); i++)












     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && bkey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),baobenbuyTP,0);
            baobenbuyTP+=piliangtpjianju*Point;
           }
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && skey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),baobensellTP,0);
            baobensellTP-=piliangtpjianju*Point;
           }
        }
     }
   PlaySound("ok.wav");
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void piliangSLdianshu(int dianshu)
  {
   if(bkey)
     {
      Print("多单批量移动止损到均价的",dianshu,"个基点上 处理中 . . .");
      comment(StringFormat("多单批量移动止损到均价的%G个基点上 处理中 . . .",dianshu));
     }
   if(skey)
     {
      Print("空单批量移动止损到均价的",dianshu,"个基点上 处理中 . . .");
      comment(StringFormat("空单批量移动止损到均价的%G个基点上 处理中 . . .",dianshu));
     }
   double baobenbuySL=NormalizeDouble(HoldingOrderbuyAvgPrice(),Digits)-dianshu*Point;
   double baobensellSL=NormalizeDouble(HoldingOrdersellAvgPrice(),Digits)+dianshu*Point;
   for(int  i=0; i<OrdersTotal(); i++)












     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && bkey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),baobenbuySL,OrderTakeProfit(),0);
            baobenbuySL-=piliangsljianju*Point;
           }
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && skey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),baobensellSL,OrderTakeProfit(),0);
            baobensellSL+=piliangsljianju*Point;
           }
        }
     }
   PlaySound("ok.wav");
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void piliangTPnowdianshu(int dianshu)
  {
   if(bkey)
     {
      Print("多单批量移动止盈到现价的",dianshu,"个基点上 处理中 . . .");
      comment(StringFormat("多单批量移动止盈到现价的%G个基点上 处理中 . . .",dianshu));
     }
   if(skey)
     {
      Print("空单批量移动止盈到现价的",dianshu,"个基点上 处理中 . . .");
      comment(StringFormat("空单批量移动止盈到现价的%G个基点上 处理中 . . .",dianshu));
     }
   double bid=Bid+dianshu*Point;
   double ask=Ask-dianshu*Point;
   for(int  i=0; i<OrdersTotal(); i++)












     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && bkey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),bid,0);
            bid+=piliangtpjianju*Point;
           }
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && skey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ask,0);
            ask-=piliangtpjianju*Point;
           }
        }
     }
   PlaySound("ok.wav");
  }


















//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void piliangSLnowdianshu(int dianshu)
  {
   if(bkey)
     {
      Print("多单批量移动止损到现价的",dianshu,"个基点上 处理中 . . .");
      comment(StringFormat("多单批量移动止损到现价的%G个基点上 处理中 . . .",dianshu));
     }
   if(skey)
     {
      Print("空单批量移动止损到现价的",dianshu,"个基点上 处理中 . . .");
      comment(StringFormat("空单批量移动止损到现价的%G个基点上 处理中 . . .",dianshu));
     }
   double bid=Bid-dianshu*Point;
   double ask=Ask+dianshu*Point;
   for(int  i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && bkey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),bid,OrderTakeProfit(),0);
            bid-=piliangtpjianju*Point;
           }
         if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && skey)
           {
            bool om=OrderModify(OrderTicket(),OrderOpenPrice(),ask,OrderTakeProfit(),0);
            ask+=piliangtpjianju*Point;
           }
        }
     }
   PlaySound("ok.wav");
  }


















//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void comment(string str)//订单信息显示在图表
  {
   if(dingdanxianshi)
     {
      ObjectCreate(0,"zi",OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,"zi",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(0,"zi",OBJPROP_XDISTANCE,dingdanxianshiX1);
      ObjectSetInteger(0,"zi",OBJPROP_YDISTANCE,dingdanxianshiY1);
      ObjectSetText("zi",str,16,"黑体",dingdanxianshicolor);
     }
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void comment1(string str)//订单信息显示在图表副本
  {
   if(dingdanxianshi)
     {
      ObjectCreate(0,"zi1",OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,"zi1",OBJPROP_CORNER,CORNER_RIGHT_UPPER);
      ObjectSetInteger(0,"zi1",OBJPROP_XDISTANCE,dingdanxianshiX2);
      ObjectSetInteger(0,"zi1",OBJPROP_YDISTANCE,dingdanxianshiY2);
      ObjectSetText("zi1",str,16,"黑体",dingdanxianshicolor);
     }
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void movesttp()//移动当前价的止盈止损
  {
   for(int cnt=0; cnt<OrdersTotal(); cnt++) //移动止盈止损
     {
      if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if(OrderSymbol()==Symbol())
           {
            double stp=OrderStopLoss();
            double tpt=OrderTakeProfit();
            double OpenPrice=OrderOpenPrice();

            if(OriginalLot==0)
              {
               OriginalLot=OrderLots();
              }
            if(OrderType()==OP_BUY && onlybuy1)
              {
               if(stp==0 && tpt==0)
                  return;
               else
                 {
                  if(stp!=0 && onlystp)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),stp-moveSTTP*Point,OrderTakeProfit(),0,CLR_NONE);
                    }
                  if(stp!=0 && onlyup)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),stp+moveSTTP*Point,OrderTakeProfit(),0,CLR_NONE);
                    }

                  if(tpt!=0 && onlytpt)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tpt+Point*moveSTTP,0,CLR_NONE);
                    }
                  if(tpt!=0 && onlydown)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tpt-Point*moveSTTP,0,CLR_NONE);
                    }
                 }
              }
            if(OrderType()==OP_SELL && onlysell1)
              {
               if(stp==0 && tpt==0)
                  return;
               else
                 {
                  if(stp!=0 && onlystp)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),stp+moveSTTP*Point,OrderTakeProfit(),0,CLR_NONE);
                    }
                  if(stp!=0 && onlydown)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),stp-moveSTTP*Point,OrderTakeProfit(),0,CLR_NONE);
                    }

                  if(tpt!=0 && onlytpt)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tpt-Point*moveSTTP,0,CLR_NONE);
                    }
                  if(tpt!=0 && onlyup)
                    {
                     bool om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),tpt+Point*moveSTTP,0,CLR_NONE);
                    }
                 }
              }
           }
        }



      else
        {
         OriginalLot=0;
        }
     }
   PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetiLowest(int Timeframe,int bars,int beginbar)
  {
   double LowSL=Low[iLowest(NULL,Timeframe,MODE_LOW,bars,beginbar)];
   return LowSL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetiHighest(int Timeframe,int bars,int beginbar)
  {
   double HighSL=High[iHighest(NULL,Timeframe,MODE_HIGH,bars,beginbar)];
   return HighSL;
  }
void PiliangSL(bool buytrue,double price,int jianju,int pianyiliang,int juxianjia,int dingdangeshu)//buytrue 如果是buy单就是true sell单就是false //pianyiliang 正数是正向偏移 负数是反向偏移

  {
   int jishu=0;
   bool om;
   double bid=0,ask=0;
//if(juxianjiadingshi03==false)
//  {
   if(buytrue && price+juxianjia*Point>Ask)
      price=Ask-juxianjia*Point;
   if(buytrue==false && price-juxianjia*Point<Bid)
      price=Bid+juxianjia*Point;
//   }
   ask=price-pianyiliang*Point;
   bid=price+pianyiliang*Point;
   for(int i=OrdersTotal()-1; i>=0; i--)

     {
      if(jishu>=dingdangeshu)
         break;



      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && buytrue)
           {
            om=OrderModify(OrderTicket(),OrderOpenPrice(),ask,OrderTakeProfit(),0);
            ask-=jianju*Point;
            jishu+=1;
           }



      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && buytrue==false)
        {
         om=OrderModify(OrderTicket(),OrderOpenPrice(),bid,OrderTakeProfit(),0);
         bid+=jianju*Point;
         jishu+=1;
        }
     }
   if(om)
      PlaySound("ok.wav");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PiliangTP(bool buytrue,double price,int jianju,int pianyiliang,int juxianjia,int dingdangeshu)//buytrue 如果是buy单就是true sell单就是false
  {
   int jishu=0;
   bool om;
   double bid=0,ask=0;
//if(juxianjiadingshi03==false)
//  {
   if(buytrue && price-juxianjia*Point<Bid)
      price=Bid+juxianjia*Point;
   if(buytrue==false && price+juxianjia*Point>Ask)
      price=Ask-juxianjia*Point;
//   }
   ask=price-pianyiliang*Point;
   bid=price+pianyiliang*Point;
   for(int i=OrdersTotal()-1; i>=0; i--)















     {
      if(jishu>=dingdangeshu)
         break;



      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderSymbol()==Symbol() && OrderType()==OP_BUY && buytrue)
           {
            om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),ask,0);
            ask+=jianju*Point;
            jishu+=1;
           }



      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL && buytrue==false)
        {
         om=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),bid,0);
         bid-=jianju*Point;
         jishu+=1;
        }
     }
   if(om)
      PlaySound("ok.wav");
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
      int ticket=OrderSend(Symbol(),OP_BUYLIMIT,lots,price,slippage,guadansl,guadantp,NULL,0,0,CLR_NONE);



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






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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
      int ticket=OrderSend(Symbol(),OP_SELLLIMIT,lots,price,slippage,guadansl,guadantp,NULL,0,0,CLR_NONE);



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









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Guadanbuystop(double lots,double price,int geshu,int jianju,double sl,double tp,int juxianjia)//突破追买单
  {
   double guadansl=0,guadantp=0;
   if(Ask+juxianjia*Point>price)
      price=Ask+juxianjia*Point;
   for(int i=geshu; i>0; i--)












     {
      if(sl!=0)
         guadansl=price-sl*Point;
      if(tp!=0)
         guadantp=price+tp*Point;
      int ticket=OrderSend(Symbol(),OP_BUYSTOP,lots,price,slippage,guadansl,guadantp,NULL,0,0,CLR_NONE);



      if(ticket>0)
        {
         price+=jianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
   PlaySound("ok.wav");
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Guadansellstop(double lots,double price,int geshu,int jianju,double sl,double tp,int juxianjia)//突破追卖单
  {
   double guadansl=0,guadantp=0;
   if(Bid-juxianjia*Point<price)
      price=Bid-juxianjia*Point;
   for(int i=geshu; i>0; i--)
     {
      if(sl!=0)
         guadansl=price+sl*Point;
      if(tp!=0)
         guadantp=price-tp*Point;
      int ticket=OrderSend(Symbol(),OP_SELLSTOP,lots,price,slippage,guadansl,guadantp,NULL,0,0,CLR_NONE);
      if(ticket>0)
        {
         price-=jianju*Point;
        }
      else
         PlaySound("timeout.wav");
     }
   PlaySound("ok.wav");
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
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


















//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Tenguadan(bool buyorsell,int weishu,double max)//整数位追单
  {
   if(max>MarketInfo(Symbol(),MODE_SPREAD))
      max=MarketInfo(Symbol(),MODE_SPREAD);
   double bid=StrToDouble(StringSubstr(DoubleToString(Bid,Digits),0,weishu));



   if(buyorsell)
     {
      double price=bid+(max+tenbuypianyiliang)*Point+press();
      Print("现价 ",Bid," 忽略尾数后程序计算结果",bid," 智能计算后buylimit开始挂单价位",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      //if(price+stoplevel*Point>Ask) Print("挂单离现价过近 在停止水平位挂单"); price=Ask-(stoplevel+3)*Point;

      Guadanbuylimit(tenGuadanlots,price,tenGuadangeshu,tenGuadanjianju,tenGuadansl,tenGuadantp,tenGuadanjuxianjia);
     }



   else
     {
      int digits=1000;
      int geshu=StringLen(DoubleToString(Bid,Digits));
      int huluegeshu=geshu-weishu;
      if(huluegeshu==0)
         digits=1;
      if(huluegeshu==1)
         digits=10;
      if(huluegeshu==2)
         digits=100;
      if(huluegeshu==3)
         digits=1000;
      if(huluegeshu==4)
         digits=10000;
      if(huluegeshu==5)
         digits=100000;
      if(huluegeshu==6)
         digits=1000000;
      Print("挂selllimit单计算整数位需要加的点数",digits);
      double price=bid+digits*Point-tensellpianyiliang*Point+press();
      Print("现价 ",Bid,"忽略尾数后程序计算结果",bid," 智能计算后selllimit挂单价位 ",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      //if(Bid+stoplevel*Point>price) Print("挂单离现价过近 在停止水平位挂单"); price=Bid+(stoplevel+3)*Point;
      Guadanselllimit(tenGuadanlots,price,tenGuadangeshu,tenGuadanjianju,tenGuadansl,tenGuadantp,tenGuadanjuxianjia);
     }
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Tensltp(bool buyorsell,bool SLtrue,int weishu,double max)//整数位追单
  {
   if(max>MarketInfo(Symbol(),MODE_SPREAD))
      max=MarketInfo(Symbol(),MODE_SPREAD);
   double bid=StrToDouble(StringSubstr(DoubleToString(Bid,Digits),0,weishu));



   if(buyorsell && SLtrue)
     {
      double price=bid-max*Point+press();
      Print("现价 ",Bid," 忽略尾数后程序计算结果",bid," 智能计算后buy单SL价位",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      //if(price+stoplevel*Point>Ask) Print("挂单离现价过近 在停止水平位挂单"); price=Ask-(stoplevel+3)*Point;
      PiliangSL(true,price,tensltpjianju,tensltppianyiliang,tensltpjuxianjia,tensltpdingdangeshu);
     }



   if(!buyorsell && !SLtrue)
     {
      double price=bid+max*Point+press();
      Print("现价 ",Bid," 忽略尾数后程序计算结果",bid," 智能计算后sell单TP价位",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      PiliangTP(false,price,tensltpjianju,tentppianyiliang,tensltpjuxianjia,tensltpdingdangeshu);
     }



   if(buyorsell && !SLtrue)
     {
      int digits=1000;
      int geshu=StringLen(DoubleToString(Bid,Digits));
      int huluegeshu=geshu-weishu;
      if(huluegeshu==0)
         digits=1;
      if(huluegeshu==1)
         digits=10;
      if(huluegeshu==2)
         digits=100;
      if(huluegeshu==3)
         digits=1000;
      if(huluegeshu==4)
         digits=10000;
      if(huluegeshu==5)
         digits=100000;
      if(huluegeshu==6)
         digits=1000000;
      Print("计算整数位需要加的点数",digits);
      double price=bid+digits*Point+press();
      Print("现价 ",Bid,"忽略尾数后程序计算结果",bid," 智能计算后buy单TP价位 ",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      //if(Bid+stoplevel*Point>price) Print("挂单离现价过近 在停止水平位挂单"); price=Bid+(stoplevel+3)*Point;
      PiliangTP(true,price,tensltpjianju,tentppianyiliang,tensltpjuxianjia,tensltpdingdangeshu);

     }



   if(!buyorsell && SLtrue)
     {
      int digits=1000;
      int geshu=StringLen(DoubleToString(Bid,Digits));
      int huluegeshu=geshu-weishu;
      if(huluegeshu==0)
         digits=1;
      if(huluegeshu==1)
         digits=10;
      if(huluegeshu==2)
         digits=100;
      if(huluegeshu==3)
         digits=1000;
      if(huluegeshu==4)
         digits=10000;
      if(huluegeshu==5)
         digits=100000;
      if(huluegeshu==6)
         digits=1000000;
      Print("计算整数位需要加的点数",digits);
      double price=bid+digits*Point+MarketInfo(Symbol(),MODE_SPREAD)*Point+press();
      Print("现价 ",Bid,"忽略尾数后程序计算结果",bid," 智能计算后sell单SL价位 ",price," 保险措施 如果点差过大使用参数的固定值 当前点差",MarketInfo(Symbol(),MODE_SPREAD));
      PiliangSL(false,price,tensltpjianju,tensltppianyiliang,tensltpjuxianjia,tensltpdingdangeshu);
     }

  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void buysellnowSL(bool buyorsell,double lots,int Timeframe,int bars,int beginbars,double pianyiliang)//带止损下单
  {
   if(buyorsell)
     {
      Print("市价buy ",lots,"手 带止损 取",bars,"根K线计算 处理中 . . .");
      comment(StringFormat("市价buy %G手 带止损 取%G根K线计算 处理中 . . .",lots,bars));

      if(testtradeSLSP)//是否支持直接带止损下单
        {
         double buysl=GetiLowest(Timeframe,bars,beginbars)-(MarketInfo(Symbol(),MODE_SPREAD)+pianyiliang)*Point;//rrr
         int buySLticket=OrderSend(Symbol(),OP_BUY,lots,Ask,keyslippage,buysl,0,NULL,0,0);
         if(buySLticket>0)
           {
            PlaySound("ok.wav");
           }
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",GetLastError());
            falsetimeCurrent=TimeCurrent();
           }
        }
      else
        {
         int buySLticket1=OrderSend(Symbol(),OP_BUY,lots,Ask,keyslippage,0,0,NULL,0,0);
         if(buySLticket1>0)
           {
            PlaySound("ok.wav");
            if(OrderSelect(buySLticket1,SELECT_BY_TICKET,MODE_TRADES)==true)
              {
               double buysl1=GetiLowest(Timeframe,bars,beginbars)-(MarketInfo(Symbol(),MODE_SPREAD)+pianyiliang)*Point;
               bool keybuy1=OrderModify(OrderTicket(),OrderOpenPrice(),buysl1,0,0);
              }
           }
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",GetLastError());
            falsetimeCurrent=TimeCurrent();
           }
        }
     }

   else
     {
      Print("市价sell ",lots,"手 带止损 取",bars,"根K线计算 处理中 . . .");
      comment(StringFormat("市价sell %G手 带止损 取%G根K线计算 处理中 . . .",lots,bars));
      if(testtradeSLSP)
        {
         double sl=GetiHighest(Timeframe,bars,beginbars)+(MarketInfo(Symbol(),MODE_SPREAD)*2+pianyiliang)*Point;
         int sellSLticket=OrderSend(Symbol(),OP_SELL,lots,Bid,keyslippage,sl,0,NULL,0,0);
         if(sellSLticket>0)
            PlaySound("ok.wav");
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",GetLastError());
            falsetimeCurrent=TimeCurrent();
           }
        }



      else
        {
         int sellSLticket=OrderSend(Symbol(),OP_SELL,lots,Bid,keyslippage,0,0,NULL,0,0);
         if(sellSLticket>0)
           {
            PlaySound("ok.wav");
            if(OrderSelect(sellSLticket,SELECT_BY_TICKET,MODE_TRADES)==true)
              {
               double sl=GetiHighest(Timeframe,bars,beginbars)+(MarketInfo(Symbol(),MODE_SPREAD)*2+pianyiliang)*Point;
               bool keysell=OrderModify(OrderTicket(),OrderOpenPrice(),sl,0,0);
              }
           }
         else
           {
            PlaySound("timeout.wav");
            Print("GetLastError=",GetLastError());
            falsetimeCurrent=TimeCurrent();
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string swaptype()//过夜库存费计算方法
  {
   int Num=(int)MarketInfo(Symbol(),MODE_SWAPTYPE);



   switch(Num)
     {
      case 0:
         return(" 隔夜库存费计算方法 - 点数计算");
      case 1:
         return(" 隔夜库存费计算方法 - 交易品种基础货币计算");
      case 2:
         return(" 隔夜库存费计算方法 - 通过利息");
      case 3:
         return(" 隔夜库存费计算方法 - 点数计算");
      default:
         return(" 隔夜库存费计算方法 Unknown");
     }
  }






//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// === 获取订单ID ===
void GetOrdersID()
  {
   int i,n,t,o;
   bool all;
   n=OrdersTotal();
   ArrayResize(OrdersID,n);
   all=StringFind(管理持仓单号,"*")>=0;
   OpType= -1;
   for(i = 0,OrdersCount = 0; i<n; i++)
     {
      bool aa=OrderSelect(i,SELECT_BY_POS);



      if(Symbol()==OrderSymbol())
        {
         t=OrderTicket();
         if(all || (StringFind(管理持仓单号,DoubleToStr(t,0))>=0))
           {
            o=OrderType();
            if(o<2)
              {
               if((OpType>=0) && (o!=OpType))
                 {
                  OpType=-1;
                  break;
                 }
               else
                 {
                  OpType=o;
                  OrdersID[OrdersCount]=t;
                  OrdersCount++;
                 }
              }
           }
        }
     }



   if(OrdersCount==0)
     {
      ObjectDelete(TPObjName);
      ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      //------------
      建仓价=0;
      移动止损=0;

     }
  }
// === 寻找获利止损线 ===
void SearchObjName(int Type,bool GetTPObj=true,bool GetSLObj=true)
  {
   int    i,ObjType,iAbove,iBelow,iTP,iSL;
   double MinAbove,MaxBelow,y1,y2;
   string ObjName;

   MinAbove = 999999;
   MaxBelow = 0;
   iAbove   = -1;
   iBelow   = -1;
   for(i=0; i<ObjectsTotal(); i++)
     {
      ObjName = ObjectName(i);
      ObjType = ObjectType(ObjName);
      switch(ObjType)
        {
         case OBJ_TREND :
         case OBJ_TRENDBYANGLE :
            y1 = CalcLineValue(ObjName, 0, 1, ObjType);
            y2 = y1;
            break;
         case OBJ_CHANNEL :
            y1 = CalcLineValue(ObjName, 0, MODE_UPPER, ObjType);
            y2 = CalcLineValue(ObjName, 0, MODE_LOWER, ObjType);
            break;
         default :
            y1 = -1;
            y2 = -1;
        }



      if((y1>0) && (y1<Bid) && (y1>MaxBelow)) // 两条线都在当前价下方
        {
         MaxBelow = y1;
         iBelow   = i;
        }



      else
         if((y2>Bid) && (y2<MinAbove)) // 两条线都在当前价上方
           {
            MinAbove = y2;
            iAbove   = i;
           }



         else                // 两条线一上一下
           {
            if((y1>0) && (y1<MinAbove))
              {
               MinAbove = y1;
               iAbove   = i;
              }
            if(y2>MaxBelow)
              {
               MaxBelow = y2;
               iBelow   = i;
              }
           }
     }



   switch(Type)
     {
      case OP_BUY :
         iTP = iAbove;
         iSL = iBelow;
         break;
      case OP_SELL :
         iTP = iBelow;
         iSL = iAbove;
         break;
      default :
         iTP = -1;
         iSL = -1;
     }



   if(GetTPObj)
     {
      if(iTP>=0)
         TPObjName=ObjectName(iTP);
     }



   if(GetSLObj)
     {
      if(iSL>=0)
         SLObjName=ObjectName(iSL);
     }
  }



// === 计算获利价和止损价 ===
void CalcPrice(double &TPPrice,double &SLPrice)
  {

//制定方式初始化定义。。。。自己加条件修改                       //  |
   double BL1,BL2;                                              //  |
   BL1=NormalizeDouble(iCustom(NULL,0,"Bands",bandsA,bandsB,bandsC,1,0),Digits);                       //  |
   BL2=NormalizeDouble(iCustom(NULL,0,"Bands",bandsA,bandsB,bandsC,2,0),Digits);
   Print(BL1," ",BL2);
// 获利价
   switch(获利方式1制定2趋势线0无获利平仓)
     {
      case 1 :

         //制定1方式获利定义。。。。自己加条件修改等号后面的               //  |
         if(OrderType()==OP_SELL)
            TPPrice=BL2+MarketInfo(Symbol(),MODE_SPREAD)*bandsdianchabeishu*Point+bandsTPpianyi*Point;
         if(OrderType()==OP_BUY)
            TPPrice=BL1-MarketInfo(Symbol(),MODE_SPREAD)*bandsdianchabeishu*Point-bandsTPpianyi*Point;                                        //  |

         break;
      case 2 :
         TPPrice=CalcLineValue(TPObjName,0,1+OpType);
         break;
      default :
         TPPrice=-1;
     }



// 止损价
   switch(止损方式1制定2趋势线3移动止损0无止损)
     {
      case 1 :

         //制定1方式止损定义。。。。自己加条件修改等号后面的               //  |
         if(OrderType()==OP_SELL)
            SLPrice=BL1+MarketInfo(Symbol(),MODE_SPREAD)*bandsdianchabeishu*Point+bandsSLpianyi*Point;
         if(OrderType()==OP_BUY)
            SLPrice=BL2-MarketInfo(Symbol(),MODE_SPREAD)*bandsdianchabeishu*Point-bandsSLpianyi*Point;
         //  |

         break;
      case 2 :
         SLPrice=CalcLineValue(SLObjName,0,2-OpType);
         break;
      //-------------------
      case 3 :
         SLPrice=移动止损;
         break;

      default :
         SLPrice=-1;
     }
  }






// === 计算直线在某个k线的值 ===
double CalcLineValue(string ObjName,int Shift,int ValueIndex=1,int ObjType=-1)
  {
   double y1,y2,delta,ret;
   int    i;

   if((ObjType<0) && (StringLen(ObjName)>0))
      ObjType=ObjectType(ObjName);



   switch(ObjType)
     {
      case OBJ_TREND :
      case OBJ_TRENDBYANGLE :
         ret=LineGetValueByShift(ObjName,Shift);
         break;
      case OBJ_CHANNEL :
         i=GetBarShift(Symbol(),0,ObjectGet(ObjName,OBJPROP_TIME3));
         delta=ObjectGet(ObjName,OBJPROP_PRICE3)-LineGetValueByShift(ObjName,i);
         y1 = LineGetValueByShift(ObjName, Shift);
         y2 = y1 + delta;
         if(ValueIndex==MODE_UPPER)
            ret=MathMax(y1,y2);
         else
            if(ValueIndex==MODE_LOWER)
               ret=MathMin(y1,y2);
            else
               ret=-1;
         break;
      default :
         ret=-1;
     }
   return(ret);
  }






// === 显示获利止损价水平线 ===
void ShowTPSLLines(double TPPrice,double SLPrice)
  {
   if(TPPrice<0)
      ObjectDelete(TP_PRICE_LINE);



   else
     {
      if(FindObject(TP_PRICE_LINE)<0)
        {
         ObjectCreate(TP_PRICE_LINE,OBJ_HLINE,0,0,0);
         ObjectSet(TP_PRICE_LINE,OBJPROP_COLOR,获利价格示例线);
         ObjectSet(TP_PRICE_LINE,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(TP_PRICE_LINE,OBJPROP_WIDTH,1);
        }
      ObjectMove(TP_PRICE_LINE,0,Time[0],TPPrice);
     }

   if(SLPrice<0)
      ObjectDelete(SL_PRICE_LINE);



   else
     {
      if(FindObject(SL_PRICE_LINE)<0)
        {
         ObjectCreate(SL_PRICE_LINE,OBJ_HLINE,0,0,0);
         ObjectSet(SL_PRICE_LINE,OBJPROP_COLOR,止损价格示例线);
         ObjectSet(SL_PRICE_LINE,OBJPROP_STYLE,STYLE_SOLID);
         ObjectSet(SL_PRICE_LINE,OBJPROP_WIDTH,1);
        }
      ObjectMove(SL_PRICE_LINE,0,Time[0],SLPrice);
     }
  }






// === 查找对象 ===
int FindObject(string Name)
  {
   if(StringLen(Name)<=0)
      return(-1);
   else
      return(ObjectFind(Name));
  }






// === 平仓 ===
void CloseOrder(int Ticket,int type)
  {
   double ClosePrice;
   string str[2]= {"TP","SL"};



   if(OrderSelect(Ticket,SELECT_BY_TICKET,MODE_TRADES))
     {
      if(OrderType()==OP_BUY)
         ClosePrice=MarketInfo(Symbol(),MODE_BID);
      else
         ClosePrice=MarketInfo(Symbol(),MODE_ASK);
      if(OrderClose(Ticket,OrderLots(),ClosePrice,0))
         Print("Order #",Ticket," was closed successfully at ",str[type]," ",ClosePrice);
      else
         Print("Order #",Ticket," reached ",str[type]," ",ClosePrice,", but failed to close for error ",GetLastError());
     }
  }


















// === 计算直线上的值 ===
double LineGetValueByShift(string ObjName,int Shift)
  {
   double i1,i2,i,y1,y2,y;
   i1 = GetBarShift(Symbol(), 0, ObjectGet(ObjName, OBJPROP_TIME1));
   i2 = GetBarShift(Symbol(), 0, ObjectGet(ObjName, OBJPROP_TIME2));
//Print("aaa=",ObjectGet(ObjName,OBJPROP_TIME3));
   y1 = ObjectGet(ObjName, OBJPROP_PRICE1);
   y2 = ObjectGet(ObjName, OBJPROP_PRICE2);



   if(i1<i2)
     {
      i  = i1;
      i1 = i2;
      i2 = i;
      y  = y1;
      y1 = y2;
      y2 = y;
     }
   if(Shift>i1)
      y=(y2-y1)/(i2-i1) *(Shift-i1)+y1;
   else
      y=ObjectGetValueByShift(ObjName,Shift);

   return(y);
  }


















// === 取时间值的shift数 ===
int GetBarShift(string symbol,int atimeframe,double time)
  {
   datetime now;
   now=iTime(symbol,atimeframe,0);
   int now1=StrToInteger(IntegerToString(now,0));
   int time1=StrToInteger(DoubleToStr(time,0));
// Print("now2=",now2,"  ","now=",now,"time=",time,"time1=",time1);
   if(time1<now1+atimeframe*60)
      return(iBarShift(symbol, atimeframe, time1));



   else
     {
      if(atimeframe==0)
         atimeframe=Period();
      return((now1 - time1) / atimeframe / 60);
     }
  }
















//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double press()//增加或减少偏移
  {
   double pianyi=(shangpress-xiapress)*presspianyi*Point;
   shangpress=0;
   xiapress=0;
   return(pianyi);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Huaxianguadan()//划线 挂单
  {
//Print("划线平仓开始");
///////////////////////////////////////////////////////////////////
   double TPPrice,SLPrice,tpPrice,slPrice;
   获利方式1制定2趋势线0无获利平仓=2;
   止损方式1制定2趋势线3移动止损0无止损=2;



   if(kkey && bkey)//直接划线设置止盈止损 多单止损
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print("TPPrice=",tpPrice," ","SLPrice=",slPrice);
      if(SLPrice>0 && TPPrice<0)
         PiliangSL(true,slPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);



      //if(TPPrice>0 && SLPrice<0)PiliangSL(true,tpPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice<Bid)
            PiliangSL(true,tpPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
         if(slPrice<Bid)
            PiliangSL(true,slPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      kkey=false;
      bkey=false;
     }



   if(kkey && skey)//直接划线设置止盈止损 空单止损
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print("TPPrice=",tpPrice," ","SLPrice=",slPrice);
      if(SLPrice>0 && TPPrice<0)
         PiliangSL(false,slPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);



      //if(TPPrice>0 && SLPrice<0)PiliangSL(false,tpPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice>Bid)
            PiliangSL(false,tpPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
         if(slPrice>Bid)
            PiliangSL(false,slPrice,jianju07,pianyiliang07,juxianjia07,dingdangeshu07);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      kkey=false;
      skey=false;
     }



   if(okey && bkey)//直接划线设置止盈止损 多单止盈
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print("TPPrice=",tpPrice," ","SLPrice=",slPrice);
      //if(SLPrice>0 && TPPrice<0)PiliangTP(true,slPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
      if(TPPrice>0 && SLPrice<0)
         PiliangTP(true,tpPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice>Bid)
            PiliangTP(true,tpPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
         if(slPrice>Bid)
            PiliangTP(true,slPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      okey=false;
      bkey=false;
     }



   if(okey && skey)//直接划线设置止盈止损 空单止盈
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print("TPPrice=",tpPrice," ","SLPrice=",slPrice);
      //if(SLPrice>0 && TPPrice<0)PiliangTP(false,slPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
      if(TPPrice>0 && SLPrice<0)
         PiliangTP(false,tpPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice<Bid)
            PiliangTP(false,tpPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
         if(slPrice<Bid)
            PiliangTP(false,slPrice,jianju07,pianyiliang07tp,juxianjia07,dingdangeshu07);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      okey=false;
      skey=false;
     }



   if(okey && lkey)//直接划线挂单
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print(tpPrice," ",slPrice);
      if(SLPrice>0 && TPPrice<0)
         Guadanbuylimit(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
      if(TPPrice>0 && SLPrice<0)
         Guadanbuylimit(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice<Bid)
            Guadanbuylimit(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(slPrice<Bid)
            Guadanbuylimit(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      okey=false;
      lkey=false;
     }



   if(kkey && lkey)//
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print(tpPrice," ",slPrice);
      if(SLPrice>0 && TPPrice<0)
         Guadanselllimit(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
      if(TPPrice>0 && SLPrice<0)
         Guadanselllimit(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice>Bid)
            Guadanselllimit(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(slPrice>Bid)
            Guadanselllimit(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      kkey=false;
      lkey=false;
     }



   if(pkey && lkey)//
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print(tpPrice," ",slPrice);
      if(SLPrice>0 && TPPrice<0)
         Guadanbuystop(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
      if(TPPrice>0 && SLPrice<0)
         Guadanbuystop(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice>Bid)
            Guadanbuystop(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(slPrice>Bid)
            Guadanbuystop(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      pkey=false;
      lkey=false;
     }



   if(lkey && lkey)//
     {
      CalcPrice(TPPrice,SLPrice);
      tpPrice=NormalizeDouble(TPPrice,Digits);
      slPrice=NormalizeDouble(SLPrice,Digits);
      Print(tpPrice," ",slPrice);
      if(SLPrice>0 && TPPrice<0)
         Guadansellstop(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
      if(TPPrice>0 && SLPrice<0)
         Guadansellstop(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);



      if(TPPrice>0 && SLPrice>0)
        {
         if(tpPrice<Bid)
            Guadansellstop(huaxianguadanlots,tpPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(slPrice<Bid)
            Guadansellstop(huaxianguadanlots,slPrice,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
        }
      if(ObjectFind(TPObjName)>=0)
         ObjectDelete(TPObjName);
      if(ObjectFind(SLObjName)>=0)
         ObjectDelete(SLObjName);
      if(ObjectFind(TP_PRICE_LINE)>=0)
         ObjectDelete(TP_PRICE_LINE);
      if(ObjectFind(SL_PRICE_LINE)>=0)
         ObjectDelete(SL_PRICE_LINE);
      huaxianguadan=false;
      Print("划线挂单模式关闭");
      comment1("划线挂单模式关闭");
      lkey=false;
     }
   bool   SetTPObj=false,SetSLObj=false;
//string MesgText;
   GetOrdersID();     // 获取需要管理的订单ID



   if(OpType>=0) // 方向一致
     {
      if(获利方式1制定2趋势线0无获利平仓==2)
         SetTPObj=FindObject(TPObjName)<0;
      if(止损方式1制定2趋势线3移动止损0无止损==2)
         SetSLObj=FindObject(SLObjName)<0;
      if(SetTPObj || SetSLObj)
         SearchObjName(OpType,SetTPObj,SetSLObj);         // 搜寻获利止损线的对象名
      CalcPrice(TPPrice,SLPrice);
      if(是否显示示例线)
         ShowTPSLLines(TPPrice,SLPrice);



      if((SLPrice>0) &&
         ((OpType==OP_BUY) && (Bid<=SLPrice)))
         //((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //((OpType == OP_SELL) &&(Bid>= SLPrice))))
         //CloseOrder(OrdersID[i],1);
        {
         Guadanbuylimit(huaxianguadanlots,Ask-(stoplevel+5)*Point,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxianguadan=false;
         Print("划线挂单模式关闭");
         comment1("划线挂单模式关闭");
        }



      if((SLPrice>0) &&
         //(((OpType== OP_BUY) &&(Bid>= TPPrice))||
         ((OpType==OP_SELL) && (Bid>=SLPrice)))
         //((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //CloseOrder(OrdersID[i],2);
        {
         Guadanselllimit(huaxianguadanlots,Bid+(stoplevel+5)*Point,huaxianguadangeshu,huaxianguadanjianju,huaxianguadansl,huaxianguadantp,huaxianguadanjuxianjia);
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxianguadan=false;
         Print("划线挂单模式关闭");
         comment1("划线挂单模式关闭");
        }
     }
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Huaxiankaicang()//划线直接开仓
  {
   获利方式1制定2趋势线0无获利平仓=2;
   止损方式1制定2趋势线3移动止损0无止损=2;
// Print("划线平仓开始");
   double TPPrice,SLPrice;
   bool   SetTPObj=false,SetSLObj=false;
//string MesgText;
   GetOrdersID();     // 获取需要管理的订单ID



   if(OpType>=0) // 方向一致
     {
      if(获利方式1制定2趋势线0无获利平仓==2)
         SetTPObj=FindObject(TPObjName)<0;
      if(止损方式1制定2趋势线3移动止损0无止损==2)
         SetSLObj=FindObject(SLObjName)<0;
      if(SetTPObj || SetSLObj)
         SearchObjName(OpType,SetTPObj,SetSLObj);         // 搜寻获利止损线的对象名
      CalcPrice(TPPrice,SLPrice);
      if(是否显示示例线)
         ShowTPSLLines(TPPrice,SLPrice);



      if((SLPrice>0) &&
         ((OpType==OP_BUY) && (Bid<=SLPrice)))
         //((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //((OpType == OP_SELL) &&(Bid>= SLPrice))))
         //CloseOrder(OrdersID[i],1);
        {
         for(int i=huaxiankaicanggeshu; i>0; i--)
           {
            int keybuy=OrderSend(Symbol(),OP_BUY,keylots,MarketInfo(Symbol(),MODE_ASK),keyslippage,0,0,NULL,0,0);
            Print(TimeCurrent());
            if(keybuy>0)
               PlaySound("ok.wav");
            else
               PlaySound("timeout.wav");
            Sleep(huaxiankaicangtime);
           }
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxiankaicang=false;
         Print("触及划线直接开仓模式关闭");
         comment1("触及划线直接开仓模式关闭");
        }



      if((SLPrice>0) &&
         //(((OpType== OP_BUY) &&(Bid>= TPPrice))||
         ((OpType==OP_SELL) && (Bid>=SLPrice)))
         //((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //CloseOrder(OrdersID[i],2);
        {
         for(int i=huaxiankaicanggeshu; i>0; i--)
           {
            int keysell=OrderSend(Symbol(),OP_SELL,keylots,MarketInfo(Symbol(),MODE_BID),keyslippage,0,0,NULL,0,0);
            if(keysell>0)
               PlaySound("ok.wav");
            else
              {
               PlaySound("timeout.wav");
               Print("Error=",GetLastError());
              }
            Print(TimeCurrent());
            Sleep(huaxiankaicangtime);
           }
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxiankaicang=false;
         Print("触及划线直接开仓模式关闭");
         comment1("触及划线直接开仓模式关闭");
        }
     }
  }









//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HuaxianSwitch()////划线平仓代码 划线锁仓 布林带平仓
  {
//Print("HuaxianSwitch运行");
   double TPPrice,SLPrice;
   bool   SetTPObj=false,SetSLObj=false;
//string MesgText;
   GetOrdersID();     // 获取需要管理的订单ID



   if(OpType>=0) // 方向一致
     {
      if(获利方式1制定2趋势线0无获利平仓==2)
         SetTPObj=FindObject(TPObjName)<0;
      if(止损方式1制定2趋势线3移动止损0无止损==2)
         SetSLObj=FindObject(SLObjName)<0;
      if(SetTPObj || SetSLObj)
         SearchObjName(OpType,SetTPObj,SetSLObj);         // 搜寻获利止损线的对象名



      //--------------
      if(止损方式1制定2趋势线3移动止损0无止损==3)
        {
         建仓价=OrderOpenPrice();
         if(OrderType()==OP_BUY)
            //如果(订单类型=多单)
           {
            if(移动止损<建仓价-Point*止损)
               移动止损=建仓价-Point*止损;
            if(Bid>建仓价+首次保护盈利止损*Point && 移动止损<建仓价+保护盈利*Point)
               移动止损=建仓价+保护盈利*Point;
            if(Bid>建仓价+移动步长*1*Point && 移动止损<建仓价+保护盈利*Point)
               移动止损=建仓价+保护盈利*Point;
            if(Bid>建仓价+移动步长*2*Point && 移动止损<建仓价+移动步长*1*Point)
               移动止损=建仓价+移动步长*1*Point;
            if(Bid>建仓价+移动步长*3*Point && 移动止损<建仓价+移动步长*2*Point)
               移动止损=建仓价+移动步长*2*Point;
            if(Bid>建仓价+移动步长*5*Point && 移动止损<建仓价+移动步长*3*Point)
               移动止损=建仓价+移动步长*3*Point;
            if(Bid>建仓价+移动步长*7*Point && 移动止损<建仓价+移动步长*4*Point)
               移动止损=建仓价+移动步长*4*Point;
           }

         if(OrderType()==OP_SELL)
            //如果 仓单类型=空单，则，
           {
            if(移动止损<建仓价+Point*止损)
               移动止损=建仓价+Point*止损;
            if(Ask<建仓价-首次保护盈利止损*Point && 移动止损>建仓价-保护盈利*Point-(Ask-Bid)*Point)
               移动止损=建仓价-保护盈利*Point-(Ask-Bid)*Point;
            if(Ask<建仓价-移动步长*1*Point && 移动止损>建仓价-保护盈利*Point-(Ask-Bid)*Point)
               移动止损=建仓价-保护盈利*Point-(Ask-Bid)*Point;
            if(Ask<建仓价-移动步长*2*Point && 移动止损>建仓价-移动步长*1*Point)
               移动止损=建仓价-移动步长*1*Point;
            if(Ask<建仓价-移动步长*3*Point && 移动止损>建仓价-移动步长*2*Point)
               移动止损=建仓价-移动步长*2*Point;
            if(Ask<建仓价-移动步长*5*Point && 移动止损>建仓价-移动步长*3*Point)
               移动止损=建仓价-移动步长*3*Point;
            if(Ask<建仓价-移动步长*7*Point && 移动止损>建仓价-移动步长*4*Point)
               移动止损=建仓价-移动步长*4*Point;
           }
        }
      //---------------
      CalcPrice(TPPrice,SLPrice);
      /*
               MesgText="止损：";
               if(SLPrice<0)
                  MesgText=MesgText+" __ ";
               else
                  MesgText=MesgText+DoubleToStr(SLPrice,Digits);
               MesgText=MesgText+"  ；止赢：";
               if(TPPrice<0)
                  MesgText=MesgText+" __ ";
               else
                  MesgText=MesgText+DoubleToStr(TPPrice,Digits);
               Comment(MesgText);
      */
      if(是否显示示例线)
         ShowTPSLLines(TPPrice,SLPrice);
      if((SLPrice>0) &&
         (((OpType== OP_BUY) &&(Bid<= SLPrice))||
          ((OpType == OP_SELL) &&(Bid>= SLPrice))))
         //CloseOrder(OrdersID[i],1);
        {
         if(huaxianShift)
           {
            suocang();
           }
         else
           {
            if(huaxianCtrl)
              {
               fanxiangsuodan();
              }
            else
              {
               xunhuanquanpingcang();
              }
           }

         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxianSwitch=false;
         huaxianTimeSwitch=false;
         huaxianShift=false;
         huaxianCtrl=false;
         Print("触及划线直接平仓或反锁模式关闭");
         comment1("触及划线直接平仓或反锁模式关闭");
        }



      if((TPPrice>0) &&
         (((OpType== OP_BUY) &&(Bid>= TPPrice))||
          ((OpType == OP_SELL) &&(Bid<= TPPrice))))
         //CloseOrder(OrdersID[i],2);
        {
         if(huaxianShift)
           {
            suocang();
           }
         else
           {
            if(huaxianCtrl)
              {
               fanxiangsuodan();
              }
            else
              {
               xunhuanquanpingcang();
              }
           }
         if(ObjectFind(TPObjName)>=0)
            ObjectDelete(TPObjName);
         if(ObjectFind(SLObjName)>=0)
            ObjectDelete(SLObjName);
         if(ObjectFind(TP_PRICE_LINE)>=0)
            ObjectDelete(TP_PRICE_LINE);
         if(ObjectFind(SL_PRICE_LINE)>=0)
            ObjectDelete(SL_PRICE_LINE);
         huaxianSwitch=false;
         huaxianTimeSwitch=false;
         huaxianShift=false;
         huaxianCtrl=false;
         Print("触及划线直接平仓或反锁模式关闭");
         comment1("触及划线直接平仓或反锁模式关闭");
        }
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetLevel(string text,double level,color col1)//划一条横线
  {

   string linename=text;



   if(ObjectFind(linename)!=0)
     {
      ObjectCreate(linename,OBJ_HLINE,0,Time[linebar],level);
      ObjectSet(linename,OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(linename,OBJPROP_LEVELWIDTH,5);
      ObjectSet(linename,OBJPROP_COLOR,col1);
     }



   else
     {
      ObjectMove(linename,0,Time[linebar],level);
     }
  }




//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
