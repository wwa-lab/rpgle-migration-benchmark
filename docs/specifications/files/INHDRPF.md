# INHDRPF 文件规格

## Spec Header

- **Spec ID**：INHDRPF-20260905-01
- **Spec Level / Output Mode**：L3 Full / Full Spec
- **Version / Status**：1.0 / Draft
- **File Type / Change Type**：PF / New File
- **Source TD**：[技术设计](../../design/technical-design.md) Objects Affected 行 `INHDRPF`。
- **合成来源**：用户授权自行制定字段、长度和键；不描述真实系统。库不适用，后续源成员容器名约定 QDDSSRC。
- **机器契约**：[INHDRPF.json](INHDRPF.json)。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次定义。

## File Overview

不可变的输入信封及原始业务头。数字和日期业务字段先以字符接收；物理批次与序号是载体约束，业务必填在程序内判断。

## Record Formats

| Format ID | Name | Fields |
| --- | --- | --- |
| FMT-01 | INHDRR | 23 |

## Field Definitions

所有字段不允许 NULL、没有 DFT 关键字；A 字段 CCSID=37，P 字段 CCSID 不适用。Edit Code/Edit Word 不设置，Col Heading 等于字段名，额外 DDS Keywords 为空。字段均为新增合成定义。

| ID | 字段 | DDS 类型 | 长度 | 小数 | 含义 |
| --- | --- | --- | --- | --- | --- |
| FLD-01 | IHBATCH | A | 20 | N/A | 原始批次 |
| FLD-02 | IHSEQ | P | 9 | 0 | 原始输入序号，1 起且批次内唯一 |
| FLD-03 | IHSRC | A | 12 | N/A | 业务来源，允许原始空值进入拒绝路径 |
| FLD-04 | IHREQ | A | 20 | N/A | 请求标识 |
| FLD-05 | IHEVENT | A | 8 | N/A | 事件编码 |
| FLD-06 | IHDAY | A | 8 | N/A | 原请求业务日 |
| FLD-07 | IHARRDAY | A | 8 | N/A | 到达日期，传输包装 |
| FLD-08 | IHARRTIME | A | 6 | N/A | 到达时刻，传输包装 |
| FLD-09 | IHORDER | A | 20 | N/A | 订单身份 |
| FLD-10 | IHVERSION | A | 9 | N/A | 期望订单版本原文 |
| FLD-11 | IHCUST | A | 12 | N/A | 客户 |
| FLD-12 | IHPART | A | 1 | N/A | 部分履约 Y/N |
| FLD-13 | IHSHIP | A | 20 | N/A | 本次发货身份 |
| FLD-14 | IHRETURN | A | 20 | N/A | 本次退货身份 |
| FLD-15 | IHSETTL | A | 48 | N/A | 被反馈或恢复的结算身份 |
| FLD-16 | IHMSG | A | 80 | N/A | 关联出站消息身份 |
| FLD-17 | IHRESULT | A | 8 | N/A | 反馈结果 |
| FLD-18 | IHACTION | A | 8 | N/A | 恢复类别 |
| FLD-19 | IHREFSRC | A | 12 | N/A | 被恢复请求来源 |
| FLD-20 | IHREFREQ | A | 20 | N/A | 被恢复请求标识 |
| FLD-21 | IHACTOR | A | 20 | N/A | 操作者 |
| FLD-22 | IHREASON | A | 120 | N/A | 处置原因或反馈说明 |
| FLD-23 | IHNLINE | A | 5 | N/A | 业务明细条数原文 |

## Key Definition

完整键 UNIQUE；部分键对应多记录范围。

| 序号 | 字段 | Field Ref | 方向 |
| --- | --- | --- | --- |
| 1 | IHBATCH | FLD-01 | ASCEND |
| 2 | IHSEQ | FLD-02 | ASCEND |

## Constraints

CST-01：完整键唯一。未声明 DDS 外键、CHECK、VALUES 或 RANGE；业务合法性由程序规格规定。

## Validation Rules

检查字段类型／长度／精度、名称、ID、键引用、字段数量及必需章节；LF 额外逐字段核对 PF 继承。规则代码见机器契约。

## Business Rules

| 局部编号 | 定义 | 范围 |
| --- | --- | --- |
| BR-01 | 本文件完整键唯一；前缀可以返回多条记录。 | 仅当前文件；全限定引用 INHDRPF-20260905-01:BR-01 |

业务流程规则仍引用 FS-20260905-01，不在文件局部重新编号。

## Related Objects

| Program | 关系 | Spec |
| --- | --- | --- |
| ORDMAIN | Read | [ORDMAIN-20260905-01](../programs/ORDMAIN.md) |

## Processing Considerations

一个记录格式、单成员、键访问；估算记录字节 490（A 按单字节，P 按压缩十进制计算）。原始输入只读；写用对象参加调用者承诺控制。部署、日志和授权未配置，应用初始化不能依赖默认值。

## Change Impact

additive：全部为新定义，无现有对象需重编译。

## Confidence Assessment

MEDIUM：字段是明确标注的合成设定；尚无编译或运行证据。

## Open Questions / TBD

无阻塞本规格的结构待定项；运行环境留在项目范围外。

## Spec Summary

| Formats | Fields | Keys | Local Rules | Open Questions | Mode |
| --- | --- | --- | --- | --- | --- |
| 1 | 23 | 2 | 1 | 0 | Full Spec / Draft |
