# Example: RPGLE Embedded SQL Pattern

Use this example when the Program Spec explicitly indicates SQL-based data access.

## Scenario

- Program Type: `RPGLE`
- Access Method: `Embedded SQL`
- Output Mode: `Full Implementation` or targeted SQL block

## Program Spec Cues

- `File Usage` or `Main Logic` references SQL access instead of native `CHAIN` / `READ`
- `Data Contract` identifies host variables
- `Error Handling` requires SQL failure handling

## Expected Pattern

```rpgle
// Step 3 / BR-02 - retrieve customer row
exec sql
   select CUSNAM, CRDLMT
     into :CustName, :CredLim
     from CUSTMAST
    where CUSID = :CUSTID;

if SQLCODE <> 0;
   // Step 4 / Validation or data access failure
   RETCODE = '9';
   return;
endif;
```

## Review Intent

- `EXEC SQL` appears only when supported by the Program Spec
- Host variables come from the Data Contract
- SQL error handling maps back to the Program Spec's Error Handling section
