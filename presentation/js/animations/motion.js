export function easeOutCubic(t) {
  return 1 - (1 - t) ** 3;
}

export function animateCount(el, to, duration = 900) {
  const suffix = el.dataset.suffix ?? "";
  const start = performance.now();
  const from = 0;

  function frame(now) {
    const progress = Math.min(1, (now - start) / duration);
    const value = Math.round(from + (to - from) * easeOutCubic(progress));
    el.textContent = `${value.toLocaleString("en-US")}${suffix}`;
    if (progress < 1) {
      requestAnimationFrame(frame);
    }
  }

  requestAnimationFrame(frame);
}

export function followPath(packet, path, duration = 1400) {
  if (!packet || !path || typeof path.getTotalLength !== "function") {
    return;
  }
  const length = path.getTotalLength();
  if (!length) {
    return;
  }
  packet.removeAttribute("hidden");
  const start = performance.now();

  function frame(now) {
    const progress = Math.min(1, (now - start) / duration);
    const point = path.getPointAtLength(length * easeOutCubic(progress));
    packet.setAttribute("cx", String(point.x));
    packet.setAttribute("cy", String(point.y));
    packet.style.opacity = progress < 0.08 ? String(progress / 0.08) : progress > 0.92 ? String((1 - progress) / 0.08) : "1";
    if (progress < 1) {
      requestAnimationFrame(frame);
    }
  }

  requestAnimationFrame(frame);
}

export function placeOnPath(el, path, t) {
  if (!el || !path) {
    return;
  }
  const length = path.getTotalLength();
  const point = path.getPointAtLength(length * t);
  el.setAttribute("transform", `translate(${point.x - 46} ${point.y - 16})`);
  const label = el.parentNode?.querySelector(".agent-token-label");
  if (label) {
    label.setAttribute("transform", `translate(${point.x} ${point.y + 5})`);
    label.removeAttribute("x");
    label.removeAttribute("y");
  }
}
