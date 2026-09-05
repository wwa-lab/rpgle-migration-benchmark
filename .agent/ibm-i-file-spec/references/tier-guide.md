# Tier Guide — IBM i File Spec (V2.0)

Rules and examples for selecting the correct Spec Level (L1 / L2 / L3).

---

## Quick Reference

| Level | Name | Scope | Typical Use |
|-------|------|-------|-------------|
| L1 | Lite | Single-field change, attribute modification, simple add | Add field to existing PF, change field length, add function key |
| L2 | Standard | New simple file, moderate change | New PF with straightforward fields, new non-join LF, simple DSPF/PRTF |
| L3 | Full | New complex file, major redesign | New DSPF with subfile, join LF, complex PRTF, PF with constraints |

---

## Decision Table

| Condition | Level |
|-----------|-------|
| New PF with complex key structure or multiple record formats | **L3 (Full)** |
| New LF with join specification | **L3 (Full)** |
| New DSPF with subfile or multiple record formats | **L3 (Full)** |
| New PRTF with multiple record formats and complex layout | **L3 (Full)** |
| New simple PF (single format, straightforward fields) | **L2 (Standard)** |
| New simple LF (select/omit or rekey only) | **L2 (Standard)** |
| New simple DSPF (single record format, no subfile) | **L2 (Standard)** |
| New simple PRTF (single record format, simple layout) | **L2 (Standard)** |
| Add field(s) to existing PF | **L1 (Lite)** |
| Modify field attributes (length, type, edit code) | **L1 (Lite)** |
| Add/modify function keys on existing DSPF | **L1 (Lite)** |
| User explicitly requests a specific level | **Use requested level** |
| Unclear | **Default to L2 (Standard)** |

---

## Decision Examples

### Example 1: "Add email address field to customer master file"

**Analysis:**
- Change to existing PF
- Single field addition
- No key change, no structural change

**Decision: L1 (Lite)**

Rationale: Isolated field addition. Only needs Field Definitions with the new field
tagged (NEW) and minimal context.

---

### Example 2: "Create a new order header physical file with order number, customer, date, status, and total"

**Analysis:**
- New PF
- Single record format
- Straightforward fields (5-6 fields)
- Simple key (order number, unique)

**Decision: L2 (Standard)**

Rationale: New file but simple structure. Standard level provides full field definitions,
key definition, and related objects without the overhead of constraints, processing
considerations, and other L3 sections.

---

### Example 3: "Create a display file for order inquiry with a subfile showing order lines"

**Analysis:**
- New DSPF
- Multiple record formats (header, subfile record, subfile control, footer)
- Subfile with paging
- Function keys (F3, F5, F12, page keys)
- Indicator logic for subfile control

**Decision: L3 (Full)**

Rationale: Subfile screens are inherently complex. Need full indicator documentation,
subfile definition, function keys, and complete record format layouts.

---

### Example 4: "Create a logical file over ORDDTL keyed by customer number and order date for reporting"

**Analysis:**
- New LF (the LF is new, even though the PF exists)
- Non-join logical
- Rekey only (different key from PF)
- No select/omit

**Decision: L2 (Standard)**

Rationale: Simple rekey logical. Standard level covers based-on PF, key definition,
and field selection.

---

### Example 5: "Create a join logical file combining order header and order detail for invoice printing"

**Analysis:**
- New LF with join specification
- Two physical files joined
- Join fields, join type
- Field selection from both files

**Decision: L3 (Full)**

Rationale: Join logicals require full join specification, field mapping from multiple
files, and careful key definition.

---

### Example 6: "Change the customer name field from 30 characters to 50 characters"

**Analysis:**
- Change to existing PF
- Single field attribute modification
- No new fields, no key change

**Decision: L1 (Lite)**

Rationale: Minimal change scope. One field tagged (MODIFIED) with the attribute change.

---

### Example 7: "Add select/omit criteria to existing logical file to show only active customers"

**Analysis:**
- Change to existing LF
- Adding select/omit criteria
- No field or key changes

**Decision: L1 (Lite)**

Rationale: Targeted change to one section. Select/Omit Criteria section with (NEW)
entries.

---

### Example 8: "Create a version file of CUSTMAST called CUSTMASV for data migration"

**Analysis:**
- PF version file
- Same record format as CUSTMAST
- Different file name (CUSTMASV)
- Fields inherited from source — no new definitions needed

**Decision: L1 (Lite)**

Rationale: PF version file inherits the record format and field definitions from the
source. The spec only needs to document the new file name, the Version Of reference,
and any key differences.

---

### Example 9: "Create a version logical file over CUSTMAST with a different key for the new reporting module"

**Analysis:**
- LF version file
- Different record format from original LF
- Different key arrangement
- Based on same PF (CUSTMAST)

**Decision: L2 (Standard)**

Rationale: LF version files typically have a different record format and key structure,
requiring explicit field selection/mapping and key definition documentation.

---

## Edge Cases

**New file but user says "simple"**: Trust the user. If they say L1, use L1. But note
in Open Questions if the file appears to warrant a higher level.

**Enhancement that cascades**: Adding a field to a PF may require corresponding changes
to LFs, DSPFs, and programs. Each file change gets its own File Spec. The Program Spec
handles program changes separately.

**Existing file definition provided**: When the user provides the current DDS source or
field list, use it as context for (EXISTING) entries. Do not reproduce the entire
existing definition — only include what is needed to contextualize the change.

**PF version file**: Always L1. The record format is inherited — do not redefine all
fields from scratch. Reference the source PF and note only differences (if any).

**LF version file**: Usually L2. The record format is different, so field selection,
key definition, and possibly select/omit all need explicit documentation.
