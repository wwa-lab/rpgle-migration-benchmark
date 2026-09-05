# REQPF 文件规格

## Spec Header

- **Spec ID**：REQPF-20260905-01
- **Spec Level / Output Mode**：L3 Full / Full Spec
- **Version / Status**：1.0 / Draft
- **File Type / Change Type**：PF / New File
- **Source TD**：[技术设计](../../design/technical-design.md) Objects Affected 行 `REQPF`。
- **合成来源**：用户授权自行制定字段、长度和键；不描述真实系统。库不适用，后续源成员容器名约定 QDDSSRC。
- **机器契约**：[REQPF.json](REQPF.json)。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次定义。

## File Overview

去重、原始受理和本地恢复账本。缺来源或请求标识时不写伪造键；由 AUDITPF 使用输入身份记录。结算最新进度从结算事实读取，不覆盖原发货已接受事实。

## Record Formats

| Format ID | Name | Fields |
| --- | --- | --- |
| FMT-01 | REQR | 17 |

## Field Definitions

所有字段不允许 NULL、没有 DFT 关键字；A 字段 CCSID=37，P 字段 CCSID 不适用。Edit Code/Edit Word 不设置，Col Heading 等于字段名，额外 DDS Keywords 为空。字段均为新增合成定义。

| ID | 字段 | DDS 类型 | 长度 | 小数 | 含义 |
| --- | --- | --- | --- | --- | --- |
| FLD-01 | RQSRC | A | 12 | N/A | 规范来源 |
| FLD-02 | RQREQ | A | 20 | N/A | 规范请求标识 |
| FLD-03 | RQBATCH | A | 20 | N/A | 首次出现批次 |
| FLD-04 | RQINPUT | P | 9 | 0 | 首次输入序号 |
| FLD-05 | RQEVENT | A | 8 | N/A | 原请求事件 |
| FLD-06 | RQDAY | A | 8 | N/A | 原请求处理日 |
| FLD-07 | RQCANLEN | P | 9 | 0 | 规范内容实际长度 |
| FLD-08 | RQCANON | A | 24000 | N/A | 完整规范内容，不以哈希替代比较 |
| FLD-09 | RQORDER | A | 20 | N/A | 关联订单 |
| FLD-10 | RQSHIP | A | 20 | N/A | 关联发货 |
| FLD-11 | RQRETURN | A | 20 | N/A | 关联退货 |
| FLD-12 | RQSETTL | A | 48 | N/A | 单项结算关联，多个时沿退货查询 |
| FLD-13 | RQSTATE | A | 8 | N/A | DONE / REJECT / RETRY，指原请求本地处理 |
| FLD-14 | RQRC | A | 4 | N/A | 最近一次原请求本地处理结果 |
| FLD-15 | RQREASON | A | 120 | N/A | 结果原因 |
| FLD-16 | RQVERSION | P | 9 | 0 | 本地接受后订单版本，非最新订单版本缓存 |
| FLD-17 | RQMSG | A | 80 | N/A | 最近一次结果投影的回执消息身份；原始请求内容保持不变 |

## Key Definition

完整键 UNIQUE；部分键对应多记录范围。

| 序号 | 字段 | Field Ref | 方向 |
| --- | --- | --- | --- |
| 1 | RQSRC | FLD-01 | ASCEND |
| 2 | RQREQ | FLD-02 | ASCEND |

## Constraints

CST-01：完整键唯一。未声明 DDS 外键、CHECK、VALUES 或 RANGE；业务合法性由程序规格规定。

## Validation Rules

检查字段类型／长度／精度、名称、ID、键引用、字段数量及必需章节；LF 额外逐字段核对 PF 继承。规则代码见机器契约。

## Business Rules

| 局部编号 | 定义 | 范围 |
| --- | --- | --- |
| BR-01 | 本文件完整键唯一；前缀可以返回多条记录。 | 仅当前文件；全限定引用 REQPF-20260905-01:BR-01 |

业务流程规则仍引用 FS-20260905-01，不在文件局部重新编号。

## Related Objects

| Program | 关系 | Spec |
| --- | --- | --- |
| ORDDAILY | Read | [ORDDAILY-20260905-01](../programs/ORDDAILY.md) |
| ORDMAIN | Read / Write | [ORDMAIN-20260905-01](../programs/ORDMAIN.md) |

## Processing Considerations

一个记录格式、单成员、键访问；估算记录字节 24403（A 按单字节，P 按压缩十进制计算）。原始输入只读；写用对象参加调用者承诺控制。部署、日志和授权未配置，应用初始化不能依赖默认值。

## Change Impact

additive：全部为新定义，无现有对象需重编译。

## Confidence Assessment

MEDIUM：字段是明确标注的合成设定；尚无编译或运行证据。

## Open Questions / TBD

无阻塞本规格的结构待定项；运行环境留在项目范围外。

## Spec Summary

| Formats | Fields | Keys | Local Rules | Open Questions | Mode |
| --- | --- | --- | --- | --- | --- |
| 1 | 17 | 2 | 1 | 0 | Full Spec / Draft |
