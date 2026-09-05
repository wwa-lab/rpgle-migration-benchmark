# AS400 Program Development Guideline

Status: Draft shell

This file is the repository-local organization coding standard referenced by
`ibm-i-code-generator/SKILL.md`.

Use this document to define mandatory development rules that should shape
generated IBM i code.

Note:
- Keep business logic in the Program Spec, not here.
- Use this file for coding standards, formatting rules, naming rules, and
  forbidden patterns.
- When this file conflicts with the Program Spec or enhancement-safe existing
  source preservation, the Program Spec and existing source win.

---

## 1. Scope

Define which source types this guideline applies to.

Example placeholders:
- RPGLE new programs
- RPGLE enhancements
- CLLE new programs
- CLLE enhancements
- Fixed-format members
- Free-format members

---

## 2. Rule Priority

Document the intended priority order.

Recommended baseline:
1. Program Spec and explicit user instruction
2. Existing source and touched-region preservation for enhancements
3. This guideline
4. Skill default behavior

---

## 3. Mandatory Naming Conventions

Define required naming patterns for:
- Program names
- Parameters
- Work fields
- Constants
- Data structures
- Subroutines
- Key lists
- Return code variables
- Error indicators / status fields

Template:
- Parameters:
- Work fields:
- Constants:
- Data structures:
- Subroutines:
- Key lists:
- Return code fields:

---

## 4. Header and Comment Standards

Define required format for:
- Program header block
- Author / date / change history
- Section banners
- Inline comments
- BR / Step trace comments

Template:
- Header format:
- Change history format:
- Banner style:
- Inline comment style:
- Trace comment style:

---

## 5. Declaration and Layout Standards

Define required layout rules for:
- `ctl-opt`
- F-spec / D-spec ordering
- Procedure or subroutine ordering
- Blank-line spacing
- Alignment rules
- Column-sensitive fixed-format practices

Template:
- Declaration ordering:
- Section ordering:
- Spacing rules:
- Alignment rules:

---

## 6. RPGLE Development Rules

Define mandatory RPGLE practices.

Template:
- Free-format defaults:
- Fixed-format constraints:
- Indicator usage:
- Native I/O conventions:
- Embedded SQL conventions:
- Error handling:
- Commit / rollback handling:

---

## 7. CLLE Development Rules

Define mandatory CLLE practices.

Template:
- `PGM` / `DCL` layout:
- `MONMSG` usage:
- Command ordering:
- Message handling:
- Return handling:

---

## 8. Enhancement Rules

Define how enhancements must be implemented.

Template:
- Preserve existing naming:
- Preserve touched-region format:
- Preserve native I/O vs SQL style:
- Delta block vs full-member expectations:
- Modification log requirements:

---

## 9. Forbidden or Discouraged Patterns

List patterns the generator must avoid.

Template:
- Forbidden:
- Discouraged:
- Allowed only with justification:

---

## 10. Required Error Handling Rules

Define the minimum standard for validation, exception handling, and return codes.

Template:
- Validation failures:
- File I/O failures:
- External call failures:
- SQL failures:
- Default return code handling:

---

## 11. Examples of Compliant Patterns

Add short approved examples or links to reference members.

Template:
- Example member for fixed-format RPGLE:
- Example member for free-format RPGLE:
- Example member for CLLE:

---

## 12. Open Questions

Track unresolved standard items here until finalized.

Template:
- TBD:
- Needs team confirmation:
- Pending migration decision:
