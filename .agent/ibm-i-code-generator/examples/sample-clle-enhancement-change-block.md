# Example: Existing CLLE Enhancement Change Block

Use this example when patching an **existing CLLE** program without full current source.

## Scenario

- Change Type: `Change to Existing`
- Program Type: `CLLE`
- Current Source: not fully provided
- Output Mode: `Controlled Change Block`

## Program Spec Cues

- `Step 3` adds a validation branch before an external call
- `BR-02` requires blank input rejection
- `Return Code Definition` says validation error returns `1`

## Preferred Output

```cl
/* Step 3 / BR-02 - reject blank request id before external call */
IF   COND(&REQID *EQ '          ') THEN(DO)
   CHGVAR     VAR(&RETCODE) VALUE('1')
   SNDPGMMSG  MSG('REQUEST ID REQUIRED')
   GOTO       CMDLBL(ENDPGM)
ENDDO
```

## Notes

- This is a local CLLE patch block, not a fabricated full member
- `MONMSG`, `SNDPGMMSG`, and declaration patterns should align to current source when available
- If current source is later provided, the anchor label and exact message handling should be reconciled there
