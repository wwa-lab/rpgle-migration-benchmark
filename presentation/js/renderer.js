import { components } from "./components/registry.js";

export function renderDeck(content, host) {
  host.innerHTML = "";
  (content.slides ?? []).forEach((slide, index) => {
    const render = components[slide.type];
    if (!render) {
      throw new Error(`Unknown slide type: ${slide.type}`);
    }
    const section = document.createElement("section");
    section.id = slide.id;
    section.dataset.slideType = slide.type;
    section.dataset.slideIndex = String(index + 1);
    if (slide.animation) {
      section.dataset.animation = slide.animation;
    }
    section.innerHTML = render(slide);
    if (slide.notes) {
      const notes = document.createElement("aside");
      notes.className = "notes";
      notes.textContent = slide.notes;
      section.appendChild(notes);
    }
    host.appendChild(section);
  });
}
