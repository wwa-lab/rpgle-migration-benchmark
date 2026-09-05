# Sample Interactive RPGLE Test Scaffold — Order Entry Screen

Calibration example showing how the scaffold handles an interactive RPGLE program:
data setup and verification are automated, while execution remains a manual screen guide.

---

# Test Scaffold

- **UT Plan:** UTP-20260409-02
- **Version:** 1.0
- **Generated:** 2026-04-09
- **Program:** ORD200
- **Test Library:** TSTLIB
- **Source Library:** SRCLIB
- **Program Library:** PGMLIB
- **Test Scope:** Small
- **Program Type:** Interactive

---

## Open Questions / Prerequisites

- Display file `ORDDSP` is assumed to be available in the test environment.

---

## Artifact 1: Environment Setup (CL)

```cl
ADDLIBLE LIB(TSTLIB) POSITION(*FIRST)
CRTDUPOBJ OBJ(CUSTMAST) FROMLIB(PRODLIB) OBJTYPE(*FILE) TOLIB(TSTLIB) DATA(*NO)
CRTDUPOBJ OBJ(ORDHDR) FROMLIB(PRODLIB) OBJTYPE(*FILE) TOLIB(TSTLIB) DATA(*NO)
OVRDBF FILE(CUSTMAST) TOFILE(TSTLIB/CUSTMAST)
OVRDBF FILE(ORDHDR) TOFILE(TSTLIB/ORDHDR)
```

---

## Artifact 2: Compile (CL)

```cl
CRTBNDRPG PGM(PGMLIB/ORD200) +
  SRCFILE(SRCLIB/QRPGLESRC) +
  SRCMBR(ORD200) +
  DBGVIEW(*SOURCE) +
  OPTION(*EVENTF)

DSPOBJD OBJ(PGMLIB/ORD200) OBJTYPE(*PGM)
```

---

## Artifact 3: Test Data Setup (SQL)

```sql
INSERT INTO TSTLIB/CUSTMAST (CUSNO, CUSNAM, CUSSTS)
  VALUES (90001, 'ACTIVE CUSTOMER', 'A');
```

---

## Artifact 4: Test Execution

### Interactive Cases

1. Sign on to the test environment.
2. Verify library list includes `TSTLIB` first.
3. Call the program: `CALL PGM(PGMLIB/ORD200)`.
4. Enter customer number `90001` and press Enter.
5. Enter order quantity and confirm the transaction.
6. Verify the confirmation message is displayed.
7. Exit the program and run Artifact 5 verification SQL.

---

## Artifact 5: Result Verification (SQL)

### After-State Queries

```sql
SELECT ORDNO,
       CUSNO,
       CASE WHEN CUSNO = 90001 THEN 'PASS' ELSE '** FAIL **' END AS UT01_RESULT
FROM TSTLIB/ORDHDR
WHERE CUSNO = 90001;
```

### Test Results Summary

```sql
SELECT 'UT-01' AS TEST_CASE,
       CASE WHEN EXISTS (SELECT 1
                           FROM TSTLIB/ORDHDR
                          WHERE CUSNO = 90001)
            THEN 'PASS'
            ELSE '** FAIL **'
       END AS RESULT
FROM SYSIBM/SYSDUMMY1;
```

---

## Artifact 6: Cleanup (SQL)

```sql
DELETE FROM TSTLIB/ORDHDR
WHERE CUSNO = 90001;

DELETE FROM TSTLIB/CUSTMAST
WHERE CUSNO = 90001;
```
