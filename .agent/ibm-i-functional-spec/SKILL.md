---
name: ibm-i-functional-spec
description: >
  Generates structured IBM i (AS/400) Functional Specification documents from business
  requirements, change requests, or enhancement descriptions. V1.0 — tiered document system
  with Lite/Standard/Full levels based on functional complexity. Covers business context,
  current/future behavior, functional requirements, business rules (BR-xx shared across
  document chain), functional inputs/outputs, exception scenarios, and acceptance criteria.
  Automatically selects the right document level based on business scope. Use this skill
  whenever a user provides a business requirement, change request, or enhancement description
  and wants it converted into a Functional Spec for IBM i development. Also trigger when the
  user asks to "write a functional spec", "document the requirements", "spec the business
  rules", "write an FS", or describes a business change targeting IBM i, AS/400, iSeries,
  RPGLE, or CLLE and the intent is functional documentation rather than technical design or
  program specification. This is a functional-specification skill, not a technical-design or
  code-generation skill.
---

# IBM i Functional Spec Generator (V1.0)

Converts business requirements into standardized Functional Specification documents for
IBM i (AS/400) projects. The output is a business-functional document — never a Technical
Design, never a Program Spec, never source code.

**Document Chain Position:**

```
Business Requirement / Change Request → Functional Spec → Technical Design → Program Spec → Coding
```

This skill produces the Functional Spec layer. It sits upstream of the Technical Design.
Each document in the chain serves a different audience and a different review gate:

| Document | Purpose | Audience | Review Gate |
|----------|---------|----------|-------------|
| **Functional Spec** | Scope alignment — WHAT the business needs, WHY it needs it, HOW success is measured | Business analysts, process owners, project managers, SMEs | Business/scope review |
| **Technical Design** | Design alignment — WHAT responsibilities go WHERE, HOW objects interact, WHAT is impacted | Solution architects, tech leads | Design review |
| **Program Spec** | Implementation handoff — step-by-step logic, field-level processing, parameter contracts | Developers, testers | Build review |

The Functional Spec must never collapse into a Technical Design. If the output describes
module allocation, object interactions, file access patterns, or program-level interfaces,
it has crossed into technical territory and failed its purpose.

---

## When to Use This Skill

Trigger on any of these signals:
- User provides a business requirement or change request and asks for a functional spec
- User mentions IBM i, AS/400, iSeries, RPGLE, or CLLE and the intent is requirements documentation
- User asks to "write a functional spec", "document requirements", "spec the business rules", or "write an FS"
- User wants a structured document for scope alignment or business review
- User provides an enhancement description and needs business-level scoping before technical design
- User asks "what does this change need to do?" or "what are the business requirements?" for IBM i

**Do NOT trigger** when:
- User asks for a Technical Design (use `ibm-i-technical-design` instead)
- User asks for a Program Spec (use `ibm-i-program-spec` instead)
- User asks about module allocation, object interaction, file access design, or program interfaces
- User asks for code, SQL, or RPG source

---

## Role

You are an IBM i (AS/400) business analyst and functional specification specialist. Your
responsibility is to produce Functional Specification documents — not Technical Designs,
not Program Specs, not code, not informal analysis. The document must be directly usable
as input for business review, scope alignment, and downstream Technical Design generation.

You think in terms of:
- Business outcomes, not technical structure
- Functional behavior, not module responsibility
- User/operator experience, not program internals
- Business rules, not implementation conditions
- Process flow visible to the business, not processing stages internal to the system

---

## Core Process

### Step 1 — Gather Inputs and Determine Document Level

Identify from the user's message:
1. **Business Requirement** (mandatory) — what the business needs
2. **Change Type** — New Function or Enhancement to Existing
3. **Business Scope** — how many business rules, process touchpoints, or user roles are involved
4. **Platform Context** — note if the user mentions RPGLE, CLLE, batch, online, or specific IBM i details (record for downstream handoff, but do not elaborate technically)

Then determine the **Document Level** using this decision table:

| Condition | Level |
|-----------|-------|
| New business function or process with multiple actors, dependencies, or process branches | **L3 (Full)** |
| Enhancement that significantly changes business flow, adds multiple rules, or affects multiple user/process touchpoints | **L3 (Full)** |
| Enhancement that adds or modifies business rules, changes observable process behavior, or introduces new inputs/outputs | **L2 (Standard)** |
| Enhancement that affects multiple business rules or alters exception handling visible to users | **L2 (Standard)** |
| Small enhancement with narrow business impact — single rule change, threshold change, message change | **L1 (Lite)** |
| Cosmetic or label-only change with no business behavior impact | **L1 (Lite)** |
| User explicitly requests a specific level | **Use requested level** |
| Unclear | **Default to L2 (Standard)**, note in Open Questions |

If the requirement is too vague to determine even the functional scope, ask for clarification
before proceeding — do not guess.

### Step 2 — Identify Functional Requirements and Business Rules

Separate the requirement into **Functional Requirements** (FR-nn) and **Business Rules**
(BR-xx). FRs describe what capabilities the system must provide. BRs describe the
constraints, policies, or decision criteria that govern those capabilities. Do not duplicate
content across the two — state each item once in its natural category.

Express business rules as numbered entries (BR-01, BR-02, etc.) — the same BR-xx convention
used in Technical Design and Program Spec.

The numbering convention is shared across the full document chain so that rules maintain
identity from Functional Spec through Technical Design through Program Spec:

| Layer | Same BR-xx | Expressed As |
|-------|-----------|--------------|
| **Functional Spec** | BR-01 | "Orders exceeding the customer credit limit must be rejected" — states the business rule |
| **Technical Design** | BR-01 | "Orders exceeding the customer credit limit must be rejected" — allocates the rule to a module |
| **Program Spec** | BR-01 | "IF ORDAMT > CRDLMT → set RETCODE = 1, return error" — implements the rule as a condition |

The Functional Spec states the business rule. The Technical Design allocates it. The Program
Spec implements it. The BR number bridges all three.

Rules:
- Each BR must be atomic and independently testable from a business perspective
- BRs at this level describe the business constraint in business language
- Do not express BRs as implementation conditions or technical logic
- If a requirement implies a rule but the exact condition is not stated, create a TBD rule
  and add it to Open Questions
- For **enhancements**: tag rules as `(NEW)`, `(MODIFIED)`, or `(EXISTING — context only)`
- Include `(EXISTING — context only)` rules only when they are necessary to understand
  a new or modified rule — do not list every existing rule in the process

### Step 3 — Document Current and Future Behavior

For enhancements, describe:
- **Current behavior**: how the process works today, as seen by the business
- **Future behavior**: how the process will work after the change

For new functions, describe:
- **Future behavior**: the desired functional behavior from end to end

This is the most important analytical step. The current/future comparison is what makes
the change reviewable by business stakeholders.

Describe behavior in business terms — what the user sees, what the process does from a
business perspective, what outcomes are produced. Do not describe technical processing
stages, module interactions, or program internals.

### Step 4 — Define Acceptance Criteria

Every Functional Spec must include acceptance criteria that are testable at the business
level. Acceptance criteria answer: "How will the business verify this works correctly?"

Each criterion should be:
- Specific — references a BR-xx or FR-nn
- Observable — can be verified through business-visible behavior
- Independent — testable without knowledge of program internals

For enhancements: cover every **(NEW)** and **(MODIFIED)** FR and BR. Items tagged
**(EXISTING — context only)** do not need separate criteria unless the enhancement
directly affects their observable behavior.

### Step 5 — Self-Check

Before outputting, verify every applicable item in the Quality Rules section below.
Confirm the document reads as a business-functional document — not as a Technical Design.

---

## Output Structure

Include sections per the Section Inclusion Table for the determined Document Level.
For REQUIRED sections with no content, write `N/A`. For CONDITIONAL sections that are
irrelevant, omit them entirely. Maintain section order as listed below.

### Section Inclusion Table

| Section | L1 (Lite) | L2 (Standard) | L3 (Full) |
|---------|-----------|---------------|-----------|
| Document Header | REQUIRED | REQUIRED | REQUIRED |
| Amendment History | REQUIRED | REQUIRED | REQUIRED |
| Functional Overview | REQUIRED | REQUIRED | REQUIRED |
| Business Context / Background | OPTIONAL | REQUIRED | REQUIRED |
| Business Objective | REQUIRED | REQUIRED | REQUIRED |
| Scope and Boundary | REQUIRED | REQUIRED | REQUIRED |
| Current Process / Current Behavior | CONDITIONAL | REQUIRED | REQUIRED |
| Future Process / Desired Behavior | REQUIRED | REQUIRED | REQUIRED |
| Functional Requirements | REQUIRED | REQUIRED | REQUIRED |
| Business Rules | REQUIRED | REQUIRED | REQUIRED |
| Functional Inputs / Outputs | CONDITIONAL | REQUIRED | REQUIRED |
| User / Role / Trigger Context | OPTIONAL | CONDITIONAL | REQUIRED |
| Exception Scenarios | REQUIRED | REQUIRED | REQUIRED |
| Acceptance Criteria | REQUIRED | REQUIRED | REQUIRED |
| Upstream / Downstream Business Dependencies | CONDITIONAL | REQUIRED | REQUIRED |
| Assumptions / Constraints | REQUIRED | REQUIRED | REQUIRED |
| Open Questions / TBD | REQUIRED | REQUIRED | REQUIRED |
| Functional Summary | REQUIRED | REQUIRED | REQUIRED |

Classification meanings:
- **REQUIRED**: Always include. Write `N/A` if genuinely empty.
- **CONDITIONAL**: Include if the enhancement touches this area. Omit entirely if irrelevant.
- **OPTIONAL**: Include only if the user provides relevant information or it adds clear value.

---

### Section Definitions

```
## Document Header

- **Document ID:** <FS-yyyymmdd-nn>
- **Document Level:** <L1 Lite | L2 Standard | L3 Full>
- **Version:** 1.0
- **Status:** Draft | Review | Approved
- **Change Type:** <New Function | Enhancement to Existing>
- **Target Platform:** <IBM i>
- **Related Business Process:** <name(s) or TBD>
- **Description:** <One to two sentence functional summary>

---

## Amendment History

| Version | Date | Author | Change Description |
|---------|------|--------|--------------------|
| 1.0     | TBD  | TBD    | Initial draft      |

---

## Functional Overview

<2–4 sentence narrative: what business function is being specified, why, and for
whom. This is the executive summary. A business stakeholder should understand the
purpose and scope from this section alone.

For enhancements: state what exists today, what changes, and why the business
needs the change.>

---

## Business Context / Background

- **Business Area:** <which part of the business this serves>
- **Current Pain Point or Driver:** <why this change is needed — business reason>
- **Requesting Stakeholder:** <role or team, or TBD>
- **Business Priority:** <if stated, or TBD>

<Provide enough context for a reviewer unfamiliar with the specific process to
understand why this Functional Spec exists.>

---

## Business Objective

<State the business goal in 1–3 sentences. What must the business achieve?
This is not a restatement of the requirement — it is the business outcome
that satisfies the requirement.

Example: "Prevent orders from being accepted when the customer has exceeded
their credit limit, reducing bad debt write-offs.">

---

## Scope and Boundary

### In Scope

<Bulleted list: what this Functional Spec covers>

### Out of Scope

<Bulleted list: what this Functional Spec explicitly does NOT cover>

### Boundary Notes

<Anything the reader needs to know about the edges of this scope: upstream
processes assumed to be in place, downstream processes not covered here,
related changes being handled separately.>

---

## Current Process / Current Behavior

<Describe how the process works today, as visible to the business. What does the
user or operator see? What does the system do from the business perspective? What
are the current business outcomes?

For enhancements, this is the baseline against which the change will be reviewed.
Without a clear current state, the future state cannot be properly evaluated.

For new functions: write "N/A — new function. No current process exists."

For L1 enhancements: describe only the specific behavior that is changing. Do not
describe the entire current process — just enough baseline for the reader to
understand what the change modifies. One to three sentences is typical for L1.

Describe in business terms. Do not describe technical internals — no file reads,
no program calls, no processing stages. Describe what the user/operator experiences
and what business results are produced.>

---

## Future Process / Desired Behavior

<Describe how the process will work after the change, as visible to the business.
What will the user or operator see differently? What will the system do differently
from the business perspective? What business outcomes will change?

This is the core of the Functional Spec. A business reviewer should be able to read
Current Behavior and Future Behavior side by side and understand exactly what changes.

For enhancements: clearly distinguish what changes from what stays the same.
For new functions: describe the complete desired behavior end to end.

Describe in business terms only. Do not describe how programs will be structured,
which modules will handle which responsibility, or how data flows between objects.
Those belong in the Technical Design.>

---

## Functional Requirements

<Functional Requirements describe what capabilities or behaviors the business needs
the system to provide. Each FR states a function — something the system must DO.>

FR-01: <capability — what the system must do, stated as a behavior>
FR-02: <capability>
FR-03: <capability>

<FR vs BR distinction:>
- **FR = function**: "The system must validate credit limits before accepting orders"
- **BR = constraint**: "Orders exceeding the customer credit limit must be rejected"

<FRs describe WHAT the system provides. BRs describe the rules that GOVERN those
functions. A single FR may be governed by multiple BRs. Do not duplicate content
across FR and BR — state the function in FR, state the governing rule in BR.>

<For enhancements, tag each requirement:>
- **(NEW)** — did not exist before
- **(MODIFIED)** — existed, being changed
- **(EXISTING — context only)** — unchanged, included only for clarity

---

## Business Rules

<Business Rules describe the constraints, policies, or decision criteria that govern
functional requirements. Each BR states a rule — a condition the business enforces.
BR-xx numbers carry forward into Technical Design and Program Spec.>

BR-01: <rule — a business constraint, policy, or decision criterion>
BR-02: <rule>
BR-03: <rule>

<BR vs FR distinction:>
- **BR = constraint**: "Orders exceeding the customer credit limit must be rejected"
- **FR = function**: "The system must validate credit limits before accepting orders"

<BRs govern FRs. Do not restate a function as a rule or a rule as a function. If an
item is a capability the system must provide, it is an FR. If it is a condition or
policy that governs behavior, it is a BR.>

<Rules must be stated in business language:>
- GOOD: "Orders exceeding the customer credit limit must be rejected"
- BAD: "IF ORDAMT > CRDLMT THEN reject" (this is implementation language)

<For enhancements, tag each rule:>
- **(NEW)** — did not exist before
- **(MODIFIED)** — existed, being changed. State both old and new rule.
- **(EXISTING — context only)** — unchanged, included only when needed to
  understand a new or modified rule

---

## Functional Inputs / Outputs

### Inputs

<What information enters this process? Describe at business level — not field
names or parameter types.>

| Input | Source | Description |
|-------|--------|-------------|
| <what> | <where it comes from — user, upstream process, schedule, etc.> | <business meaning> |

### Outputs

<What information or outcomes does this process produce? Describe at business level.>

| Output | Destination | Description |
|--------|-------------|-------------|
| <what> | <where it goes — user, downstream process, report, etc.> | <business meaning> |

<STOP POINT: Do NOT describe field names, data types, parameter contracts, or
file-level detail. Those belong in Technical Design or Program Spec.>

---

## User / Role / Trigger Context

<Who interacts with this process and how is it initiated?>

| Actor | Role | Interaction |
|-------|------|-------------|
| <user, operator, scheduler, upstream process> | <what role they play> | <what they do or trigger> |

- **Primary Trigger:** <what starts this process — user action, schedule, event, command>
- **Frequency:** <how often this runs or is triggered, if known, or TBD>

---

## Exception Scenarios

<Describe what happens when things go wrong, from the business perspective.
Only include scenarios that are visible to users, operators, or business
stakeholders. Internal technical failures (file locks, system errors, job
abends) are not exception scenarios — they belong in Technical Design.>

| # | Scenario | Business Outcome | Severity |
|---|----------|------------------|----------|
| E-01 | <what goes wrong — in business terms visible to the user or operator> | <what should happen — user message, process halt, notification, etc.> | Critical / High / Medium / Low |

<Exception scenarios answer: "What does the business expect to see when this
goes wrong?" — not "What does the program do internally when this fails."

Include only exceptions that a business stakeholder would recognize:>
- GOOD: "Customer not found when order is submitted" — business-visible
- GOOD: "Credit limit exceeded during order entry" — business-visible
- BAD: "File lock timeout on CUSTMAST" — internal technical failure
- BAD: "Program returns error code 9" — implementation detail

<Error handling strategy, return codes, and logging belong in Technical Design
and Program Spec.>

---

## Acceptance Criteria

<Each criterion must be testable at the business level — verifiable through
observable behavior without knowledge of program internals.>

| # | Criterion | Validates |
|---|-----------|-----------|
| AC-01 | <Given [precondition], when [action], then [expected result]> | BR-xx / FR-nn |
| AC-02 | <Given [precondition], when [action], then [expected result]> | BR-xx / FR-nn |

<Coverage rules:>
- Every **(NEW)** and **(MODIFIED)** FR and BR must be covered by at least one
  acceptance criterion
- **(EXISTING — context only)** items do not need separate acceptance criteria
  unless the enhancement directly affects their observable behavior
- If a new or modified rule cannot be expressed as a testable criterion, flag it
  in Open Questions

<Acceptance criteria must reference business-visible behavior:>
- GOOD: "Given a customer with a $5,000 credit limit and a $6,000 order, when the
  order is submitted, then the order is rejected with a credit limit exceeded message"
- BAD: "Given CRDLMT = 5000 and ORDAMT = 6000, when ORDVAL is called, then RETCODE = 1"
  (this is implementation-level — belongs in Program Spec test cases)

---

## Upstream / Downstream Business Dependencies

### Upstream

<What processes, systems, or inputs must be in place for this function to work?>

| Dependency | Type | Description |
|------------|------|-------------|
| <process or system> | <data / trigger / prerequisite> | <what it provides> |

### Downstream

<What processes, systems, or outputs depend on this function?>

| Dependent | Type | Description |
|-----------|------|-------------|
| <process or system> | <data / trigger / consumer> | <what it consumes> |

<Describe dependencies at business/process level. Do not describe program call chains,
file dependencies, or object interaction maps — those belong in Technical Design.>

---

## Assumptions / Constraints

### Assumptions

<Bulleted list. Each assumption is something that, if false, would change the
functional requirements.>

### Constraints

<Bulleted list. Business constraints, regulatory requirements, timeline constraints,
or process limitations that the solution must work within.>

---

## Open Questions / TBD

| # | Section | Question | Source | Status |
|---|---------|----------|--------|--------|
| 1 | <section> | <question> | <Requirement / Business / Dependency> | Open |

<Every TBD in the document must have a corresponding entry here.
Every (Inferred) element should appear if confirmation is needed.>

---

## Functional Summary

- **Document Level:** <L1 / L2 / L3>
- **Change Type:** <New Function / Enhancement to Existing>
- **Target Platform:** <IBM i>
- **Total Functional Requirements (FR):** <count> (<new> new, <modified> modified)
- **Total Business Rules (BR):** <count> (<new> new, <modified> modified)
- **Total Exception Scenarios:** <count>
- **Total Acceptance Criteria:** <count>
- **Total Open Questions:** <count>
- **Business Review Ready:** <Yes / No — if No, list blockers>
```

---

## Document Level Guidance

### L1 — Lite Functional Spec

**Use when**: The enhancement is small, with narrow business impact — a single rule change,
a threshold adjustment, a message change, or a minor validation addition.

**Typical enhancements**:
- Change a validation threshold (e.g., credit limit from $5,000 to $10,000)
- Add a simple business rule within an existing process
- Modify a user-facing message or label
- Change an exception outcome

**Key principle**: Document the business change clearly and concisely. A well-formed L1
is half a page to one page. It is a functional change note, not a full requirements document.

**L1 should be short.** Keep sections brief:
- Functional Overview: 2–3 sentences
- Current Behavior: 1–3 sentences covering only the behavior being changed
- Future Behavior: one paragraph describing the change
- Functional Requirements: only new/modified FRs
- Business Rules: only new/modified BRs
- Exception Scenarios: only if the change affects exception handling
- Acceptance Criteria: 1–3 criteria covering the new/modified items

### L2 — Standard Functional Spec

**Use when**: The enhancement adds or modifies multiple business rules, changes observable
process behavior, or introduces new inputs/outputs affecting multiple touchpoints.

**Typical enhancements**:
- Add a new validation process visible to users
- Modify how a business process behaves under certain conditions
- Add new inputs or outputs to an existing process
- Change exception handling visible to users or operators

**Key principle**: Full functional specification of the change, including current/future
behavior comparison, complete rule set, and comprehensive acceptance criteria.

### L3 — Full Functional Spec

**Use when**: A new business function is being introduced, or an existing process is being
fundamentally changed — multiple actors, multiple business rules, new process flow, large
acceptance scope.

**Typical scenarios**:
- New business function from scratch
- Major rework of an existing business process
- New process with multiple user roles or triggers
- Enhancement with broad business impact across multiple areas

**Key principle**: Complete functional specification for business review, scope agreement,
and downstream Technical Design generation. All sections are required.

---

## Decision Examples

| Requirement | Level | Reasoning |
|-------------|-------|-----------|
| "Change the credit limit from $5,000 to $10,000" | L1 | Single rule change, narrow scope |
| "Add a check: reject orders for inactive customers" | L2 | New rule, new exception scenario, changed process behavior |
| "Add the ability to override credit limit with supervisor approval" | L2 | New input, new role, modified rules, new acceptance criteria |
| "Build a new order validation process that checks credit, inventory, and shipping eligibility" | L3 | New function, multiple rules, multiple actors, full process |
| "Redesign the returns process to support online and in-store returns with different approval workflows" | L3 | Major rework, multiple flows, multiple roles |
| "Change the 'customer not found' error message wording" | L1 | Cosmetic, no business behavior change |

---

## Core Rules

### Safe Draft Rule

When requirements are incomplete but sufficient to identify a reasonable functional direction,
generate the best possible Functional Spec draft. Mark all unknowns as `TBD (To Be Confirmed)`
and all reasonable inferences as `(Inferred)`. Do not withhold a useful draft because some
details are missing — in enterprise environments, requirements are often incomplete, and the
team needs a reviewable draft to drive clarification.

Only ask clarifying questions when the input is too vague to safely establish even the
functional scope or change type. Otherwise, produce the draft and let Open Questions drive
the review.

### No Hallucination Rule

Never invent business rules, process steps, user roles, system names, or business outcomes.
If not explicitly provided by the user, mark `TBD (To Be Confirmed)`.

### No Assumed Logic Rule

Never fill in business logic, functional behavior, or process steps not supported by the
requirement. If ambiguous, mark TBD and add to Open Questions.

### Inferred Content Rule

If a functional element can be reasonably inferred from the requirement but is not explicitly
stated, it may be included — but must be labeled `(Inferred)` and flagged in Open Questions
for confirmation. Inferred content must never be presented as confirmed fact.

### Functional Abstraction Rule

The Functional Spec must operate at the business-functional level. If any section describes
technical structure — module allocation, object interactions, file access patterns, program
interfaces, processing stages, error handling strategies, or return code definitions — it has
crossed into Technical Design territory.

**Test**: Can this section be understood by a business analyst or process owner who has no
knowledge of program internals? If yes, the abstraction level is correct. If no, it is too
technical.

### Downstream Deferral Rule

If content belongs naturally to the downstream Technical Design or Program Spec, do not
include it in the Functional Spec. Describe functional behavior only.

Apply by asking: **"Does a business stakeholder need this detail to review and approve the
functional scope, or does only a technical team need it to design or build the solution?"**

- If only a technical team needs it → defer to Technical Design or Program Spec
- If a business stakeholder needs it → include at functional level

| Content Type | Functional Spec (business-level) | Deferred To |
|-------------|----------------------------------|-------------|
| Business rules | State the business constraint | Technical Design allocates to module; Program Spec implements as condition |
| Process behavior | Describe what the user/business sees | Technical Design maps processing stages; Program Spec details logic steps |
| Inputs / outputs | Describe at business level (what, from where, to where) | Technical Design maps to objects; Program Spec defines field-level contracts |
| Exceptions | Describe business outcome when errors occur | Technical Design defines error strategy; Program Spec defines return codes |
| Acceptance criteria | Business-testable given/when/then | Program Spec defines test cases with technical detail |
| Module structure | Not included | Technical Design |
| Object interaction | Not included | Technical Design |
| File access / data queues | Not included | Technical Design |
| Program interfaces / parameters | Not included | Technical Design / Program Spec |
| Implementation logic | Not included | Program Spec |

When in doubt, defer. A Functional Spec that defers too much to Technical Design is a minor
gap. A Functional Spec that includes technical design content is a layer violation.

### Enhancement Tagging Rule

For enhancements, tag requirements, rules, and behavior as:
- **(NEW)** — introduced by this change
- **(MODIFIED)** — existing, changed by this enhancement
- **(EXISTING — context only)** — unchanged, included for clarity

**Signal over noise:** Include `(EXISTING — context only)` entries only when they are
necessary to understand a new or modified element. Do not list every existing rule,
requirement, or process step. A document cluttered with EXISTING rows obscures the
actual change.

---

## Quality Rules

Before outputting, confirm each applicable rule. Skip rules for sections that are
irrelevant at the current Document Level.

**All levels (L1, L2, L3):**
- [ ] Document Header includes Document Level, Change Type, and Document ID
- [ ] Functional Overview is readable as a standalone summary
- [ ] Business Objective states the business goal, not just the requirement
- [ ] Scope and Boundary clearly separates in-scope from out-of-scope
- [ ] Business Rules exist with numbered BR-xx entries stated in business language
- [ ] Functional Requirements exist with numbered FR-nn entries
- [ ] FRs describe capabilities/behaviors; BRs describe constraints/policies — no duplication
- [ ] Future Process / Desired Behavior describes what changes in business terms
- [ ] Exception Scenarios describe only business-visible outcomes, not internal technical failures
- [ ] Acceptance Criteria are testable at business level without program knowledge
- [ ] Every NEW and MODIFIED BR and FR is covered by at least one acceptance criterion
- [ ] No business rules, user roles, or process steps were invented
- [ ] All unknowns are marked `TBD (To Be Confirmed)`
- [ ] All inferred content is labeled `(Inferred)` and appears in Open Questions
- [ ] Open Questions table lists every TBD and every inference requiring confirmation
- [ ] Functional Summary counts are accurate
- [ ] Section Inclusion Table was followed for the Document Level

**L2 and L3 only:**
- [ ] Current Process / Current Behavior describes today's state in business terms
- [ ] Current and Future Behavior are clearly distinguishable
- [ ] Functional Inputs / Outputs are described at business level, not field level
- [ ] Upstream / Downstream Business Dependencies are identified at process level

**L3 only:**
- [ ] Business Context / Background is fully populated
- [ ] User / Role / Trigger Context identifies all actors
- [ ] All REQUIRED sections are present (none omitted)

**Enhancement documents (any level):**
- [ ] Business rules are tagged (NEW) / (MODIFIED) / (EXISTING — context only)
- [ ] Functional requirements are tagged (NEW) / (MODIFIED) / (EXISTING — context only)
- [ ] EXISTING entries are included only when needed for change clarity
- [ ] Functional Summary includes new/modified counts

**Anti-Pattern Check — Technical Drift (all levels):**
- [ ] No module allocation or responsibility assignment
- [ ] No object interaction maps or file access summaries
- [ ] No program interface descriptions or parameter tables
- [ ] No processing stages or technical error handling strategies
- [ ] No data queue, data area, or call chain descriptions
- [ ] No field names, data types, or record layouts
- [ ] No return codes or technical error categories
- [ ] No deployment, migration, or compile-order notes
- [ ] Every section passes the business analyst test: "Can a business analyst
      understand this without knowledge of program internals?"
- [ ] No section contains content that belongs in Technical Design or Program Spec

**L1 brevity check:**
- [ ] L1 document fits within half a page to one page of content
- [ ] No section is overelaborated relative to the business scope of the change
- [ ] Acceptance criteria are present but proportionate (1–3 criteria)

---

## Relationship to Technical Design

This Functional Spec is the **input** for downstream Technical Design generation using the
`ibm-i-technical-design` skill. The handoff works as follows:

| Functional Spec Produces | Technical Design Consumes |
|--------------------------|--------------------------|
| Business Objective | Design objective and solution scope |
| Current / Future Behavior | High-level processing flow and design boundary |
| Functional Requirements (FR-nn) | Design scope — what must be solved technically |
| Business Rules (BR-xx) | BR-xx allocation to modules and processing stages |
| Functional Inputs / Outputs | Data / object interaction candidates |
| Exception Scenarios | Error handling strategy categories |
| Acceptance Criteria | Design validation targets and downstream test scope |
| Upstream / Downstream Dependencies | Interface / dependency design scope |

The BR-xx numbers carry forward. A rule numbered BR-03 in the Functional Spec remains
BR-03 in the Technical Design and BR-03 in the Program Spec — only the expression changes
across layers.

Recommended workflow when all three skills are available:
1. Generate Functional Spec (this skill) → business review → scope approval
2. Generate Technical Design (`ibm-i-technical-design`) → design review → design approval
3. Generate Program Spec (`ibm-i-program-spec`) for each module → build review → implementation

---

## Reference Files

- `references/section-guide.md` — Detailed guidance on what belongs in each section
- `references/tier-guide.md` — Examples and detailed rules for each Document Level
- `examples/sample-new-function.md` — Example L3 Full Functional Spec (new function)
- `examples/sample-enhancement.md` — Example L2 Standard enhancement spec
- `examples/sample-lite.md` — Example L1 Lite enhancement spec

Read these if you need additional context on section content or formatting.
