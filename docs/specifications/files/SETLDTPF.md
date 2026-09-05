# SETLDTPF 文件规格

## Spec Header

- **Spec ID**：SETLDTPF-20260905-01
- **Spec Level / Output Mode**：L3 Full / Full Spec
- **Version / Status**：1.0 / Draft
- **File Type / Change Type**：PF / New File
- **Source TD**：[技术设计](../../design/technical-design.md) Objects Affected 行 `SETLDTPF`。
- **合成来源**：用户授权自行制定字段、长度和键；不描述真实系统。库不适用，后续源成员容器名约定 QDDSSRC。
- **机器契约**：[SETLDTPF.json](SETLDTPF.json)。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次定义。

## File Overview

形成后不再重算的结算数量及金额明细。

## Record Formats

| Format ID | Name | Fields |
| --- | --- | --- |
| FMT-01 | SETLDTR | 10 |

## Field Definitions

所有字段不允许 NULL、没有 DFT 关键字；A 字段 CCSID=37，P 字段 CCSID 不适用。Edit Code/Edit Word 不设置，Col Heading 等于字段名，额外 DDS Keywords 为空。字段均为新增合成定义。

| ID | 字段 | DDS 类型 | 长度 | 小数 | 含义 |
| --- | --- | --- | --- | --- | --- |
| FLD-01 | SLSETTL | A | 48 | N/A | 结算身份 |
| FLD-02 | SLLINE | P | 5 | 0 | 结算内明细序号 |
| FLD-03 | SLSHIP | A | 20 | N/A | 原发货 |
| FLD-04 | SLSHLINE | P | 5 | 0 | 原发货明细 |
| FLD-05 | SLRETURN | A | 20 | N/A | 反向来源退货，正向为空 |
| FLD-06 | SLRTLINE | P | 5 | 0 | 反向来源退货明细；正向 0 |
| FLD-07 | SLORDER | A | 20 | N/A | 原订单 |
| FLD-08 | SLORDLINE | P | 5 | 0 | 原订单行 |
| FLD-09 | SLQTY | P | 9 | 0 | 结算／调整对应数量 |
| FLD-10 | SLAMOUNT | P | 15 | 2 | 金额绝对值 |

## Key Definition

完整键 UNIQUE；部分键对应多记录范围。

| 序号 | 字段 | Field Ref | 方向 |
| --- | --- | --- | --- |
| 1 | SLSETTL | FLD-01 | ASCEND |
| 2 | SLLINE | FLD-02 | ASCEND |

## Constraints

CST-01：完整键唯一。未声明 DDS 外键、CHECK、VALUES 或 RANGE；业务合法性由程序规格规定。

## Validation Rules

检查字段类型／长度／精度、名称、ID、键引用、字段数量及必需章节；LF 额外逐字段核对 PF 继承。规则代码见机器契约。

## Business Rules

| 局部编号 | 定义 | 范围 |
| --- | --- | --- |
| BR-01 | 本文件完整键唯一；前缀可以返回多条记录。 | 仅当前文件；全限定引用 SETLDTPF-20260905-01:BR-01 |

业务流程规则仍引用 FS-20260905-01，不在文件局部重新编号。

## Related Objects

| Program | 关系 | Spec |
| --- | --- | --- |
| ORDDAILY | Read | [ORDDAILY-20260905-01](../programs/ORDDAILY.md) |
| ORDMAIN | Read | [ORDMAIN-20260905-01](../programs/ORDMAIN.md) |
| ORDSETTL | Read / Write | [ORDSETTL-20260905-01](../programs/ORDSETTL.md) |

## Processing Considerations

一个记录格式、单成员、键访问；估算记录字节 133（A 按单字节，P 按压缩十进制计算）。原始输入只读；写用对象参加调用者承诺控制。部署、日志和授权未配置，应用初始化不能依赖默认值。

## Change Impact

additive：全部为新定义，无现有对象需重编译。

## Confidence Assessment

MEDIUM：字段是明确标注的合成设定；尚无编译或运行证据。

## Open Questions / TBD

无阻塞本规格的结构待定项；运行环境留在项目范围外。

## Spec Summary

| Formats | Fields | Keys | Local Rules | Open Questions | Mode |
| --- | --- | --- | --- | --- | --- |
| 1 | 10 | 2 | 1 | 0 | Full Spec / Draft |
