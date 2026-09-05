# Sample L2 Standard Enhancement Design — Customer Contact Capture

> **This document is a sample TD fixture used by the orchestrator's
> td-driven-with-file sample (see `sample-task-md-td-driven-with-file.md`).
> It illustrates the minimum TD shape that triggers both program-spec and
> file-spec Layer A targets in `td-driven-multi-spec-batch` mode. It is not
> a real change request and is not part of the technical-design skill's own
> examples library.**

Calibration example showing an enhancement that touches both an existing
file (CUSTMAST — add EMAIL/PHONE fields) and introduces a new program
(CUSTUPD — customer maintenance program that captures the new fields).

---

**Requirement**: Add email address and phone number capture to the
customer master file, and introduce a customer maintenance program that
allows operators to update these new contact fields. The existing order
processing programs are unchanged by this enhancement.

**Solution Type**: RPGLE (program) + DDS-PF change (file)
**Change Type**: Enhancement to Existing system (mixed: new program + file change)

---

## Document Header

- **Design ID:** TD-20260430-CC
- **Design Level:** L2 Standard
- **Version:** 1.0
- **Status:** Draft (sample)
- **Change Type:** Enhancement to Existing
- **Solution Type:** RPGLE PGM + PF
- **Related Object(s):** TBD (CUSTUPD program), CUSTMAST
- **Description:** Add EMAIL and PHONE fields to CUSTMAST and create a
  new RPGLE maintenance program CUSTUPD to populate them.

---

## Design Overview

The customer master file currently lacks contact fields. This enhancement
adds two new fields (EMAIL, PHONE) to CUSTMAST and introduces a new
RPGLE maintenance program (CUSTUPD) that operators use to set or update
the contact information for an existing customer.

The new program is interactive (display file driven). The file change
is structural (record format gains two fields); existing programs that
read CUSTMAST continue to work unchanged because the new fields are
appended to the record.

---

## Module / Responsibility Allocation

### Module Allocation Table

| Object | Type | Status | Primary Role | Responsibility | Depends On | Depended On By |
|--------|------|--------|--------------|----------------|------------|----------------|
| TBD (CUSTUPD program) | RPGLE PGM | (NEW) | Maintenance | Reads existing CUSTMAST record by Customer ID, prompts operator for EMAIL/PHONE, updates the record | CUSTMAST, TBD (CUSTUPD display file) | Operator menu (out of scope) |
| TBD (CUSTUPD display file) | DSPF | (EXISTING — context only) | UI surface | Will be specified separately if needed; this TD only references it | — | TBD (CUSTUPD program) |

**Design note**: The display file is referenced as context only because
this enhancement focuses on the program logic and the physical file
change. A separate TD or direct file-spec invocation can address the
DSPF if and when needed.

---

## High-Level Processing Flow

**Stage 1: Operator selects a customer**
The CUSTUPD program prompts for Customer ID, reads the CUSTMAST record,
and rejects if not found.
- Active module: TBD (CUSTUPD program)
- Input consumed: Customer ID
- Output produced: Customer header data displayed
- Business rules: BR-01

**Stage 2: Operator enters EMAIL and PHONE**
The program displays current values (blank for existing customers
before this enhancement runs) and accepts new values.
- Active module: TBD (CUSTUPD program)
- Input consumed: EMAIL, PHONE entered by operator
- Output produced: validated values
- Business rules: BR-02, BR-03

**Stage 3: Update CUSTMAST**
The program writes the updated record. The 8 existing fields are
preserved unchanged.
- Active module: TBD (CUSTUPD program)
- Input consumed: validated EMAIL, PHONE
- Output produced: updated CUSTMAST record
- Business rules: BR-04

---

## Data / Object Interaction Design

### Object Interaction Map

| Source | Target | Interaction | Data Exchanged (summary) | Direction |
|--------|--------|-------------|--------------------------|-----------|
| TBD (CUSTUPD program) | CUSTMAST | Read | Customer record by Customer ID | <-- |
| TBD (CUSTUPD program) | CUSTMAST | Update | Updated EMAIL, PHONE values | --> |

### File Access Summary

| File Name | Accessed By | Access Type (I/O/U) | Key Field(s) | Purpose |
|-----------|-------------|---------------------|-------------|---------|
| CUSTMAST | TBD (CUSTUPD program) | U | Customer ID | Read existing record, update EMAIL/PHONE |

---

## Business Rule Allocation

| BR | Rule Description | Allocated To (Module) | Enforced At (Stage) | Notes |
|----|------------------|-----------------------|---------------------|-------|
| BR-01 | Customer ID must exist in CUSTMAST | TBD (CUSTUPD program) | Stage 1 | NEW |
| BR-02 | EMAIL may be blank but if non-blank must contain '@' | TBD (CUSTUPD program) | Stage 2 | NEW (also enforced at file level — see CUSTMAST file spec) |
| BR-03 | PHONE may be blank — no format validation at program level | TBD (CUSTUPD program) | Stage 2 | NEW |
| BR-04 | Update writes back full record; the 8 existing fields are preserved unchanged | TBD (CUSTUPD program) | Stage 3 | NEW |

---

## Impact Analysis

### Objects Affected

| Object | Type | Impact | Description |
|--------|------|--------|-------------|
| TBD (CUSTUPD program) | PGM (RPGLE) | New | New customer maintenance program |
| CUSTMAST | FILE | Modified | Add EMAIL (60A) and PHONE (15A) fields at the end of the record |

### Downstream Effects

- Existing programs that read CUSTMAST are unaffected by the field
  addition because the new fields are appended at the end of the
  record format. They will see the extra columns as unused.
- Reports that dump CUSTMAST may need a separate enhancement if they
  should display the new fields, but that is out of scope here.

### Test Impact

- New unit tests required for BR-01..BR-04 in CUSTUPD.
- Regression test on at least one existing CUSTMAST consumer to confirm
  no format-related runtime issue (RPG record-length tolerance).

---

## Open Questions

| # | Section | Question |
|---|---------|----------|
| 1 | Module Allocation | Final program name for CUSTUPD has not been assigned. |
| 2 | Module Allocation | Final DSPF name for CUSTUPD's display file (currently context-only). |
| 3 | File Access | Existing CUSTMAST DDS source path needs to be located in QDDSSRC. |
| 4 | Business Rules | EMAIL maximum length: TD assumes 60A; should be confirmed with business before file-spec finalizes. |
