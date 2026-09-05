# task.md Template (V1.0)

This template is used by `ibm-i-workflow-orchestrator` in **Plan Mode** to generate
a batch execution plan for a single requirement, and consumed by the same
orchestrator in **Execute Mode** to drive end-to-end skill execution.

---

## Scope of This Template

`task.md` is **not a new spec layer**. It is an execution plan + state machine that
lets one approved Program Spec drive all downstream artifacts (code, DDS, UT plan,
test scaffold) plus their review gates in one batched run.

**Default entry point:** Program Spec (already approved).
**Default exit point:** Test Scaffold (executable SQL/CL scripts).
**Default HITL gate:** any reviewer Critical finding.

The template below is the canonical structure. The orchestrator may omit sections
that do not apply (e.g., omit DDS targets when there is no File Spec).

---

## Template

```markdown
# Task: <CR ID or short requirement title>

## 1. Metadata

- task_id: TASK-YYYY-MMDD-NNN
- entry_layer: program-spec
- exit_layer: test-scaffold
- mode: single-requirement-full-chain
- created_by: agent (Plan Mode draft)
- approved_by: <human reviewer> | (pending)
- created_at: YYYY-MM-DD
- approved_at: YYYY-MM-DD | (pending)
- status: draft | approved | running | blocked | done | failed

## 2. Inputs

Required and optional input artifacts. All paths are relative to repo root.

- program_spec: <path>                  # required
- file_spec:    <path>                  # optional — include only if file objects change
- existing_source: <path>               # required for enhancement work
- cr_document: <path>                   # optional — original change request; if omitted, the Spec ID in the spec header acts as the change record
- supplement_sources: [<path>, ...]     # optional — peer members for style/naming

## 3. Targets

Each target is a single deliverable produced by exactly one skill.
The Depends On column drives execution order. Targets with no shared
ancestor on the critical path may be executed in parallel (see §4).

| ID | Type              | Skill                       | Output Path                       | Depends On            |
|----|-------------------|-----------------------------|-----------------------------------|------------------------|
| T1 | RPGLE/CLLE source | ibm-i-code-generator        | ./out/<PGM>.RPGLE                 | inputs.program_spec    |
| T2 | Compile precheck  | ibm-i-compile-precheck      | ./out/<PGM>.precheck.md           | T1                     |
| T3 | Code review       | ibm-i-code-reviewer         | ./out/<PGM>.code-review.md        | T1, T2                 |
| T4 | DDS source        | ibm-i-dds-generator         | ./out/<FILE>.PF                   | inputs.file_spec       |
| T5 | DDS review        | ibm-i-dds-reviewer          | ./out/<FILE>.dds-review.md        | T4                     |
| T6 | UT plan           | ibm-i-ut-plan-generator     | ./out/<PGM>.ut-plan.md            | inputs.program_spec    |
| T7 | Test scaffold     | ibm-i-test-scaffold         | ./out/<PGM>.tests/                | T6                     |

Notes:
- Omit the DDS rows (T4, T5) when no file_spec is provided.
- For new (non-fixed-format) RPGLE programs, T2 may be optional — the orchestrator
  will mark it skipped in §6 with a reason.

**TD-driven variant (two layers).** When `mode: td-driven-multi-spec-batch`,
§3 is structured as two explicit layers separated by a divider:

```
Layer A — spec generation

| ID | Type | Skill | Output Path | Depends On |
|----|------|-------|-------------|------------|
| A1 | program-spec | ibm-i-program-spec | ./out/specs/<MOD1>-program-spec.md | inputs.technical_design |
| A2 | program-spec | ibm-i-program-spec | ./out/specs/<MOD2>-program-spec.md | inputs.technical_design |
| A3 | file-spec    | ibm-i-file-spec    | ./out/specs/<FILE1>-file-spec.md   | inputs.technical_design |

--- Spec Approval Gate (see §5) ---

Layer B — downstream artifacts

| ID | Type | Skill | Output Path | Depends On |
|----|------|-------|-------------|------------|
| B1 | RPGLE source     | ibm-i-code-generator    | ./out/<MOD1>.RPGLE                 | A1 |
| B2 | Code review      | ibm-i-code-reviewer     | ./out/<MOD1>.code-review.md        | B1 |
| B3 | UT plan          | ibm-i-ut-plan-generator | ./out/<MOD1>.ut-plan.md            | A1 |
| B4 | Test scaffold    | ibm-i-test-scaffold     | ./out/<MOD1>.tests/                | B3 |
| B5 | RPGLE source     | ibm-i-code-generator    | ./out/<MOD2>.RPGLE                 | A2 |
| B6 | Code review      | ibm-i-code-reviewer     | ./out/<MOD2>.code-review.md        | B5 |
| B7 | UT plan          | ibm-i-ut-plan-generator | ./out/<MOD2>.ut-plan.md            | A2 |
| B8 | Test scaffold    | ibm-i-test-scaffold     | ./out/<MOD2>.tests/                | B7 |
| B9 | DDS source       | ibm-i-dds-generator     | ./out/<FILE1>.PF                   | A3 |
| B10| DDS review       | ibm-i-dds-reviewer      | ./out/<FILE1>.dds-review.md        | B9 |
```

Layer-A IDs use the `A` prefix; Layer-B IDs use the `B` prefix. Layer-B
rows depend on Layer-A target IDs, not on inputs directly. The Spec
Approval Gate (defined in §5) sits between the two layers.

**A-target invocation contract.** Each Layer A spec-generation target
calls a spec skill in TD-aware mode. The agent passes:

- For **program-spec** targets (calling `ibm-i-program-spec` V2.6+ Step 0):
    - `td_path = inputs.technical_design`
    - `module_name = <verbatim TD Module Allocation Object string>`
    - `output_path = <§3 Output Path column>`
    - `existing_source = inputs.existing_source` (only if Modified)
- For **file-spec** targets (calling `ibm-i-file-spec` V2.2+ Step 0):
    - `td_path = inputs.technical_design`
    - `file_object_name = <verbatim TD Objects Affected Object string>`
    - `output_path = <§3 Output Path column>`
    - `existing_source = inputs.existing_source` for the file (DDS source) if Modified

Both spec types are now supported in Layer A.

## 4. Execution Policy

- on_critical_finding:   STOP_AND_REPORT       # any reviewer Critical halts the run
- on_high_finding:       CONTINUE_WITH_LOG     # High issues recorded, do not stop
- on_tbd_in_spec:        CONTINUE_AS_SKELETON  # TBDs degrade code-gen to skeleton mode
- on_skill_failure:      STOP_AND_REPORT       # any skill error halts the run
- max_retries_per_task:  1
- parallel_safe:         (computed by Plan Mode — see Parallel Safety Rules)

## 5. Gate Definitions

Gates fire after specific targets and decide whether execution continues.

### G1 — after T2 (compile precheck)
- block_if: severity == CRITICAL

### G2 — after T3 (code review)
- block_if: severity == CRITICAL OR br_coverage_gap == true

### G3 — after T5 (dds review)
- block_if: severity == CRITICAL

### G_SpecApproval — Spec Approval Gate (TD-driven mode only)

Structural HALT gate inserted between Layer A and Layer B in §3.
Unlike severity-based gates (G1/G2/G3), this gate **always fires** the
first time it is reached and only releases when a human writes a
non-empty `specs_approved_by:` value into §1 and resets §1 status from
`awaiting-spec-approval` back to `running`.

- fires_after: every Layer A target reaches `[x] done`
- block_until: §1 `specs_approved_by` is non-empty AND §1 `status` = `running`
- override: not allowed (no waiver field)

This gate is auto-emitted by Plan Mode when `mode: td-driven-multi-spec-batch`.
It is not present in any other mode.

a target ID and a single block_if condition.

## 6. Execution Log

The orchestrator appends to this section in real time during Execute Mode.
Each line is one of:
- `[ ] <Tn> pending`
- `[~] <Tn> running @ HH:MM`
- `[x] <Tn> done @ HH:MM → <output path>`
- `[!] <Tn> blocked @ HH:MM — <reason>`
- `[s] <Tn> skipped — <reason>`

Initial state (Plan Mode writes this; Execute Mode mutates it):

- [ ] T1 pending
- [ ] T2 pending
- [ ] T3 pending
- [ ] T4 pending
- [ ] T5 pending
- [ ] T6 pending
- [ ] T7 pending

## 7. Open Questions

Carried from the input Program Spec (and File Spec, if present). Each item must
be resolved before the run reaches the target that depends on it, or be
explicitly marked deferred.

- Q1: <quoted TBD location and text>
  - origin: program_spec §<n>
  - resolution: pending | resolved (<note>) | confirmed-defer | block

## 8. Final Deliverables Manifest

Filled in by Execute Mode at run completion. Do not write during Plan Mode.

| ID | Output Path | SHA-256 (first 12) | Reviewer Verdict | Status |
|----|-------------|--------------------|------------------|--------|
| T1 |             |                    |                  |        |
| T2 |             |                    |                  |        |
| ...|             |                    |                  |        |
```

---

## Field Conventions

### Mode values

Allowed values for §1 `mode`. Plan Mode picks the value that matches
the entry shape; do not invent new mode names.

| Value | When to use |
|-------|-------------|
| `single-requirement-full-chain` | Default. Program-spec entry, with or without an accompanying File Spec. Both Program and File chains may be in §3. |
| `file-only-enhancement` | File-only entry (File Spec only, no Program Spec). §3 contains DDS-gen + DDS-review only. |
| `td-driven-multi-spec-batch` | Technical Design entry. §3 has two layers (Layer A: spec generation, Layer B: downstream artifacts) separated by a Spec Approval Gate. §1 also requires `specs_approved_by`. Layer A supports both program-spec targets (via `ibm-i-program-spec` V2.6+) and file-spec targets (via `ibm-i-file-spec` V2.2+). |
| `minimal` | Trivial L1 change where §4, §5, §7, §8 are omitted. See Minimum Viable task.md below. |

### Status values

| Value | Meaning |
|-------|---------|
| `draft` | Plan Mode generated, awaiting human approval |
| `approved` | Human approved, not yet started |
| `running` | Execute Mode currently active |
| `awaiting-spec-approval` | (TD-driven mode only) Layer A complete; Execute Mode halted at the Spec Approval Gate. Waiting for `specs_approved_by` to be filled and status reset to `running`. |
| `blocked` | Halted on a gate; waiting for human resolution |
| `done` | All targets complete, all gates passed |
| `failed` | Stopped on unrecoverable error or rejected gate |

### Target ID conventions

- Use `T1`..`Tn` in execution-recommended order.
- Do not reuse IDs across runs.
- When a target is added during human review of the draft, append rather than
  renumber.

### CR document fallback

When `§2 cr_document` is not provided, the Spec ID in the input
spec header acts as the change record (e.g.,
`ORDCONF-20260401-02` from `program_spec.§Spec Header`). Plan Mode
must annotate this in §2 with a comment like
`(none — Spec ID <spec-id> acts as the change record)` so the
audit trail is explicit.

Use a real CR document when one exists. The Spec ID fallback is
intended for small enhancements or internal changes where a
formal CR was never raised, not as a way to skip CR discipline
on changes that should have one.

### Path conventions

- All output paths under `./out/` (or as configured per project).
- One output file per target, except `test-scaffold` which produces a directory.

---

---

## Placeholder Rules

Any field in this task.md may contain `<...>` placeholders when a value
cannot be known at Plan Mode time. Common locations:

- §2 Inputs paths (e.g., `existing_source: ./out/legacy/<P_PGM_NAME>.RPGLE`)
- §3 Output Path columns
- §3 Type column when the artifact name itself depends on a TBD

When the orchestrator emits a placeholder anywhere in the task.md:

- It **must** emit a corresponding question in §7 Open Questions with
  `blocking: yes`.
- It **must** point the reader to which Q-id resolves the placeholder
  in the nearest Notes section (§3 Notes for §3 placeholders, a §2
  comment line for §2 placeholders).
- The same placeholder name may appear in multiple locations (e.g.,
  `<P_PGM_NAME>` in both §2 `existing_source` and §3 Output Paths) —
  one §7 question is enough; do not duplicate.
- The task.md **cannot** move from `draft` to `approved` until every
  placeholder has been replaced with a concrete value and the matching
  Q-id has `resolution: resolved (<value>)`.

Placeholder syntax: angle brackets around an UPPER_SNAKE_CASE name —
e.g., `<P_PGM_NAME>`, `<TARGET_LIBRARY>`. Plain `<TBD>` is not allowed
anywhere — be specific so Q-id mapping is unambiguous.

Execute Mode must refuse to run if any field anywhere in the task.md
still contains a `<...>` placeholder, regardless of §1 status.
---

## §7 Blocking Field Values

Each Open Question's `blocking:` field uses one of these values:

| Value | Meaning | Set by |
|-------|---------|--------|
| `yes` | This question must be resolved before approval / Layer B start | Plan Mode (TD-level) or human (during review) |
| `no` | Can be deferred without breaking downstream work | Plan Mode or human |
| `pending-human-judgment` | Auto-derived TBD (from TD-level Open Questions in Plan Mode, or from Layer A spec output in Execute Mode); agent could not infer blocking severity | Plan Mode (TD-level TBDs not backing a placeholder), or Execute Mode step 5a (Spec Approval Gate merge) |

Rules:

- Plan Mode writes `pending-human-judgment` for any TD-level TBD it
  cannot classify with confidence. The two structural exceptions are:
    - **Placeholder backers** — when a §7 entry exists specifically
      to back a `<...>` placeholder elsewhere in the task.md, Plan
      Mode must write `blocking: yes` (the Placeholder Rule already
      requires this; do not regress to pending-human-judgment here).
    - **Trivial deferrable annotations** — when Plan Mode adds an
      entry purely for audit traceability (e.g., "no TBDs derived"
      placeholder line during step 5a), `blocking: no` is acceptable
      because no human judgment is needed.
- Execute Mode merge step 5a writes `pending-human-judgment` for every
  derived TBD. The human at Spec Approval Gate must change every such
  entry to `yes` or `no` before releasing the gate.
- Execute Mode resume from `awaiting-spec-approval` to `running` is
  blocked if any §7 entry still has `blocking: pending-human-judgment`.

---

## Parallel Safety Rules

§4 `parallel_safe` is **not** a fixed default. Plan Mode computes it from the
actual targets emitted in §3 by these rules:

| Rule | Description |
|------|-------------|
| R1 | Two targets are parallel-safe only if their Depends On sets are disjoint, i.e., neither is in the other's transitive ancestors. |
| R2 | A target and its own gate (anything in §5 referencing it) are **never** parallel — gates run sequentially after their target. |
| R3 | Code-generation targets (T1) and DDS-generation targets (T4) are typically parallel-safe because both depend only on inputs. Plan Mode should emit `[T1, T4]` whenever both targets exist. |
| R4 | UT-plan generation depends only on inputs (not on T1 output), so it is parallel-safe with code-gen and DDS-gen. Plan Mode should emit a pair containing the UT-plan target and any other input-only target that exists. |
| R5 | Reviewer targets that operate on different chains (code-review on T1, DDS-review on T4) are parallel-safe with each other. |

If §3 contains only sequential dependencies (rare — typically a small L1
enhancement), `parallel_safe` may be empty: `parallel_safe: []`.

Plan Mode must enumerate the actual T-IDs that exist in this task.md — never
copy a generic example with hard-coded T-numbers from another task.md.

## Minimum Viable task.md

For trivial L1 enhancements where DDS is not involved and tests are skipped, the
minimum content is sections 1, 2, 3, and 6. The orchestrator may omit 4, 5, 7, 8
in this case but must explain the omission in §1 metadata as `mode: minimal`.

---

## Companion Document

For the rules governing how this task.md is consumed during a batch run —
including precondition checks, gate evaluation, parallel execution, idempotent
resume, and the §6 log marker reference — see `task-md-execution-protocol.md`.
