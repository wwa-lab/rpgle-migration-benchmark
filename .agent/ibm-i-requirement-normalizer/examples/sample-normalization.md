# Sample Normalization — Inactive Customer Order Block

Calibration example showing the normalized requirement package format for a mixed
business/technical email request.

---

**Raw Input (email from business user):**

> Hey team,
>
> We had another issue last week where an order got placed for a customer that's been
> inactive for months. Can we add a check so inactive customers can't place orders?
> I think the order entry program is where this needs to go. The customer status is in
> the CUSTMAST file if that helps. Not sure what field exactly but there's definitely
> a status flag in there. We need this done before end of quarter if possible.
>
> Thanks,
> Sarah

---

## Request Summary

- **Normalizer ID:** NR-20260402-01
- **Input Type:** Conversational fragment
- **Change Type:** Enhancement to Existing
- **Target Platform:** IBM i — program type not specified
- **Related Process or Program:** Order entry program (name not specified)

---

## Change Intent

Add a validation check to the order entry process that prevents orders from being placed
when the customer's status is inactive.

---

## Business Goal

Prevent orders from being incorrectly placed for inactive customers, avoiding downstream
processing issues and data quality problems. (Inferred)

---

## Scope Signals

- **Estimated complexity:** Small — single validation check in an existing process
- **Affected area:** Order entry
- **Multiple programs likely:** Unclear — depends on whether order entry is a single program or calls subroutines
- **New process or change to existing:** Existing

---

## Known Facts

- Orders have been placed for inactive customers (this has happened at least once recently)
- A customer status indicator exists in the CUSTMAST file
- The order entry program is the intended location for the change
- The change is needed before end of quarter

---

## Inferred Items

- The CUSTMAST file contains a status field that distinguishes active from inactive customers (Inferred)
- The order entry program already reads from or has access to the CUSTMAST file (Inferred)
- "Inactive" is a specific status value, not a derived condition (Inferred)
- The check should occur before the order is committed, not after (Inferred)

---

## Missing Information

| # | What Is Missing | Needed By |
|---|-----------------|-----------|
| 1 | Exact field name for customer status in CUSTMAST | Functional Spec — Business Rules; Program Spec — Data Contract |
| 2 | Valid values for the status field (what constitutes "inactive" vs "active" vs other states) | Functional Spec — Business Rules |
| 3 | Program name for the order entry program | Functional Spec — Scope; Program Spec — Spec Header |
| 4 | Expected behavior when an inactive customer is detected (error message text, return code, screen behavior) | Functional Spec — Exception Scenarios |
| 5 | Whether existing orders for inactive customers need retroactive handling | Functional Spec — Scope (in-scope / out-of-scope) |
| 6 | Whether this applies to all order types or specific ones | Functional Spec — Business Rules |

---

## Technical Hints

- Customer master data is stored in the CUSTMAST file
- The order entry program is the target for the change
- A status flag exists in CUSTMAST (exact field name not provided)

---

## Candidate Actors / Triggers

| Actor / Trigger | Type | Source | Status |
|-----------------|------|--------|--------|
| Order entry operator | Actor | Inferred | Needs Confirmation |
| Order submission | Trigger | Inferred | Needs Confirmation |

---

## Candidate Functional Changes

CF-01: The order entry process must validate customer status before allowing an order to be placed. (NEW)
CF-02: If the customer is inactive, the order must be blocked and the user notified. (NEW)

---

## Candidate Business Rules

CBR-01: Inactive customers are not permitted to have new orders placed against them. (Stated)
CBR-02: Customer status is determined by a flag in the CUSTMAST file. (Stated)
CBR-03: The inactive check must occur before the order is committed. (Inferred)

---

## Candidate Exceptions

| # | Scenario | Source |
|---|----------|--------|
| CE-01 | Customer record not found in CUSTMAST during order entry | Inferred |
| CE-02 | Customer status field is blank or contains an unrecognized value | Inferred |

---

## Candidate Inputs / Outputs

### Inputs

| Input | Source | Status |
|-------|--------|--------|
| Customer identifier (from the order being entered) | Order entry screen or calling program | Inferred |
| Customer status | CUSTMAST file | Stated |

### Outputs

| Output | Destination | Status |
|--------|-------------|--------|
| Rejection message or indicator when customer is inactive | Order entry screen or calling program | Inferred |

---

## Suggested Downstream Document

**Recommended next step:** Functional Spec

**Rationale:** The business need is clear (block orders for inactive customers), but the
scope, acceptance criteria, and detailed behavior have not been formally defined. A
Functional Spec will formalize the business rules, define exception handling, and establish
acceptance criteria before design work begins.

**Readiness:** Partially ready — key details need resolution before the Functional Spec
can be fully generated.

**Critical items to resolve before proceeding:**
- Valid values for the customer status field (what exactly means "inactive")
- Expected user-facing behavior when an order is blocked (error message, screen action)
- Whether this check applies to all order types or only specific ones
- Program name for the order entry program

---

## Normalization Summary

- **Input Type:** Conversational fragment
- **Change Type:** Enhancement to Existing
- **Known Facts:** 4
- **Inferred Items:** 4
- **Missing Items:** 6
- **Candidate Functional Changes (CF):** 2
- **Candidate Business Rules (CBR):** 3
- **Candidate Exceptions (CE):** 2
- **Recommended Next Step:** Functional Spec
- **Readiness:** Partially ready — needs resolution
