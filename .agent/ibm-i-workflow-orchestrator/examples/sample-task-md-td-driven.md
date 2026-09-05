<!-- Local adaptation: repository skill references use .agent. -->

# Task: Order Validation — TD-driven Multi-Spec Batch

> **Sample task.md** — illustrates Plan Mode output for a **TD-driven
> multi-spec batch** scenario. Generated from
> `.agent/ibm-i-technical-design/examples/sample-rpgle-design.md`.
> This file is for documentation only; it is not part of any active run.
>
> Demonstrates: two-layer §3 (Layer A spec generation, Layer B downstream
> artifacts), Spec Approval Gate between layers, derivation from
> Module Allocation Table + Objects Affected table.

## 1. Metadata

- task_id: TASK-2026-0430-ORDVAL-TD
- entry_layer: technical-design
- exit_layer: test-scaffold
- mode: td-driven-multi-spec-batch
- created_by: agent (Plan Mode draft)
- approved_by: (pending)
- specs_approved_by: (pending — set after Layer A completes and human reviews specs)
- created_at: 2026-04-30
- approved_at: (pending)
- status: draft

## 2. Inputs

- technical_design: ./.agent/ibm-i-technical-design/examples/sample-rpgle-design.md
- existing_source: ./out/legacy/<CLLE_DRIVER_NAME>.CLLE  (TBD — resolved by §7 Q2; required for the Modified CLLE driver)
- cr_document: (none — TD's design intent acts as the change record)
- supplement_sources: []

## 3. Targets

Derivation summary (from TD):
- Module Allocation Table: 2 rows. `order validation program` (New) and
  `CLLE batch driver` (Existing, but listed as Modified in Objects
  Affected) → both yield Layer A program-spec targets.
- Objects Affected: 1 file row, `order master file` marked
  "Existing — accessed" with no structural change → **no** file-spec
  target generated. customer master file is not in Objects Affected →
  also skipped.
- Net Layer A: 2 program-spec targets, 0 file-spec targets.

### Layer A — spec generation

| ID | Type         | Skill              | Output Path                                     | Depends On              |
|----|--------------|--------------------|--------------------------------------------------|--------------------------|
| A1 | program-spec | ibm-i-program-spec | ./out/specs/<ORDVAL_PGM_NAME>-program-spec.md   | inputs.technical_design  |
| A2 | program-spec | ibm-i-program-spec | ./out/specs/<CLLE_DRIVER_NAME>-program-spec.md  | inputs.technical_design, inputs.existing_source |

A2 carries `inputs.existing_source` because the CLLE driver is Modified
(Objects Affected table). A1 does not carry existing_source because it
is a New program.

--- Spec Approval Gate (see §5 G_SpecApproval) ---

### Layer B — downstream artifacts

| ID | Type             | Skill                       | Output Path                                          | Depends On |
|----|------------------|-----------------------------|------------------------------------------------------|------------|
| B1 | RPGLE source     | ibm-i-code-generator        | ./out/<ORDVAL_PGM_NAME>.RPGLE                        | A1         |
| B2 | Code review      | ibm-i-code-reviewer         | ./out/<ORDVAL_PGM_NAME>.code-review.md               | B1         |
| B3 | UT plan          | ibm-i-ut-plan-generator     | ./out/<ORDVAL_PGM_NAME>.ut-plan.md                   | A1         |
| B4 | Test scaffold    | ibm-i-test-scaffold         | ./out/<ORDVAL_PGM_NAME>.tests/                       | B3         |
| B5 | CLLE source      | ibm-i-code-generator        | ./out/<CLLE_DRIVER_NAME>.CLLE                        | A2         |
| B6 | Compile precheck | ibm-i-compile-precheck      | ./out/<CLLE_DRIVER_NAME>.precheck.md                 | B5         |
| B7 | Code review      | ibm-i-code-reviewer         | ./out/<CLLE_DRIVER_NAME>.code-review.md              | B5, B6     |
| B8 | UT plan          | ibm-i-ut-plan-generator     | ./out/<CLLE_DRIVER_NAME>.ut-plan.md                  | A2         |
| B9 | Test scaffold    | ibm-i-test-scaffold         | ./out/<CLLE_DRIVER_NAME>.tests/                      | B8         |

Notes:
- B6 (compile-precheck) is included for the CLLE driver (B5) because A2
  is a Modified existing program — most likely fixed-format. B1 is for
  a New RPGLE program; precheck is omitted there by default.
- All `<...>` placeholders in §3 trace to §7 Q1 / Q2 (blocking).

**A-target invocation (TD-aware mode).** Each Layer A target calls
`ibm-i-program-spec` with these arguments:

- A1:
    - `td_path` = `./.agent/ibm-i-technical-design/examples/sample-rpgle-design.md`
    - `module_name` = `TBD (order validation program)` (verbatim from TD)
    - `output_path` = `./out/specs/<ORDVAL_PGM_NAME>-program-spec.md`
    - `existing_source` = (none — Objects Affected = New)
- A2:
    - `td_path` = same as A1
    - `module_name` = `TBD (CLLE batch driver)` (verbatim from TD)
    - `output_path` = `./out/specs/<CLLE_DRIVER_NAME>-program-spec.md`
    - `existing_source` = `./out/legacy/<CLLE_DRIVER_NAME>.CLLE`

Note: `module_name` is passed verbatim including the leading `TBD (...)`
form. The skill emits a Spec Header with `Program Name: TBD` and the
orchestrator resolves it later via §7 Q1/Q2 before code generation.

## 4. Execution Policy

- on_critical_finding:   STOP_AND_REPORT
- on_high_finding:       CONTINUE_WITH_LOG
- on_tbd_in_spec:        CONTINUE_AS_SKELETON
- on_skill_failure:      STOP_AND_REPORT
- max_retries_per_task:  1
- parallel_safe:         [[A1, A2], [B1, B3], [B5, B8]]

Parallel safety derivation:
- A1 and A2 both depend only on inputs (Layer A). By R1 they are parallel-safe.
- Cross-layer pairs are never parallel-safe (Spec Approval Gate enforces).
- Within Layer B per module: B1 (code-gen) and B3 (UT plan) for the
  ORDVAL program both depend only on A1 → parallel-safe. Likewise B5/B8
  for the CLLE driver. B1/B5 cannot be paired because they belong to
  different module chains and would need a wider review.

## 5. Gate Definitions

### G_SpecApproval — Spec Approval Gate (TD-driven mode)
- fires_after: every Layer A target ([A1, A2]) reaches `[x] done`
- block_until: §1 `specs_approved_by` is non-empty AND §1 `status` = `running`
- override: not allowed

### G1 — after B6 (compile precheck for CLLE driver)
- block_if: severity == CRITICAL

### G2 — after B2 (code review for ORDVAL)
- block_if: severity == CRITICAL OR br_coverage_gap == true

### G3 — after B7 (code review for CLLE driver)
- block_if: severity == CRITICAL OR br_coverage_gap == true

Per SKILL.md §Gate Coverage in §5: B3, B4, B8, B9 (UT plans and test
scaffolds) are **not gated**. Their findings are surfaced via §6
Execution Log only and reviewed by humans after the batch run completes.

## 6. Execution Log

- [ ] A1 pending
- [ ] A2 pending
- [ ] B1 pending
- [ ] B2 pending
- [ ] B3 pending
- [ ] B4 pending
- [ ] B5 pending
- [ ] B6 pending
- [ ] B7 pending
- [ ] B8 pending
- [ ] B9 pending

## 7. Open Questions

- Q1: Final program name for the new order validation RPGLE program.
  - origin: technical_design §Module Allocation Table row 1 ("TBD (order validation program)")
  - resolution: pending
  - **blocking: yes** — backs the `<ORDVAL_PGM_NAME>` placeholder in
    §3 (A1 output, B1–B4 outputs).

- Q2: Final program name for the existing CLLE batch driver.
  - origin: technical_design §Module Allocation Table row 2 ("TBD (CLLE batch driver)")
  - resolution: pending
  - **blocking: yes** — backs the `<CLLE_DRIVER_NAME>` placeholder in
    §2 existing_source and in §3 (A2 output, B5–B9 outputs). Without
    this, A2 cannot find the existing source to do delta-first
    enhancement.

- Q3: TD §Operating Considerations marks Estimated Volume and Job Queue
  as TBD.
  - origin: technical_design §Operating Considerations
  - resolution: pending
  - blocking: pending-human-judgment — Affects deployment notes only, not code generation.
    Mark as `confirmed-defer` to proceed.

**Note: §7 will grow.** Plan Mode populates this section with TBDs
visible in the TD itself. Once Layer A produces the actual Program
Specs (A1 and A2 outputs), each generated spec will introduce its own
TBDs. Those new questions are merged into §7 **automatically by Execute Mode** (step 5a of the execution algorithm) as part
of Spec Approval Gate processing — before status flips to `awaiting-spec-approval`. The human reviews the consolidated §7 and writes `specs_approved_by:` to release the gate.

## 8. Final Deliverables Manifest

(Empty — populated by Execute Mode at run completion.)
