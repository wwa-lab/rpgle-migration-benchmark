import { html, text } from "../lib/dom.js";

function column(side, tone, index) {
  const items = (side.items ?? [])
    .map((item) => html`<li class="fragment fade-in" data-fragment-index="${index}">${text(item)}</li>`)
    .join("");
  return html`
    <section class="compare-col compare-${tone}">
      <p class="compare-label">${text(side.title)}</p>
      <ul>${items}</ul>
    </section>`;
}

export function renderComparison(slide) {
  return html`
    <div class="slide-frame comparison-slide" data-component="comparison">
      <header class="slide-head">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      <div class="compare-grid">
        ${column(slide.data?.before ?? {}, "before", 0)}
        <div class="compare-arrow fragment fade-in" data-fragment-index="1" aria-hidden="true">→</div>
        ${column(slide.data?.after ?? {}, "after", 1)}
      </div>
    </div>`;
}
