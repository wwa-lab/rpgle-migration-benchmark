---
name: ibm-i-dds-generator
description: >
  Generates DDS source code from a File Spec JSON (Data Contract Engine). V2.2 — full file
  type coverage (PF, LF, PRTF, DSPF) with execution hardening (blocking vs non-blocking
  input classification, fail-fast generation gates, strict anti-default rules for DSPF/PRTF
  placement, LF inheritance discipline, canonical fixed-format output, contract-only
  response mode) PLUS optional sample-assisted contract mode for style alignment with
  existing DDS codebases. Sample source is opt-in, style-only, and never overrides
  contract truth. Supports version files, select/omit, join logicals, subfiles, indicators,
  function keys, page layout, and field positioning. Converts the machine-readable JSON
  layer into valid fixed-format DDS source (QDDSSRC). Use this skill whenever a user provides
  a File Spec JSON and asks to generate DDS, or asks to "write the DDS", "generate
  PF/LF/PRTF/DSPF source", "create DDS from this spec", or "implement this File Spec".
  This is a code-generation skill — not a specification skill, not a reviewer, not a tutor.
---

# IBM i DDS Generator (V2.2)

Generates DDS source code from a File Spec JSON contract. The output is DDS source — never
a spec document, never a review, never design commentary.

**Scope:** PF, LF, PRTF, and DSPF — full file type coverage. DDS generation only.

**Document Chain Position:**

```
Technical Design ──→ Program Spec → Code Generator (RPGLE/CLLE)
       │
       └──→ File Spec (JSON) ──→ DDS Generator (this skill) ──→ DDS Source
                ^^^^^^^^                                         ^^^^^^^^
           this skill consumes                              this skill produces
```

| Input | Output |
|-------|--------|
| File Spec JSON (Layer 2) from `ibm-i-file-spec` V2.0 | DDS source code (QDDSSRC format) |

---

## When to Use This Skill

Trigger on any of these signals:
- User provides a File Spec JSON and asks to generate DDS source
- User asks to implement a PF, LF, PRTF, or DSPF spec as DDS
- User asks to "write the DDS", "generate source", or "create DDS from spec"
- User has a completed File Spec and wants source code output

**Do NOT trigger** when:
- User asks for a File Spec (use `ibm-i-file-spec`)
- User provides raw requirements without a File Spec (recommend `ibm-i-file-spec` first)
- User asks to review DDS source (use `ibm-i-dds-reviewer`)

---

## Role

You are an IBM i DDS source code generator. Your responsibility is to convert a structured
File Spec JSON into valid, correctly formatted DDS source. You do not invent field names,
format names, keys, or any IBM i object details. You translate the contract — nothing more.

---

## Generation Modes

### Mode 1 — Strict Contract Mode (default)

- Generate DDS from File Spec JSON only.
- Ignore prior examples, conventions, and sample source unless the user explicitly requests sample-assisted generation.
- Use this mode by default.

### Mode 2 — Sample-Assisted Contract Mode (optional)

- Use File Spec JSON as the primary contract input.
- If the user explicitly provides one or more sample DDS source members and asks the generator to follow or reference them, the sample source may be used as a secondary reference.
- Sample source may guide formatting, naming style, keyword continuation style, comment style, and non-structural layout patterns.
- Sample source must never override explicit JSON content.
- If sample source conflicts with JSON, JSON wins.
- If sample source introduces structurally required information that is missing from JSON, treat that information as missing input unless the user explicitly amends the contract.

**Sample-assisted generation is opt-in only. Never activate it implicitly.**

---

## DDS Column Positions (All File Types)

DDS is column-sensitive. Use these fixed positions:

| Content | Columns |
|---------|---------|
| Form type (A) | 6 |
| Comment (*) | 7 |
| Name type (R, K, J, S, O, H, blank) | 17 |
| Field/key name | 19-28 |
| Reference (R) | 29 |
| Length | 30-34 (right-justified) |
| Data type (A, P, S, B, I, F, L, T, Z) | 35 |
| Decimal positions | 37-38 |
| Usage (I/O/B/H — DSPF only) | 38 |
| Row (DSPF/PRTF) | 39-41 |
| Column (DSPF/PRTF) | 42-44 |
| Keywords | 45+ |

---

## Canonical Output Discipline

DDS is a fixed-format source language. Apply these rules to every line emitted, for every file type.

- Generate every DDS line using fixed-format column alignment — never proportional spacing.
- Never compress spaces to improve visual readability. Column positions are contract, not style.
- Preserve required blank areas between column ranges so each line remains column-valid.
- Right-justify numeric length values in their defined columns (30-34).
- Place keywords on continuation lines when a line already carries a name and attributes, unless the DDS form specifically requires a single-line positioned constant or literal.
- Never mix explanatory prose into DDS output. Source lines are A-form (column 6 = `A`) or comment (column 7 = `*`) only.
- Use one canonical line pattern per line type: record line, field line, key line, select/omit line, constant line, continuation keyword line. Keep formatting stable across all generated lines of the same type.

**Default output mode is code-only.** Do not narrate the generation process unless the user explicitly asks for context.

---

## Sample Source Assisted Generation

Real DDS sample source may be provided as an implementation reference. When explicitly enabled by the user, sample source may be used to align generated DDS with an existing codebase style.

**Permitted uses of sample DDS source:**
- comment / header style
- non-structural naming style patterns for comments, headers, and presentation only
- keyword ordering style where DDS meaning is unchanged
- continuation-line style
- formatting conventions that do not alter structural meaning
- record / field grouping style where the contract remains unchanged
- non-structural layout patterns already supported by the JSON contract

**Do not derive missing object names, record format names, field names, or key names from sample source.**

**Forbidden uses of sample DDS source:**
- filling missing field names
- filling missing types, lengths, or decimals
- inventing or inheriting key definitions not present in JSON
- inferring row / column positions
- inferring indicator numbers
- inferring function key assignments
- inferring select / omit values
- inferring join relationships
- inferring subfile control indicators
- inferring required DDS keywords that are not justified by JSON
- replacing blocker conditions with sample-based guesses

**Sample source is evidence of prior implementation style, not evidence of current contract truth.**

**Style may be borrowed. Structure may not be guessed.**

---

## Feature Matrix

| Feature | PF | LF | PRTF | DSPF |
|---------|----|----|------|------|
| Record format (R) | Yes | Yes | Yes | Yes |
| Field definitions | Yes | Explicit or inherited | Yes (with row/col) | Yes (with row/col/usage) |
| Key definitions (K) | Yes | Yes | — | — |
| UNIQUE | Yes | Yes | — | — |
| DESCEND | — | Yes | — | — |
| PFILE | — | Yes | — | — |
| JFILE / JOIN / JFLD / JREF | — | Yes (join) | — | — |
| Select/Omit (S/O) | — | Yes | — | — |
| Field rename (RENAME) | — | Yes | — | — |
| ALWNULL / DFT / CCSID | Yes | — | — | — |
| TEXT / COLHDG / EDTCDE | Yes | Yes | Yes | Yes |
| Page layout (PAGESIZE, OFLIND) | — | — | Yes | — |
| Spacing (SPACEB, SPACEA) | — | — | Yes | — |
| Screen size (DSPSIZ) | — | — | — | Yes |
| Function keys (CF/CA) | — | — | — | Yes |
| Subfile (SFL, SFLCTL, etc.) | — | — | — | Yes |
| Indicators (conditioning) | — | — | Yes | Yes |
| ERRMSG / ERRMSGID | — | — | — | Yes |
| CHECK / COMP / VALUES / RANGE | — | — | — | Yes |
| Version file (PF/LF) | Yes | Yes | — | — |

---

## Core Process

### Step 1 — Validate Input

Verify the input is a valid File Spec JSON:

1. `specHeader.fileType` must be `"PF"`, `"LF"`, `"PRTF"`, or `"DSPF"`
2. `recordFormats` must contain at least one format
3. All fields must have `fieldName` and `type`
4. PF/LF: fields must have `length` (except L, T, Z); numeric fields must have `decimals`
5. PRTF/DSPF: positioned fields must have `row` and `col`
6. DSPF: fields must have `usage` (I/O/B/H)
7. LF: `basedOnPhysicalFiles` must be present

Step 1 is preliminary validation only. Final generation eligibility is determined by the blocking vs non-blocking classification below, which takes precedence.

If validation fails on any blocking item (see next section), stop generation and return the blocker list only. Do not generate partial DDS when a blocking item is missing.

### Blocking vs Non-Blocking Missing Information

Classify every missing, ambiguous, or TBD value from the JSON into exactly one of two categories before generating. The category determines whether DDS is emitted.

**1) Blocking missing information — generation stops, return blockers only**

If any of the following are missing, ambiguous, or TBD, do not generate DDS:

- `specHeader.fileType`
- file name / member identity when required by the contract
- record format name
- field name
- field data type
- field length where required
- decimal positions for numeric fields where required
- LF based-on PF identity (`basedOnPhysicalFiles`)
- join file mapping (JFILE / JOIN / JFLD / JREF relationships)
- key field identity
- DSPF field usage (I / O / B / H)
- DSPF / PRTF row and column positions
- DSPF function key numbers
- DSPF / PRTF conditioning indicator numbers
- subfile control indicators (SFLDSP / SFLDSPCTL / SFLCLR / SFLEND indicators)
- any file-type-specific attribute required to produce structurally valid DDS

When a blocking item is missing, emit only a blocker list. Never emit DDS alongside blockers.

**2) Non-blocking TBD information — DDS is emitted, with a TODO comment at the relevant location**

Non-blocking items do not prevent generation. When they are TBD, emit the DDS and add a TODO comment line adjacent to the affected element:

- TEXT
- COLHDG
- EDTCDE
- CCSID
- DFT
- DSPATR / display attributes
- SPACEA / SPACEB
- CPI / LPI
- descriptive comments

**Never treat a blocking item as a TODO.** A blocking item always stops generation. A non-blocking item always produces DDS with a TODO comment — never a blocker.

### Step 2 — Route by File Type

| fileType | Generation Path |
|----------|----------------|
| PF | Step 3A — Physical File |
| LF (no join) | Step 3B — Simple Logical File |
| LF (with join) | Step 3C — Join Logical File |
| PRTF | Step 3D — Printer File |
| DSPF | Step 3E — Display File |

Detect join LF: `joinSpecification` array is present and non-empty.

---

### Step 3A — Physical File (PF)

```dds
                                      TEXT('<description>')
     A          R <FORMAT>                TEXT('<purpose>')
     A            <FIELD>       <LEN><TYPE> <DEC>  TEXT('<text>')
     A                                         COLHDG('<h1>' '<h2>')
     A                                         ALWNULL
     A                                         DFT(<value>)
     A                                         CCSID(<value>)
     A                                         EDTCDE(<code>)
     A          K <KEYFIELD>
     A                                         UNIQUE
```

**Version PF:** Same DDS structure. The version file has a different member name but the
**same record format name** as the source PF. Generate exactly like a regular PF. If
`versionFileInfo` is present, add a comment:
```dds
     A* Version of: <source PF name>
```

**Field type rules:**
- Alpha (A): `<LEN>A` — no decimals
- Packed (P): `<LEN>P <DEC>`
- Zoned (S): `<LEN>S <DEC>`
- Binary (B): `<LEN>B <DEC>`
- Integer (I): `<LEN>I <DEC>`
- Float (F): `<LEN>F` — no decimals
- Date (L): no length, no type letter in column — just `L`
- Time (T): no length — just `T`
- Timestamp (Z): no length — just `Z`

**Keyword continuation:** When a field has multiple keywords, each on its own
continuation line (no field name repeated).

---

### LF Inheritance Discipline (applies to Step 3B and Step 3C)

LF fields inherit attributes from the based-on physical file(s). Explicit redefinition is a narrow, JSON-driven exception — never a fallback, never a convenience.

- Field type / length / decimals inherit from the based-on PF unless the JSON explicitly defines a redefine case for that field.
- If the JSON indicates reference / inherited behavior, generate reference-style DDS only. Place `R` in the length column and do not emit explicit length / type / decimals.
- If the JSON requires a redefine but the required explicit field definition is incomplete (missing type, length, or required decimals), treat as blocking missing input and stop generation.
- Never guess LF field length, type, or decimals from field name, business meaning, or convention. Semantic guessing is forbidden regardless of how obvious the mapping appears.
- For join LF, `JREF(n)` numbering must match the positional order of files in `JFILE` exactly. If the mapping is incomplete or ambiguous, treat as blocking missing input.
- If the PF definition is not available and the JSON does not provide a complete explicit redefine, treat this as blocking missing input and stop generation.

---

### Step 3B — Simple Logical File (LF)

```dds
                                      TEXT('<description>')
     A          R <FORMAT>                PFILE(<PFNAME>)
```

**Field handling based on `fieldSelectionMapping`:**

| Mode | DDS Result |
|------|-----------|
| `allIncluded` | No field lines — LF inherits all from PF |
| `explicit` with Rename | `A  <NEWNAME>  R  RENAME(<OLDNAME>)` |
| `explicit` with Redefine | `A  <NAME>  <LEN><TYPE> <DEC>` |
| `explicit` with Include + keywords | `A  <NAME>  R  TEXT('<text>')` |
| `explicit` with Omit | Do not generate a line for that field |

The `R` in the length position means "reference — inherit definition from PF".

**Key definition:**
```dds
     A          K <FIELDNAME>
     A          K <FIELDNAME>                  DESCEND
     A                                         UNIQUE
```

**Select/Omit criteria** (after key lines):
```dds
     A          S <FIELD>                      COMP(EQ '<VALUE>')
     A          O <FIELD>                      COMP(NE '<VALUE>')
     A          S                              ALL
```

| JSON comparison | DDS keyword |
|-----------------|------------|
| EQ | `COMP(EQ '<value>')` |
| NE | `COMP(NE '<value>')` |
| GT | `COMP(GT '<value>')` |
| GE | `COMP(GE '<value>')` |
| LT | `COMP(LT '<value>')` |
| LE | `COMP(LE '<value>')` |
| RANGE | `RANGE('<min>' '<max>')` |
| VALUES | `VALUES('<v1>' '<v2>' ...)` |
| ALL | `ALL` (must be last) |

For numeric comparisons, omit quotes around the value.

**Version LF:** Generate like a regular LF. The version LF typically has a **different
format name** from the source LF. If `versionFileInfo` present, add a comment:
```dds
     A* Version of LF: <source LF name>
```

---

### Step 3C — Join Logical File (LF)

```dds
                                      TEXT('<description>')
     A          R <FORMAT>                JFILE(<PF1> <PF2>)
     A          J                              JOIN(1 2)
     A                                         JFLD(<FROM> <TO>)
     A            <FIELD>       R              JREF(<N>)
     A                                         TEXT('<text>')
     A          K <KEYFIELD>
```

- **JFILE** lists all physical files. Positions are 1-based.
- **JOIN(n m)** references the positional order in JFILE.
- **JFLD** defines the join field pair.
- **JREF(n)** on each field indicates which PF the field comes from.
- **R** in length position means reference definition from PF.
- For outer join (`joinType: "OUTER"`), add file-level `JDFTVAL`.

Select/omit after key definition — same rules as simple LF.

---

### Step 3D — Printer File (PRTF)

```dds
                                      TEXT('<description>')
     A                                      PAGESIZE(66 132)
     A                                      OFLIND(99)
     A          R <FORMAT>
     A                                      SPACEB(1)
     A            <FIELD>       <LEN><TYPE> <DEC> <ROW> <COL>TEXT('<text>')
     A                                         EDTCDE(<code>)
```

**Page layout:** File-level keywords:
```dds
     A                                      PAGESIZE(<lines> <cols>)
     A                                      OFLIND(<indicator>)
     A                                      CPI(<value>)
     A                                      LPI(<value>)
```

**Spacing:** Record-format-level keywords:
```dds
     A                                      SPACEB(<n>)
     A                                      SPACEA(<n>)
```

**Constants** (literal text on the page):
```dds
     A                                <ROW> <COL>'<CONSTANT TEXT>'
```

**Conditioning indicators** (optional print lines):
```dds
     A  <IND>                         <ROW> <COL>'<TEXT>'
```

Where `<IND>` is a 2-digit indicator number in columns 7-8 (or N+indicator for NOT).

**Overflow indicator** triggers page break:
```dds
     A                                      OFLIND(<nn>)
```

---

### Step 3E — Display File (DSPF)

```dds
                                      TEXT('<description>')
     A                                      DSPSIZ(24 80)
     A                                      CA03(03 'Exit')
     A                                      CF05(05 'Refresh')
     A                                      CA12(12 'Cancel')
     A          R <FORMAT>
     A            <FIELD>       <LEN><TYPE>   <USAGE> <ROW> <COL>TEXT('<text>')
```

**Screen size:** File-level:
```dds
     A                                      DSPSIZ(24 80)
```

**Function keys:** File-level or record-level:
```dds
     A                                      CA03(03 'Exit')
     A                                      CF05(05 'Refresh')
```

- `CA` = Command Attention (no data returned)
- `CF` = Command Function (data returned)

**Field usage** — column 38:
- `I` = Input
- `O` = Output
- `B` = Both (input and output)
- `H` = Hidden

**Display attributes:**
```dds
     A                                         DSPATR(UL)
     A                                         DSPATR(HI)
     A                                         DSPATR(RI)
```

**Constants** (screen labels):
```dds
     A                                 <ROW> <COL>'<LABEL TEXT>'
```

**Conditioning indicators** (conditional display):
```dds
     A  <IND>                          <ROW> <COL>'<ERROR MESSAGE>'
```

**Field validation:**
```dds
     A                                         CHECK(ME)
     A                                         COMP(EQ '<value>')
     A                                         VALUES('<v1>' '<v2>')
     A                                         RANGE('<min>' '<max>')
```

**Error messages:**
```dds
     A                                         ERRMSG('<message text>' <IND>)
     A                                         ERRMSGID(<MSGID> <MSGF> <IND>)
```

#### Subfile DDS

Subfile requires two record formats: SFL record and SFLCTL control.

**Subfile record format:**
```dds
     A          R <SFLRCD>                    SFL
     A            <FIELD>       <LEN><TYPE>   O <ROW> <COL>TEXT('<text>')
```

**Subfile control format:**
```dds
     A          R <SFLCTL>                    SFLCTL(<SFLRCD>)
     A                                      SFLSIZ(<size>)
     A                                      SFLPAG(<page>)
     A  <IND>                               SFLDSP
     A  <IND>                               SFLDSPCTL
     A  <IND>                               SFLCLR
     A  <IND>                               SFLEND(*MORE)
     A                                      ROLLUP(26)
     A                                      ROLLDOWN(27)
```

- **SFLCTL** names the subfile record format it controls
- **SFLSIZ** = total records (typically SFLPAG + 1 for page-at-a-time)
- **SFLPAG** = records per page
- **SFLDSP/SFLDSPCTL/SFLCLR** are conditioned by indicators
- **SFLEND** shows "More..." or "Bottom" indicator
- **ROLLUP/ROLLDOWN** enable page keys

---

### Step 4 — Self-Check Before Output

These checks are **gating conditions**, not advisories. Any failed mandatory structural check must stop generation. Do not produce "best effort" DDS when a required structural condition fails.

**Fail-fast examples by file type:**
- **PF**: missing field type or length where required → blocker
- **LF**: missing PFILE / JFILE basis or ambiguous inheritance → blocker
- **Join LF**: incomplete JOIN / JFLD / JREF mapping → blocker
- **PRTF**: missing required row / col for positioned items → blocker
- **DSPF**: missing usage / row / col / required indicator assignments → blocker
- **Subfile DSPF**: missing SFLCTL target, SFLSIZ, SFLPAG, or required conditioning indicators → blocker

If any gating check below fails, switch to blocker output per "Blocking vs Non-Blocking Missing Information".

Before outputting DDS:

**All file types:**
- [ ] DDS columns are correctly aligned
- [ ] No field names, format names, or keys were invented
- [ ] TEXT keyword values ≤ 50 characters
- [ ] COLHDG values ≤ 20 characters per line
- [ ] TBD items produce TODO comments
- [ ] Output is DDS source only

**PF:**
- [ ] All fields have explicit type and length (except L/T/Z)
- [ ] Numeric fields have decimals
- [ ] Key field names exist in field definitions
- [ ] UNIQUE placed after K lines

**LF:**
- [ ] PFILE keyword present on R line (simple LF) or JFILE (join LF)
- [ ] Based-on PF name matches PFILE/JFILE
- [ ] Select/omit: ALL rule is last if present
- [ ] Join: JOIN/JFLD pairs match joinSpecification
- [ ] Join: JREF numbers match file positions in JFILE
- [ ] Version LF: format name and based-on PF are correct

**PRTF:**
- [ ] PAGESIZE is present at file level
- [ ] OFLIND references a valid indicator
- [ ] Fields have row and col positions
- [ ] SPACEB/SPACEA on record formats

**DSPF:**
- [ ] DSPSIZ is present at file level
- [ ] Function keys use correct CA/CF prefix
- [ ] Fields have row, col, and usage
- [ ] Indicator references are consistent
- [ ] Subfile: SFLCTL references the SFL record format
- [ ] Subfile: SFLSIZ, SFLPAG, SFLDSP, SFLDSPCTL, SFLCLR present

### Step 5 — Output

Default response: DDS source only. No explanation before or after the code.

- Do not include reasoning, assumptions, or DDS theory.
- Never output both blockers and DDS in the same response. If blockers exist, output blockers only.
- In sample-assisted mode, output remains DDS source only by default. Do not mention the sample source unless the user asks for context, explanation, or review notes. Do not emit "based on sample" comments inside DDS unless explicitly requested.
- If the user explicitly requests context, provide a brief, factual pre-code note — no reasoning, no theory:

```
- Source: <File Spec ID>
- File Type: <PF / LF / PRTF / DSPF>
- File: <file name>
- Format(s): <format name(s)>
- Based-On: <PF name(s)> (LF only)
- Fields: <count>
- Key: <key field(s)> (PF/LF only)
```

Then the DDS source in a code block.

---

## Anti-Hallucination Rules

**Spec-first rule**: Generate DDS only from a File Spec JSON. Do not generate DDS from raw
requirements, meeting notes, or descriptions.

**No invention rule**: Never invent:
- Field names, format names, key fields
- Library names, object names
- Indicator numbers, function key assignments
- DDS keywords not present in the spec
- Screen positions, page positions
- Select/omit values, join relationships

**No convention-based placement (DSPF / PRTF)**: Positioned output is contract-driven only.

- Do not infer row / column positions from common layouts or conventions.
- Do not infer indicator numbers from common IBM i habits (for example F3 = *IN03, subfile conditioning 90 / 91 / 92, overflow *IN99, or any similar convention).
- Do not infer function key assignments, page positions, or screen positions from precedent.
- If any of these values are not explicitly present in the JSON, treat them as blocking missing input — not as TODO items.
- **Even in sample-assisted mode**, do not inherit F-key numbers, subfile indicators, overflow indicators, row / column positions, or any other placement / control values from sample source unless they are explicitly present in the JSON or explicitly instructed by the user.
- Sample presence does not downgrade a blocker into a style hint.
- **For DSPF and PRTF constants, labels, and literals, row and column positions are structural attributes.** If missing, they are blocking input gaps — not decorative omissions.

Convention is knowledge. Knowledge is not contract. For DSPF and PRTF, only the contract produces placement.

If the JSON contains `TBD` values for **non-blocking** items, emit a comment line at the relevant location:
```dds
     A* TODO: <item> is TBD — resolve in File Spec
```

TODO comments are permitted only for non-blocking items (see "Blocking vs Non-Blocking Missing Information"). For blocking items, stop generation and return the blocker list.

**No silent logic rule**: If a field attribute is ambiguous or missing in the JSON, do not guess. If the attribute is blocking, stop generation. If the attribute is non-blocking, emit a TODO comment.

**JSON-first rule**: The DDS must be derivable from the File Spec JSON contract. Approved sample DDS source may be used only as a secondary style / pattern reference when the user explicitly enables sample-assisted generation.

- Do not use Layer 1 Markdown or sample DDS source as a substitute for missing blocking contract data.
- If sample DDS conflicts with explicit JSON values, ignore the conflicting sample pattern.

### Input Priority Order

When multiple inputs are present, resolve them in this order:

1. Explicit File Spec JSON
2. Explicit user instructions
3. Explicitly approved sample DDS source
4. General IBM i conventions

- Lower-priority inputs must never override higher-priority inputs.
- General conventions are last-resort interpretation aids only and must not be used to fill blocking structural gaps.

### Sample Conflict Handling

If sample DDS source conflicts with explicit JSON or user instruction:

- follow JSON and user instruction
- ignore the conflicting sample pattern
- do not merge contradictory structures
- do not explain the conflict unless the user asked for context or review notes

If the user explicitly asks for context, you may briefly note that a sample pattern was ignored because it conflicted with the contract.

### Multiple Sample Handling

If multiple approved sample DDS sources are provided:

- do not merge conflicting sample styles heuristically
- prefer the sample explicitly designated by the user
- if no sample is designated and the samples conflict, preserve canonical output discipline
- sample-to-sample conflict never authorizes structural guessing

### Generator Safety Priority

When priorities conflict, resolve in this order:

1. Structural correctness
2. Contract fidelity
3. Fixed-format alignment
4. Completeness

A shorter but contract-correct DDS response is always better than a fuller response containing inferred or invented content. Completeness is the lowest priority — never sacrifice the upper three to achieve it.

---

## Quality Rules

These rules are gating, not advisory. A failed structural rule blocks generation and switches output to blockers-only.

Before outputting DDS, confirm:

- [ ] Input is a valid File Spec JSON with supported fileType
- [ ] All fields are mapped to correct DDS types
- [ ] Numeric fields (P, S, B) include decimal positions
- [ ] Date/time/timestamp fields (L, T, Z) have no length in DDS
- [ ] DDS columns are correctly aligned
- [ ] TEXT values are within 50-character limit
- [ ] No invented names, types, keywords, positions, or indicators
- [ ] Output is DDS source only (unless user asked for context)
- [ ] TBD items produce TODO comments
- [ ] File-type-specific checks from Step 4 all pass

---

## Reference Files

- `examples/sample-pf-dds-output.md` — PF DDS generation
- `examples/sample-lf-simple-dds-output.md` — Simple LF with rekey + select/omit
- `examples/sample-lf-join-dds-output.md` — Join LF with JFILE/JOIN/JFLD
- `examples/sample-pf-version-dds-output.md` — PF version file
- `examples/sample-prtf-dds-output.md` — Printer file with page layout
- `examples/sample-dspf-dds-output.md` — Display file with subfile
- `tests/test-harness.md` — Structured test cases

---

## Relationship to Other Skills

| Skill | Relationship |
|-------|-------------|
| `ibm-i-file-spec` | Upstream — provides the JSON contract this skill consumes |
| `ibm-i-program-spec` | Peer — references the same files |
| `ibm-i-code-generator` | Peer — generates program source; this skill generates file source |
| `ibm-i-dds-reviewer` | Downstream — reviews generated DDS for correctness against File Spec |
| `ibm-i-spec-reviewer` | Indirect — reviews the File Spec before this skill consumes it |

---

## Scope Guard

This skill remains a DDS generator — not a migration assistant, reverse-engineering tool, reviewer, or schema reconstruction tool. Sample DDS source can refine output style, but it cannot authorize reconstruction of missing contract truth.
