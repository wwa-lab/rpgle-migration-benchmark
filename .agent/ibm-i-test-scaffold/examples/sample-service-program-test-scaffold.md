# Sample Service Program Test Scaffold — Pricing Utilities

Calibration example showing the service-program path: compile modules, create the
service program, and document the required caller stub for execution.

---

# Test Scaffold

- **UT Plan:** UTP-20260409-04
- **Version:** 1.0
- **Generated:** 2026-04-09
- **Program:** PRCUTIL
- **Test Library:** TSTLIB
- **Source Library:** SRCLIB
- **Program Library:** PGMLIB
- **Test Scope:** Medium
- **Program Type:** Service Program

---

## Open Questions / Prerequisites

- Caller stub program name is TBD and must be confirmed before execution.

---

## Artifact 1: Environment Setup (CL)

```cl
ADDLIBLE LIB(TSTLIB) POSITION(*FIRST)
CRTDUPOBJ OBJ(PRCAUD) FROMLIB(PRODLIB) OBJTYPE(*FILE) TOLIB(TSTLIB) DATA(*NO)
OVRDBF FILE(PRCAUD) TOFILE(TSTLIB/PRCAUD)
```

---

## Artifact 2: Compile (CL)

```cl
CRTRPGMOD MODULE(PGMLIB/PRCUTIL) +
  SRCFILE(SRCLIB/QRPGLESRC) +
  SRCMBR(PRCUTIL) +
  DBGVIEW(*SOURCE) +
  OPTION(*EVENTF)

CRTSRVPGM SRVPGM(PGMLIB/PRCUTIL) +
  MODULE(PGMLIB/PRCUTIL) +
  EXPORT(*ALL)
```

---

## Artifact 3: Test Data Setup (SQL)

```sql
INSERT INTO TSTLIB/PRCAUD (REQID, SKU, CALCSTS)
  VALUES ('TST0001', 'SKU-001', 'P');
```

---

## Artifact 4: Test Execution

### Service Program Cases

- Caller stub required: compile or reuse a small test harness program that invokes
  exported procedure `CALCPRICE`.
- Parameter set for UT-01:
  - `SKU = 'SKU-001'`
  - `QTY = 10`
  - expected return price = `125.00`

---

## Artifact 5: Result Verification (SQL)

```sql
SELECT REQID,
       CALCSTS,
       CASE WHEN CALCSTS = 'C' THEN 'PASS' ELSE '** FAIL **' END AS UT01_RESULT
FROM TSTLIB/PRCAUD
WHERE REQID = 'TST0001';
```

---

## Artifact 6: Cleanup (SQL)

```sql
DELETE FROM TSTLIB/PRCAUD
WHERE REQID = 'TST0001';
```
