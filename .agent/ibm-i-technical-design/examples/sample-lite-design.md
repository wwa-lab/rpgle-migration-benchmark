# Sample L1 Lite Design -- Change Credit Limit Threshold

Calibration example showing the L1 Lite format for a small, isolated change.

---

**Requirement**: In the order validation program, change the credit limit check from
$5,000 to $10,000. Orders above the new limit must be rejected.

**Solution Type**: RPGLE
**Change Type**: Enhancement to Existing

---

## Document Header

- **Design ID:** TD-20260402-03
- **Design Level:** L1 Lite
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** Enhancement to Existing
- **Solution Type:** RPGLE
- **Related Program(s):** TBD (existing order validation program)
- **Description:** Increase the credit limit validation threshold from $5,000 to $10,000.

---

## Amendment History

| Version | Date       | Author | Change Description                  |
|---------|------------|--------|-------------------------------------|
| 1.0     | 2026-04-02 | TBD    | Initial draft -- threshold change   |

---

## Design Overview

The existing order validation program rejects orders that exceed a $5,000 credit
limit. This enhancement raises the threshold to $10,000. The change is a single
constant modification with no structural impact on the program's module design,
file access, or interface contract.

---

## Design Objective

Update the credit limit threshold constant from $5,000 to $10,000 so that orders
between $5,001 and $10,000 are no longer rejected.

---

## Scope and Boundary

### In Scope

- Change the credit limit threshold value used in order validation

### Out of Scope

- Changes to credit validation logic (only the threshold changes, not the check itself)
- Customer-specific credit limits (this is a global threshold)
- Changes to error handling or return codes
- Changes to the program interface

### Boundary Conditions

- The credit limit is stored as a constant within the validation program (Inferred)
- No external configuration (data area, file) is involved in the threshold value

---

## High-Level Processing Flow

**Stage 1: Credit Validation (MODIFIED)**
The validation program compares the order total against the credit limit threshold.
The threshold value changes from $5,000 to $10,000. The validation logic itself
is unchanged.
- Active module: TBD (order validation program)
- Business rules: BR-01 (MODIFIED)

---

## Business Rule Allocation

| BR | Rule Description | Allocated To (Module) | Enforced At (Stage) | Notes |
|----|------------------|-----------------------|---------------------|-------|
| BR-01 | Orders with a total exceeding the credit limit must be rejected. Threshold changes from $5,000 to $10,000. | TBD (order validation program) | Stage 1 | (MODIFIED) |

---

## Error Handling Strategy

### Error Categories

| Category | Strategy | Responsible Module | Escalation |
|----------|----------|--------------------|------------|
| Validation Errors | (EXISTING -- unchanged) Credit limit rejection continues to use existing failure return code | TBD (order validation program) | Caller logs |
| Data Errors | (EXISTING -- unchanged) | TBD (order validation program) | Caller logs |
| Processing Failures | (EXISTING -- unchanged) | TBD (order validation program) | Caller escalates |
| System Errors | (EXISTING -- unchanged) | TBD (order validation program) | Caller halts batch |

No change to error handling strategy. The existing validation failure path applies
to the modified threshold without alteration.

---

## Impact Analysis

### Objects Affected

| Object | Type | Impact | Description |
|--------|------|--------|-------------|
| TBD (order validation program) | PGM (RPGLE) | Modified | Credit limit constant changes from 5000 to 10000 |

### Downstream Effects

- Orders between $5,001 and $10,000 that were previously rejected will now be accepted
  and written to the order file. Downstream fulfilment and reporting processes will see
  increased order volume in this range.
- The CLLE batch driver is not affected (no interface change).
- No file structure changes.

### Test Impact

- Existing test case for credit limit rejection must be updated (threshold now $10,000)
- New boundary test cases: orders at $9,999, $10,000, and $10,001

---

## Assumptions / Constraints

### Assumptions

- The credit limit is a single constant, not derived from a file or data area
  (Inferred)
- The threshold change applies to all order types uniformly

### Constraints

- The validation logic (comparison operator, return code) must not change -- only
  the threshold value

---

## Open Questions / TBD

| # | Section | Question | Source | Status |
|---|---------|----------|--------|--------|
| 1 | Document Header | What is the name of the existing order validation program? | Requirement | Open |
| 2 | Business Rule Allocation | Is the $10,000 limit inclusive or exclusive (>= vs >)? | Requirement | Open |
| 3 | Scope and Boundary | Is the threshold stored as a program constant, or is it in a data area or configuration file? | Design (Inferred) | Open |

---

## Design Summary

- **Design Level:** L1 Lite
- **Change Type:** Enhancement to Existing
- **Solution Type:** RPGLE
- **Total Business Rules (BR):** 1 (0 new, 1 modified)
- **Total Modules:** 1 (0 new, 1 modified)
- **Total Processing Stages:** 1
- **Total Files Accessed:** 0
- **Total External Dependencies:** 0
- **Total Open Questions:** 3
- **Design Review Ready:** Yes -- pending resolution of open questions, design is structurally complete
