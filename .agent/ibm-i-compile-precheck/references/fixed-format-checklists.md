# Fixed-Format RPGLE Compile-Safety Checklists

Reusable reference for the `ibm-i-compile-precheck` skill. Each checklist can be run
independently or as part of a full precheck scan.

---

## CL1: Fixed-Format Opcode Safety

**Purpose:** Catch BIF/opcode combinations that fail on the IBM i compiler or produce
unexpected results in fixed-format C-specs.

### Dangerous Patterns

| # | Pattern | Risk Level | Symptom | Safe Alternative |
|---|---------|-----------|---------|-----------------|
| 1 | `%SUBST()` in Factor 2 of `MOVE`/`MOVEL` | Blocker | RNF7535 or similar compile error | `EVAL wk = %SUBST(src:pos:len)` then `MOVEL wk TARGET` |
| 2 | `%TRIM()`/`%TRIMR()` in Factor 2 of `MOVE`/`MOVEL` | Blocker | Compile error on some levels | `EVAL wk = %TRIM(src)` then `MOVEL wk TARGET` |
| 3 | `%TRIM()` in Factor 2 of `CAT` | Blocker | `CAT` does not support BIFs in factors | `EVAL wk = %TRIM(src)` then `CAT` with `wk` |
| 4 | Nested BIFs in Factor 1 (e.g., `%SUBST(%TRIM(x))`) | Blocker | Fixed-format factors do not support nesting | Break into sequential `EVAL` steps |
| 5 | `MOVE` between packed and alpha without `MOVE(P)` | Warning | Silent data corruption | Use `MOVE(P)` or explicit `%CHAR()`/`%DEC()` conversion |
| 6 | `EVAL` result field shorter than expression | Warning | Silent right-truncation | Verify target field length |
| 7 | `SCAN`/`CHECK` with result field too short | Warning | Truncated position value | Use a field at least as long as the source |

### Safe Replacement Patterns

```rpgle
C* UNSAFE: BIF in Factor 2 of MOVEL
C                   MOVEL     %SUBST(SOURCE:1:10)          TARGET

C* SAFE: staged via EVAL
C                   EVAL      wkStage = %SUBST(SOURCE:1:10)
C                   MOVEL     wkStage       TARGET

C* UNSAFE: %TRIM in CAT
C     %TRIM(FLD1)   CAT       %TRIM(FLD2):1  RESULT

C* SAFE: staged via EVAL
C                   EVAL      wk1 = %TRIM(FLD1)
C                   EVAL      wk2 = %TRIM(FLD2)
C                   EVAL      RESULT = wk1 + ' ' + wk2
```

---

## CL2: KLIST / KFLD Completeness

**Purpose:** Ensure every keyed file access has a complete, correct key list definition.

| # | Check | What to Look For |
|---|-------|-----------------|
| 1 | Every `CHAIN`/`SETLL`/`SETGT` that uses a KLIST → the KLIST exists | Search for KLIST name in D-specs or C-specs |
| 2 | KFLD count matches file key count | Compare KFLD entries against known key fields |
| 3 | KFLD field types are compatible with key field types | Packed key field → packed KFLD, alpha → alpha, etc. |
| 4 | KFLD field lengths are sufficient | KFLD field must be ≥ key field length |
| 5 | No orphaned KLISTs (defined but never used in CHAIN/SETLL/SETGT) | Declaration hygiene |
| 6 | Composite keys have KFLDs in the correct order | Match physical file key sequence |

---

## CL3: File / Record-Format Alias Consistency

**Purpose:** Ensure I/O opcodes target the correct name — file name vs record format name.

| # | Check | Rule |
|---|-------|------|
| 1 | F-spec with `RENAME` → I/O opcodes must use the renamed format name | `CHAIN SSCUSTR` not `CHAIN SSCUSTP` |
| 2 | F-spec without `RENAME` → I/O opcodes use the default format name (usually same as file name) | Verify against actual file definition |
| 3 | `UPDATE` target matches the format read by the preceding `CHAIN`/`READ` | Same format name |
| 4 | `WRITE` target is a valid output-capable format | Check F-spec I/O type |
| 5 | No I/O opcode targets a name that is neither a declared file nor a declared/renamed format | Flag undefined targets |

---

## CL4: Array / Index / Occurrence Safety

**Purpose:** Prevent array-out-of-bounds and occurrence-out-of-range errors.

| # | Check | Rule |
|---|-------|------|
| 1 | Array access (`ARR(idx)`) → `idx` is bounds-checked before use | `IF idx <= %ELEM(ARR)` or equivalent |
| 2 | `OCCUR` opcode → occurrence is set before DS field access | `OCCUR` before any field reference |
| 3 | Loop counters used as array indexes → loop has explicit upper bound | `DO %ELEM(ARR)` or `DOW idx <= maxIdx` |
| 4 | `DIM` / `OCCURS` values are consistent with spec or reference | Flag mismatches |
| 5 | No negative or zero index values possible | Check counter initialization |

---

## CL5: Response-Cap and Silent-Truncation Safety

**Purpose:** Catch cases where data is silently lost due to overflow or truncation.

| # | Check | Rule |
|---|-------|------|
| 1 | Response array/list with cap → overflow path exists (stop, flag, or wrap) | No silent drop of records beyond cap |
| 2 | String concatenation → result fits in target field | Target length ≥ sum of source lengths |
| 3 | Numeric assignment → target has sufficient digits and decimals | No precision loss |
| 4 | `%SUBST` target → start + length does not exceed field boundary | Bounds check |
| 5 | `EVAL` with packed → zoned or vice versa → no implicit length mismatch | Explicit length verification |

---

## CL6: Declaration Hygiene

**Purpose:** Flag unused or duplicate declarations that indicate drafting leftovers.

| # | Check | Rule |
|---|-------|------|
| 1 | Declared files (`F`-spec) are referenced by at least one I/O opcode | Flag unreferenced files |
| 2 | Declared standalone fields are referenced in C-specs or expressions | Flag unreferenced fields |
| 3 | Declared data structures are referenced | Flag unreferenced DS |
| 4 | Declared constants are referenced | Flag unreferenced constants |
| 5 | No duplicate names at the same scope | Flag duplicates |
| 6 | Distinguish true dead code from intentionally reserved fields | If the reference source style keeps certain fields for structural reasons, note as Info, not Warning |
