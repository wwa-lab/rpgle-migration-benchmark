import { animateCount } from "./motion.js";

export function playKpi(slideEl) {
  const root = slideEl.querySelector('[data-component="kpi"]');
  if (!root || root.dataset.played === "1") {
    return;
  }
  root.dataset.played = "1";
  root.querySelectorAll("[data-count]").forEach((el) => {
    animateCount(el, Number(el.dataset.count), 1100);
  });
  root.querySelectorAll(".kpi-track i").forEach((bar) => {
    requestAnimationFrame(() => {
      bar.style.width = `${bar.dataset.width}%`;
    });
  });
}

export function bindComparison(slideEl) {
  const root = slideEl.querySelector('[data-component="comparison"]');
  if (!root) {
    return;
  }
  root.classList.add("is-ready");
}
