# Enhancement Review Patterns

Read this file when reviewing `Change to Existing` implementations or change blocks.

## Delta-First Expectation

The paired `ibm-i-code-generator` defaults to minimal-delta output for enhancements.

That means:
- change blocks are normal
- full-member regeneration is exceptional
- a full revised member is only expected when the user explicitly requested it and current source was available

## Safe Enhancement Signals

- touched logic maps to `(NEW)` and `(MODIFIED)` spec items
- unchanged surrounding logic remains in place
- existing formatting and idioms are preserved
- file access pattern stays the same unless the spec explicitly changes it
- the change block identifies routine / step / anchor

## Risk Signals

- unrelated declarations rewritten
- existing subroutines or procedures reformatted wholesale
- native I/O silently converted to SQL
- new external call added without spec support
- return-code behavior changed outside the requested enhancement
- full member emitted without current source

## Controlled Change Block Review

For a change block:
- review the block as a local unit
- check whether its target location is identifiable
- verify it does not assume surrounding declarations or labels that were never provided
- avoid criticizing absence of unrelated full-member context if the block is clearly labeled as controlled draft
