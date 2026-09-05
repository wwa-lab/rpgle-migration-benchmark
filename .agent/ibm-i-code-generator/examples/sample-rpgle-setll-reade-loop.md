# Example: SETLL/READE Loop for 1:N File Access

Use this example when the Program Spec's File Usage declares **1:N** access pattern for a
file/key combination, indicating multiple records match the same key.

## Scenario

- Change Type: `New Program`
- Program Type: `RPGLE`
- Source Format: `Free format`
- Output Mode: `Full Implementation`

## Program Spec Cues

- `File Usage` declares:

  | File Name | Type | Key Field(s) | Access Pattern | Description |
  |-----------|------|-------------|----------------|-------------|
  | CUSTMAST  | I    | CUSTID      | 1:1            | Customer master |
  | ORDDTL   | I    | ORDNO       | 1:N            | Order detail lines |

- `Main Logic` includes:
  - `Step 1: Validate order number`
  - `Step 2: Read customer master by CUSTID` (1:1 — CHAIN)
  - `Step 3: FOR EACH detail line in ORDDTL by ORDNO → accumulate line total (BR-01)`
  - `Step 4: IF accumulated total > credit limit → reject (BR-02)`
  - `Step 5: Return success`

## Expected Shape

```rpgle
**free
// Program: ORDVAL

ctl-opt dftactgrp(*no) actgrp(*caller);

dcl-f CUSTMAST keyed usage(*input);
dcl-f ORDDTL  keyed usage(*input);

dcl-pi *n;
  ORDNO    char(10) const;
  CUSTID   char(10) const;
  RETCODE  char(1);
end-pi;

dcl-s orderTotal packed(11:2) inz(0);
dcl-s creditLimit packed(11:2);

// Step 1 / BR-01
if %trim(ORDNO) = *blanks;
   RETCODE = '1';
   return;
endif;

// Step 2 — 1:1 access (CHAIN)
chain CUSTID CUSTMAST;
if not %found(CUSTMAST);
   RETCODE = '2';
   return;
endif;

creditLimit = CRLMT;

// Step 3 — 1:N access (SETLL + READE loop)
// Multiple detail lines exist per order number
setll ORDNO ORDDTL;
reade ORDNO ORDDTL;
dow not %eof(ORDDTL);
   orderTotal += LNAMT;  // BR-01: accumulate line total
   reade ORDNO ORDDTL;
enddo;

// Step 4 / BR-02
if orderTotal > creditLimit;
   RETCODE = '3';
   return;
endif;

// Step 5
RETCODE = '0';
return;
```

## Key Pattern: CHAIN vs SETLL/READE

This example demonstrates both patterns side by side:

| File | Key | Access Pattern | I/O Pattern | Why |
|------|-----|----------------|-------------|-----|
| CUSTMAST | CUSTID | 1:1 | `CHAIN` | One customer per ID — single record |
| ORDDTL | ORDNO | 1:N | `SETLL` + `READE` loop | Many detail lines per order — must process all |

**Common mistake this prevents:** Using `CHAIN ORDNO ORDDTL` would read only the first
detail line and silently skip all remaining lines, producing an incorrect total.

## Why This Example Exists

- Shows how File Usage Access Pattern drives I/O opcode selection
- Demonstrates CHAIN (1:1) and SETLL/READE (1:N) in the same program
- Shows the standard `SETLL` → `READE` → `DOW NOT %EOF` → `READE` loop structure
- Prevents the common bug of using CHAIN for partial-key access
