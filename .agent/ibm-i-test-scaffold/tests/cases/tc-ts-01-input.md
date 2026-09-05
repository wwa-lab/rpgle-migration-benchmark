## UT Plan Header

- **UT Plan ID:** UTP-20260409-01
- **Version:** 1.0
- **Status:** Draft
- **Change Size:** Small
- **Change Mode:** Batch
- **Change Type:** Enhancement
- **Source Documents:** PS-ORDCLOSE-20260409-01
- **Generated Without Program Spec:** No

---

## Change Summary

Close an open order by order number. The program updates `ORDHDR` status from `O`
to `C` and stamps the close date.

---

## Impacted Artifacts

| # | Artifact | Type | Impact |
|---|----------|------|--------|
| 1 | ORDCLOSE | RPGLE | MODIFIED |
| 2 | ORDHDR | PF | MODIFIED |

---

## Test Data Design

| File | Key | Field Values | Used By |
|------|-----|-------------|---------|
| ORDHDR | ORDNO=9000001 | ORDSTS='O', CHGDAT=0, CHGTIM=0 | UT-01 |

---

## UT Cases

### Batch Order Close — Compact Matrix

| UT | Objective | Source Ref | Input | Expected Result | Priority |
|----|-----------|-----------|-------|-----------------|----------|
| UT-01 | Close open order | PS:BR-01 | ORDNO=9000001 | ORDHDR status becomes `C` and close date is updated | P1 |
