# ORDSTOCK 程序规格

## Spec Header

- **Spec ID**：ORDSTOCK-20260905-01
- **Spec Level**：L3 Full
- **Version / Status**：1.0 / Draft
- **Change Type / Program Type**：New Program / RPGLE
- **Program Name**：ORDSTOCK
- **Description**：库存／占用候选规划及本地事务内应用。
- **Source TD**：[TD-20260905-01](../../design/technical-design.md) Module Allocation 行 `ORDSTOCK`。
- **共同输入**：[功能需求](../../requirements/functional-requirements.md)、[共享契约](../shared-contract.md)。全部字段及步骤为授权合成定义，不是对既有系统的发现。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次完整规格。

## Caller Context

仅由 ORDMAIN 同步调用；按 CTXDS.CXACTION 选择适用动作。成功后调用方按返回码继续；失败由主程序决定回滚、记录结果或停止。辅助成功不等于事务提交。

## Functions

- 库存／占用候选规划及本地事务内应用。
- 输出有身份和原因的结果，保持职责范围与静态追踪关系。

## Business Rules

继承 FS 编号，不在各程序重新从 01 编号。主责与协作分开；下面的恢复／记录引用不把所有规则所有权转移到本程序。

| BR | 需求规则 | 本程序角色 |
| --- | --- | --- |
| BR-10 | 订单只有在尚无发货记录、且没有全部取消时才可修改；修改需要重新校验、计价及安排分配，修改未被接受时保持原订单与原占用。 | 协作／处理边界；主责 ORDMAIN |
| BR-13 | 仅从启用仓库分配，固定优先次序为演示仓库 A、B、C；同一订单按明细序号分配。 | 主责 |
| BR-14 | 可分配数量为现有库存扣除已占用数量，分配不得使可用数量为负；发货同时减少现有库存及对应占用。 | 主责 |
| BR-15 | 不允许部分履约的订单，仅在整单剩余数量均可满足时分配，否则整单剩余数量等待且不新增占用；允许部分履约时可先分配可用数量，其余等待。 | 协作／处理边界；主责 ORDMAIN |
| BR-16 | 后续补分配只处理尚未分配、发货或取消的有效需求；新到库存不会触发重复占用已有分配。 | 协作／处理边界；主责 ORDMAIN |
| BR-17 | 每次发货数量必须为正整数且不超过该订单明细在指定仓库的尚未发货占用；一次确认涉及多条明细时，全部满足条件才接受该次确认。 | 协作／处理边界；主责 ORDMAIN |
| BR-18 | 取消数量必须为正整数且不得超过未发货、未取消数量；先取消未分配部分，不足部分按 C、B、A 的次序释放占用。 | 协作／处理边界；主责 ORDMAIN |
| BR-19 | 已发货数量不得通过取消回退；全部剩余数量取消后不再接受该订单的新分配和修改，已有发货仍允许完成结算及符合条件的退货。 | 协作／处理边界；主责 ORDMAIN |
| BR-21 | 接受退货后将数量归还到原发货仓库，但不重新增加原订单待分配需求；即使该仓库已停用，归还数量也只记为该仓库库存，不供新订单分配。 | 协作／处理边界；主责 ORDMAIN |
| BR-32 | 请求、订单、明细、发货、退货、结算、调整、回执和处理批次均能沿关联标识追溯；拒绝、等待和重试也须保留可解释的业务结果。 | 协作／处理边界；主责 ORDMAIN |

## Interface Contract

参数按位置引用传递，完整布局只在共享契约定义；本表长度为字节。IO 表示依动作输入或输出，输入用途与目标状态不能通过残留值猜测。

### Program Parameters

| 位置 | Name | Type | Length | I/O | Valid Values / Description |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | NEW / MOD / ALLOC / SHIP / CANCEL / RETURN / VIEW / APPLY |
| 2 | STKIN | DS | 2600 | I | 最多 100 项业务需求 |
| 3 | STKOLD | DS | 23700 | IO | 原版本释放方案；APPLY 只读 |
| 4 | STKNEW | DS | 23700 | IO | 本次方案；APPLY 只读 |
| 5 | RESDS | DS | 153 | O | 结果 |

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
| ALORDER | ALLOCPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 8, Step 9 | Step 10 | ALLOCPF-20260905-01:FLD-01 | 订单 |
| ALLINE | ALLOCPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 8, Step 9 | Step 10 | ALLOCPF-20260905-01:FLD-02 | 明细 |
| ALWH | ALLOCPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 8, Step 9 | Step 10 | ALLOCPF-20260905-01:FLD-03 | 仓库 |
| ALITEM | ALLOCPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 8, Step 9 | Step 10 | ALLOCPF-20260905-01:FLD-04 | 本版本商品 |
| ALRESVD | ALLOCPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 8, Step 9 | Step 10 | ALLOCPF-20260905-01:FLD-05 | 尚未发货的占用 |
| ALSHIPPED | ALLOCPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 8, Step 9 | Step 10 | ALLOCPF-20260905-01:FLD-06 | 该分配已用于发货累计 |
| ALRELEASE | ALLOCPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 8, Step 9 | Step 10 | ALLOCPF-20260905-01:FLD-07 | 该分配取消释放累计 |
| STITEM | STOCKPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 7, Step 8, Step 9 | — | STOCKPF-20260905-01:FLD-01 | 商品 |
| STWH | STOCKPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 7, Step 8, Step 9 | — | STOCKPF-20260905-01:FLD-02 | 仓库 |
| STONHAND | STOCKPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 7, Step 8, Step 9 | Step 10 | STOCKPF-20260905-01:FLD-03 | 现有库存 |
| STRESVD | STOCKPF | Persisted | Step 2, Step 3, Step 4, Step 5, Step 6, Step 7, Step 8, Step 9 | Step 10 | STOCKPF-20260905-01:FLD-04 | 被全部订单占用总量 |
| WHID | WHSEPF | Persisted | Step 2, Step 4, Step 7 | — | WHSEPF-20260905-01:FLD-01 | 演示仓库 A/B/C |
| WHACTIVE | WHSEPF | Persisted | Step 2, Step 4, Step 7 | — | WHSEPF-20260905-01:FLD-02 | Y/N |
| WHRANK | WHSEPF | Persisted | Step 2, Step 4, Step 7 | — | WHSEPF-20260905-01:FLD-03 | A=1、B=2、C=3 |

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
| STKIN[].SILINE | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 STKIN | 原订单明细号 |
| STKIN[].SIITEM | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 STKIN | 商品 |
| STKIN[].SIWH | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 STKIN | SHIP / RETURN 指定仓库，其他动作空格 |
| STKIN[].SIQTY | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 STKIN | 当前目标待满足量或本次动作量 |
| STKIN[].SIREMAIN | Parameter / ORDCTX | Transient | Step 1 接收；适用动作见下文 | — | 共享契约 STKIN | 取消前有效剩余量；非取消动作设 0 |
| STKOLD[].SPLINE | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 订单行 |
| STKOLD[].SPITEM | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 库存商品 |
| STKOLD[].SPWH | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 仓库 |
| STKOLD[].SPONHAND | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 计划前库存 |
| STKOLD[].SPRESVD | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 计划前总占用 |
| STKOLD[].SPONDELTA | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 本行实物变化，可为负 |
| STKOLD[].SPRSDELTA | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 本行总占用变化，可为负 |
| STKOLD[].SPOLDITEM | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 原分配商品或空格 |
| STKOLD[].SPOLDRES | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 原行占用 |
| STKOLD[].SPOLDSHIP | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 原行已发货 |
| STKOLD[].SPOLDREL | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 原行已释放 |
| STKOLD[].SPNEWRES | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 新行占用 |
| STKOLD[].SPNEWSHIP | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 新行已发货 |
| STKOLD[].SPNEWREL | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | 新行已释放 |
| STKOLD[].SPUSE | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKOLD | Y/N，有效项 |
| STKNEW[].SPLINE | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 订单行 |
| STKNEW[].SPITEM | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 库存商品 |
| STKNEW[].SPWH | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 仓库 |
| STKNEW[].SPONHAND | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 计划前库存 |
| STKNEW[].SPRESVD | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 计划前总占用 |
| STKNEW[].SPONDELTA | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 本行实物变化，可为负 |
| STKNEW[].SPRSDELTA | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 本行总占用变化，可为负 |
| STKNEW[].SPOLDITEM | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 原分配商品或空格 |
| STKNEW[].SPOLDRES | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 原行占用 |
| STKNEW[].SPOLDSHIP | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 原行已发货 |
| STKNEW[].SPOLDREL | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 原行已释放 |
| STKNEW[].SPNEWRES | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 新行占用 |
| STKNEW[].SPNEWSHIP | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 新行已发货 |
| STKNEW[].SPNEWREL | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | 新行已释放 |
| STKNEW[].SPUSE | Parameter / ORDRES | Transient | Step 1 接收；适用动作见下文 | Step 1 初始化；适用动作输出 | 共享契约 STKNEW | Y/N，有效项 |
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
| ALLOCPF | U | ALORDER + ALLINE + ALWH | 1:1 + 1:N | [ALLOCPF-20260905-01](../files/ALLOCPF.md) | 订单行到仓库的占用关联 |
| STOCKPF | U | STITEM + STWH | 1:1 + 1:N | [STOCKPF-20260905-01](../files/STOCKPF.md) | 商品仓库实物及占用总量 |
| WHSEPF | I | WHID | 1:1 | [WHSEPF-20260905-01](../files/WHSEPF.md) | 仓库资格和固定优先顺序 |

I=只读；U=可写，是否允许新增见 File Output。1:N 使用键前缀与完整范围循环，不可用一次 CHAIN 代替。

## Data Queue

N/A。

## Data Area

N/A。

## External Data Structure

外部描述文件的记录格式见 File Usage 和 Compile-Oriented Constraints；读取后按需要复制进独立参数／候选结构。共享 COPY 是源定义，不是新外部对象。

## Internal Data Structure

ORDCTX / ORDRES / ORDSTS 的布局与常量均引用共享契约。

虚拟库存池以商品+仓库分组，最多 600 个当前计划键；每项继承 SPITEM/SPWH/SPONHAND/SPRESVD 及聚合 delta。旧、新各 300 计划行分开，最终写入对同库存键合并；不能重复检查同键时把前一项自身写入误判为外部变化。

## External Program Calls

N/A：无应用程序互调；文件 I/O 不算外部 CALL。

## External Subroutines

N/A：不依赖未列出的外部例程。

## Standard Subroutines

| 例程名 | 逻辑位置 | 职责 |
| --- | --- | --- |
| SINIT | Step 1 | 初始化本次结果；规划动作清空 STKOLD/STKNEW，APPLY 必须保留主程序传回的方案 |
| SLOAD | Step 2 | FOR EACH ALLOCPF 按订单键前缀读取现有分配，WHSEPF 按仓库键读取，STOCKPF 按商品+仓库完整键读取；同商品多订单行共享一个虚拟库存池 |
| SMOD | Step 3 | MOD：将原当前分配的尚未发货占用写入 STKOLD 释放候选，在虚拟池增加可用量；只有未发货版本允许此动作 |
| SALLOC | Step 4 | NEW/MOD/ALLOC：按订单行升序、仓库 A/B/C，只在启用仓中分配 |
| SCANCEL | Step 5 | CANCEL：每行未分配量=目标原有效剩余量−当前占用总量；先消耗未分配量，仍需释放的量按 C/B/A 从 ALRESVD 扣除，累加 ALRELEASE |
| SSHIP | Step 6 | SHIP：按订单行+仓库汇总本次发货量，验证每个分配足额；候选同时减少 STONHAND/STRESVD/ALRESVD、增加 ALSHIPPED |
| SRETURN | Step 7 | RETURN：根据传入已核验原发货商品仓库增加 STONHAND；不增加 ALRESVD/STRESVD、不重开需求，WHACTIVE=N 仍允许归还 |
| SVIEW | Step 8 | VIEW：只返回指定订单当前分配、商品仓库数量快照；不生成待应用增减、不改变任何数据，供主程序组装 QUERY |
| SAPCHECK | Step 9 | APPLY：重读全部计划相关 STOCKPF/ALLOCPF，逐项核对计划前快照与当前值，合并同商品仓库的所有旧／新增 delta；IF 任一不同或最终数量非法 → 2000 且不写 |
| SAPWRITE | Step 10 | 验证完成后每个库存键只 UPDATE 一次；每个最终分配键 WRITE/UPDATE 一次，RETURN 只写库存 |
| SRET | Step 11 | 返回 0000 或已规划等待 0010，并给有效候选行标志和缺口；所有计划只在当前调用事件中有效，回滚后必须丢弃重建 |

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
| NEW / ALLOC | Step 1–2、4、11；只规划 |
| MOD | Step 1–4、11；只规划 |
| CANCEL / SHIP / RETURN | Step 1–2，再分别 Step 5 / 6 / 7，Step 11 返回；只规划 |
| VIEW | Step 1–2、8、11；只读 |
| APPLY | Step 1、9–11；保留传入方案，CXEVENT 区分原动作 |

Step 1: **SINIT** — 初始化本次结果；规划动作清空 STKOLD/STKNEW，APPLY 必须保留主程序传回的方案。校验动作、行数、字段类型和数量。IF ABI 不支持或方案不完整 → 9000／2000。 (BR-14, BR-17, BR-32)

Step 2: **SLOAD** — FOR EACH ALLOCPF 按订单键前缀读取现有分配，WHSEPF 按仓库键读取，STOCKPF 按商品+仓库完整键读取；同商品多订单行共享一个虚拟库存池。IF 缺库存记录、现有量<占用或关系商品不一致 → 2000，不补造。 (BR-13, BR-14, BR-16)

Step 3: **SMOD** — MOD：将原当前分配的尚未发货占用写入 STKOLD 释放候选，在虚拟池增加可用量；只有未发货版本允许此动作。旧分配的商品、数量及统计保留计划前快照；不在规划阶段写库。 (BR-10, BR-14)

Step 4: **SALLOC** — NEW/MOD/ALLOC：按订单行升序、仓库 A/B/C，只在启用仓中分配。目标未占用量=传入有效剩余量−现有有效占用；MOD 使用释放后的新版本零占用。IF 不允许部分且全部行合计不能满足 → 清除本次新占用方案，返回 0010；允许部分则保留可得部分及缺口。 (BR-13, BR-14, BR-15, BR-16)

Step 5: **SCANCEL** — CANCEL：每行未分配量=目标原有效剩余量−当前占用总量；先消耗未分配量，仍需释放的量按 C/B/A 从 ALRESVD 扣除，累加 ALRELEASE。库存现有量不变，总占用减少。IF 取消量或关系不一致 → 整体 1000／2000。STKIN 的 QTY 为本次取消量，原有效剩余量由调用者通过 SIREMAIN 传入。 (BR-18, BR-19)

Step 6: **SSHIP** — SHIP：按订单行+仓库汇总本次发货量，验证每个分配足额；候选同时减少 STONHAND/STRESVD/ALRESVD、增加 ALSHIPPED。IF 任一行不满足或出现负量 → 全部拒绝。仓库当前停用不禁止履行已有占用。 (BR-14, BR-17)

Step 7: **SRETURN** — RETURN：根据传入已核验原发货商品仓库增加 STONHAND；不增加 ALRESVD/STRESVD、不重开需求，WHACTIVE=N 仍允许归还。不存在原库存记录属于资料异常。 (BR-21)

Step 8: **SVIEW** — VIEW：只返回指定订单当前分配、商品仓库数量快照；不生成待应用增减、不改变任何数据，供主程序组装 QUERY。 (BR-32)

Step 9: **SAPCHECK** — APPLY：重读全部计划相关 STOCKPF/ALLOCPF，逐项核对计划前快照与当前值，合并同商品仓库的所有旧／新增 delta；IF 任一不同或最终数量非法 → 2000 且不写。原版本清理与新版本同键变更先合并成最终分配行，不能连写两次覆盖累计。 (BR-10, BR-14, BR-17)

Step 10: **SAPWRITE** — 验证完成后每个库存键只 UPDATE 一次；每个最终分配键 WRITE/UPDATE 一次，RETURN 只写库存。IF 任一 I/O 失败 → 3000 或 9000，立即返回主程序整体回滚，自己不补偿、不提交。 (BR-10, BR-14, BR-17, BR-21)

Step 11: **SRET** — 返回 0000 或已规划等待 0010，并给有效候选行标志和缺口；所有计划只在当前调用事件中有效，回滚后必须丢弃重建。 (BR-15, BR-16, BR-32)

### File Output / Update

| File | Action | Fields Modified | File Spec Ref | Condition / Steps |
| --- | --- | --- | --- | --- |
| ALLOCPF | WRITE / UPDATE | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | ALLOCPF-20260905-01 | Step 10 |
| STOCKPF | UPDATE only | 仅 STONHAND、STRESVD | STOCKPF-20260905-01 | Step 10 |

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
| BR-10 | Step 3, Step 9, Step 10 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF |
| BR-13 | Step 2, Step 4 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF, WHSEPF |
| BR-14 | Step 1, Step 2, Step 3, Step 4, Step 6, Step 9, Step 10 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF, WHSEPF |
| BR-15 | Step 4, Step 11 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF, WHSEPF |
| BR-16 | Step 2, Step 4, Step 11 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF, WHSEPF |
| BR-17 | Step 1, Step 6, Step 9, Step 10 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF |
| BR-18 | Step 5 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF |
| BR-19 | Step 5 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF |
| BR-21 | Step 7, Step 10 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF, WHSEPF |
| BR-32 | Step 1, Step 8, Step 11 | E01 / E02 / E03 / E04（按具体失败类别） | ALLOCPF, STOCKPF |

## Processing Considerations

单作业串行处理；显式日期，不依赖运行机器的当前日期。多记录范围及历史集合读完整，固定数组只限制单次事件候选。ORDMAIN 是正常提交／回滚所有者；辅助程序不得提交，失败由调用方整体撤销。不设置吞吐量或运行成功承诺。

## Compile-Oriented Constraints

| File | Record Format | RENAME | KLIST / KFLD 顺序 | Confidence |
| --- | --- | --- | --- | --- |
| ALLOCPF | ALLOCR | N/A | KALLOC = ALORDER + ALLINE + ALWH | Assumed：授权合成，未编译 |
| STOCKPF | STOCKR | N/A | KSTOCK = STITEM + STWH | Assumed：授权合成，未编译 |
| WHSEPF | WHSER | N/A | KWHSE = WHID | Assumed：授权合成，未编译 |

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
| L3 Full | 10 | 11 | 3 | 0 | 0 |

Traceability Complete：规格内 BR 到步骤和文件／委派入口已建立。状态 Draft；所有规则是继承规则，没有新增需求级 BR。
