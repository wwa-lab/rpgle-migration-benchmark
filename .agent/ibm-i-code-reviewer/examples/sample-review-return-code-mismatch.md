# Example Review Case: Return Code Mismatch

Use this example when code behavior conflicts with `Return Code Definition` or `Error Handling`.

## Scenario

- Program Spec says validation error returns `1`
- Reviewed code returns `9` for the same condition

## Expected Finding Shape

- Severity: `Major`
- Category: `Interface Compliance` or `Error Handling`
- Location: return assignment or exit branch
- Finding: implementation uses a return code that contradicts the Interface Contract / Error Handling table
- Recommendation: align the return code to the Program Spec or revise the Program Spec before code patching if the spec is wrong

## Why This Example Exists

- Return-code mismatches are easy to miss in implementation
- They create downstream caller and test regressions even if the branch "looks correct"
