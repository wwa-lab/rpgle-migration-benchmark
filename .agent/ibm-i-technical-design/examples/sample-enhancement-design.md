# Sample L2 Standard Enhancement Design -- Add Inactive Customer Rejection

Calibration example showing the L2 Standard format for an enhancement to an existing
program.

---

**Requirement**: In the existing order validation program, add a check to reject
orders placed by inactive customers. Currently the program validates credit limits
but does not check customer active/inactive status. If the customer is inactive,
the order must be rejected before the credit check is performed.

**Solution Type**: RPGLE
**Change Type**: Enhancement to Existing

---

## Document Header

- **Design ID:** TD-20260402-02
- **Design Level:** L2 Standard
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** Enhancement to Existing
- **Solution Type:** RPGLE
- **Related Program(s):** TBD (existing order validation program)
- **Description:** Add inactive customer rejection to the existing order validation program, enforced before credit validation.

---

## Amendment History

| Version | Date       | Author | Change Description           |
|---------|------------|--------|------------------------------|
| 1.0     | 2026-04-02 | TBD    | Initial draft                |

---

## Design Overview

The existing order validation program checks customer credit limits before writing
orders to the order file. This enhancement adds a customer status check that rejects
orders from inactive customers. The new check executes before the existing credit
validation, creating a two-gate validation flow: eligibility first, credit second.
No new programs or files are introduced -- the change modifies the existing validation
program's processing flow and business rule set.

---

## Business Context / Trigger

- **Business Event:** Batch order processing cycle (unchanged)
- **Business Purpose:** Prevent orders from inactive customers from consuming credit validation resources and entering the order file
- **Current State:** Orders are validated only against credit limit. Inactive customers can place orders that pass validation.
- **Desired State:** Orders from inactive customers are rejected immediately, before credit check processing.

---

## Design Objective

Extend the existing order validation program to include customer eligibility checking
based on active/inactive status, positioned before the existing credit validation gate,
with minimal disruption to the current processing flow.

---

## Scope and Boundary

### In Scope

- Add customer active/inactive status check to the validation program
- Position the new check before the existing credit validation
- Return a distinct failure indicator for inactive customer rejection
- Update error handling to include the new validation category

### Out of Scope

- Customer master file maintenance (activation/deactivation workflows)
- Changes to the credit validation logic (unchanged by this enhancement)
- Changes to the CLLE batch driver calling contract
- Reporting on rejected inactive customer orders

### Boundary Conditions

- The customer master file already contains an active/inactive status indicator
  (Inferred -- see Open Questions)
- The existing return code model can accommodate a new failure category or the
  existing validation failure code is reused

---

## Solution Overview

The enhancement modifies the existing order validation program by inserting a new
processing stage before credit validation. The program already reads the customer
master file for credit limit data; the new check reads the customer status from the
same file access. No additional file interaction is required. The design adds one
new business rule and one new processing stage while preserving the existing validation
flow unchanged.

---

## Module / Responsibility Allocation

### Module Allocation Table

| Object | Type | Status | Primary Role | Responsibility | Depends On | Depended On By |
|--------|------|--------|--------------|----------------|------------|----------------|
| TBD (order validation program) | RPGLE PGM | (MODIFIED) | Validation | Validates customer eligibility (NEW) and credit (EXISTING). Also performs Data Access for customer lookup and Update for order write. | Customer master file, Order master file | TBD (CLLE batch driver) |
| TBD (CLLE batch driver) | CLLE PGM | (EXISTING -- context only) | Orchestration | Controls batch flow, calls validation program. Unchanged by this enhancement. | TBD (order validation program) | Scheduler |

---

## High-Level Processing Flow

**Stage 1: Input Receipt and Initialization (EXISTING -- context only)**
The validation program receives order and customer identification from the batch
driver. No change to this stage.
- Active module: TBD (order validation program)

**Stage 2: Customer Eligibility Validation (NEW)**
The validation program checks the customer's active/inactive status using data
already available from the customer master file read. If the customer is inactive,
processing stops and a validation failure result is returned.
- Active module: TBD (order validation program)
- Input consumed: Customer status (from customer master file)
- Output produced: Eligibility result (pass/fail)
- Business rules: BR-01 (NEW)

**Stage 3: Credit Validation (EXISTING -- context only)**
The validation program compares the order total against the customer's credit limit.
Unchanged by this enhancement.
- Active module: TBD (order validation program)
- Business rules: BR-02 (EXISTING)

**Stage 4: Order Confirmation and Persistence (EXISTING -- context only)**
Validated orders are written to the order master file. Unchanged by this enhancement.
- Active module: TBD (order validation program)
- Business rules: BR-03 (EXISTING)

**Stage 5: Result Return (EXISTING -- context only)**
Result code returned to the batch driver. The driver's handling of the return code
may need review if a new return code value is introduced (see Open Questions).
- Active module: TBD (order validation program)

---

## Data / Object Interaction Design

### Object Interaction Map

| Source | Target | Interaction | Data Exchanged (summary) | Direction |
|--------|--------|-------------|--------------------------|-----------|
| TBD (order validation program) | Customer master file | Read | Customer header data including status (MODIFIED -- now reads status in addition to credit data) | <-- |
| TBD (order validation program) | Order master file | Write | Confirmed order data (EXISTING -- context only) | --> |

### File Access Summary

| File Name | Accessed By | Access Type (I/O/U) | Key Field(s) | Purpose |
|-----------|-------------|---------------------|-------------|---------|
| TBD (customer master file) | TBD (order validation program) | I | Customer ID | (MODIFIED) Now also used for status check in addition to credit lookup |
| TBD (order master file) | TBD (order validation program) | O | Order ID | (EXISTING -- context only) Write confirmed orders |

---

## Interface / Dependency Design

### Program Interface Summary

| Program | Key Inputs (summary) | Key Outputs (summary) | Return Semantics |
|---------|---------------------|----------------------|------------------|
| TBD (order validation program) | Order identification, customer identification (EXISTING -- unchanged) | Validation result code (MODIFIED -- may include new inactive customer failure category) | Success = order written; Failure = validation rejection; System error = unexpected condition |

### External Dependencies

| Dependency | Type | Direction | Impact if Unavailable |
|------------|------|-----------|----------------------|
| Customer master file | Physical file | Inbound (read) | Cannot validate -- return system error (EXISTING -- unchanged) |
| Order master file | Physical file | Outbound (write) | Cannot persist -- return system error (EXISTING -- unchanged) |

### Call Chain

```
TBD (CLLE batch driver) --> TBD (order validation program) [unchanged]
```

The call chain is unchanged. The batch driver calls the validation program with the
same parameters. The internal processing within the validation program changes, but
the external contract is preserved (unless a new return code value is introduced).

---

## Business Rule Allocation

| BR | Rule Description | Allocated To (Module) | Enforced At (Stage) | Notes |
|----|------------------|-----------------------|---------------------|-------|
| BR-01 | Customers with inactive status must not have orders accepted | TBD (order validation program) | Stage 2 | (NEW) |
| BR-02 | Order total must not exceed customer's available credit limit | TBD (order validation program) | Stage 3 | (EXISTING -- context only) |
| BR-03 | Only orders passing all validation checks are written to the order file | TBD (order validation program) | Stage 4 | (EXISTING -- context only) |

---

## Error Handling Strategy

### Error Categories

| Category | Strategy | Responsible Module | Escalation |
|----------|----------|--------------------|------------|
| Validation Errors | (MODIFIED) Return validation failure code. Now includes inactive customer rejection in addition to credit failure. | TBD (order validation program) | Caller logs and continues |
| Data Errors | (EXISTING -- unchanged) Customer not found returns specific failure code. | TBD (order validation program) | Caller logs and continues |
| Processing Failures | (EXISTING -- unchanged) Order write failure returns processing failure code. | TBD (order validation program) | Caller logs and escalates |
| System Errors | (EXISTING -- unchanged) Unexpected conditions return system error code. | TBD (order validation program) | Caller halts batch and alerts operations |

### Recovery Approach

No change to recovery approach. The inactive customer check occurs before any write
operation, so no new rollback scenario is introduced.

### Logging and Auditability

No change. The batch driver continues to log validation failures using the return code
from the validation program. The new inactive customer rejection is communicated
through the same return code mechanism.

---

## Impact Analysis

### Objects Affected

| Object | Type | Impact | Description |
|--------|------|--------|-------------|
| TBD (order validation program) | PGM (RPGLE) | Modified | New processing stage added before credit check |

### Downstream Effects

- The CLLE batch driver is not structurally affected if the existing validation failure
  return code is reused for inactive customer rejection. If a new distinct return code
  is introduced, the batch driver's result handling logic must be reviewed.
- Downstream programs reading the order file are not affected -- the file format is
  unchanged. Order volume may decrease slightly as previously accepted orders from
  inactive customers are now rejected.
- Operations may see an increase in validation failure counts in batch logs.

### Test Impact

- New test scenario: order from inactive customer (expect rejection)
- New test scenario: order from active customer (expect pass-through to credit check)
- Existing test scenarios for credit validation should be regression-tested to confirm
  they still pass with the new stage inserted before them
- Batch driver integration test should confirm proper handling of the new rejection
  scenario

### Migration / Deployment Notes

- Recompile the modified validation program.
- No file changes, no new objects, no compile order dependency.
- Confirm the customer master file contains an active/inactive status indicator before
  deployment.
- Recommend deploying during a batch window gap.

---

## Assumptions / Constraints

### Assumptions

- The customer master file contains a status field that indicates active or inactive
  (Inferred)
- The existing customer master file read in the validation program can be extended to
  include the status field without a separate file access
- The inactive customer check should execute before the credit check (requirement states
  "before the credit check is performed")

### Constraints

- The existing interface contract with the CLLE batch driver should be preserved if
  possible (no new parameters)
- The order of existing validation stages (credit check, order write) must not change

---

## Open Questions / TBD

| # | Section | Question | Source | Status |
|---|---------|----------|--------|--------|
| 1 | Document Header | What is the name of the existing order validation program? | Requirement | Open |
| 2 | Business Rule Allocation | What field in the customer master file indicates active/inactive status? | Design (Inferred) | Open |
| 3 | Interface / Dependency Design | Should inactive customer rejection use the existing validation failure return code or a new distinct code? | Design | Open |
| 4 | Error Handling Strategy | Does the batch driver need to distinguish between inactive customer rejection and credit rejection for logging? | Design | Open |
| 5 | Business Rule Allocation | What defines "inactive"? Is it a single status value, or are there multiple statuses that qualify as inactive? | Requirement | Open |

---

## Design Summary

- **Design Level:** L2 Standard
- **Change Type:** Enhancement to Existing
- **Solution Type:** RPGLE
- **Total Business Rules (BR):** 3 (1 new, 0 modified, 2 existing context)
- **Total Modules:** 2 (0 new, 1 modified, 1 existing context)
- **Total Processing Stages:** 5 (1 new, 0 modified, 4 existing context)
- **Total Files Accessed:** 2
- **Total External Dependencies:** 2
- **Total Open Questions:** 5
- **Design Review Ready:** No -- customer status field name and return code strategy unresolved
