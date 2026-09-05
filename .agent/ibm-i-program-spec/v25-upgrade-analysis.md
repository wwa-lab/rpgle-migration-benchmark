# IBM i Program Spec Skill — V2.0 → V2.5 Upgrade Analysis

---

## SECTION 1 — Critical Design Issues in V2.0

### Issue 1: One-Size-Fits-All Kills Adoption

V2.0 has 25 mandatory sections. A developer changing a single validation threshold
("credit limit from $5K to $10K") must produce — and a reviewer must read — a full
Data Contract, Interface Contract, Traceability Matrix, Caller Context, and 15 other
sections. Most will contain `N/A` or repeat existing documentation. This is the #1
barrier to team adoption: the cost of the spec exceeds the cost of the change.

**Impact**: Teams skip the spec for small changes. The SDD pipeline has a gap at the
bottom — the most frequent change type is undocumented.

### Issue 2: No Concept of "Change" vs "New"

V2.0 treats every spec as if documenting a program from scratch. When modifying an
existing program, there is no way to distinguish new logic from existing logic, new
fields from existing fields, or new BRs from unchanged BRs. The developer reading the
spec cannot answer: "What exactly is changing?"

**Impact**: Developers re-read the entire spec to find the delta. Test generators
cannot distinguish "new tests needed" from "existing tests unchanged." Impact analyzers
cannot isolate the change footprint.

### Issue 3: CONDITIONAL Sections Forced as REQUIRED

V2.0's completeness rule says: "Every section must appear. If empty, write N/A." This
means a CLLE program that uses no files still has `## File Usage → N/A`, a program with
no external calls still has `## External Program Calls → N/A`, and a program with no data
queues still has `## Data Queue → N/A`. These N/A sections are noise — they consume
attention without conveying information.

**Impact**: Signal-to-noise ratio degrades. Reviewers learn to skim past N/A sections,
which means they also skim past sections that matter.

### Issue 4: No Level Indicator for Downstream Tools

V2.0 has no machine-readable flag indicating spec complexity. A test generator processing
100 specs cannot distinguish a trivial constant change from a multi-file transaction
without parsing every section. There is no way to batch-triage specs by size/risk.

**Impact**: Downstream automation treats all specs equally. A Lite change gets the same
test generation overhead as a new program. Pipeline efficiency suffers.

### Issue 5: Spec Summary Lacks Change Dimensionality

V2.0's Spec Summary counts totals (Total BRs: 3, Total Steps: 12) but does not decompose
them into new vs. modified. For a change spec, "Total Business Rules: 5" could mean
5 new rules, 1 new + 4 existing, or 5 modified. The summary is useless for change scoping.

**Impact**: Tech leads cannot triage spec reviews from the summary alone. Automated
validators cannot flag "change spec with zero new elements" (probably an error).

---

## SECTION 2 — Patch Design

### Patch 1: Spec Tiering System

**ADD** — New Spec Level decision table in Core Process Step 1:

```
Then determine the **Spec Level** using this decision table:

| Condition | Level |
|-----------|-------|
| New program (no existing code) | L3 (Full) |
| Change adds new file access, external call, or data queue/area | L3 (Full) |
| Change adds new business rules or modifies logic flow | L2 (Standard) |
| Change adds new parameter or modifies interface contract | L2 (Standard) |
| Change modifies a single field, flag, constant, or threshold | L1 (Lite) |
| Change is cosmetic (message text, display label) | L1 (Lite) |
| User explicitly requests a specific level | Use requested level |
| Unclear | Default to L2 (Standard), note in Open Questions |
```

**ADD** — Section Inclusion Table controlling which sections appear at each level:

```
| Section | L1 (Lite) | L2 (Standard) | L3 (Full) |
|---------|-----------|---------------|-----------|
| Spec Header | REQUIRED | REQUIRED | REQUIRED |
| Amendment History | REQUIRED | REQUIRED | REQUIRED |
| Caller Context | OPTIONAL | CONDITIONAL | REQUIRED |
| Functions | OPTIONAL | REQUIRED | REQUIRED |
| Business Rules | REQUIRED | REQUIRED | REQUIRED |
| Interface Contract | CONDITIONAL | REQUIRED | REQUIRED |
| Data Contract | OMIT | CONDITIONAL | REQUIRED |
| File Usage | CONDITIONAL | REQUIRED | REQUIRED |
| Data Queue | CONDITIONAL | CONDITIONAL | REQUIRED |
| Data Area | CONDITIONAL | CONDITIONAL | REQUIRED |
| External Data Structure | OMIT | CONDITIONAL | REQUIRED |
| Internal Data Structure | OMIT | CONDITIONAL | REQUIRED |
| External Program Calls | CONDITIONAL | CONDITIONAL | REQUIRED |
| External Subroutines | OMIT | CONDITIONAL | REQUIRED |
| Standard Subroutines | OMIT | CONDITIONAL | REQUIRED |
| Constants | CONDITIONAL | CONDITIONAL | REQUIRED |
| Main Logic | REQUIRED | REQUIRED | REQUIRED |
| File Output / Update | CONDITIONAL | REQUIRED | REQUIRED |
| Error Handling | REQUIRED | REQUIRED | REQUIRED |
| Traceability Matrix | OMIT | REQUIRED | REQUIRED |
| Processing Considerations | OPTIONAL | CONDITIONAL | REQUIRED |
| Programming Language | REQUIRED | REQUIRED | REQUIRED |
| Amend Data Structure | OPTIONAL | OPTIONAL | REQUIRED |
| Open Questions | REQUIRED | REQUIRED | REQUIRED |
| Spec Summary | REQUIRED | REQUIRED | REQUIRED |
```

**MODIFY** — Completeness rule:

Old: "Every section in the output structure must appear. If a section has no content, write N/A."

New: "Include sections per the Section Inclusion Table for the determined Spec Level. For REQUIRED sections with no content, write N/A. For CONDITIONAL sections that are irrelevant to the change, omit entirely. For OMIT sections, do not include."

---

### Patch 2: Change Type and Tagging System

**ADD** — New fields in Spec Header:

```
- **Spec Level:** <L1 Lite | L2 Standard | L3 Full>
- **Change Type:** <New Program | Change to Existing>
```

**ADD** — Change tagging rules for Business Rules, Data Contract, and Main Logic:

```
For change specs (any level), tag elements to distinguish change scope:
- (NEW) — did not exist before
- (MODIFIED) — existed, being changed
- (EXISTING — context only) — unchanged, shown for developer context
- (EXISTING — unchanged) — same, used in Data Contract for fields
```

**MODIFY** — Spec Summary:

Old:
```
- **Total Business Rules:** <count>
- **Total Main Logic Steps:** <count>
```

New:
```
- **Spec Level:** <L1 / L2 / L3>
- **Change Type:** <New Program / Change to Existing>
- **Total Business Rules:** <count> (<new> new, <modified> modified)
- **Total Main Logic Steps:** <count> (<new> new, <modified> modified)
```

---

### Patch 3: Quality Rules Split by Level

**MODIFY** — Quality Rules section:

Old: Single flat checklist of 20 items, all mandatory.

New: Three-tier checklist:

```
**All levels (L1, L2, L3):**
- [ ] Spec Header includes Spec Level, Change Type, and Spec ID
- [ ] Business Rules exist with BR-xx numbering
- [ ] Every conditional step references a BR-xx
- [ ] Main Logic is step-based
- [ ] No invented system objects
- [ ] All unknowns marked TBD
- [ ] Error Handling includes 4 mandatory categories
- [ ] Open Questions lists every TBD
- [ ] Spec Summary counts are accurate
- [ ] Section Inclusion Table was followed

**L2 and L3 only:**
- [ ] Functions describe WHAT only
- [ ] Data Contract lists every field (L2: if change introduces fields)
- [ ] Interface Contract complete with type, length, valid values
- [ ] Traceability Matrix includes every BR-xx
- [ ] File Usage includes key fields

**L3 only:**
- [ ] Caller Context populated or TBD
- [ ] External Program Calls include params and return
- [ ] All REQUIRED sections present

**Change specs (any level):**
- [ ] BRs tagged (NEW) / (MODIFIED) / (EXISTING)
- [ ] Logic steps tagged (NEW) / (MODIFIED) / (EXISTING)
- [ ] Data Contract fields tagged (L2/L3)
- [ ] Summary includes new/modified counts
```

---

### Patch 4: CONDITIONAL Section Behavior

**ADD** — Rule for CONDITIONAL sections:

```
CONDITIONAL sections must appear IF the change touches the area they cover.
If irrelevant, omit the section entirely — do not write N/A.

The distinction is important:
- N/A = "I checked, and this section has no content" (REQUIRED sections)
- Omission = "This section is out of scope for this change" (CONDITIONAL sections)

This reduces noise in L1 and L2 specs while preserving completeness in L3 specs.
```

---

### Patch 5: New Reference File — Tier Guide

**ADD** — `references/tier-guide.md` containing:
- Level definitions (L1, L2, L3) with typical change examples
- Decision examples table (requirement → level → reasoning)
- Change tagging rules with examples
- Completeness strategy explanation

This file is the authoritative reference for spec level selection. The SKILL.md contains
the decision table; the tier-guide contains the rationale and edge cases.

---

## SECTION 3 — System Evolution

### 1. Spec Reviewer Skill (Build First)

**What it does**: Takes a V2.5 spec and produces a structured review report. Validates:
- Section Inclusion Table compliance (right sections for the Spec Level)
- BR-xx completeness in Traceability Matrix (L2/L3)
- Return codes in Error Handling match Return Code Definition
- Data Contract step references are valid (L2/L3)
- Change tags present for change specs
- Spec Summary counts match actual content
- No hallucinated objects (cross-reference: fields in Main Logic must appear in Data Contract)

**Output format**: Structured review report with pass/fail per rule, severity ratings
(Critical / Warning / Info), and a one-line verdict (Approved / Needs Revision).

**How it connects**: Reads the Spec Header to determine level. Applies level-appropriate
rules. Can run automatically after the generator — a "spec lint" step. Findings loop back
to the generator for revision.

**Why it matters**: The generator's self-check catches most issues, but a separate reviewer
catches what the generator misses — the same reason code review exists. The reviewer also
validates consistency that the generator cannot check (e.g., "does the Data Contract match
the Main Logic?"). Without this, spec quality depends entirely on human review.

**Downstream compatibility notes**: The Spec Level field in the header tells the reviewer
which rules to apply. The Change Type field tells it whether to check for (NEW)/(MODIFIED)
tags. The structured table format in every section enables programmatic validation.

---

### 2. Test Case Generator Skill (Build Second)

**What it does**: Takes a V2.5 spec and generates structured test cases.

For each spec level:
- **L1**: Generate tests for (MODIFIED) and (NEW) BRs only. Typically 2–4 test cases.
- **L2**: Generate tests for all BRs in Traceability Matrix. Each BR → 1 positive test
  (happy path through Logic Steps) + 1 negative test (trigger Error Handling Row).
  Each return code → 1 validation test.
- **L3**: Full test suite. BRs + return codes + boundary tests from Interface Contract
  Valid Values + field-level tests from Data Contract.

**Output format**: Structured test case document:

```
| Test ID | BR/Source | Type | Preconditions | Input | Expected Output | Expected Return |
```

**How it connects**: Reads:
- Business Rules → test objectives
- Traceability Matrix → which Logic Steps to exercise, which Error Handling to trigger
- Interface Contract → parameter boundaries and return code expectations
- Data Contract → field-level verification points
- Spec Level → test depth (L1 = focused, L3 = comprehensive)

**Why it matters**: Manual test writing is the slowest part of the IBM i development cycle.
The V2.5 spec's structured tables make mechanical test derivation possible — the generator
does not need to "understand" the spec, it reads table rows and produces test rows.

---

### 3. Impact Analyzer Skill (Build Third)

**What it does**: Given a proposed change description, scans a set of V2.5 specs and
identifies which programs, steps, error handling rows, and test cases are affected.

**Input**: Change description + collection of V2.5 specs (could be a directory of .md files).

**Analysis dimensions**:
- **File impact**: "Field X in ORDHDRPF is being added" → scan all specs' File Usage and
  Data Contract for ORDHDRPF → list affected programs and steps.
- **Interface impact**: "Program ORDCONF is adding a new parameter" → scan all specs'
  External Program Calls for ORDCONF → list callers that must be updated.
- **BR impact**: "Business rule for credit limit is changing" → scan all specs' Business
  Rules for credit-related rules → list affected logic steps via Traceability Matrix.
- **Upstream impact**: Use Caller Context to trace the call chain upward.

**Output format**: Impact report:

```
| Spec ID | Program | Affected Section | Affected Element | Impact Type | Severity |
```

**How it connects**: Reads:
- File Usage (key fields) → file-level impact
- Data Contract (field → step mapping) → field-level impact
- External Program Calls (params, return) → interface-level impact
- Caller Context → upstream call chain
- Spec Level → helps prioritize (L3 specs represent higher-risk programs)

**Why it matters**: IBM i systems have deep, decades-old dependency chains. A single file
change can cascade across 50 programs. Without automated impact analysis, teams rely on
tribal knowledge — which erodes as senior developers retire. The V2.5 spec's structured
tables make mechanical impact tracing possible.

---

### 4. Code Skeleton Generator Skill (Build Fourth)

**What it does**: Takes a V2.5 spec and generates an RPGLE or CLLE code skeleton.

For RPGLE:
- File declarations from File Usage (file name, key, I/O type)
- Data structure shells from External/Internal DS
- Parameter list from Interface Contract
- Constant definitions from Constants
- Procedure shell with step comments from Main Logic
- *PSSR shell from Standard Subroutines / Error Handling

For CLLE:
- DCL statements from Interface Contract parameters
- DCLF from File Usage (if display files)
- MONMSG blocks from Error Handling
- Procedure shell with step comments

**Output format**: Source file (.rpgle or .clle) with structured comments marking where
the developer fills in logic:

```rpg
// Step 3: IF P_ORDNBR is blank → set P_RTNCDE = C_FAILURE → return. (BR-01)
// TODO: Implement BR-01 validation
```

**How it connects**: Reads:
- Spec Header → program name, language
- Interface Contract → parameter declarations
- File Usage → file declarations with key fields
- Constants → named constant definitions
- Data Contract → data structure subfield declarations
- Main Logic → step-by-step comments in the procedure body
- Error Handling → *PSSR / MONMSG scaffolding

**Why it matters**: This closes the loop from requirement to code. The skeleton is not
complete code — it is scaffolding. But because it is generated from the spec, it is
guaranteed to match the spec's structure. The developer fills in logic between comments
guided by the Main Logic steps, and the skeleton already has the right files, parameters,
and error handling in place.

For change specs (L1/L2): the skeleton contains only the (NEW) and (MODIFIED) elements,
with (EXISTING) context comments showing where the changes fit in the existing code.

---

### Pipeline Summary (V2.5)

```
Business Requirement
       │
       ▼
┌─────────────────────────┐
│  Spec Generator (V2.5)  │──→ Determines L1/L2/L3
│  Tiered output          │──→ Change tagging (NEW/MODIFIED/EXISTING)
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│   Spec Reviewer         │──→ Level-aware validation
│   (automated lint)      │──→ Feedback loop to generator
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Test Case Generator    │──→ L1: focused tests (2-4 cases)
│  (level-aware depth)    │──→ L3: comprehensive suite
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Impact Analyzer        │──→ Cross-spec dependency scan
│  (multi-spec)           │──→ File, interface, BR, upstream impact
└────────────┬────────────┘
             │
             ▼
┌─────────────────────────┐
│  Code Skeleton Generator│──→ RPGLE/CLLE scaffolding
│  (change-aware)         │──→ NEW/MODIFIED elements only for change specs
└────────────┬────────────┘
             │
             ▼
    Developer fills in logic
             │
             ▼
    Tests run against implementation
```

Each downstream skill reads the Spec Level from the header and adjusts its behavior
accordingly. L1 specs produce lighter outputs. L3 specs produce comprehensive outputs.
The tiering propagates through the entire pipeline.
