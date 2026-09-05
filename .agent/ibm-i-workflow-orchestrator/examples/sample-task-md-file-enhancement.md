<!-- Local adaptation: repository skill references use .agent. -->

# Task: CUSTMAST — Add EMAIL and PHONE Fields

> **Sample task.md** — illustrates Plan Mode output for a **file-only
> enhancement** scenario. Generated from
> `.agent/ibm-i-file-spec/examples/sample-pf-enhancement-spec.md`.
> This file is for documentation only; it is not part of any active run.
>
> **When to use task.md for file-only changes:** strictly speaking, a
> file-only change has just two steps (DDS gen + DDS review) and can be
> handled by Routing Mode. task.md is still useful here when (a) the CR
> touches several related files, (b) review iterations are expected, or
> (c) audit traceability of the gate decision is required. For a one-off
> single-file add-column change, prefer Routing Mode.

## 1. Metadata

- task_id: TASK-2026-0430-CUSTMAST
- entry_layer: file-spec
- exit_layer: dds-review
- mode: file-only-enhancement
- created_by: agent (Plan Mode draft)
- approved_by: (pending)
- created_at: 2026-04-30
- approved_at: (pending)
- status: draft

## 2. Inputs

- file_spec:        ./.agent/ibm-i-file-spec/examples/sample-pf-enhancement-spec.md
- program_spec:     (none — change does not affect program logic)
- existing_source:  <CUSTMAST_DDS_PATH>  (TBD — resolved by §7 Q3; required for delta-first DDS regeneration)
- cr_document:      (none provided — Spec ID CUSTMAST-20260403-02 acts as the change record)
- supplement_sources: []

## 3. Targets

| ID | Type        | Skill                  | Output Path                          | Depends On       |
|----|-------------|------------------------|--------------------------------------|------------------|
| T1 | DDS source  | ibm-i-dds-generator    | ./out/CUSTMAST.PF                    | inputs.file_spec |
| T2 | DDS review  | ibm-i-dds-reviewer     | ./out/CUSTMAST.dds-review.md         | T1               |

Notes:
- No code-generation targets — there is no Program Spec in §2.
- No UT targets — file-only changes are not exercised by the UT plan
  generator without a corresponding program change. The downstream
  programs that read/write CUSTMAST will be regression-tested separately.
- No placeholders in §3 Output Paths (file name `CUSTMAST` is concrete in
  the input file spec).

## 4. Execution Policy

- on_critical_finding:   STOP_AND_REPORT
- on_high_finding:       CONTINUE_WITH_LOG
- on_tbd_in_spec:        CONTINUE_AS_SKELETON
- on_skill_failure:      STOP_AND_REPORT
- max_retries_per_task:  1
- parallel_safe:         []

Parallel safety derivation (per template Parallel Safety Rules):
- Only two targets exist; T2 is gated on T1 (R2). No parallel pairs.

## 5. Gate Definitions

### G1 — after T2 (DDS review)
- block_if: severity == CRITICAL

This is the only gate. Per SKILL.md §Gate Coverage in §5, DDS review
gates fire on CRITICAL severity. There are no UT artifacts in this
plan, so no "UT not gated" clarifier is needed here.

## 6. Execution Log

- [ ] T1 pending
- [ ] T2 pending

## 7. Open Questions

- Q1: Confirm EMAIL length of 60 is sufficient for business needs.
  - origin: file_spec §Open Questions / TBD #1
  - resolution: pending
  - blocking: pending-human-judgment — DDS generator can produce the field with the
    proposed length 60; if business confirms a different length later,
    a follow-up enhancement will be required. Mark as
    `confirmed-defer` to accept length 60.

- Q2: Which programs need to be updated to populate the new fields?
  - origin: file_spec §Open Questions / TBD #2
  - resolution: pending
  - blocking: pending-human-judgment — this question is about **downstream impact**, not
    about the DDS itself. Resolve it by running `ibm-i-impact-analyzer`
    on CUSTMAST consumers in a separate task. Mark as
    `confirmed-defer` to keep this DDS task scoped to the file change.

- Q3: Is the existing CUSTMAST DDS source available for reference (R-file
  layout, existing keywords, EDTCDE/CHKEXP usage)?
  - origin: derived from §2 existing_source TBD
  - resolution: pending
  - **blocking: yes** — DDS generator needs the existing source to
    preserve the layout of the 8 unchanged fields and to position the
    new EMAIL/PHONE fields at the end without disturbing record-format
    compatibility. Without it, the generator may produce a structurally
    correct PF that is still binary-incompatible with existing programs.

## 8. Final Deliverables Manifest

(Empty — populated by Execute Mode at run completion.)
