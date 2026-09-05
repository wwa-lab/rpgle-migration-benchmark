# ORDMAIN 程序规格

## Spec Header

- **Spec ID**：ORDMAIN-20260905-01
- **Spec Level**：L3 Full
- **Version / Status**：1.0 / Draft
- **Change Type / Program Type**：New Program / RPGLE
- **Program Name**：ORDMAIN
- **Description**：大型固定格式业务主程序：统一事件分派、事实写入、恢复和本地提交。
- **Source TD**：[TD-20260905-01](../../design/technical-design.md) Module Allocation 行 `ORDMAIN`。
- **共同输入**：[功能需求](../../requirements/functional-requirements.md)、[共享契约](../shared-contract.md)。全部字段及步骤为授权合成定义，不是对既有系统的发现。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次完整规格。

## Caller Context

由 ORDRUN 发起，读取显式输入事件批次。成功后调用方按返回码继续；失败由主程序决定回滚、记录结果或停止。辅助成功不等于事务提交。

## Functions

- 大型固定格式业务主程序：统一事件分派、事实写入、恢复和本地提交。
- 输出有身份和原因的结果，保持职责范围与静态追踪关系。

## Business Rules

继承 FS 编号，不在各程序重新从 01 编号。主责与协作分开；下面的恢复／记录引用不把所有规则所有权转移到本程序。

| BR | 需求规则 | 本程序角色 |
| --- | --- | --- |
| BR-01 | 所有业务请求必须具有来源、请求标识、业务类型和处理日；缺少任何一项均拒绝受理。 | 主责 |
| BR-02 | 新订单和订单修改只允许使用存在且启用的客户。 | 协作／处理边界；主责 ORDCHECK |
| BR-03 | 新订单和订单修改的所有明细必须引用存在、启用且有正数有效单价的商品。 | 协作／处理边界；主责 ORDCHECK |
| BR-04 | 每条订单明细数量必须为 1～9,999 的整数。 | 协作／处理边界；主责 ORDCHECK |
| BR-05 | 一张订单必须包含 1～100 条明细；明细序号在订单内唯一。 | 协作／处理边界；主责 ORDCHECK |
| BR-06 | 同一来源和请求标识、相同业务内容的重复请求必须返回最近已知结果，不重复占用、发货或结算；“重新尝试失败业务”需要独立的恢复动作。 | 主责 |
| BR-07 | 同一来源和请求标识携带不同业务内容时，拒绝为冲突请求，保留第一次请求及其结果。 | 主责 |
| BR-08 | 已存在的订单不能用新请求标识再次作为新订单创建；后续动作必须引用原订单。 | 主责 |
| BR-09 | 修改、取消、分配和发货请求须基于当前订单版本；版本过期时拒绝该动作，不改变当前业务记录。 | 主责 |
| BR-10 | 订单只有在尚无发货记录、且没有全部取消时才可修改；修改需要重新校验、计价及安排分配，修改未被接受时保持原订单与原占用。 | 主责 |
| BR-11 | 客户分普通和优选两级：普通按有效单价计价，优选享 5% 折扣；不叠加其他折扣、税费或运费。修改使用修改受理时的有效价格和客户等级。 | 协作／处理边界；主责 ORDPRICE |
| BR-12 | 每行金额按数量、单价及客户折扣计算，四舍五入保留两位小数；整单金额等于已舍入的各行金额之和。首次发货后保留原计价依据，不能因价格资料变化重算已受理订单。 | 协作／处理边界；主责 ORDPRICE |
| BR-13 | 仅从启用仓库分配，固定优先次序为演示仓库 A、B、C；同一订单按明细序号分配。 | 协作／处理边界；主责 ORDSTOCK |
| BR-14 | 可分配数量为现有库存扣除已占用数量，分配不得使可用数量为负；发货同时减少现有库存及对应占用。 | 协作／处理边界；主责 ORDSTOCK |
| BR-15 | 不允许部分履约的订单，仅在整单剩余数量均可满足时分配，否则整单剩余数量等待且不新增占用；允许部分履约时可先分配可用数量，其余等待。 | 主责 |
| BR-16 | 后续补分配只处理尚未分配、发货或取消的有效需求；新到库存不会触发重复占用已有分配。 | 主责 |
| BR-17 | 每次发货数量必须为正整数且不超过该订单明细在指定仓库的尚未发货占用；一次确认涉及多条明细时，全部满足条件才接受该次确认。 | 主责 |
| BR-18 | 取消数量必须为正整数且不得超过未发货、未取消数量；先取消未分配部分，不足部分按 C、B、A 的次序释放占用。 | 主责 |
| BR-19 | 已发货数量不得通过取消回退；全部剩余数量取消后不再接受该订单的新分配和修改，已有发货仍允许完成结算及符合条件的退货。 | 主责 |
| BR-20 | 退货只能引用已成功结算的原发货明细；每次退货数量须为正整数，累计退货数量不得超过该明细已发货数量，退货处理日与发货业务日相差须为 0～30 个自然日（含边界）。 | 主责 |
| BR-21 | 接受退货后将数量归还到原发货仓库，但不重新增加原订单待分配需求；即使该仓库已停用，归还数量也只记为该仓库库存，不供新订单分配。 | 主责 |
| BR-22 | 退货调整沿用原发货结算金额。按累计退货数量比例计算累计应调整额，再扣除此前已成功调整额；全部退回时累计调整必须等于原发货结算金额。同一原发货明细仍有未完成调整时，后续退货暂不受理且不增加归还数量；原调整沿既有身份恢复，不重复创建。 | 主责 |
| BR-23 | 结算只针对已确认发货，且每次发货只形成一项正向结算。分次发货按原订单行金额的累计发货比例分摊到两位小数，本次金额为累计应结算额减此前已分配给发货的金额，全部发完时正好等于原行金额。 | 主责 |
| BR-24 | 明确的结算失败保留已发货或已接受退货事实，标为待恢复；结算结果未知时保留为待核实，核实前不能再次发起结算或宣告成功。 | 主责 |
| BR-25 | 已确认可重试的失败沿用原结算或调整身份重试，不创建第二笔业务；成功结果不得被后到的失败通知覆盖，重复成功通知不重复计入金额。 | 主责 |
| BR-26 | 回执发送失败只允许重送回执，不重做已完成业务；回执应同时反映业务结果和最近送达情况。 | 协作／处理边界；主责 ORDREPLY |
| BR-27 | 批次中的业务拒绝只影响该请求，其余独立请求继续；每条请求的受理结果及等待／失败原因可单独查询。 | 主责 |
| BR-28 | 恢复中断批次时跳过已完成请求，从未完成请求继续；“结果未知”的外部结算先核实，不能因重跑批次而重发业务。 | 主责 |
| BR-29 | 业务处理日由输入明确指定；演示运营日以 18:00 为接单截点，18:00 及之后到达的请求归下一处理日。涉及重复识别时，重送保留原请求处理日，不重分日期。 | 主责 |
| BR-30 | 日终金额按本处理日已确认成功的正向结算减本处理日已确认成功的退货调整汇总；待处理、失败和未知结果另列，历史成功记录不因后来退货而从历史汇总消失。 | 协作／处理边界；主责 ORDDAILY |
| BR-31 | 人工处置须保留操作者、原因及所选择的恢复动作；不能直接覆盖成功结算、抹去原失败或跳过数量和状态校验。 | 主责 |
| BR-32 | 请求、订单、明细、发货、退货、结算、调整、回执和处理批次均能沿关联标识追溯；拒绝、等待和重试也须保留可解释的业务结果。 | 主责 |

## Interface Contract

参数按位置引用传递，完整布局只在共享契约定义；本表长度为字节。IO 表示依动作输入或输出，输入用途与目标状态不能通过残留值猜测。

### Program Parameters

| 位置 | Name | Type | Length | I/O | Valid Values / Description |
| --- | --- | --- | --- | --- | --- |
| 1 | BATCH | A | 20 | I | 批次身份 |
| 2 | DAY | A | 8 | I | 执行日 YYYYMMDD |
| 3 | MODE | A | 8 | I | PROCESS / RESUME |
| 4 | ACTOR | A | 20 | I | 操作人 |
| 5 | RESULT | A | 4 | O | 统一返回码 |

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
| AUID | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-01 | 批次:输入序号:事件序号 |
| AUBATCH | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-02 | 输入批次 |
| AUINPUT | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-03 | 输入序号 |
| AUSRC | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-04 | 请求来源，可为空 |
| AUREQ | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-05 | 请求标识，可为空 |
| AUDAY | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-06 | 本次处理日 |
| AUEVENT | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-07 | 事件类别 |
| AUORDER | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-08 | 订单 |
| AUSHIP | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-09 | 发货 |
| AURETURN | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-10 | 退货 |
| AUSETTL | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-11 | 结算 |
| AUMSG | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-12 | 消息 |
| AUACTOR | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-13 | 操作人 |
| AUREASON | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-14 | 原因 |
| AURC | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-15 | 结果码 |
| AUBEFORE | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-16 | 变更前状态 |
| AUAFTER | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-17 | 变更后状态 |
| AUDETAIL | AUDITPF | Persisted | Step 33 | Step 13, Step 36, Step 39 | AUDITPF-20260905-01:FLD-18 | 结构化事实或版本快照片段 |
| BTID | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-01 | 批次身份 |
| BTDAY | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-02 | 批次运行处理日 |
| BTSTATE | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-03 | OPEN / DONE / STOP |
| BTLAST | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-04 | 最后闭合的输入序号，初值 0 |
| BTCOUNT | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-05 | 闭合信封累计数 |
| BTACCEPT | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-06 | 已接受输入数 |
| BTREJECT | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-07 | 拒绝或冲突输入数 |
| BTWAIT | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-08 | 闭合时处于等待的输入数 |
| BTACTOR | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-09 | 最后操作人 |
| BTRC | BATCHPF | Persisted | Step 2 | Step 2, Step 37, Step 39, Step 40 | BATCHPF-20260905-01:FLD-10 | 最后作业结果码 |
| IDBATCH | INDTLPF | Persisted | Step 3, Step 29 | — | INDTLPF-20260905-01:FLD-01 | 原始批次 |
| IDINPUT | INDTLPF | Persisted | Step 3, Step 29 | — | INDTLPF-20260905-01:FLD-02 | 输入序号 |
| IDPOS | INDTLPF | Persisted | Step 3, Step 29 | — | INDTLPF-20260905-01:FLD-03 | 传输行位置，1 起 |
| IDLINE | INDTLPF | Persisted | Step 3, Step 29 | — | INDTLPF-20260905-01:FLD-04 | 订单明细号或事件行号原文 |
| IDITEM | INDTLPF | Persisted | Step 3, Step 29 | — | INDTLPF-20260905-01:FLD-05 | 商品 |
| IDQTY | INDTLPF | Persisted | Step 3, Step 29 | — | INDTLPF-20260905-01:FLD-06 | 数量原文 |
| IDWH | INDTLPF | Persisted | Step 3, Step 29 | — | INDTLPF-20260905-01:FLD-07 | 仓库 A/B/C |
| IDSHIP | INDTLPF | Persisted | Step 3, Step 29 | — | INDTLPF-20260905-01:FLD-08 | 退货所引用的原发货身份 |
| IDSHLINE | INDTLPF | Persisted | Step 3, Step 29 | — | INDTLPF-20260905-01:FLD-09 | 原发货明细号原文 |
| IHBATCH | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-01 | 原始批次 |
| IHSEQ | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-02 | 原始输入序号，1 起且批次内唯一 |
| IHSRC | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-03 | 业务来源，允许原始空值进入拒绝路径 |
| IHREQ | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-04 | 请求标识 |
| IHEVENT | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-05 | 事件编码 |
| IHDAY | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-06 | 原请求业务日 |
| IHARRDAY | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-07 | 到达日期，传输包装 |
| IHARRTIME | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-08 | 到达时刻，传输包装 |
| IHORDER | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-09 | 订单身份 |
| IHVERSION | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-10 | 期望订单版本原文 |
| IHCUST | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-11 | 客户 |
| IHPART | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-12 | 部分履约 Y/N |
| IHSHIP | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-13 | 本次发货身份 |
| IHRETURN | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-14 | 本次退货身份 |
| IHSETTL | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-15 | 被反馈或恢复的结算身份 |
| IHMSG | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-16 | 关联出站消息身份 |
| IHRESULT | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-17 | 反馈结果 |
| IHACTION | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-18 | 恢复类别 |
| IHREFSRC | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-19 | 被恢复请求来源 |
| IHREFREQ | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-20 | 被恢复请求标识 |
| IHACTOR | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-21 | 操作者 |
| IHREASON | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-22 | 处置原因或反馈说明 |
| IHNLINE | INHDRPF | Persisted | Step 3, Step 29 | — | INHDRPF-20260905-01:FLD-23 | 业务明细条数原文 |
| ODORDER | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-01 | 订单 |
| ODLINE | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-02 | 订单内唯一明细号 |
| ODITEM | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-03 | 商品 |
| ODQTY | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-04 | 本版本原受理数量 |
| ODCANCEL | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-05 | 本版本累计取消量 |
| ODSHIPPED | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-06 | 本版本累计发货量 |
| ODUNIT | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-07 | 冻结单价 |
| ODRATE | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-08 | 计价系数：1.0000 或 0.9500 |
| ODAMOUNT | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-09 | 冻结行金额 |
| ODSHPAMT | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-10 | 此前已分配给发货的累计金额，含尚未成功结算 |
| ODVERSION | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-11 | 当前行所属订单版本 |
| ODACTIVE | ORDDTLPF | Persisted | Step 7, Step 10, Step 14, Step 15, Step 17, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDDTLPF-20260905-01:FLD-12 | 当前版本有效 Y/N；旧版本停用行不参与数量及金额 |
| OHORDER | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-01 | 订单身份 |
| OHVERSION | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-02 | 当前版本，初次为 1 |
| OHCUST | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-03 | 客户 |
| OHTIER | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-04 | 本版本计价客户等级 |
| OHPART | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-05 | Y/N |
| OHDAY | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-06 | 订单首次业务日 |
| OHPRCDAY | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-07 | 当前版本取价日 |
| OHNLINE | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-08 | 当前订单明细数 |
| OHAMOUNT | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-09 | 当前版本行金额合计 |
| OHSTATE | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-10 | ACTIVE / CANCEL / CLOSED |
| OHSHIPANY | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-11 | 是否曾有发货 Y/N |
| OHSRC | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-12 | 最近业务更新请求来源 |
| OHREQ | ORDHDRPF | Persisted | Step 7, Step 8, Step 10, Step 33 | Step 13, Step 14, Step 15, Step 19 | ORDHDRPF-20260905-01:FLD-13 | 最近业务更新请求标识 |
| RQSRC | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-01 | 规范来源 |
| RQREQ | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-02 | 规范请求标识 |
| RQBATCH | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-03 | 首次出现批次 |
| RQINPUT | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-04 | 首次输入序号 |
| RQEVENT | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-05 | 原请求事件 |
| RQDAY | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-06 | 原请求处理日 |
| RQCANLEN | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-07 | 规范内容实际长度 |
| RQCANON | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-08 | 完整规范内容，不以哈希替代比较 |
| RQORDER | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-09 | 关联订单 |
| RQSHIP | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-10 | 关联发货 |
| RQRETURN | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-11 | 关联退货 |
| RQSETTL | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-12 | 单项结算关联，多个时沿退货查询 |
| RQSTATE | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-13 | DONE / REJECT / RETRY，指原请求本地处理 |
| RQRC | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-14 | 最近一次原请求本地处理结果 |
| RQREASON | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-15 | 结果原因 |
| RQVERSION | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-16 | 本地接受后订单版本，非最新订单版本缓存 |
| RQMSG | REQPF | Persisted | Step 5, Step 29, Step 33 | Step 29, Step 37, Step 39 | REQPF-20260905-01:FLD-17 | 最近一次结果投影的回执消息身份；原始请求内容保持不变 |
| RDRETURN | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-01 | 退货身份 |
| RDLINE | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-02 | 退货明细号 |
| RDSHIP | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-03 | 原发货 |
| RDSHLINE | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-04 | 原发货明细 |
| RDORDER | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-05 | 原订单 |
| RDITEM | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-06 | 商品 |
| RDWH | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-07 | 原仓库 |
| RDQTY | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-08 | 本次归还数量 |
| RDAMOUNT | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-09 | 本次调整金额 |
| RDSETTL | RTNDTLPF | Persisted | Step 21, Step 33 | Step 23 | RTNDTLPF-20260905-01:FLD-10 | 所属反向调整身份 |
| RHRETURN | RTNHDRPF | Persisted | Step 20, Step 33 | Step 23 | RTNHDRPF-20260905-01:FLD-01 | 唯一退货身份 |
| RHORDER | RTNHDRPF | Persisted | Step 20, Step 33 | Step 23 | RTNHDRPF-20260905-01:FLD-02 | 原订单；一次退货限定同一订单 |
| RHDAY | RTNHDRPF | Persisted | Step 20, Step 33 | Step 23 | RTNHDRPF-20260905-01:FLD-03 | 接受退货日 |
| RHSRC | RTNHDRPF | Persisted | Step 20, Step 33 | Step 23 | RTNHDRPF-20260905-01:FLD-04 | 原请求来源 |
| RHREQ | RTNHDRPF | Persisted | Step 20, Step 33 | Step 23 | RTNHDRPF-20260905-01:FLD-05 | 原请求标识 |
| RHNLINE | RTNHDRPF | Persisted | Step 20, Step 33 | Step 23 | RTNHDRPF-20260905-01:FLD-06 | 退货明细数 |
| RHAMOUNT | RTNHDRPF | Persisted | Step 20, Step 33 | Step 23 | RTNHDRPF-20260905-01:FLD-07 | 本次调整金额合计 |
| SLSETTL | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-01 | 结算身份 |
| SLLINE | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-02 | 结算内明细序号 |
| SLSHIP | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-03 | 原发货 |
| SLSHLINE | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-04 | 原发货明细 |
| SLRETURN | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-05 | 反向来源退货，正向为空 |
| SLRTLINE | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-06 | 反向来源退货明细；正向 0 |
| SLORDER | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-07 | 原订单 |
| SLORDLINE | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-08 | 原订单行 |
| SLQTY | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-09 | 结算／调整对应数量 |
| SLAMOUNT | SETLDTPF | Persisted | Step 33 | — | SETLDTPF-20260905-01:FLD-10 | 金额绝对值 |
| SEID | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-01 | 正向 S:发货 或反向 A:退货:原发货 |
| SEKIND | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-02 | P 正向 / R 反向 |
| SESHIP | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-03 | 原发货，正反向均必填 |
| SERETURN | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-04 | 反向来源退货，正向为空 |
| SEORIG | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-05 | 反向的原正向结算，正向为空 |
| SEORDER | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-06 | 原订单 |
| SECREATED | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-07 | 创建业务日 |
| SESTATE | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-08 | NEW / SENT / OK / FAIL / UNKNOWN |
| SEAMOUNT | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-09 | 结算金额，正反向都存非负数 |
| SEFIRSTDAY | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-10 | 首次认定成功日；未成功为空格 |
| SEATTEMPT | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-11 | 本业务发送尝试号，初值 1 |
| SELASTMSG | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-12 | 当前发送或核实消息 |
| SENLINE | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-13 | 结算明细数 |
| SERETRY | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-14 | 是否已有明确可重试证据 Y/N |
| SEREASON | SETLHDPF | Persisted | Step 33 | — | SETLHDPF-20260905-01:FLD-15 | 最近有效结果说明 |
| SDSHIP | SHIPDTPF | Persisted | Step 20, Step 22, Step 33 | Step 19 | SHIPDTPF-20260905-01:FLD-01 | 发货身份 |
| SDLINE | SHIPDTPF | Persisted | Step 20, Step 22, Step 33 | Step 19 | SHIPDTPF-20260905-01:FLD-02 | 本次发货行序号 |
| SDORDER | SHIPDTPF | Persisted | Step 20, Step 22, Step 33 | Step 19 | SHIPDTPF-20260905-01:FLD-03 | 原订单 |
| SDORDLINE | SHIPDTPF | Persisted | Step 20, Step 22, Step 33 | Step 19 | SHIPDTPF-20260905-01:FLD-04 | 原订单行 |
| SDITEM | SHIPDTPF | Persisted | Step 20, Step 22, Step 33 | Step 19 | SHIPDTPF-20260905-01:FLD-05 | 商品 |
| SDWH | SHIPDTPF | Persisted | Step 20, Step 22, Step 33 | Step 19 | SHIPDTPF-20260905-01:FLD-06 | 原发货仓 |
| SDQTY | SHIPDTPF | Persisted | Step 20, Step 22, Step 33 | Step 19 | SHIPDTPF-20260905-01:FLD-07 | 该行发货数量 |
| SDAMOUNT | SHIPDTPF | Persisted | Step 20, Step 22, Step 33 | Step 19 | SHIPDTPF-20260905-01:FLD-08 | 该行分配金额 |
| SHSHIP | SHIPHDPF | Persisted | Step 16, Step 20, Step 33 | Step 19 | SHIPHDPF-20260905-01:FLD-01 | 唯一发货身份 |
| SHORDER | SHIPHDPF | Persisted | Step 16, Step 20, Step 33 | Step 19 | SHIPHDPF-20260905-01:FLD-02 | 订单 |
| SHVERSION | SHIPHDPF | Persisted | Step 16, Step 20, Step 33 | Step 19 | SHIPHDPF-20260905-01:FLD-03 | 接受时新版本 |
| SHDAY | SHIPHDPF | Persisted | Step 16, Step 20, Step 33 | Step 19 | SHIPHDPF-20260905-01:FLD-04 | 发货业务日 |
| SHSRC | SHIPHDPF | Persisted | Step 16, Step 20, Step 33 | Step 19 | SHIPHDPF-20260905-01:FLD-05 | 原请求来源 |
| SHREQ | SHIPHDPF | Persisted | Step 16, Step 20, Step 33 | Step 19 | SHIPHDPF-20260905-01:FLD-06 | 原请求标识 |
| SHNLINE | SHIPHDPF | Persisted | Step 16, Step 20, Step 33 | Step 19 | SHIPHDPF-20260905-01:FLD-07 | 发货明细数 |
| SHSETTL | SHIPHDPF | Persisted | Step 16, Step 20, Step 33 | Step 19 | SHIPHDPF-20260905-01:FLD-08 | 唯一正向结算身份 |
| SHAMOUNT | SHIPHDPF | Persisted | Step 16, Step 20, Step 33 | Step 19 | SHIPHDPF-20260905-01:FLD-09 | 本次发货金额 |

| Field | Source | Storage | Read by | Written by | Reference | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| BATCH | Parameter | Transient | Step 1 | — | N/A | 批次身份 |
| DAY | Parameter | Transient | Step 1 | — | N/A | 执行日 YYYYMMDD |
| MODE | Parameter | Transient | Step 1 | — | N/A | PROCESS / RESUME |
| ACTOR | Parameter | Transient | Step 1 | — | N/A | 操作人 |
| RESULT | Parameter | Transient | — | Step 1, Step 40 | N/A | 统一返回码 |
| CTXDS.CXABI | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 0001 |
| CTXDS.CXBATCH | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 输入批次 |
| CTXDS.CXINPUT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 输入序号 |
| CTXDS.CXDAY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 原请求业务日 |
| CTXDS.CXPROCDAY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 当前执行处理日 |
| CTXDS.CXSRC | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 请求来源 |
| CTXDS.CXREQ | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 请求身份 |
| CTXDS.CXEVENT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 业务事件 |
| CTXDS.CXACTION | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 本次辅助调用动作 |
| CTXDS.CXORDER | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 订单 |
| CTXDS.CXVERSION | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 期望订单版本 |
| CTXDS.CXACTOR | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 人工操作人 |
| CTXDS.CXREASON | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 人工原因 |
| CTXDS.CXSHIP | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 发货 |
| CTXDS.CXRETURN | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 退货 |
| CTXDS.CXSETTL | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 结算身份 |
| CTXDS.CXMSG | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 原消息身份 |
| CTXDS.CXPART | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 部分履约 Y/N |
| CTXDS.CXTIER | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | S/P |
| CTXDS.CXCOUNT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 本次数组有效行数 |
| CTXDS.CXOUTSEQ | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 同一输入同种消息的确定性序号，1 起 |
| CTXDS.CXEXPECT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 主程序读取到的旧结算状态 |
| CTXDS.CXATTEMPT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 主程序读取到的旧结算尝试 |
| CTXDS.CXFEED | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CTXDS | 原始反馈 OK/FAIL/UNKNOWN/RETRYOK/SENT |
| RESDS.RSRC | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 RESDS | 0000 成功 / 0010 等待 / 0020 重复 / 1000 拒绝 / 1100 冲突 / 2000 数据问题 / 3000 本地失败 / 9000 停止 |
| RESDS.RSREASON | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 RESDS | 可解释原因 |
| RESDS.RSINDEX | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 RESDS | 问题行号，0 为头或系统 |
| RESDS.RSCOUNT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 RESDS | 输出行数 |
| RESDS.RSAMOUNT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 RESDS | 合计或日报净额 |
| RESDS.RSSTATE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 RESDS | 结果状态 |
| RESDS.RSVERSION | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 RESDS | 结果订单版本 |
| HDRDS.IHBATCH | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-01 | 原始批次 |
| HDRDS.IHSEQ | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-02 | 原始输入序号，1 起且批次内唯一 |
| HDRDS.IHSRC | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-03 | 业务来源，允许原始空值进入拒绝路径 |
| HDRDS.IHREQ | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-04 | 请求标识 |
| HDRDS.IHEVENT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-05 | 事件编码 |
| HDRDS.IHDAY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-06 | 原请求业务日 |
| HDRDS.IHARRDAY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-07 | 到达日期，传输包装 |
| HDRDS.IHARRTIME | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-08 | 到达时刻，传输包装 |
| HDRDS.IHORDER | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-09 | 订单身份 |
| HDRDS.IHVERSION | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-10 | 期望订单版本原文 |
| HDRDS.IHCUST | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-11 | 客户 |
| HDRDS.IHPART | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-12 | 部分履约 Y/N |
| HDRDS.IHSHIP | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-13 | 本次发货身份 |
| HDRDS.IHRETURN | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-14 | 本次退货身份 |
| HDRDS.IHSETTL | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-15 | 被反馈或恢复的结算身份 |
| HDRDS.IHMSG | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-16 | 关联出站消息身份 |
| HDRDS.IHRESULT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-17 | 反馈结果 |
| HDRDS.IHACTION | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-18 | 恢复类别 |
| HDRDS.IHREFSRC | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-19 | 被恢复请求来源 |
| HDRDS.IHREFREQ | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-20 | 被恢复请求标识 |
| HDRDS.IHACTOR | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-21 | 操作者 |
| HDRDS.IHREASON | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-22 | 处置原因或反馈说明 |
| HDRDS.IHNLINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INHDRPF-20260905-01:FLD-23 | 业务明细条数原文 |
| RAWROWS[].IDBATCH | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INDTLPF-20260905-01:FLD-01 | 原始批次 |
| RAWROWS[].IDINPUT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INDTLPF-20260905-01:FLD-02 | 输入序号 |
| RAWROWS[].IDPOS | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INDTLPF-20260905-01:FLD-03 | 传输行位置，1 起 |
| RAWROWS[].IDLINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INDTLPF-20260905-01:FLD-04 | 订单明细号或事件行号原文 |
| RAWROWS[].IDITEM | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INDTLPF-20260905-01:FLD-05 | 商品 |
| RAWROWS[].IDQTY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INDTLPF-20260905-01:FLD-06 | 数量原文 |
| RAWROWS[].IDWH | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INDTLPF-20260905-01:FLD-07 | 仓库 A/B/C |
| RAWROWS[].IDSHIP | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INDTLPF-20260905-01:FLD-08 | 退货所引用的原发货身份 |
| RAWROWS[].IDSHLINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | INDTLPF-20260905-01:FLD-09 | 原发货明细号原文 |
| CHKHEAD.CHVERSION | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CHKHEAD | 解析后的版本 |
| CHKHEAD.CHTIER | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CHKHEAD | 客户等级 |
| CHKHEAD.CHCOUNT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CHKHEAD | 规范明细数 |
| CHKHEAD.CHLEN | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CHKHEAD | 规范内容实际长度 |
| CHKHEAD.CHCANON | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 CHKHEAD | 规范内容 |
| NORMROWS[].NRLINE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 NORMROWS | 业务行号 |
| NORMROWS[].NRITEM | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 NORMROWS | 商品 |
| NORMROWS[].NRQTY | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 NORMROWS | 整数数量 |
| NORMROWS[].NRWH | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 NORMROWS | 仓库 |
| NORMROWS[].NRSHIP | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 NORMROWS | 原发货 |
| NORMROWS[].NRSHLINE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 NORMROWS | 原发货行 |
| PRIN[].PIGROUP | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PRIN | 金额累计组：订单行或原发货行 |
| PRIN[].PILINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PRIN | 本次顺序 |
| PRIN[].PIITEM | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PRIN | 商品 |
| PRIN[].PIQTY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PRIN | 订单报价量或本次流转量 |
| PRIN[].PIBASEQTY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PRIN | 比例分母：原订单量或原发货量 |
| PRIN[].PIPRIORQ | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PRIN | 本次前累计发货／退货数量 |
| PRIN[].PIBASEAMT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PRIN | 原行／原发货金额 |
| PRIN[].PIPRIORA | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PRIN | 此前已分配发货额／已成功调整额 |
| PROUT[].POLINE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PROUT | 本次行顺序 |
| PROUT[].POUNIT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PROUT | 报价单价；比例模式回传 0 |
| PROUT[].PORATE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PROUT | 报价系数；比例模式回传 0 |
| PROUT[].POAMOUNT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PROUT | 当前行金额或本次分摊额 |
| PROUT[].POCUMQTY | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PROUT | 更新后累计数量 |
| PROUT[].POCUMAMT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 PROUT | 更新后累计金额 |
| STKIN[].SILINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKIN | 原订单明细号 |
| STKIN[].SIITEM | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKIN | 商品 |
| STKIN[].SIWH | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKIN | SHIP / RETURN 指定仓库，其他动作空格 |
| STKIN[].SIQTY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKIN | 当前目标待满足量或本次动作量 |
| STKIN[].SIREMAIN | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKIN | 取消前有效剩余量；非取消动作设 0 |
| STKOLD[].SPLINE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 订单行 |
| STKOLD[].SPITEM | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 库存商品 |
| STKOLD[].SPWH | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 仓库 |
| STKOLD[].SPONHAND | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 计划前库存 |
| STKOLD[].SPRESVD | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 计划前总占用 |
| STKOLD[].SPONDELTA | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 本行实物变化，可为负 |
| STKOLD[].SPRSDELTA | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 本行总占用变化，可为负 |
| STKOLD[].SPOLDITEM | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 原分配商品或空格 |
| STKOLD[].SPOLDRES | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 原行占用 |
| STKOLD[].SPOLDSHIP | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 原行已发货 |
| STKOLD[].SPOLDREL | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 原行已释放 |
| STKOLD[].SPNEWRES | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 新行占用 |
| STKOLD[].SPNEWSHIP | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 新行已发货 |
| STKOLD[].SPNEWREL | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | 新行已释放 |
| STKOLD[].SPUSE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKOLD | Y/N，有效项 |
| STKNEW[].SPLINE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 订单行 |
| STKNEW[].SPITEM | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 库存商品 |
| STKNEW[].SPWH | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 仓库 |
| STKNEW[].SPONHAND | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 计划前库存 |
| STKNEW[].SPRESVD | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 计划前总占用 |
| STKNEW[].SPONDELTA | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 本行实物变化，可为负 |
| STKNEW[].SPRSDELTA | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 本行总占用变化，可为负 |
| STKNEW[].SPOLDITEM | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 原分配商品或空格 |
| STKNEW[].SPOLDRES | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 原行占用 |
| STKNEW[].SPOLDSHIP | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 原行已发货 |
| STKNEW[].SPOLDREL | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 原行已释放 |
| STKNEW[].SPNEWRES | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 新行占用 |
| STKNEW[].SPNEWSHIP | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 新行已发货 |
| STKNEW[].SPNEWREL | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | 新行已释放 |
| STKNEW[].SPUSE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 STKNEW | Y/N，有效项 |
| SETHEAD.SEID | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-01 | 正向 S:发货 或反向 A:退货:原发货 |
| SETHEAD.SEKIND | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-02 | P 正向 / R 反向 |
| SETHEAD.SESHIP | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-03 | 原发货，正反向均必填 |
| SETHEAD.SERETURN | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-04 | 反向来源退货，正向为空 |
| SETHEAD.SEORIG | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-05 | 反向的原正向结算，正向为空 |
| SETHEAD.SEORDER | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-06 | 原订单 |
| SETHEAD.SECREATED | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-07 | 创建业务日 |
| SETHEAD.SESTATE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-08 | NEW / SENT / OK / FAIL / UNKNOWN |
| SETHEAD.SEAMOUNT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-09 | 结算金额，正反向都存非负数 |
| SETHEAD.SEFIRSTDAY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-10 | 首次认定成功日；未成功为空格 |
| SETHEAD.SEATTEMPT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-11 | 本业务发送尝试号，初值 1 |
| SETHEAD.SELASTMSG | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-12 | 当前发送或核实消息 |
| SETHEAD.SENLINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-13 | 结算明细数 |
| SETHEAD.SERETRY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-14 | 是否已有明确可重试证据 Y/N |
| SETHEAD.SEREASON | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLHDPF-20260905-01:FLD-15 | 最近有效结果说明 |
| SETROWS[].SLSETTL | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-01 | 结算身份 |
| SETROWS[].SLLINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-02 | 结算内明细序号 |
| SETROWS[].SLSHIP | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-03 | 原发货 |
| SETROWS[].SLSHLINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-04 | 原发货明细 |
| SETROWS[].SLRETURN | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-05 | 反向来源退货，正向为空 |
| SETROWS[].SLRTLINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-06 | 反向来源退货明细；正向 0 |
| SETROWS[].SLORDER | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-07 | 原订单 |
| SETROWS[].SLORDLINE | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-08 | 原订单行 |
| SETROWS[].SLQTY | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-09 | 结算／调整对应数量 |
| SETROWS[].SLAMOUNT | Internal / ORDCTX | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | SETLDTPF-20260905-01:FLD-10 | 金额绝对值 |
| SETVIEW[].SVSHLINE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 SETVIEW | 原发货明细 |
| SETVIEW[].SVSUCCQTY | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 SETVIEW | 已经成功调整的累计数量 |
| SETVIEW[].SVSUCCAMT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 SETVIEW | 已经成功调整的累计绝对金额 |
| SETVIEW[].SVPENDING | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | 共享契约 SETVIEW | 是否有未完成调整 Y/N |
| OUTREC.OBID | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-01 | 唯一消息身份 |
| OUTREC.OBKIND | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-02 | SETTLE / ADJUST / VERIFY / RECEIPT / WHRESULT |
| OUTREC.OBBIZID | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-03 | 结算身份或回执关联业务身份 |
| OUTREC.OBSRC | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-04 | 请求来源 |
| OUTREC.OBREQ | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-05 | 请求标识 |
| OUTREC.OBBATCH | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-06 | 原始输入批次 |
| OUTREC.OBINPUT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-07 | 原始输入序号 |
| OUTREC.OBORDER | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-08 | 订单 |
| OUTREC.OBSTATE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-09 | NEW / SENT / OK / FAIL |
| OUTREC.OBRESULT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-10 | NONE / OK / FAIL / UNKNOWN / RETRYOK，业务反馈与送达分开 |
| OUTREC.OBRESDAY | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-11 | 业务反馈处理日；无反馈为空 |
| OUTREC.OBATTEMPT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-12 | 消息送达尝试次数 |
| OUTREC.OBDAY | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-13 | 创建处理日 |
| OUTREC.OBLEN | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-14 | 有效负载长度 |
| OUTREC.OBPAYLOAD | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-15 | 带版本的完整消息内容，长度外为空格 |
| OUTREC.OBREASON | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | OUTBOXPF-20260905-01:FLD-16 | 最近送达原因 |
| DAYHEAD.DYDAY | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-01 | 被汇总处理日 |
| DAYHEAD.DYSNAP | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-02 | 来源:日终请求标识；同日完整快照身份 |
| DAYHEAD.DYLINE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-03 | 0 为头；其余为组成行 |
| DAYHEAD.DYKIND | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-04 | HEADER / POS / NEG / PENDING / LOCAL |
| DAYHEAD.DYSTATE | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-05 | 头 DRAFT / READY；组成行保存观察状态 |
| DAYHEAD.DYSETTL | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-06 | 组成结算身份 |
| DAYHEAD.DYSRC | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-07 | 组成请求来源 |
| DAYHEAD.DYREQ | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-08 | 组成请求标识 |
| DAYHEAD.DYAMOUNT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-09 | 行金额；HEADER 存净额，NEG 行存负值 |
| DAYHEAD.DYPOS | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-10 | 头正向总额 |
| DAYHEAD.DYNEG | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-11 | 头反向绝对值总额 |
| DAYHEAD.DYCOUNT | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-12 | 头组成行数 |
| DAYHEAD.DYRC | Internal / ORDRES | Transient | 对应调用步骤；见精确调用顺序 | Step 1 清空；业务及调用步骤赋值 | DAYRPTPF-20260905-01:FLD-13 | 待处理原因结果码 |

## File Usage

| File | I/O/U | 完整键 | Access Pattern | File Spec Ref | Description |
| --- | --- | --- | --- | --- | --- |
| AUDITPF | U | AUID | 1:1 + Sequential（关联历史／待恢复） | [AUDITPF-20260905-01](../files/AUDITPF.md) | 只追加的请求、处置及版本历史 |
| BATCHPF | U | BTID | 1:1 | [BATCHPF-20260905-01](../files/BATCHPF.md) | 批次恢复位置及历史处理计数 |
| INDTLPF | I | IDBATCH + IDINPUT + IDPOS | 1:1 + 1:N | [INDTLPF-20260905-01](../files/INDTLPF.md) | 不可变的原始请求行 |
| INHDRPF | I | IHBATCH + IHSEQ | 1:1 + 1:N | [INHDRPF-20260905-01](../files/INHDRPF.md) | 不可变的输入信封及原始业务头 |
| ORDDTLPF | U | ODORDER + ODLINE | 1:1 + 1:N | [ORDDTLPF-20260905-01](../files/ORDDTLPF.md) | 订单行有效需求与发货分摊基数 |
| ORDHDRPF | U | OHORDER | 1:1 | [ORDHDRPF-20260905-01](../files/ORDHDRPF.md) | 订单版本、计价快照及有效需求摘要 |
| REQPF | U | RQSRC + RQREQ | 1:1 + 1:N + Sequential（关联历史／待恢复） | [REQPF-20260905-01](../files/REQPF.md) | 去重、原始受理和本地恢复账本 |
| RTNDTLPF | U | RDRETURN + RDLINE | 1:1 + 1:N + Sequential（关联历史／待恢复） | [RTNDTLPF-20260905-01](../files/RTNDTLPF.md) | 不可变的归还事实和原发货关联 |
| RTNHDRPF | U | RHRETURN | 1:1 | [RTNHDRPF-20260905-01](../files/RTNHDRPF.md) | 不可变的退货事件头 |
| SETLDTPF | I | SLSETTL + SLLINE | 1:1 + 1:N | [SETLDTPF-20260905-01](../files/SETLDTPF.md) | 形成后不再重算的结算数量及金额明细 |
| SETLHDPF | I | SEID | 1:1 | [SETLHDPF-20260905-01](../files/SETLHDPF.md) | 正反向结算处理状态与首次成功事实 |
| SHIPDTPF | U | SDSHIP + SDLINE | 1:1 + 1:N | [SHIPDTPF-20260905-01](../files/SHIPDTPF.md) | 不可变的发货数量、仓库及金额 |
| SHIPHDPF | U | SHSHIP | 1:1 | [SHIPHDPF-20260905-01](../files/SHIPHDPF.md) | 不可变的整次发货事实 |

I=只读；U=可写，是否允许新增见 File Output。1:N 使用键前缀与完整范围循环，不可用一次 CHAIN 代替。

## Data Queue

N/A。

## Data Area

N/A。

## External Data Structure

外部描述文件的记录格式见 File Usage 和 Compile-Oriented Constraints；读取后按需要复制进独立参数／候选结构。共享 COPY 是源定义，不是新外部对象。

## Internal Data Structure

ORDCTX / ORDRES / ORDSTS 的布局与常量均引用共享契约。

主程序另外使用 CURHDR（ORDHDRPF 记录快照）、CURLINES（最多 100 条当前有效 ORDDTLPF 快照）、RECCTX（CTXDS 副本）、RESULTCTX（RESDS 副本）。它们为瞬态工作区，字段逐一继承对应定义；用于保存外层恢复上下文以及避免其他文件 I/O 覆盖当前业务基数。历史审计／退货扫描一次一条，不能按 100 行上限截断历史。

## External Program Calls

| Program | Purpose | Parameters Passed | Expected Return |
| --- | --- | --- | --- |
| ORDCHECK | 原始输入规范化以及客户、商品、数量资格校验 | CTXDS, HDRDS, RAWROWS, CHKHEAD, NORMROWS, RESDS | 精确顺序／长度与 ORDCHECK Interface Contract 一致；0000/0010/0020 或错误码 |
| ORDDAILY | 按首次成功日生成净额、未完成结算和本地待恢复快照 | CTXDS, DAYHEAD, RESDS | 精确顺序／长度与 ORDDAILY Interface Contract 一致；0000/0010/0020 或错误码 |
| ORDPRICE | 有效价格读取、客户折扣及累计数量比例分摊 | CTXDS, PRIN, PROUT, RESDS | 精确顺序／长度与 ORDPRICE Interface Contract 一致；0000/0010/0020 或错误码 |
| ORDREPLY | 业务回执和仓储结果的登记、查询与送达恢复 | CTXDS, OUTREC, RESDS | 精确顺序／长度与 ORDREPLY Interface Contract 一致；0000/0010/0020 或错误码 |
| ORDSETTL | 结算事实、原发货调整查询及结算类消息交接 | CTXDS, SETHEAD, SETROWS, SETVIEW, OUTREC, RESDS | 精确顺序／长度与 ORDSETTL Interface Contract 一致；0000/0010/0020 或错误码 |
| ORDSTOCK | 库存／占用候选规划及本地事务内应用 | CTXDS, STKIN, STKOLD, STKNEW, RESDS | 精确顺序／长度与 ORDSTOCK Interface Contract 一致；0000/0010/0020 或错误码 |

## External Subroutines

N/A：不依赖未列出的外部例程。

## Standard Subroutines

| 例程名 | 逻辑位置 | 职责 |
| --- | --- | --- |
| MINIT | Step 1 | 初始化作业参数、CTXDS、所有候选／结果缓冲及局部指示器；保留运行 DAY 为 CXPROCDAY |
| MBATCH | Step 2 | 按 BATCHPF 完整键读取；新 PROCESS 可创建 OPEN、LAST=0 的批次头，RESUME 要求批次已存在；校验 BTDAY 与当前作业日一致 |
| MINPUT | Step 3 | FOR EACH INHDRPF 以 IHBATCH=BATCH 且 IHSEQ>BTLAST 的键范围升序读取；逐笔建立输入身份 |
| MCANON | Step 4 | CALL ORDCHECK CANON，取得完整比较内容和解析状态；此时不检查当前客户、商品、库存或版本 |
| MDEDUP | Step 5 | 按来源+请求号读 REQPF |
| MENVELOPE | Step 6 | 对新请求 CALL ORDCHECK VALIDATE，再校验事件、业务身份字符集、有效日和事件载荷；IHDAY 必须等于 CXPROCDAY |
| MORDER | Step 7 | QUERY 先按原请求引用解析订单；其他需要现有订单的 MOD/ALLOC/SHIP/CANCEL/RETURN 以及已解析的 QUERY 读取 ORDHDRPF 及 FOR EACH 当前版本 ODACTIVE=Y 的 ORDDTLPF；校验实际行数、ODVERSION 与头一致 |
| MNEW | Step 8 | IF NEW 的订单已存在 → 1100；否则建立版本 1 候选，OHSHIPANY=N |
| MVALID | Step 9 | NEW/MOD 接收 MENVELOPE 中 ORDCHECK VALIDATE 返回的客户等级、规范明细及全部拒绝原因 |
| MMOD | Step 10 | MOD 必须无历史发货且未全部取消；对原头、所有当前有效行与旧分配规划结果准备逐记录审计快照 |
| MQUOTE | Step 11 | NEW/MOD 把 1–100 个新行组成 PRIN，CTXDS 使用当前受理日和客户等级，CALL ORDPRICE QUOTE |
| MPLAN | Step 12 | NEW/MOD 把新行完整数量交 ORDSTOCK；MOD 在 STKOLD 形成释放、在 STKNEW 形成新占用 |
| MVERSION | Step 13 | 全部校验完成后 CALL ORDSTOCK APPLY；写新头／行，MOD 先停用旧行并将其当前计数字段归零，再按新行更新／新增；新行 CANCEL/SHIPPED/SHPAMT=0、ODACTIVE=Y、ODVERSION=新版本 |
| MALLOC | Step 14 | ALLOC 检查订单仍有有效未取消需求；每行目标=ODQTY−ODCANCEL−ODSHIPPED，调用 ORDSTOCK ALLOC 后 APPLY，辅助程序再扣现有占用求新增缺口 |
| MCANCEL | Step 15 | CANCEL 按订单行整理输入，拒绝重复业务行或非正整数；每行取消量不得大于 ODQTY−ODCANCEL−ODSHIPPED |
| MSHIPID | Step 16 | SHIP 检查 SHIPHDPF 中发货身份不存在；已有相同身份的新请求返回冲突，不能再建正向结算 |
| MSHIPPLAN | Step 17 | FOR EACH 发货行加载原订单行与原冻结金额；原数量、累计已发量及累计分配金额组成 PRIN |
| MSHIPAMT | Step 18 | CALL ORDPRICE SHIP，用固定原行数量作分母、ODSHPAMT 作此前金额，得到各发货明细分摊；取消不改变原计价分母 |
| MSHIPAP | Step 19 | CALL ORDSTOCK APPLY；写不可变 SHIPHDPF/SHIPDTPF，增加 ODSHIPPED/ODSHPAMT 并推进订单版本、OHSHIPANY=Y |
| MRETURN | Step 20 | RETURN 检查 RTNHDRPF 中退货身份不存在，行数量为正且同一事件不重复引用原发货明细 |
| MRETBASE | Step 21 | 逐个原发货 CALL ORDSETTL FETCH/LOOKUP，正向结算必须成功；FOR EACH RTNDTLPF 显式历史扫描累计该原发货明细已接受退货量，与 SETVIEW 的已成功调整及待调整量核对 |
| MRETAMT | Step 22 | 构造按原发货明细分组的 PRIN，BASEAMT=原发货明细金额，BASEQTY=原发货量，PRIORQ=历史已接受退回量，PRIORA=已成功调整额；CALL ORDPRICE RETURN |
| MRETAP | Step 23 | CALL ORDSTOCK RETURN 再 APPLY，将数量归还原商品原仓；不更新订单需求／版本 |
| MSETGET | Step 24 | SETRES 先 CALL ORDSETTL FETCH，核对结算存在、消息指向同一结算、消息类型为 SETTLE/ADJUST/VERIFY，以及原发货关联 |
| MSETSTATE | Step 25 | 按共享迁移表判断：已 OK 的后到非成功只审计；重复 OK 不变首次成功日；有效首次 OK 写 CXPROCDAY；非当前尝试 FAIL 忽略其状态效果；UNKNOWN 只接受当前 VERIFY 的明确核实解除；当前明确失败可记 FAIL，可重试性须有 FAIL 的无业务效果语义或 RETRYOK 核实依据 |
| MSETAP | Step 26 | 将允许的目标 SETHEAD 和原消息 OUTREC 交 ORDSETTL APPLY；仅结算状态及相关消息结果变化，SH/SD/RH/RD 不删不改 |
| MDELIV | Step 27 | DELIVER 先 ORDREPLY FETCH 按消息身份读取载体；根据 OBKIND 分别调用 ORDSETTL DELIVERY 或 ORDREPLY DELIVERY |
| MRECCHK | Step 28 | RECOVER 必须有非空操作者和原因，且原关联完整 |
| MLOCAL | Step 29 | RECOVER/LOCAL 查原 REQPF，仅允许 RETRY（含未受理的退货调整等待）；保留恢复上下文副本，重读 RQBATCH/RQINPUT 的原始头与明细并从原内容重新校验当前版本／资料 |
| MRETRY | Step 30 | RECOVER/RETRY 通过 ORDSETTL FETCH 取得原业务 |
| MVERIFY | Step 31 | RECOVER/VERIFY 仅核实 UNKNOWN，CALL ORDSETTL VERIFY 登记查询 |
| MREPLY | Step 32 | RECOVER/REPLY 仅 CALL ORDREPLY RESEND，原 OBPAYLOAD、业务身份和消息身份保持不变，尝试号推进；不访问库存或创建结算 |
| MQUERY | Step 33 | QUERY 或相同请求重复投影：若原 RQEVENT=DAYEND，取 RQDAY/RQSRC/RQREQ 调 ORDDAILY FETCH 返回原快照；其他请求按 RQORDER/RQSHIP/RQRETURN/RQSETTL 及当前订单读取最新事实，结算／回执经所属辅助程序 FETCH，库存占用经 ORDSTOCK VIEW |
| MDAY | Step 34 | DAYEND 先校验请求日=当前运行日，建立稳定的未提交本地单元，再 CALL ORDDAILY SNAPSHOT；同一来源／请求快照重复返回已有结果，不积加原金额；不在日报发布中推进任何结算 |
| MPROJECT | Step 35 | 建立结果投影并 CALL ORDREPLY CREATE：包含业务结果、订单版本、履约／结算状态及上一回执送达状态；原业务重复请求的新投影允许新消息，原消息显式重送仍仅 RESEND |
| MAUDIT | Step 36 | 逐事件追加 AUDITPF，必要时按对象记录旧／新版本快照片段；每条含输入身份、业务关联、操作者、原因及前后状态 |
| MLEDGER | Step 37 | 新请求写规范账本；仅恢复可修改原请求处理状态，最新回执关联更新 RQMSG |
| MCOMMIT | Step 38 | 对包含业务、消息、审计、账本和检查点的本地单元 COMMIT；已确认成功才处理下一输入 |
| MROLL | Step 39 | 任何可确认的本地失败先 ROLBK；IF 回滚失败或状态不明 → 9000 停止 |
| MFINISH | Step 40 | 读取完该批次范围后将 BTSTATE=DONE 并提交批次结束记录；RESULT 表示批次输入完成 |

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
| 共同入口 | Step 1–6；每个新请求完成去重后适用校验 |
| NEW | Step 8–9、11–13 |
| MOD | Step 7、9–13 |
| ALLOC | Step 7、14 |
| CANCEL | Step 7、15 |
| SHIP | Step 7、16–19 |
| RETURN | Step 7、20–23 |
| SETRES | Step 24–26 |
| DELIVER | Step 27 |
| RECOVER | Step 28，再按类别进入 Step 29 / 30 / 31 / 32 |
| QUERY | Step 33；需要订单时先解析关联并执行 Step 7 |
| DAYEND | Step 34 |
| 同内容重复 | Step 5 识别后到 Step 33，跳过业务变更 |
| 正常闭合 | Step 35–38，再回 Step 3；无剩余输入时 Step 40 |
| 拒绝／可回滚失败 | Step 39；确认结果单元提交后回 Step 3；9000 停止 |

Step 1: **MINIT** — 初始化作业参数、CTXDS、所有候选／结果缓冲及局部指示器；保留运行 DAY 为 CXPROCDAY。IF ABI、日期或 MODE 不支持 → RESULT=9000 返回。 (BR-28, BR-29, BR-32)

Step 2: **MBATCH** — 按 BATCHPF 完整键读取；新 PROCESS 可创建 OPEN、LAST=0 的批次头，RESUME 要求批次已存在；校验 BTDAY 与当前作业日一致。IF DONE → 返回已有批次结果；IF 提交位置无法确认 → 停止。 (BR-27, BR-28, BR-29)

Step 3: **MINPUT** — FOR EACH INHDRPF 以 IHBATCH=BATCH 且 IHSEQ>BTLAST 的键范围升序读取；逐笔建立输入身份。FOR EACH INDTLPF 以批次、输入序号读取完整明细；读第 101 条即可记容量拒绝，不截断成合法 100 行请求。原始文件保持不变。 (BR-01, BR-05, BR-27, BR-28)

Step 4: **MCANON** — CALL ORDCHECK CANON，取得完整比较内容和解析状态；此时不检查当前客户、商品、库存或版本。IF 来源／请求标识缺失 → 以输入身份进入拒绝路径，不构造 REQPF 假键。 (BR-01, BR-06, BR-07)

Step 5: **MDEDUP** — 按来源+请求号读 REQPF。IF 已存在且 RQCANLEN／完整内容不同 → 1100，原账本不变；IF 相同 → 保留原业务日并转最近投影，原 RQSTATE=RETRY 也不能自动恢复。只有新请求进入业务处理；同一输入信封已闭合由批次检查点跳过。 (BR-06, BR-07, BR-28)

Step 6: **MENVELOPE** — 对新请求 CALL ORDCHECK VALIDATE，再校验事件、业务身份字符集、有效日和事件载荷；IHDAY 必须等于 CXPROCDAY。以新候选账本保留规范内容，尚不单独提交。IF 事件未知、必填缺失或不适用字段非空 → 1000；传输字段不参与业务规则。 (BR-01, BR-04, BR-05, BR-17, BR-18, BR-20, BR-29, BR-32)

Step 7: **MORDER** — QUERY 先按原请求引用解析订单；其他需要现有订单的 MOD/ALLOC/SHIP/CANCEL/RETURN 以及已解析的 QUERY 读取 ORDHDRPF 及 FOR EACH 当前版本 ODACTIVE=Y 的 ORDDTLPF；校验实际行数、ODVERSION 与头一致。IF MOD/ALLOC/SHIP/CANCEL 的输入版本不等于 OHVERSION → 1100。 (BR-09, BR-10, BR-19, BR-32)

Step 8: **MNEW** — IF NEW 的订单已存在 → 1100；否则建立版本 1 候选，OHSHIPANY=N。不能靠换请求标识重新创建同一订单。 (BR-08)

Step 9: **MVALID** — NEW/MOD 接收 MENVELOPE 中 ORDCHECK VALIDATE 返回的客户等级、规范明细及全部拒绝原因。IF 任一客户、商品、数量或明细结构无效 → 整笔拒绝，不先保存部分订单。 (BR-02, BR-03, BR-04, BR-05, BR-10)

Step 10: **MMOD** — MOD 必须无历史发货且未全部取消；对原头、所有当前有效行与旧分配规划结果准备逐记录审计快照。输入是完整替换，未列旧行将在接受后设 ODACTIVE=N；任何失败保留旧版本及旧占用。 (BR-10, BR-19, BR-32)

Step 11: **MQUOTE** — NEW/MOD 把 1–100 个新行组成 PRIN，CTXDS 使用当前受理日和客户等级，CALL ORDPRICE QUOTE。IF 无有效正价或金额越界 → 拒绝／数据异常；行金额与合计来自同一份候选。 (BR-03, BR-11, BR-12)

Step 12: **MPLAN** — NEW/MOD 把新行完整数量交 ORDSTOCK；MOD 在 STKOLD 形成释放、在 STKNEW 形成新占用。IF 不允许部分且不能全满足 → 候选新占用为零但订单可接受为等待；不要把库存等待等同修改校验失败。 (BR-10, BR-13, BR-14, BR-15)

Step 13: **MVERSION** — 全部校验完成后 CALL ORDSTOCK APPLY；写新头／行，MOD 先停用旧行并将其当前计数字段归零，再按新行更新／新增；新行 CANCEL/SHIPPED/SHPAMT=0、ODACTIVE=Y、ODVERSION=新版本。头金额等于候选行和，版本只推进一次；审计保留旧版本完整快照。所有写入尚在同一未提交单元。 (BR-10, BR-11, BR-12, BR-14, BR-15, BR-32)

Step 14: **MALLOC** — ALLOC 检查订单仍有有效未取消需求；每行目标=ODQTY−ODCANCEL−ODSHIPPED，调用 ORDSTOCK ALLOC 后 APPLY，辅助程序再扣现有占用求新增缺口。IF 无库存仍可闭合为等待；接受的 ALLOC 仅推进一次订单版本及当前有效行版本，不重算价格。 (BR-09, BR-13, BR-14, BR-15, BR-16, BR-19)

Step 15: **MCANCEL** — CANCEL 按订单行整理输入，拒绝重复业务行或非正整数；每行取消量不得大于 ODQTY−ODCANCEL−ODSHIPPED。CALL ORDSTOCK CANCEL 先抵消未分配需求，再以 C/B/A 释放；全部行可接受后 APPLY，并增加 ODCANCEL、推进版本。 (BR-09, BR-18, BR-19)

Step 16: **MSHIPID** — SHIP 检查 SHIPHDPF 中发货身份不存在；已有相同身份的新请求返回冲突，不能再建正向结算。保留原请求去重已在前面执行。检查本次业务行 1–100、同订单行/仓库组合唯一。 (BR-06, BR-09, BR-17, BR-23)

Step 17: **MSHIPPLAN** — FOR EACH 发货行加载原订单行与原冻结金额；原数量、累计已发量及累计分配金额组成 PRIN。同订单行多仓按 A/B/C 排序累计。CALL ORDSTOCK SHIP 验证各仓占用及同商品聚合数量；任一不满足整次不生效。 (BR-14, BR-17, BR-23)

Step 18: **MSHIPAMT** — CALL ORDPRICE SHIP，用固定原行数量作分母、ODSHPAMT 作此前金额，得到各发货明细分摊；取消不改变原计价分母。IF 舍入或累积范围异常 → 停止本笔应用。 (BR-12, BR-23)

Step 19: **MSHIPAP** — CALL ORDSTOCK APPLY；写不可变 SHIPHDPF/SHIPDTPF，增加 ODSHIPPED/ODSHPAMT 并推进订单版本、OHSHIPANY=Y。构造 SETHEAD=NEW 和 SETROWS，CALL ORDSETTL CREATE 产生唯一 S:SHIP 正向结算及待交接消息；本次所有本地对象一起提交。 (BR-14, BR-17, BR-23, BR-24)

Step 20: **MRETURN** — RETURN 检查 RTNHDRPF 中退货身份不存在，行数量为正且同一事件不重复引用原发货明细。FOR EACH 原 SHIPHDPF/SHIPDTPF 读取校验，必须属于同一订单，当前业务日与 SHDAY 相差 0–30 个自然日。 (BR-20, BR-22, BR-32)

Step 21: **MRETBASE** — 逐个原发货 CALL ORDSETTL FETCH/LOOKUP，正向结算必须成功；FOR EACH RTNDTLPF 显式历史扫描累计该原发货明细已接受退货量，与 SETVIEW 的已成功调整及待调整量核对。IF 新累计超过原发货量 → 拒绝；IF 任一原明细调整未完 → 本次不入库，RQSTATE=RETRY、RC=0010，须显式 LOCAL 恢复。 (BR-20, BR-22, BR-24)

Step 22: **MRETAMT** — 构造按原发货明细分组的 PRIN，BASEAMT=原发货明细金额，BASEQTY=原发货量，PRIORQ=历史已接受退回量，PRIORA=已成功调整额；CALL ORDPRICE RETURN。所有原明细均无未完调整时这些基数必须一致。 (BR-20, BR-22)

Step 23: **MRETAP** — CALL ORDSTOCK RETURN 再 APPLY，将数量归还原商品原仓；不更新订单需求／版本。写 RTNHDRPF/RTNDTLPF；按原发货分别 CALL ORDSETTL CREATE 生成 A:RETURN:SHIP 反向调整，原正向结算不改金额。本次库存、退货和全部调整一起提交。 (BR-21, BR-22, BR-24)

Step 24: **MSETGET** — SETRES 先 CALL ORDSETTL FETCH，核对结算存在、消息指向同一结算、消息类型为 SETTLE/ADJUST/VERIFY，以及原发货关联。IF 无关联或消息身份冲突 → 1100，仅记审计，不改业务事实。 (BR-24, BR-25, BR-32)

Step 25: **MSETSTATE** — 按共享迁移表判断：已 OK 的后到非成功只审计；重复 OK 不变首次成功日；有效首次 OK 写 CXPROCDAY；非当前尝试 FAIL 忽略其状态效果；UNKNOWN 只接受当前 VERIFY 的明确核实解除；当前明确失败可记 FAIL，可重试性须有 FAIL 的无业务效果语义或 RETRYOK 核实依据。 (BR-24, BR-25, BR-30)

Step 26: **MSETAP** — 将允许的目标 SETHEAD 和原消息 OUTREC 交 ORDSETTL APPLY；仅结算状态及相关消息结果变化，SH/SD/RH/RD 不删不改。未知、失败返回等待或待恢复业务投影，不能让它们触发第二次实物流转。 (BR-24, BR-25, BR-32)

Step 27: **MDELIV** — DELIVER 先 ORDREPLY FETCH 按消息身份读取载体；根据 OBKIND 分别调用 ORDSETTL DELIVERY 或 ORDREPLY DELIVERY。送达 OK 只能确认消息送达；结算至多由 NEW 进入 SENT，不进入业务 OK。 (BR-24, BR-26, BR-32)

Step 28: **MRECCHK** — RECOVER 必须有非空操作者和原因，且原关联完整。IF 请求要覆盖已成功业务、无核实直接重发未知结算或跳过数量资格 → 拒绝并审计；恢复自身使用新来源／请求身份，可独立去重。 (BR-06, BR-24, BR-25, BR-26, BR-31, BR-32)

Step 29: **MLOCAL** — RECOVER/LOCAL 查原 REQPF，仅允许 RETRY（含未受理的退货调整等待）；保留恢复上下文副本，重读 RQBATCH/RQINPUT 的原始头与明细并从原内容重新校验当前版本／资料。原业务日保持不变；成功后原账本转 DONE，恢复请求也闭合，均在同一提交。IF 原请求不再满足业务资格 → 记录拒绝，不伪造成功。 (BR-06, BR-09, BR-22, BR-28, BR-31)

Step 30: **MRETRY** — RECOVER/RETRY 通过 ORDSETTL FETCH 取得原业务。仅 SESTATE=FAIL 且 SERETRY=Y 可 CALL RETRY：原结算身份不变、发送尝试加一、新消息身份从本恢复事件派生；不再写发货、退货、库存。 (BR-24, BR-25, BR-31)

Step 31: **MVERIFY** — RECOVER/VERIFY 仅核实 UNKNOWN，CALL ORDSETTL VERIFY 登记查询。已存在当前未终结核实消息时返回等待；不得把查询转换为再次 SETTLE/ADJUST。 (BR-24, BR-25, BR-28, BR-31)

Step 32: **MREPLY** — RECOVER/REPLY 仅 CALL ORDREPLY RESEND，原 OBPAYLOAD、业务身份和消息身份保持不变，尝试号推进；不访问库存或创建结算。 (BR-26, BR-31)

Step 33: **MQUERY** — QUERY 或相同请求重复投影：若原 RQEVENT=DAYEND，取 RQDAY/RQSRC/RQREQ 调 ORDDAILY FETCH 返回原快照；其他请求按 RQORDER/RQSHIP/RQRETURN/RQSETTL 及当前订单读取最新事实，结算／回执经所属辅助程序 FETCH，库存占用经 ORDSTOCK VIEW。FOR EACH AUDITPF 显式按关联筛选并分消息输出；拒绝、等待及历史版本不能被当前摘要掩盖。 (BR-06, BR-26, BR-32)

Step 34: **MDAY** — DAYEND 先校验请求日=当前运行日，建立稳定的未提交本地单元，再 CALL ORDDAILY SNAPSHOT；同一来源／请求快照重复返回已有结果，不积加原金额；不在日报发布中推进任何结算。 (BR-29, BR-30, BR-32)

Step 35: **MPROJECT** — 建立结果投影并 CALL ORDREPLY CREATE：包含业务结果、订单版本、履约／结算状态及上一回执送达状态；原业务重复请求的新投影允许新消息，原消息显式重送仍仅 RESEND。仓储结果由同程序另建 WHRESULT 消息。IF 输出登记失败 → 本笔整体回滚，不能先提交业务。 (BR-06, BR-26, BR-32)

Step 36: **MAUDIT** — 逐事件追加 AUDITPF，必要时按对象记录旧／新版本快照片段；每条含输入身份、业务关联、操作者、原因及前后状态。缺业务来源的拒绝也必须通过输入身份定位；不能因规范键缺失丢掉拒绝。 (BR-01, BR-27, BR-31, BR-32)

Step 37: **MLEDGER** — 新请求写规范账本；仅恢复可修改原请求处理状态，最新回执关联更新 RQMSG。身份冲突不覆盖旧账本；重复投影只可更新 RQMSG，不改原规范内容及受理事实。记录原请求状态 DONE/REJECT/RETRY，推进 BTLAST 及输入闭合计数。 (BR-06, BR-07, BR-27, BR-28, BR-32)

Step 38: **MCOMMIT** — 对包含业务、消息、审计、账本和检查点的本地单元 COMMIT；已确认成功才处理下一输入。IF 提交返回状态不可靠 → 9000 停止，恢复时重查已提交账本；不能继续写拒绝记录并假定前次未发生。 (BR-24, BR-27, BR-28, BR-32)

Step 39: **MROLL** — 任何可确认的本地失败先 ROLBK；IF 回滚失败或状态不明 → 9000 停止。确认回滚后清空全部候选和记录缓冲；为已知拒绝／可恢复失败开启无业务副作用结果单元，写 REQPF（有键时）、AUDITPF、必要回执及 BATCHPF；结果单元失败则不推进检查点并停止。 (BR-07, BR-10, BR-17, BR-22, BR-27, BR-28, BR-32)

Step 40: **MFINISH** — 读取完该批次范围后将 BTSTATE=DONE 并提交批次结束记录；RESULT 表示批次输入完成。仍等待结算的业务保留原状态，下一批反馈继续推进；异常退出交 ORDRUN 清理。 (BR-27, BR-28)

### File Output / Update

| File | Action | Fields Modified | File Spec Ref | Condition / Steps |
| --- | --- | --- | --- | --- |
| AUDITPF | WRITE only | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | AUDITPF-20260905-01 | Step 13, Step 36, Step 39 |
| BATCHPF | WRITE / UPDATE | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | BATCHPF-20260905-01 | Step 2, Step 37, Step 39, Step 40 |
| ORDDTLPF | WRITE / UPDATE | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | ORDDTLPF-20260905-01 | Step 13, Step 14, Step 15, Step 19 |
| ORDHDRPF | WRITE / UPDATE | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | ORDHDRPF-20260905-01 | Step 13, Step 14, Step 15, Step 19 |
| REQPF | WRITE / UPDATE | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE；规范内容及首次输入关联不可改；LOCAL 可改 RQSTATE/RQRC/RQREASON 及结果关联，投影可改 RQMSG | REQPF-20260905-01 | Step 29, Step 37, Step 39 |
| RTNDTLPF | WRITE only | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | RTNDTLPF-20260905-01 | Step 23 |
| RTNHDRPF | WRITE only | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | RTNHDRPF-20260905-01 | Step 23 |
| SHIPDTPF | WRITE only | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | SHIPDTPF-20260905-01 | Step 19 |
| SHIPHDPF | WRITE only | 全部定义字段在 WRITE 显式赋值；完整键不可 UPDATE | SHIPHDPF-20260905-01 | Step 19 |

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
| BR-01 | Step 3, Step 4, Step 6, Step 36 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, INDTLPF, INHDRPF |
| BR-02 | Step 9 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-03 | Step 9, Step 11 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-04 | Step 6, Step 9 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-05 | Step 3, Step 6, Step 9 | E01 / E02 / E03 / E04（按具体失败类别） | INDTLPF, INHDRPF |
| BR-06 | Step 4, Step 5, Step 16, Step 28, Step 29, Step 33, Step 35, Step 37 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, BATCHPF, INDTLPF, INHDRPF, ORDDTLPF, ORDHDRPF, REQPF, RTNDTLPF, RTNHDRPF, SETLDTPF, SETLHDPF, SHIPDTPF, SHIPHDPF |
| BR-07 | Step 4, Step 5, Step 37, Step 39 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, BATCHPF, REQPF |
| BR-08 | Step 8 | E01 / E02 / E03 / E04（按具体失败类别） | ORDHDRPF |
| BR-09 | Step 7, Step 14, Step 15, Step 16, Step 29 | E01 / E02 / E03 / E04（按具体失败类别） | INDTLPF, INHDRPF, ORDDTLPF, ORDHDRPF, REQPF, SHIPHDPF |
| BR-10 | Step 7, Step 9, Step 10, Step 12, Step 13, Step 39 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, BATCHPF, ORDDTLPF, ORDHDRPF, REQPF |
| BR-11 | Step 11, Step 13 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, ORDDTLPF, ORDHDRPF |
| BR-12 | Step 11, Step 13, Step 18 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, ORDDTLPF, ORDHDRPF |
| BR-13 | Step 12, Step 14 | E01 / E02 / E03 / E04（按具体失败类别） | ORDDTLPF, ORDHDRPF |
| BR-14 | Step 12, Step 13, Step 14, Step 17, Step 19 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, ORDDTLPF, ORDHDRPF, SHIPDTPF, SHIPHDPF |
| BR-15 | Step 12, Step 13, Step 14 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, ORDDTLPF, ORDHDRPF |
| BR-16 | Step 14 | E01 / E02 / E03 / E04（按具体失败类别） | ORDDTLPF, ORDHDRPF |
| BR-17 | Step 6, Step 16, Step 17, Step 19, Step 39 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, BATCHPF, ORDDTLPF, ORDHDRPF, REQPF, SHIPDTPF, SHIPHDPF |
| BR-18 | Step 6, Step 15 | E01 / E02 / E03 / E04（按具体失败类别） | ORDDTLPF, ORDHDRPF |
| BR-19 | Step 7, Step 10, Step 14, Step 15 | E01 / E02 / E03 / E04（按具体失败类别） | ORDDTLPF, ORDHDRPF |
| BR-20 | Step 6, Step 20, Step 21, Step 22 | E01 / E02 / E03 / E04（按具体失败类别） | RTNDTLPF, RTNHDRPF, SHIPDTPF, SHIPHDPF |
| BR-21 | Step 23 | E01 / E02 / E03 / E04（按具体失败类别） | RTNDTLPF, RTNHDRPF |
| BR-22 | Step 20, Step 21, Step 22, Step 23, Step 29, Step 39 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, BATCHPF, INDTLPF, INHDRPF, REQPF, RTNDTLPF, RTNHDRPF, SHIPDTPF, SHIPHDPF |
| BR-23 | Step 16, Step 17, Step 18, Step 19 | E01 / E02 / E03 / E04（按具体失败类别） | ORDDTLPF, ORDHDRPF, SHIPDTPF, SHIPHDPF |
| BR-24 | Step 19, Step 21, Step 23, Step 24, Step 25, Step 26, Step 27, Step 28, Step 30, Step 31, Step 38 | E01 / E02 / E03 / E04（按具体失败类别） | ORDDTLPF, ORDHDRPF, RTNDTLPF, RTNHDRPF, SHIPDTPF, SHIPHDPF |
| BR-25 | Step 24, Step 25, Step 26, Step 28, Step 30, Step 31 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-26 | Step 27, Step 28, Step 32, Step 33, Step 35 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, ORDDTLPF, ORDHDRPF, REQPF, RTNDTLPF, RTNHDRPF, SETLDTPF, SETLHDPF, SHIPDTPF, SHIPHDPF |
| BR-27 | Step 2, Step 3, Step 36, Step 37, Step 38, Step 39, Step 40 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, BATCHPF, INDTLPF, INHDRPF, REQPF |
| BR-28 | Step 1, Step 2, Step 3, Step 5, Step 29, Step 31, Step 37, Step 38, Step 39, Step 40 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, BATCHPF, INDTLPF, INHDRPF, REQPF |
| BR-29 | Step 1, Step 2, Step 6, Step 34 | E01 / E02 / E03 / E04（按具体失败类别） | BATCHPF |
| BR-30 | Step 25, Step 34 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |
| BR-31 | Step 28, Step 29, Step 30, Step 31, Step 32, Step 36 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, INDTLPF, INHDRPF, REQPF |
| BR-32 | Step 1, Step 6, Step 7, Step 10, Step 13, Step 20, Step 24, Step 26, Step 27, Step 28, Step 33, Step 34, Step 35, Step 36, Step 37, Step 38, Step 39 | E01 / E02 / E03 / E04（按具体失败类别） | AUDITPF, BATCHPF, ORDDTLPF, ORDHDRPF, REQPF, RTNDTLPF, RTNHDRPF, SETLDTPF, SETLHDPF, SHIPDTPF, SHIPHDPF |

## Processing Considerations

单作业串行处理；显式日期，不依赖运行机器的当前日期。多记录范围及历史集合读完整，固定数组只限制单次事件候选。ORDMAIN 是正常提交／回滚所有者；辅助程序不得提交，失败由调用方整体撤销。不设置吞吐量或运行成功承诺。

## Compile-Oriented Constraints

| File | Record Format | RENAME | KLIST / KFLD 顺序 | Confidence |
| --- | --- | --- | --- | --- |
| AUDITPF | AUDITR | N/A | KAUDIT = AUID | Assumed：授权合成，未编译 |
| BATCHPF | BATCHR | N/A | KBATCH = BTID | Assumed：授权合成，未编译 |
| INDTLPF | INDTLR | N/A | KINDTL = IDBATCH + IDINPUT + IDPOS | Assumed：授权合成，未编译 |
| INHDRPF | INHDRR | N/A | KINHDR = IHBATCH + IHSEQ | Assumed：授权合成，未编译 |
| ORDDTLPF | ORDDTLR | N/A | KORDD = ODORDER + ODLINE | Assumed：授权合成，未编译 |
| ORDHDRPF | ORDHDRR | N/A | KORDH = OHORDER | Assumed：授权合成，未编译 |
| REQPF | REQR | N/A | KREQ = RQSRC + RQREQ | Assumed：授权合成，未编译 |
| RTNDTLPF | RTNDTLR | N/A | KRTND = RDRETURN + RDLINE | Assumed：授权合成，未编译 |
| RTNHDRPF | RTNHDRR | N/A | KRTNH = RHRETURN | Assumed：授权合成，未编译 |
| SETLDTPF | SETLDTR | N/A | KSETLD = SLSETTL + SLLINE | Assumed：授权合成，未编译 |
| SETLHDPF | SETLHDR | N/A | KSETLH = SEID | Assumed：授权合成，未编译 |
| SHIPDTPF | SHIPDTR | N/A | KSHIPD = SDSHIP + SDLINE | Assumed：授权合成，未编译 |
| SHIPHDPF | SHIPHDR | N/A | KSHIPH = SHSHIP | Assumed：授权合成，未编译 |

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
| L3 Full | 32 | 40 | 13 | 6 | 0 |

Traceability Complete：规格内 BR 到步骤和文件／委派入口已建立。状态 Draft；所有规则是继承规则，没有新增需求级 BR。
