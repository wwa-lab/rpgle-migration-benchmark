# 统一评测包使用入口

**材料版本：RPGFLOW-1.0。输入已冻结，模型尚未运行。** 源码仍为 Draft 静态分析候选；冻结表示输入内容与校验值固定，不代表已经通过编译或业务运行验证。

## 选择同一种交付方式

| 方式 | 下载 | 适用条件 |
| --- | --- | --- |
| RO-FILES（默认） | [文件评测包](dist/RPGFLOW-1.0-files.zip) | 两边均能在隔离目录中列出文件、搜索文本和按行读取，且能记录和限制工具使用 |
| TEXT-PARTS（备选） | [分段文本评测包](dist/RPGFLOW-1.0-text.zip) | 两边关闭工具，按相同顺序接收全部 32 段文本，并具备足够的上下文容量 |

两种方式使用相同的 38 份业务材料和同一份四类 Flow 分析任务。不同方式的结果分开比较；不能一边使用文件检索，另一边使用文本分段后直接归因于模型能力。

## 开始一次评测

1. 按[运行说明](runs/README.md)核实两端实际模型、推理设置、输入／输出限制和工具条件，复制填写[运行记录模板](runs/run-template.json)。每轮使用新会话和隔离目录。
2. 只交付上表选中的压缩包。文件版解压后将 `input/` 作为唯一可见工作目录，发送其中的 [prompts/run.md](input/prompts/run.md)。文本版先发送 [start.md](delivery/start.md)，依照 [index.json](delivery/index.json) 顺序发送全部分段，最后发送 [final.md](delivery/final.md)。
3. 保存原始输出及使用记录，再由评审者使用[评分说明](reference/rubric.md)和[证据清单](reference/evidence-checklist.md)评分。Operation、System、Data、Transaction Flow 各 25 分，总计 100 分。

不要向被测模型开放整个开发仓库。本页、运行记录、评分参考、完整需求与设计以及技能均属于操作／评审侧材料，不在压缩包内。实际运行记录建议放入 `runs/<运行编号>/`，保留原始模板。

## 包内材料与核验

- 35 个源码文件：7 个固定格式 RPGLE、1 个 CLLE、24 个 DDS、3 个 COPY；另含输入索引和两份必要背景说明。
- 主程序保留 10,114 个物理行；开发版的 388 行源码注释已清理，保留行号映射及固定格式代码列位置。
- 32 段文本可逐字节还原同一套业务材料。提示词、材料校验值及压缩包文件边界已检查通过。
- [输入清单](input/manifest.json)、[压缩包校验值](dist/SHA256SUMS.txt)、[冻结记录](freeze.json)、[打包检查结果](reference/packaging-checks.json)。

评审侧保留[转换记录](reference/transformation.json)和原始源码校验快照。任何输入、提示词或评分基准变更都需要更新版本并重新核验，不能混用结果。

两端实际配置仍待核实，见[配置备注](runs/configuration-notes.md)。目前没有模型得分、运行时间或编译／业务执行结果。
