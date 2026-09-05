<!-- Local adaptation: repository skill references use .agent. -->

# Task: ORDCONF — New Order Confirmation Program

> **Sample task.md** — illustrates Plan Mode output for a New Program scenario
> with no File Spec and no compile-precheck. Generated from
> `.agent/ibm-i-program-spec/sample-rpgle-spec.md`. This file is for
> documentation only; it is not part of any active run.

## 1. Metadata

- task_id: TASK-2026-0430-ORDCONF
- entry_layer: program-spec
- exit_layer: test-scaffold
- mode: single-requirement-full-chain
- created_by: agent (Plan Mode draft)
- approved_by: (pending)
- created_at: 2026-04-30
- approved_at: (pending)
- status: draft

## 2. Inputs

- program_spec: ./.agent/ibm-i-program-spec/sample-rpgle-spec.md
- file_spec:    (none — change does not create or alter file objects; ORDHDRPF is read/updated only)
- existing_source: (none — Change Type: New Program)
- cr_document: (none provided)
- supplement_sources: []

## 3. Targets

| ID | Type          | Skill                       | Output Path                       | Depends On            |
|----|---------------|-----------------------------|-----------------------------------|------------------------|
| T1 | RPGLE source  | ibm-i-code-generator        | ./out/<P_PGM_NAME>.RPGLE          | inputs.program_spec    |
| T2 | Code review   | ibm-i-code-reviewer         | ./out/<P_PGM_NAME>.code-review.md | T1                     |
| T3 | UT plan       | ibm-i-ut-plan-generator     | ./out/<P_PGM_NAME>.ut-plan.md     | inputs.program_spec    |
| T4 | Test scaffold | ibm-i-test-scaffold         | ./out/<P_PGM_NAME>.tests/         | T3                     |

Notes:
- Compile-precheck is **omitted** — New Program with no fixed-format RPGLE
  signal in the spec; the code generator will default to free format.
- DDS-gen / DDS-review targets are **omitted** — no File Spec is in scope.
- `<P_PGM_NAME>` appears in every Output Path. It is resolved by §7 Q1
  (blocking). Per Placeholder Rules in `task-md-template.md`, this task.md
  cannot move to `approved` until Q1 is resolved and §3 paths are rewritten.

## 4. Execution Policy

- on_critical_finding:   STOP_AND_REPORT
- on_high_finding:       CONTINUE_WITH_LOG
- on_tbd_in_spec:        CONTINUE_AS_SKELETON
- on_skill_failure:      STOP_AND_REPORT
- max_retries_per_task:  1
- parallel_safe:         [[T1, T3]]

Parallel safety derivation (per template Parallel Safety Rules):
- T1 (code-gen) and T3 (UT-plan) both depend only on `inputs.program_spec`,
  so by R1 + R4 they are parallel-safe.
- T2 (code-review) is gated on T1, so by R2 it cannot run in parallel with T1.
- T4 (test-scaffold) depends on T3, so by R1 it cannot run in parallel with T3.

## 5. Gate Definitions

### G1 — after T2 (code review)
- block_if: severity == CRITICAL OR br_coverage_gap == true

Per SKILL.md §Gate Coverage in §5: T3 (UT plan) and T4 (test scaffold) are
**not gated**. Quality issues found in those artifacts are surfaced via §6
Execution Log only and are reviewed by humans after the batch run completes.
A skill error (not a quality issue) on T3 or T4 still halts the run via §4
`on_skill_failure: STOP_AND_REPORT`.

## 6. Execution Log

- [ ] T1 pending
- [ ] T2 pending
- [ ] T3 pending
- [ ] T4 pending

## 7. Open Questions

- Q1: Program name (*PGM object) is not specified.
  - origin: program_spec §Spec Header
  - resolution: pending
  - **blocking: yes** — code generator cannot produce a source member
    without the target program name. This question backs the
    `<P_PGM_NAME>` placeholder used in every §3 Output Path. Both must
    be resolved together before approval.

- Q2: Exact name of the calling order entry display program.
  - origin: program_spec §Caller Context
  - resolution: pending
  - blocking: pending-human-judgment — affects only Caller Context narrative; code generation
    uses program parameters, not caller-name knowledge. Defer is acceptable.

- Q3: Library for ORDLOGDQ data queue.
  - origin: program_spec §Data Queue
  - resolution: pending
  - blocking: pending-human-judgment — generator can emit `*LIBL` qualifier. Mark as
    `confirmed-defer` if shop convention supports `*LIBL` lookup, otherwise
    resolve before approval.

- Q4: Exact layout of LOG_ENTRY_DS.
  - origin: program_spec §Internal Data Structure
  - resolution: pending
  - blocking: pending-human-judgment — Step 9 builds LOG_ENTRY_DS and Step 10 sends it to
    ORDLOGDQ. The generator cannot infer field types/lengths/order.
  - **Fallback if not resolved:** §4 `on_tbd_in_spec` is set to
    `CONTINUE_AS_SKELETON`, which means the **whole program** is generated
    in Skeleton mode — not just Steps 9–10. Well-defined steps still
    appear, but as skeleton-shaped code with `TODO (Q4)` markers
    concentrated where LOG_ENTRY_DS is referenced. If a Full Implementation
    is required, this question must be resolved before approval.

- Q5: Should the program log the specific failure reason?
  - origin: program_spec §Error Handling
  - resolution: pending
  - blocking: pending-human-judgment — affects logging detail only. Default behavior matches
    the existing Error Handling table (Logged column = "No" for validation
    rows, "Yes" for system error and update failure rows). Mark as
    `confirmed-defer` to accept the default.

## 8. Final Deliverables Manifest

(Empty — populated by Execute Mode at run completion.)
