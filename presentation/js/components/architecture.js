import { html, text } from "../lib/dom.js";

function nodeBox(node) {
  const width = node.wide ? 320 : 220;
  const height = 86;
  return html`
    <g class="arch-node arch-${text(node.kind)}" data-node="${text(node.id)}" transform="translate(${node.x},${node.y})">
      <rect class="arch-hit" x="-8" y="-8" width="${width + 16}" height="${height + 16}"></rect>
      <rect class="arch-card" width="${width}" height="${height}" rx="6"></rect>
      <text class="arch-name" x="18" y="36">${text(node.label)}</text>
      <text class="arch-role" x="18" y="62">${text(node.role)}</text>
    </g>`;
}

function edgePath(edge, nodes) {
  const from = nodes[edge.from];
  const to = nodes[edge.to];
  if (!from || !to) {
    return "";
  }
  const fromW = from.wide ? 320 : 220;
  const toW = to.wide ? 320 : 220;
  const x1 = from.x + fromW / 2;
  const y1 = from.y + 86;
  const x2 = to.x + toW / 2;
  const y2 = to.y;
  const midY = (y1 + y2) / 2;
  const d = edge.arc
    ? `M ${from.x} ${from.y + 20} C ${from.x - 140} ${from.y - 40}, ${to.x - 80} ${to.y + 40}, ${to.x + 20} ${to.y + 20}`
    : `M ${x1} ${y1} C ${x1} ${midY}, ${x2} ${midY}, ${x2} ${y2}`;
  return html`
    <g class="arch-edge" data-edge="${text(edge.id)}" data-from="${text(edge.from)}" data-to="${text(edge.to)}">
      <path id="${text(edge.id)}" d="${d}" fill="none"></path>
      <text class="arch-edge-label">${text(edge.label ?? "")}</text>
    </g>`;
}

export function renderArchitecture(slide) {
  const nodes = slide.data?.nodes ?? [];
  const nodeMap = Object.fromEntries(nodes.map((node) => [node.id, node]));
  const edges = (slide.data?.edges ?? []).map((edge) => edgePath(edge, nodeMap)).join("");
  const cards = nodes.map(nodeBox).join("");
  const flows = (slide.data?.flows ?? [])
    .map(
      (flow, index) => html`
        <li class="flow-step fragment fade-in" data-fragment-index="${index}" data-flow="${text(flow.id)}" data-edges="${text((flow.edges ?? []).join(","))}">
          ${text(flow.label)}
        </li>`
    )
    .join("");
  const details = Object.entries(slide.data?.details ?? {})
    .map(([id, body]) => html`<p class="arch-detail" data-detail="${text(id)}">${text(body)}</p>`)
    .join("");

  return html`
    <div class="slide-frame architecture-slide" data-component="architecture">
      <header class="slide-head compact">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      <div class="arch-layout">
        <svg class="arch-svg" viewBox="0 0 1480 680" role="img" aria-label="${text(slide.title)}">
          ${edges}
          ${cards}
          <circle class="arch-packet" r="5" hidden></circle>
        </svg>
        <aside class="arch-rail">
          <p class="rail-label">数据流</p>
          <ol class="flow-list">${flows}</ol>
          <div class="arch-detail-box">
            <p class="rail-label">模块说明</p>
            <p class="arch-detail is-default">点击左侧模块查看职责。翻页不受影响。</p>
            ${details}
          </div>
        </aside>
      </div>
      <p class="hint">${text(slide.data?.hint ?? "")}</p>
    </div>`;
}
