# 文件与程序规格索引

这套规格把 [技术设计](../design/technical-design.md) 的对象与流程展开为生成所需的字段、键、参数和处理步骤。全部为合成场景，状态 Draft；后续生成的源码及检查记录见 [源码索引](../source/README.md)，测试数据尚未生成。

## 阅读顺序

1. [共享字段、调用与状态契约](shared-contract.md)：先看身份、状态、容量、舍入、恢复和调用布局。
2. 根据下表阅读相关 File Spec；每个文件同时提供 Markdown 和 JSON。
3. 阅读 [ORDMAIN 程序规格](programs/ORDMAIN.md)，再沿调用进入配套程序。

[机器索引](specification-index.json) 保存对象、引用、规则、逻辑步骤和依赖，用于静态交叉检查。它不执行流水线，也不是另一份任务清单。

[静态检查记录](validation-report.md)列出本轮结构、引用和示例算术的核对结果。

## 文件规格

| 对象 | 类型 | 用途 | 文档 | 机器契约 |
| --- | --- | --- | --- | --- |
| BATCHPF | PF | 批次恢复位置及历史处理计数 | [BATCHPF](files/BATCHPF.md) | [JSON](files/BATCHPF.json) |
| INHDRPF | PF | 不可变的输入信封及原始业务头 | [INHDRPF](files/INHDRPF.md) | [JSON](files/INHDRPF.json) |
| INDTLPF | PF | 不可变的原始请求行 | [INDTLPF](files/INDTLPF.md) | [JSON](files/INDTLPF.json) |
| REQPF | PF | 去重、原始受理和本地恢复账本 | [REQPF](files/REQPF.md) | [JSON](files/REQPF.json) |
| CUSTPF | PF | 合成客户资料 | [CUSTPF](files/CUSTPF.md) | [JSON](files/CUSTPF.json) |
| ITEMPF | PF | 合成商品资料 | [ITEMPF](files/ITEMPF.md) | [JSON](files/ITEMPF.json) |
| PRICEPF | PF | 按商品与日期选取有效价格 | [PRICEPF](files/PRICEPF.md) | [JSON](files/PRICEPF.json) |
| WHSEPF | PF | 仓库资格和固定优先顺序 | [WHSEPF](files/WHSEPF.md) | [JSON](files/WHSEPF.json) |
| STOCKPF | PF | 商品仓库实物及占用总量 | [STOCKPF](files/STOCKPF.md) | [JSON](files/STOCKPF.json) |
| ORDHDRPF | PF | 订单版本、计价快照及有效需求摘要 | [ORDHDRPF](files/ORDHDRPF.md) | [JSON](files/ORDHDRPF.json) |
| ORDDTLPF | PF | 订单行有效需求与发货分摊基数 | [ORDDTLPF](files/ORDDTLPF.md) | [JSON](files/ORDDTLPF.json) |
| ALLOCPF | PF | 订单行到仓库的占用关联 | [ALLOCPF](files/ALLOCPF.md) | [JSON](files/ALLOCPF.json) |
| SHIPHDPF | PF | 不可变的整次发货事实 | [SHIPHDPF](files/SHIPHDPF.md) | [JSON](files/SHIPHDPF.json) |
| SHIPDTPF | PF | 不可变的发货数量、仓库及金额 | [SHIPDTPF](files/SHIPDTPF.md) | [JSON](files/SHIPDTPF.json) |
| RTNHDRPF | PF | 不可变的退货事件头 | [RTNHDRPF](files/RTNHDRPF.md) | [JSON](files/RTNHDRPF.json) |
| RTNDTLPF | PF | 不可变的归还事实和原发货关联 | [RTNDTLPF](files/RTNDTLPF.md) | [JSON](files/RTNDTLPF.json) |
| SETLHDPF | PF | 正反向结算处理状态与首次成功事实 | [SETLHDPF](files/SETLHDPF.md) | [JSON](files/SETLHDPF.json) |
| SETLDTPF | PF | 形成后不再重算的结算数量及金额明细 | [SETLDTPF](files/SETLDTPF.md) | [JSON](files/SETLDTPF.json) |
| OUTBOXPF | PF | 按消息身份保存出站内容与送达状态 | [OUTBOXPF](files/OUTBOXPF.md) | [JSON](files/OUTBOXPF.json) |
| AUDITPF | PF | 只追加的请求、处置及版本历史 | [AUDITPF](files/AUDITPF.md) | [JSON](files/AUDITPF.json) |
| DAYRPTPF | PF | 日报头与可追溯组成行 | [DAYRPTPF](files/DAYRPTPF.md) | [JSON](files/DAYRPTPF.json) |
| SETLBYDAY | LF | 按状态及首次成功日读取结算 | [SETLBYDAY](files/SETLBYDAY.md) | [JSON](files/SETLBYDAY.json) |
| SETLBYREF | LF | 按原发货定位正反向结算 | [SETLBYREF](files/SETLBYREF.md) | [JSON](files/SETLBYREF.json) |
| OUTBYST | LF | 按种类和送达进度读取回执 | [OUTBYST](files/OUTBYST.md) | [JSON](files/OUTBYST.json) |

## 程序规格

| 程序 | 职责 | 逻辑步骤 | 文档 |
| --- | --- | --- | --- |
| ORDRUN | 独立演示作业入口、承诺定义生命周期和异常收尾 | 6 | [ORDRUN](programs/ORDRUN.md) |
| ORDMAIN | 大型固定格式业务主程序：统一事件分派、事实写入、恢复和本地提交 | 40 | [ORDMAIN](programs/ORDMAIN.md) |
| ORDCHECK | 原始输入规范化以及客户、商品、数量资格校验 | 7 | [ORDCHECK](programs/ORDCHECK.md) |
| ORDPRICE | 有效价格读取、客户折扣及累计数量比例分摊 | 6 | [ORDPRICE](programs/ORDPRICE.md) |
| ORDSTOCK | 库存／占用候选规划及本地事务内应用 | 11 | [ORDSTOCK](programs/ORDSTOCK.md) |
| ORDSETTL | 结算事实、原发货调整查询及结算类消息交接 | 10 | [ORDSETTL](programs/ORDSETTL.md) |
| ORDREPLY | 业务回执和仓储结果的登记、查询与送达恢复 | 7 | [ORDREPLY](programs/ORDREPLY.md) |
| ORDDAILY | 按首次成功日生成净额、未完成结算和本地待恢复快照 | 7 | [ORDDAILY](programs/ORDDAILY.md) |

## 规格边界

24 份文件规格、8 份程序规格和 1 份共享契约构成本阶段交付。文件局部 BR 使用带 specId 的全限定引用；程序 BR 沿用需求 BR-01～BR-32。结构性检查不等于业务运行测试。完整规格保留在生成／评审侧，不能直接进入被测模型输入包。
