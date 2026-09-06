import { renderTitle } from "./title.js";
import { renderSection } from "./section.js";
import { renderProblem } from "./problem.js";
import { renderCards } from "./cards.js";
import { renderArchitecture } from "./architecture.js";
import { renderWorkflow } from "./workflow.js";
import { renderAgents } from "./agents.js";
import { renderComparison } from "./comparison.js";
import { renderKpi } from "./kpi.js";
import { renderCode } from "./code.js";
import { renderRoadmap } from "./roadmap.js";
import { renderClosing } from "./closing.js";

export const components = {
  title: renderTitle,
  section: renderSection,
  problem: renderProblem,
  cards: renderCards,
  architecture: renderArchitecture,
  workflow: renderWorkflow,
  agents: renderAgents,
  comparison: renderComparison,
  kpi: renderKpi,
  code: renderCode,
  roadmap: renderRoadmap,
  closing: renderClosing
};
