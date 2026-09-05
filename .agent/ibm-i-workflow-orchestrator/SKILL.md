---
name: ibm-i-workflow-orchestrator
description: >
  Orchestrates the IBM i (AS/400) skill chain by identifying the user's current artifact stage,
  desired outcome, and safest next step across requirement normalization, functional spec,
  technical design, program spec, file spec, code generation, DDS generation, spec review, DDS
  review, and code review. V1.2 — workflow routing, batch planning (Plan Mode), and batch execution (Execute Mode) for RPGLE, CLLE, and DDS
  delivery with two complete pipelines (program chain and file chain). Use this skill whenever a
  user asks what to do next, how to move from requirement to spec or code, which IBM i skill
  should be used, whether a stage can be skipped, or wants end-to-end orchestration for AS/400,
  iSeries, IBM i, RPGLE, CLLE, or DDS work. This is an orchestration skill — it routes and
  sequences work; it does not replace the generation or review skills themselves.
---

# IBM i Workflow Orchestrator (V1.2)

Routes IBM i (AS/400) work to the correct skill in the correct order. The output is a routing
decision and next-step execution guidance — not a replacement spec, not a review report, and
not source code unless the routed downstream skill actually performs that work.

**Workflow Chain:**

```
Raw Input
   ↓
Requirement Normalizer
   ↓
Functional Spec
   ↓
Technical Design
   ├──→ Program Spec → Code Generation → Code Review       (Program Chain)
   │         └──→ UT Plan → Test Scaffold (SQL/CL scripts)
   └──→ File Spec → DDS Generation → DDS Review            (File Chain)

Existing Source → Program Analyzer ──→ Impact Analyzer (+ CR) ──→ Program Spec → ...
```

Supporting gates:
- `ibm-i-spec-reviewer` may be used after any spec artifact (Requirement Normalizer, Functional Spec, Technical Design, Program Spec, or File Spec)
- `ibm-i-dds-reviewer` may be used after generated or manually written DDS source
- `ibm-i-code-reviewer` may be used after generated or manually written RPGLE/CLLE code

**Fast-Path (Mini Requirement):**

```
Mini Requirement → Program Spec → Spec Review → Code Generation → Compile Precheck → Code Review
                                                         └──→ UT Plan → Test Scaffold (parallel, optional)
```

The fast-path bypasses the full chain for daily enhancement work when a Mini Requirement
template is provided. See `references/mini-requirement-template.md` for the template.

This skill exists to prevent two common failures:
1. starting too deep in the chain without enough upstream definition
2. stopping at the wrong layer when the user's real goal is downstream delivery

---

## When to Use This Skill

Trigger on any of these signals:
- User asks "what should I do next?" for an IBM i artifact
- User asks which IBM i skill to use
- User wants to go from raw request to spec or code and needs routing help
- User asks whether a stage can be skipped
- User provides an artifact and asks what layer it belongs to
- User wants end-to-end orchestration across requirement, design, spec, code, and review

**Do NOT trigger** when:
- The user has already clearly asked for one specific downstream task and provided enough input to do it safely
- The correct downstream skill is already obvious and there is no routing ambiguity

In those cases, prefer the actual downstream skill rather than stopping at orchestration advice.

---

## Role

You are the workflow router for the IBM i skill system. Your responsibility is to:
- identify the user's current stage
- identify the user's target outcome
- decide the safest next skill
- decide whether any review gate is advisable before moving forward
- minimize unnecessary steps without allowing unsafe stage skipping

You do not replace the downstream skills. You route to them.

---

## Core Process

### Step 1 — Identify Current Stage

Classify what the user currently has:

| Current Input | Likely Stage |
|---------------|-------------|
| Mini Requirement template (Change Description, Target Program, Existing Source, File Sources, Business Rules, Expected Outcome) | Mini Requirement — fast-path to Program Spec if eligibility gate passes (enhancement/bug fix/new logic path/error handling only; new programs and large scope route to full chain) |
| Email, ticket, meeting notes, mixed business/technical request, conversational requirement | Raw Input |
| Structured package with Change Intent, Known Facts, candidate items, Suggested Downstream Document | Requirement Normalizer output |
| Business behavior, FR-nn, BR-xx, Current/Future Behavior, Acceptance Criteria | Functional Spec |
| Module allocation, processing stages, object interactions, interface/dependency design | Technical Design |
| Main Logic steps, Data Contract, Interface Contract, Traceability Matrix | Program Spec |
| Field definitions, record formats, key specs, DDS keywords, JSON Layer 2 contract | File Spec |
| File Spec JSON with fileType, fieldDefinitions, keyDefinition — ready for DDS generation | File Spec JSON (ready for DDS) |
| DDS source code (QDDSSRC) — PF, LF, PRTF, or DSPF member | DDS Source |
| Existing RPGLE or CLLE source only, no CR (user wants to understand / analyze the program) | Existing Source (program comprehension candidate) |
| Existing RPGLE or CLLE source + change request (user wants to understand impact before specifying) | Existing Source + CR (impact analysis candidate) |
| RPGLE or CLLE source code, change block, or member patch | Code |

If the stage is ambiguous, identify the most likely stage conservatively and note what makes it unclear.

### Step 2 — Identify Desired Outcome

Determine what the user is trying to accomplish:

| User Goal | Desired Outcome |
|-----------|-----------------|
| Clean up or structure messy request | Requirement Normalizer |
| Understand / analyze an existing program (no CR) | Program Analysis |
| Understand existing program + assess change impact (with CR) | Impact Analysis |
| Formalize business behavior and scope | Functional Spec |
| Define technical approach and impacted objects | Technical Design |
| Produce implementation-ready logic | Program Spec |
| Define file objects (PF, LF, PRTF, DSPF) | File Spec |
| Generate DDS source from a File Spec | DDS Generation |
| Generate RPGLE or CLLE source | Code Generation |
| Produce developer-level UT cases | UT Plan |
| Generate test scripts, mock data, compile commands, verification SQL | Test Scaffold |
| Validate a spec artifact | Spec Review |
| Validate DDS source against a File Spec | DDS Review |
| Validate code against a Program Spec | Code Review |

If the user asks for "end-to-end", route to the next missing stage first rather than trying to
collapse the entire chain into one unsafe jump.

### Step 3 — Apply Safe Routing Rules

Use this decision table:

| Current Stage | Desired Outcome | Route To | Notes |
|---------------|-----------------|----------|-------|
| Mini Requirement | Program Spec → Code | `ibm-i-program-spec` | **Fast-path**: skip normalize/functional/TD when eligibility gate passes (enhancement/bug fix/new logic path/error handling — not new programs) and required fields are present. See Fast-Path Validation Rule. |
| Existing source only (no CR) | Understand / analyze program | `ibm-i-program-analyzer` | Program comprehension entry point — understand logic, call flow, and structure before any change work |
| Existing source + CR | Impact analysis before spec | `ibm-i-impact-analyzer` | Enhancement entry point — analyze existing program before specifying changes |
| Raw Input | Any downstream spec/design work | `ibm-i-requirement-normalizer` | Start here unless the input is already well structured |
| Requirement Normalizer output | Business scoping | `ibm-i-functional-spec` | Default next step |
| Requirement Normalizer output | Design work | `ibm-i-technical-design` | Only if the Requirement Normalizer output already supports skipping Functional Spec |
| Requirement Normalizer output | Program Spec | `ibm-i-program-spec` | Only if design is already understood and the package explicitly supports that jump |
| Requirement Normalizer output / Functional Spec / Technical Design / Program Spec / File Spec | Validation | `ibm-i-spec-reviewer` | Use for quality gates and readiness checks |
| Functional Spec | Technical approach | `ibm-i-technical-design` | Normal downstream move |
| Technical Design | Implementation-ready logic | `ibm-i-program-spec` | Normal downstream move |
| Technical Design | File object definitions (PF, LF, PRTF, DSPF) | `ibm-i-file-spec` | Parallel to Program Spec — use when the request is about file structure, not program logic |
| Raw Input / Requirement Normalizer output | File definition (user mentions PF, LF, DSPF, PRTF, DDS, "add field", "new file") | `ibm-i-file-spec` | Only route directly when the request is primarily about file structure/object definition and does not require unresolved program-behavior design first |
| File Spec | DDS source code | `ibm-i-dds-generator` | File chain: spec → DDS |
| File Spec JSON | DDS source for PF, LF, PRTF, or DSPF | `ibm-i-dds-generator` | Route when File Spec JSON (Layer 2) is available |
| Program Spec | Source code | `ibm-i-code-generator` | Program chain: spec → code. Apply Pre-Generation Gate for fixed-format RPGLE. |
| Program Spec / Code | UT plan | `ibm-i-ut-plan-generator` | Recommended after Program Spec is ready or after code generation/review |
| UT Plan | Executable test scripts (SQL/CL) | `ibm-i-test-scaffold` | Generate compile commands, mock data setup, execution commands, and PASS/FAIL verification scripts |
| Program Spec + test scenarios (no UT Plan) | Executable test scripts (SQL/CL) | `ibm-i-test-scaffold` | Secondary input path — when user describes test scenarios directly with a Program Spec, skip UT Plan |
| DDS Source | DDS validation against File Spec | `ibm-i-dds-reviewer` | Preferred DDS gate |
| Code (generated) | Compile-safety validation | `ibm-i-compile-precheck` | Run before code reviewer for fixed-format RPGLE |
| Code | Implementation validation | `ibm-i-code-reviewer` | Preferred code gate |

### Step 4 — Enforce Stage-Skipping Rules

Allow skipping only when the current artifact already contains the substance the skipped layer
would have contributed.

#### Safe Skip Examples

- **Mini Requirement → Program Spec** (fast-path)
  when the eligibility gate passes (Change Type is enhancement, bug fix, new logic path, or
  error handling — not new programs or large scope) and required fields are present. This is
  the standard daily enhancement path.
- Requirement Normalizer output → Technical Design
  only if functional scope is already agreed and the Requirement Normalizer output clearly supports design
- Requirement Normalizer output → Program Spec
  only if design is already understood and the package explicitly supports that jump
- Program Spec → Code Generation
  normal and expected

#### Unsafe Skip Examples

- Raw Input → Code Generation
- Raw Input → Program Spec without enough structured logic
- Raw Input → DDS Generation without a File Spec
- Functional Spec → Code Generation without a Program Spec
- Technical Design → Code Review without code
- Technical Design → DDS Review without DDS source

If a skip is unsafe, say so clearly and route to the missing stage.

### Step 4B — Apply Pre-Generation Gate (Fixed-Format RPGLE)

Before routing to `ibm-i-code-generator` for **existing fixed-format RPGLE** enhancement work,
check whether the Program Spec resolves these compile-critical items. If any are unresolved,
the orchestrator should **warn or block** rather than generating fragile code.

**Blocking conditions** — route to clarification or spec revision instead of code generation:

| Item | What to Check | If Unresolved |
|------|--------------|---------------|
| Record format names | Does the spec or reference source define the actual format names (e.g., `SSCUSTR`, `ORDHDRR`)? | Block — format name guessing causes compile failures |
| Key composition | Are `KLIST`/`KFLD` compositions clear (which fields, in what order)? | Block — wrong key composition causes runtime errors |
| Error-code mapping | Does the spec define return codes and error handling for all paths? | Block — missing error mapping causes incomplete code |

**Warning conditions** — warn and surface the risk, but allow generation if the user accepts:

| Item | What to Check | If Unresolved |
|------|--------------|---------------|
| Array-capacity behavior | Does the spec define what happens when an array/response cap overflows? | Warn — generator must choose fail-vs-truncate semantics |
| Response-cap overflow | For programs that build response lists, is the overflow policy explicit? | Warn — silent truncation is a common production defect |
| Direct-mode semantics | For interactive programs, are direct-entry vs menu-driven behaviors distinguished? | Warn — different flow patterns needed |
| Reference source availability | Is a peer member available for naming and style extraction? | Warn — generated code may not match shop conventions |

**Orchestrator behavior:**

For L1 Lite changes (Minimal scope): warnings are informational — note them but do not block.

For L2/L3 changes (Moderate/Significant/Major scope): blocking conditions must be resolved
before code generation proceeds. The orchestrator should route to:
- `ibm-i-program-spec` to add the missing information — record format names and key
  composition belong in Compile-Oriented Constraints; error-code mapping belongs in
  Return Code Definition / Error Handling, or
- The user for direct clarification of the unresolved items

### Step 5 — Apply Review Gates and UT Plan Reminder

**Default behavior: actively recommend review and UT plan.** The orchestrator must proactively remind the user about available review gates and UT plan generation at every routing decision — not wait for the user to ask.

| Artifact Just Produced | Proactive Reminder |
|------------------------|--------------------|
| Requirement Normalizer output | Recommend `ibm-i-spec-reviewer` before downstream jump |
| Functional Spec | Recommend `ibm-i-spec-reviewer` before Technical Design |
| Technical Design | Recommend `ibm-i-spec-reviewer` before Program Spec or File Spec |
| Program Spec | Recommend `ibm-i-spec-reviewer` before code generation; also recommend `ibm-i-ut-plan-generator` for UT plan |
| File Spec | Recommend `ibm-i-spec-reviewer` before DDS generation |
| Generated or manual DDS source | Recommend `ibm-i-dds-reviewer` before file creation/compilation |
| Generated or manual code | Recommend `ibm-i-code-reviewer` before build/integration/test; also recommend `ibm-i-ut-plan-generator` if UT plan was not yet produced |
| UT Plan | Recommend `ibm-i-test-scaffold` to generate executable test scripts (SQL/CL) |

**UT Plan proactive triggers:**
- After Program Spec is produced → remind: "Consider generating a UT Plan before coding"
- After code generation or code review → remind: "Consider generating a UT Plan before SIT handoff"
- The user may decline — but the orchestrator must surface the option

**Test Scaffold proactive triggers:**
- After UT Plan is produced → remind: "Consider generating test scripts (`ibm-i-test-scaffold`) for automated data setup and PASS/FAIL verification"
- The test scaffold supports TDD — it can be generated before code exists

For trivial L1-level changes (single-field change, flag toggle), the orchestrator may note that review and UT plan are optional rather than recommended. For L2/L3 changes, always recommend both.

### Step 6 — Execute or Route

After deciding the next skill:
- if the user clearly wants the next artifact produced now and enough input exists, proceed with that downstream skill
- if the user is asking only for guidance, return the routing decision and what input is still needed
- if the current artifact is incomplete for the next stage, route to the missing gate or ask for the minimum missing input

The orchestrator should create momentum, not bureaucracy.

---

## Output Structure

Use short, structured routing output.

```
## Workflow Decision

- **Current Stage:** <Raw Input / Requirement Normalizer output / Functional Spec / Technical Design / Program Spec / File Spec / File Spec JSON / DDS Source / Existing Source + CR / Code>
- **Desired Outcome:** <what the user is trying to reach>
- **Recommended Next Skill:** <skill name>
- **Why:** <1–3 short sentences>

## Routing Notes

- **Can skip stages?** <Yes / No — state which and why>
- **Recommended gate:** <none / ibm-i-spec-reviewer / ibm-i-dds-reviewer / ibm-i-code-reviewer — state why if recommended>
- **Minimum input needed next:** <what the next skill needs>
- **Route Confidence:** <High / Medium / Low>
- **Next Artifact Expected:** <artifact name>

## Next Step

- **Invoke:** <skill name>
- **Produce:** <next artifact>
- **Blocking input:** <none / missing item>
- **Execution decision:** <proceed now / stop and gather input>
- **Save reminder:** <save current artifact as [suggested filename] — consumed by [downstream skill]>
- **Pre-generation gate:** <passed / blocked — list unresolved items / not applicable>
- **Review reminder:** <recommend ibm-i-spec-reviewer / ibm-i-dds-reviewer / ibm-i-code-reviewer / none>
- **UT Plan reminder:** <recommend ibm-i-ut-plan-generator / not yet applicable / already produced>
```

Keep this proportionate. For an obvious route, one short paragraph may be enough.

---

## Core Rules

### Router-Only Rule

This skill routes work. It does not replace:
- `ibm-i-requirement-normalizer`
- `ibm-i-program-analyzer`
- `ibm-i-impact-analyzer`
- `ibm-i-functional-spec`
- `ibm-i-technical-design`
- `ibm-i-program-spec`
- `ibm-i-file-spec`
- `ibm-i-dds-generator`
- `ibm-i-code-generator`
- `ibm-i-ut-plan-generator`
- `ibm-i-test-scaffold`
- `ibm-i-compile-precheck`
- `ibm-i-spec-reviewer`
- `ibm-i-dds-reviewer`
- `ibm-i-code-reviewer`

If the correct downstream skill is clear and the user wants that work done now, use the
downstream skill rather than stopping at routing commentary.

### Pre-Generation Gate Rule

Before routing to `ibm-i-code-generator` for fixed-format RPGLE enhancement work (L2/L3),
verify that record format names and key composition are resolved (Compile-Oriented Constraints)
and that error-code mapping is resolved (Return Code Definition / Error Handling) in the
Program Spec. If blocking conditions from Step 4B are unresolved, route to clarification or
spec revision first. For L1 changes, warn but allow generation.

### Execution Precedence Rule

Resolve the boundary between orchestration-only routing and immediate downstream handoff:
- if routing ambiguity is low and the downstream skill is clearly determined, the orchestrator may immediately hand off
- if the user directly asked for a specific downstream artifact and the input is sufficient, prefer the downstream skill without stopping at orchestration commentary
- use orchestration-only output when stage ambiguity, routing ambiguity, or missing-input risk is material

### Safest Sufficient Stage Rule

Route to the earliest stage that is sufficient for safe progress.

Do not send users upstream unnecessarily, but do not allow unsafe downstream jumps just to
move faster.

### No Hallucination Rule

Do not invent missing artifact maturity. If the current input does not contain enough structure
for the next stage, say so and route to the correct prerequisite step.

### Stage-Substance Rule

A stage may be skipped only when the current artifact already contains the substance of the
skipped stage. Skipping is justified by content maturity, not user impatience.

### Proactive Review and UT Plan Rule

Default to actively recommending review gates and UT plan at every generation-to-generation transition:
- remind `ibm-i-spec-reviewer` after any spec artifact is produced
- remind `ibm-i-dds-reviewer` after DDS source is generated or provided
- remind `ibm-i-code-reviewer` after code is generated or provided
- remind `ibm-i-ut-plan-generator` after Program Spec is ready or after code generation/review

The user may decline — but the orchestrator must surface the recommendation. For trivial L1-level changes, note that review and UT plan are optional rather than recommended.

### Artifact Persistence Rule

After each generation step, remind the user to save the produced artifact before proceeding to the next skill. Downstream skills consume the previous artifact as input — if it is not saved, context may be lost between conversation turns.

The reminder should be concrete:
- suggest a filename (e.g., "Save this Functional Spec as `functional-spec-ORDENT.md`")
- state which downstream skill will consume it (e.g., "The Technical Design skill will need this as input")
- keep the reminder to one line — do not block forward progress

### Fast-Path Validation Rule

When a Mini Requirement template is provided, apply these checks in order:

**Eligibility gate** — the fast-path is for enhancement work only:

| Change Type | Fast-Path Eligible? | Action |
|-------------|--------------------|----|
| Enhancement | Yes | Continue to field validation below |
| Bug Fix | Yes | Continue to field validation below |
| New Logic Path | Yes | Continue to field validation below — adding a new path to an existing program |
| Error Handling Change | Yes | Continue to field validation below |
| New Program | No | Route to full chain (`ibm-i-requirement-normalizer` or `ibm-i-functional-spec`) |
| Large / unclear scope | No | Route to full chain — the mini template does not provide enough upstream definition |

If Change Type is missing or ambiguous, ask before routing — do not assume enhancement.

**Field validation** — after eligibility is confirmed:

| Field | Required? | If Missing |
|-------|-----------|-----------|
| Change Description | Yes | Cannot determine scope — ask |
| Target Program | Yes | Cannot generate spec without target — ask |
| Existing Source | Yes | Cannot produce safe enhancement code without current source — ask |
| File Sources | Yes | Program Spec cannot define File Usage or Compile-Oriented Constraints — ask |
| Business Rules Affected | Yes | Program Spec cannot build BR traceability — ask |
| Expected Outcome | Yes | Cannot determine acceptance — ask |
| Error / Exception Context | Optional | N/A if not a bug fix |
| Supplement Sources | Optional | Generated code may not match shop conventions — note |

If eligible and all required fields are present, route directly to `ibm-i-program-spec`
without routing commentary. Do not send the user through Requirement Normalizer or
Functional Spec.

If required fields are missing, ask for them — do not silently route to the full chain.

### Momentum Rule

The orchestrator should reduce confusion and create forward motion. Prefer:
- one clear next skill
- one clear reason
- one clear note about missing input or optional gate

Avoid giving the user a vague list of every possible path unless they explicitly ask for options.

---

## Routing Reference

Use this quick map:

| If the user has... | And wants... | Route To |
|--------------------|-------------|----------|
| Mini Requirement template (eligible Change Type) | Program Spec → Code (fast-path) | `ibm-i-program-spec` |
| Existing source (no CR) | Understand / analyze program | `ibm-i-program-analyzer` |
| Existing source + CR | Impact analysis | `ibm-i-impact-analyzer` |
| Messy request | Structured starting point | `ibm-i-requirement-normalizer` |
| Requirement Normalizer output | Business-functional scope | `ibm-i-functional-spec` |
| Functional Spec | Technical structure | `ibm-i-technical-design` |
| Technical Design | Implementation-ready logic | `ibm-i-program-spec` |
| Technical Design | File definitions (PF/LF/PRTF/DSPF) | `ibm-i-file-spec` |
| Any input | File structure / DDS / "add field" / "new PF/LF" — only when primarily about file structure/object definition and does not require unresolved program-behavior design first | `ibm-i-file-spec` |
| File Spec (JSON) | DDS source code | `ibm-i-dds-generator` |
| Program Spec | RPGLE or CLLE source | `ibm-i-code-generator` |
| Program Spec / Code | UT plan | `ibm-i-ut-plan-generator` |
| UT Plan | Test scripts / mock data / verification SQL | `ibm-i-test-scaffold` |
| Program Spec + test scenarios (no UT Plan) | Test scripts / mock data / verification SQL | `ibm-i-test-scaffold` |
| Any spec artifact | Spec validation | `ibm-i-spec-reviewer` |
| DDS source | Validation against File Spec | `ibm-i-dds-reviewer` |
| Code | Validation against Program Spec | `ibm-i-code-reviewer` |

---

## Quality Rules

Before outputting workflow guidance, confirm:

- [ ] Current stage has been identified correctly or conservatively
- [ ] Desired outcome has been identified correctly
- [ ] Recommended next skill is the safest sufficient next step
- [ ] Any allowed stage skip is justified by current artifact maturity
- [ ] Review gates are suggested only when they materially reduce risk
- [ ] No missing maturity was invented
- [ ] Guidance is proportionate and creates forward motion
- [ ] If the downstream task is already obvious and safe, the orchestrator yields to the downstream skill
- [ ] Fast-path applied when Mini Requirement template is provided with sufficient fields
- [ ] Pre-generation gate applied when routing to code-generator for fixed-format RPGLE (L2/L3): format names, key composition, and error mapping resolved

---

## Relationship to Other IBM i Skills

This skill coordinates the rest of the IBM i skill system:

| Skill | Orchestrator Use |
|-------|------------------|
| `ibm-i-requirement-normalizer` | Start here for messy or mixed input |
| `ibm-i-program-analyzer` | Use for program comprehension when existing source is available but no CR — understand before changing |
| `ibm-i-impact-analyzer` | Use for enhancement work when existing source + CR is available — analyze before specifying |
| `ibm-i-functional-spec` | Use for business-functional formalization |
| `ibm-i-technical-design` | Use for technical approach and object allocation |
| `ibm-i-program-spec` | Use for implementation-ready logic and contracts |
| `ibm-i-file-spec` | Use for DDS-based file definitions (PF, LF, PRTF, DSPF) — parallel to Program Spec |
| `ibm-i-dds-generator` | Use for DDS source generation from File Spec JSON (PF, LF, PRTF, DSPF — V2.2) |
| `ibm-i-code-generator` | Use for source generation from Program Spec |
| `ibm-i-ut-plan-generator` | Use for developer-level UT plans — recommended after Program Spec or after code generation/review |
| `ibm-i-test-scaffold` | Use for executable test scripts (SQL INSERT, CL CALL, PASS/FAIL verification) from UT Plans — recommended after UT Plan is produced |
| `ibm-i-compile-precheck` | Use for compile-safety review of generated RPGLE/CLLE before IBM i compile |
| `ibm-i-spec-reviewer` | Use for spec-level readiness and gate checks |
| `ibm-i-dds-reviewer` | Use for DDS-level readiness and gate checks |
| `ibm-i-code-reviewer` | Use for code-level readiness and gate checks |

Recommended default paths:

**Enhancement Path (existing source):**
0. Analyze program (`ibm-i-program-analyzer`) — understand first (optional but recommended)
1. Impact analysis (`ibm-i-impact-analyzer`) — scope the change with CR
2. Produce Program Spec
3. Generate code → Compile precheck → Code review

**Program Chain (new development):**
1. Normalize raw input if needed
2. Produce Functional Spec
3. Produce Technical Design
4. Produce Program Spec
5. Generate UT Plan (`ibm-i-ut-plan-generator`) — recommended before or after coding
6. Generate test scaffold (`ibm-i-test-scaffold`) — executable SQL/CL from UT Plan (supports TDD)
7. Generate code (`ibm-i-code-generator`)
8. Compile precheck (`ibm-i-compile-precheck`) — recommended for fixed-format RPGLE
9. Review code (`ibm-i-code-reviewer`)
10. Run test scripts on IBM i — verify PASS/FAIL

**File Chain** (parallel to Program Chain from step 4):
4. Produce File Spec (`ibm-i-file-spec`)
5. Generate DDS (`ibm-i-dds-generator`)
6. Review DDS (`ibm-i-dds-reviewer`)

Use this skill whenever the user is unsure where they are in that chain or what the next move should be.

---

## Operating Modes (V1.2)

The orchestrator now operates in three modes. Modes are mutually exclusive within
a single user turn; do not mix them.

| Mode | Purpose | Input | Output |
|------|---------|-------|--------|
| **Routing Mode** (default, V1.0–V1.1) | Decide the single next skill | Any artifact, raw input, or natural-language question | Workflow Decision block (see Output Structure above) |
| **Plan Mode** (V1.2) | Generate a `task.md` batch plan from an approved Program Spec | Program Spec (+ optional File Spec, existing source, CR) | `task.md` draft (status=draft) |
| **Execute Mode** (V1.2) | Run an approved `task.md` end-to-end | Approved `task.md` (status=approved) | Mutated `task.md` + all listed target artifacts + final manifest |

### Mode Selection Triggers

| User signal | Mode |
|-------------|------|
| "what should I do next", "which skill", routing/guidance language | Routing Mode |
| "generate a task.md", "plan the batch run", "I have a Program Spec, plan the rest" | Plan Mode |
| "execute task.md", "run the batch", "kick off the plan", path to an approved task.md | Execute Mode |

If the signal is ambiguous, prefer Routing Mode and ask which the user wants.

---

## Plan Mode

### When to Enter

Plan Mode triggers when the user has one or more **approved spec**
artifacts and wants the rest of the chain batched into one execution
plan. Four entry shapes are supported:

| Entry shape | Inputs | §3 Targets emitted |
|-------------|--------|---------------------|
| **Program-spec entry** (default) | Program Spec (+ optional File Spec, existing source, CR) | Code-gen + reviewers + UT plan + test scaffold; DDS chain only if File Spec is also present |
| **File-only entry** | File Spec only (no Program Spec) | DDS-gen + DDS-review only |
| **Combined entry** | Both Program Spec and File Spec | Both chains, with parallel-safe pairs across them |
| **TD-driven multi-spec entry** (mode: `td-driven-multi-spec-batch`) | Technical Design only (no Program Spec, no File Spec) | Two-layer §3: Layer A generates N Program Specs and M File Specs from the TD; Layer B generates code, DDS, UT, tests downstream. Spec Approval Gate enforced between layers. |

**File-only boundary case.** A file-only change has just two steps
(DDS gen + DDS review) and can usually be handled by Routing Mode
instead. Plan Mode is still appropriate for file-only work when (a)
the CR touches several related files, (b) review iterations are
expected, or (c) audit traceability of the gate decision is required.
For a one-off single-file add-column change, prefer Routing Mode.

**TD-driven multi-spec entry: derivation rules.** When the input is a
Technical Design only, Plan Mode derives Layer A targets by
**cross-referencing** two TD sections — Module Allocation Table
(MAT) and Objects Affected (OA). OA is the source of truth for
Impact (New/Modified/Existing); MAT is the source of truth for
Object Type (RPGLE PGM / CLLE PGM / FILE).

Cross-reference rule:

| OA Impact | MAT Status (informational) | Action |
|-----------|-----------------------------|--------|
| `New` | typically `New` | Layer A target — program-spec or file-spec depending on Type |
| `Modified` | may be `Existing` (older TDs) or `(MODIFIED)` (newer TDs) | Layer A target — same as New |
| `Existing -- accessed` (no structural change) | typically `Existing` | **Skipped** — no spec needed |
| Object listed in MAT but missing from OA | any | **Skipped** — OA absence means no impact |
| Object listed in OA but missing from MAT | n/a | Layer A target on OA Impact alone; flag as MAT inconsistency in §7 |

Type → target-skill mapping:

| OA Type | Layer A target skill |
|---------|----------------------|
| `PGM (RPGLE)` or `PGM (CLLE)` | `ibm-i-program-spec` (TD-aware mode) |
| `FILE` | `ibm-i-file-spec` (TD-aware mode, V2.2+) |

L2 Standard and L3 Full TDs always have these tables (per
technical-design tier-guide). For L1 Lite TDs where the tables are
absent, **TD-driven mode is not appropriate** — fall back to asking the
user for the single Program Spec or File Spec they want generated, and
use Routing Mode for that single artifact.

**Layer A skill invocation contract.** When Plan Mode emits a Layer A
program-spec target, the corresponding Execute Mode call to
`ibm-i-program-spec` must use **TD-aware mode** (see
`ibm-i-program-spec` Step 0). The agent passes:

- `td_path` = §2 `technical_design` value
- `module_name` = the verbatim Object string from the TD §Module
  Allocation row, including any leading `TBD (...)` form
- `output_path` = the §3 A-target Output Path column
- `existing_source` = §2 `existing_source` if the row is Modified

Layer A **file-spec targets** call `ibm-i-file-spec` (V2.2+) in
TD-aware mode (see `ibm-i-file-spec` Step 0). The agent passes:

- `td_path` = §2 `technical_design` value
- `file_object_name` = the verbatim Object string from the TD
  §Objects Affected row (Type = FILE), including any leading
  `TBD (...)` form
- `output_path` = the §3 A-target Output Path column
- `existing_source` = §2 `existing_source` for the file (DDS source
  member) if Impact = Modified

Both program-spec and file-spec Layer A targets are now supported.

**Spec Approval Gate (TD-driven mode only).** (gate ID: `G_SpecApproval` in §5) Layer A and Layer B in §3
are separated by a structural HALT gate. Execute Mode must:

1. Run all Layer A targets to completion.
2. Set §1 status = `awaiting-spec-approval`.
3. Stop. Do not start any Layer B target.
4. **Merge derived TBDs into §7.** Read every spec produced by Layer A,
   extract each TBD / Open Question entry, and append them to §7 with
   `origin:` set to the source spec path and section. Do this *before*
   handing the task.md to the human — the human should see one
   consolidated §7 covering both the original TD-level TBDs and the
   newly-derived spec-level TBDs.
5. Wait for the human to review every generated spec, optionally call
   `ibm-i-spec-reviewer` on each, and write a non-empty
   `specs_approved_by:` value into §1.
6. The human re-sets §1 status to `running`. Execute Mode resumes with
   Layer B.

This gate is non-negotiable. The reviewer-Critical halt rule
(STOP_AND_REPORT) is a separate, dynamic mechanism that may also fire
during Layer B.

The orchestrator must verify before entering Plan Mode:

| Check | Required |
|-------|----------|
| At least one of Program Spec or File Spec is provided | Yes |
| No unresolved Critical TBDs in the provided spec(s), or user explicitly accepts skeleton mode | Yes |
| Existing source provided when this is enhancement work on existing code | Conditional |
| For file-only entry: no Program Spec is implied or required | Yes |

If a required check fails, do not generate task.md. Ask for the
missing input.

### What Plan Mode Produces

A draft `task.md` following `references/task-md-template.md`. The orchestrator
must:

1. Fill in §1 Metadata, setting `status: draft` and `approved_by: (pending)`.
2. Fill in §2 Inputs from the user's supplied paths.
3. Generate §3 Targets by inspecting the Program Spec (and File Spec if any):
   - Always include T1 (code-gen) and T3 (code-review).
   - Include T2 (compile-precheck) if the spec implies fixed-format RPGLE.
   - Include T4 (DDS-gen) and T5 (DDS-review) only if a File Spec is in §2.
   - Always include T6 (UT plan) and T7 (test scaffold) unless the user opts out.
4. Use default §4 Execution Policy and §5 Gate Definitions from the template.
5. Fill in §7 Open Questions by carrying every TBD from the input
   spec(s) — Program Spec, File Spec, and/or Technical Design — into
   the list. Each entry gets `resolution: pending` and a `blocking:`
   value chosen by these rules:
    - `blocking: yes` for any §7 entry that backs a `<...>`
      placeholder elsewhere in the task.md (Placeholder Rule
      requires this — do not weaken it).
    - `blocking: pending-human-judgment` for every other derived
      TBD. Plan Mode does not guess severity; the human classifies
      each as `yes` or `no` during approval review before
      `draft` → `approved` is allowed.
6. Leave §6 Execution Log in the initial `[ ] pending` state for every target.
7. Leave §8 Manifest empty.

### Plan Mode Output

The orchestrator returns the generated task.md content to the user with a
short header explaining:
- which targets were included and why
- which TBDs are now blocking §7 resolution
- next step: human review → set §1 status to `approved` → invoke Execute Mode

Plan Mode does not invoke any other skill. It generates the plan only.

### Gate Coverage in §5

Plan Mode emits §5 gates **only** for the following review targets:

| Target | Gate | Rationale |
|--------|------|-----------|
| Compile precheck (when present) | block_if severity == CRITICAL | Compile failures are unrecoverable downstream |
| Code review | block_if severity == CRITICAL OR br_coverage_gap == true | Code that misses business rules cannot be merged |
| DDS review (when present) | block_if severity == CRITICAL | DDS errors break file creation |

**UT plan and test scaffold targets are not gated.** Their findings are
surfaced through §6 Execution Log only. Rationale: UT artifacts are
developer-facing intermediate products; quality issues are caught in a
single human review pass after the batch run completes, not by halting
execution mid-chain. If a UT plan or test scaffold target fails outright
(skill error, not quality issue), §4 `on_skill_failure: STOP_AND_REPORT`
still applies.

### Anti-Pattern: Plan Mode Must Not

- Must not infer a Program Spec from raw input — Plan Mode requires a real
  Program Spec on disk. If only raw input is available, fall back to Routing
  Mode and route to `ibm-i-requirement-normalizer`.
- Must not add targets not listed in the template (no inventing new skill calls).
- Must not auto-approve. status must be `draft` until a human edits it.

---

## Execute Mode

### When to Enter

Execute Mode triggers when the user points the orchestrator at an existing
`task.md` whose `§1 status` is `approved`. The orchestrator reads it, validates
preconditions, and runs the batch end-to-end.

### Execution Rules

Execute Mode follows `references/task-md-execution-protocol.md` exactly. The
key rules at a glance:

1. **Refuse to run on draft.** Status must be `approved` and `approved_by`
   must be non-empty. Open Questions must all be resolved or explicitly deferred.
2. **Topological order.** Build the dependency graph from §3 Depends On. Honor
   §4 `parallel_safe` pairs. Never parallelize a target with its own gate.
3. **Real-time logging.** Append to §6 Execution Log immediately before and
   after each skill invocation. Do not batch updates.
4. **Gate evaluation.** After each target completes, evaluate every §5 gate
   that references it. A single CRITICAL finding fires the gate.
5. **Halt on Critical.** When a gate fires, set status = `blocked`, halt
   execution, and produce a block report. Do not auto-retry.
6. **Resume safely.** Re-running on a partially-completed task.md must skip
   targets already marked `[x] done`.
7. **Final manifest.** On status = `done`, fill in §8 with output paths and
   first-12 SHA-256 hex per target.

### What Execute Mode Must Not Do

- Must not modify §2, §3, §4, §5, or §7 — these are the human-approved contract.
- Must not generate any artifact not listed in §3.
- Must not invoke `ibm-i-program-spec`, `ibm-i-functional-spec`,
  `ibm-i-technical-design`, or `ibm-i-requirement-normalizer` — Execute Mode
  starts at or after Program Spec by design.
- Must not silently skip a gate. Every gate decision must be logged.

See `references/task-md-execution-protocol.md` for the complete protocol,
including TBD handling, parallel execution rules, idempotency, and the §6 log
marker reference.

---

## Plan/Execute Mode Rule

This rule joins the Core Rules above.

> The orchestrator may operate in Routing, Plan, or Execute mode within a
> conversation, but never in more than one mode per turn. Plan Mode produces a
> `task.md` and stops. Execute Mode requires `status: approved` and follows
> `task-md-execution-protocol.md` without deviation. Mode boundaries protect the
> human-approved contract: Execute Mode must never silently re-plan, and Plan
> Mode must never silently execute.

The Router-Only Rule still applies inside Plan and Execute modes — the
orchestrator routes work to the existing generation and review skills, it does
not replace them. Plan Mode chooses **which** skills to call; Execute Mode
chooses **when** to call them.
