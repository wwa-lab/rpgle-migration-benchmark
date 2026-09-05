## Spec Header
- **Spec ID:** ORDVAL-20260404-02
- **Spec Level:** L2 Standard
- **Version:** 1.0
- **Status:** Approved
- **Change Type:** Change to Existing
- **Program Type:** RPGLE
- **Program Name:** ORDVAL
- **Description:** Add credit-hold validation to order validation program.

## Amendment History
| Version | Date | Author | Change Description |
|---------|------|--------|--------------------|
| 1.0 | 2026-04-04 | TBD | Add credit-hold check (BR-04) |

## Business Rules
1. BR-01 (EXISTING -- context only): Order number must not be blank.
2. BR-02 (EXISTING -- context only): Order must exist in ORDHDR.
3. BR-03 (EXISTING -- context only): Order status must be 'P' (Pending).
4. BR-04 (NEW): Customer must not have credit-hold status ('H') in CUSTMAST. If credit hold, reject with return code '4'.

## Interface Contract
### Program Parameters
| Name | Type | Length | Input/Output | Valid Values | Description |
|------|------|--------|-------------|--------------|-------------|
| P_ORDNO | CHAR | 10 | Input | Non-blank | Order number |
| P_RETCDE | CHAR | 1 | Output | '0','1','2','3','4' | Return code |

### Return Code Definition
| Code | Meaning | Caller Action |
|------|---------|---------------|
| '0' | Success | (EXISTING) |
| '1' | Blank order | (EXISTING) |
| '2' | Order not found | (EXISTING) |
| '3' | Wrong status | (EXISTING) |
| '4' | Credit hold | (NEW) Display credit-hold message |

## Data Contract
| Field Name | Source | Storage | Read by Steps | Written by Steps | Notes |
|------------|--------|---------|---------------|-----------------|-------|
| P_ORDNO | Param | Transient | 3,4 | -- | (EXISTING -- unchanged) |
| P_RETCDE | Param | Transient | -- | 2,3,4,5,6,8 | (MODIFIED -- new value '4') |
| CUSTID | File | Persisted | 6 | -- | (NEW) Customer ID from ORDHDR |
| CRDSTS | File | Persisted | 6 | -- | (NEW) Credit status from CUSTMAST |

## File Usage
| File Name | Type (I/O/U) | Key Field(s) | Access Pattern | Description |
|-----------|--------------|-------------|----------------|-------------|
| ORDHDR | I | ORDNO | 1:1 | (EXISTING) Order header |
| CUSTMAST | I | CUSTID | 1:1 | (NEW) Customer master -- credit hold check |

## Main Logic
Step 1 (EXISTING -- context only): Receive parameters.
Step 2 (EXISTING -- context only): Set P_RETCDE = '1'.
Step 3 (EXISTING -- context only): IF P_ORDNO blank -> return '1'. (BR-01)
Step 4 (EXISTING -- context only): Read ORDHDR. IF not found -> return '2'. (BR-02)
Step 5 (EXISTING -- context only): IF order status <> 'P' -> return '3'. (BR-03)
Step 6 (NEW): Read CUSTMAST by CUSTID from ORDHDR record. IF CRDSTS = 'H' -> set P_RETCDE = '4' -> return. (BR-04)
Step 7 (EXISTING -- context only): Update order status to 'C'.
Step 8 (EXISTING -- context only): Set P_RETCDE = '0'. Return.

## Error Handling
| Scenario | Return Code | Action | Logged? |
|----------|-------------|--------|---------|
| Credit hold (BR-04) | '4' | (NEW) Set P_RETCDE = '4', return | No |
| CUSTMAST not found | '4' | (NEW) Set P_RETCDE = '4', return | No |

## Traceability Matrix
| BR | Rule Summary | Logic Step(s) | File(s) Affected |
|----|-------------|---------------|-----------------|
| BR-04 | Credit hold check | Step 6 | CUSTMAST |

## Programming Language
RPGLE

## Open Questions / TBD
(none)
