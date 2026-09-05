# Example Review Case: BR Coverage Gap

Use this example when the code misses a business rule from the Program Spec.

## Scenario

- Program Spec includes `BR-03: Reject blank request ID`
- Reviewed code validates only length and format, not blank value

## Expected Finding Shape

- Severity: `Major` or `Critical` depending on impact
- Category: `Spec Alignment` or `Traceability`
- Location: specific validation branch or missing validation region
- Finding: code does not implement the blank-value rejection required by `BR-03`
- Recommendation: add the missing validation in the `Step n` region that owns input validation

## Why This Example Exists

- Missing BR coverage is one of the highest-value reviewer catches
- It is stronger than a style finding because behavior is missing, not merely presented differently
