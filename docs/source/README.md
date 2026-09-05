# 源码与静态检查索引

- **交付标识：** SRC-20260905-01
- **版本与状态：** 1.0 Draft，合成静态分析候选
- **依据：** [需求 1.2](../requirements/functional-requirements.md)、[技术设计 1.1](../design/technical-design.md)、[程序／文件规格](../specifications/README.md)

源码阶段生成 35 个源码文件：7 个固定格式 RPGLE（含主程序）、1 个 CLLE、24 个 DDS（21 PF / 3 LF）及 3 个 COPY。全部源码共 13,918 个物理行。未编译、未运行 IBM i 程序，未生成交易数据、装载脚本或模型结果。后续已完成[统一评测包](../../benchmark/README.md)。

## 从哪里开始

1. [ORDRUN.clle](../../src/QCLLESRC/ORDRUN.clle)：显式批次、处理日和调用者入口，承诺定义所有权及异常收尾。
2. [ORDMAIN.rpgle](../../src/QRPGLESRC/ORDMAIN.rpgle)：事件分派、订单／发货／退货事实、结果投影、去重、恢复、审计及提交。
3. 沿主程序 CALL 阅读配套程序；字段及参数以 [共享契约](../specifications/shared-contract.md) 和 [COPY](../../src/QRPGLESRC/ORDCTX.rpgleinc) 为准。
4. [检查记录](validation-report.md) 区分已检查的结构项目与尚无编译、运行证据的部分。

[静态检查明细](static-checks.json) 包含源码校验值、程序步骤位置、实际文件读写、调用参数以及行数。它属于生成／评审材料，不进入被测模型输入包。

## 程序规模

| 程序 | 总物理行 | 空行 | 注释行 | 非空非注释行 |
| --- | ---: | ---: | ---: | ---: |
| [ORDMAIN](../../src/QRPGLESRC/ORDMAIN.rpgle) | 10,114 | 119 | 204 | 9,791 |
| [ORDCHECK](../../src/QRPGLESRC/ORDCHECK.rpgle) | 493 | 9 | 19 | 465 |
| [ORDPRICE](../../src/QRPGLESRC/ORDPRICE.rpgle) | 251 | 6 | 15 | 230 |
| [ORDSTOCK](../../src/QRPGLESRC/ORDSTOCK.rpgle) | 757 | 13 | 28 | 716 |
| [ORDSETTL](../../src/QRPGLESRC/ORDSETTL.rpgle) | 769 | 12 | 26 | 731 |
| [ORDREPLY](../../src/QRPGLESRC/ORDREPLY.rpgle) | 291 | 7 | 17 | 267 |
| [ORDDAILY](../../src/QRPGLESRC/ORDDAILY.rpgle) | 348 | 8 | 19 | 321 |

主程序 10,114 行满足 BC-02；COPY 不展开计入主程序。非空非注释行包括声明、键定义、参数、固定格式续行、字段序列化与错误检查，不能等同于独立业务规则或有效业务语句数量。

主程序的 119 个子程序均可从入口静态追踪到。体量来自业务生命周期、跨文件核对、调用结果契约、逐字段证据编码和分事件结果输出；没有添加空子程序、重复整段业务实现或未调用的占位流程。复用的记录编码服务于历史审计与查询输出。

## 配套源码

| 类型 | 入口 | 内容 |
| --- | --- | --- |
| CL 驱动 | [ORDRUN](../../src/QCLLESRC/ORDRUN.clle) | 63 行；参数顺序与 ORDMAIN 相同 |
| 共享输入 | [ORDCTX](../../src/QRPGLESRC/ORDCTX.rpgleinc) | 上下文、原始输入、金额／库存候选和结算载体 |
| 共享输出 | [ORDRES](../../src/QRPGLESRC/ORDRES.rpgleinc) | 返回码、规范行、金额／库存结果、消息和日报头 |
| 常量 | [ORDSTS](../../src/QRPGLESRC/ORDSTS.rpgleinc) | ABI 版本与统一返回码 |
| DDS | [BATCHPF 示例](../../src/QDDSSRC/BATCHPF.dds) | 24 个成员；下表列出完整清单 |

- [ALLOCPF.dds](../../src/QDDSSRC/ALLOCPF.dds)
- [AUDITPF.dds](../../src/QDDSSRC/AUDITPF.dds)
- [BATCHPF.dds](../../src/QDDSSRC/BATCHPF.dds)
- [CUSTPF.dds](../../src/QDDSSRC/CUSTPF.dds)
- [DAYRPTPF.dds](../../src/QDDSSRC/DAYRPTPF.dds)
- [INDTLPF.dds](../../src/QDDSSRC/INDTLPF.dds)
- [INHDRPF.dds](../../src/QDDSSRC/INHDRPF.dds)
- [ITEMPF.dds](../../src/QDDSSRC/ITEMPF.dds)
- [ORDDTLPF.dds](../../src/QDDSSRC/ORDDTLPF.dds)
- [ORDHDRPF.dds](../../src/QDDSSRC/ORDHDRPF.dds)
- [OUTBOXPF.dds](../../src/QDDSSRC/OUTBOXPF.dds)
- [OUTBYST.dds](../../src/QDDSSRC/OUTBYST.dds)
- [PRICEPF.dds](../../src/QDDSSRC/PRICEPF.dds)
- [REQPF.dds](../../src/QDDSSRC/REQPF.dds)
- [RTNDTLPF.dds](../../src/QDDSSRC/RTNDTLPF.dds)
- [RTNHDRPF.dds](../../src/QDDSSRC/RTNHDRPF.dds)
- [SETLBYDAY.dds](../../src/QDDSSRC/SETLBYDAY.dds)
- [SETLBYREF.dds](../../src/QDDSSRC/SETLBYREF.dds)
- [SETLDTPF.dds](../../src/QDDSSRC/SETLDTPF.dds)
- [SETLHDPF.dds](../../src/QDDSSRC/SETLHDPF.dds)
- [SHIPDTPF.dds](../../src/QDDSSRC/SHIPDTPF.dds)
- [SHIPHDPF.dds](../../src/QDDSSRC/SHIPHDPF.dds)
- [STOCKPF.dds](../../src/QDDSSRC/STOCKPF.dds)
- [WHSEPF.dds](../../src/QDDSSRC/WHSEPF.dds)

## 本轮实现约定

这些是合成样本的实现细化，沿用已有契约，不新增真实外部对象或业务规则。

- 源码均为 ASCII，固定格式 RPGLE 和 DDS 保持 80 列以内；字符数据字段按规格声明 CCSID 37。DDS `TEXT` 使用字段标识，中文业务释义保留在文件规格中。
- `QRPGLESRC`、`QCLLESRC`、`QDDSSRC` 是源码容器名称。`/COPY QRPGLESRC,ORDCTX` 等引用使用成员名；磁盘扩展名用于仓库识别。没有配置实际库、日志、对象授权或部署环境。
- COPY 按 `U_<结构名>` 条件引入；参数结构维持字段顺序、packed 精度及数组容量，未加入指针。最大单参数为 OUTREC 的 30,375 字节。
- 编码采用已有 ABI `0001` 与长度前缀。审计、查询和分事件回执可带字段名；长消息分成有原对象身份、总长及起点的片段，容量失败显式返回错误，不截取成成功结果。
- 日期由作业及原请求显式传入。18:00 分日仍属于接入端的合成运营背景，核心没有凭空推算到达时点。评测包的简短 Operation Flow 背景已单独说明这一设定。
- ORDMAIN 保存正常提交和回滚边界。ORDRUN 只在独立批次入口取得自身作业级承诺定义，启动失败不取得所有权；异常清理保留 9000，不声称未知提交已撤销。
- 本轮增加了原始输入留痕、不可变发货／退货与结算的交叉核对、辅助程序返回契约检查。它们只读已有事实或写现有审计／回执，不增加外部系统。

## 评测材料边界

本目录、完整规格、校验明细和技能属于评审侧。开发源码仍含 BR/Step 标记、字段含义与实现说明，不能直接把整个项目作为模型输入。

统一输入文件、最小操作／系统背景、统一提示词与四类 Flow 输出要求已冻结为 [RPGFLOW-1.0](../../benchmark/README.md)。评测版清理源码注释并保留物理行号，转换及校验值保存在评审侧；开发源码未因打包而改变。模型评测尚未执行。
