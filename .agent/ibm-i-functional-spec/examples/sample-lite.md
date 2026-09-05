# Sample L1 Lite Functional Spec — Change Credit Limit Threshold

Calibration example showing the L1 Lite format for a small, isolated enhancement.

---

**Requirement**: Change the credit limit threshold from $5,000 to $10,000 in the order
entry process. Orders above the new limit should be rejected as they are today.

**Change Type**: Enhancement to Existing
**Target Platform**: IBM i

---

## Document Header

- **Document ID:** FS-20260402-03
- **Document Level:** L1 Lite
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** Enhancement to Existing
- **Target Platform:** IBM i
- **Related Business Process:** Order Entry
- **Description:** Increase the credit limit validation threshold from $5,000 to $10,000 in the order entry process.

---

## Amendment History

| Version | Date       | Author | Change Description                  |
|---------|------------|--------|-------------------------------------|
| 1.0     | 2026-04-02 | TBD    | Initial draft — credit limit change |

---

## Functional Overview

The order entry process currently rejects orders that exceed a $5,000 credit limit. The
business has determined that this threshold is too restrictive and wants it increased to
$10,000. All other order validation behavior remains unchanged.

---

## Business Objective

Allow higher-value orders to be accepted without rejection, reflecting updated business
risk tolerance and reducing unnecessary order blocks for customers within the new limit.

---

## Scope and Boundary

### In Scope

- Changing the credit limit threshold from $5,000 to $10,000

### Out of Scope

- Changes to how credit limits are calculated or maintained
- Changes to the rejection message or rejection behavior
- Any other order validation rules

---

## Current Process / Current Behavior

Orders with a total exceeding $5,000 are rejected during order entry. The operator sees
a credit limit exceeded message.

---

## Future Process / Desired Behavior

Orders with a total exceeding $10,000 will be rejected during order entry. Orders between
$5,000 and $10,000 that were previously rejected will now be accepted. The rejection
message and behavior remain unchanged — only the threshold value changes.

---

## Functional Requirements

FR-01 (MODIFIED): The system must reject orders that exceed the credit limit threshold. Threshold changed from $5,000 to $10,000.

---

## Business Rules

BR-04 (MODIFIED): Orders with a total exceeding the credit limit must be rejected. Threshold changed from $5,000 to $10,000.

---

## Exception Scenarios

No change to exception handling. Orders exceeding the new $10,000 threshold are rejected
with the same message and behavior as today.

---

## Acceptance Criteria

| # | Criterion | Validates |
|---|-----------|-----------|
| AC-01 | Given an order with a total of $9,500, when the order is submitted, then the order is accepted (previously would have been rejected) | FR-01, BR-04 |
| AC-02 | Given an order with a total of $10,500, when the order is submitted, then the order is rejected with the existing credit limit exceeded message | FR-01, BR-04 |

---

## Assumptions / Constraints

### Assumptions

- The $10,000 threshold applies to all customer types and order types, same as the current $5,000 threshold.

### Constraints

- No other validation behavior changes with this enhancement.

---

## Open Questions / TBD

| # | Section | Question | Source | Status |
|---|---------|----------|--------|--------|
| 1 | Business Rules | Is the $10,000 limit inclusive or exclusive? (Is a $10,000.00 order accepted or rejected?) | Requirement | Open |
| 2 | Business Rules | Does this threshold apply to all order types or only specific ones? | Business | Open |

---

## Functional Summary

- **Document Level:** L1 Lite
- **Change Type:** Enhancement to Existing
- **Target Platform:** IBM i
- **Total Functional Requirements (FR):** 1 (0 new, 1 modified)
- **Total Business Rules (BR):** 1 (0 new, 1 modified)
- **Total Exception Scenarios:** 0 (no change)
- **Total Acceptance Criteria:** 2
- **Total Open Questions:** 2
- **Business Review Ready:** Yes
