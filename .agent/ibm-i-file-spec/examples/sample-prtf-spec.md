# Example: L2 Standard — New Printer File (PRTF)

## Scenario

A customer listing report with header (title, date, page number, column headings),
detail (one line per customer), and total (customer count) record formats.

---

## Spec Header

- **Spec ID:** CUSTRPT-20260404-01
- **Spec Level:** L2 Standard
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** New File
- **File Type:** PRTF
- **File Name:** CUSTRPTF
- **Library:** ORDLIB
- **Source File:** QDDSSRC
- **Description:** Customer listing report printer file.

---

## Amendment History

| Version | Date | Author | Change Description |
|---------|------|--------|--------------------|
| 1.0     | TBD  | TBD    | Initial draft      |

---

## File Overview

Printer file for the customer listing report. Produces a formatted listing of customers
with name, city, state, and active status. Used by the CUSTRPT program.

---

## Record Format(s)

| Format Name | Purpose | Fields Count |
|-------------|---------|-------------|
| PRTHDR | Report header — title, date, page number, column headings | 3 fields + constants |
| PRTDTL | Detail line — one customer per line | 5 fields |
| PRTTOT | Total line — customer count | 1 field + constant |

---

## Field Definitions

### PRTHDR

| FLD ID | Field Name | Type | Length | Decimals | Row | Col | Edit Code | Edit Word | Constant Text | Notes |
|--------|------------|------|--------|----------|-----|-----|-----------|-----------|---------------|-------|
| FLD-01 | | | | | 1 | 2 | | | CUSTOMER LISTING | Constant — report title |
| FLD-02 | RPTDTE | L | 10 | | 1 | 61 | Y | | | Report date |
| FLD-03 | RPTPAG | S | 4 | 0 | 1 | 125 | Z | | | Page number |
| FLD-04 | | | | | 1 | 118 | | | PAGE: | Constant — page label |
| FLD-05 | | | | | 3 | 2 | | | CUST ID | Column heading |
| FLD-06 | | | | | 3 | 15 | | | NAME | Column heading |
| FLD-07 | | | | | 3 | 58 | | | CITY | Column heading |
| FLD-08 | | | | | 3 | 90 | | | STATE | Column heading |
| FLD-09 | | | | | 3 | 96 | | | STATUS | Column heading |

### PRTDTL

| FLD ID | Field Name | Type | Length | Decimals | Row | Col | Edit Code | Edit Word | Constant Text | Notes |
|--------|------------|------|--------|----------|-----|-----|-----------|-----------|---------------|-------|
| FLD-10 | PCUSTID | A | 10 | | 6 | 2 | | | | Customer ID |
| FLD-11 | PCUSTNM | A | 40 | | 6 | 15 | | | | Customer name |
| FLD-12 | PCITY | A | 30 | | 6 | 58 | | | | City |
| FLD-13 | PSTATE | A | 2 | | 6 | 90 | | | | State code |
| FLD-14 | PACTSTS | A | 1 | | 6 | 96 | | | | Active status |

### PRTTOT

| FLD ID | Field Name | Type | Length | Decimals | Row | Col | Edit Code | Edit Word | Constant Text | Notes |
|--------|------------|------|--------|----------|-----|-----|-----------|-----------|---------------|-------|
| FLD-15 | | | | | 8 | 2 | | | TOTAL CUSTOMERS: | Constant — label |
| FLD-16 | PTOTAL | P | 7 | 0 | 8 | 22 | Z | | | Total customer count |

---

## Page Layout

- **Page Size:** 66 x 132
- **Overflow Line:** 60
- **Lines Per Inch:** 6
- **Characters Per Inch:** 10

---

## Record Format Layout

### PRTHDR (Header)

- **Spacing Before:** 1
- Row 1: Report title (left), date (center-right), page number (far right)
- Rows 3-4: Column headings with underline separator

### PRTDTL (Detail)

- **Spacing Before:** 1
- Single line per customer, fields aligned with column headings

### PRTTOT (Total)

- **Spacing Before:** 2 (double space before totals)
- Total customer count with label

---

## Business Rules

1. BR-01: Report prints one line per customer from CUSTMAST
2. BR-02: Page overflow at line 60 triggers new page with header reprint

---

## Related Objects

| Object Name | Type | Relationship | Notes |
|-------------|------|-------------|-------|
| CUSTMAST | PF | Read by | Source data file |
| CUSTRPT | PGM (RPGLE) | Used by | Report program |

---

## Open Questions / TBD

| # | Section | Question |
|---|---------|----------|
| — | — | None |

---

## Spec Summary

- **Spec Level:** L2
- **Change Type:** New File
- **File Type:** PRTF
- **Total Record Formats:** 3
- **Total Fields:** 16 (7 data fields + 9 constants)
- **Total Key Fields:** 0
- **Total Business Rules:** 2
- **Total Open Questions:** 0
