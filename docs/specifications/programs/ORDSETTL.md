# ORDSETTL 程序规格

## Spec Header

- **Spec ID**：ORDSETTL-20260905-01
- **Spec Level**：L3 Full
- **Version / Status**：1.0 / Draft
- **Change Type / Program Type**：New Program / RPGLE
- **Program Name**：ORDSETTL
- **Description**：结算事实、原发货调整查询及结算类消息交接。
- **Source TD**：[TD-20260905-01](../../design/technical-design.md) Module Allocation 行 `ORDSETTL`。
- **共同输入**：[功能需求](../../requirements/functional-requirements.md)、[共享契约](../shared-contract.md)。全部字段及步骤为授权合成定义，不是对既有系统的发现。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次完整规格。

## Caller Context

仅由 ORDMAIN 同步调用；按 CTXDS.CXACTION 选择适用动作。成功后调用方按返回码继续；失败由主程序决定回滚、记录结果或停止。辅助成功不等于事务提交。

## Functions

- 结算事实、原发货调整查询及结算类消息交接。
- 输出有身份和原因的结果，保持职责范围与静态追踪关系。

## Business Rules

继承 FS 编号，不在各程序重新从 01 编号。主责与协作分开；下面的恢复／记录引用不把所有规则所有权转移到本程序。

| BR | 需求规则 | 本程序角色 |
| --- | --- | --- |
| BR-20 | 退货只能引用已成功结算的原发货明细；每次退货数量须为正整数，累计退货数量不得超过该明细已发货数量，退货处理日与发货业务日相差须为 0～30 个自然日（含边界）。 | 协作／处理边界；主责 ORDMAIN |
| BR-22 | 退货调整沿用原发货结算金额。按累计退货数量比例计算累计应调整额，再扣除此前已成功调整额；全部退回时累计调整必须等于原发货结算金额。同一原发货明细仍有未完成调整时，后续退货暂不受理且不增加归还数量；原调整沿既有身份恢复，不重复创建。 | 协作／处理边界；主责 ORDMAIN |
| BR-23 | 结算只针对已确认发货，且每次发货只形成一项正向结算。分次发货按原订单行金额的累计发货比例分摊到两位小数，本次金额为累计应结算额减此前已分配给发货的金额，全部发完时正好等于原行金额。 | 协作／处理边界；主责 ORDMAIN |
| BR-24 | 明确的结算失败保留已发货或已接受退货事实，标为待恢复；结算结果未知时保留为待核实，核实前不能再次发起结算或宣告成功。 | 协作／处理边界；主责 ORDMAIN |
| BR-25 | 已确认可重试的失败沿用原结算或调整身份重试，不创建第二笔业务；成功结果不得被后到的失败通知覆盖，重复成功通知不重复计入金额。 | 协作／处理边界；主责 ORDMAIN |
| BR-30 | 日终金额按本处理日已确认成功的正向结算减本处理日已确认成功的退货调整汇总；待处理、失败和未知结果另列，历史成功记录不因后来退货而从历史汇总消失。 | 协作／处理边界；主责 ORDDAILY |
| BR-31 | 人工处置须保留操作者、原因及所选择的恢复动作；不能直接覆盖成功结算、抹去原失败或跳过数量和状态校验。 | 协作／处理边界；主责 ORDMAIN |
| BR-32 | 请求、订单、明细、发货、退货、结算、调整、回执和处理批次均能沿关联标识追溯；拒绝、等待和重试也须保留可解释的业务结果。 | 协作／处理边界；主责 ORDMAIN |

## Interface Contract

参数按位置引用传递，完整布局只在共享契约定义；本表长度为字节。IO 表示依动作输入或输出，输入用途与目标状态不能通过残留值猜测。

### Program Parameters

| 位置 | Name | Type | Length | I/O | Valid Values / Description |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | FETCH / LOOKUP / CREATE / APPLY / RETRY / VERIFY / DELIVERY |
| 2 | SETHEAD | DS | 398 | IO | FETCH 输出；写入动作输入所允许目标 |
| 3 | SETROWS | DS | 13300 | IO | FETCH / CREATE 结算明细 |
| 4 | SETVIEW | DS | 1700 | O | LOOKUP 的成功累计和待调整标志 |
| 5 | OUTREC | DS | 30375 | IO | 消息查询／创建／送达 |
| 6 | RESDS | DS | 153 | O | 结果 |

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
| OBID | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-01 | 唯一消息身份 |
| OBKIND | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-02 | SETTLE / ADJUST / VERIFY / RECEIPT / WHRESULT |
| OBBIZID | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-03 | 结算身份或回执关联业务身份 |
| OBSRC | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-04 | 请求来源 |
| OBREQ | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-05 | 请求标识 |
| OBBATCH | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-06 | 原始输入批次 |
| OBINPUT | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-07 | 原始输入序号 |
| OBORDER | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-08 | 订单 |
| OBSTATE | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-09 | NEW / SENT / OK / FAIL |
| OBRESULT | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-10 | NONE / OK / FAIL / UNKNOWN / RETRYOK，业务反馈与送达分开 |
| OBRESDAY | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-11 | 业务反馈处理日；无反馈为空 |
| OBATTEMPT | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-12 | 消息送达尝试次数 |
| OBDAY | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-13 | 创建处理日 |
| OBLEN | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-14 | 有效负载长度 |
| OBPAYLOAD | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-15 | 带版本的完整消息内容，长度外为空格 |
| OBREASON | OUTBOXPF | Persisted | Step 2, Step 6, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | OUTBOXPF-20260905-01:FLD-16 | 最近送达原因 |
| SEID | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-01 | 正向 S:发货 或反向 A:退货:原发货 |
| SEKIND | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-02 | P 正向 / R 反向 |
| SESHIP | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-03 | 原发货，正反向均必填 |
| SERETURN | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-04 | 反向来源退货，正向为空 |
| SEORIG | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-05 | 反向的原正向结算，正向为空 |
| SEORDER | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-06 | 原订单 |
| SECREATED | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-07 | 创建业务日 |
| SESTATE | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-08 | NEW / SENT / OK / FAIL / UNKNOWN |
| SEAMOUNT | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-09 | 结算金额，正反向都存非负数 |
| SEFIRSTDAY | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-10 | 首次认定成功日；未成功为空格 |
| SEATTEMPT | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-11 | 本业务发送尝试号，初值 1 |
| SELASTMSG | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-12 | 当前发送或核实消息 |
| SENLINE | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-13 | 结算明细数 |
| SERETRY | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-14 | 是否已有明确可重试证据 Y/N |
| SEREASON | SETLBYREF | Persisted | Step 3 | — | SETLBYREF-20260905-01:FLD-15 | 最近有效结果说明 |
| SLSETTL | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-01 | 结算身份 |
| SLLINE | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-02 | 结算内明细序号 |
| SLSHIP | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-03 | 原发货 |
| SLSHLINE | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-04 | 原发货明细 |
| SLRETURN | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-05 | 反向来源退货，正向为空 |
| SLRTLINE | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-06 | 反向来源退货明细；正向 0 |
| SLORDER | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-07 | 原订单 |
| SLORDLINE | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-08 | 原订单行 |
| SLQTY | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-09 | 结算／调整对应数量 |
| SLAMOUNT | SETLDTPF | Persisted | Step 2, Step 3, Step 4 | Step 5 | SETLDTPF-20260905-01:FLD-10 | 金额绝对值 |
| SEID | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-01 | 正向 S:发货 或反向 A:退货:原发货 |
| SEKIND | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-02 | P 正向 / R 反向 |
| SESHIP | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-03 | 原发货，正反向均必填 |
| SERETURN | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-04 | 反向来源退货，正向为空 |
| SEORIG | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-05 | 反向的原正向结算，正向为空 |
| SEORDER | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-06 | 原订单 |
| SECREATED | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-07 | 创建业务日 |
| SESTATE | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-08 | NEW / SENT / OK / FAIL / UNKNOWN |
| SEAMOUNT | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-09 | 结算金额，正反向都存非负数 |
| SEFIRSTDAY | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-10 | 首次认定成功日；未成功为空格 |
| SEATTEMPT | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-11 | 本业务发送尝试号，初值 1 |
| SELASTMSG | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-12 | 当前发送或核实消息 |
| SENLINE | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-13 | 结算明细数 |
| SERETRY | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-14 | 是否已有明确可重试证据 Y/N |
| SEREASON | SETLHDPF | Persisted | Step 2, Step 4, Step 6, Step 7, Step 8, Step 9 | Step 5, Step 6, Step 7, Step 8, Step 9 | SETLHDPF-20260905-01:FLD-15 | 最近有效结果说明 |

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
| SETHEAD.SEID | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-01 | 正向 S:发货 或反向 A:退货:原发货 |
| SETHEAD.SEKIND | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-02 | P 正向 / R 反向 |
| SETHEAD.SESHIP | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-03 | 原发货，正反向均必填 |
| SETHEAD.SERETURN | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-04 | 反向来源退货，正向为空 |
| SETHEAD.SEORIG | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-05 | 反向的原正向结算，正向为空 |
| SETHEAD.SEORDER | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-06 | 原订单 |
| SETHEAD.SECREATED | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-07 | 创建业务日 |
| SETHEAD.SESTATE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-08 | NEW / SENT / OK / FAIL / UNKNOWN |
| SETHEAD.SEAMOUNT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-09 | 结算金额，正反向都存非负数 |
| SETHEAD.SEFIRSTDAY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-10 | 首次认定成功日；未成功为空格 |
| SETHEAD.SEATTEMPT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-11 | 本业务发送尝试号，初值 1 |
| SETHEAD.SELASTMSG | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-12 | 当前发送或核实消息 |
| SETHEAD.SENLINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-13 | 结算明细数 |
| SETHEAD.SERETRY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-14 | 是否已有明确可重试证据 Y/N |
| SETHEAD.SEREASON | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLHDPF-20260905-01:FLD-15 | 最近有效结果说明 |
| SETROWS[].SLSETTL | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-01 | 结算身份 |
| SETROWS[].SLLINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-02 | 结算内明细序号 |
| SETROWS[].SLSHIP | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-03 | 原发货 |
| SETROWS[].SLSHLINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-04 | 原发货明细 |
| SETROWS[].SLRETURN | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-05 | 反向来源退货，正向为空 |
| SETROWS[].SLRTLINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-06 | 反向来源退货明细；正向 0 |
| SETROWS[].SLORDER | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-07 | 原订单 |
| SETROWS[].SLORDLINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-08 | 原订单行 |
| SETROWS[].SLQTY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-09 | 结算／调整对应数量 |
| SETROWS[].SLAMOUNT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | SETLDTPF-20260905-01:FLD-10 | 金额绝对值 |
| SETVIEW[].SVSHLINE | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 SETVIEW | 原发货明细 |
| SETVIEW[].SVSUCCQTY | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 SETVIEW | 已经成功调整的累计数量 |
| SETVIEW[].SVSUCCAMT | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 SETVIEW | 已经成功调整的累计绝对金额 |
| SETVIEW[].SVPENDING | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 SETVIEW | 是否有未完成调整 Y/N |
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
| SETLBYREF | I | SESHIP + SEKIND + SEID | 1:1 + 1:N | [SETLBYREF-20260905-01](../files/SETLBYREF.md) | 按原发货定位正反向结算 |
| SETLDTPF | U | SLSETTL + SLLINE | 1:1 + 1:N | [SETLDTPF-20260905-01](../files/SETLDTPF.md) | 形成后不再重算的结算数量及金额明细 |
| SETLHDPF | U | SEID | 1:1 | [SETLHDPF-20260905-01](../files/SETLHDPF.md) | 正反向结算处理状态与首次成功事实 |

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
| TINIT | Step 1 | 初始化输出工作区，按动作保留必要输入；检查 CXABI、结算类别、身份格式和数组容量 |
| TFETCH | Step 2 | FETCH：按结算身份读 SETLHDPF，FOR EACH SETLDTPF 按结算键前缀读完整明细；按消息身份读 OUTBOXPF |
| TLOOK | Step 3 | LOOKUP：FOR EACH SETLBYREF 以原发货前缀读取正反向头；正向必须唯一，输出其状态 |
| TCREATE | Step 4 | CREATE：主程序已允许的 SETHEAD/SETROWS 必须满足稳定业务身份、头明细数量／金额相符、原发货关联完整 |
| TWRITE | Step 5 | 新 CREATE 写结算头 NEW、SEFIRSTDAY 空、SEATTEMPT=1、SERETRY=N，逐行 WRITE 明细；登记唯一 SETTLE 或 ADJUST 待交接消息，载荷金额形成后不重算 |
| TAPPLY | Step 6 | APPLY：重读当前头及消息，确认 SESTATE/SEATTEMPT 仍等于 CXEXPECT/CXATTEMPT；仅应用主程序已允许的 STATE/FIRSTDAY/RETRY/REASON；把 CXFEED 与当前处理日写 OBRESULT/OBRESDAY，OBSTATE 仍只描述送达，保持身份、金额、原关联与明细不变 |
| TRETRY | Step 7 | RETRY：重读须 FAIL 且 RETRY=Y；原 SEID/金额/明细不变，SEATTEMPT 加一，登记新的业务尝试消息，状态 NEW，RETRY=N |
| TVERIFY | Step 8 | VERIFY：只针对 UNKNOWN 登记核实消息；若 SELASTMSG 已指向 OBRESULT=NONE/UNKNOWN 的 VERIFY，返回等待，不重复登记 |
| TDELIV | Step 9 | DELIVERY：只处理 SETTLE/ADJUST/VERIFY 类消息的送达字段 |
| TRET | Step 10 | 返回规范结果及出站关联，失败不修改库存／订单／发货／退货；文件更新异常经 RESDS 返回，主程序统一审计及回滚 |

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
| FETCH | Step 1–2、10 |
| LOOKUP | Step 1、3、10 |
| CREATE | Step 1、4–5、10 |
| APPLY / RETRY / VERIFY / DELIVERY | Step 1，再分别 Step 6 / 7 / 8 / 9，Step 10 返回 |

Step 1: **TINIT** — 初始化输出工作区，按动作保留必要输入；检查 CXABI、结算类别、身份格式和数组容量。IF 无完整来源关联 → 1000。 (BR-23, BR-24, BR-25, BR-32)

Step 2: **TFETCH** — FETCH：按结算身份读 SETLHDPF，FOR EACH SETLDTPF 按结算键前缀读完整明细；按消息身份读 OUTBOXPF。核对数量和头金额等于明细和。IF 缺关联 → 2000；不以空缓冲当作新对象。 (BR-20, BR-23, BR-24, BR-25)

Step 3: **TLOOK** — LOOKUP：FOR EACH SETLBYREF 以原发货前缀读取正反向头；正向必须唯一，输出其状态。对每个反向头 FOR EACH SETLDTPF 累加对应原发货明细的成功数量／金额；非 OK 的关联明细设置 SETVIEW.SVPENDING=Y。历史头流式扫描，不把 100 个请求行容量当作历史上限。 (BR-20, BR-22)

Step 4: **TCREATE** — CREATE：主程序已允许的 SETHEAD/SETROWS 必须满足稳定业务身份、头明细数量／金额相符、原发货关联完整。IF SEID 已存在 → 完整比较事实，相同返回 0020，不同 1100；主程序不能在新发货／退货路径把此返回当作重复实物流转许可。 (BR-22, BR-23, BR-25)

Step 5: **TWRITE** — 新 CREATE 写结算头 NEW、SEFIRSTDAY 空、SEATTEMPT=1、SERETRY=N，逐行 WRITE 明细；登记唯一 SETTLE 或 ADJUST 待交接消息，载荷金额形成后不重算。任何失败返回主程序回滚整个业务单元。 (BR-22, BR-23, BR-24)

Step 6: **TAPPLY** — APPLY：重读当前头及消息，确认 SESTATE/SEATTEMPT 仍等于 CXEXPECT/CXATTEMPT；仅应用主程序已允许的 STATE/FIRSTDAY/RETRY/REASON；把 CXFEED 与当前处理日写 OBRESULT/OBRESDAY，OBSTATE 仍只描述送达，保持身份、金额、原关联与明细不变。重复 OK 不覆盖 FIRSTDAY；不合法迁移返回 1100。 (BR-24, BR-25, BR-30)

Step 7: **TRETRY** — RETRY：重读须 FAIL 且 RETRY=Y；原 SEID/金额/明细不变，SEATTEMPT 加一，登记新的业务尝试消息，状态 NEW，RETRY=N。若当前已成功则返回最近结果，不登记第二笔业务。 (BR-24, BR-25, BR-31)

Step 8: **TVERIFY** — VERIFY：只针对 UNKNOWN 登记核实消息；若 SELASTMSG 已指向 OBRESULT=NONE/UNKNOWN 的 VERIFY，返回等待，不重复登记。保持业务状态 UNKNOWN 和原业务金额；新查询载荷不能包含再次结算指令。 (BR-24, BR-25, BR-31)

Step 9: **TDELIV** — DELIVERY：只处理 SETTLE/ADJUST/VERIFY 类消息的送达字段。IF 对应当前业务消息且结算 NEW → 可按主程序允许改 SENT；送达不建立 SEFIRSTDAY。旧消息送达不回退新尝试，已成功业务保持成功。 (BR-24, BR-25, BR-32)

Step 10: **TRET** — 返回规范结果及出站关联，失败不修改库存／订单／发货／退货；文件更新异常经 RESDS 返回，主程序统一审计及回滚。 (BR-24, BR-25, BR-32)

### File Output / Update

| File | Action | Fields Modified | File Spec Ref | Condition / Steps |
| --- | --- | --- | --- | --- |
| OUTBOXPF | WRITE / UPDATE | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE；UPDATE 仅 OBSTATE/OBATTEMPT/OBREASON/OBRESULT/OBRESDAY（结算反馈） | OUTBOXPF-20260905-01 | Step 5, Step 6, Step 7, Step 8, Step 9 |
| SETLDTPF | WRITE only | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | SETLDTPF-20260905-01 | Step 5 |
| SETLHDPF | WRITE / UPDATE | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE；后续只改 SESTATE/SEFIRSTDAY/SEATTEMPT/SELASTMSG/SERETRY/SEREASON | SETLHDPF-20260905-01 | Step 5, Step 6, Step 7, Step 8, Step 9 |

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
| BR-20 | Step 2, Step 3 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, SETLBYREF, SETLDTPF, SETLHDPF |
| BR-22 | Step 3, Step 4, Step 5 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, SETLBYREF, SETLDTPF, SETLHDPF |
| BR-23 | Step 1, Step 2, Step 4, Step 5 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, SETLDTPF, SETLHDPF |
| BR-24 | Step 1, Step 2, Step 5, Step 6, Step 7, Step 8, Step 9, Step 10 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, SETLDTPF, SETLHDPF |
| BR-25 | Step 1, Step 2, Step 4, Step 6, Step 7, Step 8, Step 9, Step 10 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, SETLDTPF, SETLHDPF |
| BR-30 | Step 6 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, SETLHDPF |
| BR-31 | Step 7, Step 8 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, SETLHDPF |
| BR-32 | Step 1, Step 9, Step 10 | E01 / E02 / E03 / E04（按具体失败类别） | OUTBOXPF, SETLHDPF |

## Processing Considerations

单作业串行处理；显式日期，不依赖运行机器的当前日期。多记录范围及历史集合读完整，固定数组只限制单次事件候选。ORDMAIN 是正常提交／回滚所有者；辅助程序不得提交，失败由调用方整体撤销。不设置吞吐量或运行成功承诺。

## Compile-Oriented Constraints

| File | Record Format | RENAME | KLIST / KFLD 顺序 | Confidence |
| --- | --- | --- | --- | --- |
| OUTBOXPF | OUTBOXR | N/A | KOUT = OBID | Assumed：授权合成，未编译 |
| SETLBYREF | SETLHDR | SETLRFR | KSETRF = SESHIP + SEKIND + SEID | Assumed：授权合成，未编译 |
| SETLDTPF | SETLDTR | N/A | KSETLD = SLSETTL + SLLINE | Assumed：授权合成，未编译 |
| SETLHDPF | SETLHDR | N/A | KSETLH = SEID | Assumed：授权合成，未编译 |

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
| L3 Full | 8 | 10 | 4 | 0 | 0 |

Traceability Complete：规格内 BR 到步骤和文件／委派入口已建立。状态 Draft；所有规则是继承规则，没有新增需求级 BR。
