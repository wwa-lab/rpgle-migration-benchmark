import { html, text } from "../lib/dom.js";

function column(side, tone) {
  const items = (side.items ?? [])
    .map((item) => html`<li>${text(item)}</li>`)
    .join("");
  return html`
    <div class="compare-col compare-${tone}">
      <p class="compare-label">${text(side.title)}</p>
      <ul>${items}</ul>
    </div>`;
}

export function renderComparison(slide) {
  return html`
    <div class="slide-frame comparison-slide" data-component="comparison">
      <header class="slide-head">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      <div class="compare-grid">
        ${column(slide.data?.before ?? {}, "before")}
        <div class="compare-arrow fragment fade-in" aria-hidden="true">→</div>
        ${column(slide.data?.after ?? {}, "after")}
      </div>
    </div>`;
}
