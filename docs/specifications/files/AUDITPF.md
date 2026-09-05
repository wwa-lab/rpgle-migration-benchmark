# AUDITPF 文件规格

## Spec Header

- **Spec ID**：AUDITPF-20260905-01
- **Spec Level / Output Mode**：L3 Full / Full Spec
- **Version / Status**：1.0 / Draft
- **File Type / Change Type**：PF / New File
- **Source TD**：[技术设计](../../design/technical-design.md) Objects Affected 行 `AUDITPF`。
- **合成来源**：用户授权自行制定字段、长度和键；不描述真实系统。库不适用，后续源成员容器名约定 QDDSSRC。
- **机器契约**：[AUDITPF.json](AUDITPF.json)。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次定义。

## File Overview

只追加的请求、处置及版本历史。历史查询按批次／请求／订单等关联显式扫描；一条记录容不下时分成多条带事件序号的快照片段，不截断。

## Record Formats

| Format ID | Name | Fields |
| --- | --- | --- |
| FMT-01 | AUDITR | 18 |

## Field Definitions

所有字段不允许 NULL、没有 DFT 关键字；A 字段 CCSID=37，P 字段 CCSID 不适用。Edit Code/Edit Word 不设置，Col Heading 等于字段名，额外 DDS Keywords 为空。字段均为新增合成定义。

| ID | 字段 | DDS 类型 | 长度 | 小数 | 含义 |
| --- | --- | --- | --- | --- | --- |
| FLD-01 | AUID | A | 64 | N/A | 批次:输入序号:事件序号 |
| FLD-02 | AUBATCH | A | 20 | N/A | 输入批次 |
| FLD-03 | AUINPUT | P | 9 | 0 | 输入序号 |
| FLD-04 | AUSRC | A | 12 | N/A | 请求来源，可为空 |
| FLD-05 | AUREQ | A | 20 | N/A | 请求标识，可为空 |
| FLD-06 | AUDAY | A | 8 | N/A | 本次处理日 |
| FLD-07 | AUEVENT | A | 8 | N/A | 事件类别 |
| FLD-08 | AUORDER | A | 20 | N/A | 订单 |
| FLD-09 | AUSHIP | A | 20 | N/A | 发货 |
| FLD-10 | AURETURN | A | 20 | N/A | 退货 |
| FLD-11 | AUSETTL | A | 48 | N/A | 结算 |
| FLD-12 | AUMSG | A | 80 | N/A | 消息 |
| FLD-13 | AUACTOR | A | 20 | N/A | 操作人 |
| FLD-14 | AUREASON | A | 120 | N/A | 原因 |
| FLD-15 | AURC | A | 4 | N/A | 结果码 |
| FLD-16 | AUBEFORE | A | 8 | N/A | 变更前状态 |
| FLD-17 | AUAFTER | A | 8 | N/A | 变更后状态 |
| FLD-18 | AUDETAIL | A | 24000 | N/A | 结构化事实或版本快照片段 |

## Key Definition

完整键 UNIQUE；部分键对应多记录范围。

| 序号 | 字段 | Field Ref | 方向 |
| --- | --- | --- | --- |
| 1 | AUID | FLD-01 | ASCEND |

## Constraints

CST-01：完整键唯一。未声明 DDS 外键、CHECK、VALUES 或 RANGE；业务合法性由程序规格规定。

## Validation Rules

检查字段类型／长度／精度、名称、ID、键引用、字段数量及必需章节；LF 额外逐字段核对 PF 继承。规则代码见机器契约。

## Business Rules

| 局部编号 | 定义 | 范围 |
| --- | --- | --- |
| BR-01 | 本文件完整键唯一；前缀可以返回多条记录。 | 仅当前文件；全限定引用 AUDITPF-20260905-01:BR-01 |

业务流程规则仍引用 FS-20260905-01，不在文件局部重新编号。

## Related Objects

| Program | 关系 | Spec |
| --- | --- | --- |
| ORDMAIN | Read / Write | [ORDMAIN-20260905-01](../programs/ORDMAIN.md) |

## Processing Considerations

一个记录格式、单成员、键访问；估算记录字节 24485（A 按单字节，P 按压缩十进制计算）。原始输入只读；写用对象参加调用者承诺控制。部署、日志和授权未配置，应用初始化不能依赖默认值。

## Change Impact

additive：全部为新定义，无现有对象需重编译。

## Confidence Assessment

MEDIUM：字段是明确标注的合成设定；尚无编译或运行证据。

## Open Questions / TBD

无阻塞本规格的结构待定项；运行环境留在项目范围外。

## Spec Summary

| Formats | Fields | Keys | Local Rules | Open Questions | Mode |
| --- | --- | --- | --- | --- | --- |
| 1 | 18 | 1 | 1 | 0 | Full Spec / Draft |
