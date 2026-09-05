# Example: New Free-Format RPGLE Program

Use this example when generating a **new** RPGLE member from a complete Program Spec.

## Scenario

- Change Type: `New Program`
- Program Type: `RPGLE`
- Source Format: `Free format`
- Output Mode: `Full Implementation`

## Program Spec Cues

- `Interface Contract` defines input parameter `CUSTID` and output parameter `RETCODE`
- `File Usage` names `CUSTMAST`
- `Main Logic` includes:
  - `Step 1: Validate customer ID`
  - `Step 2: Read customer master`
  - `Step 3: IF not found → set return code (BR-01)`
  - `Step 4: Return success`

## Expected Shape

```rpgle
**free
// Program: CUSCHK

ctl-opt dftactgrp(*no) actgrp(*caller);

dcl-f CUSTMAST keyed usage(*input);

dcl-pi *n;
  CUSTID   char(10) const;
  RETCODE  char(1);
end-pi;

// Step 1 / BR-01
if %trim(CUSTID) = *blanks;
   RETCODE = '1';
   return;
endif;

// Step 2
chain CUSTID CUSTMAST;

// Step 3 / BR-02
if not %found(CUSTMAST);
   RETCODE = '2';
   return;
endif;

// Step 4
RETCODE = '0';
return;
```

## Why This Example Exists

- Shows full-member free-format default for new RPGLE
- Shows short `Step n` and `BR-xx` trace comments
- Shows that interface, file usage, and return handling come from the Program Spec
