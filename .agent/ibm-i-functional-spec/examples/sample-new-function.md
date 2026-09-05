# Sample L3 Full Functional Spec — New Order Validation Function

Calibration example showing the L3 Full format for a new business function.

---

**Requirement**: Build a new order validation function for IBM i that checks customer
credit standing, product availability, and shipping eligibility before an order can be
accepted. Orders that fail any check must be rejected with a clear reason. The validation
applies to all orders entered through the order entry process. Warehouse staff must be
notified when an order is held due to inventory shortage. Finance must be notified when
an order is rejected due to credit issues.

**Change Type**: New Function
**Target Platform**: IBM i

---

## Document Header

- **Document ID:** FS-20260402-01
- **Document Level:** L3 Full
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** New Function
- **Target Platform:** IBM i
- **Related Business Process:** Order Entry, Order Fulfillment
- **Description:** Define a new order validation function that checks credit standing, product availability, and shipping eligibility before order acceptance.

---

## Amendment History

| Version | Date       | Author | Change Description |
|---------|------------|--------|--------------------|
| 1.0     | 2026-04-02 | TBD    | Initial draft      |

---

## Functional Overview

The business requires a centralized order validation function that evaluates every order
before acceptance. Today, orders are accepted without systematic validation, leading to
credit exposure, back-order situations, and shipments to restricted destinations. This
function will validate customer credit standing, confirm product availability, and verify
shipping eligibility as a prerequisite to order acceptance, reducing downstream fulfillment
failures and financial risk.

---

## Business Context / Background

- **Business Area:** Order Management
- **Current Pain Point or Driver:** Orders are currently accepted without pre-validation. This results in accepted orders that cannot be fulfilled (out-of-stock items), shipments to customers who have exceeded their credit limit, and attempted deliveries to restricted shipping zones. The business incurs cost in reversing these orders and managing customer dissatisfaction.
- **Requesting Stakeholder:** Order Management Team / Finance Department
- **Business Priority:** High — directly impacts revenue protection and fulfillment efficiency

---

## Business Objective

Prevent unfulfillable or financially risky orders from entering the fulfillment pipeline
by validating credit, inventory, and shipping eligibility at the point of order entry.
This reduces bad debt exposure, eliminates back-order rework, and prevents shipments to
restricted destinations.

---

## Scope and Boundary

### In Scope

- Credit standing validation for the ordering customer
- Product availability check for all line items on the order
- Shipping eligibility verification for the delivery destination
- Rejection of orders that fail any validation check, with reason provided to the order entry operator
- Notification to warehouse when an order is held due to inventory shortage
- Notification to finance when an order is rejected due to credit issues
- Validation applies to all orders entered through the order entry process

### Out of Scope

- Modification of the order entry screen layout or user interface
- Changes to how credit limits are established or maintained
- Inventory replenishment or reorder processes
- Shipping zone maintenance or restricted destination list management
- Batch order processing or EDI order intake
- Order modification after initial acceptance

### Boundary Notes

- The order entry process is assumed to exist and function correctly today. This spec covers the validation step that will be added before order acceptance.
- Credit limit maintenance is handled by a separate Finance process and is not affected by this change.
- The restricted shipping zone list is maintained by the Logistics team and is assumed to be current.

---

## Current Process / Current Behavior

N/A — new function. No current validation process exists.

Today, when an order entry operator submits an order, the system accepts the order
immediately and routes it to fulfillment. No checks are performed against the customer's
credit standing, product availability, or shipping destination eligibility. Problems are
discovered downstream during fulfillment, invoicing, or shipping, requiring manual
intervention to cancel or hold orders.

---

## Future Process / Desired Behavior

When an order entry operator submits an order, the system will validate the order before
acceptance:

1. The system checks the customer's credit standing. If the customer has exceeded their
   credit limit, the order is rejected and the operator is informed that the order cannot
   be accepted due to credit issues. Finance is notified of the rejection.

2. The system checks product availability for every line item on the order. If any item
   is not available in sufficient quantity, the order is held and the operator is informed
   which items are unavailable. The warehouse team is notified of the shortage.

3. The system checks the shipping destination against the restricted shipping zone list.
   If the destination is in a restricted zone, the order is rejected and the operator is
   informed that shipment to that destination is not permitted.

4. If all three checks pass, the order is accepted and routed to fulfillment as it is
   today.

The operator receives a clear result for every order submission: accepted, rejected
(with reason), or held (with reason). The order is never silently accepted when a
validation failure exists.

---

## Functional Requirements

FR-01: The system must validate the customer's credit standing before accepting an order.
FR-02: The system must verify product availability for all line items before accepting an order.
FR-03: The system must verify shipping eligibility for the delivery destination before accepting an order.
FR-04: The system must reject orders that fail credit validation and provide the reason to the operator.
FR-05: The system must hold orders that fail availability checks and provide item-level detail to the operator.
FR-06: The system must reject orders that fail shipping eligibility and provide the reason to the operator.
FR-07: The system must notify the warehouse team when an order is held due to inventory shortage.
FR-08: The system must notify the finance team when an order is rejected due to credit issues.
FR-09: The system must accept orders that pass all three validation checks and route them to fulfillment.

---

## Business Rules

BR-01: A customer whose outstanding balance plus the new order total exceeds their approved credit limit must be treated as having failed credit validation.
BR-02: All line items on the order must have sufficient available quantity to fill the order. Partial availability does not satisfy this rule.
BR-03: Orders with a delivery destination in a restricted shipping zone must not be accepted.
BR-04: Credit validation must be performed before availability and shipping checks. If credit fails, the remaining checks are not required.
BR-05: When an order is held due to inventory shortage, the hold notification must identify each unavailable item and the shortfall quantity.
BR-06: When an order is rejected due to credit issues, the rejection notification must include the customer identifier and the amount by which the credit limit is exceeded.
BR-07: Orders that pass all three checks must be accepted without manual intervention.

---

## Functional Inputs / Outputs

### Inputs

| Input | Source | Description |
|-------|--------|-------------|
| Order details | Order entry operator via order entry process | Customer identifier, line items with quantities, delivery destination |
| Customer credit information | Customer master data | Credit limit, current outstanding balance |
| Product availability | Inventory records | Available quantity per product |
| Restricted shipping zones | Shipping zone reference | List of destinations where shipment is not permitted |

### Outputs

| Output | Destination | Description |
|--------|-------------|-------------|
| Validation result | Order entry operator | Accepted, rejected (with reason), or held (with reason) |
| Credit rejection notification | Finance team | Customer identifier, order reference, amount over limit |
| Inventory hold notification | Warehouse team | Order reference, list of unavailable items with shortfall quantities |
| Accepted order | Fulfillment process | Order routed to fulfillment (existing downstream process) |

---

## User / Role / Trigger Context

| Actor | Role | Interaction |
|-------|------|-------------|
| Order entry operator | Submits orders | Enters order details and receives validation result |
| Finance team | Credit oversight | Receives notification when orders are rejected for credit reasons |
| Warehouse team | Inventory management | Receives notification when orders are held due to shortage |

- **Primary Trigger:** Order entry operator submits an order for acceptance
- **Frequency:** TBD — dependent on daily order volume

---

## Exception Scenarios

| # | Scenario | Business Outcome | Severity |
|---|----------|------------------|----------|
| E-01 | Customer credit information is not available at the time of validation | Order is held pending credit verification; operator is informed that credit check could not be completed | High |
| E-02 | Product availability information is not available for one or more line items | Order is held; operator is informed which items could not be verified | High |
| E-03 | Restricted shipping zone list is not available | Order is held pending shipping verification; operator is informed | Medium |
| E-04 | Customer does not exist in customer master data | Order is rejected; operator is informed that the customer is not recognized | Critical |
| E-05 | Order contains no line items | Order is rejected; operator is informed that the order has no items to validate | Medium |

---

## Acceptance Criteria

| # | Criterion | Validates |
|---|-----------|-----------|
| AC-01 | Given a customer whose outstanding balance plus order total exceeds their credit limit, when the order is submitted, then the order is rejected and the operator sees a credit limit exceeded message | FR-01, FR-04, BR-01 |
| AC-02 | Given an order where one line item has insufficient available quantity, when the order is submitted, then the order is held and the operator sees which item is unavailable and the shortfall quantity | FR-02, FR-05, BR-02, BR-05 |
| AC-03 | Given an order with a delivery destination in a restricted shipping zone, when the order is submitted, then the order is rejected and the operator sees a restricted destination message | FR-03, FR-06, BR-03 |
| AC-04 | Given an order that passes credit, availability, and shipping checks, when the order is submitted, then the order is accepted and routed to fulfillment without manual intervention | FR-09, BR-07 |
| AC-05 | Given a customer who fails credit validation, when the order is rejected, then the finance team receives a notification with the customer identifier and the amount over limit | FR-08, BR-06 |
| AC-06 | Given an order held due to inventory shortage, when the hold is recorded, then the warehouse team receives a notification identifying each unavailable item and shortfall quantity | FR-07, BR-05 |
| AC-07 | Given a customer who fails credit validation, when validation is performed, then availability and shipping checks are not performed | BR-04 |
| AC-08 | Given a customer whose credit information is unavailable, when the order is submitted, then the order is held and the operator is informed that credit verification could not be completed | E-01 |
| AC-09 | Given an order for a customer not found in customer master data, when the order is submitted, then the order is rejected with a customer not recognized message | E-04 |

---

## Upstream / Downstream Business Dependencies

### Upstream

| Dependency | Type | Description |
|------------|------|-------------|
| Customer master data | Data | Must contain current credit limits and outstanding balances for all active customers |
| Inventory records | Data | Must reflect current available quantities for all products |
| Restricted shipping zone list | Data | Must be maintained and current |
| Order entry process | Trigger | Must provide complete order details including customer, line items, and destination |

### Downstream

| Dependent | Type | Description |
|-----------|------|-------------|
| Order fulfillment process | Consumer | Receives accepted orders for picking, packing, and shipping |
| Finance team notification process | Consumer | Receives credit rejection notifications |
| Warehouse team notification process | Consumer | Receives inventory hold notifications |

---

## Assumptions / Constraints

### Assumptions

- Customer credit limits and outstanding balances are maintained and current in the customer master data before validation occurs.
- Product availability quantities are updated in near-real-time and reflect current stock levels.
- The restricted shipping zone list is maintained by the Logistics team and is available for lookup.
- The order entry process provides all required order details (customer, line items with quantities, delivery destination) at the time of submission.

### Constraints

- Validation must complete within a timeframe acceptable to the order entry operator (specific threshold TBD).
- The validation function must not modify order data — it evaluates and returns a result only.
- Notification delivery method (email, message queue, dashboard) is TBD and may vary by recipient role.

---

## Open Questions / TBD

| # | Section | Question | Source | Status |
|---|---------|----------|--------|--------|
| 1 | Business Rules | Is the credit limit check inclusive or exclusive of the current order total? (Does "exceeds" mean > or >=?) | Requirement | Open |
| 2 | Business Rules | Should availability be checked per-warehouse or across all warehouses? | Business | Open |
| 3 | User / Role / Trigger Context | What is the expected daily order volume? | Business | Open |
| 4 | Exception Scenarios | What is the timeout threshold for an acceptable validation response time? | Business | Open |
| 5 | Functional Outputs | What is the notification delivery mechanism for finance and warehouse teams? | Business | Open |
| 6 | Business Rules | Are there any customer types or order types that are exempt from validation? | Business | Open |
| 7 | Scope and Boundary | Should batch/EDI orders also go through this validation in a future phase? | Business | Open |

---

## Functional Summary

- **Document Level:** L3 Full
- **Change Type:** New Function
- **Target Platform:** IBM i
- **Total Functional Requirements (FR):** 9 (9 new, 0 modified)
- **Total Business Rules (BR):** 7 (7 new, 0 modified)
- **Total Exception Scenarios:** 5
- **Total Acceptance Criteria:** 9
- **Total Open Questions:** 7
- **Business Review Ready:** No — notification delivery mechanism and credit limit boundary condition must be confirmed before scope approval
