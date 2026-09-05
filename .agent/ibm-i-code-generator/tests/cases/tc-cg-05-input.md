## Spec Header
- **Spec ID:** CUSTAUD-20260404-01
- **Spec Level:** L3 Full
- **Version:** 1.0
- **Status:** Approved
- **Change Type:** New Program
- **Program Type:** RPGLE
- **Program Name:** CUSTAUD
- **Description:** Retrieves customer information via SQL and inserts an audit trail record.

## Business Rules
1. BR-01: Customer ID parameter must not be blank.
2. BR-02: Customer must exist in CUSTMAST table.
3. BR-03: An audit record must be inserted into CUSTAUDT for every successful lookup.

## Interface Contract
### Program Parameters
| Name | Type | Length | Input/Output | Valid Values | Description |
|------|------|--------|-------------|--------------|-------------|
| P_CUSTID | CHAR | 10 | Input | Non-blank | Customer ID |
| P_CUSTNM | CHAR | 40 | Output | -- | Customer name (returned) |
| P_RETCDE | CHAR | 1 | Output | '0','1' | Return code |

### Return Code Definition
| Code | Meaning | Caller Action |
|------|---------|---------------|
| '0' | Success | Use P_CUSTNM |
| '1' | Failure | Handle error |

## Data Contract
| Field Name | Source | Storage | Read by Steps | Written by Steps | Notes |
|------------|--------|---------|---------------|-----------------|-------|
| P_CUSTID | Param | Transient | 3,4 | -- | Input |
| P_CUSTNM | Param | Transient | -- | 4 | Output |
| P_RETCDE | Param | Transient | -- | 2,4,5,6 | Output |
| wkTimestamp | Derived | Transient | -- | 5 | Current timestamp for audit |

## File Usage
| File Name | Type (I/O/U) | Key Field(s) | Access Pattern | Description |
|-----------|--------------|-------------|----------------|-------------|
| CUSTMAST | I (SQL) | CUSTID | 1:1 | Customer master (SQL SELECT) |
| CUSTAUDT | O (SQL) | -- | -- | Customer audit trail (SQL INSERT) |

## Main Logic
Step 1: Receive parameters.
Step 2: Set P_RETCDE = '1'.
Step 3: IF P_CUSTID is blank -> return. (BR-01)
Step 4: EXEC SQL SELECT CUSTNM INTO :P_CUSTNM FROM CUSTMAST WHERE CUSTID = :P_CUSTID. IF SQLCODE <> 0 -> return. (BR-02)
Step 5: Set wkTimestamp = current timestamp. EXEC SQL INSERT INTO CUSTAUDT (CUSTID, AUDTTS, AUDTYP) VALUES (:P_CUSTID, :wkTimestamp, 'LOOKUP'). (BR-03)
Step 6: Set P_RETCDE = '0'.
Step 7: Return.

## Error Handling
| Scenario | Return Code | Action | Logged? |
|----------|-------------|--------|---------|
| Validation Error (BR-01) | '1' | Set P_RETCDE, return | No |
| SQL Select failure (BR-02) | '1' | Check SQLCODE, set P_RETCDE, return | No |
| SQL Insert failure (BR-03) | '1' | Check SQLCODE, set P_RETCDE, return | Yes |
| System Error | '1' | Set P_RETCDE, return | Yes |

## Programming Language
RPGLE

## Open Questions / TBD
(none)
