# ORDHDRPF 文件规格

## Spec Header

- **Spec ID**：ORDHDRPF-20260905-01
- **Spec Level / Output Mode**：L3 Full / Full Spec
- **Version / Status**：1.0 / Draft
- **File Type / Change Type**：PF / New File
- **Source TD**：[技术设计](../../design/technical-design.md) Objects Affected 行 `ORDHDRPF`。
- **合成来源**：用户授权自行制定字段、长度和键；不描述真实系统。库不适用，后续源成员容器名约定 QDDSSRC。
- **机器契约**：[ORDHDRPF.json](ORDHDRPF.json)。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次定义。

## File Overview

订单版本、计价快照及有效需求摘要。

## Record Formats

| Format ID | Name | Fields |
| --- | --- | --- |
| FMT-01 | ORDHDRR | 13 |

## Field Definitions

所有字段不允许 NULL、没有 DFT 关键字；A 字段 CCSID=37，P 字段 CCSID 不适用。Edit Code/Edit Word 不设置，Col Heading 等于字段名，额外 DDS Keywords 为空。字段均为新增合成定义。

| ID | 字段 | DDS 类型 | 长度 | 小数 | 含义 |
| --- | --- | --- | --- | --- | --- |
| FLD-01 | OHORDER | A | 20 | N/A | 订单身份 |
| FLD-02 | OHVERSION | P | 9 | 0 | 当前版本，初次为 1 |
| FLD-03 | OHCUST | A | 12 | N/A | 客户 |
| FLD-04 | OHTIER | A | 1 | N/A | 本版本计价客户等级 |
| FLD-05 | OHPART | A | 1 | N/A | Y/N |
| FLD-06 | OHDAY | A | 8 | N/A | 订单首次业务日 |
| FLD-07 | OHPRCDAY | A | 8 | N/A | 当前版本取价日 |
| FLD-08 | OHNLINE | P | 5 | 0 | 当前订单明细数 |
| FLD-09 | OHAMOUNT | P | 15 | 2 | 当前版本行金额合计 |
| FLD-10 | OHSTATE | A | 8 | N/A | ACTIVE / CANCEL / CLOSED |
| FLD-11 | OHSHIPANY | A | 1 | N/A | 是否曾有发货 Y/N |
| FLD-12 | OHSRC | A | 12 | N/A | 最近业务更新请求来源 |
| FLD-13 | OHREQ | A | 20 | N/A | 最近业务更新请求标识 |

## Key Definition

完整键 UNIQUE；部分键对应多记录范围。

| 序号 | 字段 | Field Ref | 方向 |
| --- | --- | --- | --- |
| 1 | OHORDER | FLD-01 | ASCEND |

## Constraints

CST-01：完整键唯一。未声明 DDS 外键、CHECK、VALUES 或 RANGE；业务合法性由程序规格规定。

## Validation Rules

检查字段类型／长度／精度、名称、ID、键引用、字段数量及必需章节；LF 额外逐字段核对 PF 继承。规则代码见机器契约。

## Business Rules

| 局部编号 | 定义 | 范围 |
| --- | --- | --- |
| BR-01 | 本文件完整键唯一；前缀可以返回多条记录。 | 仅当前文件；全限定引用 ORDHDRPF-20260905-01:BR-01 |

业务流程规则仍引用 FS-20260905-01，不在文件局部重新编号。

## Related Objects

| Program | 关系 | Spec |
| --- | --- | --- |
| ORDMAIN | Read / Write | [ORDMAIN-20260905-01](../programs/ORDMAIN.md) |

## Processing Considerations

一个记录格式、单成员、键访问；估算记录字节 107（A 按单字节，P 按压缩十进制计算）。原始输入只读；写用对象参加调用者承诺控制。部署、日志和授权未配置，应用初始化不能依赖默认值。

## Change Impact

additive：全部为新定义，无现有对象需重编译。

## Confidence Assessment

MEDIUM：字段是明确标注的合成设定；尚无编译或运行证据。

## Open Questions / TBD

无阻塞本规格的结构待定项；运行环境留在项目范围外。

## Spec Summary

| Formats | Fields | Keys | Local Rules | Open Questions | Mode |
| --- | --- | --- | --- | --- | --- |
| 1 | 13 | 1 | 1 | 0 | Full Spec / Draft |
