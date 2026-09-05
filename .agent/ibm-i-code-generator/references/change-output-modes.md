# Change Output Modes

Read this file when deciding between `Full Implementation`, `Skeleton`, and `Controlled Change Block`.

## Mode Selection

| Mode | Use When | Output Should Contain | Output Must Not Do |
|------|----------|-----------------------|--------------------|
| Full Implementation | Program Spec is materially complete and safe to execute against | Full member or full routine implementation for all non-TBD logic | Guess missing interfaces, fields, return codes, or objects |
| Skeleton | Program Spec has meaningful gaps but a safe structure can still be created | Member shape, declarations, flow regions, explicit placeholders | Pretend unresolved logic is complete |
| Controlled Change Block | Enhancement logic is clear, but full current source is unavailable or only a local patch is needed | Targeted replacement block, insertion block, or local scaffold tied to a routine/step/anchor | Fabricate the unchanged legacy member around the patch |

## Full Implementation Checklist

Use `Full Implementation` only if:
- Program Type is known
- Interface Contract is concrete enough
- File/object names are known or explicitly TBD-safe
- Return codes and error handling are defined well enough to implement
- Main Logic steps are concrete enough to code without invention

## Skeleton Checklist

Use `Skeleton` when:
- declarations can be formed safely
- flow regions are known but detailed logic is not
- interfaces or objects are partially unresolved
- placeholders can be tied back to `Open Questions / TBD`

Good placeholder styles:
- `TODO (Spec TBD)`
- `TODO (Open Questions #2)`
- `TODO (Step 4 / BR-03 clarification needed)`

## Controlled Change Block Checklist

Prefer a `Controlled Change Block` when:
- the work is an enhancement to an existing member
- the changed logic is clear from the Program Spec
- unchanged code shape cannot be safely reconstructed
- the user still needs implementation help without a full member rewrite

Each change block should identify:
- target routine / subroutine / anchor
- affected step or BR where possible
- whether the block is insertion, replacement, or local scaffold
- that it is not a verified drop-in replacement unless current source was provided

## Anti-Patterns

Avoid these:
- generating a complete legacy fixed-format member with invented declarations
- filling in unknown file names to make compile-looking source
- emitting a full enhancement member when only a local patch is safely supported
- treating `Skeleton` as a cosmetic disclaimer while still inventing logic
