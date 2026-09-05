# Example: L2 Standard — New Logical File (LF) with Select/Omit

## Scenario

A logical file over the customer master (CUSTMAST) that provides access to active
customers only, keyed by customer name for alphabetical lookup.

---

## Spec Header

- **Spec ID:** CUSTACTV-20260403-01
- **Spec Level:** L2 Standard
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** New File
- **File Type:** LF
- **File Name:** CUSTACTV
- **Library:** ORDLIB
- **Source File:** QDDSSRC
- **Description:** Active customers logical file, keyed by customer name for alphabetical lookup.

---

## Amendment History

| Version | Date | Author | Change Description |
|---------|------|--------|--------------------|
| 1.0     | TBD  | TBD    | Initial draft      |

---

## File Overview

Provides an alphabetical view of active customers over the CUSTMAST physical file. Used
by customer search and reporting programs that need to list or look up customers by name.
Only active customers (ACTSTS = 'A') appear through this logical.

---

## Record Format(s)

| Format Name | Purpose | Fields Count |
|-------------|---------|-------------|
| CUSTR | Customer record (same format as PF) | 10 |

---

## Field Definitions

### CUSTR

All fields included from CUSTMAST (no field changes).

---

## Key Definition

| # | Key Field | Sort Direction | Notes |
|---|-----------|---------------|-------|
| 1 | CUSTNM | ASCEND | Alternate key for name lookup |

- **Unique:** No (multiple customers could share a name)
- **Access Path:** Keyed

---

## Based-On Physical File(s)

| Physical File | Library | Record Format | Notes |
|---------------|---------|---------------|-------|
| CUSTMAST | ORDLIB | CUSTR | Customer master |

---

## Select/Omit Criteria

| # | Field | Comparison | Value(s) | Select/Omit | Notes |
|---|-------|------------|----------|-------------|-------|
| 1 | ACTSTS | EQ | 'A' | Select | Only active customers |

---

## Field Selection / Mapping

All fields included from CUSTMAST. No renaming or redefinition.

---

## Business Rules

1. BR-01: Only records with ACTSTS = 'A' are visible through this logical file

---

## Related Objects

| Object Name | Type | Relationship | Notes |
|-------------|------|-------------|-------|
| CUSTMAST | PF | Based-on physical file | Customer master |
| CUSTSRCH | PGM (RPGLE) | Reads | Customer search program |
| CUSTRPT | PGM (RPGLE) | Reads | Customer listing report |

---

## Open Questions / TBD

| # | Section | Question |
|---|---------|----------|
| — | — | None |

---

## Spec Summary

- **Spec Level:** L2
- **Change Type:** New File
- **File Type:** LF
- **Total Record Formats:** 1
- **Total Fields:** 10 (all from PF)
- **Total Key Fields:** 1
- **Total Business Rules:** 1
- **Total Open Questions:** 0
