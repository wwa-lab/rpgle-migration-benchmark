# Sample L1 Lite Spec — Change Validation Threshold

Calibration example showing the L1 Lite format for a small, isolated change.

---

**Requirement**: In the order confirmation program, change the credit limit check from
$5,000 to $10,000. Orders above the new limit must be rejected with return code '1'.

**Program Type**: RPGLE
**Change Type**: Change to Existing

---

## Spec Header

- **Spec ID:** ORDCONF-20260401-02
- **Spec Level:** L1 Lite
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** Change to Existing
- **Program Type:** RPGLE
- **Program Name:** TBD
- **Description:** Increase the credit limit validation threshold from $5,000 to $10,000 in the order confirmation program.

---

## Amendment History

| Version | Date       | Author | Change Description                  |
|---------|------------|--------|-------------------------------------|
| 1.0     | 2026-04-01 | TBD    | Initial draft — credit limit change |

---

## Business Rules

1. BR-04 (MODIFIED): Orders with a total value exceeding $10,000 must be rejected. (Was: $5,000)

---

## Constants

| Name          | Value    | Description                              |
|---------------|----------|------------------------------------------|
| C_CREDIT_LMT  | 10000.00 | (MODIFIED) Credit limit threshold. Was: 5000.00 |

---

## Program Processing

### Main Logic

Step 6 (EXISTING — context only): IF order status ≠ C_PENDING → reject. (BR-03)
Step 7 (MODIFIED): IF order total > C_CREDIT_LMT → set P_RTNCDE = C_FAILURE → return. (BR-04)
Step 8 (EXISTING — context only): Set order status = C_CONFIRMED.

---

## Error Handling

| Scenario                                     | Return Code | Action                         | Logged? |
|----------------------------------------------|-------------|--------------------------------|---------|
| Validation Error (BR-04: over credit limit)  | '1'         | Set P_RTNCDE, return           | No      |
| Data Not Found                               | '1'         | (EXISTING — unchanged)         | No      |
| Update Failure                               | '1'         | (EXISTING — unchanged)         | Yes     |
| System Error                                 | '1'         | (EXISTING — unchanged)         | Yes     |

---

## Programming Language

RPGLE

---

## Open Questions / TBD

| # | Section     | Question                                              |
|---|-------------|-------------------------------------------------------|
| 1 | Spec Header | Program name (*PGM object) is not specified.          |
| 2 | Business Rules | Is the $10,000 limit inclusive or exclusive (> vs ≥)? |
| 3 | Business Rules | Does this limit apply to all order types or only specific ones? |

---

## Spec Summary

- **Spec Level:** L1 Lite
- **Change Type:** Change to Existing
- **Total Business Rules:** 1 (0 new, 1 modified)
- **Total Main Logic Steps:** 1 (0 new, 1 modified)
- **Total Files Used:** 0
- **Total External Calls:** 0
- **Total Open Questions:** 3
