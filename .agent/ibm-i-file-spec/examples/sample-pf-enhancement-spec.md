# Example: L1 Lite — PF Enhancement (Add Fields)

## Scenario

Add email address and phone number fields to the existing CUSTMAST physical file.

---

## Spec Header

- **Spec ID:** CUSTMAST-20260403-02
- **Spec Level:** L1 Lite
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** Change to Existing
- **File Type:** PF
- **File Name:** CUSTMAST
- **Library:** ORDLIB
- **Source File:** QDDSSRC
- **Description:** Add email and phone fields to customer master file.

---

## Amendment History

| Version | Date | Author | Change Description |
|---------|------|--------|--------------------|
| 1.0     | TBD  | TBD    | Add EMAIL and PHONE fields |

---

## File Overview

Add customer contact fields (email address and phone number) to the existing customer
master file to support the new customer notification feature.

---

## Record Format(s)

| Format Name | Purpose | Fields Count |
|-------------|---------|-------------|
| CUSTR | Customer master record | 12 (10 existing + 2 new) |

---

## Field Definitions

### CUSTR

| Field Name | Type | Length | Decimals | Text | Notes |
|------------|------|--------|----------|------|-------|
| CUSTID | A | 10 | | Customer ID | (EXISTING — unchanged) Key field |
| CUSTNM | A | 40 | | Customer name | (EXISTING — unchanged) |
| EMAIL | A | 60 | | Email address | **(NEW)** |
| PHONE | A | 15 | | Phone number | **(NEW)** |

Only new and contextual fields shown. 8 additional existing fields unchanged.

---

## Business Rules

1. BR-01 (NEW): EMAIL may be blank but if provided must contain '@' character
2. BR-02 (NEW): PHONE may be blank — no format validation at file level

---

## Open Questions / TBD

| # | Section | Question |
|---|---------|----------|
| 1 | Field Definitions | Confirm EMAIL length of 60 is sufficient for business needs |
| 2 | Related Objects | Which programs need to be updated to populate the new fields? |

---

## Spec Summary

- **Spec Level:** L1
- **Change Type:** Change to Existing
- **File Type:** PF
- **Total Record Formats:** 1
- **Total Fields:** 12 (2 new, 0 modified)
- **Total Key Fields:** 1 (unchanged)
- **Total Business Rules:** 2 (2 new)
- **Total Open Questions:** 2
