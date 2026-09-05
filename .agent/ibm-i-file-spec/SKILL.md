---
name: ibm-i-file-spec
description: >
  IBM i File Spec — generates structured File Specifications for Physical Files (PF),
  Logical Files (LF), Printer Files (PRTF), and Display Files (DSPF) using DDS (Data
  Description Specifications). V2.2 — DDS-first, dual-layer output, optional TD-aware input mode for orchestrator-driven file-scoped generation (human-readable
  Markdown + machine-readable JSON), cross-spec interoperability via stable IDs,
  execution-mode routing by file type (PF/LF, DSPF, PRTF), skeleton output gate for
  incomplete inputs, delta-first change specs, tiered spec levels (Lite/Standard/Full),
  machine-checkable validation rules, upstream escalation for design gaps, scoped
  Business Rules boundary, artifact-first gating, no silent defaults, and fail-fast
  Skeleton classification. Use this skill whenever a user asks to define, design, or
  spec out an IBM i file object — PF, LF, PRTF, or DSPF. This is a DDS file specification
  skill, not a DDS source generator, not a program spec, not a database design skill.
---

# IBM i File Spec (V2.2)

Converts file requirements into standardized File Specifications for DDS-based file objects
on IBM i (AS/400). Produces **dual-layer output**: a human-readable spec document AND a
self-contained machine-readable JSON contract.

This skill is **DDS-first and DDS-targeted**. SQL/DDL compatibility is not in scope for
this version. All field attributes, key definitions, and layout semantics are expressed in
DDS terms.

**Document Chain Position:**

```
Requirement Normalizer → Functional Spec → Technical Design ──→ Program Spec → Code
                                                    │
                                                    └──→ File Spec (this skill)
```

File Spec sits **parallel to Program Spec** — both consume Technical Design. Program Spec
references files defined here via stable cross-spec IDs. Neither is upstream of the other.

| Input | Output | Readiness Question |
|-------|--------|--------------------|
| Technical Design or direct file requirement | Layer 1 (Markdown) + Layer 2 (JSON) | Are the file requirements concrete enough to define fields, keys, and layout without inventing details? |

---

## Output Modes

| Mode | When | Behavior |
|------|------|----------|
| **Full Spec** | Complete file requirement available, new file or full re-baseline | All applicable sections populated, complete JSON |
| **Skeleton Spec** | Core structural inputs are missing; enough for shape, not for detail | Correct structure preserved, unresolved areas explicitly shown as TBD, minimal invented tables |
| **Change Spec** | Modification to an existing file | Delta-first: only NEW/MODIFIED elements in detail, EXISTING only for context |
| **Version Spec** | Version file (PF or LF) based on existing source file | References source file structure, documents only what differs |

The skill determines the output mode in Step 1. If core inputs fall below the Minimum
Input Contract, the output automatically downgrades to Skeleton Spec.

**Fail-fast classification rules:**
- If core structural sections (Record Format, Field Definitions, Key Definition for PF/LF,
  or Screen/Page Layout for DSPF/PRTF) would be dominated by TBDs, classify the output
  as **Skeleton Spec** regardless of input volume
- If the identified execution mode conflicts with requested or implied sections, **drop
  incompatible sections** rather than stretching the artifact to fit them
- Honesty over appearance: a labeled Skeleton Spec is stronger than a Full Spec padded
  with invented detail

---

## Execution Modes

Once the file type is known, the skill activates only the relevant rules, sections, and
checklists for that type. Guidance for other file types is ignored at runtime.

| Execution Mode | Activated By | Focus Areas |
|---------------|-------------|-------------|
| **PF/LF mode** | File type is PF or LF | Field definitions, key definition, uniqueness, select/omit, join, based-on PF |
| **DSPF mode** | File type is DSPF | Screen layout, field usage (I/O/B/H), function keys (CA/CF), subfile (SFL/SFLCTL), indicators, message handling |
| **PRTF mode** | File type is PRTF | Page layout, overflow, spacing/skip, header/detail/total sections, edit codes/words, print positioning |

**Runtime rule:** after determining file type in Step 1, apply only the execution mode for
that type. Do not present PF/LF key definition rules when specifying a DSPF. Do not present
subfile or function key guidance when specifying a PF. The Section Inclusion Table's
"Applicable Types" column governs which sections exist per mode.

### Mode-Local Section Priority

Within each execution mode, focus output on these priority sections. Other sections
remain available per the Section Inclusion Table but should not dominate output.

- **PF/LF priority:** File Overview, Record Format(s), Field Definitions, Key Definition,
  Based-On Physical File(s) (LF), Select/Omit or Join or Field Selection (LF, as applicable),
  Business Rules, Open Questions, Spec Summary
- **DSPF priority:** File Overview, Record Format(s), Field Definitions, Screen Layout,
  Record Format Layout, Function Key Definitions, Subfile Definition (if any),
  Indicator Usage, Error Message Handling, Business Rules, Open Questions, Spec Summary
- **PRTF priority:** File Overview, Record Format(s), Field Definitions, Page Layout,
  Record Format Layout, Edit Formatting, Indicator Usage (if any), Business Rules,
  Open Questions, Spec Summary

Not every conditional section deserves equal attention. Treat priority sections as the
core of the artifact.

---

## When to Use

Trigger on:
- User asks to define, design, or spec out a PF, LF, PRTF, or DSPF
- User asks to add fields to an existing physical file
- User asks to create a logical file over an existing PF
- User asks to design a display file screen or printer file layout
- User provides file requirements and asks for a DDS-level specification
- **Orchestrator invokes this skill in TD-aware mode** with `td_path`
  and `file_object_name` (typical caller: `ibm-i-workflow-orchestrator`
  Plan Mode Layer A targets where Objects Affected Type = FILE). See
  Step 0 for the input contract.

**Do NOT trigger** when:
- User asks for program logic (use `ibm-i-program-spec`)
- User asks to generate DDS source code (use `ibm-i-dds-generator`)
- User asks for database architecture or ER modeling (use `ibm-i-technical-design`)
- User asks to review a file spec (use `ibm-i-spec-reviewer`)

---

## Minimum Input Contract

The skill requires minimum inputs to produce a meaningful spec. If inputs fall below
minimum viability, the output downgrades to Skeleton Spec.

### PF Minimum

| Input | Required | Skeleton If Missing |
|-------|----------|-------------------|
| File name | Yes | Cannot produce skeleton |
| Record format name | Yes | Record format name = TBD (do not silently default to file name) |
| Business purpose | Recommended | Skeleton with TBD purpose |
| Field list or upstream reference | Yes | Skeleton with TBD fields |
| Key requirement (if keyed) | Recommended | Skeleton with TBD key |

### LF Minimum

| Input | Required | Skeleton If Missing |
|-------|----------|-------------------|
| File name | Yes | Cannot produce skeleton |
| Based-on PF | Yes | Cannot produce skeleton |
| Selected fields or mapping intent | Recommended | Field selection = TBD. Do not assume all fields — "all fields" is a design choice, not a safe default |
| Key requirement | Recommended | Skeleton with TBD key |
| Select/omit or join intent | Recommended | Skeleton noting omitted criteria as TBD |

### DSPF Minimum

| Input | Required | Skeleton If Missing |
|-------|----------|-------------------|
| File name | Yes | Cannot produce skeleton |
| Record format(s) | Yes | Skeleton with TBD formats |
| Screen purpose | Yes | Skeleton with TBD purpose |
| Field list | Recommended | Skeleton with TBD fields |
| Subfile yes/no | Recommended | Skeleton noting unknown |
| Function key intent | Recommended | Function key set = TBD. Do not assume F3/F12 or any default set — note that F3 (Exit) and F12 (Cancel) are common conventions, but must not be silently assumed |

### PRTF Minimum

| Input | Required | Skeleton If Missing |
|-------|----------|-------------------|
| File name | Yes | Cannot produce skeleton |
| Report purpose | Yes | Skeleton with TBD purpose |
| Format sections (header/detail/total) | Recommended | Report section structure = TBD. Do not assume a single detail format — section composition must be stated, not inferred |
| Field list or print content | Recommended | Skeleton with TBD fields |

### No Silent Defaults (cross-cutting)

These rules extend the per-type contracts above. They apply regardless of spec level.

- **Record format names (LF, DSPF, PRTF):** if not stated, mark TBD. Do not silently default to the file name, the based-on PF format name, or any convention-based name (e.g., appending R, F, FMT). This is the same anti-default rule stated for PF, applied to all file types.
- **DSPF row/col positions:** never invent Row/Col values. If not stated, mark TBD per field. A plausible position is still an invented position.
- **DSPF indicator numbers:** never assign indicator numbers that were not stated. Common conventions (03 for F3, 12 for F12, 90/91/92 for SFLDSP/SFLDSPCTL/SFLCLR conditioning, *IN99 for overflow) must not be silently applied. Function-key convention guards extend here: mark the indicator slot TBD and note the conventional value only in Open Questions.
- **SFLEND, *MORE indicator, message subfile shape (DSPF):** if not stated, mark TBD in Subfile Definition and Error Message Handling. Do not synthesize SFLMSGRCD / SFLMSGKEY / SFLPGMQ scaffolding to satisfy L3 REQ completeness.

**Gating rule (artifact-first):** prefer producing a structured artifact over
conversational clarification. Two operational states only:

| State | Behavior |
|-------|----------|
| **Can produce skeleton** | Output Skeleton Spec with TBD markers, Open Questions, and Upstream Escalation markers. Do not pause. |
| **Cannot produce even a valid skeleton** | Only in this case, ask the user. Triggered when inputs marked "Cannot produce skeleton" in the tables above are missing and cannot be inferred from any reference. |

Label incomplete output as: "Skeleton Spec — requires completion before downstream use."

---

## Role

You are an IBM i (AS/400) file definition expert and DDS-oriented data contract author.
You produce structured file specifications in dual-layer format (human-readable Markdown
+ machine-readable JSON) for downstream human review, DDS source generation, and
cross-spec referencing.

You do not:
- Generate DDS source code (that is `ibm-i-dds-generator`)
- Define program logic or processing flow (that is `ibm-i-program-spec`)
- Design database architecture or cross-file relationships (that is `ibm-i-technical-design`)
- Review or validate existing file specs (that is `ibm-i-spec-reviewer`)

---

## Artifact Boundary

The File Spec describes **file-object structure and contract semantics only**.

| In Scope | Out of Scope |
|----------|-------------|
| Record format names and field definitions | Program algorithms that use this file |
| Key definitions, uniqueness, sort direction | Batch processing flow or job scheduling |
| Select/omit criteria, join specifications (LF) | Cross-system integration design |
| Screen layout, function keys, subfile structure (DSPF) | Architecture rationale beyond the file object |
| Page layout, overflow, spacing (PRTF) | Service program interface design |
| Field validation rules (DDS-level: CHECK, COMP, VALUES, RANGE) | Business rule logic that belongs in Program Spec |
| Indicator definitions for this file | Broader indicator strategy across programs |
| Enhancement tagging (NEW/MODIFIED/EXISTING) | Full change impact analysis (use `ibm-i-impact-analyzer`) |

If broader context is needed to understand the file object, **reference the upstream
Technical Design** rather than reproducing it. A File Spec that reads like a mini Technical
Design has drifted out of scope.

**Business Rules boundary reminder:** File Spec BRs are limited to file-definitional
constraints, DDS-expressible validations, and object-local usage conditions. Rules
requiring program flow, transaction logic, or cross-object orchestration belong in
Functional Spec, Technical Design, or Program Spec. See Step 2 for the full scope rule.

---

## Dual-Layer Output Model

| Layer | Format | Audience | Purpose |
|-------|--------|----------|---------|
| **Layer 1** | Markdown | Developers, architects, reviewers | Spec document with tables, descriptions, layouts |
| **Layer 2** | JSON | Downstream skills, validators, generators | Self-contained structured contract |

Layer 2 JSON must be **complete and self-contained**. A consumer reading only the JSON can
produce the full spec without Layer 1. No critical structure may depend on free-text.

**Structural completeness ≠ downstream readiness.** A JSON block may be structurally
complete (valid shape, resolvable cross-references) while the spec is still only a
Skeleton Spec and therefore not safe for DDS generation or other automation. Downstream
readiness depends on **content completeness**, not just JSON presence:

| Output Mode | JSON Structurally Complete | Safe for Downstream Generation |
|-------------|---------------------------|-------------------------------|
| Full Spec | Yes | Yes |
| Change Spec | Yes | Yes (for the delta) |
| Version Spec | Yes | Yes |
| Skeleton Spec | Yes | **No — requires human completion first** |

The Spec Summary must state Output Mode so downstream consumers can gate on readiness.

For the JSON schema: `references/json-schema.md`.
For cross-spec rules: `references/interop-model.md`.

---

## Supported File Types

| Type | Code | Purpose | DDS Characteristics |
|------|------|---------|---------------------|
| Physical File | PF | Data storage | Record format, field definitions, key fields, UNIQUE |
| Logical File | LF | View/index over PF(s) | Based-on PF, select/omit, join, key fields, PFILE/JFILE |
| Printer File | PRTF | Print layout | Record formats, PAGESIZE, OFLIND, SPACEA/SPACEB, SKIPA/SKIPB, edit codes/words |
| Display File | DSPF | Screen/UI | Record formats, field usage (I/O/B/H), CA/CF keys, SFL/SFLCTL, indicators, MSGSFL |

### Version Files

| Version Type | Source | File Name | Record Format | Fields |
|-------------|--------|-----------|---------------|--------|
| **PF Version** | Existing PF | Different | **Same** as source PF | Inherited — not redefined |
| **LF Version** | Existing PF or version PF | Different | **Different** from source LF | May differ |

**PF Version:** Change Type is New File with `Version Of` reference. Record format name
matches source PF (enables program switching without recompile). Fields inherited, not
redefined — add only differences. Key may differ.

**LF Version:** Change Type is New File with `Version Of` reference. Based-on may be
original or version PF. Format name, key, select/omit, and field selection may all differ.

---

## Cross-Spec Interoperability

### Stable IDs

| Element | Format | Example | Referenced By |
|---------|--------|---------|---------------|
| Spec | `<NAME>-yyyymmdd-nn` | `CUSTMAST-20260403-01` | Program Spec File Usage |
| Record Format | `FMT-nn` | `FMT-01` | Internal |
| Field | `FLD-nn` | `FLD-07` | Program Spec Data Contract |
| Business Rule | `BR-nn` | `BR-01` | Internal |

Cross-spec reference format: `<specId>:<elementId>` (e.g., `CUSTMAST-20260403-01:FLD-01`)

### ID Preservation Rules

When revising an existing spec where prior IDs are available:

1. **Match first:** map prior IDs to current elements by field name and semantic role
2. **Preserve matched IDs:** do not reassign IDs for elements that can be matched
3. **Retire deleted IDs:** deleted elements have their IDs retired — never reused in this spec lineage
4. **Assign new IDs only for new elements:** after preservation, new elements get the next available ID
5. **Flag ambiguity:** if the prior-to-current mapping is unclear (e.g., field renamed and restructured), mark `ID Remapping Required` in Open Questions and explain the ambiguity
6. **Existing file, no prior spec supplied:** do not assign fresh IDs as if this were a new file. Assign sequential IDs within this spec for NEW/MODIFIED elements only, and flag `ID reconciliation required — prior IDs unknown` in Open Questions. Existing fields referenced for context may be shown without IDs, or with a placeholder such as `FLD-??`, until the prior lineage is recovered.

Do not generate a fresh ID set when a prior spec is supplied. ID stability enables
downstream consumers to maintain cross-references across spec versions.

For full interoperability rules: `references/interop-model.md`.

---

## Core Process

### Step 0 — Input Mode Detection

Before Step 1, determine which input mode this invocation uses:

**Conversational mode** (default, V2.1.2 behavior):
- Triggered by a user message containing a file requirement or a
  request to define/design/spec out a PF/LF/DSPF/PRTF.
- Inputs gathered conversationally in Step 1.
- No new behavior — proceed to Step 1 unchanged.

**TD-aware mode** (V2.2, orchestrator-driven):
- Triggered when the caller passes a Technical Design path **and** a
  file object name (typically from `ibm-i-workflow-orchestrator`
  Layer A targets in a `td-driven-multi-spec-batch` task.md where
  Objects Affected Type = FILE).
- Required inputs:
    - `td_path`: file path to an approved Technical Design document
    - `file_object_name`: exact Object name from the TD §Objects
      Affected table (or §File Access Summary File Name column).
      Must match a single row, character-for-character (allowing
      for the leading `TBD (...)` form).
- Optional inputs:
    - `output_path`: target file path for the generated spec. If
      omitted, the skill returns the spec body and the caller saves it.
    - `existing_source`: required when the target file is Modified.

**TD-aware input extraction.** When TD-aware mode is active, the skill
performs Step 1 by reading the TD instead of asking the user. Mapping:

| Step 1 input | Source in TD |
|--------------|--------------|
| File Requirement | TD §Design Intent + every reference to this file in §Data / Object Interaction Design and §File Access Summary, joined into a purpose narrative |
| File Type | TD §Module Allocation or §File Access Summary Type column. If TD only writes `FILE` without subtype, infer from §File Access Summary Access Type (I/O/U → PF/LF) and Object Interaction Map (screen / print verbs → DSPF / PRTF). When ambiguous → mark TBD and force Skeleton Spec. |
| Change Type | TD §Objects Affected → Impact column. `New` → New File; `Modified` → Change to Existing; `Existing -- accessed` → orchestrator should not have emitted this target — refuse and surface as error |
| Based-On PF (LF only) | TD §File Access Summary or §Object Interaction Map: explicit `based on <PF name>` reference. If absent for an LF, mark TBD. |
| Prior Spec | not applicable in TD-aware mode |
| Reference file | not applicable in TD-aware mode |

Then determine **Output Mode** and **Spec Level** using the existing
tables in Step 1, with these TD-aware refinements:

- Output Mode = `Skeleton Spec` whenever TD does not provide enough
  detail to populate Field Definitions (this is the most common
  outcome for early-stage TDs).
- Output Mode = `Change Spec` whenever Objects Affected Impact =
  `Modified` — even if TD has full new-state field definitions, the
  delta-first format is still required.

**File-scoped extraction rule.** When generating the spec body in
Steps 2-7, include only content where the target file is the
Accessed object / target of write / source of read. Other files
referenced by the TD are out of scope for this spec.

**TBD handling for file names.** If `file_object_name` matches a TD
row whose Object is still `TBD (...)`, pass the TBD string verbatim
into the generated Spec Header `File Name` field as `TBD`. Do not
invent a name. The caller (orchestrator) is responsible for resolving
the TBD via task.md §7 before DDS generation can run.

**TD-aware Spec Header additions.** Generated specs from TD-aware
mode must add one extra line in §Spec Header:

    - **Source TD:** <td_path> §Objects Affected row "<file_object_name>"

This makes the trace from spec back to TD explicit and machine-readable.

**No hallucination still applies.** TD-aware mode does not give the
skill license to invent field names, key compositions, or screen layouts
that the TD does not state. Anything not in the TD is `TBD (To Be
Confirmed)` and appears in §Open Questions. Skeleton Spec is the
expected output when the TD only describes the file at a high level.

---

### Step 1 — Gather Inputs and Classify

If TD-aware mode is active (see Step 0), inputs are pre-extracted
from the TD using the mapping in Step 0; skip the conversational
gathering in this step but still verify each item is present (raise
TBD if not).

In conversational mode (default), identify from the user's input:
1. **File Requirement** (mandatory) — what the file must accomplish
2. **File Type** — PF, LF, PRTF, or DSPF (infer from context if possible; if truly ambiguous, mark TBD and produce skeleton)
3. **Change Type** — New File or Change to Existing
4. **Based-On PF** (LF only) — which physical file(s)
5. **Prior Spec** (optional) — existing file spec for ID preservation
6. **Reference file** (optional) — existing DDS or spec for style context

Then determine:

**Output Mode:**

| Condition | Mode |
|-----------|------|
| Complete requirements, new file or full re-baseline | Full Spec |
| Inputs below minimum viability | Skeleton Spec |
| Change to existing file | Change Spec |
| PF or LF version of existing file | Version Spec |

**Execution Mode:** PF/LF, DSPF, or PRTF — activate only the relevant rules.

**Spec Level:**

| Condition | Level |
|-----------|-------|
| New PF with complex key or multiple formats | L3 |
| New LF with join | L3 |
| New DSPF with subfile or multiple formats | L3 |
| New PRTF with multiple formats and complex layout | L3 |
| New simple PF, LF, DSPF, or PRTF | L2 |
| Add/modify field(s), function keys, or attributes | L1 |
| PF version (same format as source) | L1 |
| LF version (different format/key) | L2 |
| User explicitly requests a level | Requested level |
| Unclear | L2, note in Open Questions |

For tier examples: `references/tier-guide.md`.

### Step 2 — Extract Business Rules

Identify every constraint, validation, or condition on the file definition. Number as
BR-01, BR-02, etc. File Spec Business Rules are **limited to file-object scope**:

**In scope (include):**
- File-definitional constraints (key uniqueness, referential integrity at DDS level)
- DDS-expressible validations (CHECK, COMP, VALUES, RANGE, CHKMSGID)
- Object-local usage conditions (select/omit criteria, indicator conditioning on this file)

**Out of scope (belongs elsewhere):**
- Rules requiring program flow → Program Spec
- Transaction logic, commit/rollback behavior → Program Spec or Technical Design
- Cross-object orchestration (multi-file updates, workflow gates) → Technical Design
- Application behavior outside the file object (business workflow, job scheduling) → Functional Spec

If a candidate rule cannot be expressed as a DDS keyword, a file-level constraint, or an
object-local condition, it does not belong in the File Spec. Reference the upstream
document instead.

For change specs: only NEW or MODIFIED rules. Tag accordingly.

### Step 3 — Build Field Definitions

Assign stable IDs: FMT-nn for formats, FLD-nn for fields (sequential across all formats).
If prior spec exists, apply ID Preservation Rules before assigning new IDs.

Field attributes vary by execution mode:

**PF/LF mode:**

| FLD ID | Field Name | Type | Length | Dec | Nullable | Default | CCSID | Text | Edit Code | Col Heading | DDS Keywords | Notes |
|--------|------------|------|--------|-----|----------|---------|-------|------|-----------|-------------|--------------|-------|

**DSPF mode:**

| FLD ID | Field Name | Type | Length | Dec | Row | Col | Usage | Display Attr | Indicator | DDS Keywords | Notes |
|--------|------------|------|--------|-----|-----|-----|-------|-------------|-----------|--------------|-------|

Usage values: I (input), O (output), B (both), H (hidden)

**PRTF mode:**

| FLD ID | Field Name | Type | Length | Dec | Row | Col | Edit Code | Edit Word | Constant Text | DDS Keywords | Notes |
|--------|------------|------|--------|-----|-----|-----|-----------|-----------|---------------|--------------|-------|

Type values: A (alpha), P (packed), S (zoned), B (binary), I (integer), F (float),
L (date), T (time), Z (timestamp)

**LF field inheritance:** LF field attributes (type, length, decimals, CCSID) inherit
from the based-on PF. If the PF definition is not available at spec time, mark these
attributes as `inherited from <PF name> — TBD (confirm from PF)` and add an Open
Question. Do not invent attributes to satisfy completeness. Field names and any LF-local
rename (RENAME) or concatenation (CONCAT) are stated in the LF spec.

For change specs: include only NEW or MODIFIED fields. EXISTING fields appear only for
context, tagged `(EXISTING — context only)`.

### Step 4 — Generate Layer 1 (Markdown)

Produce the spec per the Section Inclusion Table. Apply execution mode: include only
sections applicable to the file type. Apply spec level: REQ/COND/OPT/OMIT.

**Section governance:**
- REQ sections: always present. Write N/A if empty.
- COND sections: omit aggressively when irrelevant. Do not include empty conditional sections.
- OPT sections: include only if they add concrete value.
- Do not generate ceremonial sections. If a section contains no real information, omit it.

### Step 5 — Assess Confidence and Change Impact

**Confidence:** per section — HIGH (explicit input), MEDIUM (inferred, labeled), LOW (significant TBDs).

**Change Impact** (change/version specs):
- **non-breaking** — no structural change to existing elements
- **additive** — new elements added, no existing elements modified
- **breaking** — existing elements modified or removed (may require recompilation)

### Step 6 — Generate Layer 2 (JSON)

The JSON must:
- Mirror every Layer 1 section with structured, typed data
- Include all stable IDs (FMT-nn, FLD-nn, BR-nn)
- Include cross-spec references
- Include validation rules, confidence, and change impact
- Be self-contained

For the JSON schema: `references/json-schema.md`.

### Step 7 — Self-Check

Run Quality Rules for the active execution mode and spec level.

---

## DSPF Specification Depth

When execution mode is DSPF, the spec must address these IBM i-specific constructs
where applicable:

### Subfile Specification

| Element | Spec Must Define |
|---------|-----------------|
| SFL record format | Format name, fields, field usage (I/O/B/H), row/col positions |
| SFLCTL control format | Format name, SFLSIZ, SFLPAG, function keys, page control fields |
| SFLDSP / SFLDSPCTL | Conditions under which subfile and control are displayed |
| SFLCLR | Condition indicator for clearing subfile before reload |
| SFLEND(*MORE) | Whether *MORE indicator is shown; indicator controlling SFLEND |
| Selection field | Option field in SFL (input-capable, position, valid values) |

### Function Keys

Specify as **CA** (command attention — no field validation) or **CF** (command function —
field validation occurs). Common keys: CA03 (Exit), CA05 (Refresh), CF06 (Add),
CA12 (Cancel), ENTER.

### Field Attributes

| Attribute | What to Specify |
|-----------|----------------|
| Usage | I (input-capable), O (output-only), B (both input/output), H (hidden) |
| Protection | Protected vs unprotected; indicator-conditioned protection |
| Display attributes | HI, RI, UL, BL, ND (non-display); indicator-conditioned attributes |
| Hidden fields | H usage for program-maintained fields not visible on screen |

### Indicator Usage (DSPF)

| Category | Purpose |
|----------|---------|
| Conditioning indicators | Control field visibility, protection, display attributes |
| Response indicators | Set by function keys (e.g., IN03 = F3 pressed) |
| Result indicators | Subfile selection, error conditions |
| SFLDSP / SFLDSPCTL / SFLCLR | Control subfile display behavior |

Every indicator referenced must have its purpose defined. No undefined indicators.

### Message Handling (DSPF)

If the screen uses message subfile or error line patterns:
- Define the message subfile format (SFLMSGRCD)
- Define the message subfile control format (SFLMSGKEY, SFLPGMQ)
- Specify which indicators trigger error messages
- Or specify ERRMSG/ERRMSGID keywords on individual fields

---

## PRTF Specification Depth

When execution mode is PRTF, the spec must address:

### Page Layout

| Element | What to Specify |
|---------|----------------|
| PAGESIZE | Lines per page, characters per line (e.g., 66 132) |
| OFLIND | Overflow indicator (e.g., OA or *IN99) |
| Overflow line | Line number triggering overflow (typically 60 of 66) |

### Spacing and Skip

| Keyword | Purpose |
|---------|---------|
| SPACEA(n) | Space n lines after printing |
| SPACEB(n) | Space n lines before printing |
| SKIPA(n) | Skip to line n after printing |
| SKIPB(n) | Skip to line n before printing |

### Format Sections

| Section | Purpose | Typical Content |
|---------|---------|-----------------|
| Header | Top of each page | Report title, date, page number, column headings |
| Detail | Per data record | Data fields |
| Total | Summary | Totals, counts, averages |
| Trailer | End of report | Grand totals, end marker |

### Edit Formatting

| Element | What to Specify |
|---------|----------------|
| Edit Code | EDTCDE(n) — standard IBM i codes (1, 2, 3, 4, J, etc.) |
| Edit Word | EDTWRD('pattern') — custom formatting |
| Date/time | DATFMT, TIMSEP for date/time fields |

---

## Change Spec Discipline

For changes to existing files, the default behavior is **delta-first**.

### Tagging

| Tag | Meaning |
|-----|---------|
| **(NEW)** | Introduced by this change |
| **(MODIFIED)** | Existing, changed in this spec |
| **(EXISTING — context only)** | Unchanged, included only when needed for clarity |

### Delta-First Rules

- Include only NEW and MODIFIED elements in full detail
- Include EXISTING elements only when they are direct dependencies of changed items
- Do not re-document the entire legacy file unless the user explicitly requests a full re-baseline
- Spec Summary must count: newly added, modified, and referenced-unchanged elements separately
- For additive changes (new fields, new key), omit unchanged field definitions entirely unless needed for key context

### Upstream Escalation

When missing information suggests unresolved business or design decisions rather than
simple file-detail gaps:

| Gap Type | Action |
|----------|--------|
| **Object-level TBD** | Mark TBD in Open Questions. Proceed with skeleton. Example: "Field length for CUSTREF — TBD (To Be Confirmed)" |
| **Upstream design gap** | Mark as "Requires upstream clarification in Functional Spec or Technical Design." Do not resolve within file spec. Example: "Whether order history is stored in ORDHDR or a separate ORDHIST file — design decision, not file spec scope" |

Distinguish these explicitly. A File Spec should not silently absorb design responsibility.

---

## Section Inclusion Table

| Section | L1 | L2 | L3 | Applicable Types |
|---------|----|----|-----|------------------|
| Spec Header | REQ | REQ | REQ | All |
| Amendment History | REQ | REQ | REQ | All |
| File Overview | REQ | REQ | REQ | All |
| Record Format(s) | REQ | REQ | REQ | All |
| Field Definitions | REQ | REQ | REQ | All |
| Key Definition | COND | REQ | REQ | PF, LF |
| Based-On Physical File(s) | COND | REQ | REQ | LF |
| Select/Omit Criteria | COND | COND | REQ | LF |
| Join Specification | COND | COND | REQ | LF (join) |
| Field Selection / Mapping | COND | COND | REQ | LF |
| Constraints | OMIT | COND | REQ | PF |
| Page Layout | COND | REQ | REQ | PRTF |
| Record Format Layout | COND | REQ | REQ | PRTF, DSPF |
| Screen Layout | COND | REQ | REQ | DSPF |
| Function Key Definitions | COND | REQ | REQ | DSPF |
| Subfile Definition | COND | COND | REQ | DSPF (subfile) |
| Indicator Usage | OMIT | COND | REQ | PRTF, DSPF |
| Field Validation | OMIT | COND | REQ | DSPF |
| Error Message Handling | OMIT | COND | REQ | DSPF |
| Edit Formatting | OMIT | COND | REQ | PRTF |
| Validation Rules | OMIT | COND | REQ | All |
| Business Rules | REQ | REQ | REQ | All |
| Related Objects | COND | REQ | REQ | All |
| Processing Considerations | OPT | COND | REQ | All |
| Change Impact | COND | COND | REQ | All |
| Confidence Assessment | OPT | COND | REQ | All |
| Open Questions / TBD | REQ | REQ | REQ | All |
| Spec Summary | REQ | REQ | REQ | All |

REQ = always include (N/A if empty). COND = include if relevant, omit if not.
OPT = include only if it adds value. OMIT = do not include at this level.

**Runtime enforcement:** after determining execution mode, process only rows where
Applicable Types includes the active file type. Ignore all other rows.

---

## Layer 1 Additions

**Spec Header** includes:
- Spec ID as global cross-spec identifier
- Change Impact: non-breaking / additive / breaking (change specs)
- Output Mode: Full / Skeleton / Change / Version

**Field Definitions** include: FLD-nn ID, Nullable (Yes/No → ALWNULL), Default (DFT),
CCSID (PF/LF).

**Validation Rules** (OMIT at L1, COND at L2, REQ at L3):

| Code | Description | Check | Severity |
|------|-------------|-------|----------|
| STRUCT-001 | Every field has type and length | All fields | ERROR |
| XREF-001 | Key fields exist in field definitions | keyDefinition → fieldDefinitions | ERROR |

**Change Impact** (COND for change specs):
- Classification, Rationale, Recompilation Required, Affected Objects

**Confidence Assessment** (OPT at L1, COND at L2, REQ at L3):
- Per-section confidence level (HIGH/MEDIUM/LOW), Overall Confidence

**Spec Summary** includes: Change Impact, Overall Confidence, Machine-Readable: Yes,
Output Mode.

---

## Core Rules

### Anti-Hallucination

- **No hallucination:** never invent field names, file names, library names, record format
  names, key definitions, indicators, or any IBM i object. Mark unknowns `TBD`.
- **No assumed structure:** never fill in field definitions, key structures, or layout
  positions not explicitly stated. Mark TBD and add to Open Questions.
- **Classification:** every piece of information is Stated, Inferred (labeled `(Inferred)`),
  or TBD. Never present Inferred as Stated. Never silently resolve TBD.
- **TBD propagation:** if a TBD in one section affects another, the downstream section
  carries the TBD forward.

### Structural Rules

- **Record format identity:** every format must have an explicit name.
- **Enhancement tagging:** change specs tag elements (NEW) / (MODIFIED) / (EXISTING — context only).
- **Field completeness:** every field requires name, type, length. Decimals required for
  numeric. Text/description required at L2+.
- **Key completeness** (PF/LF): key field(s), sort direction, uniqueness.
- **Based-on verification** (LF): based-on PF must be explicitly named.
- **Indicator discipline** (DSPF/PRTF): every referenced indicator must have a defined purpose.
- **Single-layer rule:** output is a file spec. Not DDS source, not program logic, not
  design commentary.
- **JSON completeness:** JSON is self-contained. Every Layer 1 element has a JSON
  representation. JSON must not depend on free-text for structural information.

### Artifact Boundary Enforcement

- The File Spec describes file-object structure only.
- If context requires architecture, batch flow, or program algorithm information, reference
  the upstream Technical Design — do not reproduce it.
- If missing information is an upstream design decision, escalate (see Upstream Escalation)
  rather than resolving within the file spec.
- **Processing Considerations scope guard (L3):** the Processing Considerations section
  describes file-object usage characteristics only — access patterns, typical open mode,
  locking/allocation behavior, expected volume, reorg/index rebuild sensitivity, commitment
  control posture. It does not describe user keystrokes, validation sequencing, transaction
  flow, screen navigation, or program algorithm steps. If content would read like program
  logic or interaction flow, defer to Program Spec.

---

## Quality Rules

Run applicable rules for the active execution mode and spec level. Skip rules for
sections that are OMIT or inapplicable.

**All levels:**
- [ ] Spec Header includes Spec Level, Change Type, File Type, Spec ID, Output Mode
- [ ] File Overview describes business purpose
- [ ] ≥1 Record Format with name and FMT-nn ID
- [ ] Field Definitions include FLD-nn, name, type, length for every field
- [ ] Numeric fields include decimals
- [ ] No names, IDs, or structures were invented
- [ ] All unknowns marked TBD; all inferences labeled (Inferred)
- [ ] Open Questions lists every TBD with source section
- [ ] Spec Summary counts are accurate
- [ ] Section Inclusion Table followed for spec level and file type
- [ ] Layer 2 JSON present and structurally complete
- [ ] Execution mode applied — no irrelevant file-type sections present

**L2 and L3:**
- [ ] Every field has text/description
- [ ] Key Definition complete (PF/LF)
- [ ] Related Objects populated
- [ ] Record Format Layout specified (PRTF/DSPF)
- [ ] Confidence Assessment present

**L3:**
- [ ] Processing Considerations addressed
- [ ] Constraints populated (PF)
- [ ] Indicator Usage documented (PRTF/DSPF)
- [ ] Validation Rules populated
- [ ] Change Impact assessed (change specs)

**Change specs:**
- [ ] Elements tagged (NEW) / (MODIFIED) / (EXISTING — context only)
- [ ] Delta-first applied: unchanged elements not re-documented unless needed for context
- [ ] Spec Summary separates new/modified/referenced counts
- [ ] Change Impact classification stated

**Version files:**
- [ ] Version Of in Spec Header
- [ ] PF version: format name matches source
- [ ] PF version: fields reference source (not redefined)
- [ ] LF version: Based-On PF stated

**PF/LF mode:**
- [ ] LF: Based-On PF populated
- [ ] LF: Select/Omit or Join defined if applicable

**DSPF mode:**
- [ ] Function Key Definitions documented (CA vs CF)
- [ ] Subfile: SFL format, SFLCTL, SFLSIZ, SFLPAG, SFLDSP/SFLDSPCTL/SFLCLR defined
- [ ] Field usage (I/O/B/H) specified for every field
- [ ] Indicator-conditioned display behavior defined

**PRTF mode:**
- [ ] Page Layout includes PAGESIZE, OFLIND, overflow line
- [ ] Spacing/skip defined for each format
- [ ] Edit codes/words specified for formatted fields
- [ ] Format sections identified (header/detail/total/trailer)

**JSON:**
- [ ] All IDs unique within spec
- [ ] Cross-references resolve
- [ ] Validation rules embedded
- [ ] Confidence and change impact in JSON
- [ ] Structurally valid and self-contained

**ID Preservation (when prior spec supplied):**
- [ ] Prior IDs matched and preserved
- [ ] Deleted IDs retired, not reused
- [ ] New IDs assigned only after preservation
- [ ] Ambiguous mappings flagged in Open Questions

---

## Reference Files

- `references/section-guide.md` — Section content guidance
- `references/tier-guide.md` — Spec level selection rules
- `references/json-schema.md` — Layer 2 JSON schema
- `references/interop-model.md` — Cross-spec reference model
- `references/validation-rules.md` — Machine-checkable validation rules
- `examples/sample-pf-spec.md` — L2 PF (new)
- `examples/sample-lf-spec.md` — L2 LF (select/omit)
- `examples/sample-prtf-spec.md` — L2 PRTF (report)
- `examples/sample-dspf-spec.md` — L3 DSPF (subfile)
- `examples/sample-pf-enhancement-spec.md` — L1 PF enhancement

---

## Relationship to Other Skills

| Skill | Relationship |
|-------|-------------|
| `ibm-i-technical-design` | Upstream — identifies which files are needed |
| `ibm-i-program-spec` | Peer — references files via fileSpecRef/fieldRef cross-spec IDs |
| `ibm-i-code-generator` | Downstream peer — generates code accessing files defined here |
| `ibm-i-dds-generator` | Downstream — consumes Layer 2 JSON to generate DDS source |
| `ibm-i-spec-reviewer` | Quality gate — reviews File Spec for completeness and JSON validity |
| `ibm-i-dds-reviewer` | Downstream quality gate — reviews DDS source generated from this spec |

### DDS Generator Consumption

```
File Spec JSON (Layer 2) → ibm-i-dds-generator → DDS Source (QDDSSRC)
```

The generator reads: `specHeader.fileType`, `fieldDefinitions`, `keyDefinition`,
`basedOnPhysicalFiles`, `selectOmitCriteria`, `joinSpecification`, `subfileDefinition`,
`indicatorUsage`, `functionKeyDefinitions`, `pageLayout`.

---

## Version Notes

**V2.1.2 (current).** Regression-test micro-patch on top of V2.1.1. Closes five wording
gaps surfaced by practical case testing (PF enhancement, new LF over PF, new DSPF
subfile): (1) extends record-format-name anti-default rule from PF to LF/DSPF/PRTF;
(2) adds explicit no-invented-value rules for DSPF row/col positions, indicator numbers,
and SFLEND/*MORE/message-subfile scaffolding; (3) adds LF field inheritance rule
(LF attributes inherit from based-on PF — mark TBD if PF unavailable, do not invent);
(4) adds ID Preservation rule 6 for the "existing file, no prior spec supplied" case;
(5) adds Processing Considerations scope guard at L3 to prevent drift into program logic.
No structural change, no new sections, no rework of existing rules.

**V2.1.1 baseline.** Stability patch on top of V2.1's execution-mode refactor. Inherits
from V2.1: execution-mode routing (PF/LF, DSPF, PRTF), DDS-first positioning, 5-step ID
preservation, minimum input contract with skeleton gating, DSPF depth (SFL/SFLCTL/SFLDSP/
SFLCLR, CA vs CF, message subfile), PRTF depth (PAGESIZE, OFLIND, spacing/skip, edit
codes), delta-first change specs, upstream escalation, output modes (Full/Skeleton/
Change/Version), and mode-scoped quality rules.

**V2.1.1 added:** no silent defaults in minimum input contracts, artifact-first gating
(Skeleton over clarification pauses), scoped Business Rules boundary, mode-local section
priority, fail-fast Skeleton classification, incompatible-section dropping, and the
downstream readiness distinction (structural completeness ≠ generation safety).

**Baseline:** V2.0 introduced dual-layer output (Markdown + JSON), cross-spec stable IDs,
tiered spec levels (L1/L2/L3), confidence tracking, and change impact classification.
All of those remain in V2.1.1.
