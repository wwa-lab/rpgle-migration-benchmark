import { followPath } from "./motion.js";

function reset(root) {
  root.querySelectorAll(".arch-node, .arch-edge").forEach((node) => {
    node.classList.remove("is-live", "is-dim");
  });
}

function activate(root, edgeIds) {
  const live = new Set(edgeIds);
  const liveNodes = new Set();

  root.querySelectorAll(".arch-edge").forEach((edge) => {
    const on = live.has(edge.dataset.edge);
    edge.classList.toggle("is-live", on);
    edge.classList.toggle("is-dim", !on);
    if (on) {
      liveNodes.add(edge.dataset.from);
      liveNodes.add(edge.dataset.to);
    }
  });

  root.querySelectorAll(".arch-node").forEach((node) => {
    const on = liveNodes.has(node.dataset.node);
    node.classList.toggle("is-live", on);
    node.classList.toggle("is-dim", !on);
  });
}

export function bindArchitecture(deck) {
  const root = deck.querySelector('[data-component="architecture"]');
  if (!root || root.dataset.bound === "1") {
    return;
  }
  root.dataset.bound = "1";

  const packet = root.querySelector(".arch-packet");
  const details = root.querySelectorAll(".arch-detail");
  const fallback = root.querySelector(".arch-detail.is-default");

  root.querySelectorAll(".arch-node").forEach((node, index) => {
    node.style.opacity = "0";
    window.setTimeout(() => {
      node.style.opacity = "";
    }, 80 + index * 70);

    node.addEventListener("click", (event) => {
      event.preventDefault();
      event.stopPropagation();
      const id = node.dataset.node;
      details.forEach((item) => item.classList.toggle("is-on", item.dataset.detail === id));
      if (fallback) {
        fallback.hidden = true;
      }
      root.querySelectorAll(".arch-node").forEach((item) => {
        item.classList.toggle("is-selected", item === node);
      });
    });
  });

  const runFlow = (step) => {
    if (!step) {
      reset(root);
      return;
    }
    const ids = (step.dataset.edges ?? "").split(",").filter(Boolean);
    activate(root, ids);
    ids.forEach((id, index) => {
      const path = root.querySelector(`#${CSS.escape(id)}`);
      window.setTimeout(() => followPath(packet, path, 1200), index * 160);
    });
  };

  const currentFlow = () =>
    [...root.querySelectorAll(".flow-step")].reverse().find((step) => (
      step.classList.contains("current-fragment") || step.classList.contains("visible")
    ));

  const observer = new MutationObserver(() => runFlow(currentFlow()));
  root.querySelectorAll(".flow-step").forEach((step) => {
    observer.observe(step, { attributes: true, attributeFilter: ["class"] });
  });
}
