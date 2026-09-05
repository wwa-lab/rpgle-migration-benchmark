## UT Plan Header

- **UT Plan ID:** UTP-20260409-04
- **Version:** 1.0
- **Status:** Draft
- **Change Size:** Medium
- **Change Mode:** Service Program
- **Change Type:** New Program
- **Source Documents:** PS-PRCUTIL-20260409-01
- **Generated Without Program Spec:** No

---

## Change Summary

Create service program `PRCUTIL` with exported procedure `CALCPRICE` that
computes price and writes an audit row.

---

## Impacted Artifacts

| # | Artifact | Type | Impact |
|---|----------|------|--------|
| 1 | PRCUTIL | SRVPGM | NEW |
| 2 | PRCAUD | PF | WRITE |

---

## Test Data Design

| File | Key | Field Values | Used By |
|------|-----|-------------|---------|
| PRCAUD | REQID='TST0001' | SKU='SKU-001', CALCSTS='P' | UT-01 |

---

## UT Cases

### Service Program Pricing — Compact Matrix

| UT | Objective | Source Ref | Input | Expected Result | Priority |
|----|-----------|-----------|-------|-----------------|----------|
| UT-01 | Calculate price and complete audit row | PS:BR-03 | SKU='SKU-001', QTY=10 | Returned price is `125.00` and audit row status becomes `C` | P1 |
