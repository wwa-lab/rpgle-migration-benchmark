# Sample L3 Full Technical Design -- New Order Validation Program (RPGLE)

Calibration example showing the L3 Full format for a new program design.

---

**Requirement**: Create a new RPGLE program that validates incoming orders. The program
must read the customer master file to verify the customer exists and is active, check
the customer's available credit against the order total, and if validation passes,
write the order to the order master file. The program is called by a CLLE driver that
manages the batch order processing flow. Return a code indicating success, validation
failure, or system error.

**Solution Type**: RPGLE
**Change Type**: New Program

---

## Document Header

- **Design ID:** TD-20260402-01
- **Design Level:** L3 Full
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** New Program
- **Solution Type:** RPGLE
- **Related Program(s):** TBD (new validation program), TBD (existing CLLE batch driver)
- **Description:** Design a new order validation program that verifies customer eligibility and credit before writing confirmed orders.

---

## Amendment History

| Version | Date       | Author | Change Description |
|---------|------------|--------|--------------------|
| 1.0     | 2026-04-02 | TBD    | Initial draft      |

---

## Design Overview

This design introduces a new RPGLE program responsible for validating incoming orders
against customer eligibility and credit availability. The program reads customer data,
applies business validation rules, and writes validated orders to the order master file.
It operates within an existing batch order processing flow controlled by a CLLE driver
program.

---

## Business Context / Trigger

- **Business Event:** Batch order processing cycle executes on schedule (daily or on demand)
- **Business Purpose:** Ensure only valid orders from active, creditworthy customers are written to the order file, preventing downstream fulfilment of invalid orders
- **Current State:** N/A -- new program
- **Desired State:** Automated order validation within the batch processing flow, with clear pass/fail signaling to the calling driver

---

## Design Objective

Design a modular order validation program that separates customer eligibility checks
from credit validation, returns structured results to the calling batch driver, and
writes only validated orders to persistent storage.

---

## Scope and Boundary

### In Scope

- Customer existence and active status validation
- Credit limit validation against order total
- Writing validated orders to the order master file
- Return code signaling to the calling CLLE driver
- Error handling for all four mandatory categories

### Out of Scope

- Order entry or order capture (orders arrive as input to this program)
- Customer master file maintenance
- Credit limit adjustment or override workflows
- Order fulfilment processing downstream of validation
- Reporting or audit trail generation beyond error logging

### Boundary Conditions

- The CLLE batch driver is responsible for reading pending orders and calling this
  program once per order
- The customer master file is maintained by a separate process and is treated as
  read-only by this design
- The order master file structure is assumed to exist; this design writes to it but
  does not define its layout

---

## Solution Overview

The solution is a single RPGLE program called by an existing CLLE batch driver. The
program receives order identification and customer identification as input, performs
a two-phase validation (customer eligibility followed by credit check), and writes
the order to the order master file only if both checks pass. The design separates
validation responsibility from data persistence to allow future reuse of the validation
logic as a service program if needed. Error handling follows a return-code model where
the caller receives a structured result and decides on retry or escalation.

---

## Module / Responsibility Allocation

### Module Allocation Table

| Object | Type | Status | Primary Role | Responsibility | Depends On | Depended On By |
|--------|------|--------|--------------|----------------|------------|----------------|
| TBD (order validation program) | RPGLE PGM | New | Validation | Validates customer eligibility and credit, writes confirmed orders. Also performs Data Access for customer lookup and Update for order write. | Customer master file, Order master file | TBD (CLLE batch driver) |
| TBD (CLLE batch driver) | CLLE PGM | Existing | Orchestration | Controls batch flow, reads pending orders, calls validation program, handles results | TBD (order validation program) | Scheduler / Job queue |

**Design note**: The validation program carries three roles (Validation, Data Access,
Update). If future requirements demand reuse of validation logic independently from
order writing, the Data Access and Update responsibilities should be extracted into
a service program. For the current scope, a single program is sufficient.

---

## High-Level Processing Flow

**Stage 1: Input Receipt and Initialization**
The CLLE batch driver calls the validation program, passing order identification and
customer identification. The validation program initializes its working state and
prepares for processing.
- Active module: TBD (order validation program)
- Input consumed: Order ID, Customer ID (from caller)
- Output produced: None (internal initialization)

**Stage 2: Customer Eligibility Validation**
The validation program reads the customer master file using the provided customer ID.
It verifies that the customer record exists and that the customer is in active status.
If the customer is not found or is inactive, processing stops and a validation failure
result is returned to the caller.
- Active module: TBD (order validation program)
- Input consumed: Customer ID, customer master file data
- Output produced: Eligibility result (pass/fail)
- Business rules: BR-01, BR-02

**Stage 3: Credit Validation**
The validation program compares the order total against the customer's available credit
limit. If the order total exceeds the credit limit, processing stops and a validation
failure result is returned.
- Active module: TBD (order validation program)
- Input consumed: Order total, customer credit limit (from customer master file)
- Output produced: Credit check result (pass/fail)
- Business rules: BR-03

**Stage 4: Order Confirmation and Persistence**
If both validation stages pass, the validation program writes the order record to the
order master file and returns a success result to the caller.
- Active module: TBD (order validation program)
- Input consumed: Validated order data
- Output produced: Order master file record, success return code
- Business rules: BR-04

**Stage 5: Result Return**
The validation program returns the result code to the CLLE batch driver. The driver
decides on next action (process next order, log failure, or escalate system error).
- Active module: TBD (order validation program), TBD (CLLE batch driver)
- Input consumed: Result code
- Output produced: Return to caller

---

## Data / Object Interaction Design

### Object Interaction Map

| Source | Target | Interaction | Data Exchanged (summary) | Direction |
|--------|--------|-------------|--------------------------|-----------|
| TBD (CLLE batch driver) | TBD (order validation program) | Call | Order identification, customer identification | --> |
| TBD (order validation program) | Customer master file | Read | Customer header data (status, credit limit) | <-- |
| TBD (order validation program) | Order master file | Write | Confirmed order data | --> |
| TBD (order validation program) | TBD (CLLE batch driver) | Return | Validation result code | --> |

### File Access Summary

| File Name | Accessed By | Access Type (I/O/U) | Key Field(s) | Purpose |
|-----------|-------------|---------------------|-------------|---------|
| TBD (customer master file) | TBD (order validation program) | I | Customer ID | Retrieve customer status and credit limit for validation |
| TBD (order master file) | TBD (order validation program) | O | Order ID | Write confirmed order records |

---

## Interface / Dependency Design

### Program Interface Summary

| Program | Key Inputs (summary) | Key Outputs (summary) | Return Semantics |
|---------|---------------------|----------------------|------------------|
| TBD (order validation program) | Order identification, customer identification | Validation result code | Success = order written; Failure = validation rejection with category; System error = unexpected condition |

### External Dependencies

| Dependency | Type | Direction | Impact if Unavailable |
|------------|------|-----------|----------------------|
| Customer master file | Physical file | Inbound (read) | Cannot validate -- return system error |
| Order master file | Physical file | Outbound (write) | Cannot persist -- return system error |
| TBD (CLLE batch driver) | Calling program | Inbound (caller) | Program not invoked -- no impact on this program |

### Call Chain

```
TBD (CLLE batch driver) --> TBD (order validation program)
                                --> Customer master file (read)
                                --> Order master file (write)
                            <-- Return code to driver
```

---

## Business Rule Allocation

| BR | Rule Description | Allocated To (Module) | Enforced At (Stage) | Notes |
|----|------------------|-----------------------|---------------------|-------|
| BR-01 | Customer must exist in the customer master file | TBD (order validation program) | Stage 2 | NEW |
| BR-02 | Customer must be in active status to place orders | TBD (order validation program) | Stage 2 | NEW |
| BR-03 | Order total must not exceed customer's available credit limit | TBD (order validation program) | Stage 3 | NEW |
| BR-04 | Only orders passing all validation checks are written to the order file | TBD (order validation program) | Stage 4 | NEW |

---

## Error Handling Strategy

### Error Categories

| Category | Strategy | Responsible Module | Escalation |
|----------|----------|--------------------|------------|
| Validation Errors | Return validation failure code to caller with category indicator. Do not write order. | TBD (order validation program) | Caller logs and continues to next order |
| Data Errors | If customer record not found, treat as validation failure (BR-01). Return specific failure code. | TBD (order validation program) | Caller logs and continues |
| Processing Failures | If order file write fails, return processing failure code. Do not leave partial data. | TBD (order validation program) | Caller logs and escalates |
| System Errors | Unexpected conditions (file not open, system exception) return system error code. | TBD (order validation program) | Caller halts batch and alerts operations |

### Recovery Approach

Commitment control is not required for this design. Each order is processed independently
-- a validation failure on one order does not affect other orders. The write operation
is a single record insert with no multi-file transaction. If the write fails, no
rollback is needed because no prior persistent change was made within the same call.

If future requirements introduce multi-file updates (e.g., updating customer credit
balance after order write), commitment control should be revisited.

### Logging and Auditability

The validation program does not perform logging directly. The CLLE batch driver is
responsible for logging validation failures and system errors to the job log or an
application log file. The validation program provides sufficient information in its
return code for the driver to construct meaningful log entries.

---

## Operational / Processing Considerations

- **Batch vs Online:** Batch. Called within a batch order processing cycle.
- **Scheduling:** Controlled by the CLLE batch driver, which runs on a daily schedule (Inferred). The validation program itself has no scheduler dependency.
- **Estimated Volume:** TBD. Dependent on daily order volume.
- **Performance Sensitivity:** Each call performs one keyed read (customer file) and one write (order file). Performance scales linearly with order count. No known SLA constraint.
- **Locking / Contention:** The order master file may experience write contention if multiple batch jobs run concurrently. The customer master file is read-only in this context and should not contend.
- **Commitment Control:** Not required for single-record insert. See Recovery Approach.
- **Job Queue / Subsystem:** TBD. Determined by the batch driver's execution environment.

---

## Impact Analysis

### Objects Affected

| Object | Type | Impact | Description |
|--------|------|--------|-------------|
| TBD (order validation program) | PGM (RPGLE) | New | New program created by this design |
| TBD (CLLE batch driver) | PGM (CLLE) | Modified | Must be updated to call the new validation program |
| TBD (order master file) | FILE | Existing -- accessed | Written to by the new program; no structural change to the file |

### Downstream Effects

- The CLLE batch driver must be modified to include the call to the new validation
  program. Any existing tests for the batch driver will need updating.
- Programs that read the order master file downstream (fulfilment, reporting) are not
  affected structurally but may see changes in data volume or patterns if previously
  invalid orders were being written.
- No existing validation logic is being replaced by this design (this is a new addition).

### Test Impact

- New test scenarios required for all four business rules (BR-01 through BR-04)
- New test scenarios for all four error categories
- Batch driver integration test must be updated to include the validation call
- Existing downstream tests that read the order file should be regression-tested to
  confirm no format change

### Migration / Deployment Notes

- Compile order: Create the RPGLE validation program first, then modify and recompile
  the CLLE batch driver.
- No data migration required.
- The order master file must exist before the validation program is deployed.
- Recommend deploying during a batch window gap to avoid contention with existing
  processing.

---

## Assumptions / Constraints

### Assumptions

- The customer master file contains a status indicator that can be checked for
  active/inactive
- The customer master file contains a credit limit field
- The order total is available to the validation program at call time (passed by the
  driver or derivable from order data)
- The CLLE batch driver already exists and currently processes orders without validation
  (this program adds validation to the existing flow)

### Constraints

- The validation program must return a result to the caller -- it cannot silently
  discard invalid orders
- The order master file structure is fixed and cannot be modified by this design
- The customer master file is read-only in this context

---

## Open Questions / TBD

| # | Section | Question | Source | Status |
|---|---------|----------|--------|--------|
| 1 | Document Header | What is the program name (*PGM object) for the new validation program? | Requirement | Open |
| 2 | Document Header | What is the name of the existing CLLE batch driver? | Requirement | Open |
| 3 | Data / Object Interaction | What is the physical file name for the customer master file? | Requirement | Open |
| 4 | Data / Object Interaction | What is the physical file name for the order master file? | Requirement | Open |
| 5 | Operational | What is the expected daily order volume? | Requirement | Open |
| 6 | Operational | Is the batch driver scheduling confirmed as daily? | Design (Inferred) | Open |
| 7 | Operational | What job queue and subsystem does the batch driver run in? | Requirement | Open |
| 8 | Business Rule Allocation | Does the credit limit check use the full credit limit or available credit (limit minus outstanding)? | Requirement | Open |

---

## Design Summary

- **Design Level:** L3 Full
- **Change Type:** New Program
- **Solution Type:** RPGLE
- **Total Business Rules (BR):** 4 (4 new, 0 modified)
- **Total Modules:** 2 (1 new, 1 modified)
- **Total Processing Stages:** 5
- **Total Files Accessed:** 2
- **Total External Dependencies:** 3
- **Total Open Questions:** 8
- **Design Review Ready:** No -- program names, file names, and volume estimates are unresolved
