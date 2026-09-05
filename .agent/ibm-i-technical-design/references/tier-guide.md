# Tier Guide — Design Levels (V1.0)

Detailed rules for selecting and applying each Design Level.

---

## Why Tiering Exists

A new program with multi-file transactions and external data queue integration needs
a full architecture document. A change to a credit limit threshold does not. Forcing
every enhancement through a full design template creates two problems:

1. **Over-design fatigue**: A developer changing a single constant has to wade through
   18 sections of design ceremony. The overhead kills adoption.
2. **Incomplete-input noise**: When requirements are partial, the generator fills
   sections with TBD rows that add no value. A Module Allocation table full of TBDs
   is noise, not design.

Tiering solves both by matching design depth to change complexity. A threshold change
gets a 1-2 page Lite design. A new program gets the full 18-section document. The
quality rules are identical -- only the scope changes.

---

## Level Definitions

### L1 -- Lite Design

**Use when**: The enhancement is small, isolated, and does not alter the solution's
module structure, file dependencies, or external interfaces.

**Typical enhancements**:
- Change a validation threshold or business rule constant
- Add a simple flag or field-level check
- Modify a message or display element
- Add a minor validation within an existing module

**Key principle**: Document the design context of the change -- what is affected and
why -- without elaborating the full solution architecture. The Lite design assumes the
reader already knows the system and needs only the change scoped at design level.

**L1 should be short.** A well-formed L1 design is 1-2 pages. It is a design note,
not a mini-architecture document. Keep sections brief:
- Processing Flow: 1-2 stages
- Business Rule Allocation: only new/modified rules
- Error Handling Strategy: confirm the existing strategy covers the change, or note
  what changes
- Impact Analysis: brief affected-object table and one-line downstream note

**Impact Analysis is REQUIRED even at L1.** In IBM i environments, even a single-field
change can affect downstream programs, job flows, or dependent objects. Skipping impact
analysis for "small" changes is a common source of production incidents.

### L2 -- Standard Design

**Use when**: The enhancement modifies processing flow, adds or changes business rules,
alters interface dependencies, or introduces new object interactions within an existing
solution.

**Typical enhancements**:
- Add a new validation routine or processing stage
- Modify how programs interact or how data flows between objects
- Add or change parameters on an existing interface
- Introduce a new file dependency or external program call
- Change the responsibility boundary between existing modules

**Key principle**: Full design specification of the enhancement, including module
allocation, processing flow, object interactions, and impact analysis. Operational
considerations are conditional -- include only if the enhancement affects batch windows,
locking, or scheduling.

### L3 -- Full Design

**Use when**: A new program is being created, or an existing program is being
fundamentally redesigned -- new file access, new external interfaces, multi-object
processing flows.

**Typical scenarios**:
- New program from scratch
- Major redesign of an existing program
- New file access, data queue, or data area introduction
- Multi-program transaction flow requiring commitment control
- New batch process or scheduler integration

**Key principle**: Complete design for architecture review, impact assessment, and
downstream Program Spec generation. All 18 sections are required.

---

## Decision Table

| Condition | Level |
|-----------|-------|
| New program or process with multiple object dependencies | **L3 (Full)** |
| Enhancement that introduces new file access, external calls, or data queue/area usage | **L3 (Full)** |
| Enhancement that adds or modifies business rules, changes processing flow, or alters interface dependencies | **L2 (Standard)** |
| Enhancement that changes a parameter interface or introduces a new module responsibility | **L2 (Standard)** |
| Small enhancement with narrow impact -- single rule change, threshold change, flag addition | **L1 (Lite)** |
| Cosmetic or message-only change with no structural design impact | **L1 (Lite)** |
| User explicitly requests a specific level | **Use requested level** |
| Unclear | **Default to L2 (Standard)**, note in Open Questions |

---

## Decision Examples

| Requirement | Level | Reasoning |
|-------------|-------|-----------|
| "Change the credit limit threshold from $5,000 to $10,000" | L1 | Single rule change, no structural impact. One constant, one BR modification. Impact analysis confirms no downstream breakage. |
| "Fix the error message text when customer is not found" | L1 | Cosmetic change to a message string. No structural design impact, no file or interface change. |
| "Add validation: reject orders for inactive customers" | L2 | New business rule, new processing stage within existing flow. Requires new file interaction (customer status lookup) but no new program. |
| "Add a new output parameter to return error message text" | L2 | Interface change affecting downstream callers. Module responsibility unchanged but dependency contracts shift. |
| "Modify order processing to split domestic and international orders into separate output files" | L2 | New processing branch, new file interaction (international order file), modified business rules. Existing program structure, but flow changes significantly. |
| "Add a retry mechanism for external API calls with configurable timeout" | L2 | New processing stage, new configuration dependency (data area for timeout), modified error handling strategy. |
| "Create a new program to read invoices and send totals to a data queue" | L3 | New program, new file access, new data queue. Full design needed for architecture review. |
| "Rewrite order validation to use the new pricing file instead of the old one" | L3 | New file dependency, multiple rule changes, fundamental flow change. Even though the program exists, the redesign scope warrants full design. |
| "Build a batch process that reads pending orders, validates against inventory, and generates pick lists" | L3 | New batch program, multiple file accesses, scheduler integration, commitment control likely required. |

---

## Change Tagging Rules

When a design documents an enhancement to an existing solution (any level), use these
tags to distinguish new content from existing context:

- **(NEW)** -- This element did not exist before. It is being introduced by this design.
- **(MODIFIED)** -- This element existed but is being changed by this design.
- **(EXISTING -- context only)** -- This element is unchanged. It is included only to
  give the reader context for understanding the change.

### Where Tags Apply

| Design Section | Tagging Required? |
|----------------|-------------------|
| Business Rule Allocation | Yes -- every BR tagged |
| Module / Responsibility Allocation | Yes -- every module row tagged |
| High-Level Processing Flow | Yes -- stages tagged where applicable |
| Data / Object Interaction Design | Yes -- interactions tagged |
| Interface / Dependency Design | Yes -- interfaces tagged where applicable |
| Impact Analysis (Objects Affected) | No -- this table lists only impacted objects by definition |

### Tagging Purpose

Tags serve three purposes in the design context:
1. **Review clarity**: Reviewers instantly see what is changing vs. what exists for context
2. **Downstream handoff**: The Program Spec skill uses tags to scope its own generation
3. **Impact tracing**: Only (NEW) and (MODIFIED) elements need impact assessment

### Signal Over Noise

Include `(EXISTING -- context only)` entries only when they are necessary to understand
a new or modified element -- typically as a direct dependency or interaction partner.
Do not list every existing object, rule, or stage in the solution. A design cluttered
with EXISTING rows obscures the actual change.

---

## Completeness Strategy

The tiering system prevents over-design, but within each level, the REQUIRED /
CONDITIONAL / OPTIONAL classification prevents under-design:

- **REQUIRED**: Must appear. If genuinely empty, write `N/A`. Omitting a REQUIRED
  section is an error.
- **CONDITIONAL**: Must appear IF the enhancement touches this area. If irrelevant
  to the change, omit the section entirely -- do not write `N/A` (that implies it was
  considered and found empty; omission means it is out of scope).
- **OPTIONAL**: Include if the user provides relevant information or if it adds clear
  value to the design review. Do not force it.

### Section Inclusion by Level

| Section | L1 (Lite) | L2 (Standard) | L3 (Full) |
|---------|-----------|---------------|-----------|
| Document Header | REQUIRED | REQUIRED | REQUIRED |
| Amendment History | REQUIRED | REQUIRED | REQUIRED |
| Design Overview | REQUIRED | REQUIRED | REQUIRED |
| Business Context / Trigger | OPTIONAL | REQUIRED | REQUIRED |
| Design Objective | REQUIRED | REQUIRED | REQUIRED |
| Scope and Boundary | REQUIRED | REQUIRED | REQUIRED |
| Solution Overview | OPTIONAL | REQUIRED | REQUIRED |
| Module / Responsibility Allocation | CONDITIONAL | REQUIRED | REQUIRED |
| High-Level Processing Flow | REQUIRED | REQUIRED | REQUIRED |
| Data / Object Interaction Design | CONDITIONAL | REQUIRED | REQUIRED |
| Interface / Dependency Design | CONDITIONAL | REQUIRED | REQUIRED |
| Business Rule Allocation | REQUIRED | REQUIRED | REQUIRED |
| Error Handling Strategy | REQUIRED | REQUIRED | REQUIRED |
| Operational / Processing Considerations | OPTIONAL | CONDITIONAL | REQUIRED |
| Impact Analysis | REQUIRED | REQUIRED | REQUIRED |
| Assumptions / Constraints | REQUIRED | REQUIRED | REQUIRED |
| Open Questions / TBD | REQUIRED | REQUIRED | REQUIRED |
| Design Summary | REQUIRED | REQUIRED | REQUIRED |

This means a well-formed L1 design may have only 10-12 sections, but every one of
those sections is fully specified. A poorly-formed L3 design with 18 sections full
of TBDs is worse than a tight L1 with 10 complete sections.

**The goal is not maximum sections. The goal is maximum signal per section.**

---

## Level-Specific Quality Reminders

### L1 Quality

- Total design length: 1-2 pages
- No section is over-elaborated relative to the change scope
- Impact Analysis is present but proportionate (brief table, not exhaustive)
- Business Rule Allocation includes only new/modified rules
- Processing Flow: 1-2 stages maximum
- Error Handling Strategy: confirm existing strategy covers the change, or note changes

### L2 Quality

- Module / Responsibility Allocation includes all modules touched by the enhancement
- Processing Flow covers the modified flow completely (3-6 stages typical)
- Data / Object Interaction Design shows new/modified interactions
- Interface / Dependency Design identifies affected interfaces
- Impact Analysis includes test impact and migration notes
- Enhancement tagging applied consistently across all applicable sections

### L3 Quality

- All 18 sections present (none omitted)
- Business Context / Trigger fully populated
- Solution Overview describes the overall technical approach
- Operational / Processing Considerations addressed comprehensively
- Module / Responsibility Allocation covers all modules with role assignments
- Full call chain documented in Interface / Dependency Design
