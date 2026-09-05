# RPGLE Review Policy

Read this file when reviewing `RPGLE`.

## Format Policy

| Scenario | Expected Policy |
|----------|-----------------|
| New Program | Free format |
| Existing Program | Fixed format |
| Mixed-format Existing Program | Keep consistent with the original source |

## What Counts as a Real Format Finding

Raise a format-policy finding when:
- an existing fixed-format program is rewritten into free format without justification
- a mixed-format touched region is rewritten in the wrong local style
- indicator usage is changed across styles without spec support
- fixed-format continuation or layout is broken in a way that risks incorrect behavior or poor maintainability

Do **not** raise a format finding merely because:
- the reviewer prefers free format
- an old program uses indicators
- the code uses fixed-format style consistently where that is the required policy

## Indicator Review Guidance

- Existing fixed-format source: preserve `*INxx` usage if that is how the current source works
- New free-format source: named indicators or `%ERROR` / `%FOUND` / `%EOF` are acceptable defaults
- If indicator logic is changed across styles without spec support, treat that as scope or unsupported-logic risk, not cosmetic style preference

## Mixed-Format Rule

For mixed-format members:
- inspect the touched region, not just the member globally
- fixed-format change inside fixed region → acceptable
- free-format change inside existing free region → acceptable
- converting unrelated fixed code because some free-format procedures exist elsewhere → drift
