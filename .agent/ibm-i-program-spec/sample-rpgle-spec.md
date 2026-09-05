# Sample L3 Full Spec — New RPGLE Program

Calibration example showing the L3 Full format for a new program.

---

**Requirement**: When a customer order is confirmed, validate the order header and update
the order status to "Confirmed". Only orders in "Pending" status can be confirmed. Send a
confirmation entry to the order log data queue. The program is called from the order
entry display program.

**Program Type**: RPGLE
**Change Type**: New Program

---

## Spec Header

- **Spec ID:** ORDCONF-20260401-01
- **Spec Level:** L3 Full
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** New Program
- **Program Type:** RPGLE
- **Program Name:** TBD
- **Description:** Validates a customer order confirmation request and updates the order status, then sends a log entry to the order log data queue.

---

## Amendment History

| Version | Date       | Author | Change Description |
|---------|------------|--------|--------------------|
| 1.0     | 2026-04-01 | TBD    | Initial draft      |

---

## Caller Context

- **Called by:** Order entry display program (name TBD)
- **Trigger:** User confirms an order from the order entry screen.
- **Expected behavior on success:** Caller refreshes the order display to show "Confirmed" status.
- **Expected behavior on failure:** Caller displays an error message to the user based on the return code.

---

## Functions

1. Receive and validate the order number parameter.
2. Retrieve the order header record.
3. Enforce order confirmation business rules.
4. Update the order status.
5. Send a confirmation log entry to the order log data queue.
6. Return a success/failure indicator to the calling program.

---

## Business Rules

1. BR-01: The order number parameter must not be blank.
2. BR-02: The order must exist in the order header file.
3. BR-03: An order can only be confirmed if its current status is "Pending".

---

## Interface Contract

### Program Parameters

| Name      | Type | Length | Input/Output | Valid Values                     | Description             |
|-----------|------|--------|-------------|----------------------------------|-------------------------|
| P_ORDNBR  | CHAR | 10     | Input       | Non-blank, existing order number | Order number to confirm |
| P_RTNCDE  | CHAR | 1      | Output      | '0', '1'                         | Return code             |

### Return Code Definition

| Code | Meaning                      | Caller Action                         |
|------|------------------------------|---------------------------------------|
| '0'  | Order confirmed successfully | Refresh display, show success message |
| '1'  | Confirmation failed          | Display error message to user         |

---

## Data Contract

| Field Name   | Source  | Storage   | Read by Steps | Written by Steps | Notes                   |
|--------------|---------|-----------|---------------|-----------------|-------------------------|
| P_ORDNBR     | Param   | Transient | 3, 4          | —               | Input parameter          |
| P_RTNCDE     | Param   | Transient | —             | 2, 3, 5, 6, 11 | Output parameter         |
| Order status | File    | Persisted | 6             | 7, 8            | Field in ORDHDRPF        |
| Order number | Param   | Transient | —             | 9               | Copied into LOG_ENTRY_DS |
| Timestamp    | Derived | Transient | —             | 9               | Current system timestamp |
| User ID      | Derived | Transient | —             | 9               | Current job user         |

---

## File Usage

| File Name | Type (I/O/U) | Key Field(s) | Description                                          |
|-----------|--------------|-------------|------------------------------------------------------|
| ORDHDRPF  | U            | P_ORDNBR    | Order header physical file — read and update status  |

---

## Data Queue

- **ORDLOGDQ** (Library: TBD) — Send direction. Entry format: TBD (To Be Confirmed).

---

## Data Area

N/A

---

## External Data Structure

- **ORDHDR_DS** — Based on ORDHDRPF record format.

---

## Internal Data Structure

- **LOG_ENTRY_DS** — Data queue entry: order number, timestamp, user ID. All transient.

---

## External Program Calls

N/A

---

## External Subroutines

N/A

---

## Standard Subroutines

- **\*PSSR** — Error handler. Logs error, sets P_RTNCDE = '1', returns.

---

## Constants

| Name        | Value | Description             |
|-------------|-------|-------------------------|
| C_PENDING   | 'P'   | Order status: Pending   |
| C_CONFIRMED | 'C'   | Order status: Confirmed |
| C_SUCCESS   | '0'   | Return code: Success    |
| C_FAILURE   | '1'   | Return code: Failure    |

---

## Program Processing

### Main Logic

Step 1: Receive parameters P_ORDNBR and P_RTNCDE.
Step 2: Set P_RTNCDE = C_FAILURE (default to failure).
Step 3: IF P_ORDNBR is blank → set P_RTNCDE = C_FAILURE → return. (BR-01)
Step 4: Read ORDHDRPF with key P_ORDNBR.
Step 5: IF record not found → set P_RTNCDE = C_FAILURE → return. (BR-02)
Step 6: IF order status ≠ C_PENDING → set P_RTNCDE = C_FAILURE → return. (BR-03)
Step 7: Set order status = C_CONFIRMED.
Step 8: Update ORDHDRPF record.
Step 9: Build LOG_ENTRY_DS with order number, current timestamp, current user.
Step 10: Send LOG_ENTRY_DS to ORDLOGDQ.
Step 11: Set P_RTNCDE = C_SUCCESS.
Step 12: Return.

### File Output / Update

| File     | Action | Fields Modified | Condition                                        |
|----------|--------|----------------|--------------------------------------------------|
| ORDHDRPF | Update | Order status   | Order passes all business rules (BR-01 to BR-03) |

---

## Error Handling

| Scenario                              | Return Code | Action                                  | Logged? |
|---------------------------------------|-------------|-----------------------------------------|---------|
| Validation Error (BR-01: blank order) | '1'         | Set P_RTNCDE, return                    | No      |
| Data Not Found (BR-02: order missing) | '1'         | Set P_RTNCDE, return                    | No      |
| Update Failure (ORDHDRPF write error) | '1'         | Log error details, set P_RTNCDE, return | Yes     |
| System Error (*PSSR)                  | '1'         | Log error details, set P_RTNCDE, return | Yes     |
| Data queue send failure (ORDLOGDQ)    | '1'         | Log error, set P_RTNCDE, return         | Yes     |

---

## Traceability Matrix

| BR    | Rule Summary           | Logic Step(s) | Error Handling Row        | File(s) Affected |
|-------|------------------------|---------------|--------------------------|-----------------|
| BR-01 | Order number not blank | Step 3        | Validation Error          | N/A             |
| BR-02 | Order must exist       | Step 4, 5     | Data Not Found            | ORDHDRPF        |
| BR-03 | Status must be Pending | Step 6        | N/A (positive logic only) | ORDHDRPF        |

---

## Processing Considerations

- **Performance:** Single record read/update — no concerns.
- **Locking:** ORDHDRPF locked during read-for-update, released after update.
- **Batch vs online:** Online (interactive) call only.

---

## Programming Language

RPGLE

---

## Amend Data Structure

N/A

---

## Open Questions / TBD

| # | Section        | Question                                                    |
|---|----------------|-------------------------------------------------------------|
| 1 | Spec Header    | Program name (*PGM object) is not specified.                |
| 2 | Caller Context | Exact name of the calling order entry display program.      |
| 3 | Data Queue     | Library for ORDLOGDQ data queue.                            |
| 4 | Internal DS    | Exact layout of LOG_ENTRY_DS.                               |
| 5 | Error Handling | Should the program log the specific failure reason?         |

---

## Spec Summary

- **Spec Level:** L3 Full
- **Change Type:** New Program
- **Total Business Rules:** 3 (3 new, 0 modified)
- **Total Main Logic Steps:** 12 (12 new, 0 modified)
- **Total Files Used:** 1
- **Total External Calls:** 0
- **Total Open Questions:** 5
- **Traceability Complete:** Yes
