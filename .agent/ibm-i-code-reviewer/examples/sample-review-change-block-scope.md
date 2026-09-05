# Example Review Case: Change Block Scope Creep

Use this example when a controlled change block expands beyond the justified enhancement area.

## Scenario

- User requested a small enhancement
- Reviewed artifact is a change block
- The block also rewrites unrelated declarations or adjacent logic not covered by `(NEW)` / `(MODIFIED)` items

## Expected Finding Shape

- Severity: `Major`
- Category: `Enhancement Safety`
- Location: change block plus unrelated declarations or rewritten branch
- Finding: controlled change block exceeds the intended enhancement boundary
- Recommendation: reduce the patch to the minimal affected region and keep unrelated code outside the delta

## Why This Example Exists

- Scope creep is one of the main risks in enhancement work
- A good reviewer should catch unnecessary rewrite even when the resulting code still compiles
