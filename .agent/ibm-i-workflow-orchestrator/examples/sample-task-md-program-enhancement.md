<!-- Local adaptation: repository skill references use .agent. -->

# Task: ORDCONF — Increase Credit Limit Threshold from $5K to $10K

> **Sample task.md** — illustrates Plan Mode output for a **program-only
> enhancement** scenario (no file changes). Generated from
> `.agent/ibm-i-program-spec/sample-lite-spec.md`. This file is for
> documentation only; it is not part of any active run.
>
> Demonstrates: existing-source input, compile-precheck inclusion,
> CR-document substitution by Spec ID, multiple blocking TBDs.

## 1. Metadata

- task_id: TASK-2026-0430-ORDCONF-CR02
- entry_layer: program-spec
- exit_layer: test-scaffold
- mode: single-requirement-full-chain
- created_by: agent (Plan Mode draft)
- approved_by: (pending)
- created_at: 2026-04-30
- approved_at: (pending)
- status: draft

## 2. Inputs

- program_spec: ./.agent/ibm-i-program-spec/sample-lite-spec.md
- file_spec:    (none — change does not affect file objects; ORDHDRPF read-only path)
- existing_source: ./out/legacy/<P_PGM_NAME>.RPGLE  (TBD — resolved by §7 Q1; needed for delta-first enhancement code generation)
- cr_document: (none — Spec ID ORDCONF-20260401-02 acts as the change record)
- supplement_sources: []

## 3. Targets

| ID | Type             | Skill                       | Output Path                       | Depends On            |
|----|------------------|-----------------------------|-----------------------------------|------------------------|
| T1 | RPGLE source     | ibm-i-code-generator        | ./out/<P_PGM_NAME>.RPGLE          | inputs.program_spec, inputs.existing_source |
| T2 | Compile precheck | ibm-i-compile-precheck      | ./out/<P_PGM_NAME>.precheck.md    | T1                     |
| T3 | Code review      | ibm-i-code-reviewer         | ./out/<P_PGM_NAME>.code-review.md | T1, T2                 |
| T4 | UT plan          | ibm-i-ut-plan-generator     | ./out/<P_PGM_NAME>.ut-plan.md     | inputs.program_spec    |
| T5 | Test scaffold    | ibm-i-test-scaffold         | ./out/<P_PGM_NAME>.tests/         | T4                     |

Notes:
- T2 (compile-precheck) is **included** because this is enhancement work
  on existing RPGLE source — most likely fixed-format. The precheck
  catches format/key/error-mapping risks before code-review runs.
- DDS-gen / DDS-review targets are **omitted** — no File Spec is in scope.
- `<P_PGM_NAME>` appears in every Output Path. It is resolved by §7 Q1
  (blocking). Per Placeholder Rules, this task.md cannot move to
  `approved` until Q1 is resolved.
- The same placeholder also appears in §2 `existing_source`. That entry
  is marked TBD; the path resolves once Q1 is answered (the program
  name determines both the output path and the existing source path).

## 4. Execution Policy

- on_critical_finding:   STOP_AND_REPORT
- on_high_finding:       CONTINUE_WITH_LOG
- on_tbd_in_spec:        CONTINUE_AS_SKELETON
- on_skill_failure:      STOP_AND_REPORT
- max_retries_per_task:  1
- parallel_safe:         [[T1, T4]]

Parallel safety derivation (per template Parallel Safety Rules):
- T1 (code-gen) and T4 (UT-plan) both depend only on inputs (T4 uses
  only `inputs.program_spec`). By R1 + R4 they are parallel-safe.
- T2 is gated on T1 (R2) → sequential after T1.
- T3 depends on both T1 and T2 (R1) → sequential after T2.
- T5 depends on T4 (R1) → sequential after T4.

## 5. Gate Definitions

### G1 — after T2 (compile precheck)
- block_if: severity == CRITICAL

### G2 — after T3 (code review)
- block_if: severity == CRITICAL OR br_coverage_gap == true

Per SKILL.md §Gate Coverage in §5: T4 (UT plan) and T5 (test scaffold) are
**not gated**. Their findings are surfaced via §6 Execution Log only and
are reviewed by humans after the batch run completes. Skill errors on T4
or T5 still halt the run via §4 `on_skill_failure: STOP_AND_REPORT`.

## 6. Execution Log

- [ ] T1 pending
- [ ] T2 pending
- [ ] T3 pending
- [ ] T4 pending
- [ ] T5 pending

## 7. Open Questions

- Q1: Program name (*PGM object) is not specified.
  - origin: program_spec §Spec Header
  - resolution: pending
  - **blocking: yes** — backs the `<P_PGM_NAME>` placeholder used in
    every §3 Output Path **and** in §2 `existing_source`. Both must
    be resolved together before approval.

- Q2: Is the $10,000 limit inclusive or exclusive (`>` vs `>=`)?
  - origin: program_spec §Open Questions #2
  - resolution: pending
  - blocking: pending-human-judgment — Step 7 in main logic literally encodes the
    comparison. The wrong operator silently mis-rejects a $10,000.00
    order on day one of release. This must be resolved before code
    generation; do not rely on the spec's existing `> C_CREDIT_LMT`
    text since that may have been written before BR-04 was finalized.

- Q3: Does this limit apply to all order types or only specific ones?
  - origin: program_spec §Open Questions #3
  - resolution: pending
  - blocking: pending-human-judgment — if the limit is conditional on order type, Step
    7 needs an additional guard (e.g., `IF order_type IN (...)`). The
    current spec implies unconditional application; if business wants
    type-specific behavior, BR-04 needs a new clause and the Main Logic
    needs a new step.
  - **Fallback if not resolved before approval:** §4
    `on_tbd_in_spec` is set to `CONTINUE_AS_SKELETON`, which means the
    **whole program** is generated in Skeleton mode — not just Step 7.
    Well-defined steps still appear, but as skeleton-shaped code with
    `TODO (Q3)` markers concentrated where the order-type guard would
    live. This is generally not acceptable for an L1 Lite enhancement
    where Full Implementation is the expected output.

## 8. Final Deliverables Manifest

(Empty — populated by Execute Mode at run completion.)
