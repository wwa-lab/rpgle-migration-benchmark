import { html, text } from "../lib/dom.js";

export function renderSection(slide) {
  return html`
    <div class="slide-frame section-slide">
      <p class="eyebrow">${text(slide.eyebrow)}</p>
      <h2 class="display">${text(slide.title)}</h2>
      <p class="lead">${text(slide.data?.lead ?? "")}</p>
    </div>`;
}
