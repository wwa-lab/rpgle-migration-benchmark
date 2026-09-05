# Section Guide — IBM i File Spec (V2.0)

Detailed guidance on what belongs in each section of the File Spec.
See `tier-guide.md` for Spec Level selection rules.

---

## Spec Header

- **Spec ID**: Format `FILE-yyyymmdd-nn`. Example: `CUSTMAST-20260403-01`.
- **Spec Level**: `L1 Lite`, `L2 Standard`, or `L3 Full`. Determined in Step 1.
- **Version**: Starts at `1.0`. Increment on revision.
- **Status**: `Draft`, `Review`, or `Approved`.
- **Change Type**: `New File` or `Change to Existing`.
- **File Type**: `PF`, `LF`, `PRTF`, or `DSPF`.
- **File Name**: The DDS source member name if known, otherwise `TBD`.
- **Library**: Target library, or `TBD`.
- **Source File**: Typically `QDDSSRC`. State if different.
- **Description**: 1–2 sentences. What the file stores/displays/prints.

## Amendment History

| Version | Date | Author | Change Description |

First-time specs: one row with Version 1.0, date TBD, "Initial draft".

## File Overview

2–4 sentences describing the file's business purpose, what data it holds or presents,
and its role in the application. This is not a technical description — focus on why this
file exists from a business perspective.

For **version files**: explain why the version file exists (migration, archival, parallel
testing) and its relationship to the source file.

REQUIRED at all levels.

## Version File Information

When Spec Header includes a `Version Of` reference, this section documents the
relationship to the source file.

**PF Version File:**
- Source PF name and library
- Record format: "Same as source PF `<format name>`"
- Field differences: list only fields that differ from source (if any), or state
  "All fields inherited from source PF — no changes"
- Key differences: document if key differs from source

**LF Version File:**
- Source LF name (for reference/context)
- Based-on PF: the original PF or a version PF
- Record format: typically different from source LF — document the new format name
- Key/select/omit differences from source LF

CONDITIONAL — include only when `Version Of` is populated in Spec Header.

## Record Format(s)

| Format Name | Purpose | Fields Count |

Every DDS file has at least one record format. Name each format explicitly.

For PF: typically one record format. The format name is often the file name or a
shortened version (e.g., file CUSTMAST, format CUSTMASTR or CUSTR).

For LF: format name usually matches the PF format name unless fields are renamed.

For PRTF: may have multiple formats (header, detail, total, overflow).

For DSPF: may have multiple formats (header, detail, subfile record, subfile control,
footer, function key display).

REQUIRED at all levels.

## Field Definitions

The core section. Every field in every record format must be listed.

### PF / LF Field Table

| FLD ID | Field Name | Type | Length | Decimals | Nullable | Default | CCSID | Text | Edit Code | Column Heading | DDS Keywords | Notes |

- **FLD ID**: Stable field identifier (FLD-01, FLD-02, etc.). Assigned sequentially
  across all formats. Used for cross-spec referencing.
- **Field Name**: 1–10 characters, uppercase. Must match DDS naming conventions.
- **Type**: A (alpha), P (packed), S (zoned), B (binary), I (integer), F (float), L (date), T (time), Z (timestamp).
- **Length**: Total length. For packed, this is the number of digits.
- **Decimals**: Required for numeric types (P, S, B). Omit or blank for A, L, T, Z.
- **Nullable**: Yes/No. Maps to DDS ALWNULL keyword. Default No if not stated.
- **Default**: DDS DFT keyword value. Blank if no default.
- **CCSID**: Field-level CCSID override. Blank if using file/system default.
- **Text**: Field description (up to 50 characters). REQUIRED at L2 and L3.
- **Edit Code**: DDS edit code (1, 2, 3, 4, A, B, C, D, J, K, L, M, etc.) if applicable.
- **Column Heading**: 3-line column heading for query/report use. OPTIONAL.
- **DDS Keywords**: Additional DDS keywords (VARLEN, DATFMT, TIMFMT, etc.).
- **Notes**: Enhancement tags, change notes.

### PRTF Field Table

| FLD ID | Field Name | Type | Length | Decimals | Row | Col | Edit Code | Edit Word | Constant Text | Notes |

- **Row / Col**: Position on the printed page. Row is the line number, Col is the
  column number. Required for positioned fields.
- **Constant Text**: For literal text fields (column headers, labels).

### DSPF Field Table

| FLD ID | Field Name | Type | Length | Decimals | Row | Col | Usage (I/O/B/H) | Display Attr | Indicator | Notes |

- **Usage**: I (input), O (output), B (both input and output), H (hidden).
- **Display Attr**: UL (underline), HI (highlight), RI (reverse image), BL (blink),
  ND (non-display), PR (protect). Multiple attributes comma-separated.
- **Indicator**: Conditioning indicator(s) that control when this field is displayed.

For **change specs**: tag each field:
- `(NEW)` — field being added
- `(MODIFIED)` — field being changed (note what changed)
- `(EXISTING — unchanged)` — shown only for positional context

REQUIRED at all levels.

## Key Definition (PF / LF)

| # | Key Field | Sort Direction | Notes |

- **Key Field**: Must reference a field in the Field Definitions.
- **Sort Direction**: ASCEND (default) or DESCEND.
- **Unique**: State whether the key is UNIQUE or non-unique.
- **Access Path**: KEYED (most common) or ARRIVAL.

For LF: the key may differ from the PF key. This is the primary reason for creating
many logical files — to provide alternate access paths.

REQUIRED at L2 and L3 for PF/LF. CONDITIONAL at L1.

## Based-On Physical File(s) (LF only)

| Physical File | Library | Record Format | Notes |

Every logical file must declare which physical file(s) it is based on.

For simple (non-join) logicals: one physical file.
For join logicals: two or more physical files.

If the PF is unknown, mark TBD and add to Open Questions.

REQUIRED at L2 and L3. CONDITIONAL at L1.

## Select/Omit Criteria (LF only)

| # | Field | Comparison | Value(s) | Select/Omit | Notes |

- **Comparison**: EQ, NE, GT, GE, LT, LE, RANGE, VALUES, ALL.
- **Select/Omit**: S (select) or O (omit).

Select/omit criteria filter which records from the PF appear through this LF.
Order matters — DDS processes select/omit rules top to bottom.

CONDITIONAL at L1 and L2. REQUIRED at L3 when applicable.

## Join Specification (LF — join only)

| Join From | Join To | Join Field (From) | Join Field (To) | Join Type |

- **Join Type**: INNER (JDFTVAL not specified) or OUTER (JDFTVAL specified).

Join logicals combine records from two or more physical files. The join specification
defines the relationship between the files.

CONDITIONAL at L1 and L2. REQUIRED at L3 when applicable.

## Field Selection / Mapping (LF only)

| PF Field Name | LF Field Name | Action | Notes |

- **Action**: Include (use as-is), Rename (different name in LF), Redefine (different
  type/length), Omit (exclude from LF).

When all PF fields are included unchanged, write "All fields included from <PF name>".

CONDITIONAL at L1 and L2. REQUIRED at L3.

## Constraints (PF only)

| # | Constraint Type | Field(s) | Rule | Notes |

- **Constraint Type**: UNIQUE, CHECK, REFCST (referential).
- **Rule**: The constraint expression or referenced parent file.

OMIT at L1. CONDITIONAL at L2. REQUIRED at L3.

## Page Layout (PRTF only)

- **Page Size**: Lines x columns (e.g., 66 x 132).
- **Overflow Line**: The line number that triggers page overflow (e.g., 60).
- **Lines Per Inch**: 6 (standard) or 8 (compressed).
- **Characters Per Inch**: 10 (standard) or 15 (compressed).

CONDITIONAL at L1. REQUIRED at L2 and L3.

## Record Format Layout (PRTF / DSPF)

For each record format, describe the visual arrangement of fields and constants.

For PRTF: describe which lines contain headers, detail data, totals, and page overflow.
Include spacing before/after each format.

For DSPF: describe the screen area each format occupies. For subfile screens, describe
the subfile record area, control record area, and any header/footer formats.

CONDITIONAL at L1. REQUIRED at L2 and L3.

## Screen Layout (DSPF only)

- **Screen Size**: 24 x 80 (standard) or 27 x 132 (wide).
- **Display Attributes**: Global attributes that apply to the entire screen.

CONDITIONAL at L1. REQUIRED at L2 and L3.

## Function Key Definitions (DSPF only)

| Key | Action | Indicator | Notes |

Common function keys:
- F3 = Exit (CF03 / indicator 03)
- F5 = Refresh (CF05 / indicator 05)
- F6 = Add (CF06 / indicator 06)
- F12 = Cancel (CF12 / indicator 12)
- ENTER = Confirm / Submit
- PAGEUP / PAGEDOWN = Subfile paging (ROLLUP / ROLLDOWN)

**CF vs CA**: CF (Command Function) returns changed data. CA (Command Attention) does
not return data. Use CF when the program needs field values; use CA for cancel/exit.

CONDITIONAL at L1. REQUIRED at L2 and L3.

## Subfile Definition (DSPF — subfile only)

A subfile is a list display that shows multiple records at once. It requires:
- **Subfile Record Format**: the format for each row in the list
- **Subfile Control Format**: the format that controls the subfile display
- **Subfile Size (SFLSIZ)**: total records the subfile can hold
- **Subfile Page (SFLPAG)**: records displayed per page
- **SFLCLR**: indicator that clears the subfile before loading
- **SFLDSP**: indicator that displays the subfile records
- **SFLDSPCTL**: indicator that displays the subfile control format
- **SFLEND**: indicator or *MORE that controls end-of-list display

Common pattern: SFLSIZ = SFLPAG + 1 for page-at-a-time loading.

CONDITIONAL at L1 and L2. REQUIRED at L3 when applicable.

## Indicator Usage (PRTF / DSPF)

| Indicator | Purpose | Where Used |

Every indicator referenced in the spec must be documented here. Indicators are numbered
01–99 for general purpose, or use named indicators like *IN03 for function keys.

Common conventions:
- 01–20: General conditioning
- 21–40: Error and validation
- 41–60: Display control
- 61–80: Subfile and list control
- 81–99: Overflow and special

OMIT at L1. CONDITIONAL at L2. REQUIRED at L3.

## Field Validation (DSPF only)

| Field | Validation Type | Rule | Error Message |

- **CHECK**: ME (mandatory enter), MF (mandatory fill), AB (allow blanks), ER (entry required)
- **COMP**: EQ, NE, GT, GE, LT, LE against a value
- **VALUES**: list of valid values
- **RANGE**: minimum and maximum values

OMIT at L1. CONDITIONAL at L2. REQUIRED at L3.

## Error Message Handling (DSPF only)

| # | Message ID | Message Text | Field / Format | Indicator |

- **Message ID**: If using a message file (MSGF), specify the message ID.
- **Message Text**: If using ERRMSG keyword, specify the inline text.

OMIT at L1. CONDITIONAL at L2. REQUIRED at L3.

## Edit Formatting (PRTF only)

| Field | Edit Code | Edit Word | Notes |

Common edit codes:
- 1: Commas, decimal point, no sign, zero suppress
- 3: No commas, decimal point, no sign, zero suppress
- J: Commas, decimal point, minus sign, zero suppress
- Y: Date edit (slash-separated)
- Z: Zero suppress only

OMIT at L1. CONDITIONAL at L2. REQUIRED at L3.

## Business Rules

Format: `BR-xx: <condition or constraint>`

File-level business rules focus on data integrity, validation, and access control:
- Key uniqueness requirements
- Field validation constraints
- Select/omit logic rationale
- Display conditioning rules
- Print formatting rules

For change specs: tag as (NEW), (MODIFIED), (EXISTING — context only).

REQUIRED at all levels.

## Related Objects

| Object Name | Type | Relationship | Notes |

List programs, files, and other objects that interact with this file:
- Programs that read/write this file
- Physical files this LF is based on
- Logical files built over this PF
- Message files referenced by DSPF
- Print programs that use this PRTF

CONDITIONAL at L1. REQUIRED at L2 and L3.

## Processing Considerations

- **Journaling**: Is this file journaled? Required for commitment control.
- **Authority**: Object authority settings (*PUBLIC, *CHANGE, *USE, *EXCLUDE).
- **CCSID**: Character set if non-default.
- **Record Length**: Calculated total record length (useful for PF sizing).
- **Member Policy**: Single-member (default) or multi-member.

OPTIONAL at L1. CONDITIONAL at L2. REQUIRED at L3.

## Open Questions / TBD

| # | Section | Question |

Every TBD in the spec must appear here. REQUIRED at all levels.

## Spec Summary

- **Spec Level**: L1 / L2 / L3
- **Change Type**: New File / Change to Existing
- **File Type**: PF / LF / PRTF / DSPF
- **Total Record Formats**: count
- **Total Fields**: count (new, modified)
- **Total Key Fields**: count
- **Total Business Rules**: count
- **Total Open Questions**: count

REQUIRED at all levels.
