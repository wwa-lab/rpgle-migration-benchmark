# Example: Mixed-Format RPGLE Touched Region

Use this example when the existing member is mixed-format and the change lands in one specific region.

## Scenario

- Change Type: `Change to Existing`
- Program Type: `RPGLE`
- Current Source: mixed-format member
- Source Format Policy: `Keep consistent with the touched region`

## Rule

Do not treat the existence of free-format procedures elsewhere in the member as permission to
convert a fixed-format mainline or fixed-format subroutine.

## Example A: Touched Region Is Fixed-Format

```rpgle
     C* Step 7 / BR-04 - existing fixed-format update branch
     C           IF        RETCD = '0'
     C                   UPDATE    ORDERR
     C           ENDIF
```

## Example B: Touched Region Is Already Free-Format

```rpgle
// Step 7 / BR-04 - existing free-format procedure branch
if RETCD = '0';
   update ORDERR;
endif;
```

## Why This Example Exists

- Shows local-style preservation as the real rule
- Prevents accidental normalization of mixed members
