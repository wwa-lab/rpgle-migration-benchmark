# Example Review Case: Data Access Drift

Use this example when code changes native I/O and SQL strategy without Program Spec support.

## Scenario

- Existing source uses native file I/O
- Program Spec does not call for SQL conversion
- Reviewed code introduces `EXEC SQL`

## Expected Finding Shape

- Severity: `Major`
- Category: `Unsupported Logic` or `Enhancement Safety`
- Location: SQL block or replaced file-access region
- Finding: implementation changes the data access pattern without spec support
- Recommendation: revert to the existing access pattern or revise the Program Spec before code regeneration

## Why This Example Exists

- Data access conversion is architectural drift, not a cosmetic code choice
- It affects testing, locking behavior, and downstream integration
