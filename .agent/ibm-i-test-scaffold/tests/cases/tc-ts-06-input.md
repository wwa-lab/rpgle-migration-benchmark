## UT Plan Header

- **UT Plan ID:** UTP-20260409-06
- **Version:** 1.0
- **Status:** Draft
- **Change Size:** Small
- **Change Mode:** Batch
- **Change Type:** Defect Fix
- **Source Documents:** CR-20260409-06
- **Generated Without Program Spec:** Yes

---

## Change Summary

Fix batch validation for product dates. Library names and source member are not yet confirmed.

---

## Impacted Artifacts

| # | Artifact | Type | Impact |
|---|----------|------|--------|
| 1 | PRDVAL | RPGLE | MODIFIED |
| 2 | PRDMAST | PF | READ |

---

## Open Questions

1. Confirm test library name.
2. Confirm source library and source member.
3. Confirm product date format in `PRDMAST`.

---

## UT Cases

### Product Date Validation — Compact Matrix

| UT | Objective | Source Ref | Input | Expected Result | Priority |
|----|-----------|-----------|-------|-----------------|----------|
| UT-01 | Reject expired product | (Inferred) | PRDNO='P10045' | Validation result = `N` | P1 |
