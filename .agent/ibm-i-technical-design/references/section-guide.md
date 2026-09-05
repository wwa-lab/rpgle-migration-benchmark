# Section Guide — IBM i Technical Design (V1.0)

Detailed guidance on what belongs in each section of the Technical Design.
See `references/tier-guide.md` for Design Level selection rules.

The guiding principle for every section: **design-level abstraction**. If the content
reads like implementation instructions a developer would follow line by line, it has
fallen below the design layer. Every section should pass the architect test: "Does a
solution architect need this detail to approve the design?"

---

## Document Header

- **Design ID**: Format `TD-yyyymmdd-nn`. Example: `TD-20260402-01`.
- **Design Level**: `L1 Lite`, `L2 Standard`, or `L3 Full`. Determined in Step 1.
- **Version**: Starts at `1.0`. Increment on revision.
- **Status**: `Draft`, `Review`, or `Approved`.
- **Change Type**: `New Program` or `Enhancement to Existing`.
- **Solution Type**: `RPGLE`, `CLLE`, or `Mixed`.
- **Related Program(s)**: Known program names or `TBD`.
- **Description**: 1-2 sentences summarizing the design purpose.

**Does NOT contain**: Business rules, processing detail, or any content that belongs
in the body of the document.

**Common mistakes**:
- Omitting Design Level (required for section inclusion rules)
- Using Program Spec format (Spec ID / Spec Level) instead of Design ID / Design Level
- Writing a paragraph instead of structured metadata

---

## Amendment History

| Version | Date | Author | Change Description |

First-time designs: one row with Version 1.0, date TBD, "Initial draft".

**Does NOT contain**: Detailed change descriptions that belong in the Design Overview
narrative.

---

## Design Overview

2-4 sentence executive summary. A reader should understand the purpose and scope of
the design from this section alone.

For enhancements: state what exists today, what changes, and why.

**Contains**: The what, why, and for whom at the highest level.

**Does NOT contain**: Technical approach detail (that belongs in Solution Overview),
step-by-step logic, or business rule enumeration.

**Common mistakes**:
- Making it too long (more than 4 sentences)
- Restating the requirement verbatim instead of summarizing the design intent
- Including solution structure detail that belongs in Solution Overview

---

## Business Context / Trigger

- **Business Event**: What triggers this process (user action, scheduler, upstream program, command)
- **Business Purpose**: Why this process exists in business terms
- **Current State**: How it works today, or "N/A - new program"
- **Desired State**: What the design achieves

**Contains**: Business-facing context that frames the design decision.

**Does NOT contain**: Technical trigger mechanics (job queue setup, SBMJOB parameters).
Those belong in Operational / Processing Considerations.

**Common mistakes**:
- Confusing technical triggers (CALL PGM) with business triggers (customer places order)
- Writing the Design Objective here instead of the business context

**When to include**: OPTIONAL at L1, REQUIRED at L2 and L3.

---

## Design Objective

1-3 sentences stating the specific technical objective. This is not a restatement of
the business requirement -- it is the technical goal that satisfies the requirement.

**Contains**: What the design must accomplish technically.

**Does NOT contain**: Business justification (that is Business Context), solution
approach (that is Solution Overview), or scope boundaries (that is Scope and Boundary).

**Common mistakes**:
- Copying the business requirement verbatim
- Stating the solution approach instead of the objective
- Writing multiple paragraphs instead of 1-3 focused sentences

---

## Scope and Boundary

### In Scope
Bulleted list of what this design covers.

### Out of Scope
Bulleted list of what this design explicitly does NOT cover.

### Boundary Conditions
Constraints that define the edges: upstream dependencies, downstream consumers, system
boundaries. What does this design assume is already in place?

**Contains**: Clear separation of what is inside and outside the design boundary.

**Does NOT contain**: Detailed dependency analysis (that is Impact Analysis) or
module-level responsibility (that is Module / Responsibility Allocation).

**Common mistakes**:
- Leaving Out of Scope empty (every design has boundaries)
- Confusing boundary conditions with assumptions (boundary conditions are structural
  facts; assumptions are beliefs that may be wrong)
- Including implementation constraints that belong in Assumptions / Constraints

---

## Solution Overview

3-6 sentence narrative describing the overall technical approach. What is the shape
of the solution? What are the major moving parts? Why this structure (single program
vs multi-program, batch vs online, file-driven vs parameter-driven)?

**Contains**: The architectural shape and design rationale at narrative level.

**Does NOT contain**: Module-by-module decomposition (that is Module / Responsibility
Allocation), processing stages (that is High-Level Processing Flow), or data movement
(that is Data / Object Interaction Design).

**Common mistakes**:
- Decomposing the solution into modules here instead of providing a narrative overview
- Including processing flow detail
- Writing more than 6 sentences

**When to include**: OPTIONAL at L1, REQUIRED at L2 and L3.

---

## Module / Responsibility Allocation

The core design decomposition. For each program or service program, define its
primary responsibility role using the standard taxonomy:

| Role | What It Means | Typical IBM i Object |
|------|---------------|---------------------|
| **Orchestration** | Controls execution sequence, calls other modules | CLLE driver, control program |
| **Validation** | Enforces business rules, checks preconditions | RPGLE validation routine |
| **Data Access** | Reads from files, performs lookups | RPGLE read routine, SRVPGM |
| **Update** | Writes, updates, or deletes file records | RPGLE update routine |
| **External Integration** | Calls external programs, sends/receives via data queues | CLLE call wrapper, DTAQ handler |
| **Context / Dependency** | Provides configuration or shared state | DTAARA, shared SRVPGM |

### Module Allocation Table

| Object | Type | Status | Primary Role | Responsibility | Depends On | Depended On By |

**Contains**: Module identity, responsibility ownership, and dependency relationships.

**Does NOT contain**: Internal module logic, subroutine decomposition, field-level
processing, or step-by-step flow. Those belong in the downstream Program Spec.

**Common mistakes**:
- Describing HOW a module works instead of WHAT it owns
- Including files and data areas as module rows (they are objects, not modules -- they
  appear in Depends On / Depended On By columns and in Data / Object Interaction Design)
- Listing every existing object in the system instead of only those with a direct
  dependency on changed modules
- Assigning no role or an undefined role
- For enhancements: forgetting to tag entries as (NEW), (MODIFIED), or
  (EXISTING -- context only)

**When to include**: CONDITIONAL at L1 (include if the change introduces or modifies
a module boundary), REQUIRED at L2 and L3.

---

## High-Level Processing Flow

Numbered stages. Each stage is a logical phase of processing -- not an implementation
step. A stage may span multiple programs or encompass several internal operations.

Format:
```
Stage 1: <phase name>
  <What happens. Which modules are active. What is produced or consumed.>
  Business rules: BR-xx, BR-yy

Stage 2: <phase name>
  <What happens.>
```

**Contains**: Processing phases, active modules per phase, inputs/outputs per phase,
governing business rules per phase.

**Does NOT contain**: Implementation steps (Step 1, Step 2), conditional logic
(IF x THEN y), field-level actions, or code-level sequencing. Those belong in the
Program Spec's Main Logic section.

**Common mistakes**:
- Writing `Step 1:` instead of `Stage 1:` -- stages are design phases, steps are
  implementation instructions
- Including IF/THEN conditional logic within stages
- Referencing individual fields instead of data categories
- Writing too many stages for L1 (1-2 stages is appropriate)
- Writing too few stages for L3 (cover all major processing phases)

**Typical stage counts**: L1: 1-2 stages. L2: 3-6 stages. L3: as many as needed.

---

## Data / Object Interaction Design

Describes how data moves between objects in the solution. This section shows the
collaboration pattern -- which objects work together and what data flows between them.

### Object Interaction Map

| Source | Target | Interaction | Data Exchanged (summary) | Direction |

### File Access Summary

| File Name | Accessed By | Access Type (I/O/U) | Key Field(s) | Purpose |

### Reference Naming Map

Maps the naming layers for each file object — file name, record format name, rename alias,
and key list name — so the downstream Program Spec and code generator know exactly which
name to use at each layer.

CONDITIONAL at L2/L3. Include for fixed-format RPGLE when naming distinctions (file name vs
record format vs alias vs key list) affect downstream implementation. OMIT when all files use
default format names with no renames or explicit key lists.

| File Name | Record Format | Rename Alias | Key List Name | Access Style | Notes |

**Contains**: One row per file where the naming is non-trivial (renamed formats, explicit
key lists, intentional scan access).

**Does NOT contain**: Field-level key definitions or KFLD compositions — those belong in the
Program Spec's Compile-Oriented Constraints.

### Data Queue / Data Area Usage (if applicable)

| Object | Type | Used By | Direction | Purpose |

**Contains**: Object-to-object data movement summarized by category (e.g., "customer
header data", "order totals", "validation result").

**Does NOT contain**: Individual field names, field types, field lengths, or field-level
data contracts. Those belong in the Program Spec's Data Contract section.

**Distinct from Impact Analysis**: Interaction Design describes HOW objects collaborate.
Impact Analysis describes WHAT changes and what is affected.

**Common mistakes**:
- Listing individual fields in the Data Exchanged column instead of data categories
- Duplicating the File Access Summary from the Module Allocation table
- Including unchanged interactions without tagging them (EXISTING -- context only)
- Confusing this section with the Program Spec's File Usage section (which includes
  field-level detail)

**When to include**: CONDITIONAL at L1 (include if the change alters data flow),
REQUIRED at L2 and L3.

---

## Interface / Dependency Design

### Program Interface Summary

| Program | Key Inputs (summary) | Key Outputs (summary) | Return Semantics |

### External Dependencies

| Dependency | Type | Direction | Impact if Unavailable |

### Call Chain

Text description or simple diagram of the call sequence.

**Contains**: Design-level interface summaries (what goes in, what comes out, success/
failure model), external dependency catalog, and call chain.

**Does NOT contain**: Full parameter tables with type, length, valid values, or return
code catalogs. Those belong in the Program Spec's Interface Contract.

**Common mistakes**:
- Writing a full parameter table (Name, Type, Length, Valid Values) instead of a
  design-level summary
- Including return code catalogs with every possible code and caller action
- Omitting the Call Chain when multiple programs are involved
- For enhancements: not identifying which interfaces are (NEW) vs (MODIFIED)

**When to include**: CONDITIONAL at L1 (include if the change alters interfaces),
REQUIRED at L2 and L3.

---

## Business Rule Allocation

Assigns each BR-xx to the module or processing stage responsible for enforcing it.
This is design-level ownership -- not implementation-level traceability.

| BR | Rule Description | Allocated To (Module) | Enforced At (Stage) | Notes |

**Contains**: BR-to-module allocation, BR-to-stage mapping, and status tags for
enhancement designs.

**Does NOT contain**: BR-to-implementation-step traceability (that belongs in the
Program Spec's Traceability Matrix), implementation conditions (IF x THEN y), or
field-level rule decomposition.

**Common mistakes**:
- Writing implementation conditions instead of business constraints
- Mapping BRs to implementation steps instead of modules/stages
- Omitting a BR (every BR-xx must appear in this table)
- For enhancements: forgetting to tag rules as (NEW), (MODIFIED), or (EXISTING)

---

## Error Handling Strategy

Design-level error handling approach -- strategy and responsibility, not exhaustive
scenarios.

### Error Categories

| Category | Strategy | Responsible Module | Escalation |

Four mandatory categories at ALL levels:
- Validation Errors
- Data Errors
- Processing Failures
- System Errors

### Recovery Approach

Commitment control strategy, rollback approach, retry logic, or compensation design.
Write N/A if not applicable.

### Logging and Auditability

What is logged, where, and why -- design-level only.

**Contains**: Error handling strategy by category, module responsibility for each
category, escalation paths, and recovery approach.

**Does NOT contain**: Specific return codes, error message text, or per-scenario error
tables with exact return values. Those belong in the Program Spec's Error Handling
section.

**Common mistakes**:
- Writing a full error scenario table with return codes (that is Program Spec content)
- Defining specific error message text
- Omitting one of the four mandatory categories
- Omitting the Recovery Approach subsection (write N/A if not applicable)

---

## Operational / Processing Considerations

- **Batch vs Online**: With rationale
- **Scheduling**: When and how the process runs
- **Estimated Volume**: Expected record counts or transaction volume
- **Performance Sensitivity**: Known constraints or SLA requirements
- **Locking / Contention**: Files or objects that may contend
- **Commitment Control**: Required / not required with rationale
- **Job Queue / Subsystem**: Target execution environment

**Contains**: Operational context that affects the design: execution mode, scheduling,
volume, performance, and concurrency.

**Does NOT contain**: Implementation-level performance tuning (index recommendations,
OPNQRYF optimization), specific SBMJOB parameters, or job description details.

**Common mistakes**:
- Omitting commitment control rationale for update-heavy designs
- Not mentioning locking when multiple programs access the same files
- Including this section at L1 when the change has no operational impact

**When to include**: OPTIONAL at L1, CONDITIONAL at L2 (include if the enhancement
affects operational behavior), REQUIRED at L3.

---

## Impact Analysis

Describes WHAT changes and WHAT is affected. Distinct from Data / Object Interaction
Design, which describes HOW objects collaborate.

### Objects Affected

| Object | Type | Impact | Description |

List only objects with actual impact (New / Modified / Retired).

### Downstream Effects

What other programs, processes, job flows, reports, or interfaces are affected?
What might break? What needs regression testing?

### Test Impact

What existing test cases or test data are affected? What new test scenarios does this
design introduce?

### Migration / Deployment Notes (L2/L3)

Object dependencies, compile order, data migration, cutover steps. Write N/A if
straightforward.

**Contains**: Change impact on objects, downstream effects, test impact, and deployment
considerations.

**Does NOT contain**: Interaction patterns (that is Data / Object Interaction Design)
or module responsibilities (that is Module / Responsibility Allocation).

**REQUIRED at all levels, including L1.** In IBM i environments, even a single-field
change can affect downstream programs, job flows, or dependent objects. Skipping impact
analysis for "small" changes is a common source of production incidents.

**Common mistakes**:
- Omitting Impact Analysis at L1 ("it's just a small change")
- Listing unchanged objects in the Objects Affected table (only New / Modified / Retired)
- Not identifying downstream programs that may break
- Omitting test impact assessment
- For L1: over-elaborating (a brief table and one-line downstream note is sufficient)

---

## Assumptions / Constraints

### Assumptions
Bulleted list. Each assumption is something that, if false, would change the design.

### Constraints
Bulleted list. Technical limitations, business rules that cannot be changed, system
boundaries, timeline constraints.

**Contains**: Design assumptions and constraints that bound the solution.

**Does NOT contain**: Open questions (those belong in Open Questions / TBD) or
scope boundaries (those belong in Scope and Boundary).

**Common mistakes**:
- Confusing assumptions with scope statements
- Listing constraints that are actually open questions requiring resolution
- Including obvious facts that would not change the design if false

---

## Open Questions / TBD

| # | Section | Question | Source | Status |

Every TBD in the document must have a corresponding entry here. Every (Inferred) design
element should appear if confirmation is needed.

**Contains**: Unresolved questions, TBD items with their source section, and inferred
elements requiring confirmation.

**Does NOT contain**: Resolved items (remove or mark as Resolved with the answer).

**Common mistakes**:
- Having TBDs in the document body with no corresponding row here
- Including questions that are already answered elsewhere in the design
- Not specifying the source (Design / Requirement / Dependency)

---

## Design Summary

- **Design Level**: L1 / L2 / L3
- **Change Type**: New Program / Enhancement to Existing
- **Solution Type**: RPGLE / CLLE / Mixed
- **Total Business Rules (BR)**: count (new, modified)
- **Total Modules**: count (new, modified)
- **Total Processing Stages**: count
- **Total Files Accessed**: count
- **Total External Dependencies**: count
- **Total Open Questions**: count
- **Design Review Ready**: Yes / No (if No, list blockers)

**Contains**: Accurate counts derived from the document body. These counts serve as a
quick validation -- if the counts do not match the document content, something is wrong.

**Does NOT contain**: Narrative summary (that is Design Overview) or detailed findings.

**Common mistakes**:
- Counts that do not match the actual document content
- Marking "Design Review Ready: Yes" when open questions remain unresolved
- Omitting the new/modified breakdown for enhancement designs
