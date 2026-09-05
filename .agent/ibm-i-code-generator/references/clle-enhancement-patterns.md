# CLLE Enhancement Patterns

Read this file when Program Type is `CLLE`, especially for change-to-existing work.

## Existing CLLE Preservation Rules

For existing CLLE source:
- preserve `DCL` ordering
- preserve `MONMSG` scope and nesting
- preserve command structure and parameter ordering idioms
- preserve `SNDPGMMSG` patterns, message IDs, and target queue behavior from current source
- preserve `CHGVAR`, `RTVJOBA`, and `RTVSYSVAL` usage patterns unless the Program Spec explicitly changes them

Do not "clean up" the member into a different structural style during an enhancement.

## New CLLE Default Shape

For new CLLE programs when the Program Spec is complete enough:
1. Header comment
2. `PGM` parameter list
3. `DCL` declarations from the Interface/Data Contract
4. Main flow ordered by `Step 1`, `Step 2`, etc.
5. `CALL` / `CALLPRC` points from `External Program Calls`
6. `MONMSG` blocks aligned to `Error Handling`
7. Return handling
8. `ENDPGM`

## Change Block Guidance

If current source is unavailable:
- prefer a local change block over a fabricated full member
- identify the target section, for example:
  - validation branch
  - command execution block
  - message handling branch
  - return-code assignment block
- mark the output as controlled draft rather than drop-in replacement

## Review Questions

- Are declarations being reordered without need?
- Has MONMSG behavior drifted from the existing style?
- Are new command parameters or message IDs introduced without support from the Program Spec?
- Is the output a safe patch shape, or is it inventing surrounding legacy structure?
