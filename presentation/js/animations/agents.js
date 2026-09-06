import { placeOnPath } from "./motion.js";

export function bindAgents(deck) {
  const root = deck.querySelector('[data-component="agents"]');
  if (!root) {
    return;
  }

  const cards = [...root.querySelectorAll(".agent-card")];
  const path = root.querySelector("#agent-flow-path");
  const token = root.querySelector(".agent-token");

  const sync = () => {
    let last = 0;
    cards.forEach((card, index) => {
      const on = card.classList.contains("visible") || card.classList.contains("current-fragment");
      card.classList.toggle("is-active", on);
      if (on) {
        last = index;
      }
    });
    const t = cards.length > 1 ? last / (cards.length - 1) : 0;
    placeOnPath(token, path, t);
  };

  placeOnPath(token, path, 0);
  const observer = new MutationObserver(sync);
  cards.forEach((card) => observer.observe(card, { attributes: true, attributeFilter: ["class"] }));
}
