import { html, text } from "../lib/dom.js";

export function renderTitle(slide) {
  const meta = (slide.data?.meta ?? [])
    .map(
      (item) => html`
        <div class="meta-item">
          <span class="meta-label">${text(item.label)}</span>
          <span class="meta-value">${text(item.value)}</span>
        </div>`
    )
    .join("");

  const title = String(slide.title ?? "")
    .split("\n")
    .map((line) => `<span>${text(line)}</span>`)
    .join("");

  return html`
    <div class="slide-frame title-slide">
      <div class="title-rule"></div>
      <p class="eyebrow">${text(slide.eyebrow)}</p>
      <h1 class="display">${title}</h1>
      <p class="kicker">${text(slide.kicker)}</p>
      <div class="title-meta">${meta}</div>
      <p class="title-foot">${text(slide.data?.footer ?? "")}</p>
    </div>`;
}
