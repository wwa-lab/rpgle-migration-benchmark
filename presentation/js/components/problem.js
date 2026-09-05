import { html, text } from "../lib/dom.js";

export function renderProblem(slide) {
  const points = (slide.data?.points ?? [])
    .map(
      (point, index) => html`
        <article class="problem-card fragment fade-in" data-fragment-index="${index}">
          <span class="problem-index">${text(point.index)}</span>
          <h3>${text(point.title)}</h3>
          <p>${text(point.body)}</p>
        </article>`
    )
    .join("");

  return html`
    <div class="slide-frame">
      <header class="slide-head">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      <p class="lead">${text(slide.data?.lead ?? "")}</p>
      <div class="problem-grid">${points}</div>
    </div>`;
}
