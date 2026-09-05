# 四类 Flow 证据与计分清单

状态：静态评审草案；不是运行验证。以下路径均基于冻结的 input。每项 5 点，每点 1 分；评分时打开实际源码核对。

来源范围用于导航，答案本身应引用更精确的行或分支。图、正文或有效的等价表述均可计分。

## O1 角色与职责

1. 识别客服及订单／售后请求职责
2. 识别仓库人员及仓储请求职责
3. 识别结算人员及异常参与职责
4. 识别日终操作员及批次／处理日职责
5. 注明角色来自题目背景，未声称源码实现登录或权限

证据：
- [context/operations-and-systems.md](../input/context/operations-and-systems.md)：1. 角色

## O2 日间与日终时点

1. 区分日间事件与日终操作触发
2. 正确说明首次到达的 18:00 截点约定
3. 说明重送保留原请求处理日这一外部约定
4. 说明核心使用显式请求日和运行日，并定位其处理代码
5. 不把接入端分日、真实时区或调度配置说成核心中已实现

证据：
- [context/operations-and-systems.md](../input/context/operations-and-systems.md)：2. 时点
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：491–507 / MCONTEXT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：589–622 / MENVELOPE
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2446–2466 / MDAY

## O3 批次操作过程

1. 定位 ORDRUN 入口及显式 BATCH / DAY / MODE / ACTOR
2. 说明 PROCESS 与 RESUME 的批次存在性路径
3. 说明按批次和检查点位置读取后续输入
4. 说明单次输入闭合和批次 DONE 是不同层次
5. 注明批次完成不直接证明结算端已完成

证据：
- [src/QCLLESRC/ORDRUN.clle](../input/src/QCLLESRC/ORDRUN.clle)：1–63 / CL
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：348–378 / MBATCH
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：446–462 / MINPUT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：3190–3204 / MFINISH

## O4 人工介入

1. 定位 RECOVER 所需动作／操作人／原因检查
2. 识别 LOCAL、RETRY、VERIFY、REPLY 的分派入口
3. 说明恢复请求与原请求有关联而不是覆盖原始请求身份
4. 定位人工信息写入 AUDIT 的路径
5. 从角色背景连到异常操作入口，而不是把函数名当成人员

证据：
- [context/operations-and-systems.md](../input/context/operations-and-systems.md)：1. 角色
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1952–1964 / MRECCHK
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1968–1983 / MRECROUTE
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1988–2057 / MLOCAL
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2966–3010 / MAPPENDAUD

## O5 结果交接与可观察性

1. 指出业务回复交给接入端／客服的背景关系
2. 指出仓储输出与仓库人员之间的背景关系
3. 指出日终结果的消费角色
4. 在代码中定位回执、仓储结果和审计至少两类载体
5. 说明实际展示或外部交接执行器未提供

证据：
- [context/operations-and-systems.md](../input/context/operations-and-systems.md)：1. 角色
- [context/operations-and-systems.md](../input/context/operations-and-systems.md)：3. 系统边界
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2492–2634 / MPROJECT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2672–2889 / MWHRESULT
- [src/QRPGLESRC/ORDDAILY.rpgle](../input/src/QRPGLESRC/ORDDAILY.rpgle)：319–339 / DPUBLISH

## S1 外部边界

1. 区分订单接入端与核心
2. 区分仓储端与核心
3. 区分结算端与核心
4. 区分报表／调度端与核心
5. 外部端与内部 RPGLE 程序不被混画为同一层次

证据：
- [context/operations-and-systems.md](../input/context/operations-and-systems.md)：3. 系统边界

## S2 接入载体

1. 定位 INHDRPF 头与 INDTLPF 明细
2. 定位 BATCH / DAY 等调用参数入口
3. 说明批次／序号与来源／请求是两组关联
4. 说明读取输入的方向是接入载体到核心
5. 未臆造未给出的接入程序、网络协议或产品

证据：
- [context/interfaces.md](../input/context/interfaces.md)：1. 输入与输出载体
- [context/interfaces.md](../input/context/interfaces.md)：2. 外部字段含义
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：446–462 / MINPUT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：465–487 / MREADROWS
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：491–507 / MCONTEXT

## S3 出站及反馈

1. 定位 OUTBOXPF 为本地出站载体
2. 区分结算类、回执类和仓储类消息用途
3. 定位 SETRES 与 DELIVER 的不同入口分派
4. 说明出站记录与外部实际发送不是同一份实现证据
5. 图上明确至少一条输出方向和一条反馈方向

证据：
- [context/interfaces.md](../input/context/interfaces.md)：1. 输入与输出载体
- [context/interfaces.md](../input/context/interfaces.md)：3. 日期、反馈及编码
- [src/QRPGLESRC/ORDSETTL.rpgle](../input/src/QRPGLESRC/ORDSETTL.rpgle)：313–501 / TOUT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1776–1812 / MSETGET
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1898–1948 / MDELIV
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2672–2889 / MWHRESULT

## S4 核心内部职责

1. 定位 ORDRUN 调用 ORDMAIN
2. 定位 ORDMAIN 调用 6 个配套程序
3. 区分校验、金额、库存的内部职责
4. 区分结算、回复、日报的内部职责
5. 说明内部调用图只用于补充系统图而不替代外部边界

证据：
- [src/QCLLESRC/ORDRUN.clle](../input/src/QCLLESRC/ORDRUN.clle)：34–42 / CL
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：625–778 / MDISPATCH
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：532–555 / MCANON
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：916–936 / MQUOTE
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：940–964 / MPLAN
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2492–2634 / MPROJECT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2446–2466 / MDAY

## S5 运行环境边界

1. 指出外部发送器未提供
2. 指出反馈接收器／界面未提供
3. 指出实际库、日志或作业配置未提供
4. 能定位源码中的承诺定义前提而非把配置存在当事实
5. 没有把静态文本称为编译通过或真实网络执行结果

证据：
- [context/interfaces.md](../input/context/interfaces.md)：4. 阅读边界
- [context/operations-and-systems.md](../input/context/operations-and-systems.md)：3. 系统边界
- [src/QCLLESRC/ORDRUN.clle](../input/src/QCLLESRC/ORDRUN.clle)：28–63 / CL

## D1 请求身份及规范化

1. 说明来源加请求号用于账本查找
2. 说明完整规范内容和长度的比较，不把代码等同只比哈希
3. 说明规范化与当前资格校验的先后分离
4. 说明输入包装字段和业务字段在规范内容中的区别
5. 追踪规范结果到 REQPF 的写入或冲突保护

证据：
- [src/QRPGLESRC/ORDCHECK.rpgle](../input/src/QRPGLESRC/ORDCHECK.rpgle)：91–267 / CCANON
- [src/QRPGLESRC/ORDCHECK.rpgle](../input/src/QRPGLESRC/ORDCHECK.rpgle)：288–305 / CMODE
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：510–528 / MUNIT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：559–585 / MDEDUP
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：3015–3109 / MLEDGER

## D2 金额来源及分摊

1. 定位有效价格读取与有效区间匹配检查
2. 说明 S / P 对应 1.0000 / 0.9500 及按行舍入
3. 说明报价写入订单的单位价、系数和行金额
4. 说明累计数量比例产生当前分摊差额及最后数量的原额上限
5. 区分发货的订单行基数和退货的原发货明细／成功调整基数

证据：
- [src/QRPGLESRC/ORDPRICE.rpgle](../input/src/QRPGLESRC/ORDPRICE.rpgle)：109–153 / PLOOK
- [src/QRPGLESRC/ORDPRICE.rpgle](../input/src/QRPGLESRC/ORDPRICE.rpgle)：157–180 / PQUOTE
- [src/QRPGLESRC/ORDPRICE.rpgle](../input/src/QRPGLESRC/ORDPRICE.rpgle)：184–218 / PGROUP
- [src/QRPGLESRC/ORDPRICE.rpgle](../input/src/QRPGLESRC/ORDPRICE.rpgle)：222–238 / PSPLIT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：968–1059 / MVERSION
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1269–1316 / MSHIPPLAN
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1592–1618 / MRETAMT

## D3 库存数量

1. 说明按商品及仓库共用虚拟余额，避免每个订单行独立重复使用可用量
2. 说明 A/B/C 的新增分配顺序及启用条件
3. 说明 ALLOC 的输入剩余需求还需扣除已有占用
4. 说明候选阶段与 APPLY 写入阶段分开，并核对旧快照
5. 追踪 STOCKPF 与 ALLOCPF 的最终更新及非负约束

证据：
- [src/QRPGLESRC/ORDSTOCK.rpgle](../input/src/QRPGLESRC/ORDSTOCK.rpgle)：184–222 / SPOOL
- [src/QRPGLESRC/ORDSTOCK.rpgle](../input/src/QRPGLESRC/ORDSTOCK.rpgle)：336–408 / SALLOC
- [src/QRPGLESRC/ORDSTOCK.rpgle](../input/src/QRPGLESRC/ORDSTOCK.rpgle)：553–705 / SAPCHECK
- [src/QRPGLESRC/ORDSTOCK.rpgle](../input/src/QRPGLESRC/ORDSTOCK.rpgle)：709–745 / SAPWRITE
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1079–1128 / MALLOC

## D4 实物、财务及消息关联

1. 追踪发货头／行与正向结算身份
2. 追踪退货头／行、原发货明细与调整身份
3. 定位原发货分组的多个调整头，而非一律只有一笔调整
4. 区分数量事实、结算状态、消息送达状态的不同文件／字段
5. 指出反馈路径不删除或重写已建立的发货／退货事实

证据：
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1340–1442 / MSHIPAP
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1623–1772 / MRETAP
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1874–1894 / MSETAP
- [src/QRPGLESRC/ORDSETTL.rpgle](../input/src/QRPGLESRC/ORDSETTL.rpgle)：505–614 / TAPPLY
- [src/QRPGLESRC/ORDSETTL.rpgle](../input/src/QRPGLESRC/ORDSETTL.rpgle)：696–735 / TDELIV
- [src/QRPGLESRC/ORDREPLY.rpgle](../input/src/QRPGLESRC/ORDREPLY.rpgle)：196–231 / YDELIV

## D5 日报与审计

1. 说明按首次成功日选取成功结算
2. 说明正向额减去反向额绝对值形成净额
3. 说明未完成结算与 LOCAL 待恢复请求另列，不加净额
4. 说明 READY 快照查询和同身份重用路径
5. 追踪请求／输入／业务身份及人工信息进入审计，不能用审计替代当前状态

证据：
- [src/QRPGLESRC/ORDDAILY.rpgle](../input/src/QRPGLESRC/ORDDAILY.rpgle)：89–156 / DINIT
- [src/QRPGLESRC/ORDDAILY.rpgle](../input/src/QRPGLESRC/ORDDAILY.rpgle)：179–245 / DSUCCESS
- [src/QRPGLESRC/ORDDAILY.rpgle](../input/src/QRPGLESRC/ORDDAILY.rpgle)：249–279 / DPENDING
- [src/QRPGLESRC/ORDDAILY.rpgle](../input/src/QRPGLESRC/ORDDAILY.rpgle)：283–301 / DLOCAL
- [src/QRPGLESRC/ORDDAILY.rpgle](../input/src/QRPGLESRC/ORDDAILY.rpgle)：319–339 / DPUBLISH
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2966–3010 / MAPPENDAUD

## T1 受理、重复及修改

1. 说明重复判断先于业务事件执行，相同内容转查询
2. 说明同键不同内容的冲突分支保留原账本
3. 说明新订单业务身份存在时的拒绝路径
4. 说明 MOD 的版本／历史发货／关闭状态检查与完整替换过程
5. 说明库存等待可以是受理结果，不能笼统等同修改失败

证据：
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：510–528 / MUNIT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：559–585 / MDEDUP
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：847–861 / MNEW
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：782–843 / MORDER
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：885–912 / MMOD
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：940–964 / MPLAN
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：968–1059 / MVERSION

## T2 分配、取消及发货

1. 说明 ALLOC 只补当前缺口而不重新报价
2. 说明取消先抵消未分配量，再按 C/B/A 释放
3. 说明取消量受未发货剩余数量约束
4. 说明发货核对指定仓库自己的占用，实物与占用同时减少
5. 说明发货候选全部检查后在同一本地事件中应用、记实物及生成结算

证据：
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1079–1128 / MALLOC
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1132–1187 / MCANCEL
- [src/QRPGLESRC/ORDSTOCK.rpgle](../input/src/QRPGLESRC/ORDSTOCK.rpgle)：412–466 / SCANCEL
- [src/QRPGLESRC/ORDSTOCK.rpgle](../input/src/QRPGLESRC/ORDSTOCK.rpgle)：470–497 / SSHIP
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1269–1316 / MSHIPPLAN
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1340–1442 / MSHIPAP

## T3 退货及调整

1. 说明原发货、同订单及 0–30 天窗口检查
2. 说明正向结算已成功及累计退货数量限制
3. 说明原明细存在未完成调整时进入待恢复路径，尚不归还库存
4. 说明回原商品原仓增加现有量，不重新分配订单需求
5. 说明退款基数、分原发货调整及后续财务结果是不同阶段

证据：
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1446–1500 / MRETURN
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1505–1588 / MRETBASE
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1592–1618 / MRETAMT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1623–1772 / MRETAP
- [src/QRPGLESRC/ORDSTOCK.rpgle](../input/src/QRPGLESRC/ORDSTOCK.rpgle)：501–525 / SRETURN

## T4 财务反馈与恢复

1. 说明已有 OK 不被晚到失败覆盖，首次成功日不重复推进
2. 正确说明代码先处理 OK，再过滤旧尝试的非成功反馈，不把所有 UNKNOWN 出口概括成只能来自 VERIFY
3. 说明 UNKNOWN 的非成功解除要求当前核实消息；已知失败 RETRY 保留业务身份
4. 区分 LOCAL 重新检查原始请求与财务 RETRY / VERIFY，不混作自动重放业务
5. 说明 REPLY 仅重送原回执，保留身份和负载；送达不能直接构成财务成功

证据：
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1816–1870 / MSETSTATE
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：1988–2057 / MLOCAL
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2086–2131 / MRETRY
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2135–2179 / MVERIFY
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2183–2198 / MREPLY
- [src/QRPGLESRC/ORDSETTL.rpgle](../input/src/QRPGLESRC/ORDSETTL.rpgle)：618–656 / TRETRY
- [src/QRPGLESRC/ORDSETTL.rpgle](../input/src/QRPGLESRC/ORDSETTL.rpgle)：660–692 / TVERIFY
- [src/QRPGLESRC/ORDSETTL.rpgle](../input/src/QRPGLESRC/ORDSETTL.rpgle)：696–735 / TDELIV
- [src/QRPGLESRC/ORDREPLY.rpgle](../input/src/QRPGLESRC/ORDREPLY.rpgle)：235–263 / YRESEND

## T5 提交、失败与检查点

1. 明确业务生命周期不等同一次数据库事务
2. 定位正常提交由 ORDMAIN 负责，配套程序不独立 COMMIT / ROLBK
3. 追踪结果、审计、账本和检查点在提交前的闭合路径
4. 说明确认回滚后的结果单元及其再次失败时停止路径
5. 说明提交／回滚不可靠时停止并保留未知，不把它描述成已经撤销成功；CL 清理受自身所有权限制

证据：
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：2469–2487 / MCLOSE
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：3015–3109 / MLEDGER
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：3113–3122 / MCOMMIT
- [src/QRPGLESRC/ORDMAIN.rpgle](../input/src/QRPGLESRC/ORDMAIN.rpgle)：3126–3185 / MROLL
- [src/QCLLESRC/ORDRUN.clle](../input/src/QCLLESRC/ORDRUN.clle)：28–63 / CL

## 静态实现与设计的关系

T4 按当前 MSETSTATE 的实际分支顺序评分：OK 在当前尝试／消息检查之前处理。不得拿更严格或更宽泛的设计口号覆盖这个代码事实。其他计分点同样需要以实际源码为准。发现新问题时记录统一裁决，对同组结果采用相同规则。
