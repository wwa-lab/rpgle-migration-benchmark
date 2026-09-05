import { html, text } from "../lib/dom.js";

export function renderClosing(slide) {
  const lines = (slide.data?.lines ?? [])
    .map(
      (line, index) => html`<li class="closing-line fragment fade-in" data-fragment-index="${index}">${text(line)}</li>`
    )
    .join("");
  const refs = (slide.data?.refs ?? [])
    .map(
      (ref) => html`
        <div class="closing-ref">
          <span>${text(ref.label)}</span>
          <code>${text(ref.value)}</code>
        </div>`
    )
    .join("");

  return html`
    <div class="slide-frame closing-slide">
      <p class="eyebrow">${text(slide.eyebrow)}</p>
      <h2 class="display">${text(slide.title)}</h2>
      <ol class="closing-list">${lines}</ol>
      <p class="closing-qa">${text(slide.data?.footer ?? "")}</p>
      <div class="closing-refs">${refs}</div>
    </div>`;
}
