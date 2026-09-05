# ORDPRICE 程序规格

## Spec Header

- **Spec ID**：ORDPRICE-20260905-01
- **Spec Level**：L3 Full
- **Version / Status**：1.0 / Draft
- **Change Type / Program Type**：New Program / RPGLE
- **Program Name**：ORDPRICE
- **Description**：有效价格读取、客户折扣及累计数量比例分摊。
- **Source TD**：[TD-20260905-01](../../design/technical-design.md) Module Allocation 行 `ORDPRICE`。
- **共同输入**：[功能需求](../../requirements/functional-requirements.md)、[共享契约](../shared-contract.md)。全部字段及步骤为授权合成定义，不是对既有系统的发现。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次完整规格。

## Caller Context

仅由 ORDMAIN 同步调用；按 CTXDS.CXACTION 选择适用动作。成功后调用方按返回码继续；失败由主程序决定回滚、记录结果或停止。辅助成功不等于事务提交。

## Functions

- 有效价格读取、客户折扣及累计数量比例分摊。
- 输出有身份和原因的结果，保持职责范围与静态追踪关系。

## Business Rules

继承 FS 编号，不在各程序重新从 01 编号。主责与协作分开；下面的恢复／记录引用不把所有规则所有权转移到本程序。

| BR | 需求规则 | 本程序角色 |
| --- | --- | --- |
| BR-03 | 新订单和订单修改的所有明细必须引用存在、启用且有正数有效单价的商品。 | 协作／处理边界；主责 ORDCHECK |
| BR-11 | 客户分普通和优选两级：普通按有效单价计价，优选享 5% 折扣；不叠加其他折扣、税费或运费。修改使用修改受理时的有效价格和客户等级。 | 主责 |
| BR-12 | 每行金额按数量、单价及客户折扣计算，四舍五入保留两位小数；整单金额等于已舍入的各行金额之和。首次发货后保留原计价依据，不能因价格资料变化重算已受理订单。 | 主责 |
| BR-20 | 退货只能引用已成功结算的原发货明细；每次退货数量须为正整数，累计退货数量不得超过该明细已发货数量，退货处理日与发货业务日相差须为 0～30 个自然日（含边界）。 | 协作／处理边界；主责 ORDMAIN |
| BR-22 | 退货调整沿用原发货结算金额。按累计退货数量比例计算累计应调整额，再扣除此前已成功调整额；全部退回时累计调整必须等于原发货结算金额。同一原发货明细仍有未完成调整时，后续退货暂不受理且不增加归还数量；原调整沿既有身份恢复，不重复创建。 | 协作／处理边界；主责 ORDMAIN |
| BR-23 | 结算只针对已确认发货，且每次发货只形成一项正向结算。分次发货按原订单行金额的累计发货比例分摊到两位小数，本次金额为累计应结算额减此前已分配给发货的金额，全部发完时正好等于原行金额。 | 协作／处理边界；主责 ORDMAIN |
| BR-32 | 请求、订单、明细、发货、退货、结算、调整、回执和处理批次均能沿关联标识追溯；拒绝、等待和重试也须保留可解释的业务结果。 | 协作／处理边界；主责 ORDMAIN |

## Interface Contract

参数按位置引用传递，完整布局只在共享契约定义；本表长度为字节。IO 表示依动作输入或输出，输入用途与目标状态不能通过残留值猜测。

### Program Parameters

| 位置 | Name | Type | Length | I/O | Valid Values / Description |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | QUOTE / SHIP / RETURN |
| 2 | PRIN | DS | 9400 | I | 最多 100 项金额依据 |
| 3 | PROUT | DS | 3300 | O | 对应金额候选 |
| 4 | RESDS | DS | 153 | O | 结果 |

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
| PRITEM | PRICEPF | Persisted | Step 2 | — | PRICEPF-20260905-01:FLD-01 | 商品 |
| PRFROM | PRICEPF | Persisted | Step 2 | — | PRICEPF-20260905-01:FLD-02 | 有效起日，含当日 |
| PRTHRU | PRICEPF | Persisted | Step 2 | — | PRICEPF-20260905-01:FLD-03 | 有效止日，含当日；99991231 表示持续有效 |
| PRUNIT | PRICEPF | Persisted | Step 2 | — | PRICEPF-20260905-01:FLD-04 | 有效单价，必须大于 0 |

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
| PRIN[].PIGROUP | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 PRIN | 金额累计组：订单行或原发货行 |
| PRIN[].PILINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 PRIN | 本次顺序 |
| PRIN[].PIITEM | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 PRIN | 商品 |
| PRIN[].PIQTY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 PRIN | 订单报价量或本次流转量 |
| PRIN[].PIBASEQTY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 PRIN | 比例分母：原订单量或原发货量 |
| PRIN[].PIPRIORQ | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 PRIN | 本次前累计发货／退货数量 |
| PRIN[].PIBASEAMT | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 PRIN | 原行／原发货金额 |
| PRIN[].PIPRIORA | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 PRIN | 此前已分配发货额／已成功调整额 |
| PROUT[].POLINE | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 PROUT | 本次行顺序 |
| PROUT[].POUNIT | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 PROUT | 报价单价；比例模式回传 0 |
| PROUT[].PORATE | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 PROUT | 报价系数；比例模式回传 0 |
| PROUT[].POAMOUNT | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 PROUT | 当前行金额或本次分摊额 |
| PROUT[].POCUMQTY | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 PROUT | 更新后累计数量 |
| PROUT[].POCUMAMT | Parameter / ORDRES | Transient | — | Step 1 初始化；适用动作输出 | 共享契约 PROUT | 更新后累计金额 |
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
| PRICEPF | I | PRITEM + PRFROM | 1:1 + 1:N | [PRICEPF-20260905-01](../files/PRICEPF.md) | 按商品与日期选取有效价格 |

I=只读；U=可写，是否允许新增见 File Output。1:N 使用键前缀与完整范围循环，不可用一次 CHAIN 代替。

## Data Queue

N/A。

## Data Area

N/A。

## External Data Structure

外部描述文件的记录格式见 File Usage 和 Compile-Oriented Constraints；读取后按需要复制进独立参数／候选结构。共享 COPY 是源定义，不是新外部对象。

## Internal Data Structure

ORDCTX / ORDRES / ORDSTS 的布局与常量均引用共享契约。

累计工作区每组保存 PRIN 中的 GROUP/BASEQTY/BASEAMT、推进后的累计量和累计金额；中间乘除 P(31,12)。分组上限等于输入最多 100 组。

## External Program Calls

N/A：无应用程序互调；文件 I/O 不算外部 CALL。

## External Subroutines

N/A：不依赖未列出的外部例程。

## Standard Subroutines

| 例程名 | 逻辑位置 | 职责 |
| --- | --- | --- |
| PINIT | Step 1 | 清空 PROUT/RESDS，确认模式 QUOTE/SHIP/RETURN、行数≤100、金额与数量输入可表示 |
| PLOOK | Step 2 | QUOTE：FOR EACH PRIN 商品，用 PRITEM 键前缀读完 PRICEPF 有效期候选，判断 PRFROM≤CXDAY≤PRTHRU；必须恰好一个匹配且 PRUNIT>0 |
| PQUOTE | Step 3 | QUOTE：CXTIER=S 用 1.0000，P 用 0.9500；宽临时值=数量×单价×系数，half-up 两位得每行金额，整单合计求已舍入行之和 |
| PGROUP | Step 4 | SHIP/RETURN：按 PIGROUP 稳定顺序处理，同组首行加载 BASEQTY/BASEAMT/PRIORQ/PRIORA，后续行必须同基数并沿前行累计推进；BASEQTY>0，PRIORQ≥0，新增量>0，新累计不能超过分母 |
| PSPLIT | Step 5 | FOR EACH 比例行计算新累计金额=round(BASEAMT×新累计量/BASEQTY,2)，当前额=新累计额−前累计额；全部数量完成时直接取 BASEAMT 作为累计额 |
| PSUM | Step 6 | 写对应 PROUT 行、合计 RSAMOUNT 和 RSCOUNT；任何一行失败令全组候选无效 |

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
| QUOTE | Step 1–3、6 |
| SHIP / RETURN | Step 1、4–6 |

Step 1: **PINIT** — 清空 PROUT/RESDS，确认模式 QUOTE/SHIP/RETURN、行数≤100、金额与数量输入可表示。IF 不满足 → 1000／2000，无金额输出有效。 (BR-03, BR-11, BR-12, BR-22, BR-23, BR-32)

Step 2: **PLOOK** — QUOTE：FOR EACH PRIN 商品，用 PRITEM 键前缀读完 PRICEPF 有效期候选，判断 PRFROM≤CXDAY≤PRTHRU；必须恰好一个匹配且 PRUNIT>0。IF 零个 → 1000；IF 重叠、无效日期或非正价 → 2000，不取第一条冒充有效价。 (BR-03, BR-11)

Step 3: **PQUOTE** — QUOTE：CXTIER=S 用 1.0000，P 用 0.9500；宽临时值=数量×单价×系数，half-up 两位得每行金额，整单合计求已舍入行之和。IF 中间值或 P(15,2) 结果越界 → 2000，全部报价候选无效。 (BR-11, BR-12)

Step 4: **PGROUP** — SHIP/RETURN：按 PIGROUP 稳定顺序处理，同组首行加载 BASEQTY/BASEAMT/PRIORQ/PRIORA，后续行必须同基数并沿前行累计推进；BASEQTY>0，PRIORQ≥0，新增量>0，新累计不能超过分母。不同组不能共享舍入余量。 (BR-20, BR-22, BR-23)

Step 5: **PSPLIT** — FOR EACH 比例行计算新累计金额=round(BASEAMT×新累计量/BASEQTY,2)，当前额=新累计额−前累计额；全部数量完成时直接取 BASEAMT 作为累计额。IF 当前额<0 或越界 → 2000；允许因舍入产生 0 金额。RETURN 的 PRIORA 来自成功调整，SHIP 来自已分配发货额，不以外部成功状态过滤发货分母。 (BR-12, BR-22, BR-23)

Step 6: **PSUM** — 写对应 PROUT 行、合计 RSAMOUNT 和 RSCOUNT；任何一行失败令全组候选无效。正常 0000 返回，数据库异常 9000；不提交、不改冻结历史或业务文件。 (BR-12, BR-22, BR-23, BR-32)

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
| BR-03 | Step 1, Step 2 | E01 / E02 / E03 / E04（按具体失败类别） | PRICEPF |
| BR-11 | Step 1, Step 2, Step 3 | E01 / E02 / E03 / E04（按具体失败类别） | PRICEPF |
| BR-12 | Step 1, Step 3, Step 5, Step 6 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-20 | Step 4 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-22 | Step 1, Step 4, Step 5, Step 6 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-23 | Step 1, Step 4, Step 5, Step 6 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-32 | Step 1, Step 6 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |

## Processing Considerations

单作业串行处理；显式日期，不依赖运行机器的当前日期。多记录范围及历史集合读完整，固定数组只限制单次事件候选。ORDMAIN 是正常提交／回滚所有者；辅助程序不得提交，失败由调用方整体撤销。不设置吞吐量或运行成功承诺。

## Compile-Oriented Constraints

| File | Record Format | RENAME | KLIST / KFLD 顺序 | Confidence |
| --- | --- | --- | --- | --- |
| PRICEPF | PRICER | N/A | KPRICE = PRITEM + PRFROM | Assumed：授权合成，未编译 |

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
| L3 Full | 7 | 6 | 1 | 0 | 0 |

Traceability Complete：规格内 BR 到步骤和文件／委派入口已建立。状态 Draft；所有规则是继承规则，没有新增需求级 BR。
