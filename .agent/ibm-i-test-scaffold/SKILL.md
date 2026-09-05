---
name: ibm-i-test-scaffold
description: >
  Generates executable SQL/CL test scripts from UT Plans for IBM i (AS/400) RPGLE
  and CLLE programs. V1.1 — produces six lifecycle artifacts: environment setup (CL),
  compile commands (CL), test data setup (SQL INSERT), execution commands (CL CALL/SBMJOB),
  result verification (SQL queries with PASS/FAIL evaluation), and cleanup (SQL DELETE).
  Uses DB2 for i SQL with system naming convention. Supports TDD workflow — test scripts
  can be generated before code exists. Does not execute tests, connect to IBM i, or
  modify UT Plans.
---

# IBM i Test Scaffold Generator (V1.1)

Generates executable SQL and CL test scripts from a UT Plan for IBM i RPGLE and CLLE
programs. The output is a structured set of scripts that automate the manual test
lifecycle: environment setup → compile → test data → execute → verify → cleanup.

**Document Chain Position:**

```
Program Spec → Code Generator → Code → Code Review
     │                           │         │
     └──→ UT Plan Generator ←───┘─────────┘
              │
              ↓
         Test Scaffold  ← (this skill)
         (SQL/CL scripts)
```

| Input | Output | Key Question |
|-------|--------|--------------|
| UT Plan (primary) or Program Spec + test scenarios | Executable SQL/CL test scripts | What scripts does a developer need to set up, run, and verify each test case on IBM i? |

---

## When to Use

Trigger on:
- User has a UT Plan and asks to "generate test scripts", "create test data", or "set up test cases"
- User asks to "automate testing" or "create mock data" for an IBM i program
- User wants TDD support — test scripts before implementation
- User provides test scenarios and wants executable SQL/CL

**Do NOT trigger** when:
- User wants a UT Plan (use `ibm-i-ut-plan-generator`)
- User wants to review code (use `ibm-i-code-reviewer`)
- User wants to execute tests on actual IBM i (this skill generates scripts, not connections)
- Target platform is not IBM i

---

## TDD Support

This skill supports Test-Driven Development on IBM i. Test scripts can be generated
**before code exists** because they derive from the UT Plan (which derives from the
Program Spec), not from the implementation.

TDD flow:
1. Program Spec → UT Plan (existing skills)
2. UT Plan → **Test Scaffold** (this skill) — compile commands + data + verification ready
3. Write/generate RPGLE/CLLE code
4. Run Artifact 2 (compile) on IBM i
5. Run Artifact 3 (test data) + Artifact 4 (execute) + Artifact 5 (verify) → check PASS/FAIL
6. Fix code → re-compile → re-run verification → iterate until all PASS

The compile and execution scripts contain the correct commands for the target
programs. In TDD mode, Artifacts 3–6 are ready before code exists; the developer
writes code, then runs Artifact 2 to compile and proceeds to testing.

---

## Input Specification

### Primary Input: UT Plan

The UT Plan provides everything needed:

| UT Plan Section | Maps To |
|----------------|---------|
| Impacted Artifacts | Environment setup — which files to prepare |
| Test Data Design | SQL INSERT — baseline and case-specific records |
| UT Cases (Input/Preconditions) | Data setup + execution parameters |
| UT Cases (Expected Result) | Verification queries |
| UT Cases (DB Verification) | Before/after SQL queries |
| Shared Preconditions | Shared data setup block |

### Secondary Input: Program Spec + Test Scenarios

When no UT Plan exists, accept a Program Spec with user-described test scenarios.
Extract file usage, parameters, and expected behavior. Label all inferences.

### Required Context (from user or UT Plan)

| Item | Purpose | Example |
|------|---------|---------|
| **Test library name** | All test data goes here | `TSTLIB`, `QATEST` |
| **Source library name** | Where production files live (for CRTDUPOBJ) | `PRODLIB`, `APPLIB` |
| **Program library name** | Where compiled programs reside | `DEVLIB`, `PGMLIB` |
| **Source file name** | Where source members reside (for compile) | `QRPGLESRC`, `QCLLESRC` |
| **Source member name** | Source member to compile | Program name or member name |
| **Program type** | Determines compile command | RPGLE bound / RPGLE module / CLLE bound / Service program |

If not provided, use `TBD` placeholders and note in Open Questions. Program type
and source member can often be inferred from the UT Plan's Impacted Artifacts.

---

## Output Artifacts

Six scripts, each independently runnable:

| # | Artifact | Format | Run Via | Purpose |
|---|----------|--------|---------|---------|
| 1 | **Environment Setup** | CL commands | Command line / CL source | Prepare test library, copy files, set library list |
| 2 | **Compile** | CL commands | Command line / CL source | CRTBNDRPG / CRTBNDCL / CRTRPGMOD + CRTPGM for target programs |
| 3 | **Test Data Setup** | SQL script | RUNSQLSTM / ACS Run SQL Scripts | INSERT baseline and case-specific test records |
| 4 | **Test Execution** | CL commands | Command line / CL source | CALL/SBMJOB for each test case |
| 5 | **Result Verification** | SQL script | RUNSQLSTM / ACS Run SQL Scripts | SELECT + PASS/FAIL evaluation per test case |
| 6 | **Cleanup** | SQL script | RUNSQLSTM / ACS Run SQL Scripts | DELETE test records, restore state |

### Artifact Independence

Each script is self-contained with comments explaining what it does and which UT
cases it serves. A developer can run any script independently — verification can
be re-run without re-inserting data, cleanup can be run at any time.

---

## Generation Decisions

### Decision 1 — Test Scope Size

Derived from the UT Plan's Change Size:

| Size | Cases | Script Style |
|------|-------|-------------|
| **Small** | 1–8 | Combined scripts, inline comments |
| **Medium** | 9–20 | Sectioned scripts with case group headers |
| **Large** | 20+ | Per-artifact grouping, full before/after snapshots |

### Decision 2 — Program Type

| Type | Execution Pattern | Verification Focus |
|------|------------------|-------------------|
| **Interactive RPGLE** | Manual screen interaction (script provides data setup + verification only) | DB state after interaction |
| **Batch RPGLE** | SBMJOB + CALL | DB state + spool output |
| **CL Program** | CALL with parameters | Effects: files, data areas, messages, job attributes |
| **Service Program** | Needs caller stub | Return values + side effects |

### Decision 3 — Data Complexity

| Complexity | Indicators | Data Strategy |
|-----------|------------|--------------|
| **Simple** | 1–2 files, no cross-file dependencies | Flat INSERT per case |
| **Multi-file** | 3+ files, master-detail relationships | Ordered INSERT with dependency comments |
| **Stateful** | Tests depend on prior state transitions | Phased data blocks with sequence markers |

---

## Test Environment Model

All test data lives in a dedicated test library. Production data is never modified.

### Library Strategy

```
PRODLIB  — production files (read-only, source for CRTDUPOBJ)
TSTLIB   — test library (test data lives here)
PGMLIB   — program library (where compiled programs reside)
```

### File Preparation Patterns

| Scenario | Command | When |
|----------|---------|------|
| File exists in production, need empty copy | `CRTDUPOBJ OBJ(file) FROMLIB(PRODLIB) OBJTYPE(*FILE) TOLIB(TSTLIB) DATA(*NO)` | Most common — clean test file |
| File exists, need with data subset | `CRTDUPOBJ ... DATA(*YES)` then selective DELETE | Need some production data as baseline |
| File does not exist yet (TDD) | SQL `CREATE TABLE` or note as prerequisite | File spec not yet implemented |

### Library List Setup

```cl
ADDLIBLE LIB(TSTLIB) POSITION(*FIRST)
```

Placing TSTLIB first ensures program file operations hit test data, not production.
Alternative: use `OVRDBF` for selective file redirection when the program must also
access production data in other files.

---

## SQL Conventions (DB2 for i)

### System Naming

Use system naming convention (library/file) throughout:

```sql
-- System naming (correct for IBM i)
INSERT INTO TSTLIB/CUSTMAST (CUSNO, CUSNAM, CUSSTS)
  VALUES (90001, 'TEST CUSTOMER A', 'A');

-- Do NOT use schema.table dot notation in generated scripts
```

### Naming Rules

- Library qualifier: always explicit (`TSTLIB/filename`)
- No implicit library resolution
- Test record keys: use high-range values to avoid collision (90000+, 'TST*', 'ZZ*')
- Comments: reference UT case ID on every statement

### Data Type Handling

| IBM i Type | SQL Literal | Example |
|-----------|------------|---------|
| Packed/Zoned decimal | Numeric literal | `1234.56` |
| Character | Quoted string | `'ACTIVE'` |
| Date (DATE type) | Date literal | `'2026-04-09'` |
| Date (numeric YYYYMMDD) | Numeric | `20260409` |
| Date (numeric YYMMDD) | Numeric | `260409` |
| Indicator (1A) | Character | `'Y'`, `'N'`, `' '` |
| Timestamp | Timestamp literal | `'2026-04-09-10.30.00.000000'` |

When the date format is unknown, note in comments and use the most common format
with a TBD marker.

### SQL Script Header

Every SQL script starts with:

```sql
-- =================================================================
-- Test Scaffold: <artifact type>
-- UT Plan: <UTP-ID>
-- Generated: <date>
-- Test Library: <TSTLIB>
-- Program: <program name>
-- =================================================================
-- Run via: RUNSQLSTM SRCSTMF('/path/script.sql') COMMIT(*NONE)
--      or: ACS Run SQL Scripts (paste content)
-- =================================================================
```

---

## CL Conventions

### Command Format

CL commands are generated as standalone commands (one per line), not as compiled CL
program source. This allows direct copy-paste execution on the 5250 command line.

For longer sequences, a compilable CL source wrapper is provided as an alternative.

### CL Command Style

```cl
/* UT-01: Environment setup */
ADDLIBLE LIB(TSTLIB) POSITION(*FIRST)
OVRDBF FILE(CUSTMAST) TOFILE(TSTLIB/CUSTMAST)

/* UT-01: Execute — active customer places order */
CALL PGM(PGMLIB/ORD200) PARM('90001')
```

### Batch Execution Pattern

```cl
/* UT-05: Batch job submission */
SBMJOB CMD(CALL PGM(PGMLIB/BATCHPGM) PARM('20260401' '20260430')) +
  JOB(TSTBATCH) JOBQ(QBATCH)

/* Check completion: WRKJOB JOB(TSTBATCH) — verify job ended normally */
```

### Error Monitoring (CL wrapper variant)

When generating a CL source wrapper, include MONMSG for expected error cases:

```cl
CALL PGM(PGMLIB/TESTPGM) PARM(&PARM1)
MONMSG MSGID(CPF0000) EXEC(DO)
  SNDPGMMSG MSG('UT-nn: Program signaled error as expected') +
    TOPGMQ(*EXT)
ENDDO
```

---

## Compile Command Patterns

Compile commands bridge the gap between generated source and executable programs.
The skill generates the correct compile command for each program in the UT Plan's
Impacted Artifacts.

### Compile Command Reference

| Program Type | Command | Typical Usage |
|-------------|---------|--------------|
| Bound RPGLE program | `CRTBNDRPG` | Most common — single-module RPGLE |
| RPGLE module (for service program) | `CRTRPGMOD` | Module to be bound into SRVPGM |
| Service program | `CRTSRVPGM` | After CRTRPGMOD |
| Bound CL program | `CRTBNDCL` | Most common — CL program |
| CL module | `CRTCLMOD` | Module to be bound into PGM |
| Program from modules | `CRTPGM` | Multi-module program |

### RPGLE Compile Commands

```cl
/* Bound RPGLE program (most common) */
CRTBNDRPG PGM(PGMLIB/ORD200) +
  SRCFILE(SRCLIB/QRPGLESRC) +
  SRCMBR(ORD200) +
  DBGVIEW(*SOURCE) +
  OPTION(*EVENTF)

/* RPGLE module (for service program or multi-module) */
CRTRPGMOD MODULE(PGMLIB/ORDUTIL) +
  SRCFILE(SRCLIB/QRPGLESRC) +
  SRCMBR(ORDUTIL) +
  DBGVIEW(*SOURCE) +
  OPTION(*EVENTF)

/* Service program from module */
CRTSRVPGM SRVPGM(PGMLIB/ORDUTIL) +
  MODULE(PGMLIB/ORDUTIL) +
  EXPORT(*ALL)
```

### CLLE Compile Commands

```cl
/* Bound CL program (most common) */
CRTBNDCL PGM(PGMLIB/ORDCTL) +
  SRCFILE(SRCLIB/QCLLESRC) +
  SRCMBR(ORDCTL) +
  DBGVIEW(*SOURCE) +
  OPTION(*EVENTF)
```

### Multi-Module Program

```cl
/* Step 1: Compile each module */
CRTRPGMOD MODULE(PGMLIB/MOD001) +
  SRCFILE(SRCLIB/QRPGLESRC) SRCMBR(MOD001) +
  DBGVIEW(*SOURCE) OPTION(*EVENTF)
CRTRPGMOD MODULE(PGMLIB/MOD002) +
  SRCFILE(SRCLIB/QRPGLESRC) SRCMBR(MOD002) +
  DBGVIEW(*SOURCE) OPTION(*EVENTF)

/* Step 2: Bind modules into program */
CRTPGM PGM(PGMLIB/MAINPGM) +
  MODULE(PGMLIB/MOD001 PGMLIB/MOD002) +
  ACTGRP(*NEW)
```

### Compile Options

| Option | Purpose | Default |
|--------|---------|---------|
| `DBGVIEW(*SOURCE)` | Allow source-level debug | Always include for test builds |
| `OPTION(*EVENTF)` | Generate event file for RDi/SEU error listing | Always include |
| `ACTGRP(*NEW)` | Activation group — isolated for testing | Use for bound programs |
| `BNDDIR(binddir)` | Binding directory for service programs | Include when known from spec |
| `TGTRLS(*CURRENT)` | Target release | Default unless spec says otherwise |

### Compile Validation

After each compile command, include a verification step:

```cl
/* Verify compile succeeded */
DSPOBJD OBJ(PGMLIB/ORD200) OBJTYPE(*PGM)
/* If error: WRKSPLF — check compile listing for errors */
```

### Inference Rules

When the UT Plan does not explicitly state the compile command:

| Available Information | Infer |
|-----------------------|-------|
| Impacted Artifact type = RPGLE, Impact = NEW or MODIFIED | `CRTBNDRPG` (default for single RPGLE) |
| Impacted Artifact type = CLLE, Impact = NEW or MODIFIED | `CRTBNDCL` (default for CL) |
| Program Spec mentions SRVPGM or exports procedures | `CRTRPGMOD` + `CRTSRVPGM` |
| Multiple modules listed for one program | `CRTRPGMOD` per module + `CRTPGM` |
| Source file name unknown | Use `QRPGLESRC` for RPGLE, `QCLLESRC` for CLLE (most common) |

Label all inferred compile commands with `(Inferred)` in comments.

---

## Verification Patterns

### PASS/FAIL Evaluation

Every verification query produces a clear PASS/FAIL result:

```sql
-- UT-01: Within validity — Expected PRDVLD = 'Y'
SELECT
  PRDNO,
  PRDVLD,
  CASE WHEN PRDVLD = 'Y' THEN 'PASS' ELSE '** FAIL **' END AS UT01_RESULT
FROM TSTLIB/PRDMAST
WHERE PRDNO = 'P10045';
```

### Before/After Comparison

For file-modifying operations, generate both snapshots:

```sql
-- UT-03: Before execution — capture baseline
-- (Run BEFORE calling the program)
SELECT ORDNO, ORDSTS, CHGDAT, CHGTIM
FROM TSTLIB/ORDMAST
WHERE ORDNO = 90001;
-- Expected before: ORDSTS='O', CHGDAT=0, CHGTIM=0

-- UT-03: After execution — verify changes
-- (Run AFTER calling the program)
SELECT
  ORDNO, ORDSTS, CHGDAT, CHGTIM,
  CASE WHEN ORDSTS = 'C'
        AND CHGDAT = DECIMAL(CHAR(CURRENT DATE, ISO), 8, 0)
       THEN 'PASS' ELSE '** FAIL **' END AS UT03_RESULT
FROM TSTLIB/ORDMAST
WHERE ORDNO = 90001;
```

### Record Count Verification

```sql
-- UT-07: Batch created 3 output records
SELECT
  COUNT(*) AS REC_COUNT,
  CASE WHEN COUNT(*) = 3 THEN 'PASS' ELSE '** FAIL **' END AS UT07_RESULT
FROM TSTLIB/OUTRPT
WHERE RPTKEY LIKE 'TST%';
```

### Record Absence Verification

```sql
-- UT-09: Deleted record should not exist
SELECT
  CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE '** FAIL **' END AS UT09_RESULT
FROM TSTLIB/CUSTMAST
WHERE CUSNO = 90005;
```

### Multi-Field Verification

```sql
-- UT-12: Multiple fields updated correctly
SELECT
  CUSNO, CUSNAM, CUSSTS, CUSLMT,
  CASE WHEN CUSNAM = 'UPDATED NAME'
        AND CUSSTS = 'A'
        AND CUSLMT = 50000.00
       THEN 'PASS' ELSE '** FAIL **' END AS UT12_RESULT
FROM TSTLIB/CUSTMAST
WHERE CUSNO = 90001;
```

### Summary Dashboard Query

A final combined query at the end of the verification script:

```sql
-- =================================================================
-- TEST RESULTS SUMMARY
-- =================================================================
SELECT 'UT-01' AS TEST_CASE,
  CASE WHEN (SELECT PRDVLD FROM TSTLIB/PRDMAST WHERE PRDNO = 'P10045') = 'Y'
       THEN 'PASS' ELSE '** FAIL **' END AS RESULT
FROM SYSIBM/SYSDUMMY1
UNION ALL
SELECT 'UT-02',
  CASE WHEN (SELECT PRDVLD FROM TSTLIB/PRDMAST WHERE PRDNO = 'P10046') = 'N'
       THEN 'PASS' ELSE '** FAIL **' END
FROM SYSIBM/SYSDUMMY1
-- ... one row per test case
;
```

This gives the developer a single result set showing all test outcomes.

### Spool Verification (Batch/Report)

Spool output cannot be verified via SQL. Generate manual instructions:

```
-- UT-08: Spool verification (manual)
-- 1. WRKSPLF SELECT(TSTBATCH)
-- 2. Open spool file QSYSPRT (or named spool)
-- 3. Verify: page 1 header shows report date = 2026-04-01
-- 4. Verify: detail line count = 15 records
-- 5. Verify: total amount = 45,230.50
```

---

## Test Data Design Rules

### Key Range Isolation

Test records use high-range keys to avoid collision with production data:

| Key Type | Test Range | Example |
|----------|-----------|---------|
| Numeric (5,0) | 90001–99999 | CUSNO = 90001 |
| Numeric (7,0) | 9000001–9999999 | ORDNO = 9000001 |
| Character (6) | 'TST001'–'TST999' | PRDNO = 'TST001' |
| Character (10) | 'ZTEST00001' | EMPID = 'ZTEST00001' |

Adjust the range if the production data range is known from the UT Plan or
user context. The goal is zero collision risk.

### Dependency Ordering

Insert master records before detail records. Comment the dependency:

```sql
-- Step 1: Master file (no dependencies)
INSERT INTO TSTLIB/CUSTMAST (CUSNO, CUSNAM, CUSSTS)
  VALUES (90001, 'TEST CUST A', 'A');

-- Step 2: Header references CUSTMAST.CUSNO
INSERT INTO TSTLIB/ORDHDR (ORDNO, CUSNO, ORDDAT, ORDSTS)
  VALUES (9000001, 90001, 20260409, 'O');

-- Step 3: Detail references ORDHDR.ORDNO
INSERT INTO TSTLIB/ORDDTL (ORDNO, ORDLIN, PRDNO, ORDQTY)
  VALUES (9000001, 1, 'TST001', 10);
```

### Shared Baseline vs Case-Specific Data

```sql
-- =================================================================
-- SHARED BASELINE (used by multiple test cases)
-- =================================================================
INSERT INTO TSTLIB/CUSTMAST (CUSNO, CUSNAM, CUSSTS)
  VALUES (90001, 'ACTIVE CUSTOMER', 'A');
INSERT INTO TSTLIB/CUSTMAST (CUSNO, CUSNAM, CUSSTS)
  VALUES (90002, 'INACTIVE CUSTOMER', 'I');
INSERT INTO TSTLIB/CUSTMAST (CUSNO, CUSNAM, CUSSTS)
  VALUES (90003, 'SUSPENDED CUSTOMER', 'S');

-- =================================================================
-- UT-01 SPECIFIC: Active customer places order
-- =================================================================
INSERT INTO TSTLIB/ORDHDR (ORDNO, CUSNO, ORDDAT, ORDSTS)
  VALUES (9000001, 90001, 20260409, 'O');

-- =================================================================
-- UT-02 SPECIFIC: Inactive customer blocked
-- =================================================================
INSERT INTO TSTLIB/ORDHDR (ORDNO, CUSNO, ORDDAT, ORDSTS)
  VALUES (9000002, 90002, 20260409, 'O');
```

### Data Reset Between Cases

When test cases modify the same records, provide reset statements:

```sql
-- =================================================================
-- RESET: Restore baseline between UT-03 and UT-04
-- (Run only if executing cases sequentially on same data)
-- =================================================================
UPDATE TSTLIB/ORDMAST SET ORDSTS = 'O', CHGDAT = 0, CHGTIM = 0
  WHERE ORDNO = 9000001;
```

---

## Interactive Program Testing

For interactive (screen-based) RPGLE programs, execution is manual. The skill
generates automated data setup and verification, with a step-by-step guide for
the manual screen interaction.

1. **Data setup** — fully automated (SQL)
2. **Execution guide** — step-by-step screen instructions
3. **Verification** — fully automated (SQL)

```
-- =================================================================
-- UT-04: Interactive execution guide (manual steps)
-- =================================================================
-- 1. Sign on to test environment
-- 2. Verify library list: ADDLIBLE LIB(TSTLIB) POSITION(*FIRST)
-- 3. CALL PGM(PGMLIB/ORD200)
-- 4. On Order Entry screen: type CUSNO = 90001, press Enter
-- 5. Verify customer name 'ACTIVE CUSTOMER' appears (display-only field)
-- 6. Type PRDNO = 'TST001', QTY = 10
-- 7. Press F6=Confirm
-- 8. Verify confirmation message: 'Order 9000003 created' (or similar)
-- 9. Press F3=Exit
-- 10. Run Artifact 4 verification SQL below
```

Do not attempt to automate screen interaction. The value is in automated
data setup and verification — the manual part is just the screen operation itself.

---

## CL Program Testing

CL programs are tested by their observable effects — files modified, data areas
changed, messages sent, jobs submitted, spool files created.

### Effect-Based Verification

```sql
-- UT-10: CL program created output file records
-- After: CALL PGM(PGMLIB/CLPGM01) PARM('20260409')
SELECT COUNT(*) AS REC_COUNT,
  CASE WHEN COUNT(*) > 0 THEN 'PASS' ELSE '** FAIL **' END AS UT10_RESULT
FROM TSTLIB/RPTWORK
WHERE RPTDAT = 20260409;
```

### Data Area Verification (manual)

```
-- UT-11: CL program set data area
-- After execution, verify manually:
-- DSPDTAARA DTAARA(TSTLIB/CTLARA)
-- Expected: positions 1-8 = '20260409'
```

### Job Attribute Verification (manual)

```
-- UT-13: CL program submitted downstream job
-- WRKJOB JOB(DWNSTRM)
-- Expected: job status = OUTQ (completed) or ACTIVE (running)
```

---

## Internal Workflow

### Step 1 — Parse UT Plan

Read the UT Plan. Extract:
- UT Plan ID, Change Size, Change Mode, Program Type
- Impacted Artifacts (files, programs)
- Test Data Design (baseline and per-case records)
- UT Cases (inputs, expected results, DB verification)
- Shared Preconditions

### Step 2 — Resolve Environment

Confirm or mark TBD: test library, source library, program library.
Identify files needing CRTDUPOBJ from Impacted Artifacts.

### Step 3 — Determine Data Dependencies

Map file relationships from Impacted Artifacts:
- Identify master/detail relationships
- Order INSERT statements: master → detail → transactional
- Note any circular or unclear dependencies in Open Questions

### Step 4 — Generate Environment Setup (Artifact 1)

CL commands for:
- ADDLIBLE for test library
- CRTDUPOBJ for each impacted file (DATA(*NO) by default)
- OVRDBF if selective file redirection is needed

### Step 5 — Generate Compile Commands (Artifact 2)

For each program in Impacted Artifacts with Impact = NEW or MODIFIED:
- Determine compile command from program type (RPGLE → CRTBNDRPG, CLLE → CRTBNDCL, etc.)
- Include DBGVIEW(*SOURCE) and OPTION(*EVENTF) for test builds
- Add DSPOBJD verification after each compile
- Handle multi-module and service program scenarios
- If source file or member name is unknown, use TBD with inference comment

### Step 6 — Generate Test Data (Artifact 3)

SQL INSERT statements organized as:
1. Shared baseline records (used by multiple cases)
2. Per-case records (labeled with UT-nn)
3. Data reset blocks (when cases share records)

Use test key ranges. Include column-level comments for clarity on non-obvious values.

### Step 7 — Generate Execution Commands (Artifact 4)

Per program type:
- **Batch RPGLE / CL**: CL CALL or SBMJOB commands per test case
- **Interactive RPGLE**: step-by-step screen interaction guide
- **Service Program**: note that a caller stub is needed; provide parameter values

### Step 8 — Generate Verification (Artifact 5)

Per test case:
1. Before-state query (if DB modification — run before execution)
2. After-state query with PASS/FAIL CASE expression
3. Summary dashboard query combining all cases in one result set

For spool/report verification: manual check instructions.

### Step 9 — Generate Cleanup (Artifact 6)

- SQL DELETE for all test records (reverse insertion order)
- DLTOVR if overrides were used
- Optionally: CLRPFM for complete file reset

### Step 10 — Self-Review

Run Quality Bar. Fix violations.

### Step 11 — Assemble Output

Six artifacts in order, with Markdown formatting and SQL/CL code blocks.

---

## Output Template

```markdown
# Test Scaffold

- **UT Plan:** <UTP-ID>
- **Version:** <1.0 for first draft; increment on revision>
- **Generated:** <date>
- **Program:** <program name(s)>
- **Test Library:** <TSTLIB or TBD>
- **Source Library:** <PRODLIB or TBD>
- **Program Library:** <PGMLIB or TBD>
- **Test Scope:** <Small / Medium / Large>
- **Program Type:** <Interactive / Batch / CL / Service Program / Mixed>

---

## Open Questions / Prerequisites

<Unresolved items from UT Plan, missing library names, unknown field formats,
 TDD prerequisites (files not yet created), etc.>

---

## Artifact 1: Environment Setup (CL)

` ` `cl
/* Environment setup commands — run once before testing */
<CL commands: ADDLIBLE, CRTDUPOBJ, OVRDBF>
` ` `

---

## Artifact 2: Compile (CL)

` ` `cl
/* Compile target programs — run after environment setup, before test data */
/* Skip this artifact if programs are already compiled */

<CRTBNDRPG / CRTBNDCL / CRTRPGMOD + CRTSRVPGM commands>
<DSPOBJD verification after each compile>
` ` `

---

## Artifact 3: Test Data Setup (SQL)

` ` `sql
-- Test data — run after compile
<SQL header>

-- SHARED BASELINE
<shared INSERT statements>

-- UT-nn: <description>
<case-specific INSERT statements>

-- DATA RESET (if needed between cases)
<UPDATE/DELETE reset statements>
` ` `

---

## Artifact 4: Test Execution

### Batch / CL Cases

` ` `cl
<CL CALL/SBMJOB commands per case>
` ` `

### Interactive Cases

<Step-by-step interaction guides per case>

---

## Artifact 5: Result Verification (SQL)

### Before-State Queries

` ` `sql
-- Run BEFORE execution
<SELECT statements to capture pre-state>
` ` `

### After-State Queries

` ` `sql
-- Run AFTER execution
<SELECT with PASS/FAIL per case>
` ` `

### Test Results Summary

` ` `sql
-- Combined results dashboard
<UNION ALL query showing all PASS/FAIL>
` ` `

---

## Artifact 6: Cleanup (SQL)

` ` `sql
-- Run after testing is complete
<DELETE statements in reverse dependency order>
<Override removal commands>
` ` `

---

## Execution Checklist

- [ ] Test library exists and is accessible
- [ ] Environment setup commands executed (Artifact 1)
- [ ] Programs compiled successfully — DSPOBJD confirms objects exist (Artifact 2)
- [ ] Test data inserted with no SQL errors (Artifact 3)
- [ ] Before-state captured where applicable (Artifact 5 — before section)
- [ ] Program executed per test case (Artifact 4)
- [ ] After-state verification run — check PASS/FAIL (Artifact 5 — after section)
- [ ] Summary query shows all PASS (Artifact 5 — summary)
- [ ] Cleanup executed after testing complete (Artifact 6)
```

---

## Quality Bar

**Completeness:**
- [ ] Every UT case in the plan has corresponding data setup
- [ ] Every UT case has a verification query with PASS/FAIL
- [ ] Every file in Impacted Artifacts has INSERT/verification coverage
- [ ] Every NEW/MODIFIED program has a compile command in Artifact 2
- [ ] Execution commands match the program type (CALL vs SBMJOB vs manual guide)
- [ ] Cleanup covers all inserted test records

**Compile Correctness:**
- [ ] Correct compile command per program type (CRTBNDRPG / CRTBNDCL / CRTRPGMOD / etc.)
- [ ] DBGVIEW(*SOURCE) and OPTION(*EVENTF) included for test builds
- [ ] Source file and member names match (or marked TBD with inference label)
- [ ] Multi-module / service program compile sequence is correct (modules before bind)
- [ ] DSPOBJD verification after each compile command

**SQL Correctness:**
- [ ] System naming used throughout (library/file, not schema.table)
- [ ] All string literals properly quoted
- [ ] Numeric fields use numeric literals (not quoted)
- [ ] INSERT column list matches value list count
- [ ] Test keys in safe range (no production collision risk)
- [ ] Dependency order correct (master before detail in INSERT, reverse in DELETE)

**Traceability:**
- [ ] Every SQL block references its UT case ID in comments
- [ ] Every verification query evaluates specific expected values from the UT Plan
- [ ] PASS/FAIL logic matches UT Plan expected results exactly
- [ ] Shared baseline records reference which cases use them

**Practicality:**
- [ ] SQL scripts are copy-paste ready (no compilation needed)
- [ ] CL commands are standalone (runnable from 5250 command line)
- [ ] Each artifact is independently runnable
- [ ] Interactive cases have clear step-by-step instructions
- [ ] Data reset blocks provided when cases share records

**Anti-Hallucination:**
- [ ] No invented file names, field names, or values not in the UT Plan or input
- [ ] Unknown formats marked TBD with comments
- [ ] Library names from user input or TBD placeholders
- [ ] No assumed field lengths or types without source

---

## Edge-Case Handling

| Situation | Behavior |
|-----------|----------|
| UT Plan has TBD file names | Use TBD in SQL with comment: `-- TBD: confirm file name` |
| Field format unknown | Use most common format + TBD marker |
| Interactive program | Data setup + verification automated; execution is manual guide |
| Service program | Note caller stub requirement; provide parameter values |
| No DB modification (pure calculation) | Omit before/after; verify via return value or display |
| Large number of test cases (20+) | Group by file/artifact; use numbered sections |
| Cross-file dependencies | Order INSERTs by dependency; comment the relationship |
| Date-sensitive tests | Use explicit date literals; note system date assumption |
| Commitment control needed | Add `STRCMTCTL` to environment setup; `COMMIT` after execution |
| Concurrent access / lock testing | Note as manual coordination; cannot script contention |
| Program not yet compiled (TDD) | Artifact 2 compile commands ready; execution marked "compile first" |
| Compile requires binding directory | Include BNDDIR parameter if known from spec; TBD if not |
| Service program with exports | CRTRPGMOD + CRTSRVPGM sequence; note EXPORT(*ALL) or specific exports |
| Duplicate key risk on re-run | Cleanup or conditional DELETE before INSERT |
| UT Plan missing Test Data Design | Derive data from UT case inputs; label all inferences |

---

## Relationship to Other Skills

| Skill | Relationship |
|-------|-------------|
| `ibm-i-ut-plan-generator` | Primary input — UT cases, test data design, expected results |
| `ibm-i-program-spec` | Secondary input — file usage, parameters, BR-xx |
| `ibm-i-code-generator` | Peer — generates code this scaffold tests |
| `ibm-i-code-reviewer` | Peer — reviews quality; scaffold verifies correctness |
| `ibm-i-file-spec` | Supporting — field definitions inform SQL column lists |
| `ibm-i-compile-precheck` | Upstream gate — compile must pass before test execution |
| `ibm-i-workflow-orchestrator` | Routes post-UT-Plan work here |
