# Example: Existing Fixed-Format RPGLE Change Block

Use this example when patching an **existing fixed-format** RPGLE member without fabricating the whole source.

## Scenario

- Change Type: `Change to Existing`
- Program Type: `RPGLE`
- Current Source: not fully provided
- Source Format Policy: `Fixed format`
- Output Mode: `Controlled Change Block`

## Program Spec Cues

- `Step 5` adds a new validation threshold
- `BR-03` says orders over `MAXAMT` must be rejected
- Existing routine is known to be an order validation subroutine

## Preferred Output

```rpgle
     C* Step 5 / BR-03 - new maximum amount validation
     C           IF        ORDAMT > MAXAMT
     C                   EVAL      RETCD = '1'
     C                   EVAL      ERRMSG = 'ORDER AMOUNT EXCEEDS LIMIT'
     C                   GOTO      ENDCHK
     C           ENDIF
```

## Notes

- This is a local fixed-format block, not a fabricated full member
- Indicator, tag, and branch style should be aligned to the surrounding source when available
- If current source later becomes available, the exact labels and surrounding flow should be reconciled there
