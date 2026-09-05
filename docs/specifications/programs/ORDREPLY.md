# ORDREPLY 程序规格

## Spec Header

- **Spec ID**：ORDREPLY-20260905-01
- **Spec Level**：L3 Full
- **Version / Status**：1.0 / Draft
- **Change Type / Program Type**：New Program / RPGLE
- **Program Name**：ORDREPLY
- **Description**：业务回执和仓储结果的登记、查询与送达恢复。
- **Source TD**：[TD-20260905-01](../../design/technical-design.md) Module Allocation 行 `ORDREPLY`。
- **共同输入**：[功能需求](../../requirements/functional-requirements.md)、[共享契约](../shared-contract.md)。全部字段及步骤为授权合成定义，不是对既有系统的发现。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次完整规格。

## Caller Context

仅由 ORDMAIN 同步调用；按 CTXDS.CXACTION 选择适用动作。成功后调用方按返回码继续；失败由主程序决定回滚、记录结果或停止。辅助成功不等于事务提交。

## Functions

- 业务回执和仓储结果的登记、查询与送达恢复。
- 输出有身份和原因的结果，保持职责范围与静态追踪关系。

## Business Rules

继承 FS 编号，不在各程序重新从 01 编号。主责与协作分开；下面的恢复／记录引用不把所有规则所有权转移到本程序。

| BR | 需求规则 | 本程序角色 |
| --- | --- | --- |
| BR-06 | 同一来源和请求标识、相同业务内容的重复请求必须返回最近已知结果，不重复占用、发货或结算；“重新尝试失败业务”需要独立的恢复动作。 | 协作／处理边界；主责 ORDMAIN |
| BR-26 | 回执发送失败只允许重送回执，不重做已完成业务；回执应同时反映业务结果和最近送达情况。 | 主责 |
| BR-31 | 人工处置须保留操作者、原因及所选择的恢复动作；不能直接覆盖成功结算、抹去原失败或跳过数量和状态校验。 | 协作／处理边界；主责 ORDMAIN |
| BR-32 | 请求、订单、明细、发货、退货、结算、调整、回执和处理批次均能沿关联标识追溯；拒绝、等待和重试也须保留可解释的业务结果。 | 协作／处理边界；主责 ORDMAIN |

## Interface Contract

参数按位置引用传递，完整布局只在共享契约定义；本表长度为字节。IO 表示依动作输入或输出，输入用途与目标状态不能通过残留值猜测。

### Program Parameters

| 位置 | Name | Type | Length | I/O | Valid Values / Description |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | CREATE / FETCH / DELIVERY / RESEND / LIST |
| 2 | OUTREC | DS | 30375 | IO | 完整消息或按身份查询 |
| 3 | RESDS | DS | 153 | O | 结果 |

### Return Code Definition

| Code | Meaning | Caller Action |
| --- | --- | --- |
| 0000 | 本次动作完成 | 正常继续；辅助完成不等于主程序提交 |
| 0010 | 业务已接受等待／外部待核实 | 记录等待并闭合输入；不自动重试业务 |
| 0020 | 重复或已存在 | 读取最近业务投影；不重复写入业务事实 |
| 1000 | 业务拒绝 | 无业务副作用的结果单元 |
| 1100 | 身份／版本／矛盾反馈冲突 | 保留原事实并记录冲突 |
| 2000 | 资料或关联异常 | 回滚本笔；可定位且可记录则保留待处理，持久化不可靠转 9000 |
| 3000 | 本地处理失败且回滚已确认 | 结果单元记 RETRY；等待显式恢复 |
| 9000 | 系统或提交状态不可靠 | 停止批次，不能宣告已回滚或成功 |

## Data Contract

以下枚举本程序文件字段及共享参数可见字段。文件读写步骤给出使用范围，事件条件以 Main Logic 为准；O 参数在入口清空，仅当前动作的有效字段可使用。字段精度引用 File Spec，不在此另设。

| Field | Source | Storage | Read by | Written by | File Spec Ref | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| OBID | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-01 | 唯一消息身份 |
| OBKIND | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-02 | SETTLE / ADJUST / VERIFY / RECEIPT / WHRESULT |
| OBBIZID | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-03 | 结算身份或回执关联业务身份 |
| OBSRC | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-04 | 请求来源 |
| OBREQ | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-05 | 请求标识 |
| OBBATCH | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-06 | 原始输入批次 |
| OBINPUT | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-07 | 原始输入序号 |
| OBORDER | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-08 | 订单 |
| OBSTATE | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-09 | NEW / SENT / OK / FAIL |
| OBRESULT | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-10 | NONE / OK / FAIL / UNKNOWN / RETRYOK，业务反馈与送达分开 |
| OBRESDAY | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-11 | 业务反馈处理日；无反馈为空 |
| OBATTEMPT | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-12 | 消息送达尝试次数 |
| OBDAY | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-13 | 创建处理日 |
| OBLEN | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-14 | 有效负载长度 |
| OBPAYLOAD | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-15 | 带版本的完整消息内容，长度外为空格 |
| OBREASON | OUTBOXPF | Persisted | Step 2, Step 3, Step 4, Step 5 | Step 3, Step 4, Step 5 | OUTBOXPF-20260905-01:FLD-16 | 最近送达原因 |
| OBID | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-01 | 唯一消息身份 |
| OBKIND | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-02 | SETTLE / ADJUST / VERIFY / RECEIPT / WHRESULT |
| OBBIZID | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-03 | 结算身份或回执关联业务身份 |
| OBSRC | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-04 | 请求来源 |
| OBREQ | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-05 | 请求标识 |
| OBBATCH | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-06 | 原始输入批次 |
| OBINPUT | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-07 | 原始输入序号 |
| OBORDER | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-08 | 订单 |
| OBSTATE | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-09 | NEW / SENT / OK / FAIL |
| OBRESULT | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-10 | NONE / OK / FAIL / UNKNOWN / RETRYOK，业务反馈与送达分开 |
| OBRESDAY | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-11 | 业务反馈处理日；无反馈为空 |
| OBATTEMPT | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-12 | 消息送达尝试次数 |
| OBDAY | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-13 | 创建处理日 |
| OBLEN | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-14 | 有效负载长度 |
| OBPAYLOAD | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-15 | 带版本的完整消息内容，长度外为空格 |
| OBREASON | OUTBYST | Persisted | Step 6 | — | OUTBYST-20260905-01:FLD-16 | 最近送达原因 |

| Field | Source | Storage | Read by | Written by | Reference | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| CTXDS.CXABI | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 0001 |
| CTXDS.CXBATCH | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 输入批次 |
| CTXDS.CXINPUT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 输入序号 |
| CTXDS.CXDAY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 原请求业务日 |
| CTXDS.CXPROCDAY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 当前执行处理日 |
| CTXDS.CXSRC | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 请求来源 |
| CTXDS.CXREQ | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 请求身份 |
| CTXDS.CXEVENT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 业务事件 |
| CTXDS.CXACTION | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 本次辅助调用动作 |
| CTXDS.CXORDER | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 订单 |
| CTXDS.CXVERSION | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 期望订单版本 |
| CTXDS.CXACTOR | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 人工操作人 |
| CTXDS.CXREASON | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 人工原因 |
| CTXDS.CXSHIP | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 发货 |
| CTXDS.CXRETURN | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 退货 |
| CTXDS.CXSETTL | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 结算身份 |
| CTXDS.CXMSG | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 原消息身份 |
| CTXDS.CXPART | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 部分履约 Y/N |
| CTXDS.CXTIER | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | S/P |
| CTXDS.CXCOUNT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 本次数组有效行数 |
| CTXDS.CXOUTSEQ | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 同一输入同种消息的确定性序号，1 起 |
| CTXDS.CXEXPECT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 主程序读取到的旧结算状态 |
| CTXDS.CXATTEMPT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 主程序读取到的旧结算尝试 |
| CTXDS.CXFEED | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 CTXDS | 原始反馈 OK/FAIL/UNKNOWN/RETRYOK/SENT |
| OUTREC.OBID | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-01 | 唯一消息身份 |
| OUTREC.OBKIND | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-02 | SETTLE / ADJUST / VERIFY / RECEIPT / WHRESULT |
| OUTREC.OBBIZID | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-03 | 结算身份或回执关联业务身份 |
| OUTREC.OBSRC | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-04 | 请求来源 |
| OUTREC.OBREQ | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-05 | 请求标识 |
| OUTREC.OBBATCH | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-06 | 原始输入批次 |
| OUTREC.OBINPUT | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-07 | 原始输入序号 |
| OUTREC.OBORDER | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-08 | 订单 |
| OUTREC.OBSTATE | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-09 | NEW / SENT / OK / FAIL |
| OUTREC.OBRESULT | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-10 | NONE / OK / FAIL / UNKNOWN / RETRYOK，业务反馈与送达分开 |
| OUTREC.OBRESDAY | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-11 | 业务反馈处理日；无反馈为空 |
| OUTREC.OBATTEMPT | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-12 | 消息送达尝试次数 |
| OUTREC.OBDAY | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-13 | 创建处理日 |
| OUTREC.OBLEN | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-14 | 有效负载长度 |
| OUTREC.OBPAYLOAD | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-15 | 带版本的完整消息内容，长度外为空格 |
| OUTREC.OBREASON | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | OUTBOXPF-20260905-01:FLD-16 | 最近送达原因 |
| RESDS.RSRC | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 RESDS | 0000 成功 / 0010 等待 / 0020 重复 / 1000 拒绝 / 1100 冲突 / 2000 数据问题 / 3000 本地失败 / 9000 停止 |
| RESDS.RSREASON | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 RESDS | 可解释原因 |
| RESDS.RSINDEX | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 RESDS | 问题行号，0 为头或系统 |
| RESDS.RSCOUNT | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 RESDS | 输出行数 |
| RESDS.RSAMOUNT | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 RESDS | 合计或日报净额 |
| RESDS.RSSTATE | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 RESDS | 结果状态 |
| RESDS.RSVERSION | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 RESDS | 结果订单版本 |

## File Usage

| File | I/O/U | 完整键 | Access Pattern | File Spec Ref | Description |
| --- | --- | --- | --- | --- | --- |
| OUTBOXPF | U | OBID | 1:1 | [OUTBOXPF-20260905-01](../files/OUTBOXPF.md) | 按消息身份保存出站内容与送达状态 |
| OUTBYST | I | OBKIND + OBSTATE + OBID | 1:1 + 1:N | [OUTBYST-20260905-01](../files/OUTBYST.md) | 按种类和送达进度读取回执 |

I=只读；U=可写，是否允许新增见 File Output。1:N 使用键前缀与完整范围循环，不可用一次 CHAIN 代替。

## Data Queue

N/A。

## Data Area

N/A。

## External Data Structure

外部描述文件的记录格式见 File Usage 和 Compile-Oriented Constraints；读取后按需要复制进独立参数／候选结构。共享 COPY 是源定义，不是新外部对象。

## Internal Data Structure

ORDCTX / ORDRES / ORDSTS 的布局与常量均引用共享契约。

## External Program Calls

N/A：无应用程序互调；文件 I/O 不算外部 CALL。

## External Subroutines

N/A：不依赖未列出的外部例程。

## Standard Subroutines

| 例程名 | 逻辑位置 | 职责 |
| --- | --- | --- |
| YINIT | Step 1 | 初始化 RESDS，按动作保留输入 OUTREC；检查 ABI、消息容量和允许动作 |
| YFETCH | Step 2 | FETCH 按 OBID 读取完整 OUTBOXPF 作为只读载体，可读取所有种类供主程序分派 |
| YCREATE | Step 3 | CREATE 只允许 RECEIPT/WHRESULT；用输入身份和输出序号构造消息身份 |
| YDELIV | Step 4 | DELIVERY 只允许本程序拥有的种类；核对反馈与原消息关联，按 NEW/SENT/FAIL→SENT/OK/FAIL 更新送达 |
| YRESEND | Step 5 | RESEND：对未 OK 的原回执增加尝试号并置 NEW，原消息 ID、PAYLOAD、LEN 和业务关联不变；已 OK 返回 0020 |
| YLIST | Step 6 | LIST：FOR EACH OUTBYST 按消息种类及送达状态前缀读取，逐条返回给主程序形成列表；采用调用者游标 OBID 和固定一次一条，RESDS.RSCOUNT=0 表示结束 |
| YRET | Step 7 | 返回结果；更新失败交主程序撤销本次未提交变化，业务已在先前事件提交时不能重做 |

例程名是本程序固定格式子程序分解基线；对应逻辑只在 Main Logic 维护。

## Constants

| Name / Family | Value | Purpose |
| --- | --- | --- |
| ABI | 0001 | 共享参数结构版本 |
| MAXLINE | 100 | 订单／事件有效行上限 |
| MAXPLAN | 300 × 2 | 库存旧、新候选容量 |
| ROUND | 2 decimals / half-up | 金额统一舍入 |
| RETURNWIN | 0–30 days | 原发货业务日起退货窗口 |
| RC / EVENT / STATE | 共享契约列明的集合 | 以 ORDSTS 统一引用；不各自重新编码 |

## Program Processing

### Main Logic

下表是分派路径；编号不是每次调用都执行的流水序列。未选中的业务分支必须跳过，任何拒绝／系统错误停止当前分支。

| 入口 / 动作 | 适用步骤 |
| --- | --- |
| CREATE / FETCH / DELIVERY / RESEND / LIST | Step 1，再分别 Step 3 / 2 / 4 / 5 / 6，Step 7 返回 |

Step 1: **YINIT** — 初始化 RESDS，按动作保留输入 OUTREC；检查 ABI、消息容量和允许动作。IF 负载长度越界 → 1000，不截断成可发送内容。 (BR-26, BR-32)

Step 2: **YFETCH** — FETCH 按 OBID 读取完整 OUTBOXPF 作为只读载体，可读取所有种类供主程序分派。IF 不存在 → 2000；返回送达状态与不可变负载，不猜测业务成功。 (BR-26, BR-32)

Step 3: **YCREATE** — CREATE 只允许 RECEIPT/WHRESULT；用输入身份和输出序号构造消息身份。IF 消息已存在且负载及身份完全相同 → 0020；不同则 1100，不能覆盖旧消息。新消息 STATE=NEW、ATTEMPT=1；保存完整负载及业务关联。 (BR-06, BR-26, BR-32)

Step 4: **YDELIV** — DELIVERY 只允许本程序拥有的种类；核对反馈与原消息关联，按 NEW/SENT/FAIL→SENT/OK/FAIL 更新送达。已 OK 的后到失败保留 OK 并返回冲突供主程序审计。业务状态不变。 (BR-26, BR-32)

Step 5: **YRESEND** — RESEND：对未 OK 的原回执增加尝试号并置 NEW，原消息 ID、PAYLOAD、LEN 和业务关联不变；已 OK 返回 0020。这一步不调用任何库存或结算程序。 (BR-26, BR-31)

Step 6: **YLIST** — LIST：FOR EACH OUTBYST 按消息种类及送达状态前缀读取，逐条返回给主程序形成列表；采用调用者游标 OBID 和固定一次一条，RESDS.RSCOUNT=0 表示结束。不在列表中自动重送。 (BR-26, BR-32)

Step 7: **YRET** — 返回结果；更新失败交主程序撤销本次未提交变化，业务已在先前事件提交时不能重做。通过 RESDS 提供审计事实，本程序不写 AUDITPF、不提交。 (BR-26, BR-32)

### File Output / Update

| File | Action | Fields Modified | File Spec Ref | Condition / Steps |
| --- | --- | --- | --- | --- |
| OUTBOXPF | WRITE / UPDATE | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE；UPDATE 仅 OBSTATE/OBATTEMPT/OBREASON，不更改 OBPAYLOAD/OBLEN 或业务关联 | OUTBOXPF-20260905-01 | Step 3, Step 4, Step 5 |

## Error Handling

| Scenario | Return Code | Action | Logged? |
| --- | --- | --- | --- |
| E01 · Validation Error | 1000 / 1100 | 拒绝本次候选；主程序记录可定位的结果，保持已提交事实。 | 主程序 AUDITPF |
| E02 · Data Not Found / Data Error | 1000 / 2000 | 业务资格资料缺失可拒绝；关键历史关系缺失返回数据异常，不用零值继续。 | 主程序 AUDITPF |
| E03 · Update Failure | 3000 / 9000 | 停止本次写入，主程序确认回滚；不可靠时停止批次。 | 主程序或作业异常摘要 |
| E04 · System Error | 9000 | 无法可靠读取／写入／确认事务结果时停止；不得假报回滚成功。 | 作业异常摘要；不保证故障时能写审计文件 |

## Traceability Matrix

| BR | Logic Steps | Error Handling Row | Files |
| --- | --- | --- | --- |
| BR-06 | Step 3 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF |
| BR-26 | Step 1, Step 2, Step 3, Step 4, Step 5, Step 6, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, OUTBYST |
| BR-31 | Step 5 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF |
| BR-32 | Step 1, Step 2, Step 3, Step 4, Step 6, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, OUTBYST |

## Processing Considerations

单作业串行处理；显式日期，不依赖运行机器的当前日期。多记录范围及历史集合读完整，固定数组只限制单次事件候选。ORDMAIN 是正常提交／回滚所有者；辅助程序不得提交，失败由调用方整体撤销。不设置吞吐量或运行成功承诺。

## Compile-Oriented Constraints

| File | Record Format | RENAME | KLIST / KFLD 顺序 | Confidence |
| --- | --- | --- | --- | --- |
| OUTBOXPF | OUTBOXR | N/A | KOUT = OBID | Assumed：授权合成，未编译 |
| OUTBYST | OUTBOXR | OUTBYSR | KOUTST = OBKIND + OBSTATE + OBID | Assumed：授权合成，未编译 |

RPGLE 使用固定格式 H/F/D/C、显式文件描述、已列出的键访问和共享 COPY。一个读取完成立即检查自己的结果指示器，不能沿用前一调用状态。参考源成员 N/A；不生成编译命令。本轮只核对结构，后续源码阶段再核对列位置、具体操作码与环境兼容性。

## Programming Language

RPGLE；固定格式。

## Amend Data Structure

N/A：全新合成程序，尚无旧结构迁移。

## Open Questions / TBD

无阻塞本阶段的业务／字段待定项。实际 IBM i 版本与编译配置属于当前范围外，不能把 Draft 当作已编译程序。

## Spec Summary

| Level | Rules | Steps | Files | Calls | Open Questions |
| --- | --- | --- | --- | --- | --- |
| L3 Full | 4 | 7 | 2 | 0 | 0 |

Traceability Complete：规格内 BR 到步骤和文件／委派入口已建立。状态 Draft；所有规则是继承规则，没有新增需求级 BR。
