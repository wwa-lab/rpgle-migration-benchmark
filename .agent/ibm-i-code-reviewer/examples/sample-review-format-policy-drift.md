# Example Review Case: RPGLE Format Policy Drift

Use this example when an enhancement to an existing RPGLE program violates the agreed format policy.

## Scenario

- Existing program is fixed-format
- Reviewed change rewrites the touched branch in free format
- No source-format conversion was requested

## Expected Finding Shape

- Severity: `Major` if the drift changes the touched implementation style or complicates safe merge
- Category: `Format Policy`
- Location: touched branch / routine / changed region
- Finding: enhancement violates the existing-program fixed-format policy
- Recommendation: reissue the patch in fixed format or preserve the local touched-region style

## Why This Example Exists

- This is one of the most likely IBM i shop-specific failure modes
- It is not about modernization preference; it is about safe integration into existing source
