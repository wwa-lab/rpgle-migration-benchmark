# task.md Execution Protocol (V1.0)

This document defines how `ibm-i-workflow-orchestrator` reads, executes, and
mutates a `task.md` file in **Execute Mode**. It is the operational complement
to `task-md-template.md`.

The orchestrator must follow this protocol exactly. Skill behavior must not
diverge from these rules without an explicit task.md override.

---

## 1. Preconditions Before Execute Mode Starts

Before any target executes, verify:

| Check | Required State |
|-------|----------------|
| `§1 status` | `approved` (refuse to run on `draft`) |
| `§1 approved_by` | non-empty |
| `§2 program_spec` | path exists and readable |
| `§2 file_spec` | exists if any T-row references `inputs.file_spec` |
| `§7 Open Questions` | every item has resolution ≠ `pending` (must be resolved, deferred, or block) |
| Any field with `<...>` placeholder | no `<...>` placeholder remains anywhere in the task.md (covers §2 paths, §3 Output Path / Type, and any other field). Every placeholder must have been replaced with a concrete value before approval. |
| `§2 technical_design` | path exists and readable when §1 `mode: td-driven-multi-spec-batch` |
| §7 derived-TBD merge | when §1 `mode: td-driven-multi-spec-batch` and resuming from `awaiting-spec-approval` → `running`: §7 must contain at least one entry whose `origin:` points to a Layer-A-produced spec (proof that the merge step in Execution Algorithm step 5 ran). If no Layer-A spec yielded any TBD, the agent must add a single `origin:` annotation noting that fact. |
| §7 `pending-human-judgment` cleared | At every state transition that hands control to Execute Mode (`draft` → `approved`, `awaiting-spec-approval` → `running`), no §7 entry may have `blocking: pending-human-judgment`. The human must classify each such entry as `yes` or `no` first. This applies to TBDs Plan Mode derived from the input spec/TD as well as TBDs Execute Mode derived from Layer A specs. |

If any check fails, do not start execution. Output a block message that lists, for each failed check, the precise location: line number and field name. For placeholder check failures, emit one entry per occurrence (a single placeholder name appearing in 6 fields produces 6 entries) so the human can fix every occurrence in one pass. Do not mutate the task.md.

---

## 2. Execution Algorithm

The orchestrator runs a topological scheduler over §3 Targets:

```
1. Mark §1 status = running.
2. Build dependency graph from the Depends On column.
3. Compute a topological order; honor §4 parallel_safe pairs.
4. For each ready target T:
     a. Append "[~] T running @ HH:MM" to §6 Execution Log.
     b. Invoke the skill named in T.Skill with:
          - inputs: T.Depends On resolved to artifact paths
          - output: T.Output Path — pass as `output_path` argument
            when the skill accepts it (e.g., `ibm-i-program-spec`
            TD-aware mode). When the skill does not accept an
            output path, the agent must `cp` or `mv` the skill's
            produced artifact to T.Output Path immediately after
            the skill returns, before writing the `[x] done` log line.
     c. On skill completion:
          - On success → append "[x] T done @ HH:MM → <path>"
          - On error  → append "[!] T blocked @ HH:MM — <error>"
                       and apply §4 on_skill_failure policy
     d. If T has an associated gate in §5, evaluate it now (see §3 below).
5. **(td-driven mode only)** After every Layer A target reaches
   `[x] done`:
     a. **Merge derived TBDs into §7.** For each spec produced by
        Layer A, parse its Open Questions / TBD section (find it
        using the regex anchor `^## Open Questions / TBD$` —
        program-spec, file-spec, functional-spec, and technical-design
        all use this exact header) and append
        every entry to §7 with `origin:` set to the source spec path
        and section number. Use a fresh Q-id (Qn+1, Qn+2, …) — never
        renumber existing entries. If a Layer-A spec has no TBDs, add
        a single placeholder line with `origin: <spec-path> (no TBDs
        Each newly-merged entry is written with `blocking:
        pending-human-judgment` (Execute Mode cannot infer severity
        from the spec's plain question text). The human resolves
        each to `yes` or `no` before releasing the Spec Approval Gate.
        derived)` so the merge step is visibly recorded.
     b. Set §1 status = `awaiting-spec-approval`.
     c. Append `[!] G_SpecApproval halted @ HH:MM — awaiting specs_approved_by` to §6.
     d. Halt. Do not start any Layer B target.
     e. Wait. When the human writes `specs_approved_by: <name>` and
        sets §1 status = `running`, resume from the first ready Layer B target.
6. After all targets complete (or on terminal block):
     - Set §1 status = done | blocked | failed
     - Fill in §8 Final Deliverables Manifest
```

The scheduler must update §6 in real time. Do not batch updates at the end.

---

## 3. Gate Evaluation

After a target completes, find every gate in §5 whose target ID matches.
For each, evaluate the `block_if` predicate against the just-produced artifact.

### Severity extraction by skill

| Skill | Where to read severity |
|-------|------------------------|
| `ibm-i-compile-precheck` | top-level "Severity" field in the precheck markdown |
| `ibm-i-code-reviewer` | top-level "Verdict" + per-finding "Severity" (CRITICAL/HIGH/MEDIUM/LOW) |
| `ibm-i-dds-reviewer` | top-level "Verdict" + per-finding "Severity" |
| `ibm-i-spec-reviewer` | top-level "Readiness" + per-finding "Severity" |

### Predicate evaluation

`severity == CRITICAL` is true if **any** finding in the artifact has
Severity = CRITICAL. Do not require the verdict to be "Not Ready" — a single
Critical finding triggers the gate even if overall verdict is more lenient.

`br_coverage_gap == true` is true if the Code Reviewer reports any BR-xx in
the Program Spec that is not covered by generated code.

### On block

If a gate blocks:

1. Append `[!] <Tn> blocked @ HH:MM — gate <Gn>: <reason>` to §6.
2. Set §1 status = `blocked`.
3. Halt execution. Do not start downstream targets.
4. Output a single human-readable block report containing:
   - which gate fired
   - the offending findings (quoted, with file/line)
   - suggested resolution path (patch upstream / regenerate / clarify / waive)
5. Wait for human resolution. Do not auto-retry.

When the human resumes, they may:
- Edit the upstream artifact and re-approve task.md → re-run from the blocked target.
- Add a `waiver` line to the gate in §5 (e.g., `waiver: <reason> — approved by <name>`)
  and re-approve → re-run treats the gate as passed.

---

## 4. TBD Handling

`on_tbd_in_spec: CONTINUE_AS_SKELETON` (default) means:

- If the Program Spec has unresolved TBDs at execution time, the code
  generator is invoked in Skeleton mode for the **entire program**, not
  just for the steps that touch the TBD. This matches the code-generator
  skill's actual behavior — it does not support per-step partial
  skeleton output. The whole member is downgraded; well-defined steps
  still produce skeleton-shaped code with `TODO` markers tagged to the
  relevant Open Question Q-id.
- This is logged in §6 as `[x] T1 done @ HH:MM → <path> (skeleton mode)`.
- The Code Reviewer is still run, but BR-coverage gaps caused by TBDs are
  reported as MEDIUM (not CRITICAL) and do not block.

**Plan Mode constraint** (relevant when describing fallbacks in §7 Open
Questions): do not write "skeleton mode for Step N–M" or any phrasing
that implies partial skeleton output. The only honest description is
"the whole program is generated in Skeleton mode" (with TODO markers
concentrated where the TBD lives).

If §4 has `on_tbd_in_spec: BLOCK`, the orchestrator must halt before T1
with a list of every TBD location.
---

## 5. Parallel Execution

The orchestrator may execute pairs listed in §4 `parallel_safe` concurrently
**only if** both targets are independently ready (all Depends On satisfied).

Determining which pairs are parallel-safe is the responsibility of
Plan Mode, which computes them per task.md according to the rules in
`task-md-template.md` §Parallel Safety Rules. Execute Mode reads §4
`parallel_safe` as-is and does not recompute it.

The orchestrator must never parallelize:
- A target and its own gate (e.g., T1 and T2 are sequential)
- A target and any of its transitive dependents

---

## 6. Idempotency and Resume

Execute Mode must be safely re-runnable on a partially-completed task.md:

- Read §6 Execution Log first.
- Targets marked `[x] done` are skipped (their output paths are reused).
- Targets marked `[!] blocked` are re-attempted only after the human has
  resolved the blocker (status = approved again).
- Targets marked `[ ] pending` or `[~] running` (stale) are restarted.

If output files exist on disk but §6 says pending, log a warning and overwrite

**TD-driven resume semantics.** When §1 status = `awaiting-spec-approval`:

- Layer A is fully complete; do not regenerate any A-target.
- Layer B has not started; all B-targets remain `[ ] pending`.
- Resume requires the human to (a) fill `§1 specs_approved_by` and
  (b) set §1 status back to `running`. Without both, Execute Mode
  must report "still awaiting spec approval" and exit without action.
unless `--no-overwrite` is set.

---

## 7. Final Manifest

When the run finishes (status = done), the orchestrator fills in §8:

- For each completed target, compute SHA-256 of the output and record the
  first 12 hex chars. For directory outputs (test-scaffold), hash a sorted
  concatenation of file hashes inside.
- Reviewer Verdict reflects the worst severity found.
- Status mirrors §6 (done / skipped).

The manifest is the canonical handoff to downstream consumers (build, SIT,
audit). Do not omit it on successful runs.

---

## 8. What Execute Mode Must Not Do

- Must not modify §1 metadata except `status`, `approved_at` (never), and append-only fields.
- Must not modify §2, §3, §4, §5, §7 — these are the human-approved contract.
- Must not silently skip a gate.
- Must not generate any artifact that is not listed as a target in §3.
- Must not invoke any skill outside the family defined in `SKILL.md` Routing Reference.
- Must not call `ibm-i-program-spec`, `ibm-i-functional-spec`, `ibm-i-technical-design`,
  `ibm-i-requirement-normalizer`, or any upstream spec skill — Execute Mode
  starts at or after Program Spec by design.

---

## 9. Logging Format Reference

All §6 entries use UTC HH:MM (24-hour). Each entry is one line.

| Marker | Meaning | When to write |
|--------|---------|----------------|
| `[ ]` | pending | Plan Mode initial state |
| `[~]` | running | Just before invoking the skill |
| `[x]` | done | After the skill returned successfully |
| `[!]` | blocked | Skill error or gate fired |
| `[s]` | skipped | Target marked not applicable (with reason) |

Examples:

```
- [x] T1 done @ 14:23 → ./out/PGM001.RPGLE
- [x] T2 done @ 14:24 → ./out/PGM001.precheck.md
- [!] T3 blocked @ 14:26 — gate G2: BR-05 not covered by generated code
```

This log section is the primary artifact a human inspects when reviewing a
batched run. Keep it terse, factual, and parseable.
