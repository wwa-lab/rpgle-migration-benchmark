# INDTLPF 文件规格

## Spec Header

- **Spec ID**：INDTLPF-20260905-01
- **Spec Level / Output Mode**：L3 Full / Full Spec
- **Version / Status**：1.0 / Draft
- **File Type / Change Type**：PF / New File
- **Source TD**：[技术设计](../../design/technical-design.md) Objects Affected 行 `INDTLPF`。
- **合成来源**：用户授权自行制定字段、长度和键；不描述真实系统。库不适用，后续源成员容器名约定 QDDSSRC。
- **机器契约**：[INDTLPF.json](INDTLPF.json)。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次定义。

## File Overview

不可变的原始请求行。物理位置与业务明细号分开，可保留重复业务行号或非法数量以供拒绝分析。

## Record Formats

| Format ID | Name | Fields |
| --- | --- | --- |
| FMT-01 | INDTLR | 9 |

## Field Definitions

所有字段不允许 NULL、没有 DFT 关键字；A 字段 CCSID=37，P 字段 CCSID 不适用。Edit Code/Edit Word 不设置，Col Heading 等于字段名，额外 DDS Keywords 为空。字段均为新增合成定义。

| ID | 字段 | DDS 类型 | 长度 | 小数 | 含义 |
| --- | --- | --- | --- | --- | --- |
| FLD-01 | IDBATCH | A | 20 | N/A | 原始批次 |
| FLD-02 | IDINPUT | P | 9 | 0 | 输入序号 |
| FLD-03 | IDPOS | P | 5 | 0 | 传输行位置，1 起 |
| FLD-04 | IDLINE | A | 5 | N/A | 订单明细号或事件行号原文 |
| FLD-05 | IDITEM | A | 12 | N/A | 商品 |
| FLD-06 | IDQTY | A | 12 | N/A | 数量原文 |
| FLD-07 | IDWH | A | 1 | N/A | 仓库 A/B/C |
| FLD-08 | IDSHIP | A | 20 | N/A | 退货所引用的原发货身份 |
| FLD-09 | IDSHLINE | A | 5 | N/A | 原发货明细号原文 |

## Key Definition

完整键 UNIQUE；部分键对应多记录范围。

| 序号 | 字段 | Field Ref | 方向 |
| --- | --- | --- | --- |
| 1 | IDBATCH | FLD-01 | ASCEND |
| 2 | IDINPUT | FLD-02 | ASCEND |
| 3 | IDPOS | FLD-03 | ASCEND |

## Constraints

CST-01：完整键唯一。未声明 DDS 外键、CHECK、VALUES 或 RANGE；业务合法性由程序规格规定。

## Validation Rules

检查字段类型／长度／精度、名称、ID、键引用、字段数量及必需章节；LF 额外逐字段核对 PF 继承。规则代码见机器契约。

## Business Rules

| 局部编号 | 定义 | 范围 |
| --- | --- | --- |
| BR-01 | 本文件完整键唯一；前缀可以返回多条记录。 | 仅当前文件；全限定引用 INDTLPF-20260905-01:BR-01 |

业务流程规则仍引用 FS-20260905-01，不在文件局部重新编号。

## Related Objects

| Program | 关系 | Spec |
| --- | --- | --- |
| ORDMAIN | Read | [ORDMAIN-20260905-01](../programs/ORDMAIN.md) |

## Processing Considerations

一个记录格式、单成员、键访问；估算记录字节 83（A 按单字节，P 按压缩十进制计算）。原始输入只读；写用对象参加调用者承诺控制。部署、日志和授权未配置，应用初始化不能依赖默认值。

## Change Impact

additive：全部为新定义，无现有对象需重编译。

## Confidence Assessment

MEDIUM：字段是明确标注的合成设定；尚无编译或运行证据。

## Open Questions / TBD

无阻塞本规格的结构待定项；运行环境留在项目范围外。

## Spec Summary

| Formats | Fields | Keys | Local Rules | Open Questions | Mode |
| --- | --- | --- | --- | --- | --- |
| 1 | 9 | 3 | 1 | 0 | Full Spec / Draft |
