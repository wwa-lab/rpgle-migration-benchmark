# ORDCHECK 程序规格

## Spec Header

- **Spec ID**：ORDCHECK-20260905-01
- **Spec Level**：L3 Full
- **Version / Status**：1.0 / Draft
- **Change Type / Program Type**：New Program / RPGLE
- **Program Name**：ORDCHECK
- **Description**：原始输入规范化以及客户、商品、数量资格校验。
- **Source TD**：[TD-20260905-01](../../design/technical-design.md) Module Allocation 行 `ORDCHECK`。
- **共同输入**：[功能需求](../../requirements/functional-requirements.md)、[共享契约](../shared-contract.md)。全部字段及步骤为授权合成定义，不是对既有系统的发现。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次完整规格。

## Caller Context

仅由 ORDMAIN 同步调用；按 CTXDS.CXACTION 选择适用动作。成功后调用方按返回码继续；失败由主程序决定回滚、记录结果或停止。辅助成功不等于事务提交。

## Functions

- 原始输入规范化以及客户、商品、数量资格校验。
- 输出有身份和原因的结果，保持职责范围与静态追踪关系。

## Business Rules

继承 FS 编号，不在各程序重新从 01 编号。主责与协作分开；下面的恢复／记录引用不把所有规则所有权转移到本程序。

| BR | 需求规则 | 本程序角色 |
| --- | --- | --- |
| BR-01 | 所有业务请求必须具有来源、请求标识、业务类型和处理日；缺少任何一项均拒绝受理。 | 协作／处理边界；主责 ORDMAIN |
| BR-02 | 新订单和订单修改只允许使用存在且启用的客户。 | 主责 |
| BR-03 | 新订单和订单修改的所有明细必须引用存在、启用且有正数有效单价的商品。 | 主责 |
| BR-04 | 每条订单明细数量必须为 1～9,999 的整数。 | 主责 |
| BR-05 | 一张订单必须包含 1～100 条明细；明细序号在订单内唯一。 | 主责 |
| BR-06 | 同一来源和请求标识、相同业务内容的重复请求必须返回最近已知结果，不重复占用、发货或结算；“重新尝试失败业务”需要独立的恢复动作。 | 协作／处理边界；主责 ORDMAIN |
| BR-07 | 同一来源和请求标识携带不同业务内容时，拒绝为冲突请求，保留第一次请求及其结果。 | 协作／处理边界；主责 ORDMAIN |
| BR-17 | 每次发货数量必须为正整数且不超过该订单明细在指定仓库的尚未发货占用；一次确认涉及多条明细时，全部满足条件才接受该次确认。 | 协作／处理边界；主责 ORDMAIN |
| BR-18 | 取消数量必须为正整数且不得超过未发货、未取消数量；先取消未分配部分，不足部分按 C、B、A 的次序释放占用。 | 协作／处理边界；主责 ORDMAIN |
| BR-20 | 退货只能引用已成功结算的原发货明细；每次退货数量须为正整数，累计退货数量不得超过该明细已发货数量，退货处理日与发货业务日相差须为 0～30 个自然日（含边界）。 | 协作／处理边界；主责 ORDMAIN |
| BR-29 | 业务处理日由输入明确指定；演示运营日以 18:00 为接单截点，18:00 及之后到达的请求归下一处理日。涉及重复识别时，重送保留原请求处理日，不重分日期。 | 协作／处理边界；主责 ORDMAIN |
| BR-32 | 请求、订单、明细、发货、退货、结算、调整、回执和处理批次均能沿关联标识追溯；拒绝、等待和重试也须保留可解释的业务结果。 | 协作／处理边界；主责 ORDMAIN |

## Interface Contract

参数按位置引用传递，完整布局只在共享契约定义；本表长度为字节。IO 表示依动作输入或输出，输入用途与目标状态不能通过残留值猜测。

### Program Parameters

| 位置 | Name | Type | Length | I/O | Valid Values / Description |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | CANON 或 VALIDATE |
| 2 | HDRDS | DS | 490 | I | 原输入头 |
| 3 | RAWROWS | DS | 8300 | I | 原输入 100 行容量 |
| 4 | CHKHEAD | DS | 24014 | O | 规范内容／头 |
| 5 | NORMROWS | DS | 4400 | O | 规范业务行 |
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
| CUID | CUSTPF | Persisted | Step 5 | — | CUSTPF-20260905-01:FLD-01 | 客户身份 |
| CUACTIVE | CUSTPF | Persisted | Step 5 | — | CUSTPF-20260905-01:FLD-02 | Y/N |
| CUTIER | CUSTPF | Persisted | Step 5 | — | CUSTPF-20260905-01:FLD-03 | S 普通 / P 优选 |
| ITID | ITEMPF | Persisted | Step 6 | — | ITEMPF-20260905-01:FLD-01 | 商品身份 |
| ITACTIVE | ITEMPF | Persisted | Step 6 | — | ITEMPF-20260905-01:FLD-02 | Y/N |

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
| HDRDS.IHBATCH | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-01 | 原始批次 |
| HDRDS.IHSEQ | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-02 | 原始输入序号，1 起且批次内唯一 |
| HDRDS.IHSRC | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-03 | 业务来源，允许原始空值进入拒绝路径 |
| HDRDS.IHREQ | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-04 | 请求标识 |
| HDRDS.IHEVENT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-05 | 事件编码 |
| HDRDS.IHDAY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-06 | 原请求业务日 |
| HDRDS.IHARRDAY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-07 | 到达日期，传输包装 |
| HDRDS.IHARRTIME | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-08 | 到达时刻，传输包装 |
| HDRDS.IHORDER | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-09 | 订单身份 |
| HDRDS.IHVERSION | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-10 | 期望订单版本原文 |
| HDRDS.IHCUST | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-11 | 客户 |
| HDRDS.IHPART | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-12 | 部分履约 Y/N |
| HDRDS.IHSHIP | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-13 | 本次发货身份 |
| HDRDS.IHRETURN | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-14 | 本次退货身份 |
| HDRDS.IHSETTL | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-15 | 被反馈或恢复的结算身份 |
| HDRDS.IHMSG | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-16 | 关联出站消息身份 |
| HDRDS.IHRESULT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-17 | 反馈结果 |
| HDRDS.IHACTION | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-18 | 恢复类别 |
| HDRDS.IHREFSRC | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-19 | 被恢复请求来源 |
| HDRDS.IHREFREQ | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-20 | 被恢复请求标识 |
| HDRDS.IHACTOR | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-21 | 操作者 |
| HDRDS.IHREASON | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-22 | 处置原因或反馈说明 |
| HDRDS.IHNLINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INHDRPF-20260905-01:FLD-23 | 业务明细条数原文 |
| RAWROWS[].IDBATCH | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INDTLPF-20260905-01:FLD-01 | 原始批次 |
| RAWROWS[].IDINPUT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INDTLPF-20260905-01:FLD-02 | 输入序号 |
| RAWROWS[].IDPOS | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INDTLPF-20260905-01:FLD-03 | 传输行位置，1 起 |
| RAWROWS[].IDLINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INDTLPF-20260905-01:FLD-04 | 订单明细号或事件行号原文 |
| RAWROWS[].IDITEM | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INDTLPF-20260905-01:FLD-05 | 商品 |
| RAWROWS[].IDQTY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INDTLPF-20260905-01:FLD-06 | 数量原文 |
| RAWROWS[].IDWH | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INDTLPF-20260905-01:FLD-07 | 仓库 A/B/C |
| RAWROWS[].IDSHIP | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INDTLPF-20260905-01:FLD-08 | 退货所引用的原发货身份 |
| RAWROWS[].IDSHLINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | INDTLPF-20260905-01:FLD-09 | 原发货明细号原文 |
| CHKHEAD.CHVERSION | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 CHKHEAD | 解析后的版本 |
| CHKHEAD.CHTIER | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 CHKHEAD | 客户等级 |
| CHKHEAD.CHCOUNT | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 CHKHEAD | 规范明细数 |
| CHKHEAD.CHLEN | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 CHKHEAD | 规范内容实际长度 |
| CHKHEAD.CHCANON | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 CHKHEAD | 规范内容 |
| NORMROWS[].NRLINE | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 NORMROWS | 业务行号 |
| NORMROWS[].NRITEM | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 NORMROWS | 商品 |
| NORMROWS[].NRQTY | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 NORMROWS | 整数数量 |
| NORMROWS[].NRWH | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 NORMROWS | 仓库 |
| NORMROWS[].NRSHIP | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 NORMROWS | 原发货 |
| NORMROWS[].NRSHLINE | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 NORMROWS | 原发货行 |
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
| CUSTPF | I | CUID | 1:1 | [CUSTPF-20260905-01](../files/CUSTPF.md) | 合成客户资料 |
| ITEMPF | I | ITID | 1:1 | [ITEMPF-20260905-01](../files/ITEMPF.md) | 合成商品资料 |

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
| CINIT | Step 1 | 初始化 CHKHEAD/NORMROWS/RESDS；确认 CXABI=0001、CXCOUNT 在 0–100 且动作 CANON/VALIDATE |
| CCANON | Step 2 | 按共享契约生成规范头及完整行序列：仅剔除传输包装，数字规范化，保留无效原文，原处理日和恢复关联均纳入；长度前缀避免不同字段组合串接冲突 |
| CMODE | Step 3 | IF CANON → 返回 CHLEN/CHCANON，业务资格尚未检查；主程序用其比较账本 |
| CROWS | Step 4 | FOR EACH 原始行构造规范 NORMROWS |
| CCUST | Step 5 | NEW/MOD 按 CUID 完整键读取 CUSTPF |
| CITEM | Step 6 | FOR EACH NEW/MOD 规范行按 ITID 读取 ITEMPF |
| CRET | Step 7 | 全部适用校验成功返回 0000；读文件失败返回 9000，语义无效返回 1000，资料内部矛盾返回 2000 |

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
| CANON | Step 1–3，返回；不读当前资格资料 |
| VALIDATE | Step 1–4；NEW/MOD 再执行 Step 5–6；Step 7 返回 |

Step 1: **CINIT** — 初始化 CHKHEAD/NORMROWS/RESDS；确认 CXABI=0001、CXCOUNT 在 0–100 且动作 CANON/VALIDATE。IF 载体超限 → 1000，保留原输入，不访问资料。 (BR-01, BR-04, BR-05, BR-32)

Step 2: **CCANON** — 按共享契约生成规范头及完整行序列：仅剔除传输包装，数字规范化，保留无效原文，原处理日和恢复关联均纳入；长度前缀避免不同字段组合串接冲突。IF 长度超过 24000 → 1000，不裁剪。 (BR-06, BR-07)

Step 3: **CMODE** — IF CANON → 返回 CHLEN/CHCANON，业务资格尚未检查；主程序用其比较账本。VALIDATE 继续结构、日期和事件字段校验。 (BR-01, BR-06, BR-07, BR-29)

Step 4: **CROWS** — FOR EACH 原始行构造规范 NORMROWS。NEW/MOD 必须 1–100 行、业务行号为正且唯一、数量严格整数 1–9999；SHIP/CANCEL/RETURN 数量为正整数且事件组合不重复。IF 失败 → 1000 并返回问题行，输出候选无效。 (BR-04, BR-05, BR-17, BR-18, BR-20)

Step 5: **CCUST** — NEW/MOD 按 CUID 完整键读取 CUSTPF。IF 缺失或 CUACTIVE≠Y → 1000；IF CUTIER 非 S/P → 2000；只输出等级，不更新客户。 (BR-02)

Step 6: **CITEM** — FOR EACH NEW/MOD 规范行按 ITID 读取 ITEMPF。IF 缺失或 ITACTIVE≠Y → 1000。价格资格由 ORDMAIN 后续调用 ORDPRICE 完成，本程序不跨职责读取 PRICEPF 或调用金额程序。 (BR-03)

Step 7: **CRET** — 全部适用校验成功返回 0000；读文件失败返回 9000，语义无效返回 1000，资料内部矛盾返回 2000。错误只经 RESDS 交主程序统一审计，本程序没有业务写入。 (BR-01, BR-02, BR-03, BR-04, BR-05, BR-32)

### File Output / Update

N/A：不写业务文件。

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
| BR-01 | Step 1, Step 3, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-02 | Step 5, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | CUSTPF |
| BR-03 | Step 6, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | ITEMPF |
| BR-04 | Step 1, Step 4, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-05 | Step 1, Step 4, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-06 | Step 2, Step 3 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-07 | Step 2, Step 3 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-17 | Step 4 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-18 | Step 4 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-20 | Step 4 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-29 | Step 3 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-32 | Step 1, Step 7 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |

## Processing Considerations

单作业串行处理；显式日期，不依赖运行机器的当前日期。多记录范围及历史集合读完整，固定数组只限制单次事件候选。ORDMAIN 是正常提交／回滚所有者；辅助程序不得提交，失败由调用方整体撤销。不设置吞吐量或运行成功承诺。

## Compile-Oriented Constraints

| File | Record Format | RENAME | KLIST / KFLD 顺序 | Confidence |
| --- | --- | --- | --- | --- |
| CUSTPF | CUSTR | N/A | KCUST = CUID | Assumed：授权合成，未编译 |
| ITEMPF | ITEMR | N/A | KITEM = ITID | Assumed：授权合成，未编译 |

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
| L3 Full | 12 | 7 | 2 | 0 | 0 |

Traceability Complete：规格内 BR 到步骤和文件／委派入口已建立。状态 Draft；所有规则是继承规则，没有新增需求级 BR。
