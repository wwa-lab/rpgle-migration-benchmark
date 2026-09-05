# 合成源码成员

本目录保存固定格式 RPGLE 静态分析候选源码，状态 Draft。

- [ORDMAIN](QRPGLESRC/ORDMAIN.rpgle)：10,114 行主程序。
- `QRPGLESRC/`：另有 6 个配套 RPGLE 和 3 个共享 COPY。
- `QCLLESRC/`：[ORDRUN](QCLLESRC/ORDRUN.clle) 独立批次驱动。
- `QDDSSRC/`：21 个 PF 和 3 个 LF 的 DDS。

完整规模、对象索引、实现约定和静态检查记录在 [交付索引](../docs/source/README.md)。源码容器名称不代表已创建的 IBM i 对象；本轮没有编译、运行或加载交易数据。

这是开发版源码，含规格追踪及解释性信息。已另行生成[统一评测包](../benchmark/README.md)，清理源码注释、补充最小外部背景并记录转换与校验值。模型应读取评测包中的源码。
