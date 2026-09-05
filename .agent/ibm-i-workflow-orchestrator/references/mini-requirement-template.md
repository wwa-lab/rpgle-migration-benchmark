# Mini Requirement Template

A lightweight input form for daily enhancement work. Provides enough structured context
to go directly to Program Spec generation — bypassing the full Requirement Normalizer →
Functional Spec → Technical Design chain.

**When to use this template:**
- Enhancement to an existing program (the most common IBM i work)
- Bug fix or error handling change
- Small-to-medium scope change where the business need is already understood
- The developer or BA already knows which program(s) and file(s) are involved

**When NOT to use — use the full chain instead:**
- New program development with no existing reference
- Large scope change affecting multiple programs with unclear boundaries
- Business requirements are ambiguous or contested
- Formal business review / sign-off is required before implementation

---

## Template

Copy and fill in:

```
## Mini Requirement

### 1. Change Description
<1-3 sentences: WHAT needs to change and WHY. Keep it plain and specific.>

### 2. Target Program
- **Program name:** <e.g., CUR93>
- **Program type:** <RPGLE / CLLE>
- **Source format:** <Free / Fixed / Mixed>

### 3. Change Type
<Enhancement / Bug Fix / New Logic Path / Error Handling Change>

### 4. Existing Source
<The current source member being changed. Paste or attach the source.
This is the most important input — without it, the generator cannot produce
safe enhancement code.>

- Program source: <e.g., CUR93.rpgle — paste or reference>

### 5. File Sources (DDS / PF / LF)
<List the file objects the program reads, writes, or updates.
Include DDS source or PF/LF names so the spec can define correct file usage.>

- <file name: purpose, e.g., SSCUST: customer master — read>
- <file name: purpose, e.g., ORDHEDR: order header — update>

### 6. Error / Exception Context (if applicable)
<The error message, exception scenario, or problem being fixed.
Include the actual error text if available. N/A if not a bug fix.>

### 7. Business Rules Affected
<Which business rules are changing? Use BR-xx references if known,
or describe briefly.>

- <BR-xx: brief description of the rule change>
- <or: "New validation: order amount must not exceed credit limit">

### 8. Expected Outcome
<What should happen AFTER the change? Describe the expected behavior
in business terms — not code terms.>

### 9. Supplement Sources (optional)
<Other source members, DDS, or peer programs for reference/style context.
These help the code generator match shop conventions.>

- <e.g., CUR41.rpgle — peer program for naming/style reference>
- <e.g., SSCUSTR.pf — DDS for record format name confirmation>
```

---

## How This Template Feeds the Fast-Path

| Template Field | Consumed By | Maps To |
|----------------|-------------|---------|
| Change Description | Program Spec | Functions, Business Rules |
| Target Program | Program Spec | Spec Header, Programming Language |
| Change Type | Program Spec | Amendment History, tier selection |
| Existing Source | Program Spec + Code Generator | Baseline for enhancement delta |
| File Sources | Program Spec | File Usage, Compile-Oriented Constraints |
| Error / Exception Context | Program Spec | Error Handling |
| Business Rules Affected | Program Spec | Business Rules, Traceability Matrix |
| Expected Outcome | Program Spec | Functions (future behavior) |
| Supplement Sources | Code Generator | Reference Source for naming/style |

---

## Fast-Path Flow

```
Mini Requirement
       ↓
  Program Spec (ibm-i-program-spec)
       ↓
  Spec Review (ibm-i-spec-reviewer) ← recommended gate
       ↓
  Workflow Orchestrator routes to:
       ├──→ Code Generation (ibm-i-code-generator)
       │         ↓
       │    Compile Precheck (ibm-i-compile-precheck)
       │         ↓
       │    Code Review (ibm-i-code-reviewer)
       │         ↓
       │    Pass / Manual Revision
       │
       └──→ UT Plan (ibm-i-ut-plan-generator) ← parallel, optional
                  ↓
             Test Scaffold (ibm-i-test-scaffold) ← compile + mock data + PASS/FAIL verification
```

This flow matches the pilot team's actual workflow. The full chain (Requirement Normalizer →
Functional Spec → Technical Design) remains available for new programs and large-scope work.
