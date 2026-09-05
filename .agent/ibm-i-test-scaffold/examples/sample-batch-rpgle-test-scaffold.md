# Sample Batch RPGLE Test Scaffold — Order Close

Calibration example showing a batch RPGLE test scaffold with compile, test data,
execution, verification, and cleanup artifacts.

---

# Test Scaffold

- **UT Plan:** UTP-20260409-01
- **Version:** 1.0
- **Generated:** 2026-04-09
- **Program:** ORDCLOSE
- **Test Library:** TSTLIB
- **Source Library:** SRCLIB
- **Program Library:** PGMLIB
- **Test Scope:** Small
- **Program Type:** Batch

---

## Open Questions / Prerequisites

- None for this sample. File names, source member, and test library are confirmed.

---

## Artifact 1: Environment Setup (CL)

```cl
/* Environment setup for ORDCLOSE */
ADDLIBLE LIB(TSTLIB) POSITION(*FIRST)
CRTDUPOBJ OBJ(ORDHDR) FROMLIB(PRODLIB) OBJTYPE(*FILE) TOLIB(TSTLIB) DATA(*NO)
OVRDBF FILE(ORDHDR) TOFILE(TSTLIB/ORDHDR)
```

---

## Artifact 2: Compile (CL)

```cl
/* Compile ORDCLOSE for test execution */
CRTBNDRPG PGM(PGMLIB/ORDCLOSE) +
  SRCFILE(SRCLIB/QRPGLESRC) +
  SRCMBR(ORDCLOSE) +
  DBGVIEW(*SOURCE) +
  OPTION(*EVENTF)

DSPOBJD OBJ(PGMLIB/ORDCLOSE) OBJTYPE(*PGM)
```

---

## Artifact 3: Test Data Setup (SQL)

```sql
-- =================================================================
-- Test Scaffold: Test Data Setup
-- UT Plan: UTP-20260409-01
-- Generated: 2026-04-09
-- Test Library: TSTLIB
-- Program: ORDCLOSE
-- =================================================================

INSERT INTO TSTLIB/ORDHDR (ORDNO, ORDSTS, CHGDAT, CHGTIM)
  VALUES (9000001, 'O', 0, 0);
```

---

## Artifact 4: Test Execution

```cl
/* UT-01: Close open order */
CALL PGM(PGMLIB/ORDCLOSE) PARM('9000001')
```

---

## Artifact 5: Result Verification (SQL)

### Before-State Queries

```sql
SELECT ORDNO, ORDSTS, CHGDAT, CHGTIM
FROM TSTLIB/ORDHDR
WHERE ORDNO = 9000001;
```

### After-State Queries

```sql
SELECT ORDNO,
       ORDSTS,
       CASE WHEN ORDSTS = 'C' THEN 'PASS' ELSE '** FAIL **' END AS UT01_RESULT
FROM TSTLIB/ORDHDR
WHERE ORDNO = 9000001;
```

### Test Results Summary

```sql
SELECT 'UT-01' AS TEST_CASE,
       CASE WHEN (SELECT ORDSTS
                    FROM TSTLIB/ORDHDR
                   WHERE ORDNO = 9000001) = 'C'
            THEN 'PASS'
            ELSE '** FAIL **'
       END AS RESULT
FROM SYSIBM/SYSDUMMY1;
```

---

## Artifact 6: Cleanup (SQL)

```sql
DELETE FROM TSTLIB/ORDHDR
WHERE ORDNO = 9000001;
```
