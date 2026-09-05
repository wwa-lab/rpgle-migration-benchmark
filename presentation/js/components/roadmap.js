import { html, text } from "../lib/dom.js";

export function renderRoadmap(slide) {
  const phases = (slide.data?.phases ?? [])
    .map(
      (phase, index) => html`
        <article class="road-card fragment fade-up" data-fragment-index="${index}">
          <span class="road-when">${text(phase.when)}</span>
          <h3>${text(phase.title)}</h3>
          <ul>
            ${(phase.items ?? []).map((item) => html`<li>${text(item)}</li>`).join("")}
          </ul>
        </article>`
    )
    .join("");

  return html`
    <div class="slide-frame">
      <header class="slide-head">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      <div class="roadmap-grid">${phases}</div>
    </div>`;
}
