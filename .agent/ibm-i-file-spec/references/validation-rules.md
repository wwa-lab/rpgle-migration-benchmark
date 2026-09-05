# Validation Rules — IBM i File Spec (V2.0)

Machine-checkable validation rules embedded in the File Spec JSON layer.
These are programmatic assertions a validator can execute against the JSON.

---

## Rule Categories

| Category | Purpose | Applies To |
|----------|---------|------------|
| `structural` | Field-level completeness and naming | All types |
| `crossField` | Internal cross-references resolve | All types |
| `lfPfConsistency` | LF fields match based-on PF | LF only |
| `versionFileConsistency` | Version file patterns respected | Version files only |
| `specSummaryAccuracy` | Summary counts match actual | All types |
| `sectionInclusion` | Required sections present | All types |
| `tierSpecific` | Tier-dependent quality rules | All types |

---

## Structural Rules

| Code | Description | Severity | Types |
|------|-------------|----------|-------|
| STRUCT-001 | Every field has type and length | ERROR | All |
| STRUCT-002 | Numeric fields (P,S,B) have decimals specified | ERROR | All |
| STRUCT-003 | Field names are 1-10 uppercase chars or TBD | ERROR | All |
| STRUCT-004 | Every record format has a name | ERROR | All |
| STRUCT-005 | DSPF non-hidden fields have row and col | ERROR | DSPF |
| STRUCT-006 | PRTF fields have row and col | ERROR | PRTF |
| STRUCT-007 | DSPF fields have usage (I/O/B/H) | ERROR | DSPF |
| STRUCT-008 | File name is 1-10 uppercase chars or TBD | ERROR | All |
| STRUCT-009 | Field IDs are unique within the spec | ERROR | All |
| STRUCT-010 | Format IDs are unique within the spec | ERROR | All |

---

## Cross-Field Rules

| Code | Description | Severity | Types |
|------|-------------|----------|-------|
| XREF-001 | Key field names exist in field definitions | ERROR | PF, LF |
| XREF-002 | Key field refs are valid field IDs | ERROR | PF, LF |
| XREF-003 | Subfile format refs exist in record formats | ERROR | DSPF |
| XREF-004 | Function key indicator refs exist in indicator usage | ERROR | DSPF |
| XREF-005 | Subfile indicator refs exist in indicator usage | ERROR | DSPF |
| XREF-006 | Field validation field refs exist in field definitions | ERROR | DSPF |
| XREF-007 | Error message indicator refs exist in indicator usage | ERROR | DSPF |
| XREF-008 | Error message field refs exist in field definitions | ERROR | DSPF |
| XREF-009 | Constraint field refs exist in field definitions | ERROR | PF |
| XREF-010 | Business rule field refs exist in field definitions | WARNING | All |
| XREF-011 | Select/omit field refs exist in based-on PF fields | ERROR | LF |
| XREF-012 | Edit formatting field refs exist in field definitions | ERROR | PRTF |
| XREF-013 | Field condition indicator refs exist in indicator usage | ERROR | PRTF, DSPF |
| XREF-014 | Indicator whereUsed format refs exist in record formats | ERROR | PRTF, DSPF |

---

## LF-PF Consistency Rules

These require loading the referenced PF spec. If unavailable, downgrade to WARNING.

| Code | Description | Severity |
|------|-------------|----------|
| LFPF-001 | LF field names exist in based-on PF field definitions | ERROR |
| LFPF-002 | When all fields included, LF format name should match PF format name | WARNING |
| LFPF-003 | Join LF join-from and join-to files exist in basedOnPhysicalFiles | ERROR |

---

## Version File Consistency Rules

| Code | Description | Severity |
|------|-------------|----------|
| VER-001 | PF version: record format name matches source PF | ERROR |
| VER-002 | Version file: Change Type is "New File" | ERROR |
| VER-003 | LF version: basedOnPhysicalFiles is populated | ERROR |

---

## Spec Summary Accuracy Rules

| Code | Description | Severity |
|------|-------------|----------|
| SUM-001 | totalFields matches actual field count | ERROR |
| SUM-002 | totalRecordFormats matches actual format count | ERROR |
| SUM-003 | totalKeyFields matches actual key count | ERROR |
| SUM-004 | totalBusinessRules matches actual rule count | ERROR |
| SUM-005 | totalOpenQuestions matches actual open question count | ERROR |
| SUM-006 | newFields matches fields with changeTag="NEW" | ERROR |
| SUM-007 | modifiedFields matches fields with changeTag="MODIFIED" | ERROR |

---

## Section Inclusion Rules

| Code | Description | Severity |
|------|-------------|----------|
| SEC-001 | All REQUIRED sections for spec level and file type are present | ERROR |
| SEC-002 | OMIT sections for spec level are absent | WARNING |

---

## Tier-Specific Rules

| Code | Description | Severity |
|------|-------------|----------|
| TIER-001 | L2/L3 fields have text descriptions | ERROR |
| TIER-002 | Change specs have at least one non-null changeTag | WARNING |
| TIER-003 | L3 Processing Considerations are populated | ERROR |

---

## Execution Model

A validator tool reads the spec JSON and executes rules as follows:

1. Check if the rule applies (file type filter, spec level filter)
2. Evaluate the assertion against the spec data
3. Collect results: `{ ruleCode, passed, details }`

Results:
- `passed: true` — rule satisfied
- `passed: false` — violation found
- `passed: null` — rule skipped (referenced spec unavailable, or rule not applicable)

Rules are grouped by category for structured reporting.
