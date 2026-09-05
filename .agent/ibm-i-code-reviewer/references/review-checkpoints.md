# Review Checkpoints

Read this file when performing a full `ibm-i-code-reviewer` pass.

## Core Review Order

Use this order unless the user explicitly requests a targeted review:
1. Confirm code language and change type
2. Confirm controlling Program Spec exists and is usable
3. Check Main Logic step coverage
4. Check BR coverage
5. Check Interface Contract and return-code behavior
6. Check File Usage / External Program Calls / Data Contract alignment
7. Check error-handling paths
8. Check enhancement scope and format policy
9. Calibrate readiness

## Main Logic and BR Checks

- Can each significant `Step n` be located in code or an intentional placeholder?
- Do the important `BR-xx` conditions appear in conditional logic or trace annotations?
- Is any business rule implemented that does not appear in the Program Spec?
- Is any required branch missing?

## Interface and Return Code Checks

- Do parameters match the Interface Contract in name, order, direction, and meaning?
- Are return codes aligned to `Return Code Definition`?
- Does the code return or set codes in the same conditions the spec describes?
- Has a new return code been introduced without spec support?

## Data / File / External Call Checks

- Are file declarations aligned to `File Usage`?
- Are updates happening only to files the spec names?
- Are external programs called only when the spec supports them?
- Do host variables or declared fields align to the `Data Contract`?

## Error Handling Checks

Verify that code reflects the Program Spec's handling for:
- Validation Error
- Data Not Found
- Update Failure
- System Error

Missing any one of these is often at least a Major issue for a full implementation.

## Enhancement Safety Checks

- Is the output scope appropriate for an enhancement?
- Was a full member emitted where a change block would have been safer?
- Did the change drift into unrelated logic, declarations, or formatting?
- Was native I/O converted to SQL, or SQL to native I/O, without spec support?

## Readiness Calibration

- `Compile-shaped scaffold` → do not flag correctly placeholdered areas as missing implementation
- `Compile-ready draft` → normal implementation strictness
- `Production-safe implementation` → highest strictness, especially for scope creep and unsupported logic
