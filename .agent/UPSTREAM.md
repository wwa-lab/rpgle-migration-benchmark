# IBM i 技能来源

- 上游：[wwa-lab/build-agent-skill](https://github.com/wwa-lab/build-agent-skill)
- 来源快照：[上游固定版本](https://github.com/wwa-lab/build-agent-skill/tree/0c331e86fad2b13d5f9d1313bdd928b29d355b43)
- 本地技能目录：`.agent/`
- 上游技能树 Git 对象：`0c5fadf59d8c23d3f6b065784619f5492233ded6`，用于精确定位上游内容，不以本地目录名代替上游目录名。
- 上游分支：`main`
- 固定提交：`0c331e86fad2b13d5f9d1313bdd928b29d355b43`
- 复制日期：2026-09-05
- 来源核对：GitHub `main` 与现有本地克隆 HEAD 一致；从该提交的 Git archive 读取，不复制本地未提交内容。
- 复制范围：16 个技能目录，251 个技能／引用／示例／测试文件；保留可执行权限，路径适配的文件单独记录差异。
- 唯一排除：上游技能树中的 `.DS_Store`。
- 许可：上游根目录 `LICENSE` 原文复制为 [UPSTREAM-LICENSE](UPSTREAM-LICENSE)。
- 完整性清单：[upstream-manifest.json](upstream-manifest.json)，包含源树相对路径、本地路径、权限、上游 SHA-256 及当前本地 SHA-256。

本文件、清单及许可副本位置是本项目添加的元数据。技能目录及其内部引用已按用户要求统一为 `.agent`，业务与流程内容保持不变。项目特定约束见 [AGENTS.md](../AGENTS.md) 和 [README.md](../README.md)。

## 本地适配记录

- 16 个技能统一放在 `.agent/<skill-name>/`。
- 更新技能、参考文档、编排示例、项目说明及清单中的本地路径。
- 3 个历史测试脚本移除旧的用户主目录 CLI 探测项，保留显式 `CLAUDE_BIN`、PATH 及其他原有候选；不将机器上的 CLI 安装位置误改成项目目录，也不执行这些脚本。
- 11 个上游文件存在上述文本调整，均添加本地适配说明；清单同时保留原始与当前文件校验值。其余上游文件保持原始字节。
- 源路径记录为上游技能树的相对路径；许可仍记录为仓库根目录 `LICENSE`，避免误称上游已有本地目录布局。

## 技能清单

| 技能 | 用途 |
| --- | --- |
| [ibm-i-requirement-normalizer](ibm-i-requirement-normalizer/SKILL.md) | 整理原始需求 |
| [ibm-i-functional-spec](ibm-i-functional-spec/SKILL.md) | 功能需求与业务规则 |
| [ibm-i-technical-design](ibm-i-technical-design/SKILL.md) | 技术设计 |
| [ibm-i-program-spec](ibm-i-program-spec/SKILL.md) | 程序规格 |
| [ibm-i-file-spec](ibm-i-file-spec/SKILL.md) | 文件规格 |
| [ibm-i-code-generator](ibm-i-code-generator/SKILL.md) | RPGLE / CLLE 生成 |
| [ibm-i-dds-generator](ibm-i-dds-generator/SKILL.md) | DDS 生成 |
| [ibm-i-spec-reviewer](ibm-i-spec-reviewer/SKILL.md) | 规格审查 |
| [ibm-i-code-reviewer](ibm-i-code-reviewer/SKILL.md) | 程序审查 |
| [ibm-i-dds-reviewer](ibm-i-dds-reviewer/SKILL.md) | DDS 审查 |
| [ibm-i-compile-precheck](ibm-i-compile-precheck/SKILL.md) | 编译前静态预检，不执行编译 |
| [ibm-i-program-analyzer](ibm-i-program-analyzer/SKILL.md) | 程序分析 |
| [ibm-i-impact-analyzer](ibm-i-impact-analyzer/SKILL.md) | 变更影响分析 |
| [ibm-i-ut-plan-generator](ibm-i-ut-plan-generator/SKILL.md) | UT 计划；当前不启用 |
| [ibm-i-test-scaffold](ibm-i-test-scaffold/SKILL.md) | 测试脚本；当前不启用 |
| [ibm-i-workflow-orchestrator](ibm-i-workflow-orchestrator/SKILL.md) | 阶段路由与后续编排 |

## 使用注意

保留技能目录内部结构，包括上游示例、测试用例和历史测试输出。它们用于理解技能，不是本项目生成的业务样本，也不是本项目模型评测结果。

本项目通过 `.agent/<skill-name>/SKILL.md` 显式路径读取技能；没有另造多份运行时副本，也不保证 IDE 自动列出这些技能。
