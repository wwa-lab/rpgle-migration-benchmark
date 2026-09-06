import { renderDeck } from "./renderer.js";
import { bindArchitecture } from "./animations/dataflow.js";
import { bindWorkflow } from "./animations/pipeline.js";
import { bindAgents } from "./animations/agents.js";
import { playKpi, bindComparison } from "./animations/countup.js";

const CONTENT_URL = new URL("../content/rpgflow-demo.json", import.meta.url);

function bindHud(deck, meta) {
  const indexEl = document.querySelector("[data-slide-index]");
  const titleEl = document.querySelector("[data-deck-title]");
  const notesEl = document.querySelector("[data-speaker-notes]");
  if (titleEl) {
    titleEl.textContent = meta.title;
  }

  const sync = () => {
    const slide = deck.getCurrentSlide();
    const total = deck.getTotalSlides();
    const index = deck.getIndices().h + 1;
    if (indexEl) {
      indexEl.textContent = `${String(index).padStart(2, "0")}  /  ${String(total).padStart(2, "0")}`;
    }
    const notes = slide?.querySelector("aside.notes");
    if (notesEl) {
      notesEl.textContent = notes?.textContent ?? "";
    }
  };

  deck.on("slidechanged", sync);
  deck.on("ready", sync);
  deck.on("fragmentshown", sync);
  deck.on("fragmenthidden", sync);
  sync();
}

function bindHelp() {
  const help = document.querySelector("[data-help]");
  const notesRail = document.querySelector("[data-notes-rail]");
  help?.addEventListener("click", (event) => {
    if (event.target === help) {
      help.classList.remove("is-open");
    }
  });
  document.addEventListener("keydown", (event) => {
    if (event.key === "?" || (event.key === "/" && event.shiftKey)) {
      help?.classList.toggle("is-open");
    }
    if (event.key === "n" || event.key === "N") {
      if (event.target instanceof HTMLInputElement) {
        return;
      }
      notesRail?.classList.toggle("is-open");
    }
    if (event.key === "Escape") {
      help?.classList.remove("is-open");
    }
  });
}

function bindSlideEffects(deck) {
  const seen = new WeakSet();

  const apply = (slide) => {
    if (!slide || seen.has(slide)) {
      if (slide?.dataset.animation === "countup") {
        playKpi(slide);
      }
      return;
    }
    seen.add(slide);
    if (slide.dataset.animation === "dataflow" || slide.querySelector("[data-component=architecture]")) {
      bindArchitecture(slide);
    }
    if (slide.querySelector("[data-component=workflow]")) {
      bindWorkflow(slide);
    }
    if (slide.querySelector("[data-component=agents]")) {
      bindAgents(slide);
    }
    if (slide.querySelector("[data-component=comparison]")) {
      bindComparison(slide);
    }
    if (slide.dataset.animation === "countup") {
      playKpi(slide);
    }
  };

  deck.on("ready", () => apply(deck.getCurrentSlide()));
  deck.on("slidechanged", (event) => apply(event.currentSlide));
  apply(deck.getCurrentSlide());
}

async function main() {
  const response = await fetch(CONTENT_URL);
  if (!response.ok) {
    throw new Error(`Unable to load deck content: ${response.status}`);
  }
  const content = await response.json();
  document.title = content.meta.title;
  renderDeck(content, document.querySelector(".slides"));

  const deck = window.Reveal;
  await deck.initialize({
    width: 1920,
    height: 1080,
    margin: 0.06,
    minScale: 0.2,
    maxScale: 1.6,
    hash: true,
    slideNumber: false,
    progress: true,
    center: false,
    controls: true,
    controlsTutorial: false,
    transition: "fade",
    backgroundTransition: "fade",
    transitionSpeed: "default",
    fragments: true,
    fragmentInURL: true,
    keyboard: true,
    overview: true,
    touch: true,
    display: "flex",
    plugins: [window.RevealNotes]
  });

  bindHud(deck, content.meta);
  bindHelp();
  bindSlideEffects(deck);
}

main().catch((error) => {
  const host = document.querySelector(".slides");
  if (host) {
    host.innerHTML = `<section class="error-slide"><h1>Deck failed to load</h1><p>${String(error.message)}</p></section>`;
  }
  console.error(error);
});
