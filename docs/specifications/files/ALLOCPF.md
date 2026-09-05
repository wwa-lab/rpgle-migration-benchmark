# ALLOCPF 文件规格

## Spec Header

- **Spec ID**：ALLOCPF-20260905-01
- **Spec Level / Output Mode**：L3 Full / Full Spec
- **Version / Status**：1.0 / Draft
- **File Type / Change Type**：PF / New File
- **Source TD**：[技术设计](../../design/technical-design.md) Objects Affected 行 `ALLOCPF`。
- **合成来源**：用户授权自行制定字段、长度和键；不描述真实系统。库不适用，后续源成员容器名约定 QDDSSRC。
- **机器契约**：[ALLOCPF.json](ALLOCPF.json)。

## Amendment History

1.0 · 2026-09-05 · Codex · 首次定义。

## File Overview

订单行到仓库的占用关联。修改替换版本时旧分配归零并留审计；零占用行不被删除，商品与计数按新版本初始化。

## Record Formats

| Format ID | Name | Fields |
| --- | --- | --- |
| FMT-01 | ALLOCR | 7 |

## Field Definitions

所有字段不允许 NULL、没有 DFT 关键字；A 字段 CCSID=37，P 字段 CCSID 不适用。Edit Code/Edit Word 不设置，Col Heading 等于字段名，额外 DDS Keywords 为空。字段均为新增合成定义。

| ID | 字段 | DDS 类型 | 长度 | 小数 | 含义 |
| --- | --- | --- | --- | --- | --- |
| FLD-01 | ALORDER | A | 20 | N/A | 订单 |
| FLD-02 | ALLINE | P | 5 | 0 | 明细 |
| FLD-03 | ALWH | A | 1 | N/A | 仓库 |
| FLD-04 | ALITEM | A | 12 | N/A | 本版本商品 |
| FLD-05 | ALRESVD | P | 9 | 0 | 尚未发货的占用 |
| FLD-06 | ALSHIPPED | P | 9 | 0 | 该分配已用于发货累计 |
| FLD-07 | ALRELEASE | P | 9 | 0 | 该分配取消释放累计 |

## Key Definition

完整键 UNIQUE；部分键对应多记录范围。

| 序号 | 字段 | Field Ref | 方向 |
| --- | --- | --- | --- |
| 1 | ALORDER | FLD-01 | ASCEND |
| 2 | ALLINE | FLD-02 | ASCEND |
| 3 | ALWH | FLD-03 | ASCEND |

## Constraints

CST-01：完整键唯一。未声明 DDS 外键、CHECK、VALUES 或 RANGE；业务合法性由程序规格规定。

## Validation Rules

检查字段类型／长度／精度、名称、ID、键引用、字段数量及必需章节；LF 额外逐字段核对 PF 继承。规则代码见机器契约。

## Business Rules

| 局部编号 | 定义 | 范围 |
| --- | --- | --- |
| BR-01 | 本文件完整键唯一；前缀可以返回多条记录。 | 仅当前文件；全限定引用 ALLOCPF-20260905-01:BR-01 |

业务流程规则仍引用 FS-20260905-01，不在文件局部重新编号。

## Related Objects

| Program | 关系 | Spec |
| --- | --- | --- |
| ORDSTOCK | Read / Write | [ORDSTOCK-20260905-01](../programs/ORDSTOCK.md) |

## Processing Considerations

一个记录格式、单成员、键访问；估算记录字节 51（A 按单字节，P 按压缩十进制计算）。原始输入只读；写用对象参加调用者承诺控制。部署、日志和授权未配置，应用初始化不能依赖默认值。

## Change Impact

additive：全部为新定义，无现有对象需重编译。

## Confidence Assessment

MEDIUM：字段是明确标注的合成设定；尚无编译或运行证据。

## Open Questions / TBD

无阻塞本规格的结构待定项；运行环境留在项目范围外。

## Spec Summary

| Formats | Fields | Keys | Local Rules | Open Questions | Mode |
| --- | --- | --- | --- | --- | --- |
| 1 | 7 | 3 | 1 | 0 | Full Spec / Draft |
