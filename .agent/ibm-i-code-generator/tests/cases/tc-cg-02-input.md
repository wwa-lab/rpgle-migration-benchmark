## Spec Header
- **Spec ID:** ORDTOT-20260404-01
- **Spec Level:** L3 Full
- **Version:** 1.0
- **Status:** Approved
- **Change Type:** New Program
- **Program Type:** RPGLE
- **Program Name:** ORDTOT
- **Description:** Calculates the total value of an order by summing all detail lines.

## Business Rules
1. BR-01: Order number must not be blank.
2. BR-02: Order must exist in ORDHDR.
3. BR-03: Each detail line amount (LNAMT) is accumulated into the order total.

## Interface Contract
### Program Parameters
| Name | Type | Length | Input/Output | Valid Values | Description |
|------|------|--------|-------------|--------------|-------------|
| P_ORDNO | CHAR | 10 | Input | Non-blank | Order number |
| P_TOTAL | PACKED | 11,2 | Output | >= 0 | Calculated order total |
| P_RETCDE | CHAR | 1 | Output | '0','1' | Return code |

### Return Code Definition
| Code | Meaning | Caller Action |
|------|---------|---------------|
| '0' | Success | Use P_TOTAL |
| '1' | Failure | Handle error |

## Data Contract
| Field Name | Source | Storage | Read by Steps | Written by Steps | Notes |
|------------|--------|---------|---------------|-----------------|-------|
| P_ORDNO | Param | Transient | 2,3 | -- | Input |
| P_TOTAL | Param | Transient | -- | 2,5 | Output, accumulated |
| P_RETCDE | Param | Transient | -- | 2,4,6 | Output |
| LNAMT | File | Persisted | 5 | -- | Line amount in ORDDTL |

## File Usage
| File Name | Type (I/O/U) | Key Field(s) | Access Pattern | Description |
|-----------|--------------|-------------|----------------|-------------|
| ORDHDR | I | ORDNO | 1:1 | Order header |
| ORDDTL | I | ORDNO | 1:N | Order detail lines |

## Main Logic
Step 1: Receive parameters P_ORDNO, P_TOTAL, P_RETCDE.
Step 2: Set P_RETCDE = '1', P_TOTAL = 0.
Step 3: IF P_ORDNO is blank -> set P_RETCDE = '1' -> return. (BR-01)
Step 4: Read ORDHDR by ORDNO. IF not found -> set P_RETCDE = '1' -> return. (BR-02)
Step 5: FOR EACH detail line in ORDDTL by ORDNO -> accumulate LNAMT into P_TOTAL. (BR-03)
Step 6: Set P_RETCDE = '0'.
Step 7: Return.

## File Output / Update
N/A (read-only program)

## Error Handling
| Scenario | Return Code | Action | Logged? |
|----------|-------------|--------|---------|
| Validation Error (BR-01) | '1' | Set P_RETCDE, return | No |
| Data Not Found (BR-02) | '1' | Set P_RETCDE, return | No |
| System Error | '1' | Set P_RETCDE, return | Yes |

## Programming Language
RPGLE

## Open Questions / TBD
(none)
