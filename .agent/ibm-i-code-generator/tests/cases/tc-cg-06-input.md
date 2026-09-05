## Spec Header
- **Spec ID:** CUSTUPD-20260404-01
- **Spec Level:** L3 Full
- **Version:** 1.0
- **Status:** Approved
- **Change Type:** New Program
- **Program Type:** RPGLE
- **Program Name:** CUSTUPD
- **Description:** Validates customer active status and updates the last-reviewed date.

## Business Rules
1. BR-01: Customer ID parameter must not be blank.
2. BR-02: Customer record must exist in CUSTMAST.
3. BR-03: Customer must have active status 'A' to be updated.

## Interface Contract
### Program Parameters
| Name | Type | Length | Input/Output | Valid Values | Description |
|------|------|--------|-------------|--------------|-------------|
| P_CUSTID | CHAR | 10 | Input | Non-blank | Customer ID |
| P_RETCDE | CHAR | 1 | Output | '0','1' | Return code |

### Return Code Definition
| Code | Meaning | Caller Action |
|------|---------|---------------|
| '0' | Success | Continue processing |
| '1' | Failure | Log and skip customer |

## Data Contract
| Field Name | Source | Storage | Read by Steps | Written by Steps | Notes |
|------------|--------|---------|---------------|-----------------|-------|
| P_CUSTID | Param | Transient | 2,3 | -- | Input |
| P_RETCDE | Param | Transient | -- | 2,4,6,8 | Output |
| ACTSTS | File | Persisted | 5 | -- | Customer status field in CUSTMAST |
| LSTRVW | File | Persisted | -- | 7 | Last-reviewed date in CUSTMAST |

## File Usage
| File Name | Type (I/O/U) | Key Field(s) | Access Pattern | Description |
|-----------|--------------|-------------|----------------|-------------|
| CUSTMAST | U | CUSTID | 1:1 | Customer master file |

## Main Logic
Step 1: Receive parameters P_CUSTID and P_RETCDE.
Step 2: Set P_RETCDE = '1' (default to failure).
Step 3: IF P_CUSTID is blank -> set P_RETCDE = '1' -> return. (BR-01)
Step 4: Read CUSTMAST with key P_CUSTID.
Step 5: IF record not found -> set P_RETCDE = '1' -> return. (BR-02)
Step 6: IF ACTSTS <> 'A' -> set P_RETCDE = '1' -> return. (BR-03)
Step 7: Set LSTRVW = current date.
Step 8: Update CUSTMAST record.
Step 9: Set P_RETCDE = '0'.
Step 10: Return.

## File Output / Update
| File | Action | Fields Modified | Condition |
|------|--------|----------------|-----------|
| CUSTMAST | Update | LSTRVW | All BRs pass (BR-01 to BR-03) |

## Error Handling
| Scenario | Return Code | Action | Logged? |
|----------|-------------|--------|---------|
| Validation Error (BR-01) | '1' | Set P_RETCDE, return | No |
| Data Not Found (BR-02) | '1' | Set P_RETCDE, return | No |
| Business Rule Fail (BR-03) | '1' | Set P_RETCDE, return | No |
| Update Failure | '1' | Set P_RETCDE, return | Yes |
| System Error | '1' | Set P_RETCDE, return | Yes |

## Programming Language
RPGLE

## Open Questions / TBD
(none)
