# OUTBYST 文件规格

## Spec Header

- **Spec ID**：OUTBYST-20260905-01
- **Spec Level / Output Mode**：L3 Full / Full Spec
- **Version / Status**：1.0 / Draft
- **File Type / Change Type**：LF / New File
- **Source TD**：[技术设计](../../design/technical-design.md) Objects Affected 行 `OUTBYST`。
- **合成来源**：用户授权自行制定字段、长度和键；不描述真实系统。库不适用，后续源成员容器名约定 QDDSSRC。
- **机器契约**：[OUTBYST.json](OUTBYST.json)。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次定义。

## File Overview

按种类和送达进度读取回执。明确选取基础 PF 的全部字段、全部记录；无 JOIN，无 Select/Omit。读用 LF 不改变 PF 数据。

## Record Formats

| Format ID | Name | Fields |
| --- | --- | --- |
| FMT-01 | OUTBOXR | 16 |

## Field Definitions

所有字段不允许 NULL、没有 DFT 关键字；A 字段 CCSID=37，P 字段 CCSID 不适用。Edit Code/Edit Word 不设置，Col Heading 等于字段名，额外 DDS Keywords 为空。字段均为新增合成定义。

| ID | 字段 | DDS 类型 | 长度 | 小数 | 含义 |
| --- | --- | --- | --- | --- | --- |
| FLD-01 | OBID | A | 80 | N/A | 唯一消息身份 |
| FLD-02 | OBKIND | A | 8 | N/A | SETTLE / ADJUST / VERIFY / RECEIPT / WHRESULT |
| FLD-03 | OBBIZID | A | 48 | N/A | 结算身份或回执关联业务身份 |
| FLD-04 | OBSRC | A | 12 | N/A | 请求来源 |
| FLD-05 | OBREQ | A | 20 | N/A | 请求标识 |
| FLD-06 | OBBATCH | A | 20 | N/A | 原始输入批次 |
| FLD-07 | OBINPUT | P | 9 | 0 | 原始输入序号 |
| FLD-08 | OBORDER | A | 20 | N/A | 订单 |
| FLD-09 | OBSTATE | A | 8 | N/A | NEW / SENT / OK / FAIL |
| FLD-10 | OBRESULT | A | 8 | N/A | NONE / OK / FAIL / UNKNOWN / RETRYOK，业务反馈与送达分开 |
| FLD-11 | OBRESDAY | A | 8 | N/A | 业务反馈处理日；无反馈为空 |
| FLD-12 | OBATTEMPT | P | 9 | 0 | 消息送达尝试次数 |
| FLD-13 | OBDAY | A | 8 | N/A | 创建处理日 |
| FLD-14 | OBLEN | P | 9 | 0 | 有效负载长度 |
| FLD-15 | OBPAYLOAD | A | 30000 | N/A | 带版本的完整消息内容，长度外为空格 |
| FLD-16 | OBREASON | A | 120 | N/A | 最近送达原因 |

## Key Definition

完整键 UNIQUE；部分键对应多记录范围。

| 序号 | 字段 | Field Ref | 方向 |
| --- | --- | --- | --- |
| 1 | OBKIND | FLD-02 | ASCEND |
| 2 | OBSTATE | FLD-09 | ASCEND |
| 3 | OBID | FLD-01 | ASCEND |

## Based-On Physical Files

[OUTBOXPF](OUTBOXPF.md)，Spec ID `OUTBOXPF-20260905-01`，记录格式 `OUTBOXR`。

## Select/Omit Criteria

无筛选；全部记录可见。无 JOIN。

## Field Selection / Mapping

全部字段按基础 PF 顺序和属性继承，无字段重命名。RPG 同时声明相关格式时使用技术设计别名 `OUTBYSR`；该别名不改变 DDS 格式。

## Validation Rules

检查字段类型／长度／精度、名称、ID、键引用、字段数量及必需章节；LF 额外逐字段核对 PF 继承。规则代码见机器契约。

## Business Rules

| 局部编号 | 定义 | 范围 |
| --- | --- | --- |
| BR-01 | 本文件完整键唯一；前缀可以返回多条记录。 | 仅当前文件；全限定引用 OUTBYST-20260905-01:BR-01 |

业务流程规则仍引用 FS-20260905-01，不在文件局部重新编号。

## Related Objects

| Program | 关系 | Spec |
| --- | --- | --- |
| ORDREPLY | Read | [ORDREPLY-20260905-01](../programs/ORDREPLY.md) |

## Processing Considerations

一个记录格式、单成员、键访问；估算记录字节 30375（A 按单字节，P 按压缩十进制计算）。原始输入只读；写用对象参加调用者承诺控制。部署、日志和授权未配置，应用初始化不能依赖默认值。

## Change Impact

additive：全部为新定义，无现有对象需重编译。

## Confidence Assessment

MEDIUM：字段是明确标注的合成设定；尚无编译或运行证据。

## Open Questions / TBD

无阻塞本规格的结构待定项；运行环境留在项目范围外。

## Spec Summary

| Formats | Fields | Keys | Local Rules | Open Questions | Mode |
| --- | --- | --- | --- | --- | --- |
| 1 | 16 | 3 | 1 | 0 | Full Spec / Draft |
