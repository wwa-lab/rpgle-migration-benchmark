# Tier Guide — Functional Spec Document Levels (V1.0)

Detailed rules for selecting and applying each Document Level.

---

## Why Tiering Exists

Not every business change needs a 4-page functional specification. A threshold change
needs a focused change note. A new business process needs comprehensive scoping. Tiering
matches document depth to business complexity so that:

1. **Small changes get fast, clear documentation** — a single-rule change does not require
   a full process description, dependency analysis, and role mapping.
2. **Large changes get thorough scoping** — a new business function with multiple actors,
   rules, and dependencies needs all sections to prevent scope gaps downstream.
3. **Business reviewers see proportionate documents** — a 4-page spec for a threshold
   change wastes reviewer time; a half-page spec for a new process misses critical scope.

---

## Level Definitions

### L1 — Lite Functional Spec

**Use when**: The enhancement is small with narrow business impact — a single rule change,
a threshold adjustment, a message change, or a minor validation addition.

**Typical enhancements**:
- Change a validation threshold (e.g., credit limit from $5,000 to $10,000)
- Modify a user-facing message or label
- Add a simple business rule within an existing process
- Change an exception outcome for a single scenario

**Section count**: ~10 sections (REQUIRED only, minimal CONDITIONAL)
**Key principle**: Document the business change clearly and concisely. A well-formed L1
is half a page to one page. It is a functional change note, not a full requirements document.

**L1 brevity rules**:
- Functional Overview: 2-3 sentences
- Current Behavior: 1-3 sentences covering only the behavior being changed
- Future Behavior: one paragraph describing the change
- Functional Requirements: only new/modified FRs
- Business Rules: only new/modified BRs (plus EXISTING only if needed for clarity)
- Exception Scenarios: only if the change affects exception handling
- Acceptance Criteria: 1-3 criteria covering the new/modified items

### L2 — Standard Functional Spec

**Use when**: The enhancement adds or modifies multiple business rules, changes observable
process behavior, or introduces new inputs/outputs affecting multiple touchpoints.

**Typical enhancements**:
- Add a new validation process visible to users
- Modify how a business process behaves under certain conditions
- Add new inputs or outputs to an existing process
- Change exception handling visible to users or operators
- Add a new business rule that affects multiple process steps

**Section count**: ~14-16 sections
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

**Section count**: All 18 sections
**Key principle**: Complete functional specification for business review, scope agreement,
and downstream Technical Design generation. All sections are required.

---

## Decision Examples

| Requirement | Level | Reasoning |
|-------------|-------|-----------|
| "Change the credit limit from $5,000 to $10,000" | L1 | Single rule change, single threshold, narrow business impact |
| "Change the 'customer not found' error message wording" | L1 | Cosmetic message change, no business behavior change |
| "Add a check: reject orders for inactive customers" | L2 | New business rule, new exception scenario, changed process behavior visible to users |
| "Add the ability to override credit limit with supervisor approval" | L2 | New input (supervisor approval), new role (supervisor), modified rules, new acceptance criteria |
| "Add a notification to the warehouse when a rush order is confirmed" | L2 | New output, new downstream dependency, new business rule for rush classification |
| "Build a new order validation process that checks credit, inventory, and shipping eligibility" | L3 | New function, multiple rules, multiple actors, full process definition needed |
| "Redesign the returns process to support online and in-store returns with different approval workflows" | L3 | Major rework, multiple process flows, multiple roles, broad business impact |
| "Create a new end-of-day reconciliation process for invoice payments received via multiple channels" | L3 | New function, multiple inputs, multiple business rules, multiple downstream dependencies |

---

## Change Tagging Rules

When a Functional Spec documents an enhancement (any level), use these tags to distinguish
new content from existing context:

- **(NEW)** — This element is introduced by this change. Did not exist before.
- **(MODIFIED)** — This element existed but is being changed. State both old and new.
- **(EXISTING -- context only)** — This element is unchanged. Included only to help the
  reader understand a new or modified element.

### Where tags apply

| Section | Tags Applied To |
|---------|----------------|
| Functional Requirements | Each FR-nn entry |
| Business Rules | Each BR-xx entry |
| Current / Future Behavior | Narrative uses tags to highlight what changes |
| Functional Inputs / Outputs | Each input/output row |
| Exception Scenarios | Each E-nn entry |

### Signal over noise

Include `(EXISTING -- context only)` entries only when they are necessary to understand
a new or modified element. A document cluttered with EXISTING rows obscures the actual
change. Ask: "Does the reader need this existing item to understand the change?" If no,
omit it.

### MODIFIED rule presentation

When a BR or FR is tagged (MODIFIED), state both the old and new version:
- BR-04 (MODIFIED): Orders exceeding the customer credit limit must be rejected.
  Threshold changed from $5,000 to $10,000.

This gives the reviewer a clear before/after comparison without needing to reference
another document.

---

## Completeness Strategy

The tiering system prevents over-specification, but within each level, the REQUIRED /
CONDITIONAL / OPTIONAL classification prevents under-specification:

- **REQUIRED**: Must appear. If genuinely empty, write `N/A`. Omitting a REQUIRED
  section is an error.
- **CONDITIONAL**: Must appear IF the enhancement touches this area. If irrelevant to
  the change, omit the section entirely — do not write `N/A` (that implies it was
  considered and found empty; omission means it is out of scope).
- **OPTIONAL**: Include if the user provides relevant information or if it would help
  the business reviewer. Do not force it.

### Section counts by level

| Classification | L1 | L2 | L3 |
|---------------|----|----|-----|
| REQUIRED | 10 | 14 | 16 |
| CONDITIONAL | 3 | 2 | 0 |
| OPTIONAL | 2 | 0 | 0 |
| Not applicable | 3 | 2 | 2 |

A well-formed L1 may have only 10-12 sections, but every one is fully specified.
A poorly-formed L3 with 18 sections full of TBDs is worse than a tight L1 with 10
complete sections.

**The goal is not maximum sections. The goal is maximum signal per section.**

### Level escalation

If during drafting you discover that the change is more complex than initially assessed:
- An L1 that needs Current/Future Behavior comparison, multiple new rules, and dependency
  analysis should be escalated to L2.
- An L2 that introduces new actors, new process flows, or broad business impact should
  be escalated to L3.

State the escalation reason in the Functional Overview: "Initially assessed as L2;
escalated to L3 due to multiple actor roles and new process branches."

### Level confirmation

If the user requests a specific level, use that level even if the complexity suggests
otherwise. Note any concern in Open Questions: "User requested L1; complexity may warrant
L2 for full coverage of new business rules."
