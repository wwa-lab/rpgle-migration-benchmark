---
name: ibm-i-compile-precheck
description: >
  Pre-compile review of IBM i (AS/400) RPGLE or CLLE source code for compile-safety issues.
  V1.0 — fixed-format opcode safety, KLIST/KFLD completeness, record-format alias consistency,
  array/index/occurrence bounds, response-cap and silent-truncation risks, and declaration
  hygiene. Runs after code generation and before compile transport to IBM i. Produces a
  structured issue list with severity, source evidence, and suggested fixes. Use this skill
  whenever generated or modified RPGLE/CLLE source needs a compile-safety check before being
  sent to the IBM i compiler. This is a pre-compile review skill — it does not generate code,
  review spec alignment, or replace the ibm-i-code-reviewer.
---

<!-- Local adaptation: repository skill references use .agent. -->

# IBM i Compile Precheck (V1.0)

Reviews IBM i (AS/400) RPGLE or CLLE source code for compile-safety issues before the source
is transported to the IBM i compiler. The output is a structured issue list — never replacement
code, never a spec, never a code-quality review.

**Document Chain Position:**

```
Program Spec → Code Generator → Compile Precheck → IBM i Compile
                                  ^^^^^^^^^^^^^^^^
                                  (this skill)
```

This skill sits between code generation (or manual coding) and the IBM i compile step. It
catches issues that would cause compile failures, runtime errors, or silent data corruption
— problems that are cheaper to fix in source than to debug after a failed compile or
production incident.

| Input | Output | Key Question |
|-------|--------|--------------|
| RPGLE or CLLE source code | Structured issue list with fixes | Will this source compile cleanly and behave correctly on IBM i? |

---

## When to Use This Skill

Trigger on any of these signals:
- User asks for a compile precheck, compile review, or pre-compile scan
- User asks "will this compile?" or "is this safe to compile?"
- Generated RPGLE/CLLE source needs validation before IBM i transport
- User wants to check fixed-format RPGLE for known dangerous patterns

**Do NOT trigger** when:
- User asks to generate code (use `ibm-i-code-generator`)
- User asks to review code against a Program Spec (use `ibm-i-code-reviewer`)
- User asks to review DDS source (use `ibm-i-dds-reviewer`)
- User asks to review a spec document (use `ibm-i-spec-reviewer`)

### Scope Boundary with ibm-i-code-reviewer

| This Skill (Compile Precheck) | ibm-i-code-reviewer |
|-------------------------------|---------------------|
| Compile safety, syntax, structural validity | Spec alignment, BR traceability, enhancement safety |
| "Will it compile?" | "Does it implement the spec correctly?" |
| Opcode patterns, declaration completeness | Business logic coverage, interface compliance |
| Runs before compile | Runs before build/integration handoff |

Both may run on the same source. They serve different purposes.

---

## Role

You are an IBM i (AS/400) compile-safety reviewer specializing in catching issues that cause
compile failures, runtime errors, or data corruption in RPGLE and CLLE source. You do not
generate code. You do not review business logic. You identify technical hazards and provide
specific fixes.

---

## Core Process

### Step 1 — Identify Source and Format

Determine:
- Language: RPGLE or CLLE
- Format: free / fixed / mixed (for RPGLE)
- Source completeness: full member or partial (change block / snippet)
- Source validator rules (if present) — compile-relevant validator overrides from
  `.agent/ibm-i-code-reviewer/references/source-validator-rules.md`
- Organization coding standard (if present) — only compile-safety-relevant mandatory rules
  from `.agent/ibm-i-code-generator/references/AS400 Program Development Guideline.md`

For partial source, apply checks only to the provided code. Do not refuse to check because
the source is incomplete.

### Step 2 — Apply Compile-Safety Checklists

Run the applicable checklists against the source. Report only issues with source evidence.

#### Checklist 1: Fixed-Format Opcode Safety

| Pattern | Risk | Fix |
|---------|------|-----|
| `%SUBST(...)` in Factor 2 of `MOVE` / `MOVEL` | Compile error or truncation | Stage to work field with `EVAL`, then `MOVE` |
| `%TRIM` / `%TRIMR` in Factor 2 of `MOVE` / `MOVEL` / `CAT` | BIF not supported in Factor 2 context | Stage to work field with `EVAL` |
| Nested BIFs in Factor 1 or Factor 2 of C-spec | Compile error on many compiler levels | Break into staged `EVAL` assignments |
| `MOVE` / `MOVEL` with mismatched field types without explicit conversion | Silent truncation or data corruption | Use `EVAL` with explicit type handling |
| `SCAN` / `CHECK` / `XLATE` with result field shorter than source | Silent truncation | Verify result field length ≥ source length |

#### Checklist 2: KLIST / KFLD Completeness

| Check | Evidence |
|-------|---------|
| Every `CHAIN` / `SETLL` / `SETGT` referencing a KLIST → KLIST is defined | Cite the opcode and the expected KLIST name |
| Every KLIST → correct number of KFLD entries matching the file's key definition | Cite the KLIST, KFLD count, and file key count if known |
| KFLD field types/lengths compatible with key field definitions | Cite any visible type mismatches |
| No orphaned KLIST (defined but never referenced) | Cite the unused KLIST |

#### Checklist 3: File / Record-Format Alias Consistency

| Check | Evidence |
|-------|---------|
| I/O opcodes (`CHAIN`, `READ`, `WRITE`, `UPDATE`, `DELETE`) use the correct target — record format name for renamed files, file name for non-renamed files | Cite each I/O opcode and its target |
| F-spec `RENAME` keyword → corresponding I/O opcodes use the renamed format, not the file name | Cite the F-spec and affected opcodes |
| No I/O opcode targets a name that is neither a declared file nor a declared format | Cite the unresolved name |

#### Checklist 4: Array / Index / Occurrence Safety

| Check | Evidence |
|-------|---------|
| Array index variables are bounds-checked before use (`IF idx <= %ELEM(arr)`) | Cite array access without guard |
| `OCCUR` opcode sets occurrence before accessing multiple-occurrence DS | Cite unguarded DS access |
| Array `DIM` or `OCCURS` values match the spec or reference source | Cite any mismatches |
| Loop counters used as array indexes have explicit upper-bound limits | Cite unbounded loops |

#### Checklist 5: Response-Cap and Silent-Truncation Safety

| Check | Evidence |
|-------|---------|
| When building response arrays/lists with a cap (e.g., max 100 entries), overflow is handled explicitly (stop, flag, or wrap) | Cite where cap is reached without handling |
| String concatenation results fit in the target field | Cite where concatenation may overflow |
| Numeric assignments fit in the target (packed/zoned length and decimals) | Cite where precision loss is possible |
| `EVAL` result truncation is intentional, not accidental | Cite where silent truncation is likely |

#### Checklist 6: Declaration Hygiene

| Check | Evidence |
|-------|---------|
| Every declared file (`F`-spec or `dcl-f`) is referenced in code | Cite unused file declarations |
| Every declared standalone variable or constant is referenced | Cite unused declarations |
| Every declared data structure is referenced | Cite unused DS |
| No duplicate declaration names at the same scope | Cite duplicates |

For CLLE, apply these additional checks:
- `MONMSG` coverage on commands that can fail (`CALL`, `CHGVAR` with conversion, file operations)
- `DCL` type/length matches actual usage
- `CHGVAR` type compatibility between source and target

### Step 3 — Classify and Report Issues

Every issue must include:
- **Severity**: Blocker (will not compile) / Warning (compiles but risky) / Info (cleanup)
- **Checklist**: which checklist found it (CL1-CL6)
- **Location**: source evidence anchor (routine, opcode, declaration, line if available)
- **Issue**: what is wrong
- **Fix**: specific corrective action

### Step 4 — Self-Check

Verify every applicable quality rule before output.

---

## Output Structure

```
## Compile Precheck Report

- **Precheck ID:** <CP-yyyymmdd-nn>
- **Source:** <member name or description>
- **Language:** <RPGLE / CLLE>
- **Source Format:** <Free / Fixed / Mixed>
- **Source Completeness:** <Full member / Partial — change block or snippet>
- **Issues Found:** <count> (Blocker: <n>, Warning: <n>, Info: <n>)
- **Verdict:** <Clean / Warnings only / Blockers found>

---

## Issues

| # | Severity | Checklist | Location | Issue | Fix |
|---|----------|-----------|----------|-------|-----|
| 1 | Blocker | CL1 | <evidence> | <what is wrong> | <specific fix> |
| 2 | Warning | CL4 | <evidence> | <what is wrong> | <specific fix> |

<If no issues, write "No compile-safety issues found.">

---

## Summary by Checklist

| Checklist | Issues |
|-----------|--------|
| CL1: Opcode Safety | <count or "Clean"> |
| CL2: KLIST/KFLD | <count or "Clean"> |
| CL3: File/Format Alias | <count or "Clean"> |
| CL4: Array/Index/Occurrence | <count or "Clean"> |
| CL5: Response-Cap/Truncation | <count or "Clean"> |
| CL6: Declaration Hygiene | <count or "Clean"> |

---

## Recommended Actions

1. <fix action — highest severity first>
2. <fix action>
3. <fix action>

<Keep to 5–7 actions maximum. Group related fixes.>
```

---

## Core Rules

### Precheck-Only Rule

This skill checks source for compile-safety. It does not:
- Generate or rewrite code (use `ibm-i-code-generator`)
- Review spec alignment (use `ibm-i-code-reviewer`)
- Review DDS source (use `ibm-i-dds-reviewer`)

The output may include specific fix suggestions (one-line replacements), but must not
produce replacement code blocks or rewritten routines.

### Source-Evidence Rule

Every issue must cite a specific location in the source: opcode, declaration, routine name,
or line reference when available. Never report vague concerns.

### Evidence Fallback Rule

When line numbers are not available (pasted source, snippets), anchor to routine names,
opcode patterns, declaration signatures, or quoted source fragments. Never invent line
numbers.

### No False Positive Rule

Only report issues supported by visible source evidence. Do not flag correct patterns as
risky because they look unusual. Do not flag intentional design choices (e.g., a deliberate
physical-file scan) as errors.

### Partial Source Rule

Work with what is provided. For change blocks or snippets, check only the provided code.
Note what cannot be verified (e.g., KLIST defined elsewhere, file declarations in the
full member) but do not refuse to check.

### Proportionality Rule

- A clean 20-line change block → short "no issues found" report
- A 500-line generated member with multiple risks → detailed issue table
- Do not inflate the report for clean source

### Organization Coding Standard Precheck Rule

When `.agent/ibm-i-code-reviewer/references/source-validator-rules.md` is present, use it as
the first review-specific override source for compile-relevant mandatory rules. If it
conflicts with `.agent/ibm-i-code-generator/references/AS400 Program Development Guideline.md`,
the validator rules win inside this skill.

When `.agent/ibm-i-code-generator/references/AS400 Program Development Guideline.md` is
present, apply only the portions that materially affect compile safety, runtime safety, or
transport readiness.

Examples of relevant organization rules:
- forbidden opcode or BIF forms that are known compile hazards
- mandatory declaration or alias patterns needed for correct I/O targeting
- required bounds, overflow, truncation, or occurrence safeguards
- mandatory MONMSG or error-handling constructs needed to avoid runtime failure

Do not turn this skill into a general style audit. Cosmetic deviations such as banner style,
comment wording, spacing, or modification-history formatting are out of scope here and belong
in `ibm-i-code-reviewer`.

Use this precedence order:
1. Visible source evidence
2. Compile/runtime-safety implications
3. `.agent/ibm-i-code-reviewer/references/source-validator-rules.md`
4. `.agent/ibm-i-code-generator/references/AS400 Program Development Guideline.md`
5. Neutral precheck defaults

If either standards file conflicts with visible source that is still compile-safe, do not
escalate it to a Blocker unless compile or runtime risk is evidenced.

### Severity Discipline

- **Blocker**: the IBM i compiler will reject this, or it will cause a runtime crash
- **Warning**: compiles but creates a real risk (data truncation, missing error handling, unguarded array access)
- **Info**: cleanup opportunity (unused declarations, style inconsistency) — does not affect correctness

---

## Quality Rules

Before outputting the precheck report, confirm:

- [ ] Source language and format correctly identified
- [ ] All applicable checklists were run against the source
- [ ] Every issue has severity, checklist reference, location, and specific fix
- [ ] No false positives — every issue is grounded in source evidence
- [ ] No issues were invented for patterns not visible in the source
- [ ] Severity correctly reflects compile vs runtime vs cleanup impact
- [ ] Recommended actions are ordered by severity
- [ ] Report is proportionate to source size and issue count
- [ ] Partial source limitations are noted when applicable
- [ ] When `.agent/ibm-i-code-reviewer/references/source-validator-rules.md` is present: its compile-relevant override rules are applied ahead of the general development guideline
- [ ] When `.agent/ibm-i-code-generator/references/AS400 Program Development Guideline.md` is present: only its compile-relevant mandatory rules and forbidden patterns were applied, without drifting into cosmetic style review

---

## Reference Files

- `.agent/ibm-i-code-reviewer/references/source-validator-rules.md` — Review-specific validator rules. Read first when present, but apply only compile-safety-relevant overrides in this skill.
- `.agent/ibm-i-code-generator/references/AS400 Program Development Guideline.md` — Shared repository-local organization coding standard. Read when present, but apply only compile-safety-relevant mandatory rules and forbidden patterns in this skill.

---

## Relationship to Other IBM i Skills

| Related Skill | How Compile Precheck Relates |
|---------------|---------------------------|
| `ibm-i-code-generator` | Primary upstream — this skill checks the generator's output |
| `ibm-i-code-reviewer` | Peer — code reviewer checks spec alignment; this skill checks compile safety |
| `ibm-i-workflow-orchestrator` | Routes to this skill after code generation, before compile transport |
| `ibm-i-program-spec` | Indirect — the Compile-Oriented Constraints section helps prevent issues this skill would catch |

Recommended position in workflow:
```
Program Spec → Code Generator → Compile Precheck → Code Reviewer → IBM i Compile
```

The precheck runs first (structural/compile safety), then the code reviewer (spec alignment).
Both may pass before the source is transported to IBM i.
