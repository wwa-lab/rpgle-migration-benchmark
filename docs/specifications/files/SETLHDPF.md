# SETLHDPF 文件规格

## Spec Header

- **Spec ID**：SETLHDPF-20260905-01
- **Spec Level / Output Mode**：L3 Full / Full Spec
- **Version / Status**：1.0 / Draft
- **File Type / Change Type**：PF / New File
- **Source TD**：[技术设计](../../design/technical-design.md) Objects Affected 行 `SETLHDPF`。
- **合成来源**：用户授权自行制定字段、长度和键；不描述真实系统。库不适用，后续源成员容器名约定 QDDSSRC。
- **机器契约**：[SETLHDPF.json](SETLHDPF.json)。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次定义。

## File Overview

正反向结算处理状态与首次成功事实。

## Record Formats

| Format ID | Name | Fields |
| --- | --- | --- |
| FMT-01 | SETLHDR | 15 |

## Field Definitions

所有字段不允许 NULL、没有 DFT 关键字；A 字段 CCSID=37，P 字段 CCSID 不适用。Edit Code/Edit Word 不设置，Col Heading 等于字段名，额外 DDS Keywords 为空。字段均为新增合成定义。

| ID | 字段 | DDS 类型 | 长度 | 小数 | 含义 |
| --- | --- | --- | --- | --- | --- |
| FLD-01 | SEID | A | 48 | N/A | 正向 S:发货 或反向 A:退货:原发货 |
| FLD-02 | SEKIND | A | 1 | N/A | P 正向 / R 反向 |
| FLD-03 | SESHIP | A | 20 | N/A | 原发货，正反向均必填 |
| FLD-04 | SERETURN | A | 20 | N/A | 反向来源退货，正向为空 |
| FLD-05 | SEORIG | A | 48 | N/A | 反向的原正向结算，正向为空 |
| FLD-06 | SEORDER | A | 20 | N/A | 原订单 |
| FLD-07 | SECREATED | A | 8 | N/A | 创建业务日 |
| FLD-08 | SESTATE | A | 8 | N/A | NEW / SENT / OK / FAIL / UNKNOWN |
| FLD-09 | SEAMOUNT | P | 15 | 2 | 结算金额，正反向都存非负数 |
| FLD-10 | SEFIRSTDAY | A | 8 | N/A | 首次认定成功日；未成功为空格 |
| FLD-11 | SEATTEMPT | P | 9 | 0 | 本业务发送尝试号，初值 1 |
| FLD-12 | SELASTMSG | A | 80 | N/A | 当前发送或核实消息 |
| FLD-13 | SENLINE | P | 5 | 0 | 结算明细数 |
| FLD-14 | SERETRY | A | 1 | N/A | 是否已有明确可重试证据 Y/N |
| FLD-15 | SEREASON | A | 120 | N/A | 最近有效结果说明 |

## Key Definition

完整键 UNIQUE；部分键对应多记录范围。

| 序号 | 字段 | Field Ref | 方向 |
| --- | --- | --- | --- |
| 1 | SEID | FLD-01 | ASCEND |

## Constraints

CST-01：完整键唯一。未声明 DDS 外键、CHECK、VALUES 或 RANGE；业务合法性由程序规格规定。

## Validation Rules

检查字段类型／长度／精度、名称、ID、键引用、字段数量及必需章节；LF 额外逐字段核对 PF 继承。规则代码见机器契约。

## Business Rules

| 局部编号 | 定义 | 范围 |
| --- | --- | --- |
| BR-01 | 本文件完整键唯一；前缀可以返回多条记录。 | 仅当前文件；全限定引用 SETLHDPF-20260905-01:BR-01 |

业务流程规则仍引用 FS-20260905-01，不在文件局部重新编号。

## Related Objects

| Program | 关系 | Spec |
| --- | --- | --- |
| ORDMAIN | Read | [ORDMAIN-20260905-01](../programs/ORDMAIN.md) |
| ORDSETTL | Read / Write | [ORDSETTL-20260905-01](../programs/ORDSETTL.md) |

## Processing Considerations

一个记录格式、单成员、键访问；估算记录字节 398（A 按单字节，P 按压缩十进制计算）。原始输入只读；写用对象参加调用者承诺控制。部署、日志和授权未配置，应用初始化不能依赖默认值。

## Change Impact

additive：全部为新定义，无现有对象需重编译。

## Confidence Assessment

MEDIUM：字段是明确标注的合成设定；尚无编译或运行证据。

## Open Questions / TBD

无阻塞本规格的结构待定项；运行环境留在项目范围外。

## Spec Summary

| Formats | Fields | Keys | Local Rules | Open Questions | Mode |
| --- | --- | --- | --- | --- | --- |
| 1 | 15 | 1 | 1 | 0 | Full Spec / Draft |
