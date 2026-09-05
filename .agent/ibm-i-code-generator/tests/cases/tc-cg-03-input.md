## Spec Header
- **Spec ID:** RPTCTL-20260404-01
- **Spec Level:** L3 Full
- **Version:** 1.0
- **Status:** Approved
- **Change Type:** New Program
- **Program Type:** CLLE
- **Program Name:** RPTCTL
- **Description:** Controls nightly report generation. Checks run-status data area, calls the report program, and updates the data area.

## Business Rules
1. BR-01: If RPTSTDA data area = 'Y', the report is already running -- do not submit again.
2. BR-02: Set RPTSTDA to 'Y' before calling the report program.
3. BR-03: If CALL to RPTGEN fails, reset RPTSTDA to 'N'.

## Interface Contract
### Program Parameters
| Name | Type | Length | Input/Output | Valid Values | Description |
|------|------|--------|-------------|--------------|-------------|
| &RTNCDE | CHAR | 1 | Output | '0','1','2' | Return code |

### Return Code Definition
| Code | Meaning | Caller Action |
|------|---------|---------------|
| '0' | Report submitted | Log success |
| '1' | Already running | Log warning |
| '2' | Error | Raise alert |

## Data Contract
| Field Name | Source | Storage | Read by Steps | Written by Steps | Notes |
|------------|--------|---------|---------------|-----------------|-------|
| &RTNCDE | Param | Transient | -- | 2,4,7,8 | Output |
| &RPTSTS | DataArea | Persisted | 4 | 5,7 | Value from RPTSTDA |

## File Usage
N/A

## Data Area
- **RPTSTDA** (Library: RPTLIB) -- CHAR(1). 'Y' = running, 'N' = not running.

## External Program Calls
| Program | Purpose | Parameters Passed | Expected Return |
|---------|---------|-------------------|-----------------|
| RPTGEN | Generate nightly report | None | N/A |

## Main Logic
Step 1: Receive parameter &RTNCDE.
Step 2: Set &RTNCDE = '2' (default to error).
Step 3: RTVDTAARA RPTSTDA into &RPTSTS.
Step 4: IF &RPTSTS = 'Y' -> set &RTNCDE = '1' -> return. (BR-01)
Step 5: CHGDTAARA RPTSTDA to 'Y'. (BR-02)
Step 6: CALL RPTGEN.
Step 7: IF CALL fails -> CHGDTAARA RPTSTDA to 'N' -> set &RTNCDE = '2' -> return. (BR-03)
Step 8: Set &RTNCDE = '0'.
Step 9: Return.

## Error Handling
| Scenario | Return Code | Action | Logged? |
|----------|-------------|--------|---------|
| Already running (BR-01) | '1' | Set &RTNCDE, send message, return | Yes |
| RTVDTAARA failure | '2' | MONMSG, send message, return | Yes |
| CALL failure (BR-03) | '2' | Reset RPTSTDA, set &RTNCDE, return | Yes |
| System Error | '2' | MONMSG, set &RTNCDE, return | Yes |

## Programming Language
CLLE

## Open Questions / TBD
(none)
