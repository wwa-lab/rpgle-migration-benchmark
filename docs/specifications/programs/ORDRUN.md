# ORDRUN 程序规格

## Spec Header

- **Spec ID**：ORDRUN-20260905-01
- **Spec Level**：L3 Full
- **Version / Status**：1.0 / Draft
- **Change Type / Program Type**：New Program / CLLE
- **Program Name**：ORDRUN
- **Description**：独立演示作业入口、承诺定义生命周期和异常收尾。
- **Source TD**：[TD-20260905-01](../../design/technical-design.md) Module Allocation 行 `ORDRUN`。
- **共同输入**：[功能需求](../../requirements/functional-requirements.md)、[共享契约](../shared-contract.md)。全部字段及步骤为授权合成定义，不是对既有系统的发现。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次完整规格。

## Caller Context

由演示操作／调度端发起；传入显式批次、运行日和操作人。成功后调用方按返回码继续；失败由主程序决定回滚、记录结果或停止。辅助成功不等于事务提交。

## Functions

- 独立演示作业入口、承诺定义生命周期和异常收尾。
- 输出有身份和原因的结果，保持职责范围与静态追踪关系。

## Business Rules

继承 FS 编号，不在各程序重新从 01 编号。主责与协作分开；下面的恢复／记录引用不把所有规则所有权转移到本程序。

| BR | 需求规则 | 本程序角色 |
| --- | --- | --- |
| BR-28 | 恢复中断批次时跳过已完成请求，从未完成请求继续；“结果未知”的外部结算先核实，不能因重跑批次而重发业务。 | 协作／处理边界；主责 ORDMAIN |

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

| Field | Source | Storage | Read by | Written by | Reference | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| BATCH | Parameter | Transient | Step 1 | — | N/A | 批次身份 |
| DAY | Parameter | Transient | Step 1 | — | N/A | 执行日 YYYYMMDD |
| MODE | Parameter | Transient | Step 1 | — | N/A | PROCESS / RESUME |
| ACTOR | Parameter | Transient | Step 1 | — | N/A | 操作人 |
| RESULT | Parameter | Transient | — | Step 1, Step 6 | N/A | 统一返回码 |

## File Usage

N/A：无直接业务文件访问。

I=只读；U=可写，是否允许新增见 File Output。1:N 使用键前缀与完整范围循环，不可用一次 CHAIN 代替。

## Data Queue

N/A。

## Data Area

N/A。

## External Data Structure

N/A：CLLE 使用字符参数。

## Internal Data Structure

N/A：仅五个字符参数与本调用拥有承诺定义的局部标志。

## External Program Calls

| Program | Purpose | Parameters Passed | Expected Return |
| --- | --- | --- | --- |
| ORDMAIN | 大型固定格式业务主程序：统一事件分派、事实写入、恢复和本地提交 | BATCH, DAY, MODE, ACTOR, RESULT | 精确顺序／长度与 ORDMAIN Interface Contract 一致；0000/0010/0020 或错误码 |

## External Subroutines

N/A：不依赖未列出的外部例程。

## Standard Subroutines

| 例程名 | 逻辑位置 | 职责 |
| --- | --- | --- |
| RINIT | Step 1 | 接收 BATCH、DAY、MODE、ACTOR 五参数契约中的四个输入并初始化 RESULT=9000 |
| RCTX | Step 2 | 确认本次为独立演示作业且没有外来未结束承诺定义 |
| RSTART | Step 3 | 启动作业级共享承诺定义并登记本调用所有权；不建日志、不补主数据 |
| RCALL | Step 4 | 按完全相同顺序和字符长度 CALL ORDMAIN(BATCH,DAY,MODE,ACTOR,RESULT) |
| RCLEAN | Step 5 | 正常结束本调用拥有的承诺定义 |
| RRETURN | Step 6 | 返回 RESULT |

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
| PROCESS / RESUME | Step 1–6；任何错误仅走本调用适用的收尾，不继续主处理 |

Step 1: **RINIT** — 接收 BATCH、DAY、MODE、ACTOR 五参数契约中的四个输入并初始化 RESULT=9000。IF 日期格式、批次身份或 MODE 非 PROCESS/RESUME → 返回 1000，不调用主程序。 (BR-28)

Step 2: **RCTX** — 确认本次为独立演示作业且没有外来未结束承诺定义。IF 环境前提不成立 → 9000 退出；不得提交或回滚其他调用者的工作。 (BR-28)

Step 3: **RSTART** — 启动作业级共享承诺定义并登记本调用所有权；不建日志、不补主数据。IF 启动失败 → 9000 退出。 (BR-28)

Step 4: **RCALL** — 按完全相同顺序和字符长度 CALL ORDMAIN(BATCH,DAY,MODE,ACTOR,RESULT)。正常返回保留主程序结果码，主程序应已确认无悬挂业务事务。 (BR-28)

Step 5: **RCLEAN** — 正常结束本调用拥有的承诺定义。IF 主程序异常逃逸 → 先对本定义尝试回滚并记录作业异常摘要，再关闭；回滚不可靠仍返回 9000，不能报告业务已撤销。 (BR-28)

Step 6: **RRETURN** — 返回 RESULT。批次输入完成不代表外部结算完成；不自行重跑 ORDMAIN，不在收尾创建新业务请求。 (BR-28)

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
| BR-28 | Step 1, Step 2, Step 3, Step 4, Step 5, Step 6 | E01 / E02 / E03 / E04（按具体失败类别） | 参数／委派；参见对应调用步骤 |

## Processing Considerations

单作业串行处理；显式日期，不依赖运行机器的当前日期。多记录范围及历史集合读完整，固定数组只限制单次事件候选。ORDRUN 只清理本调用拥有的承诺定义。不设置吞吐量或运行成功承诺。

## Compile-Oriented Constraints

N/A：无 RPG 文件格式或键表。

CLLE 使用共享契约规定的字符参数，声明顺序与 ORDMAIN 一致。参考源成员 N/A；不生成编译命令。本轮只核对结构，后续源码阶段再核对列位置、具体操作码与环境兼容性。

## Programming Language

CLLE。

## Amend Data Structure

N/A：全新合成程序，尚无旧结构迁移。

## Open Questions / TBD

无阻塞本阶段的业务／字段待定项。实际 IBM i 版本与编译配置属于当前范围外，不能把 Draft 当作已编译程序。

## Spec Summary

| Level | Rules | Steps | Files | Calls | Open Questions |
| --- | --- | --- | --- | --- | --- |
| L3 Full | 1 | 6 | 0 | 1 | 0 |

Traceability Complete：规格内 BR 到步骤和文件／委派入口已建立。状态 Draft；所有规则是继承规则，没有新增需求级 BR。
