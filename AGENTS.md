# 项目执行规则

## 项目目标与来源

这是完全虚构的固定格式 RPGLE 静态分析评测项目。用户不提供真实业务；新角色、规则、名称和背景由本项目自行设计并标为合成设定。不要反复询问真实核心系统信息。

先读 [README.md](README.md) 中的 BC-01～BC-09，再读 [功能需求文档](docs/requirements/functional-requirements.md)。README 管理评测／交付约束，需求文档管理业务意图；下游文档细化这些内容，不另起相互冲突的定义。

## 技能入口

技能来源记录在 [.agent/UPSTREAM.md](.agent/UPSTREAM.md)。本项目统一使用 `.agent/<skill-name>/` 布局；按路径读取，不假定已被运行时自动加载，也不要为了使用技能修改全局配置。后续新增技能及路径引用均沿用 `.agent`。

- 功能需求：`.agent/ibm-i-functional-spec/SKILL.md`
- 技术设计：`.agent/ibm-i-technical-design/SKILL.md`
- 程序规格：`.agent/ibm-i-program-spec/SKILL.md`
- 文件规格：`.agent/ibm-i-file-spec/SKILL.md`
- RPGLE / CLLE：`.agent/ibm-i-code-generator/SKILL.md`
- DDS：`.agent/ibm-i-dds-generator/SKILL.md`
- 审查：相应 `ibm-i-*-reviewer` 与 `ibm-i-compile-precheck`
- 阶段路由：`.agent/ibm-i-workflow-orchestrator/SKILL.md`

## 本项目对上游默认规则的调整

- 需求明确指定固定格式；新程序生成和代码审查都必须采用这一约束。不要把项目改成“已有程序修改”来绕过上游默认，也不要自动转为自由格式。
- 用户已授权自行设计虚构场景。上游禁止凭空补写真实业务事实的规则仍有意义，但不应阻止明确标注的合成场景设计，也不要求真实 SME 提供业务内容。
- 需求里的验收场景是静态阅读和后续生成的行为参照，不代表已执行测试；遵守 README 中的编译、运行和测试脚本边界。
- 保持 FR/BR 编号连续。发现歧义时按虚构场景作出最小、可解释的设定，并在对应源文档中记录，不把猜测写成真实系统事实。
- Draft 文档不自动标为 Approved；无需为了技能中的一般流程描述再询问用户已授权的本轮工作。每轮按用户实际要求推进。
- 不因上游支持批量执行而自动运行整条链。当前交付状态见 README；后续阶段在用户要求时继续。

## 维护与验证

- 上游技能已做本地目录适配，差异见来源清单；业务与流程内容沿用上游。项目差异集中写在这里及 README。确需继续修改技能时，记录本地变更并更新来源说明，同时维护上游和本地校验值。
- 保留上游作者、许可证和历史测试材料。历史 `tests/results` 不是本项目的验证结果，不运行会调用其他模型的上游测试脚本。
- 采用轻量检查：复制完整性、相对链接、需求编号和覆盖关系；生成源码后再检查列位置、规模及引用一致性。
- 不自行提交、推送、发布或调用内外网模型服务。
