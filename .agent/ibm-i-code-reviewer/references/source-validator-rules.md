<!-- Local adaptation: repository skill references use .agent. -->

# Source Validator Rules

Status: Draft shell

This file defines review-specific source validation rules for IBM i source review.

Purpose:
- Provide stricter or more specific review rules than the general development
  guideline when needed
- Override conflicting review expectations from
  `.agent/ibm-i-code-generator/references/AS400 Program Development Guideline.md`
- Support both full source review and compile-precheck review

Priority:
1. Program Spec and explicit user instruction
2. Existing source and touched-region preservation for enhancements
3. This file
4. `.agent/ibm-i-code-generator/references/AS400 Program Development Guideline.md`
5. Skill defaults

For compile precheck, apply only the rules in this file that materially affect:
- compile safety
- runtime safety
- transport readiness

Do not use this file to invent:
- business logic
- file or field names
- interfaces
- return codes
- undocumented side effects

---

## 1. Scope

Define which artifacts these rules apply to.

Template:
- RPGLE source review:
- CLLE source review:
- Enhancement review:
- Change-block review:
- Compile-precheck applicability:

---

## 2. Review Overrides

List any review rules that must override the general development guideline.

Template:
- Override area:
- General guideline rule:
- Validator rule:
- Reason:

---

## 3. Mandatory Review Rules

List review-specific mandatory rules.

Template:
- Naming validation:
- Header/comment validation:
- Declaration/layout validation:
- Enhancement boundary validation:
- Error-handling validation:
- Forbidden-pattern validation:

---

## 4. Severity Mapping

Define how validator violations should be classified.

Template:
- Blocker:
- Warning:
- Info:
- Review-only note:

---

## 5. Compile-Relevant Rules

List the subset that compile-precheck should apply.

Template:
- Compile blocker patterns:
- Runtime-risk patterns:
- Mandatory alias/declaration checks:
- Mandatory bounds/overflow checks:
- Mandatory MONMSG/error checks:

---

## 6. Non-Compile Cosmetic Rules

List rules that belong only in source review and should not be raised by
compile-precheck.

Template:
- Banner/comment style:
- Spacing/blank lines:
- Modification history format:
- Header wording:

---

## 7. Examples

Add short examples or references to compliant and non-compliant patterns.

Template:
- Compliant example:
- Non-compliant example:
- Special-case exception:

---

## 8. Open Questions

Track unresolved validator policy items here.

Template:
- TBD:
- Needs team confirmation:
- Pending exception:
