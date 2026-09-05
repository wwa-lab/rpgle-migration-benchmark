# Sample L2 Standard Functional Spec — Add Inactive Customer Rejection

Calibration example showing the L2 Standard format for an enhancement to an existing process.

---

**Requirement**: In the existing order entry process, add a check to reject orders for
inactive customers. Currently, orders for inactive customers are accepted and fail
downstream during invoicing. The order entry operator should see a clear rejection message
when attempting to submit an order for an inactive customer.

**Change Type**: Enhancement to Existing
**Target Platform**: IBM i

---

## Document Header

- **Document ID:** FS-20260402-02
- **Document Level:** L2 Standard
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** Enhancement to Existing
- **Target Platform:** IBM i
- **Related Business Process:** Order Entry
- **Description:** Add inactive customer rejection to the order entry process so that orders for inactive customers are blocked at entry rather than failing during invoicing.

---

## Amendment History

| Version | Date       | Author | Change Description |
|---------|------------|--------|--------------------|
| 1.0     | 2026-04-02 | TBD    | Initial draft      |

---

## Functional Overview

Orders submitted for inactive customers are currently accepted through order entry and
only fail during the downstream invoicing process. This causes rework, delayed order
cancellations, and customer confusion. This enhancement adds an inactive customer check
at the point of order entry so that the operator is immediately informed when a customer
is inactive and the order is rejected before entering the fulfillment pipeline.

---

## Business Context / Background

- **Business Area:** Order Management
- **Current Pain Point or Driver:** Approximately TBD orders per month are accepted for inactive customers and fail during invoicing, requiring manual cancellation and customer notification. The Finance team has requested that these orders be blocked at entry.
- **Requesting Stakeholder:** Finance Department
- **Business Priority:** Medium — reduces rework and improves order quality

---

## Business Objective

Eliminate orders for inactive customers from entering the fulfillment pipeline by
rejecting them at the point of entry, reducing invoicing failures and the associated
manual rework.

---

## Scope and Boundary

### In Scope

- Adding an inactive customer check during order entry
- Rejecting orders for inactive customers with a clear message to the operator
- Logging rejected orders for inactive customers for reporting purposes (Inferred)

### Out of Scope

- Changes to how customers are marked inactive
- Customer reactivation process
- Changes to the invoicing process
- Handling of orders already in the pipeline for inactive customers
- Batch or EDI order intake

### Boundary Notes

- Customer status (active/inactive) is maintained by the Customer Maintenance process and is assumed to be current.
- The existing invoicing failure handling for inactive customers remains unchanged. This enhancement prevents new orders from reaching that stage.

---

## Current Process / Current Behavior

When an order entry operator submits an order, the system accepts the order regardless of
the customer's active/inactive status. The order proceeds to fulfillment and eventually
reaches invoicing. During invoicing, the system detects that the customer is inactive and
the invoice fails. A member of the Finance team must then manually cancel the order and
notify the customer or the sales representative.

---

## Future Process / Desired Behavior

When an order entry operator submits an order, the system will check the customer's status
before accepting the order. If the customer is inactive, the order is rejected immediately
and the operator sees a message indicating that the customer is inactive and the order
cannot be accepted. The operator can then contact the customer or sales representative to
resolve the status before resubmitting.

If the customer is active, the order proceeds through the existing acceptance process
unchanged.

---

## Functional Requirements

FR-01 (NEW): The system must check the customer's active/inactive status before accepting an order.
FR-02 (NEW): The system must reject orders for inactive customers and display a rejection message to the order entry operator.
FR-03 (EXISTING -- context only): The system must accept orders for active customers and route them to fulfillment.

---

## Business Rules

BR-01 (NEW): Orders for customers with an inactive status must be rejected at the point of order entry.
BR-02 (NEW): The rejection message must identify the customer and state that the customer is inactive.
BR-03 (EXISTING -- context only): Orders for active customers proceed through the existing acceptance process.
BR-04 (NEW): The inactive customer check must be performed before any other order validation (Inferred). This ensures the operator receives the most actionable rejection reason first.

---

## Functional Inputs / Outputs

### Inputs

| Input | Source | Description |
|-------|--------|-------------|
| Customer identifier | Order entry operator via order entry process | Identifies which customer the order is for |
| Customer status | Customer master data | Active or inactive indicator for the customer |

### Outputs

| Output | Destination | Description |
|--------|-------------|-------------|
| Rejection message | Order entry operator | Message stating the customer is inactive and the order cannot be accepted |
| Accepted order | Fulfillment process (EXISTING -- unchanged) | Order routed to fulfillment when customer is active |

---

## Exception Scenarios

| # | Scenario | Business Outcome | Severity |
|---|----------|------------------|----------|
| E-01 (NEW) | Customer is inactive when order is submitted | Order is rejected; operator sees inactive customer message | High |
| E-02 (NEW) | Customer status cannot be determined (customer not found or status unavailable) | Order is held; operator is informed that customer status could not be verified | High |

---

## Acceptance Criteria

| # | Criterion | Validates |
|---|-----------|-----------|
| AC-01 | Given a customer with inactive status, when an order is submitted for that customer, then the order is rejected and the operator sees a message identifying the customer and stating the customer is inactive | FR-01, FR-02, BR-01, BR-02 |
| AC-02 | Given a customer with active status, when an order is submitted for that customer, then the order is accepted and routed to fulfillment as it does today | FR-03, BR-03 |
| AC-03 | Given a customer whose status cannot be determined, when an order is submitted, then the order is held and the operator is informed that status could not be verified | E-02 |
| AC-04 | Given an inactive customer, when the order is rejected, then the inactive customer check occurs before any other order validation | BR-04 |

---

## Upstream / Downstream Business Dependencies

### Upstream

| Dependency | Type | Description |
|------------|------|-------------|
| Customer Maintenance process | Data | Must maintain current active/inactive status for all customers |
| Order entry process | Trigger | Must provide customer identifier at order submission |

### Downstream

| Dependent | Type | Description |
|-----------|------|-------------|
| Fulfillment process | Consumer | Unchanged — continues to receive accepted orders only |
| Invoicing process | Indirect benefit | Will receive fewer orders for inactive customers, reducing invoice failures |

---

## Assumptions / Constraints

### Assumptions

- Customer active/inactive status is maintained and current before order entry occurs.
- The existing order entry process provides the customer identifier at the point of submission.
- There is no business requirement for an override capability (e.g., supervisor approval to accept an order for an inactive customer). If override is needed, this should be raised as a separate enhancement.

### Constraints

- The inactive customer check must not noticeably delay the order entry process for active customers.
- The rejection message must be clear enough for the operator to take action without calling support.

---

## Open Questions / TBD

| # | Section | Question | Source | Status |
|---|---------|----------|--------|--------|
| 1 | Business Context | How many orders per month currently fail at invoicing due to inactive customers? | Business | Open |
| 2 | Business Rules | Should the inactive customer check occur before or after credit validation (if credit validation exists)? | Business | Open |
| 3 | Business Rules | (Inferred) BR-04 assumes inactive check runs first. Confirm this is the desired sequence. | Requirement | Open |
| 4 | Scope | Is there a need for a supervisor override to accept orders for inactive customers? | Business | Open |
| 5 | Exception Scenarios | What should happen if the customer record exists but the status field is blank or unrecognized? | Business | Open |

---

## Functional Summary

- **Document Level:** L2 Standard
- **Change Type:** Enhancement to Existing
- **Target Platform:** IBM i
- **Total Functional Requirements (FR):** 3 (2 new, 0 modified)
- **Total Business Rules (BR):** 4 (3 new, 0 modified)
- **Total Exception Scenarios:** 2
- **Total Acceptance Criteria:** 4
- **Total Open Questions:** 5
- **Business Review Ready:** Yes — open questions are clarifications, not scope blockers
