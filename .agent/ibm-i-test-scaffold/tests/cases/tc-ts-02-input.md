## UT Plan Header

- **UT Plan ID:** UTP-20260409-02
- **Version:** 1.0
- **Status:** Draft
- **Change Size:** Small
- **Change Mode:** Interactive
- **Change Type:** Enhancement
- **Source Documents:** PS-ORD200-20260409-01
- **Generated Without Program Spec:** No

---

## Change Summary

Enhance order entry screen `ORD200` to accept customer `90001` and create an
order header row after confirmation.

---

## Impacted Artifacts

| # | Artifact | Type | Impact |
|---|----------|------|--------|
| 1 | ORD200 | RPGLE | MODIFIED |
| 2 | CUSTMAST | PF | READ |
| 3 | ORDHDR | PF | WRITE |

---

## Test Data Design

| File | Key | Field Values | Used By |
|------|-----|-------------|---------|
| CUSTMAST | CUSNO=90001 | CUSNAM='ACTIVE CUSTOMER', CUSSTS='A' | UT-01 |

---

## UT Cases

### Order Entry Screen — Compact Matrix

| UT | Objective | Source Ref | Input | Expected Result | Priority |
|----|-----------|-----------|-------|-----------------|----------|
| UT-01 | Create order for active customer | PS:BR-02 | CUSNO=90001, quantity=10 | Order created and confirmation shown on screen | P1 |
