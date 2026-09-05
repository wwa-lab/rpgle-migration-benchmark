# RPGFLOW HTML Presentation

独立的 16:9 汇报 Deck。不改动仓库里的需求、设计、源码或评测包，也不依赖后端。内容来自 JSON，组件和动画分开，方便以后用 Markdown / YAML 生成整套片子。

当前 Demo 讲的是本项目本身：虚构的多仓订单履约样本、四类 Flow，以及已经冻结的 RPGFLOW-1.0 评测包。

## 如何启动

仓库根目录或 `presentation/` 下都可以。需要一个本地静态服务器，这样 JSON 和演讲者视图才能正常工作。

```bash
cd presentation
chmod +x serve.sh
./serve.sh
```

默认地址：<http://127.0.0.1:4173/>

也可以指定端口：

```bash
./serve.sh 8080
```

等价命令：

```bash
cd presentation
python3 -m http.server 4173
```

不要用 `file://` 直接打开 `index.html`。浏览器会拦截 `fetch` 读取 JSON。

## 如何进入 Presentation

打开 <http://127.0.0.1:4173/> 即进入 Demo Deck。

| 操作 | 按键 |
| --- | --- |
| 下一页 / 下一片段 | `→` 或 `Space` |
| 上一页 / 上一片段 | `←` |
| 全屏 | `F` |
| reveal.js 演讲者视图 | `S`（需允许弹出窗口） |
| 本页备注条 | `N` |
| 总览 | `Esc` |
| 快捷键说明 | `?` |

一屏一张 Slide，不向下滚动。右上角是页码，底部是进度条。

## 如何新增 Slide

1. 打开 [content/rpgflow-demo.json](content/rpgflow-demo.json)。
2. 在 `slides` 数组里追加一个对象，至少包含 `id`、`type`。
3. 按类型填写 `data`。可用类型见 [content/schema.json](content/schema.json)：

| `type` | 组件 | 适用内容 |
| --- | --- | --- |
| `title` | TitleSlide | 封面 |
| `section` | SectionSlide | 章节隔页 |
| `problem` | 问题卡 | 背景 / 问题 |
| `cards` | 指标卡 + 可选 CodeDemo | 现状 |
| `architecture` | ArchitectureDiagram | 系统模块与数据流 |
| `workflow` | Workflow | 流水线逐步激活 |
| `agents` | Agent 协作 | 技能交接 |
| `comparison` | Comparison | Before / After |
| `kpi` | KPI | 数字与条形图 |
| `code` | CodeDemo | 整页代码 |
| `roadmap` | Roadmap | 阶段 |
| `closing` | 收束页 | 结束 |

刷新浏览器即可。无需构建。

## 如何修改内容

改 JSON，不要改 HTML 拼版。

- 文案、备注、页标题：改对应 slide 的 `title`、`eyebrow`、`notes`、`data`。
- 架构节点和箭头：改 `architecture.data.nodes` / `edges` / `flows`。
- 流水线步骤：改 `workflow.data.steps`。
- 数字：改 `kpi.data.metrics` 和 `bars`。
- 演讲者备注：改 `notes`。按 `N` 看本页备注，按 `S` 开演讲者窗口。

组件只负责把 schema 画出来。动画层只读取 `data-component` 和 fragment 状态。

## 如何增加动画

1. 在 slide 上加 `animation` 字段，例如 `dataflow`、`pipeline`、`agents`、`countup`。
2. 组件里用 `fragment` 标记逐步出现的块。
3. 如需新动效，在 `js/animations/` 增加模块，并在 [js/boot.js](js/boot.js) 的 `bindSlideEffects` 里挂上。
4. 保持克制：只表达信息流、状态变化和交接，不要加旋转、弹跳或粒子。

现成动效：

- Architecture：模块依次出现，空格推进四段数据流，圆点沿箭头移动。点击模块看说明，不翻页。
- Workflow：Requirement → … → Compare 逐步点亮。
- Agents：任务产物沿技能链移动。
- KPI：数字 count-up，条形图展开。
- Code：按 `highlights` 逐段加亮。

## 如何全屏演示

1. 用上面的命令启动本地服务。
2. 用 Chrome 或 Edge 打开 Deck。
3. 按 `F`，或通过浏览器菜单进入全屏。
4. 按 `S` 打开演讲者视图（当前页、下一页、备注、计时）。若弹窗被拦截，先允许，或按 `N` 使用页内备注。

Deck 按 1920×1080 排版，reveal.js 会按窗口缩放，笔记本和投影都保持 16:9。

## 目录

```text
presentation/
  index.html                 入口
  serve.sh                   本地静态服务
  README.md                  本说明
  content/
    rpgflow-demo.json        Demo 内容
    schema.json              Slide schema
  css/                       主题与组件样式
  js/
    boot.js                  启动 reveal.js
    renderer.js              JSON → Slide
    components/              可复用组件
    animations/              动画层
  vendor/                    reveal.js / highlight.js 本地副本
```

## 以后用 Markdown 生成新 Presentation

当前实现已经按这条链分开：

```text
Presentation Content
  → Slide Schema
  → Reusable Components
  → Animation Layer
  → HTML Presentation
```

后续 Agent 只要做编译器，不必改组件：

1. 写 `deck.md` 或 `deck.yaml`，用 front matter 描述 `meta`，用标题和 fenced blocks 描述 slide 类型。
2. 把文档编译成现在的 `slides[]` JSON（对照 `schema.json`）。
3. 把生成文件放到 `content/`，或给 `js/boot.js` 增加 `?deck=` 查询参数指向新文件。
4. 不要把 Markdown 直接塞进 HTML。动画和布局继续走现有组件。

示例 Markdown 约定（尚未实现编译器，仅作为后续接口）：

```markdown
---
id: rpgflow-q3
title: RPGFLOW 对照汇报
aspect: 16:9
---

# title
大型固定格式 RPGLE
如何被读成四类 Flow

# architecture
animation: dataflow
```

生成结果应仍是 JSON，而不是另一套页面模板。
