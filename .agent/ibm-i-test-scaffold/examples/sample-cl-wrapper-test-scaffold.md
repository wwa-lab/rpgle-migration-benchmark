# Sample CL Wrapper Test Scaffold — Billing Extract Control

Calibration example showing a CL wrapper scaffold with `CRTBNDCL`, batch submission,
and manual verification of CL-specific side effects.

---

# Test Scaffold

- **UT Plan:** UTP-20260409-03
- **Version:** 1.0
- **Generated:** 2026-04-09
- **Program:** BILLEXTR
- **Test Library:** TSTLIB
- **Source Library:** SRCLIB
- **Program Library:** PGMLIB
- **Test Scope:** Medium
- **Program Type:** CL

---

## Open Questions / Prerequisites

- Job queue `QBATCH` is assumed to be available for test submission.

---

## Artifact 1: Environment Setup (CL)

```cl
ADDLIBLE LIB(TSTLIB) POSITION(*FIRST)
CRTDUPOBJ OBJ(RPTWORK) FROMLIB(PRODLIB) OBJTYPE(*FILE) TOLIB(TSTLIB) DATA(*NO)
OVRDBF FILE(RPTWORK) TOFILE(TSTLIB/RPTWORK)
```

---

## Artifact 2: Compile (CL)

```cl
CRTBNDCL PGM(PGMLIB/BILLEXTR) +
  SRCFILE(SRCLIB/QCLLESRC) +
  SRCMBR(BILLEXTR) +
  DBGVIEW(*SOURCE) +
  OPTION(*EVENTF)

DSPOBJD OBJ(PGMLIB/BILLEXTR) OBJTYPE(*PGM)
```

---

## Artifact 3: Test Data Setup (SQL)

```sql
INSERT INTO TSTLIB/RPTWORK (RUNDT, RUNSTS)
  VALUES (20260409, 'P');
```

---

## Artifact 4: Test Execution

```cl
SBMJOB CMD(CALL PGM(PGMLIB/BILLEXTR) PARM('20260409')) +
  JOB(TSTBILL) JOBQ(QBATCH)
```

Manual verification:

- `DSPDTAARA DTAARA(TSTLIB/CTLARA)` — expected run date = `20260409`
- `WRKJOB JOB(TSTBILL)` — expected job completes normally

---

## Artifact 5: Result Verification (SQL)

```sql
SELECT COUNT(*) AS REC_COUNT,
       CASE WHEN COUNT(*) > 0 THEN 'PASS' ELSE '** FAIL **' END AS UT01_RESULT
FROM TSTLIB/RPTWORK
WHERE RUNDT = 20260409;
```

---

## Artifact 6: Cleanup (SQL)

```sql
DELETE FROM TSTLIB/RPTWORK
WHERE RUNDT = 20260409;
```
