# 共享字段、调用与状态契约

Spec ID：SHARED-20260905-01 · 1.0 · Draft · 全部是授权合成设定。

本文是程序规格共用的数据契约，不是另一份需求或技术设计。业务含义以 [功能需求](../requirements/functional-requirements.md) 为准；文件字段以各 File Spec 为准。[机器契约](shared-contract.json) 保存相同的布局与接口。

## 标量、编码与容量

文件字符字段使用 CCSID 37，样本内容只使用其可表达的英文字母、数字和标点；中文仅存在于文档。所有身份区分大小写，去除右侧填充空格，不移除内部空格；业务身份只允许字母、数字、下划线、短横线，冒号留给内部复合身份。所有日期是经过日历合法性校验的 YYYYMMDD，未成功结算的首次成功日为空格，不能写伪造日期。输入到达日／时间只属于传输包装。

数量 P(9,0)，业务订单数量仍按 BR-04 限制 1–9999；单价 P(11,4)，行／订单／结算金额 P(15,2)，日报金额 P(19,2)。内部乘除临时值 P(31,12)；乘法先扩宽，按 half-up 舍入到两位。数组容量按下表固定，超出时拒绝本次输入并保留原文，不截断、覆盖或循环复用。历史记录流式扫描，不把历史总条数限为数组容量。

每个调用参数按位置、引用传递，DS 不启用对齐／隐式 padding；P 字节数=floor(位数/2)+1，A 按长度计。数组按记录顺序连续存储，整组长度见表；调用前初始化输出和未使用槽位。CTXDS.CXCOUNT 是普通行数组的有效数；库存方案以各行 SPUSE 区分有效项，两个 300 行数组均按固定容量检查。ABI=0001；不支持版本须在写入前返回 9000。

IBM 依据：[DDS 压缩十进制长度示例](https://www.ibm.com/docs/en/i/7.4.0?topic=dds-example-describing-physical-file-using)、[固定格式公共列约定](https://www.ibm.com/docs/en/i/7.6.0?topic=specifications-common-entries)。这里给出的是拟生成布局，尚未通过 IBM i 编译验证。

## COPY 成员布局

ORDCTX 保存上下文及输入结构，ORDRES 保存结果／候选结构，ORDSTS 保存下述事件、状态和返回码常量。它们目前只是规格，尚未生成 COPY 源码。

| 结构 | 成员 | 每项字节 | 容量 | 参数总字节 | 说明 |
| --- | --- | --- | --- | --- | --- |
| CTXDS | ORDCTX | 455 | 1 | 455 | 逐字段定义如下 |
| RESDS | ORDRES | 153 | 1 | 153 | 逐字段定义如下 |
| HDRDS | ORDCTX | 490 | 1 | 490 | 逐字段定义如下 |
| RAWROWS | ORDCTX | 83 | 100 | 8300 | 逐字段定义如下 |
| CHKHEAD | ORDRES | 24014 | 1 | 24014 | 逐字段定义如下 |
| NORMROWS | ORDRES | 44 | 100 | 4400 | 逐字段定义如下 |
| PRIN | ORDCTX | 94 | 100 | 9400 | 逐字段定义如下 |
| PROUT | ORDRES | 33 | 100 | 3300 | 逐字段定义如下 |
| STKIN | ORDCTX | 26 | 100 | 2600 | 逐字段定义如下 |
| STKOLD | ORDRES | 79 | 300 | 23700 | MOD 原分配释放方案；其他事件为空。 |
| STKNEW | ORDRES | 79 | 300 | 23700 | 新候选方案；APPLY 同时验证两个数组，库存按商品仓库聚合更新一次。 |
| SETHEAD | ORDCTX | 398 | 1 | 398 | 逐字段定义如下 |
| SETROWS | ORDCTX | 133 | 100 | 13300 | 逐字段定义如下 |
| SETVIEW | ORDRES | 17 | 100 | 1700 | 逐字段定义如下 |
| OUTREC | ORDRES | 30375 | 1 | 30375 | 逐字段定义如下 |
| DAYHEAD | ORDRES | 188 | 1 | 188 | 逐字段定义如下 |

### CTXDS

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| CXABI | A | 4 | N/A | 1 | 0001 |
| CXBATCH | A | 20 | N/A | 5 | 输入批次 |
| CXINPUT | P | 9 | 0 | 25 | 输入序号 |
| CXDAY | A | 8 | N/A | 30 | 原请求业务日 |
| CXPROCDAY | A | 8 | N/A | 38 | 当前执行处理日 |
| CXSRC | A | 12 | N/A | 46 | 请求来源 |
| CXREQ | A | 20 | N/A | 58 | 请求身份 |
| CXEVENT | A | 8 | N/A | 78 | 业务事件 |
| CXACTION | A | 8 | N/A | 86 | 本次辅助调用动作 |
| CXORDER | A | 20 | N/A | 94 | 订单 |
| CXVERSION | P | 9 | 0 | 114 | 期望订单版本 |
| CXACTOR | A | 20 | N/A | 119 | 人工操作人 |
| CXREASON | A | 120 | N/A | 139 | 人工原因 |
| CXSHIP | A | 20 | N/A | 259 | 发货 |
| CXRETURN | A | 20 | N/A | 279 | 退货 |
| CXSETTL | A | 48 | N/A | 299 | 结算身份 |
| CXMSG | A | 80 | N/A | 347 | 原消息身份 |
| CXPART | A | 1 | N/A | 427 | 部分履约 Y/N |
| CXTIER | A | 1 | N/A | 428 | S/P |
| CXCOUNT | P | 5 | 0 | 429 | 本次数组有效行数 |
| CXOUTSEQ | P | 5 | 0 | 432 | 同一输入同种消息的确定性序号，1 起 |
| CXEXPECT | A | 8 | N/A | 435 | 主程序读取到的旧结算状态 |
| CXATTEMPT | P | 9 | 0 | 443 | 主程序读取到的旧结算尝试 |
| CXFEED | A | 8 | N/A | 448 | 原始反馈 OK/FAIL/UNKNOWN/RETRYOK/SENT |

### RESDS

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| RSRC | A | 4 | N/A | 1 | 0000 成功 / 0010 等待 / 0020 重复 / 1000 拒绝 / 1100 冲突 / 2000 数据问题 / 3000 本地失败 / 9000 停止 |
| RSREASON | A | 120 | N/A | 5 | 可解释原因 |
| RSINDEX | P | 5 | 0 | 125 | 问题行号，0 为头或系统 |
| RSCOUNT | P | 5 | 0 | 128 | 输出行数 |
| RSAMOUNT | P | 19 | 2 | 131 | 合计或日报净额 |
| RSSTATE | A | 8 | N/A | 141 | 结果状态 |
| RSVERSION | P | 9 | 0 | 149 | 结果订单版本 |

### HDRDS

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| IHBATCH | A | 20 | N/A | 1 | 原始批次 |
| IHSEQ | P | 9 | 0 | 21 | 原始输入序号，1 起且批次内唯一 |
| IHSRC | A | 12 | N/A | 26 | 业务来源，允许原始空值进入拒绝路径 |
| IHREQ | A | 20 | N/A | 38 | 请求标识 |
| IHEVENT | A | 8 | N/A | 58 | 事件编码 |
| IHDAY | A | 8 | N/A | 66 | 原请求业务日 |
| IHARRDAY | A | 8 | N/A | 74 | 到达日期，传输包装 |
| IHARRTIME | A | 6 | N/A | 82 | 到达时刻，传输包装 |
| IHORDER | A | 20 | N/A | 88 | 订单身份 |
| IHVERSION | A | 9 | N/A | 108 | 期望订单版本原文 |
| IHCUST | A | 12 | N/A | 117 | 客户 |
| IHPART | A | 1 | N/A | 129 | 部分履约 Y/N |
| IHSHIP | A | 20 | N/A | 130 | 本次发货身份 |
| IHRETURN | A | 20 | N/A | 150 | 本次退货身份 |
| IHSETTL | A | 48 | N/A | 170 | 被反馈或恢复的结算身份 |
| IHMSG | A | 80 | N/A | 218 | 关联出站消息身份 |
| IHRESULT | A | 8 | N/A | 298 | 反馈结果 |
| IHACTION | A | 8 | N/A | 306 | 恢复类别 |
| IHREFSRC | A | 12 | N/A | 314 | 被恢复请求来源 |
| IHREFREQ | A | 20 | N/A | 326 | 被恢复请求标识 |
| IHACTOR | A | 20 | N/A | 346 | 操作者 |
| IHREASON | A | 120 | N/A | 366 | 处置原因或反馈说明 |
| IHNLINE | A | 5 | N/A | 486 | 业务明细条数原文 |

### RAWROWS

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| IDBATCH | A | 20 | N/A | 1 | 原始批次 |
| IDINPUT | P | 9 | 0 | 21 | 输入序号 |
| IDPOS | P | 5 | 0 | 26 | 传输行位置，1 起 |
| IDLINE | A | 5 | N/A | 29 | 订单明细号或事件行号原文 |
| IDITEM | A | 12 | N/A | 34 | 商品 |
| IDQTY | A | 12 | N/A | 46 | 数量原文 |
| IDWH | A | 1 | N/A | 58 | 仓库 A/B/C |
| IDSHIP | A | 20 | N/A | 59 | 退货所引用的原发货身份 |
| IDSHLINE | A | 5 | N/A | 79 | 原发货明细号原文 |

### CHKHEAD

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| CHVERSION | P | 9 | 0 | 1 | 解析后的版本 |
| CHTIER | A | 1 | N/A | 6 | 客户等级 |
| CHCOUNT | P | 5 | 0 | 7 | 规范明细数 |
| CHLEN | P | 9 | 0 | 10 | 规范内容实际长度 |
| CHCANON | A | 24000 | N/A | 15 | 规范内容 |

### NORMROWS

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| NRLINE | P | 5 | 0 | 1 | 业务行号 |
| NRITEM | A | 12 | N/A | 4 | 商品 |
| NRQTY | P | 9 | 0 | 16 | 整数数量 |
| NRWH | A | 1 | N/A | 21 | 仓库 |
| NRSHIP | A | 20 | N/A | 22 | 原发货 |
| NRSHLINE | P | 5 | 0 | 42 | 原发货行 |

### PRIN

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| PIGROUP | A | 48 | N/A | 1 | 金额累计组：订单行或原发货行 |
| PILINE | P | 5 | 0 | 49 | 本次顺序 |
| PIITEM | A | 12 | N/A | 52 | 商品 |
| PIQTY | P | 9 | 0 | 64 | 订单报价量或本次流转量 |
| PIBASEQTY | P | 9 | 0 | 69 | 比例分母：原订单量或原发货量 |
| PIPRIORQ | P | 9 | 0 | 74 | 本次前累计发货／退货数量 |
| PIBASEAMT | P | 15 | 2 | 79 | 原行／原发货金额 |
| PIPRIORA | P | 15 | 2 | 87 | 此前已分配发货额／已成功调整额 |

### PROUT

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| POLINE | P | 5 | 0 | 1 | 本次行顺序 |
| POUNIT | P | 11 | 4 | 4 | 报价单价；比例模式回传 0 |
| PORATE | P | 5 | 4 | 10 | 报价系数；比例模式回传 0 |
| POAMOUNT | P | 15 | 2 | 13 | 当前行金额或本次分摊额 |
| POCUMQTY | P | 9 | 0 | 21 | 更新后累计数量 |
| POCUMAMT | P | 15 | 2 | 26 | 更新后累计金额 |

### STKIN

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| SILINE | P | 5 | 0 | 1 | 原订单明细号 |
| SIITEM | A | 12 | N/A | 4 | 商品 |
| SIWH | A | 1 | N/A | 16 | SHIP / RETURN 指定仓库，其他动作空格 |
| SIQTY | P | 9 | 0 | 17 | 当前目标待满足量或本次动作量 |
| SIREMAIN | P | 9 | 0 | 22 | 取消前有效剩余量；非取消动作设 0 |

### STKOLD

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| SPLINE | P | 5 | 0 | 1 | 订单行 |
| SPITEM | A | 12 | N/A | 4 | 库存商品 |
| SPWH | A | 1 | N/A | 16 | 仓库 |
| SPONHAND | P | 9 | 0 | 17 | 计划前库存 |
| SPRESVD | P | 9 | 0 | 22 | 计划前总占用 |
| SPONDELTA | P | 9 | 0 | 27 | 本行实物变化，可为负 |
| SPRSDELTA | P | 9 | 0 | 32 | 本行总占用变化，可为负 |
| SPOLDITEM | A | 12 | N/A | 37 | 原分配商品或空格 |
| SPOLDRES | P | 9 | 0 | 49 | 原行占用 |
| SPOLDSHIP | P | 9 | 0 | 54 | 原行已发货 |
| SPOLDREL | P | 9 | 0 | 59 | 原行已释放 |
| SPNEWRES | P | 9 | 0 | 64 | 新行占用 |
| SPNEWSHIP | P | 9 | 0 | 69 | 新行已发货 |
| SPNEWREL | P | 9 | 0 | 74 | 新行已释放 |
| SPUSE | A | 1 | N/A | 79 | Y/N，有效项 |

### STKNEW

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| SPLINE | P | 5 | 0 | 1 | 订单行 |
| SPITEM | A | 12 | N/A | 4 | 库存商品 |
| SPWH | A | 1 | N/A | 16 | 仓库 |
| SPONHAND | P | 9 | 0 | 17 | 计划前库存 |
| SPRESVD | P | 9 | 0 | 22 | 计划前总占用 |
| SPONDELTA | P | 9 | 0 | 27 | 本行实物变化，可为负 |
| SPRSDELTA | P | 9 | 0 | 32 | 本行总占用变化，可为负 |
| SPOLDITEM | A | 12 | N/A | 37 | 原分配商品或空格 |
| SPOLDRES | P | 9 | 0 | 49 | 原行占用 |
| SPOLDSHIP | P | 9 | 0 | 54 | 原行已发货 |
| SPOLDREL | P | 9 | 0 | 59 | 原行已释放 |
| SPNEWRES | P | 9 | 0 | 64 | 新行占用 |
| SPNEWSHIP | P | 9 | 0 | 69 | 新行已发货 |
| SPNEWREL | P | 9 | 0 | 74 | 新行已释放 |
| SPUSE | A | 1 | N/A | 79 | Y/N，有效项 |

### SETHEAD

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| SEID | A | 48 | N/A | 1 | 正向 S:发货 或反向 A:退货:原发货 |
| SEKIND | A | 1 | N/A | 49 | P 正向 / R 反向 |
| SESHIP | A | 20 | N/A | 50 | 原发货，正反向均必填 |
| SERETURN | A | 20 | N/A | 70 | 反向来源退货，正向为空 |
| SEORIG | A | 48 | N/A | 90 | 反向的原正向结算，正向为空 |
| SEORDER | A | 20 | N/A | 138 | 原订单 |
| SECREATED | A | 8 | N/A | 158 | 创建业务日 |
| SESTATE | A | 8 | N/A | 166 | NEW / SENT / OK / FAIL / UNKNOWN |
| SEAMOUNT | P | 15 | 2 | 174 | 结算金额，正反向都存非负数 |
| SEFIRSTDAY | A | 8 | N/A | 182 | 首次认定成功日；未成功为空格 |
| SEATTEMPT | P | 9 | 0 | 190 | 本业务发送尝试号，初值 1 |
| SELASTMSG | A | 80 | N/A | 195 | 当前发送或核实消息 |
| SENLINE | P | 5 | 0 | 275 | 结算明细数 |
| SERETRY | A | 1 | N/A | 278 | 是否已有明确可重试证据 Y/N |
| SEREASON | A | 120 | N/A | 279 | 最近有效结果说明 |

### SETROWS

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| SLSETTL | A | 48 | N/A | 1 | 结算身份 |
| SLLINE | P | 5 | 0 | 49 | 结算内明细序号 |
| SLSHIP | A | 20 | N/A | 52 | 原发货 |
| SLSHLINE | P | 5 | 0 | 72 | 原发货明细 |
| SLRETURN | A | 20 | N/A | 75 | 反向来源退货，正向为空 |
| SLRTLINE | P | 5 | 0 | 95 | 反向来源退货明细；正向 0 |
| SLORDER | A | 20 | N/A | 98 | 原订单 |
| SLORDLINE | P | 5 | 0 | 118 | 原订单行 |
| SLQTY | P | 9 | 0 | 121 | 结算／调整对应数量 |
| SLAMOUNT | P | 15 | 2 | 126 | 金额绝对值 |

### SETVIEW

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| SVSHLINE | P | 5 | 0 | 1 | 原发货明细 |
| SVSUCCQTY | P | 9 | 0 | 4 | 已经成功调整的累计数量 |
| SVSUCCAMT | P | 15 | 2 | 9 | 已经成功调整的累计绝对金额 |
| SVPENDING | A | 1 | N/A | 17 | 是否有未完成调整 Y/N |

### OUTREC

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| OBID | A | 80 | N/A | 1 | 唯一消息身份 |
| OBKIND | A | 8 | N/A | 81 | SETTLE / ADJUST / VERIFY / RECEIPT / WHRESULT |
| OBBIZID | A | 48 | N/A | 89 | 结算身份或回执关联业务身份 |
| OBSRC | A | 12 | N/A | 137 | 请求来源 |
| OBREQ | A | 20 | N/A | 149 | 请求标识 |
| OBBATCH | A | 20 | N/A | 169 | 原始输入批次 |
| OBINPUT | P | 9 | 0 | 189 | 原始输入序号 |
| OBORDER | A | 20 | N/A | 194 | 订单 |
| OBSTATE | A | 8 | N/A | 214 | NEW / SENT / OK / FAIL |
| OBRESULT | A | 8 | N/A | 222 | NONE / OK / FAIL / UNKNOWN / RETRYOK，业务反馈与送达分开 |
| OBRESDAY | A | 8 | N/A | 230 | 业务反馈处理日；无反馈为空 |
| OBATTEMPT | P | 9 | 0 | 238 | 消息送达尝试次数 |
| OBDAY | A | 8 | N/A | 243 | 创建处理日 |
| OBLEN | P | 9 | 0 | 251 | 有效负载长度 |
| OBPAYLOAD | A | 30000 | N/A | 256 | 带版本的完整消息内容，长度外为空格 |
| OBREASON | A | 120 | N/A | 30256 | 最近送达原因 |

### DAYHEAD

| 字段 | 类型 | 长度 | 小数 | 单项起始字节 | 含义 |
| --- | --- | --- | --- | --- | --- |
| DYDAY | A | 8 | N/A | 1 | 被汇总处理日 |
| DYSNAP | A | 40 | N/A | 9 | 来源:日终请求标识；同日完整快照身份 |
| DYLINE | P | 9 | 0 | 49 | 0 为头；其余为组成行 |
| DYKIND | A | 8 | N/A | 54 | HEADER / POS / NEG / PENDING / LOCAL |
| DYSTATE | A | 8 | N/A | 62 | 头 DRAFT / READY；组成行保存观察状态 |
| DYSETTL | A | 48 | N/A | 70 | 组成结算身份 |
| DYSRC | A | 12 | N/A | 118 | 组成请求来源 |
| DYREQ | A | 20 | N/A | 130 | 组成请求标识 |
| DYAMOUNT | P | 19 | 2 | 150 | 行金额；HEADER 存净额，NEG 行存负值 |
| DYPOS | P | 19 | 2 | 160 | 头正向总额 |
| DYNEG | P | 19 | 2 | 170 | 头反向绝对值总额 |
| DYCOUNT | P | 9 | 0 | 180 | 头组成行数 |
| DYRC | A | 4 | N/A | 185 | 待处理原因结果码 |

## 精确调用顺序

CLLE 与主程序使用五个字符参数；DAYEND 作为输入事件，不另设隐式调用模式。辅助调用只允许 ORDMAIN 发起，不互调。

### ORDRUN

| 顺序 | 参数 | 类型 | 字节 | 方向 | 语义 |
| --- | --- | --- | --- | --- | --- |
| 1 | BATCH | A | 20 | I | 批次身份 |
| 2 | DAY | A | 8 | I | 执行日 YYYYMMDD |
| 3 | MODE | A | 8 | I | PROCESS / RESUME |
| 4 | ACTOR | A | 20 | I | 操作人 |
| 5 | RESULT | A | 4 | O | 统一返回码 |

### ORDMAIN

| 顺序 | 参数 | 类型 | 字节 | 方向 | 语义 |
| --- | --- | --- | --- | --- | --- |
| 1 | BATCH | A | 20 | I | 批次身份 |
| 2 | DAY | A | 8 | I | 执行日 YYYYMMDD |
| 3 | MODE | A | 8 | I | PROCESS / RESUME |
| 4 | ACTOR | A | 20 | I | 操作人 |
| 5 | RESULT | A | 4 | O | 统一返回码 |

### ORDCHECK

| 顺序 | 参数 | 类型 | 字节 | 方向 | 语义 |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | CANON 或 VALIDATE |
| 2 | HDRDS | DS | 490 | I | 原输入头 |
| 3 | RAWROWS | DS | 8300 | I | 原输入 100 行容量 |
| 4 | CHKHEAD | DS | 24014 | O | 规范内容／头 |
| 5 | NORMROWS | DS | 4400 | O | 规范业务行 |
| 6 | RESDS | DS | 153 | O | 结果 |

### ORDPRICE

| 顺序 | 参数 | 类型 | 字节 | 方向 | 语义 |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | QUOTE / SHIP / RETURN |
| 2 | PRIN | DS | 9400 | I | 最多 100 项金额依据 |
| 3 | PROUT | DS | 3300 | O | 对应金额候选 |
| 4 | RESDS | DS | 153 | O | 结果 |

### ORDSTOCK

| 顺序 | 参数 | 类型 | 字节 | 方向 | 语义 |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | NEW / MOD / ALLOC / SHIP / CANCEL / RETURN / VIEW / APPLY |
| 2 | STKIN | DS | 2600 | I | 最多 100 项业务需求 |
| 3 | STKOLD | DS | 23700 | IO | 原版本释放方案；APPLY 只读 |
| 4 | STKNEW | DS | 23700 | IO | 本次方案；APPLY 只读 |
| 5 | RESDS | DS | 153 | O | 结果 |

### ORDSETTL

| 顺序 | 参数 | 类型 | 字节 | 方向 | 语义 |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | FETCH / LOOKUP / CREATE / APPLY / RETRY / VERIFY / DELIVERY |
| 2 | SETHEAD | DS | 398 | IO | FETCH 输出；写入动作输入所允许目标 |
| 3 | SETROWS | DS | 13300 | IO | FETCH / CREATE 结算明细 |
| 4 | SETVIEW | DS | 1700 | O | LOOKUP 的成功累计和待调整标志 |
| 5 | OUTREC | DS | 30375 | IO | 消息查询／创建／送达 |
| 6 | RESDS | DS | 153 | O | 结果 |

### ORDREPLY

| 顺序 | 参数 | 类型 | 字节 | 方向 | 语义 |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | CREATE / FETCH / DELIVERY / RESEND / LIST |
| 2 | OUTREC | DS | 30375 | IO | 完整消息或按身份查询 |
| 3 | RESDS | DS | 153 | O | 结果 |

### ORDDAILY

| 顺序 | 参数 | 类型 | 字节 | 方向 | 语义 |
| --- | --- | --- | --- | --- | --- |
| 1 | CTXDS | DS | 455 | I | SNAPSHOT / FETCH；生成用 CXPROCDAY，查询用 CXDAY；来源和请求确定快照 |
| 2 | DAYHEAD | DS | 188 | O | 日报头 |
| 3 | RESDS | DS | 153 | O | 结果 |

## 返回码

| RC | 含义 | 调用方动作 |
| --- | --- | --- |
| 0000 | 本次动作完成 | 正常继续；辅助完成不等于主程序提交 |
| 0010 | 业务已接受等待／外部待核实 | 记录等待并闭合输入；不自动重试业务 |
| 0020 | 重复或已存在 | 读取最近业务投影；不重复写入业务事实 |
| 1000 | 业务拒绝 | 无业务副作用的结果单元 |
| 1100 | 身份／版本／矛盾反馈冲突 | 保留原事实并记录冲突 |
| 2000 | 资料或关联异常 | 回滚本笔；可定位且可记录则保留待处理，持久化不可靠转 9000 |
| 3000 | 本地处理失败且回滚已确认 | 结果单元记 RETRY；等待显式恢复 |
| 9000 | 系统或提交状态不可靠 | 停止批次，不能宣告已回滚或成功 |

## 事件与有效载荷

| 事件 | 作用 | 必需内容 |
| --- | --- | --- |
| NEW | 新建 | 订单、客户、部分政策，1–100 行 |
| MOD | 发货前完整替换 | 当前版本；替换全部明细和价格 |
| ALLOC | 补分配 | 当前版本；输入无明细，由现存订单需求形成 |
| SHIP | 确认发货 | 当前版本、唯一发货身份，1–100 行，仓库必填 |
| CANCEL | 取消数量 | 当前版本，1–100 行，引用订单行 |
| RETURN | 确认退回 | 唯一退货身份，1–100 行，引用原发货及明细 |
| SETRES | 结算／核实反馈 | 结算身份、原消息身份、OK/FAIL/UNKNOWN/RETRYOK |
| DELIVER | 送达反馈 | 消息身份、SENT/OK/FAIL |
| RECOVER | 显式恢复 | 操作者、原因、LOCAL/RETRY/VERIFY/REPLY 和原关联 |
| QUERY | 查询关联轨迹 | 订单或原请求身份；只产生结果回执 |
| DAYEND | 日终 | 当前处理日；请求身份用于快照 |

## 状态迁移

| 维度 | 原状态 | 目标状态 | 条件 |
| --- | --- | --- | --- |
| 请求 RQSTATE | 不存在 | DONE / REJECT / RETRY | 首次本地处理结果；缺业务键不写 REQPF |
| 请求 RQSTATE | RETRY | DONE / REJECT / RETRY | 仅显式 LOCAL 恢复重新处理原内容 |
| 结算 SESTATE | 不存在 | NEW | 发货／退货与结算创建同一个本地单元 |
| 结算 SESTATE | NEW | SENT / OK / FAIL / UNKNOWN | 必须校验关联消息；反馈可先于送达通知 |
| 结算 SESTATE | SENT | OK / FAIL / UNKNOWN | 业务反馈，不以送达替代 |
| 结算 SESTATE | FAIL | NEW / OK / UNKNOWN | NEW 仅在 SERETRY=Y 的显式 RETRY；晚到合法 OK 可建立成功事实 |
| 结算 SESTATE | UNKNOWN | OK / FAIL / UNKNOWN | 仅来自当前核实消息；普通 FAIL 不解除未知 |
| 结算 SESTATE | OK | OK | 重复成功不重复金额；任何失败／未知通知只留审计 |
| 回执 OBSTATE | NEW / SENT / FAIL | SENT / OK / FAIL | 仅送达；REPLY 重送保持原内容，尝试加一 |
| 回执 OBSTATE | OK | OK | 晚到失败不覆盖送达成功 |
| 日报 DYSTATE | 不存在 | READY | 一次本地单元内形成头及所有明细 |
| 日报 DYSTATE | READY | READY | 同快照返回既有结果 |

## 规范请求、复合身份与消息内容

CANON 模式只校验载体、格式和规范化所必需的结构，不访问当前客户、商品或价格。VALIDATE 才检查当前业务资格。重复识别须位于 VALIDATE 及版本检查之前。

规范内容以版本字串 0001 开头，按 INHDRPF 字段顺序纳入除 IHBATCH、IHSEQ、IHARRDAY、IHARRTIME 外所有字段；每字段写四位十进制实际长度再接去右侧填充的内容。数量、版本和明细号通过数字合法性检查后转换为不带前导零的十进制；无法解析的原文保留原样，以便相同非法请求也能去重。原处理日纳入比较。NEW/MOD/CANCEL/RETURN 按业务行号排序；SHIP 按订单行号及仓库排序，允许同一订单行分仓，但不允许同一行及仓库组合重复。无效键或重复业务组合按原 IDPOS 稳定排序，并在 VALIDATE 拒绝。每行排除 IDBATCH、IDINPUT、IDPOS，再以同样长度前缀逐字段附加。实际内容不得超过 RQCANON 24000 字节，保存 RQCANLEN；比较长度与全部内容，不以哈希相等代替相等。

内部身份：正向结算 `S:发货ID`；反向调整 `A:退货ID:原发货ID`；消息 `M:批次ID:九位输入序号:种类:五位序号`；审计 `A:批次ID:九位输入序号:九位事件序号`；日报快照 `来源:请求ID`。字段最大长度均足够容纳完整身份。序号在一次输入处理中确定，失败回滚后从同一已提交边界重建，不能因重试生成新的业务身份。

出站 OBPAYLOAD 使用版本 0001 和与上述相同的长度前缀字段序列。结算／调整载荷依次包含 SEID、SEKIND、SESHIP、SERETURN、SEORIG、SEORDER、SECREATED、SEAMOUNT、SENLINE，以及 SL 行按 SLLINE 的全部字段。VERIFY 只包含原结算身份、原发货、当前尝试号及请求核实语义，不包含再次扣款指令。回执头包含来源、请求、业务结果码／原因、订单、版本、各独立状态及上一回执送达状态；仓储结果另附按订单行及仓库排序的数量变更。QUERY 的历史结果按 AUDITPF 记录分消息分页，消息序号与页码一致，不在一条 30000 字节负载中截断历史。登记后载荷不改写；后续状态投影产生新回执消息，显式 RESEND 仅重发旧载荷。

## 事务、失败与恢复协议

ORDMAIN 是正常 COMMIT/ROLBK 的唯一所有者。ORDRUN 使用独立演示作业，启动作业级承诺定义，所有 RPGLE 在 ORDBENCH 激活组内加入该定义；已存在不属于本次调用的承诺定义时停止，不能清理别人的未提交工作。所有写用 PF 与相关 LF 必须在同一承诺定义及日志前提下打开。运行前提未在本轮配置。

一笔事件的业务写入、结算／回执登记、REQPF、AUDITPF 和 BATCHPF 检查点共用一次提交。辅助程序只能返回候选或写入结果。失败后主程序明确回滚，废弃所有候选及文件缓冲，从已提交记录重建；回滚结果不可靠则 9000 停止。

本地失败且已确认回滚后，独立结果单元把原请求记为 RETRY，记录原因并闭合该信封；同批次其他独立请求可继续。受未完成调整阻塞而尚未接受的 RETURN 也可记 RETRY/0010，未产生归还或新调整。相同原请求重复提交只返回 RETRY。显式 RECOVER/LOCAL 用新请求身份引用原来源及请求，重读首次原始信封，保留原业务日，重新检查当前资料／版本；成功后在同一提交中更新原 REQPF 和恢复请求账本。原 REQPF 内容与首次关联不变。执行原业务时，CXEVENT/CXSRC/CXREQ/CXDAY 采用原请求；CXBATCH/CXINPUT/CXPROCDAY 保留本次恢复执行上下文，RECCTX 保存外层恢复请求。新消息和审计编号因此归本次执行，业务身份仍归原业务。若结果单元也无法写入，停止且不推进检查点。

对端成功是独立反馈。结算身份、消息种类、已登记负载金额与对应来源需一致；本合成反馈不另传金额。普通 FAIL 明确表示该次业务未生效；结果本已 UNKNOWN 时，只能由当前 VERIFY 的 FAIL/RETRYOK 确認未生效并设 SERETRY=Y，或由有效成功反馈终结。非当前尝试的失败不改变当前进度；重复成功不改变 SEFIRSTDAY。OBSTATE 表示送达，OBRESULT/OBRESDAY 表示业务反馈；新消息初始化 OBRESULT=NONE、OBRESDAY 为空。普通送达反馈只更新送达状态，结算消息送达至多把 NEW 推到 SENT，不能置 OK。

当前处理日 CXPROCDAY 来自显式作业日，正常新事件 IHDAY 必须一致；重复与 LOCAL 恢复保留原 IHDAY，不重分日期。首次成功日写 CXPROCDAY，不使用旧请求或发货日。18:00 的分日由共享操作背景定义的接入端提供，核心不会从缺失时点猜测。

## 数量、修改与舍入细化

MOD 表达发货前订单完整替换版本：旧订单头、行、取消记录和占用变化先按记录形成审计快照，原有占用在候选方案中释放，新版本重新校验／计价／分配。接受后取消、发货及分摊累计从新版本零起；已全部取消或曾发货仍按 BR-10 拒绝。旧版本事实保留在审计，不混入新版本金额分母。新版本允许库存不足而处于业务等待，等待属于已接受结果；校验／本地写入失败则全部保持原状。

分次发货按订单行累计：delta=round(原行金额×新累计发货量/原行受理量,2)−此前已分配给发货的金额。取消不改写冻结原行金额或分母，因此部分发货后取消余量只结算实发比例，不凭取消补收尾差。同一订单行一次从多个仓发货时按 A/B/C 的稳定顺序累计，不能各仓都从同一个累计基数起算。

退货按原发货明细累计：delta=round(原发货明细金额×新累计退回量/原发货明细数量,2)−此前已成功调整额。存在该原发货明细任何未完成调整时整次 RETURN 暂不受理；同一事件重复引用同一原发货明细时先拒绝，避免组内重复入库。一个 RETURN 可引用同一订单的多个发货，按各原发货分别形成调整头。原发货明细金额可能为 0，调整允许为 0；数量仍须为正。

## 日终口径

成功正向／反向按 SEFIRSTDAY=CXPROCDAY 汇总，未成功结算按状态前缀另列；本地待恢复请求从 RQSTATE=RETRY 列出。已闭合请求的旧等待回执不能代替当前结算状态，也不能使已成功结算继续出现在待结算清单。库存未履约缺口通过订单 QUERY 查看，不混入待结算金额。日报头与全部组成行在一次本地单元内发布；同一日同一快照重做读取既有 READY，新的观察点需新的日终请求身份。

## 指示器及固定格式约束

全程固定格式 H/F/D/C；第 6 列为规格种类。共享符号放 ORDSTS，业务状态不借用全局 *IN 传递。每个程序局部 90=I/O 错误、91=未找到、92=范围结束，使用前重置；不能把未找到当成系统错误，也不能让一个读取覆盖另一读取的结果。具体 CHAIN、SETLL、READE、READ 的结果位置及可用操作扩展在代码生成静态预检中逐一核对。新建业务事实使用 WRITE，修改既有记录使用 UPDATE；多记录范围须读完整范围。金额采用上述宽临时值，超容量返回错误。

共享结构是同一份定义的展开引用，字段不能在程序内另取不同长度。程序文件缓冲、参数快照和候选数组须分开；对同名 PF/LF 格式按技术设计 RENAME，且读取 LF 后复制需要的值再继续其他 I/O，避免覆盖仍需使用的记录缓冲。

## 输入事件字段矩阵

所有事件均需 IHSRC/IHREQ/IHEVENT/IHDAY，IHNLINE 为实际业务行数。IHARRDAY/IHARRTIME 是包装字段；IHACTOR/IHREASON 可在任何事件记录，RECOVER 必填。下表未列出的业务头字段必须为空；无明细事件 IHNLINE=0。业务标识 1–20 字符，来源及客户／商品为各自字段容量，序号必须为正且可由 P(5,0) 表示。

| 事件 | 专用必填头 | 允许的明细字段 | 其他条件 |
| --- | --- | --- | --- |
| NEW | IHORDER、IHCUST、IHPART | IDLINE、IDITEM、IDQTY | 1–100 行；行号唯一。 |
| MOD | IHORDER、IHVERSION、IHCUST、IHPART | IDLINE、IDITEM、IDQTY | 1–100 行；完整替换。 |
| ALLOC | IHORDER、IHVERSION | 无 | 从当前订单读取需求。 |
| SHIP | IHORDER、IHVERSION、IHSHIP | IDLINE、IDQTY、IDWH | IDLINE 是原订单行；排序后另分配 SDLINE=1…N，保留 SDORDLINE。 |
| CANCEL | IHORDER、IHVERSION | IDLINE、IDQTY | 每个订单行只出现一次。 |
| RETURN | IHORDER、IHRETURN | IDLINE、IDQTY、IDSHIP、IDSHLINE | IDLINE 是本次退货序号；同原发货明细只出现一次；商品仓库从发货事实取得。 |
| SETRES | IHSETTL、IHMSG、IHRESULT | 无 | RESULT=OK/FAIL/UNKNOWN/RETRYOK；RETRYOK 仅用于核实。 |
| DELIVER | IHMSG、IHRESULT | 无 | RESULT=SENT/OK/FAIL。 |
| RECOVER | IHACTION、IHACTOR、IHREASON | 无 | LOCAL 另需 IHREFSRC/IHREFREQ；RETRY/VERIFY 需 IHSETTL；REPLY 需 IHMSG。 |
| QUERY | IHORDER 或 IHREFSRC/IHREFREQ | 无 | 二选一，不能提供不一致的两套关联。 |
| DAYEND | 无 | 无 | 使用来源／请求及运行日定位快照。 |

数字字符语法为可选正负号、十进制数字及可选小数部分；规范化去前导零，但业务数量要求正且无非零小数部分。1.0 与 1 规范化为同一整数，1.5、0、负值不能通过数量校验；超出字段容量在接入载体检查阶段拒绝，不能先截断再送入核心。日期、时间要求真实日历值。主程序在去重后调用 VALIDATE 执行本矩阵，包括非 NEW/MOD 事件。

## 候选数据与版本推进

NEW/MOD 报价输入来自 NORMROWS，CXDAY/CXTIER 为本次计价依据；PROUT 的 UNIT/RATE/AMOUNT 写入当前订单行。ALLOC 的 SIQTY=ODQTY−ODCANCEL−ODSHIPPED，由 ORDSTOCK 再扣现有占用。CANCEL 的 SIQTY 是本次取消量，SIREMAIN 是取消前有效剩余量。SHIP 的商品和冻结金额来自订单行；RETURN 的商品仓库来自原发货明细，禁止信任调用输入猜测。

库存计划中 SPONHAND/SPRESVD 均指整个计划前的原始库存快照，虚拟变化只进入 delta；同键在多个计划项中的快照必须相同。无原 ALLOCPF 行时 SPOLDITEM 为空、旧计数为零；APPLY 要求它仍不存在，再 WRITE。RETURN 仅校验并更新 STOCKPF，不要求创建或更新 ALLOCPF；VIEW 不允许 APPLY。CXACTION=APPLY 时以 CXEVENT 保留原业务类别，恢复执行时也是原业务事件。

每次接受的 MOD/ALLOC/CANCEL/SHIP 将 OHVERSION 推进一次，并同步所有当前有效行 ODVERSION；拒绝、重复、退货、结算及送达反馈不推进版本。NEW 版本从 1 开始。当前行始终要求 ODACTIVE=Y 且 ODVERSION=OHVERSION，停用旧行不参加合计。剩余需求总量大于零时 OHSTATE=ACTIVE；归零且有取消量时 CANCEL，否则 CLOSED。OHSHIPANY 一经发货为 Y，不因退货清除。

所有明确表示记录缺失的读取均需与 I/O 故障区分：预期新对象允许未找到，要求历史事实的读取未找到是 2000。文件 UPDATE 必须先定位并保有当前记录，新增 WRITE 使用完整键且核对不存在。SELASTMSG 指向最后业务尝试或核实消息；SEATTEMPT 仅在实际业务重试时推进，VERIFY 以消息身份区分。传入 SETHEAD 目标前态的校验依据为 CXEXPECT/CXATTEMPT，反馈原值为 CXFEED。

## 日终重复结果查询

ORDDAILY 的 FETCH 只读取 DYDAY=CXDAY、DYSNAP=CXSRC:CXREQ 的已发布头及组成结果；缺失返回 2000，禁止创建快照。原 DAYEND 请求跨日重复或被 QUERY 引用时，ORDMAIN 从 REQPF 取原 RQDAY/RQSRC/RQREQ 调用 FETCH。SNAPSHOT 仍只用于本次新日终事件，使用 CXPROCDAY。两种动作的参数顺序和长度完全一致。
