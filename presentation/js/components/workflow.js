import { html, text } from "../lib/dom.js";

export function renderWorkflow(slide) {
  const steps = slide.data?.steps ?? [];
  const cells = steps
    .map(
      (step, index) => html`
        <li class="pipe-step fragment fade-up" data-fragment-index="${index}" data-step="${text(step.id)}" data-status="${text(step.status)}">
          <span class="pipe-index">${String(index + 1).padStart(2, "0")}</span>
          <strong>${text(step.label)}</strong>
          <em>${text(step.detail)}</em>
          <i class="pipe-connector" aria-hidden="true"></i>
        </li>`
    )
    .join("");

  const aside = (slide.data?.aside ?? [])
    .map(
      (item) => html`
        <article class="pipe-aside">
          <span>${text(item.label)}</span>
          <p>${text(item.body)}</p>
        </article>`
    )
    .join("");

  return html`
    <div class="slide-frame workflow-slide" data-component="workflow">
      <header class="slide-head">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      <ol class="pipeline">${cells}</ol>
      <div class="pipe-notes">${aside}</div>
      <p class="hint">${text(slide.data?.caption ?? "")}</p>
    </div>`;
}
