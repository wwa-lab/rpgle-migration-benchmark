import { html, text } from "../lib/dom.js";

export function renderAgents(slide) {
  const agents = slide.data?.agents ?? [];
  const cards = agents
    .map(
      (agent, index) => html`
        <article class="agent-card fragment fade-up" data-fragment-index="${index}" data-agent="${text(agent.id)}">
          <span class="agent-role">${text(agent.role)}</span>
          <strong>${text(agent.name)}</strong>
          <em>${text(agent.output)}</em>
        </article>`
    )
    .join("");

  const pathWidth = 1320;
  const step = agents.length > 1 ? pathWidth / (agents.length - 1) : 0;
  const dots = agents
    .map((_, index) => `<circle class="agent-dot" cx="${40 + index * step}" cy="28" r="4"></circle>`)
    .join("");

  return html`
    <div class="slide-frame agents-slide" data-component="agents">
      <header class="slide-head">
        <p class="eyebrow">${text(slide.eyebrow)}</p>
        <h2>${text(slide.title)}</h2>
      </header>
      <div class="agent-task">
        <span>${text(slide.data?.task?.label ?? "Task")}</span>
        <strong>${text(slide.data?.task?.title ?? "")}</strong>
        <p>${text(slide.data?.task?.body ?? "")}</p>
      </div>
      <div class="agent-row">${cards}</div>
      <svg class="agent-path" viewBox="0 0 1400 56" aria-hidden="true">
        <path id="agent-flow-path" d="M 40 28 H 1360" fill="none"></path>
        ${dots}
        <rect class="agent-token" x="0" y="0" width="92" height="32" rx="16"></rect>
        <text class="agent-token-label" text-anchor="middle">产物</text>
      </svg>
    </div>`;
}
