## UT Plan Header

- **UT Plan ID:** UTP-20260409-03
- **Version:** 1.0
- **Status:** Draft
- **Change Size:** Medium
- **Change Mode:** CL Wrapper
- **Change Type:** Enhancement
- **Source Documents:** PS-BILLEXTR-20260409-01
- **Generated Without Program Spec:** No

---

## Change Summary

Submit nightly billing extract in batch and stamp the control data area with
the requested run date.

---

## Impacted Artifacts

| # | Artifact | Type | Impact |
|---|----------|------|--------|
| 1 | BILLEXTR | CLLE | MODIFIED |
| 2 | RPTWORK | PF | WRITE |
| 3 | CTLARA | DTAARA | UPDATE |

---

## Test Data Design

| File | Key | Field Values | Used By |
|------|-----|-------------|---------|
| RPTWORK | RUNDT=20260409 | RUNSTS='P' | UT-01 |

---

## UT Cases

### CL Wrapper Billing Extract — Compact Matrix

| UT | Objective | Source Ref | Input | Expected Result | Priority |
|----|-----------|-----------|-------|-----------------|----------|
| UT-01 | Submit billing extract and stamp control data area | PS:BR-04 | RUNDT=20260409 | Batch job is submitted, output rows created, data area updated | P1 |
