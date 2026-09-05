# ORDDAILY 程序规格

## Spec Header

- **Spec ID**：ORDDAILY-20260905-01
- **Spec Level**：L3 Full
- **Version / Status**：1.0 / Draft
- **Change Type / Program Type**：New Program / RPGLE
- **Program Name**：ORDDAILY
- **Description**：按首次成功日生成净额、未完成结算和本地待恢复快照。
- **Source TD**：[TD-20260905-01](../../design/technical-design.md) Module Allocation 行 `ORDDAILY`。
- **共同输入**：[功能需求](../../requirements/functional-requirements.md)、[共享契约](../shared-contract.md)。全部字段及步骤为授权合成定义，不是对既有系统的发现。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次完整规格。

## Caller Context

仅由 ORDMAIN 同步调用；按 CTXDS.CXACTION 选择适用动作。成功后调用方按返回码继续；失败由主程序决定回滚、记录结果或停止。辅助成功不等于事务提交。

## Functions

- 按首次成功日生成净额、未完成结算和本地待恢复快照。
- 输出有身份和原因的结果，保持职责范围与静态追踪关系。

## Business Rules

继承 FS 编号，不在各程序重新从 01 编号。主责与协作分开；下面的恢复／记录引用不把所有规则所有权转移到本程序。

| BR | 需求规则 | 本程序角色 |
| --- | --- | --- |
| BR-24 | 明确的结算失败保留已发货或已接受退货事实，标为待恢复；结算结果未知时保留为待核实，核实前不能再次发起结算或宣告成功。 | 协作／处理边界；主责 ORDMAIN |
| BR-27 | 批次中的业务拒绝只影响该请求，其余独立请求继续；每条请求的受理结果及等待／失败原因可单独查询。 | 协作／处理边界；主责 ORDMAIN |
| BR-28 | 恢复中断批次时跳过已完成请求，从未完成请求继续；“结果未知”的外部结算先核实，不能因重跑批次而重发业务。 | 协作／处理边界；主责 ORDMAIN |
| BR-30 | 日终金额按本处理日已确认成功的正向结算减本处理日已确认成功的退货调整汇总；待处理、失败和未知结果另列，历史成功记录不因后来退货而从历史汇总消失。 | 主责 |
| BR-32 | 请求、订单、明细、发货、退货、结算、调整、回执和处理批次均能沿关联标识追溯；拒绝、等待和重试也须保留可解释的业务结果。 | 协作／处理边界；主责 ORDMAIN |

## Interface Contract

参数按位置引用传递，完整布局只在共享契约定义；本表长度为字节。IO 表示依动作输入或输出，输入用途与目标状态不能通过残留值猜测。

### Program Parameters

| 位置 | Name | Type | Length | I/O | Valid Values / Description |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | SNAPSHOT / FETCH；生成用 CXPROCDAY，查询用 CXDAY；来源和请求确定快照 |
| 2 | DAYHEAD | DS | 188 | O | 日报头 |
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
| DYDAY | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-01 | 被汇总处理日 |
| DYSNAP | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-02 | 来源:日终请求标识；同日完整快照身份 |
| DYLINE | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-03 | 0 为头；其余为组成行 |
| DYKIND | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-04 | HEADER / POS / NEG / PENDING / LOCAL |
| DYSTATE | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-05 | 头 DRAFT / READY；组成行保存观察状态 |
| DYSETTL | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-06 | 组成结算身份 |
| DYSRC | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-07 | 组成请求来源 |
| DYREQ | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-08 | 组成请求标识 |
| DYAMOUNT | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-09 | 行金额；HEADER 存净额，NEG 行存负值 |
| DYPOS | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-10 | 头正向总额 |
| DYNEG | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-11 | 头反向绝对值总额 |
| DYCOUNT | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-12 | 头组成行数 |
| DYRC | DAYRPTPF | Persisted | Step 1 | Step 2, Step 3, Step 4, Step 5, Step 6 | DAYRPTPF-20260905-01:FLD-13 | 待处理原因结果码 |
| RQSRC | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-01 | 规范来源 |
| RQREQ | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-02 | 规范请求标识 |
| RQBATCH | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-03 | 首次出现批次 |
| RQINPUT | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-04 | 首次输入序号 |
| RQEVENT | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-05 | 原请求事件 |
| RQDAY | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-06 | 原请求处理日 |
| RQCANLEN | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-07 | 规范内容实际长度 |
| RQCANON | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-08 | 完整规范内容，不以哈希替代比较 |
| RQORDER | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-09 | 关联订单 |
| RQSHIP | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-10 | 关联发货 |
| RQRETURN | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-11 | 关联退货 |
| RQSETTL | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-12 | 单项结算关联，多个时沿退货查询 |
| RQSTATE | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-13 | DONE / REJECT / RETRY，指原请求本地处理 |
| RQRC | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-14 | 最近一次原请求本地处理结果 |
| RQREASON | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-15 | 结果原因 |
| RQVERSION | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-16 | 本地接受后订单版本，非最新订单版本缓存 |
| RQMSG | REQPF | Persisted | Step 5 | — | REQPF-20260905-01:FLD-17 | 最近一次结果投影的回执消息身份；原始请求内容保持不变 |
| SEID | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-01 | 正向 S:发货 或反向 A:退货:原发货 |
| SEKIND | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-02 | P 正向 / R 反向 |
| SESHIP | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-03 | 原发货，正反向均必填 |
| SERETURN | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-04 | 反向来源退货，正向为空 |
| SEORIG | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-05 | 反向的原正向结算，正向为空 |
| SEORDER | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-06 | 原订单 |
| SECREATED | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-07 | 创建业务日 |
| SESTATE | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-08 | NEW / SENT / OK / FAIL / UNKNOWN |
| SEAMOUNT | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-09 | 结算金额，正反向都存非负数 |
| SEFIRSTDAY | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-10 | 首次认定成功日；未成功为空格 |
| SEATTEMPT | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-11 | 本业务发送尝试号，初值 1 |
| SELASTMSG | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-12 | 当前发送或核实消息 |
| SENLINE | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-13 | 结算明细数 |
| SERETRY | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-14 | 是否已有明确可重试证据 Y/N |
| SEREASON | SETLBYDAY | Persisted | Step 3, Step 4 | — | SETLBYDAY-20260905-01:FLD-15 | 最近有效结果说明 |
| SLSETTL | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-01 | 结算身份 |
| SLLINE | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-02 | 结算内明细序号 |
| SLSHIP | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-03 | 原发货 |
| SLSHLINE | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-04 | 原发货明细 |
| SLRETURN | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-05 | 反向来源退货，正向为空 |
| SLRTLINE | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-06 | 反向来源退货明细；正向 0 |
| SLORDER | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-07 | 原订单 |
| SLORDLINE | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-08 | 原订单行 |
| SLQTY | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-09 | 结算／调整对应数量 |
| SLAMOUNT | SETLDTPF | Persisted | Step 3 | — | SETLDTPF-20260905-01:FLD-10 | 金额绝对值 |

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
| DAYHEAD.DYDAY | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-01 | 被汇总处理日 |
| DAYHEAD.DYSNAP | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-02 | 来源:日终请求标识；同日完整快照身份 |
| DAYHEAD.DYLINE | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-03 | 0 为头；其余为组成行 |
| DAYHEAD.DYKIND | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-04 | HEADER / POS / NEG / PENDING / LOCAL |
| DAYHEAD.DYSTATE | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-05 | 头 DRAFT / READY；组成行保存观察状态 |
| DAYHEAD.DYSETTL | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-06 | 组成结算身份 |
| DAYHEAD.DYSRC | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-07 | 组成请求来源 |
| DAYHEAD.DYREQ | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-08 | 组成请求标识 |
| DAYHEAD.DYAMOUNT | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-09 | 行金额；HEADER 存净额，NEG 行存负值 |
| DAYHEAD.DYPOS | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-10 | 头正向总额 |
| DAYHEAD.DYNEG | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-11 | 头反向绝对值总额 |
| DAYHEAD.DYCOUNT | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-12 | 头组成行数 |
| DAYHEAD.DYRC | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | DAYRPTPF-20260905-01:FLD-13 | 待处理原因结果码 |
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
| DAYRPTPF | U | DYDAY + DYSNAP + DYLINE | 1:1 + 1:N | [DAYRPTPF-20260905-01](../files/DAYRPTPF.md) | 日报头与可追溯组成行 |
| REQPF | I | RQSRC + RQREQ | 1:1 + 1:N + Sequential（关联历史／待恢复） | [REQPF-20260905-01](../files/REQPF.md) | 去重、原始受理和本地恢复账本 |
| SETLBYDAY | I | SESTATE + SEFIRSTDAY + SEID | 1:1 + 1:N | [SETLBYDAY-20260905-01](../files/SETLBYDAY.md) | 按状态及首次成功日读取结算 |
| SETLDTPF | I | SLSETTL + SLLINE | 1:1 + 1:N | [SETLDTPF-20260905-01](../files/SETLDTPF.md) | 形成后不再重算的结算数量及金额明细 |

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
| DINIT | Step 1 | 接收 SNAPSHOT，规范 DYDAY=CXPROCDAY、DYSNAP=CXSRC:CXREQ、DYLINE=0 |
| DSTART | Step 2 | 初始化 P(19,2) 正向、反向、净额及逐行计数，写本地未发布 HEADER 草稿；所有后续输出仍在主程序同一提交单元 |
| DSUCCESS | Step 3 | FOR EACH SETLBYDAY 以 SESTATE=OK、SEFIRSTDAY=指定日键前缀读取 |
| DPENDING | Step 4 | 对 NEW/SENT/FAIL/UNKNOWN 各状态前缀 FOR EACH SETLBYDAY 读取，写 PENDING 行保存其观察状态及金额但不加净额 |
| DLOCAL | Step 5 | FOR EACH REQPF 显式全表扫描，仅 RQSTATE=RETRY 写 LOCAL 待恢复行，保留来源／请求／RC，金额不计净额；DONE 上旧等待结果不当作尚未结算依据 |
| DPUBLISH | Step 6 | 净额=正向−反向绝对值合计，更新 HEADER 的 AMOUNT/POS/NEG/COUNT、STATE=READY，返回头 |
| DFAIL | Step 7 | IF 读取、写入或总额核对失败 → 返回 2000/3000/9000，主程序回滚本快照所有行 |

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
| SNAPSHOT | Step 1–6；已发布在 Step 1 返回；异常进入 Step 7 |
| FETCH | 仅 Step 1 查询既有快照；缺失返回 2000，禁止写入 |

Step 1: **DINIT** — 接收 SNAPSHOT/FETCH；生成时 DYDAY=CXPROCDAY，查询时 DYDAY=CXDAY，DYSNAP=CXSRC:CXREQ、DYLINE=0。按完整键读 DAYRPTPF；IF READY 头存在 → 返回已发布快照 0020；IF FETCH 未找到或只见残缺 DRAFT／明细 → 2000，禁止创建或覆盖；只有新 SNAPSHOT 可继续生成。 (BR-30, BR-32)

Step 2: **DSTART** — 初始化 P(19,2) 正向、反向、净额及逐行计数，写本地未发布 HEADER 草稿；所有后续输出仍在主程序同一提交单元。IF 任一累计或序号容量越界 → 2000。 (BR-30, BR-32)

Step 3: **DSUCCESS** — FOR EACH SETLBYDAY 以 SESTATE=OK、SEFIRSTDAY=指定日键前缀读取。对每个头 FOR EACH SETLDTPF 读明细核对合计，再按 P/R 累加正向或反向；写含 SEID 的 POS/NEG 组成行，NEG 用负值。旧日成功不重复计入，也不因后来的反向成功删除。 (BR-30)

Step 4: **DPENDING** — 对 NEW/SENT/FAIL/UNKNOWN 各状态前缀 FOR EACH SETLBYDAY 读取，写 PENDING 行保存其观察状态及金额但不加净额。这些项可跨创建日，不能只查 FIRSTDAY=当天；未成功记录的 FIRSTDAY 必须为空。 (BR-24, BR-30)

Step 5: **DLOCAL** — FOR EACH REQPF 显式全表扫描，仅 RQSTATE=RETRY 写 LOCAL 待恢复行，保留来源／请求／RC，金额不计净额；DONE 上旧等待结果不当作尚未结算依据。 (BR-27, BR-30, BR-32)

Step 6: **DPUBLISH** — 净额=正向−反向绝对值合计，更新 HEADER 的 AMOUNT/POS/NEG/COUNT、STATE=READY，返回头。主程序再统一提交；本程序不 COMMIT、不改变任何结算状态或 FIRSTDAY。 (BR-30, BR-32)

Step 7: **DFAIL** — IF 读取、写入或总额核对失败 → 返回 2000/3000/9000，主程序回滚本快照所有行。无成功返回不能宣称日报已发布；同快照失败后仅在确认无提交事实时重做。 (BR-28, BR-30, BR-32)

### File Output / Update

| File | Action | Fields Modified | File Spec Ref | Condition / Steps |
| --- | --- | --- | --- | --- |
| DAYRPTPF | WRITE / UPDATE | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | DAYRPTPF-20260905-01 | Step 2, Step 3, Step 4, Step 5, Step 6 |

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
| BR-24 | Step 4 | E01 / E02 / E03 / E04（按具体失败类别） | DAYRPTPF, SETLBYDAY |
| BR-27 | Step 5 | E01 / E02 / E03 / E04（按具体失败类别） | DAYRPTPF, REQPF |
| BR-28 | Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-30 | Step 1, Step 2, Step 3, Step 4, Step 5, Step 6, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | DAYRPTPF, REQPF, SETLBYDAY, SETLDTPF |
| BR-32 | Step 1, Step 2, Step 5, Step 6, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | DAYRPTPF, REQPF |

## Processing Considerations

单作业串行处理；显式日期，不依赖运行机器的当前日期。多记录范围及历史集合读完整，固定数组只限制单次事件候选。ORDMAIN 是正常提交／回滚所有者；辅助程序不得提交，失败由调用方整体撤销。不设置吞吐量或运行成功承诺。

## Compile-Oriented Constraints

| File | Record Format | RENAME | KLIST / KFLD 顺序 | Confidence |
| --- | --- | --- | --- | --- |
| DAYRPTPF | DAYRPTR | N/A | KDAY = DYDAY + DYSNAP + DYLINE | Assumed：授权合成，未编译 |
| REQPF | REQR | N/A | KREQ = RQSRC + RQREQ | Assumed：授权合成，未编译 |
| SETLBYDAY | SETLHDR | SETLDYR | KSETDY = SESTATE + SEFIRSTDAY + SEID | Assumed：授权合成，未编译 |
| SETLDTPF | SETLDTR | N/A | KSETLD = SLSETTL + SLLINE | Assumed：授权合成，未编译 |

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
| L3 Full | 5 | 7 | 4 | 0 | 0 |

Traceability Complete：规格内 BR 到步骤和文件／委派入口已建立。状态 Draft；所有规则是继承规则，没有新增需求级 BR。
