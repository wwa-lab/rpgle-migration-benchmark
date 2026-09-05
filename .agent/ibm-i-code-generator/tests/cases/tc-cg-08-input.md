## Spec Header
- **Spec ID:** ORDVAL-20260404-03
- **Spec Level:** L2 Standard
- **Version:** 1.0
- **Status:** Approved
- **Change Type:** Change to Existing
- **Program Type:** RPGLE
- **Program Name:** ORDVAL
- **Description:** Add credit-hold validation to order validation program. (Current source not available.)

## Amendment History
| Version | Date | Author | Change Description |
|---------|------|--------|--------------------|
| 1.0 | 2026-04-04 | TBD | Add credit-hold check (BR-04) |

## Business Rules
1. BR-01 (EXISTING -- context only): Order number must not be blank.
2. BR-04 (NEW): Customer must not have credit-hold status ('H') in CUSTMAST.

## Interface Contract
### Program Parameters
| Name | Type | Length | Input/Output | Valid Values | Description |
|------|------|--------|-------------|--------------|-------------|
| P_ORDNO | CHAR | 10 | Input | Non-blank | (EXISTING) |
| P_RETCDE | CHAR | 1 | Output | '0'-'4' | (MODIFIED -- new value '4') |

### Return Code Definition
| Code | Meaning | Caller Action |
|------|---------|---------------|
| '4' | Credit hold | (NEW) Display credit-hold message |

## File Usage
| File Name | Type (I/O/U) | Key Field(s) | Access Pattern | Description |
|-----------|--------------|-------------|----------------|-------------|
| CUSTMAST | I | CUSTID | 1:1 | (NEW) Customer master |

## Main Logic
Step 5 (EXISTING -- context only): IF order status <> 'P' -> return '3'. (BR-03)
Step 6 (NEW): Read CUSTMAST by CUSTID from ORDHDR record. IF CRDSTS = 'H' -> set P_RETCDE = '4' -> return. (BR-04)
Step 7 (EXISTING -- context only): Update order status.

## Error Handling
| Scenario | Return Code | Action | Logged? |
|----------|-------------|--------|---------|
| Credit hold (BR-04) | '4' | (NEW) Set P_RETCDE, return | No |

## Programming Language
RPGLE

## Open Questions / TBD
(none)
