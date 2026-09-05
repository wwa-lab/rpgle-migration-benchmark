# Tier Guide — Spec Levels (V2.5)

Detailed rules for selecting and applying each Spec Level.

---

## Why Tiering Exists

V2.0 required every section for every spec. This created two problems:

1. **Over-specification fatigue**: A developer changing a single validation threshold had
   to wade through a 25-section spec. The ceremony killed adoption.
2. **Incomplete-input paralysis**: When requirements were partial, the generator filled
   sections with TBD rows that added no value — a Data Contract full of TBDs is noise.

Tiering solves both by matching spec depth to change complexity. A 1-field change gets a
10-section Lite spec. A new program gets the full 25-section spec. The quality rules are
identical — only the scope changes.

---

## Level Definitions

### L1 — Lite Spec

**Use when**: The change is small, isolated, and does not alter the program's interface,
file usage, or external dependencies.

**Typical changes**:
- Change a validation threshold (e.g., credit limit from $5K to $10K)
- Add a new constant or flag value
- Modify a message or display label
- Add a simple field-level validation
- Toggle an existing flag

**Section count**: ~10 sections
**Key principle**: Document the change precisely, not the entire program. The Lite spec
assumes the developer already knows the program and just needs the change scoped.

**Sections included**:
- Spec Header (REQUIRED) — with Change Type = "Change to Existing"
- Amendment History (REQUIRED)
- Business Rules (REQUIRED) — only new/modified rules
- Interface Contract (CONDITIONAL) — only if parameters change
- File Usage (CONDITIONAL) — only if file access changes
- Constants (CONDITIONAL) — only if constants change
- Main Logic (REQUIRED) — only new/modified steps, with context steps
- Error Handling (REQUIRED) — all 4 categories, focused on the change
- Programming Language (REQUIRED)
- Open Questions (REQUIRED)
- Spec Summary (REQUIRED)

**Omitted sections** (not needed at this scope):
Data Contract, Caller Context, Functions, Traceability Matrix, External/Internal DS,
External Subroutines, Standard Subroutines, Data Queue, Data Area, External Program Calls,
File Output / Update, Processing Considerations, Amend Data Structure.

### L2 — Standard Spec

**Use when**: The change modifies logic flow, adds business rules, changes the parameter
interface, or adds moderate new functionality within an existing program.

**Typical changes**:
- Add a new validation routine
- Modify the processing flow (new IF/ELSE branches)
- Add or modify parameters
- Add a new subroutine within the program
- Change how an existing file is accessed (new key, new fields read)

**Section count**: ~16 sections
**Key principle**: Full logic specification, but infrastructure sections (DS, subroutines)
are conditional — include only what the change touches.

### L3 — Full Spec

**Use when**: A new program is being created, or an existing program is being fundamentally
redesigned (new file access, new external calls, new data queues, multi-file transactions).

**Typical changes**:
- New program from scratch
- Major redesign of an existing program
- Adding new file access or external program calls
- Adding data queue or data area usage
- Multi-file transaction requiring commitment control

**Section count**: All sections
**Key principle**: Complete specification for developer implementation, test generation,
and impact analysis. Nothing is omitted.

---

## Decision Examples

| Requirement | Level | Reasoning |
|-------------|-------|-----------|
| "Change the credit limit check from $5000 to $10000" | L1 | Single constant change + one BR modification |
| "Add a check: if customer is inactive, reject the order" | L2 | New BR, new logic step, modifies processing flow |
| "Add a new parameter to return the error message text" | L2 | Interface Contract change, new field, new logic |
| "Create a new program that reads the invoice file and sends totals to a data queue" | L3 | New program, new file access, new data queue |
| "Rewrite the order validation to use the new pricing file instead of the old one" | L3 | New file access, multiple BR changes, fundamental logic change |
| "Fix the error message when customer is not found — it says the wrong thing" | L1 | Cosmetic change to one step |

---

## Change Spec Tagging

When a spec modifies an existing program (any level), use these tags to distinguish
new content from existing context:

- **(NEW)** — This element did not exist before. It is being added by this change.
- **(MODIFIED)** — This element existed but is being changed.
- **(EXISTING — context only)** — This element is unchanged. It is included only to
  give the developer context for where the change fits.
- **(EXISTING — unchanged)** — Same as above, used in Data Contract for unchanged fields.

These tags serve three purposes:
1. **Developer clarity**: "What exactly am I changing vs. what already exists?"
2. **Test generation**: Only (NEW) and (MODIFIED) elements need new test cases.
3. **Impact analysis**: Only (MODIFIED) elements affect existing test cases.

---

## Completeness Strategy

The tiering system prevents over-specification, but within each level, the REQUIRED /
CONDITIONAL / OPTIONAL classification prevents under-specification:

- **REQUIRED**: Must appear. If genuinely empty, write `N/A`. Omitting a REQUIRED
  section is an error.
- **CONDITIONAL**: Must appear IF the change touches this area. If irrelevant to the
  change, omit the section entirely — do not write `N/A` (that implies it was considered
  and found empty; omission means it is out of scope).
- **OPTIONAL**: Include if the user provides relevant information or if it would help the
  developer. Do not force it.

This means a well-formed L1 spec may have only 10 sections, but every one of those 10
sections is fully specified. A poorly-formed L3 spec with 25 sections full of TBDs is
worse than a tight L1 with 10 complete sections.

**The goal is not maximum sections. The goal is maximum signal per section.**
