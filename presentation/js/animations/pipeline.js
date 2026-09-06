export function bindWorkflow(deck) {
  const root = deck.querySelector('[data-component="workflow"]');
  if (!root) {
    return;
  }

  const steps = [...root.querySelectorAll(".pipe-step")];
  const sync = () => {
    let lastVisible = -1;
    steps.forEach((step, index) => {
      const on = step.classList.contains("visible") || step.classList.contains("current-fragment");
      step.classList.toggle("is-active", on);
      if (on) {
        lastVisible = index;
      }
    });
    steps.forEach((step, index) => {
      step.classList.toggle("is-done", index < lastVisible);
    });
  };

  const observer = new MutationObserver(sync);
  steps.forEach((step) => observer.observe(step, { attributes: true, attributeFilter: ["class"] }));
}
