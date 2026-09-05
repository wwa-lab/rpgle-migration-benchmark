# Example: L2 Standard — New Physical File (PF)

## Scenario

A new customer master physical file for an order management system.

---

## Spec Header

- **Spec ID:** CUSTMAST-20260403-01
- **Spec Level:** L2 Standard
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** New File
- **File Type:** PF
- **File Name:** CUSTMAST
- **Library:** ORDLIB
- **Source File:** QDDSSRC
- **Description:** Customer master file storing core customer data for order processing.

---

## Amendment History

| Version | Date | Author | Change Description |
|---------|------|--------|--------------------|
| 1.0     | TBD  | TBD    | Initial draft      |

---

## File Overview

Stores master customer records for the order management system. Each record represents
one customer with identification, contact, and credit information. Referenced by order
entry, invoice, and reporting programs.

---

## Record Format(s)

| Format Name | Purpose | Fields Count |
|-------------|---------|-------------|
| CUSTR | Customer master record | 10 |

---

## Field Definitions

### CUSTR

| Field Name | Type | Length | Decimals | Text | Edit Code | Column Heading | Notes |
|------------|------|--------|----------|------|-----------|----------------|-------|
| CUSTID | A | 10 | | Customer ID | | CUS / ID | Key field |
| CUSTNM | A | 40 | | Customer name | | CUST / NAME | |
| ADDR1 | A | 40 | | Address line 1 | | ADDR / LINE1 | |
| ADDR2 | A | 40 | | Address line 2 | | ADDR / LINE2 | ALWNULL |
| CITY | A | 30 | | City | | CITY | |
| STATE | A | 2 | | State code | | ST | |
| ZIPCD | A | 10 | | Postal code | | ZIP / CODE | |
| CRLMT | P | 11 | 2 | Credit limit | 1 | CREDIT / LIMIT | |
| ACTSTS | A | 1 | | Active status | | ACT / STS | A=Active, I=Inactive |
| LSTUPD | L | 10 | | Last update date | Y | LAST / UPDATE | |

---

## Key Definition

| # | Key Field | Sort Direction | Notes |
|---|-----------|---------------|-------|
| 1 | CUSTID | ASCEND | Primary key |

- **Unique:** Yes
- **Access Path:** Keyed

---

## Business Rules

1. BR-01: CUSTID must be unique across all records
2. BR-02: ACTSTS must be either 'A' (Active) or 'I' (Inactive)
3. BR-03: CRLMT must be zero or positive

---

## Related Objects

| Object Name | Type | Relationship | Notes |
|-------------|------|-------------|-------|
| CUSTMASTL1 | LF | Logical over this PF | Keyed by CUSTNM for name lookup |
| ORDENTRY | PGM (RPGLE) | Reads and updates | Order entry program |
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
- **File Type:** PF
- **Total Record Formats:** 1
- **Total Fields:** 10
- **Total Key Fields:** 1
- **Total Business Rules:** 3
- **Total Open Questions:** 0
