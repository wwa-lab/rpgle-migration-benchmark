# Sample L3 Full Spec — New CLLE Program

Calibration example showing the L3 Full format for a new CL program.

---

**Requirement**: Create a CL program that submits the nightly order processing batch job.
Check a data area to see if the batch is already running. If not, submit the RPGLE
processing program and update the data area. Called from the job scheduler.

**Program Type**: CLLE
**Change Type**: New Program

---

## Spec Header

- **Spec ID:** ORDBTCSB-20260401-01
- **Spec Level:** L3 Full
- **Version:** 1.0
- **Status:** Draft
- **Change Type:** New Program
- **Program Type:** CLLE
- **Program Name:** TBD
- **Description:** Checks whether the nightly order batch is running, and if not, submits the order processing program and updates the run-status data area.

---

## Amendment History

| Version | Date       | Author | Change Description |
|---------|------------|--------|--------------------|
| 1.0     | 2026-04-01 | TBD    | Initial draft      |

---

## Caller Context

- **Called by:** Job scheduler (ADDJOBSCDE or third-party)
- **Trigger:** Scheduled execution at 00:00 daily.
- **Expected behavior on success:** Scheduler logs successful submission.
- **Expected behavior on failure:** Scheduler raises alert; operator investigates.

---

## Functions

1. Retrieve the current batch run status.
2. Enforce batch submission business rules.
3. Submit the order processing program to the batch job queue.
4. Update the batch run-status indicator.
5. Return a status code to the caller.

---

## Business Rules

1. BR-01: The batch must not be submitted if the data area = 'Y' (already running).
2. BR-02: The data area must be set to 'Y' before SBMJOB (prevents race condition).
3. BR-03: If SBMJOB fails, the data area must be reset to 'N'.

---

## Interface Contract

### Program Parameters

| Name     | Type | Length | Input/Output | Valid Values   | Description |
|----------|------|--------|-------------|----------------|-------------|
| P_RTNCDE | CHAR | 1      | Output      | '0', '1', '2' | Return code |

### Return Code Definition

| Code | Meaning         | Caller Action                          |
|------|-----------------|----------------------------------------|
| '0'  | Batch submitted | Log success                            |
| '1'  | Already running | Log warning, no action needed          |
| '2'  | Error           | Raise alert for operator investigation |

---

## Data Contract

| Field Name | Source | Storage   | Read by Steps | Written by Steps | Notes                       |
|------------|--------|-----------|---------------|------------------|-----------------------------|
| P_RTNCDE   | Param  | Transient | —             | 2, 4, 7, 8      | Output parameter             |
| &BATCHSTS  | File   | Persisted | 4             | 5, 7             | Value from ORDBTCDA          |

---

## File Usage

N/A

---

## Data Queue

N/A

---

## Data Area

- **ORDBTCDA** (Library: TBD) — CHAR(1). 'Y' = running, 'N' = not running.

---

## External Data Structure

N/A

---

## Internal Data Structure

N/A

---

## External Program Calls

| Program | Purpose                             | Parameters Passed             | Expected Return |
|---------|-------------------------------------|-------------------------------|-----------------|
| TBD     | RPGLE order processing (via SBMJOB) | None (submitted as batch job) | N/A (async)     |

---

## External Subroutines

N/A

---

## Standard Subroutines

N/A

---

## Constants

N/A (CL uses literal values in commands)

---

## Program Processing

### Main Logic

Step 1: Receive parameter P_RTNCDE.
Step 2: Set P_RTNCDE = '2' (default to error).
Step 3: RTVDTAARA ORDBTCDA into &BATCHSTS.
Step 4: IF &BATCHSTS = 'Y' → set P_RTNCDE = '1' → send message → return. (BR-01)
Step 5: CHGDTAARA ORDBTCDA to 'Y'. (BR-02)
Step 6: SBMJOB CMD(CALL TBD) JOB(ORDNIGHTLY) JOBQ(TBD).
Step 7: IF SBMJOB fails → CHGDTAARA ORDBTCDA to 'N' → set P_RTNCDE = '2' → return. (BR-03)
Step 8: Set P_RTNCDE = '0'.
Step 9: Send completion message.
Step 10: Return.

### File Output / Update

N/A

---

## Error Handling

| Scenario                                | Return Code | Action                                            | Logged? |
|-----------------------------------------|-------------|---------------------------------------------------|---------|
| Validation Error (BR-01: batch running) | '1'         | Set P_RTNCDE, send diagnostic message, return     | Yes     |
| Data Not Found (RTVDTAARA fails)        | '2'         | MONMSG, send escape message, set P_RTNCDE, return | Yes     |
| Update Failure (CHGDTAARA fails)        | '2'         | MONMSG, send escape message, set P_RTNCDE, return | Yes     |
| System Error (MONMSG CPF0000)           | '2'         | Send diagnostic message, set P_RTNCDE, return     | Yes     |
| SBMJOB failure                          | '2'         | Reset ORDBTCDA to 'N' (BR-03), set P_RTNCDE      | Yes     |

---

## Traceability Matrix

| BR    | Rule Summary               | Logic Step(s) | Error Handling Row   | File(s) Affected |
|-------|----------------------------|---------------|----------------------|-----------------|
| BR-01 | Batch not already running  | Step 4        | Validation Error     | ORDBTCDA        |
| BR-02 | Set data area before SBMJOB| Step 5        | N/A (positive logic) | ORDBTCDA        |
| BR-03 | Reset data area on failure | Step 7        | SBMJOB failure       | ORDBTCDA        |

---

## Processing Considerations

- **Performance:** No concerns — single data area read/update.
- **Locking:** Data area set to 'Y' before SBMJOB. Reset on failure. Brief window risk.
- **Batch vs online:** Called by scheduler to submit batch job. Submitted job resets ORDBTCDA.

---

## Programming Language

CLLE

---

## Amend Data Structure

N/A

---

## Open Questions / TBD

| # | Section          | Question                                                    |
|---|------------------|-------------------------------------------------------------|
| 1 | Spec Header      | Program name (*PGM object).                                 |
| 2 | External Calls   | Name of RPGLE order processing program.                     |
| 3 | Data Area        | Library for ORDBTCDA.                                       |
| 4 | Main Logic       | Target job queue for SBMJOB.                                |
| 5 | Main Logic       | Job description and user profile for submitted job.         |
| 6 | Caller Context   | Check job queue instead of/in addition to data area?        |

---

## Spec Summary

- **Spec Level:** L3 Full
- **Change Type:** New Program
- **Total Business Rules:** 3 (3 new, 0 modified)
- **Total Main Logic Steps:** 10 (10 new, 0 modified)
- **Total Files Used:** 0
- **Total External Calls:** 1
- **Total Open Questions:** 6
- **Traceability Complete:** Yes
