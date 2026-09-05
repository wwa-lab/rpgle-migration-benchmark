# Section Guide — IBM i Program Spec (V2.5)

Detailed guidance on what belongs in each section of the Program Spec.
See `references/tier-guide.md` for Spec Level selection rules.

---

## Spec Header

- **Spec ID**: Format `PROG-yyyymmdd-nn`. Example: `ORDCONF-20260401-01`.
- **Spec Level**: `L1 Lite`, `L2 Standard`, or `L3 Full`. Determined in Step 1.
- **Version**: Starts at `1.0`. Increment on revision.
- **Status**: `Draft`, `Review`, or `Approved`.
- **Change Type**: `New Program` or `Change to Existing`.
- **Program Type**: `RPGLE` or `CLLE`.
- **Program Name**: The *PGM object name if known, otherwise `TBD`.
- **Description**: 1–2 sentences. What the program does (or what the change accomplishes).

## Amendment History

| Version | Date | Author | Change Description |

First-time specs: one row with Version 1.0, date TBD, "Initial draft".

## Caller Context

Who calls this program and what do they expect?
- **Called by**: Program, scheduler, command, or menu option.
- **Trigger**: Business event that causes execution.
- **Expected behavior on success/failure**: What the caller does with each return.

REQUIRED at L3. CONDITIONAL at L2 (include if the change affects the caller contract).
OPTIONAL at L1.

## Functions

Each function: one sentence, imperative form, describes WHAT not HOW.
REQUIRED at L2 and L3. OPTIONAL at L1 (typically omitted for small changes).

For change specs: include only functions that are new or modified. Tag with (NEW) or
(MODIFIED). Include (EXISTING) functions only if needed for context.

## Business Rules

Format: `BR-xx: <condition or constraint>`

- One rule per line, atomic, independently testable
- Every IF/ELSE/condition in Main Logic must trace to a BR-xx
- TBD rules go to Open Questions

For change specs:
- `BR-01 (NEW): <rule>` — did not exist before
- `BR-02 (MODIFIED): <old rule → new rule>` — existed, being changed
- `BR-03 (EXISTING — context only): <rule>` — unchanged, shown for reference

## Interface Contract

### Program Parameters

| Name | Type | Length | Input/Output | Valid Values | Description |

- **Type**: CHAR, PACKED, ZONED, DATE, TIMESTAMP, IND, etc.
- **Length**: Including decimals where applicable (e.g., `PACKED(7,2)`).
- **Valid Values**: Enumerated values, range, or constraint. Essential for test generation.

### Return Code Definition

| Code | Meaning | Caller Action |

Every return code the program can set must appear. Each code implies at least one test.

REQUIRED at L2 and L3. CONDITIONAL at L1 (include if parameters change).

## Data Contract

| Field Name | Source | Storage | Read by Steps | Written by Steps | Notes |

- **Source**: Param, File, Derived, Constant
- **Storage**: Persisted, Display, Transient
- **Read/Written by Steps**: Step numbers from Main Logic

REQUIRED at L3. CONDITIONAL at L2 (include if change introduces or modifies fields).
OMIT at L1.

For change specs: tag fields as (NEW), (MODIFIED), or (EXISTING — unchanged).

## File Usage

| File Name | Type (I/O/U) | Key Field(s) | Access Pattern | Description |

- **Key Field(s)**: Critical for test data setup and impact analysis.
- **Access Pattern**: Declares the expected record cardinality for each key access. This
  directly controls which I/O opcode pattern the Code Generator will use:
  - **1:1** — unique key, single record expected → `CHAIN`
  - **1:N** — partial key, multiple records expected → `SETLL` + `READE` loop
  - **Sequential** — full-file sequential read → `READ` loop
  If the key is a partial key (e.g., order number against an order-detail file where
  multiple detail lines exist per order), always mark **1:N**. If unsure whether the key
  is unique, mark `TBD (1:1 or 1:N — confirm key uniqueness)` and add to Open Questions.

REQUIRED at L2 and L3. CONDITIONAL at L1 (include if file access changes).

## Data Queue / Data Area

Include name, library, direction/value, data type. REQUIRED at L3. CONDITIONAL at L2
and L1.

## External / Internal Data Structure

REQUIRED at L3. CONDITIONAL at L2. OMIT at L1.

## External Program Calls

| Program | Purpose | Parameters Passed | Expected Return |

REQUIRED at L3. CONDITIONAL at L2 and L1.

## External Subroutines / Standard Subroutines

REQUIRED at L3. CONDITIONAL at L2. OMIT at L1.

## Constants

| Name | Value | Description |

REQUIRED at L3. CONDITIONAL at all other levels.

## Program Processing — Main Logic

Numbered steps. One logical action per step.

Step notation:
- `IF condition → action (BR-xx)`
- `FOR EACH record in <file> by <key> → <action>` (use when File Usage shows 1:N access)
- `IF condition → action / ELSE → alternative`
- `READ <file> by <key>` (use when File Usage shows 1:1 access)

Additional rules:
- Every file operation names the file and key
- Every field mutation references a Data Contract field (L2/L3)
- Every conditional references a BR-xx

For change specs, tag steps:
- `Step 3 (NEW): <action>`
- `Step 5 (MODIFIED): <old behavior → new behavior>`
- `Step 4 (EXISTING — context only): <action>`

## Program Processing — File Output / Update

| File | Action | Fields Modified | Condition |

REQUIRED at L2 and L3. CONDITIONAL at L1.

## Error Handling

| Scenario | Return Code | Action | Logged? |

Four mandatory categories at ALL levels:
- Validation Error
- Data Not Found
- Update Failure
- System Error

Return Code must match a value in the Return Code Definition.

## Traceability Matrix

| BR | Rule Summary | Logic Step(s) | Error Handling Row | File(s) Affected |

Every BR-xx must appear. Gaps flagged as "NOT IMPLEMENTED".
REQUIRED at L2 and L3. OMIT at L1.

## Processing Considerations

- **Performance**
- **Locking / commitment control**
- **Batch vs online**

REQUIRED at L3. CONDITIONAL at L2. OPTIONAL at L1.

## Compile-Oriented Constraints

Captures compile-level structural facts that the downstream code generator needs for safe
generation — record format names, key list compositions, access pattern intent, reference
source member, and array/response cap policy.

This section is distinct from File Usage (which names files and their purpose) and from
Processing Considerations (which covers performance and locking). Compile-Oriented
Constraints captures the naming and structural details that bridge the gap between spec-level
file references and actual compilable code.

REQUIRED at L3. CONDITIONAL at L2 (include for fixed-format RPGLE enhancement work). OMIT at L1.

## Programming Language

`RPGLE` or `CLLE`. REQUIRED at all levels.

## Amend Data Structure

REQUIRED at L3. OPTIONAL at L2 and L1.

## Open Questions / TBD

| # | Section | Question |

Every TBD in the spec must appear here. REQUIRED at all levels.

## Spec Summary

- **Spec Level**: L1 / L2 / L3
- **Change Type**: New Program / Change to Existing
- **Total Business Rules**: count (new, modified)
- **Total Main Logic Steps**: count (new, modified)
- **Total Files Used**: count
- **Total External Calls**: count
- **Total Open Questions**: count
- **Traceability Complete**: Yes / No (L2/L3 only)

REQUIRED at all levels.
