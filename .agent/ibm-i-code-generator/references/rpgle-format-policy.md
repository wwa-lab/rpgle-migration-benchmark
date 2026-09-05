# RPGLE Format Policy

Read this file when Program Type is `RPGLE`, especially for enhancement work.

## Policy Matrix

| Scenario | Required Format | Default Output Shape |
|----------|-----------------|----------------------|
| New Program | Free format | Full member or scaffold in free-format RPGLE |
| Existing fixed-format program | Fixed format | Targeted fixed-format patch, scaffold, or controlled change block |
| Existing mixed-format program | Match the touched region | Patch only the local region in its existing style |
| Existing program with no current source provided | Fixed format by default | Controlled draft or change block, not fabricated full legacy member |

## Touched-Region Rule

- Do not normalize a member from fixed to free format just because free format is available.
- In mixed-format members, inspect the local area being changed:
  - fixed-format calculation area → emit fixed-format code there
  - existing free-format procedure/block → emit free-format code there
- Leave unrelated regions untouched.

## Fixed-Format Preservation Rules

For existing fixed-format RPGLE:
- preserve `H`, `F`, `D`, and `C` specification layout
- preserve indicator usage style (`*INxx`) when already present
- preserve existing `BEGSR` / `ENDSR`, tags, and branch idioms when current source supports them
- preserve column-sensitive continuation patterns

Do not silently replace indicator-based logic with `%FOUND`, `%ERROR`, or other BIF-driven logic
unless the Program Spec explicitly calls for that change.

## Free-Format Defaults

For new free-format RPGLE members, prefer this shape when the Program Spec is complete enough:
1. Header comment
2. `ctl-opt`
3. File declarations
4. Data declarations
5. Interface/prototype declarations
6. Mainline or main procedure ordered by `Step 1`, `Step 2`, etc.
7. Explicit error and return handling

## Native I/O vs SQL

- Preserve native file I/O when the Program Spec describes native access or when current source is native I/O.
- Use `EXEC SQL` only when the Program Spec supports SQL-based access.
- Do not convert native I/O to SQL, or SQL to native I/O, unless the Program Spec explicitly requires the change.

## Review Questions

Use these quick checks during generation or review:
- Is this new or existing code?
- If existing, is the touched region fixed, free, or mixed?
- Is the output patching only the requested area?
- Did the implementation preserve indicator and subroutine style where required?
- Did the implementation avoid silent modernization?
