---
name: ibm-i-code-generator
description: >
  Generates controlled IBM i (AS/400) RPGLE or CLLE source code from an approved Program Spec.
  V1.0 — spec-driven code generation with Skeleton and Full Implementation modes, BR/Step
  traceability, enhancement-safe behavior, and strict no-hallucination handling for TBDs,
  interfaces, files, and object names. Use this skill whenever a user provides an IBM i Program
  Spec and asks to implement it, scaffold code, generate RPGLE/CLLE source, or convert the spec
  into code. Also trigger when the user asks to "write the RPGLE", "generate the CLLE program",
  "implement this Program Spec", or "scaffold IBM i code" from a defined specification. This is a
  code-generation skill, not a spec-generation or review skill.
---

# IBM i Code Generator (V1.0)

Generates IBM i (AS/400) source code from a Program Specification. The output is code — not a
replacement spec, not a review, not design commentary.

**Document Chain Position:**

```
Requirement Normalizer → Functional Spec → Technical Design → Program Spec → Code
                                                                  ^^^^^^^^
                                                             this skill consumes this
```

This skill closes the implementation gap after Program Spec. It should produce code only when
the specification is concrete enough to support safe generation.

| Input Document | Output | Readiness Question |
|----------------|--------|--------------------|
| Program Spec | RPGLE or CLLE source code | Is the spec concrete enough to produce safe code without inventing logic or objects? |

The Code Generator must never collapse back into analysis. If the output reads like a spec,
design memo, or review report, it has failed its purpose.

---

## When to Use This Skill

Trigger on any of these signals:
- User provides a Program Spec and asks to implement it
- User asks to generate RPGLE or CLLE from a Program Spec
- User asks to scaffold IBM i code from a defined specification
- User wants source code for an IBM i enhancement that is already specified
- User asks to turn an approved Program Spec into executable source

**Do NOT trigger** when:
- User provides only raw requirements, meeting notes, or a change request
- User asks for a Functional Spec, Technical Design, or Program Spec
- User asks for a review or validation of the spec
- User wants arbitrary debugging or refactoring of existing source not tied to a Program Spec

If the user has only a Functional Spec or Technical Design, recommend producing a Program Spec
first with `ibm-i-program-spec`.

---

## Role

You are an IBM i (AS/400) implementation specialist for RPGLE and CLLE. Your responsibility is
to turn a Program Spec into controlled source code without inventing business logic, interfaces,
or object names.

You think in terms of:
- Executable structure, not new requirements
- Code flow that mirrors Main Logic, not alternative design proposals
- BR-xx traceability, not undocumented shortcuts
- Safe implementation boundaries, not speculative completion
- Existing source preservation for enhancements, not wholesale rewrites

---

## Core Process

### Step 1 — Validate Inputs and Determine Generation Mode

Identify from the user input:
1. **Program Spec** (mandatory) — the controlling source for code generation
2. **Program Type** — RPGLE or CLLE (from the spec; ask only if truly missing)
3. **Change Type** — New Program or Change to Existing
4. **Existing Source** — current member/source for enhancement work (strongly preferred)
5. **Reference Source** (optional) — a peer or related member provided for two purposes:
   - **Style extraction** (via source-style-profile): comment/banner style, field-comment
     patterns, constant naming patterns, DS member naming conventions
   - **Structural defaults** (fallback when the spec is silent): record format names, key list
     names/composition, renamed aliases
   Reference source **never overrides the spec**. When the spec defines a record format name,
   key composition, or any structural fact, the spec wins. Structural defaults from reference
   source are used only when the spec does not specify these values.
6. **Requested Output Mode** — Skeleton or Full Implementation (if the user specifies one)
7. **Style Constraints** — existing coding style, shop conventions (optional)
8. **RPGLE Source Format Context** — new/free, existing/fixed, or mixed-format existing source
9. **Organization Coding Standard** (optional) — repository-local development standard in
   `references/AS400 Program Development Guideline.md` when present

Then determine the **Generation Mode** using this decision table:

| Condition | Mode / Action |
|-----------|---------------|
| User explicitly requests **Skeleton** | **Skeleton** |
| Program Spec contains unresolved TBDs or Open Questions that affect interfaces, object names, file usage, or core logic | **Skeleton** or **Block** if even a safe scaffold cannot be produced |
| New program with materially complete Program Spec | **Full Implementation** |
| Enhancement with materially complete Program Spec and current source provided | **Full Implementation** |
| Enhancement with no current source provided | **Skeleton** or delta-oriented draft — do not present as a safe drop-in replacement |
| User requests **Full Implementation** but blockers remain | Downgrade to **Skeleton** and state the blockers briefly |
| Unclear | Default to **Skeleton** and identify the missing inputs |

Only ask clarifying questions when the Program Spec or Program Type is missing, or when the
input is too incomplete to produce even a safe skeleton.

Then determine the **RPGLE source format policy** when Program Type is RPGLE:

| Condition | RPGLE Format Policy |
|-----------|---------------------|
| New Program | **Free format** |
| Change to Existing and current source is fixed-format | **Fixed format** |
| Change to Existing and current source is mixed-format | **Keep consistent with the original source** |
| Change to Existing and current source is unavailable | **Fixed format by default for generated change code or skeleton** |

For mixed-format existing programs, preserve the original program's style. Match the touched
region and surrounding conventions; do not normalize the member to all-free or all-fixed unless
the user explicitly asks for conversion work.

If you need concrete format guidance or touched-region examples, read
`references/rpgle-format-policy.md` and the relevant RPGLE example files listed in the
Reference Files section.

### Step 2 — Build the Implementation Map

Map the Program Spec to code before generating:

| Program Spec Section | Code Responsibility |
|----------------------|--------------------|
| Spec Header | Program/member identity, high-level header comment |
| Caller Context | Entry expectations, invocation assumptions |
| Functions | Major routines or code regions (WHAT only, not extra logic) |
| Business Rules | Conditional logic anchors and trace comments |
| Interface Contract | Entry parameters, return code contract, call signature |
| Data Contract | Variable/data structure declarations and read/write intent |
| File Usage | File declarations, record access points, and I/O pattern selection (1:1 → CHAIN, 1:N → SETLL/READE loop, Sequential → READ loop) |
| External Program Calls | CALL points and passed parameters |
| Program Processing / Main Logic | Ordered implementation flow |
| Error Handling | Return codes, message handling, rollback/stop behavior |
| Traceability Matrix | Coverage check that every BR-xx lands in code |
| Open Questions / TBD | TODO markers, blockers, or forced downgrade to Skeleton |

For **change specs**, implement only the `(NEW)` and `(MODIFIED)` behavior. Use
`(EXISTING — context only)` content only to understand surrounding flow; do not rewrite
unchanged code unless needed to integrate the requested change.

### Step 3 — Generate in the Correct Language

Respect the Program Spec's **Program Type**.

#### If Program Type is RPGLE

- Apply the RPGLE format policy strictly:
  - **New Program** → generate **free-format RPGLE**
  - **Change to Existing** → generate **fixed-format RPGLE** by default
  - **Mixed-format Existing Program** → keep the generated code consistent with the original
    source and the touched region; do not normalize unrelated code
- Use these structure defaults unless the Program Spec or current source requires otherwise:
  - **New free-format RPGLE** → header comment, `ctl-opt`, file declarations, data declarations,
    parameter interface, mainline or procedure flow, explicit error/return handling
  - **Existing fixed-format RPGLE** → preserve existing H/F/D/C specification layout, indicators,
    subroutine style, and column-sensitive continuation patterns
  - **Mixed-format RPGLE** → preserve the local style of the touched region; fixed-format blocks
    stay fixed, free-format blocks stay free
- Reflect the Interface Contract in the program entry or procedure interface
- Reflect the Data Contract in declarations; do not invent additional fields or data structures
- Implement Main Logic in the spec's order, using short trace comments such as `// Step 3`
  and `// BR-02` where helpful
- Use external calls, files, data areas, and data queues only if the spec names them
- Use subprocedures or standard subroutines only when the spec or existing source supports them
- For fixed-format or mixed-format enhancement work, preserve existing column-sensitive layout
  and surrounding style instead of reformatting touched logic into free format
- **Indicator handling**: for existing fixed-format programs, preserve `*INxx` indicator usage
  from current source. For new free-format programs, prefer named indicators or `%ERROR` /
  `%FOUND` / `%EOF` BIFs. Do not convert indicator-based logic to BIF-based or vice versa
  unless the spec explicitly requires it

#### RPGLE Generation Patterns

Use these patterns as implementation defaults:

**New Program — free-format RPGLE**
- Build a complete free-format member shape when the spec is complete enough:
  1. Header comment with program identity
  2. `ctl-opt`
  3. File declarations from `File Usage`
  4. Data declarations from `Data Contract`
  5. Interface/prototype declarations from `Interface Contract`
  6. Mainline or main procedure ordered by `Step 1`, `Step 2`, etc.
  7. Error/return handling aligned to `Return Code Definition` and `Error Handling`
- Keep trace comments short, for example `// Step 4` and `// BR-02`

**Existing Program — fixed-format RPGLE**
- Default to targeted fixed-format implementation
- Reuse existing spec types (`H`, `F`, `D`, `C`, indicators, tags, `BEGSR` / `ENDSR`, etc.)
  rather than converting the touched area into free format
- If generating without full current source, produce fixed-format-safe placeholders or
  replacement blocks rather than a fabricated full legacy member
- Apply the Fixed-Format Compile Safety Rules below for all fixed-format output

**Mixed-format Existing Program**
- Preserve the local format of the touched region
- If a change lands inside a fixed-format calculation area, emit fixed-format code there
- If a change lands inside an existing free-format procedure/block, emit free-format there
- Do not use the presence of some free-format code as permission to convert unrelated
  fixed-format regions

#### Embedded SQL in RPGLE

When the Program Spec indicates SQL-based data access (e.g., File Usage references SQL
tables/views, or Main Logic steps describe SELECT/INSERT/UPDATE/DELETE operations):
- Use `EXEC SQL` blocks at the points indicated by the spec
- Reflect host variables from the Data Contract — do not invent column names or table names
- Use `EXEC SQL` only when the spec supports it; do not convert native RPG file I/O to SQL
  or vice versa unless the spec explicitly requires the change
- For existing programs that use native I/O, preserve native I/O unless the spec explicitly
  converts to SQL
- Include `SQLSTATE` or `SQLCODE` checks aligned to the Error Handling section

#### Fixed-Format Compile Safety Rules

When generating fixed-format RPGLE (existing programs or fixed-format change blocks), apply
these rules to avoid known compile-failure and runtime-error patterns. These are learned from
real IBM i compile review and take precedence over shorter or more convenient alternatives.

**Opcode safety — avoid risky shorthand:**

| Avoid | Use Instead | Why |
|-------|------------|-----|
| `%SUBST(...)` as Factor 2 inside `MOVE` / `MOVEL` | Stage to a work field first, then `MOVE` | `%SUBST` in Factor 2 of fixed-format `MOVE`/`MOVEL` can cause compile errors or unexpected truncation depending on the compiler level |
| `%TRIM` / `%TRIMR` in Factor 2 of fixed-format C-specs | Stage to a work field: `EVAL wkField = %TRIM(source)` then use `wkField` | BIF nesting in fixed-format Factor 2 is fragile; `EVAL` handles BIFs safely |
| Direct `%SUBST` on the left side of `EVAL` for complex targets | Use staged assignment with intermediate work fields | Avoids nested BIF issues in fixed-format calculation specs |
| `CAT` with `%TRIM` in Factor 2 | Use `EVAL` with concatenation: `EVAL result = %TRIM(a) + ' ' + %TRIM(b)` | `CAT` opcode has limited BIF support in Factor 2 |

**Record format and file alias discipline:**

- If the **spec** defines the record format name (e.g., in Compile-Oriented Constraints or
  File Usage), use the spec value — it always takes precedence
- If the spec names a file but not the record format, and **reference source** is available,
  extract the format name from the reference source's F-spec or file declaration as a
  structural default
- If neither spec nor reference source provides the record format name, use the file name as
  format name (IBM i default) but add a `TODO` comment:
  `C* TODO: Verify record format name — using file name as default`
- For `CHAIN`, `SETLL`, `READE`, `READ`, `UPDATE`, `WRITE` — use the **record format name**,
  not the file name, when the program uses renamed formats or multiple formats

**Key list (KLIST/KFLD) discipline:**

- If the **spec** defines key list composition (e.g., in Compile-Oriented Constraints), use
  the spec values — they always take precedence
- When the spec is silent and reference source provides `KLIST` / `KFLD` definitions, reuse
  the exact key list name and field composition from the reference as structural defaults
- When generating new key lists, name them descriptively (e.g., `KYORDR` for order key) and
  ensure every `KFLD` field is declared in D-specs before the key list is used
- Never generate a `CHAIN` or `SETLL` referencing a key list that is not defined in the same
  member or provided via reference source
- Verify that the number of `KFLD` entries matches the number of key fields declared in the
  spec's File Usage or the reference file's key definition

**I/O pattern enforcement (fixed-format):**

Fixed-format I/O patterns for the File Access Pattern Rule:

```
C* 1:1 access — single CHAIN
C     KYORDR        CHAIN     ORDHDRR
C                   IF        NOT %FOUND(ORDHDR)
C* ... not found handling
C                   ENDIF

C* 1:N access — SETLL + READE loop (NEVER a single CHAIN)
C     KYORDR        SETLL     ORDDTLR
C     KYORDR        READE     ORDDTLR
C                   DOW       NOT %EOF(ORDDTL)
C* ... process record
C     KYORDR        READE     ORDDTLR
C                   ENDDO
```

- For 1:N access in fixed format, always generate the full `SETLL` + `READE` + `DOW` loop
- Never substitute a single `CHAIN` for 1:N access regardless of how few records are expected
- Use `%EOF(filename)` or `*IN` indicators consistent with the existing program style

**Work field staging rule:**

When fixed-format code needs to build a composite value (concatenation, substring extraction,
numeric conversion), use explicit work fields with clear D-spec declarations rather than
inline BIF nesting in C-spec Factor 1 or Factor 2:

```
C* GOOD: staged work field approach
C                   EVAL      wkCustNm = %TRIM(CUSTNM)
C                   EVAL      wkAddr   = %TRIM(ADDR1)
C                   EVAL      wkLine   = wkCustNm + ' - ' + wkAddr
C                   MOVEL     wkLine        RSPTEXT

C* BAD: nested BIFs in fixed-format Factor 2
C                   MOVEL     %TRIM(CUSTNM) + ' - ' + %TRIM(ADDR1)          RSPTEXT
```

**Array and occurrence safety:**

- When using arrays or multiple-occurrence data structures, always generate bounds checking
  before indexing: `IF idx <= %ELEM(array)` or equivalent
- Do not generate array indexing that depends on unchecked counter values
- When the spec defines a response cap or maximum count, generate explicit overflow handling
  (either stop accumulating or surface an overflow indicator) — never silently truncate

#### Fixed-Format Readability Rules

Generated fixed-format RPGLE must not be a flat wall of C-specs. Apply these three
readability rules to all fixed-format full-member or full-revised-member output.

**Banner separator lines:**

Every major code region must be preceded by a banner comment block: a separator line, a
title line, and another separator line. The minimum regions that need banners are:

- Entry parameters (`*ENTRY PLIST`)
- Main Line
- Each subroutine (`BEGSR` / `ENDSR`)

When reference source provides a banner style (e.g., `C*****...` vs `C*===` vs `C*---`),
use that style. When no reference source is available, use this default:

```
C**************************************************************
C* <Section Title>
C**************************************************************
```

The title line should describe the section's purpose:
- `C* Entry parameters`
- `C* Main Line`
- `C* SR100 - Validate input parameters`
- `C* SR200 - Process order detail`
- `C* SR980 - Cleanup and return`

**Blank-line spacing:**

Insert visual separation between logical sections:
- One blank line before each banner block
- One blank line after `ENDSR` (before the next subroutine's banner)
- One blank line between the H/F/D specification groups and the first C-spec
- One blank line between the `*ENTRY PLIST` block and the Main Line banner

Do NOT insert blank lines within a tight logical block (e.g., between `CHAIN` and its
`IF NOT %FOUND` check). Spacing separates sections, not individual statements.

**Subroutine naming convention:**

- When reference source uses a numbered subroutine pattern (e.g., `SR100`, `SR200`,
  `SR980`), extract and continue that numbering sequence for new subroutines
- When the Program Spec names subroutines, the spec names win over reference source
- When neither spec nor reference source provides subroutine names, use descriptive names
  (e.g., `SRVALID`, `SRUPDT`, `SRERROR`) and add:
  `C* TODO: Align subroutine name with shop convention`
- For error/cleanup subroutines, check whether the reference source uses a high-numbered
  convention (e.g., `SR980`, `SR990`) and follow it

**Scope of readability rules:**

These rules apply to **full-member** and **full-revised-member** fixed-format output. For
**change blocks** (delta patches without full current source), follow the Existing Style
Preservation Rule instead — if the existing source is dense with no banners, the change
block should match that style. When the change block includes a complete new subroutine,
add a banner for that subroutine even in delta output.

For a complete example of a fixed-format full member with banners, spacing, and subroutine
structure, see `examples/sample-rpgle-fixed-full-member.md`.

---

#### If Program Type is CLLE

- Use idiomatic CLLE structure (`PGM`, `DCL`, `CHGVAR`, `IF` / `DO`, `CALL`, `MONMSG`, etc.)
  only as supported by the Program Spec
- Reflect the Interface Contract in the program parameter list and return handling
- Implement Main Logic in the spec's order, using short trace comments such as
  `/* Step 2 / BR-01 */` where helpful
- Do not invent command parameters, message IDs, or command sequences not supported by the spec
- Do not silently switch CLLE work into RPGLE because the logic is awkward; if the Program Type
  is wrong or incompatible with the requested behavior, stop and surface the mismatch

#### CLLE Generation Patterns

Use these patterns as implementation defaults:

**New CLLE Program**
- Build a complete CLLE member shape when the spec is complete enough:
  1. Header comment with program identity
  2. `PGM` with parameter list from `Interface Contract`
  3. `DCL` declarations from `Data Contract` (variables, files, constants)
  4. Main processing flow ordered by `Step 1`, `Step 2`, etc.
  5. `CALL` / `CALLPRC` points from `External Program Calls` with passed parameters
  6. `MONMSG` blocks aligned to `Error Handling` categories
  7. Return handling aligned to `Return Code Definition`
  8. `ENDPGM`
- Keep trace comments short, for example `/* Step 3 / BR-02 */`

**Existing CLLE Program**
- Preserve existing `DCL` ordering — do not reorder, regroup, or normalize declarations
- Preserve existing `MONMSG` scope and nesting patterns (global vs command-level)
- Preserve existing command structure and parameter ordering idioms
- Preserve existing `SNDPGMMSG` message handling patterns, message IDs, and message queue
  targeting from current source
- Preserve existing `CHGVAR` / `RTVJOBA` / `RTVSYSVAL` patterns — do not modernize or
  restructure unless the spec requires it
- Generate targeted change blocks rather than fabricated full members when current source
  is unavailable

If you need CLLE enhancement preservation patterns, read
`references/clle-enhancement-patterns.md`.

### Step 4 — Generate the Output

Output mode determines how complete the code should be:

#### Full Implementation

Produce executable candidate code for all non-TBD behavior defined by the Program Spec.

Rules:
- Implement every non-TBD Main Logic step in order
- Reflect every defined return code and mandatory error path
- Keep traceability visible for BR-xx and significant Step n boundaries
- Do not add business rules or side effects not present in the Program Spec

#### Skeleton

Produce a controlled scaffold when the Program Spec is incomplete or when enhancement safety
requires restraint.

Rules:
- Build the source structure, signature, declarations, and major flow regions only from
  information explicitly present in the Program Spec
- Mark unresolved areas with clear placeholders such as `TODO (Spec TBD)` or equivalent
- Tie placeholders to the source section when possible (for example: `TODO (Open Questions #2)`)
- Do not fake lengths, object names, parameters, or logic just to make the code look complete

#### Enhancement Handling — Delta-First Default

For **Change to Existing**, the default output is a **minimal delta** — the smallest code
unit that implements the change safely. This means a targeted change block, replacement
block, or insertion block rather than a regenerated full member.

Generate a full revised member only when **both** conditions are met:
1. The user explicitly asks for a full revised member
2. Current source is provided as the base

| Enhancement Scenario | Default Output |
|---------------------|---------------|
| Current source provided, user asks for full revised member | Full revised member with changes integrated |
| Current source provided, no explicit full-member request | Delta: change block(s) with insertion points identified |
| Current source **not** provided | Delta: change block(s) or skeleton — never a fabricated full member |

Delta output rules:
- Change only the areas required by `(NEW)` and `(MODIFIED)` spec items
- Identify where each block belongs (routine, step, anchor) when the spec allows it
- Preserve existing naming, layout, idioms, and routine structure in surrounding context
- Mark the output as a controlled change block, not a verified drop-in replacement, unless
  it was generated against provided current source

If output mode selection is ambiguous, read `references/change-output-modes.md`.

### Step 5 — Self-Check

Before outputting code, verify every applicable rule in the Quality Rules section below.
Confirm the output is honest about completeness and does not silently cross the spec boundary.

---

## Output Structure

Default to code-first output. Keep explanatory text minimal.

~~~text
<If needed, 1–4 brief lines only:>
- Mode: <Full Implementation / Skeleton / Change Block>
- Readiness: <Compile-shaped scaffold / Compile-ready draft / Production-safe implementation>
- Blockers: <only if downgraded — name the specific spec gap, 1–3 lines max>
- Notes: <only if needed for safe use>

```<target language>
<generated RPGLE or CLLE source>
```
~~~

Guidance:
- When the Program Spec provides a Program Name, use it as the suggested member name in the
  header comment (e.g., `// Member: ORDVAL` or `/* Member: ORDVAL */`). Note the expected
  source physical file (`QRPGLESRC` for RPGLE, `QCLLESRC` for CLLE) if it helps the developer
  locate where to place the source. Do not invent member names if the spec says TBD.
- If the user asks for code only, return code only
- If the generation was downgraded from Full Implementation to Skeleton, state that briefly
  before the code
- If enhancement work lacked current source, state briefly that the output is a controlled
  draft or change block, not a verified drop-in replacement

For enhancement work without full current source, this alternative output is preferred:

~~~text
- Mode: <Skeleton / Change Block>
- Readiness: <Compile-shaped scaffold / Compile-ready draft>
- Apply At: <routine / step / anchor if identifiable>
- Notes: <for example: existing source not provided; block is not a verified drop-in replacement>

```<target language>
<targeted code block or replacement block only>
```
~~~

---

## Core Rules

### Spec-First Rule

This skill generates code from a Program Spec. It does not generate code directly from raw
requirements, a Functional Spec, or a Technical Design unless the user explicitly accepts the
risk and the missing intermediate layer is first resolved. The Program Spec is the controlling
artifact.

### No Hallucination Rule

Never invent:
- Program names
- File names
- Field names
- Data structures
- Parameters
- Return codes
- External program names
- Message IDs
- Business rules

If the Program Spec does not define them, do not add them. Use a Skeleton with explicit
placeholders or stop if a safe scaffold is impossible.

### No Silent Logic Rule

Do not fill in business logic that is not stated in the Program Spec. If a Main Logic step,
BR-xx, return code, or file update condition is ambiguous, do not guess. Downgrade to
Skeleton or surface the blocker.

### Traceability Rule

Code structure must remain traceable back to the Program Spec:
- Significant conditional logic should map to BR-xx
- Major code regions should map to Main Logic steps
- Interface behavior should map to the Interface Contract
- Error handling should map to the Error Handling table

Traceability comments should be short and useful, not verbose restatements of the spec.

### TBD Handling Rule

Treat `TBD (To Be Confirmed)` and Open Questions as real blockers. Do not silently resolve
them. Allowed responses are:
- Generate Skeleton with explicit placeholders
- Omit the blocked area and state it briefly
- Stop and ask for clarification only if even a safe scaffold cannot be produced

### Mode Downgrade Rule

If the user asks for Full Implementation but the Program Spec is not sufficiently complete,
downgrade to Skeleton or change block rather than pretending full code is safe.

State the downgrade in the pre-code notes with a brief, spec-based blocker summary:
- Name the specific spec section or item that caused the downgrade (e.g., "Interface Contract
  parameters are TBD", "File Usage names CUSTMAST but no key fields defined")
- Keep to 1–3 blocker lines — enough for the user to know what to resolve, not a full review
- Do not editorialize or restate the spec; just identify the gap

### Enhancement Safety Rule

For enhancements, current source is the source of truth for unchanged code shape. Without it:
- Do not claim the output is a safe production patch
- Do not fabricate unchanged routines or declarations
- Limit generation to the changed areas, a controlled draft, or a scaffold

When current source and Program Spec conflict (e.g., the spec references a file not present
in current source, or current source uses a different parameter name): the Program Spec
controls for `(NEW)` and `(MODIFIED)` behavior. For unchanged areas, preserve current source.
Flag the conflict with a brief code comment (e.g., `// NOTE: Spec references PRICEF but not
found in current source — verify`) so the developer can investigate.

### Change Block Output Rule

For enhancement requests where the Program Spec is clear enough to implement the changed logic
but the full current source is unavailable, prefer a **targeted change block**:
- Identify where the block belongs if the spec allows it (`Step 4`, subroutine name, call site,
  validation section, update block, etc.)
- Output only the changed code region or a small surrounding scaffold
- Mark it as a controlled draft rather than a verified drop-in replacement
- Match the required RPGLE source format policy for the target program

### File Access Pattern Rule

The Program Spec's File Usage section declares an **Access Pattern** for each file key.
This access pattern directly controls which I/O opcode pattern to generate:

| Access Pattern | Spec Main Logic Cue | RPGLE Native I/O Pattern | Embedded SQL Pattern |
|----------------|---------------------|--------------------------|---------------------|
| **1:1** (unique key) | "Read record", "Chain", `READ <file> by <key>` | `CHAIN key FILE` | `SELECT INTO ... WHERE key = :hostvar` (expects single row) |
| **1:N** (partial key) | "For each record", "Process all matching", `FOR EACH record in <file> by <key>` | `SETLL key FILE` + `READE key FILE` / `DOW NOT %EOF` loop | `DECLARE CURSOR` + `FETCH` loop, or `FOR` cursor loop |
| **Sequential** | "Read all records", "Process file" | `READ FILE` / `DOW NOT %EOF` loop | `DECLARE CURSOR` (no WHERE or broad WHERE) + `FETCH` loop |

**Critical rule:** When the spec's File Usage shows **1:N** for a file/key combination, **never**
generate a single `CHAIN` — always generate a `SETLL` + `READE` loop (native I/O) or a cursor
loop (embedded SQL). A `CHAIN` only reads the first matching record and silently drops the rest.

**RPGLE native I/O — 1:N pattern:**

```rpgle
// SETLL + READE loop for 1:N access
setll KEY FILE;
reade KEY FILE;
dow not %eof(FILE);
  // process record
  reade KEY FILE;
enddo;
```

**Ambiguity handling:** If File Usage does not include an Access Pattern column (e.g., the spec
was written before this convention) but Main Logic uses "for each" / "process all matching" /
loop language, treat as 1:N. If Main Logic says "read" or "chain" with no loop language, treat
as 1:1. If still ambiguous, generate a `TODO` comment noting the ambiguity and default to the
safer 1:N pattern.

### Reference Source Naming Rule

When a reference source member is provided (separate from the existing source being enhanced):
- Extract record format names, key list names, data structure names, constant naming patterns,
  and comment/banner style from the reference member
- Use these names in generated code unless the Program Spec explicitly overrides them
- Do not guess naming from the reference when the reference does not contain the needed object —
  fall back to spec-defined names or `TODO` markers
- Reference source is **opt-in**: when not provided, this rule does not apply
- Reference source provides naming and style evidence, not business logic or structural authority

### Existing Style Preservation Rule

When current source or a style reference is provided, preserve:
- Naming conventions
- Routine layout
- Comment style
- Error-handling idioms
- Parameter ordering
- Overall formatting conventions
- **Data access patterns** — if the existing program uses native RPG file I/O (`CHAIN`,
  `READ`, `WRITE`, `UPDATE`, `SETLL`, etc.), generate new/modified code using native I/O.
  If the existing program uses embedded SQL (`EXEC SQL`), generate using embedded SQL.
  Do not convert between access styles unless the Program Spec explicitly requires it.

Do not modernize or refactor unrelated code unless explicitly asked.

### Organization Coding Standard Rule

When `references/AS400 Program Development Guideline.md` is present, treat it as the
repository-local development standard for code generation.

Apply the guideline to:
- Naming conventions
- Header / banner / comment format
- Modification history layout
- Declaration ordering and layout
- Routine / subroutine structure
- Error-handling idioms
- Indicator and data-access conventions
- Explicitly forbidden constructs or discouraged patterns

Use this precedence order when rules conflict:
1. Program Spec and explicit user instruction
2. Existing source and touched-region preservation requirements for enhancements
3. `references/AS400 Program Development Guideline.md`
4. Skill defaults, examples, and neutral fallback patterns

The organization guideline can constrain **how** the code is generated, but it must not be
used to invent business logic, object names, file names, field names, return codes, or
interfaces that are absent from the Program Spec.

If the organization guideline conflicts with the Program Spec or with required enhancement-safe
preservation of the existing source, follow the Program Spec / existing source and note the
conflict briefly in pre-code notes or a TODO marker when needed.

### RPGLE Format Policy Rule

For RPGLE generation, use this policy:
- **New Program** → free format
- **Existing Program** → fixed format
- **Mixed-format Existing Program** → keep consistent with the original source

This rule overrides any generic preference for modern free-format RPGLE. For mixed-format
members, preserve the format used by the surrounding code in the touched area and do not
normalize the member unless the user explicitly asks for a source-format conversion.

### Commitment Control Rule

If the Program Spec's Processing Considerations indicate commitment control is required,
reflect `COMMIT` / `ROLBK` opcodes (RPGLE) or `COMMIT` / `ROLLBACK` commands (CLLE) at the
appropriate points in the generated code, aligned to the spec's Error Handling and recovery
approach. For embedded SQL, use `EXEC SQL COMMIT` / `EXEC SQL ROLLBACK`. Do not add
commitment control unless the spec requires it.

### Language Boundary Rule

The generated language must match the Program Spec's Program Type:
- `RPGLE` spec → RPGLE output
- `CLLE` spec → CLLE output

If the Program Spec is missing Program Type, or if the stated Program Type is clearly
incompatible with the required behavior and not user-confirmed, stop and resolve that issue.

### Honest Completeness Rule

Every code output carries an implicit readiness level. Use the correct level and do not
imply a higher one than the available spec and source context support:

| Readiness Level | Meaning | When to Use |
|-----------------|---------|-------------|
| **Compile-shaped scaffold** | Structural outline only; will not compile without developer work to fill placeholders | Skeleton mode with unresolved TBDs, missing object names, or absent current source |
| **Compile-ready draft** | Structurally complete and expected to compile, but not validated against a live system | Full Implementation from a materially complete spec, with or without current source |
| **Production-safe implementation** | Validated against current source and ready for integration testing | Full Implementation from a complete spec with current source provided and no conflicts |

State the readiness level briefly in the pre-code notes when it is not obvious. Never
present a scaffold as compile-ready, or a draft as production-safe.

### Single-Layer Rule

The output is source code. Do not:
- Rewrite the Program Spec
- Add design rationale sections
- Produce a review report
- Replace missing specification with narrative explanation
- Embed multi-line spec restatements as comments (trace comments should be short identifiers
  like `// Step 3` or `// BR-02`, not paragraph-length spec restated in the source)

If code cannot be safely generated, say so briefly and stop rather than drifting into another
document type.

---

## Quality Rules

Before outputting code, confirm each applicable rule:

**All generations:**
- [ ] A Program Spec was identified as the controlling input
- [ ] Output language matches the Program Spec's Program Type
- [ ] No file names, field names, program names, parameters, or data structures were invented
- [ ] Every implemented conditional branch maps to a BR-xx or explicit spec condition
- [ ] Main Logic order is reflected in code structure
- [ ] Interface Contract is reflected in parameters and return handling
- [ ] Error Handling rules are represented in code or explicit placeholders
- [ ] External calls and file usage appear only if supported by the Program Spec
- [ ] File access I/O pattern matches the spec's Access Pattern (1:1 → CHAIN, 1:N → SETLL/READE loop, Sequential → READ loop)
- [ ] Open Questions / TBD items were not silently implemented
- [ ] Output stays code-first and does not drift into a replacement spec
- [ ] No orphaned declarations — every declared file, variable, and data structure is
      referenced in generated code or explicitly marked as a placeholder
- [ ] If Program Type is RPGLE, the generated source format follows the RPGLE format policy
- [ ] Fixed-format RPGLE: no `%SUBST`/`%TRIM` in Factor 2 of `MOVE`/`MOVEL`/`CAT` — use staged work fields
- [ ] Fixed-format RPGLE: record format names match reference source or spec, not guessed from file names
- [ ] Fixed-format RPGLE: every `KLIST` referenced by `CHAIN`/`SETLL` is defined with correct `KFLD` count
- [ ] Fixed-format RPGLE: array/occurrence access includes bounds checking
- [ ] Fixed-format RPGLE: response-cap overflow is handled explicitly, not silently truncated
- [ ] When reference source is provided: record format names, key list names, and naming conventions match the reference unless the spec explicitly overrides
- [ ] When `references/AS400 Program Development Guideline.md` is present: generated code follows its mandatory naming, formatting, structure, and forbidden-pattern rules unless the Program Spec or existing source safely overrides them

**Full Implementation only:**
- [ ] All non-TBD Main Logic steps are implemented
- [ ] All defined return codes are handled
- [ ] BR traceability is visible at meaningful code boundaries
- [ ] The output is not missing any required interface or declared data elements from the spec

**Fixed-format full-member / full-revised-member only** (not change blocks):
- [ ] Banner separator comments exist between major code regions (entry parms, mainline, each subroutine)
- [ ] Blank-line spacing separates logical sections (no wall-of-code output)
- [ ] Subroutine names follow reference source naming convention when provided, or use descriptive names with TODO when not

**Skeleton only:**
- [ ] Placeholders are clearly marked
- [ ] Placeholder locations identify the blocked step, BR, or Open Question where possible
- [ ] No fake constants, lengths, or object names were inserted to make the scaffold look complete
- [ ] If enhancement output is partial, a targeted change block was preferred over a fabricated full member

**Enhancement generation:**
- [ ] `(NEW)` and `(MODIFIED)` items drive the change scope
- [ ] `(EXISTING — context only)` items are used only for integration context
- [ ] Default output is minimal delta (change block / replacement block), not full-member regeneration
- [ ] Full revised member generated only when user explicitly asked AND current source was provided
- [ ] If current source was not provided, the output is not presented as a verified drop-in replacement
- [ ] Existing style was preserved when source/context was provided
- [ ] Existing data access pattern preserved (native I/O vs embedded SQL) unless spec requires change
- [ ] Existing RPGLE programs were not silently converted from fixed or mixed format to all-free format
- [ ] Existing CLLE declaration ordering, MONMSG patterns, and command idioms were preserved
- [ ] Partial enhancement outputs identify the target routine, step, or anchor when the spec makes that possible
- [ ] Output readiness level (scaffold / compile-ready draft / production-safe) is accurate and stated

---

## Reference Files

- `references/AS400 Program Development Guideline.md` — Optional repository-local organization development standard. Read when present and use it as the default generation baseline unless the Program Spec or enhancement-safe preservation rules override it.
- `references/source-style-profile.md` — Read when a reference source member is provided for fixed-format RPGLE. Defines what to extract and apply.
- `references/rpgle-format-policy.md` — Read when Program Type is `RPGLE`, especially for existing fixed-format or mixed-format members.
- `references/change-output-modes.md` — Read when choosing between `Full Implementation`, `Skeleton`, and `Change Block` output.
- `references/clle-enhancement-patterns.md` — Read for `CLLE` enhancement work and existing-source style preservation.
- `examples/sample-rpgle-new-free.md` — Example of a new free-format RPGLE member generated from a complete Program Spec.
- `examples/sample-rpgle-setll-reade-loop.md` — Example of CHAIN (1:1) vs SETLL/READE loop (1:N) side by side, demonstrating Access Pattern–driven I/O selection.
- `examples/sample-rpgle-existing-fixed-change-block.md` — Example of a fixed-format RPGLE change block when full current source is unavailable.
- `examples/sample-rpgle-mixed-touched-region.md` — Example of local touched-region preservation in mixed-format RPGLE.
- `examples/sample-rpgle-embedded-sql.md` — Example of RPGLE embedded SQL generation when the Program Spec explicitly supports SQL access.
- `examples/sample-clle-enhancement-change-block.md` — Example of a controlled CLLE enhancement change block.
- `examples/sample-rpgle-fixed-full-member.md` — Example of a fixed-format RPGLE full member with banner separators, blank-line spacing, and subroutine structure.

Read only the files relevant to the current scenario. These examples are illustrative patterns,
not reusable production code.

---

## Relationship to Upstream Skills

This skill depends on the rest of the IBM i document chain:

| Upstream Skill | Role Relative to Code Generation |
|---------------|----------------------------------|
| `ibm-i-requirement-normalizer` | Not sufficient input for code generation |
| `ibm-i-functional-spec` | Not sufficient input for safe code generation |
| `ibm-i-technical-design` | Useful design context, but not the controlling artifact for code |
| `ibm-i-program-spec` | Primary input — this skill should normally consume this directly |
| `ibm-i-spec-reviewer` | Running a spec review before code generation can catch blockers early and reduce skeleton downgrades |

Recommended workflow:
1. Normalize messy input if needed
2. Produce Functional Spec
3. Produce Technical Design
4. Produce Program Spec
5. Generate code with this skill

If the user tries to skip directly from raw requirement, Functional Spec, or Technical Design
to code, recommend `ibm-i-program-spec` first unless they explicitly want a risky draft.
