import { html, text } from "../lib/dom.js";

export function renderKpi(slide) {
  const metrics = (slide.data?.metrics ?? [])
    .map(
      (metric) => html`
        <article class="kpi-card">
          <strong class="kpi-number" data-count="${metric.value}" data-suffix="${text(metric.suffix ?? "")}">0</strong>
          <span class="kpi-label">${text(metric.label)}</span>
          <em>${text(metric.hint ?? "")}</em>
        </article>`
    )
    .join("");

  const bars = (slide.data?.bars ?? [])
    .map(
      (bar) => html`
        <div class="kpi-bar">
          <div class="kpi-bar-meta">
            <span>${text(bar.label)}</span>
            <span>${text(bar.note)}</span>
          </div>
          <div class="kpi-track">
            <i data-width="${bar.value}"></i>
          </div>
        </div>`
    )
    .join("");

  return html`
    <div class="slide-frame kpi-slide" data-component="kpi">
      <header class="slide-head">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      <div class="kpi-numbers">${metrics}</div>
      <div class="kpi-bars">${bars}</div>
    </div>`;
}
