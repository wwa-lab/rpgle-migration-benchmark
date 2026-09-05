import { html, text } from "../lib/dom.js";
import { renderCodePanel } from "./code.js";

export function renderCards(slide) {
  const items = (slide.data?.items ?? [])
    .map(
      (item, index) => html`
        <article class="stat-card fragment fade-up" data-fragment-index="${index}">
          <span class="stat-label">${text(item.label)}</span>
          <strong class="stat-value">${text(item.value)}</strong>
          <span class="stat-hint">${text(item.hint ?? "")}</span>
        </article>`
    )
    .join("");

  const code = slide.data?.code
    ? renderCodePanel(slide.data.code, slide.data.items?.length ?? 0)
    : "";

  return html`
    <div class="slide-frame current-slide">
      <header class="slide-head">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      <div class="current-layout">
        <div>
          <div class="stat-grid">${items}</div>
          <p class="aside-note">${text(slide.data?.aside ?? "")}</p>
        </div>
        ${code}
      </div>
    </div>`;
}
