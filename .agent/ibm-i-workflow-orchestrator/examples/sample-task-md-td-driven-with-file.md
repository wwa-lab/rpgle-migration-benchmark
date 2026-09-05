<!-- Local adaptation: repository skill references use .agent. -->

# Task: Customer Contact Capture — TD-driven Multi-Spec Batch (with File Layer A)

> **Sample task.md** — illustrates Plan Mode output for a TD-driven batch
> where Layer A produces **both** a program-spec and a file-spec. Generated
> from the fixture `./fixtures/fixture-td-customer-contact.md`. This file is
> for documentation only; it is not part of any active run.
>
> Companion to `sample-task-md-td-driven.md` which demonstrates the
> program-spec-only Layer A path. This sample exercises the file-spec
> Layer A path that became available with `ibm-i-file-spec` V2.2.

## 1. Metadata

- task_id: TASK-2026-0430-CUSTCC-TD
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

- technical_design: ./.agent/ibm-i-workflow-orchestrator/examples/fixtures/fixture-td-customer-contact.md
- existing_source: <CUSTMAST_DDS_PATH>  (TBD — resolved by §7 Q3; required for file-spec A2 because CUSTMAST is Modified)
- cr_document: (none — TD Design ID `TD-20260430-CC` acts as the change record)
- supplement_sources: []

Note: this task does not need `existing_source` for any program-spec
target because the only program target (A1, CUSTUPD) is a New program.
The `existing_source` slot here is reserved for the file-spec target's
existing DDS source.

## 3. Targets

Derivation summary (from TD, per orch SKILL §TD-driven derivation rules):
- Module Allocation Table rows: 2.
  - CUSTUPD program (NEW) → cross-checks against Objects Affected = New →
    A1 program-spec target.
  - CUSTUPD display file (EXISTING — context only) → skipped per cross-reference
    rule; a separate routing-mode file-spec call can be made later if needed.
- Objects Affected rows: 2.
  - CUSTUPD program: handled above.
  - CUSTMAST file: Type = FILE, Impact = Modified → A2 file-spec target.

### Layer A — spec generation

| ID | Type         | Skill              | Output Path                                          | Depends On                                          |
|----|--------------|--------------------|-------------------------------------------------------|------------------------------------------------------|
| A1 | program-spec | ibm-i-program-spec | ./out/specs/<CUSTUPD_PGM_NAME>-program-spec.md       | inputs.technical_design                              |
| A2 | file-spec    | ibm-i-file-spec    | ./out/specs/CUSTMAST-file-spec.md                    | inputs.technical_design, inputs.existing_source      |

A1 carries no `existing_source` because Objects Affected = New. A2 carries
`inputs.existing_source` because CUSTMAST is Modified — file-spec needs
the existing DDS source to preserve unchanged fields and position the
new EMAIL/PHONE fields at the end of the record.

--- Spec Approval Gate (see §5 G_SpecApproval) ---

### Layer B — downstream artifacts

| ID | Type          | Skill                       | Output Path                                       | Depends On |
|----|---------------|-----------------------------|----------------------------------------------------|------------|
| B1 | RPGLE source  | ibm-i-code-generator        | ./out/<CUSTUPD_PGM_NAME>.RPGLE                    | A1         |
| B2 | Code review   | ibm-i-code-reviewer         | ./out/<CUSTUPD_PGM_NAME>.code-review.md           | B1         |
| B3 | UT plan       | ibm-i-ut-plan-generator     | ./out/<CUSTUPD_PGM_NAME>.ut-plan.md               | A1         |
| B4 | Test scaffold | ibm-i-test-scaffold         | ./out/<CUSTUPD_PGM_NAME>.tests/                   | B3         |
| B5 | DDS source    | ibm-i-dds-generator         | ./out/CUSTMAST.PF                                 | A2         |
| B6 | DDS review    | ibm-i-dds-reviewer          | ./out/CUSTMAST.dds-review.md                      | B5         |

Notes:
- Compile-precheck is **omitted** for B1 — CUSTUPD is a New RPGLE program;
  the code generator will default to free format.
- `<CUSTUPD_PGM_NAME>` placeholder traces to §7 Q1 (blocking).
- `<CUSTMAST_DDS_PATH>` placeholder in §2 traces to §7 Q3 (blocking).
- CUSTMAST file name is **concrete** (no placeholder) because the TD
  states the file name explicitly in Objects Affected.

**A-target invocation (TD-aware mode).**

A1 calls `ibm-i-program-spec` (V2.6+ Step 0):
- `td_path` = `./.agent/ibm-i-workflow-orchestrator/examples/fixtures/fixture-td-customer-contact.md`
- `module_name` = `TBD (CUSTUPD program)` (verbatim from TD §Module Allocation)
- `output_path` = `./out/specs/<CUSTUPD_PGM_NAME>-program-spec.md`
- `existing_source` = (none — Objects Affected = New)

A2 calls `ibm-i-file-spec` (V2.2+ Step 0):
- `td_path` = same as A1
- `file_object_name` = `CUSTMAST` (verbatim from TD §Objects Affected)
- `output_path` = `./out/specs/CUSTMAST-file-spec.md`
- `existing_source` = `<CUSTMAST_DDS_PATH>` (TBD until §7 Q3 resolved)

## 4. Execution Policy

- on_critical_finding:   STOP_AND_REPORT
- on_high_finding:       CONTINUE_WITH_LOG
- on_tbd_in_spec:        CONTINUE_AS_SKELETON
- on_skill_failure:      STOP_AND_REPORT
- max_retries_per_task:  1
- parallel_safe:         [[A1, A2], [B1, B3, B5]]

Parallel safety derivation:
- Layer A: A1 and A2 both depend only on inputs → R1 parallel-safe.
- Cross-layer pairs are never parallel-safe (Spec Approval Gate enforces).
- Layer B: B1 (code-gen for program) depends on A1; B3 (ut-plan for
  program) depends on A1; B5 (dds-gen for file) depends on A2. None
  depends on the others, all three are independently ready once
  Layer A is approved → R1 + R3 parallel-safe across program/file chains.
- B2/B4/B6 are gated/sequenced after their respective predecessors.

## 5. Gate Definitions

### G_SpecApproval — Spec Approval Gate (TD-driven mode)
- fires_after: every Layer A target ([A1, A2]) reaches `[x] done`
- block_until: §1 `specs_approved_by` is non-empty AND §1 `status` = `running` AND no §7 entry has `blocking: pending-human-judgment`
- override: not allowed

### G1 — after B2 (code review for CUSTUPD)
- block_if: severity == CRITICAL OR br_coverage_gap == true

### G2 — after B6 (DDS review for CUSTMAST)
- block_if: severity == CRITICAL

Per SKILL.md §Gate Coverage in §5: B3 (UT plan) and B4 (test scaffold)
are **not gated**. Their findings are surfaced via §6 Execution Log only.

## 6. Execution Log

- [ ] A1 pending
- [ ] A2 pending
- [ ] B1 pending
- [ ] B2 pending
- [ ] B3 pending
- [ ] B4 pending
- [ ] B5 pending
- [ ] B6 pending

## 7. Open Questions

- Q1: Final program name for the new RPGLE customer maintenance program.
  - origin: technical_design §Module Allocation Table row 1 ("TBD (CUSTUPD program)")
  - resolution: pending
  - **blocking: yes** — backs the `<CUSTUPD_PGM_NAME>` placeholder used
    in §3 (A1 output and B1–B4 outputs).

- Q2: Final name of CUSTUPD's display file (DSPF).
  - origin: technical_design §Module Allocation Table row 2 ("TBD (CUSTUPD display file)")
  - resolution: pending
  - blocking: pending-human-judgment — the DSPF is marked (EXISTING — context only) in the
    TD; it is not in §3 scope. Resolve via a separate task.md or skip
    if it does not need its own spec.

- Q3: Existing CUSTMAST DDS source path (member in QDDSSRC).
  - origin: technical_design §Open Questions #3
  - resolution: pending
  - **blocking: yes** — backs the `<CUSTMAST_DDS_PATH>` placeholder in
    §2 `existing_source`. file-spec A2 cannot run delta-first (preserve
    8 unchanged fields, append EMAIL/PHONE) without it.

- Q4: EMAIL field length — TD assumes 60A.
  - origin: technical_design §Open Questions #4
  - resolution: pending
  - blocking: pending-human-judgment — file-spec A2 will encode this length into the
    DDS field definition. Wrong length is hard to undo after deployment
    (existing data padding/truncation issues). Resolve before A2 runs.

**Note: §7 will grow.** Plan Mode populates this section with TBDs
visible in the TD itself. Once Layer A produces the actual specs (A1
program-spec and A2 file-spec), each will introduce its own TBDs.
Those new questions are merged into §7 **automatically by Execute
Mode** (step 5a of the execution algorithm) with `blocking:
pending-human-judgment`. The human at Spec Approval Gate review must
classify each merged entry as `yes` or `no` before releasing the gate.

## 8. Final Deliverables Manifest

(Empty — populated by Execute Mode at run completion.)
