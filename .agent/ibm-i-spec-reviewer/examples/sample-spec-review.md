# Sample Spec Review — L2 Standard Functional Spec

Calibration example showing the review report format for a Functional Spec with a
layer boundary violation, a missing acceptance criterion, and a readability issue.

---

**Scenario:** An L2 Standard Functional Spec for an enhancement to the customer
credit hold process has been submitted for review. The spec is generally well-structured
but contains three issues:

1. A "Module Allocation" table appears in the Functional Spec (belongs in Technical Design)
2. BR-03 has no corresponding acceptance criterion
3. The Future Behavior narrative for one section uses dense run-on sentences

---

## Review Summary

- **Review ID:** RV-20260402-01
- **Reviewed Document:** FS-CRDHLD-20260328-01 — Customer Credit Hold Enhancement
- **Document Type:** Functional Spec
- **Document Level:** L2 Standard
- **Change Type:** Enhancement
- **Review Scope:** Full review

---

## Overall Assessment

The spec demonstrates solid business analysis with well-defined functional requirements and
clean BR numbering. The most significant issue is a layer boundary violation: Section 9
contains a Module Allocation table that belongs in the Technical Design layer, not the
Functional Spec. Additionally, BR-03 lacks a corresponding acceptance criterion, which
would leave a gap in business validation. With targeted fixes, this document should be
ready for business review.

---

## Strengths

- Business Rules are clearly numbered (BR-01 through BR-05) with consistent one-sentence
  format and unambiguous conditions
- Current Behavior and Future Behavior sections provide a clean before/after contrast that
  stakeholders can validate without technical knowledge
- Exception Scenarios cover all four mandatory categories and include realistic business
  language
- FR-nn to BR-xx cross-references are present and consistent throughout

---

## Findings

### Critical Findings

None.

### Major Findings

| # | Category | Location | Finding | Recommendation |
|---|----------|----------|---------|----------------|
| M-01 | Layer Boundary | Section 9 — "Module Allocation" | The spec contains a Module Allocation table assigning responsibilities to specific programs (CRDHLDR, CRDHLDUPD, CRDHLDNTF). Module allocation is a Technical Design concern — it defines how the solution is structured, not what the business requires. This content crosses the Functional Spec boundary into Technical Design territory. | Remove Section 9 entirely from the Functional Spec. Preserve the content as input for the Technical Design skill (`ibm-i-technical-design`), where it belongs in the Module / Responsibility Allocation section. The Functional Spec should describe what the system must do, not how the solution is decomposed into modules. |
| M-02 | Missing Information | Business Rules — BR-03; Acceptance Criteria section | BR-03 ("Credit hold must be released automatically when the outstanding balance drops below the threshold") has no corresponding acceptance criterion. All other BRs (BR-01, BR-02, BR-04, BR-05) have at least one AC entry. BR-03 defines a key automated behavior that requires explicit business validation criteria. | Add at least one acceptance criterion for BR-03 that specifies the testable condition — for example, the threshold value, the timing of the automatic release, and the expected system state after release. Reference BR-03 explicitly in the AC entry. |

### Minor Findings

| # | Category | Location | Finding | Recommendation |
|---|----------|----------|---------|----------------|
| m-01 | Readability | Section 5 — Future Behavior, paragraph 2 | The second paragraph describing the credit hold notification flow is a single run-on sentence spanning six lines. It combines the trigger condition, the notification channel, the recipient logic, and the escalation path in one clause chain. This reduces readability for business stakeholders who need to validate each element independently. | Break the paragraph into separate sentences, one per behavior element: (1) trigger condition, (2) notification channel, (3) recipient determination, (4) escalation path. This matches the clarity standard set by the other Future Behavior paragraphs in the same section. |

### Suggestions

| # | Category | Location | Suggestion |
|---|----------|----------|------------|
| S-01 | Readability | Section 4 — Current Behavior | Consider adding a brief summary sentence at the top of the Current Behavior section stating which program(s) currently handle the credit hold process. This would give reviewers immediate context without needing to read the full narrative first. |

---

## Layer Boundary Check

**Document type:** Functional Spec
**Expected layer behavior:** Business-level what — functional requirements, business rules,
current/future behavior, acceptance criteria, exception scenarios. No module allocation,
no object interaction design, no processing stages, no implementation logic.

**Verdict:** Minor drift — downward into Technical Design

Section 9 contains a Module Allocation table that assigns functional responsibilities to
named program objects (CRDHLDR, CRDHLDUPD, CRDHLDNTF). This is solution decomposition,
which belongs in the Technical Design layer. The remainder of the spec stays cleanly
within the Functional Spec boundary.

- **Content that belongs elsewhere:** Module Allocation table (Section 9)
- **Target layer:** Technical Design — Module / Responsibility Allocation
- **Sections affected:** Section 9 only; all other sections are clean

---

## Completeness Check

| Section | Expected | Status | Notes |
|---------|----------|--------|-------|
| Spec Header | Required | Present | Complete |
| Functional Overview | Required | Present | Clear and concise |
| Business Objective | Required | Present | Aligned with change intent |
| Current Behavior | Required | Present | Well-structured narrative |
| Future Behavior | Required | Present | Complete but see m-01 for readability |
| Business Rules | Required | Present | BR-01 through BR-05, all tagged correctly |
| Functional Requirements | Required | Present | FR-01 through FR-04 with BR cross-references |
| Acceptance Criteria | Required | Incomplete | Missing AC for BR-03 (see M-02) |
| Exception Scenarios | Required | Present | All four mandatory categories covered |
| Functional Inputs / Outputs | Required | Present | Complete |
| User / Role / Trigger Context | Required | Present | Two roles, one trigger identified |
| Scope | Required | Present | In-scope and out-of-scope clearly defined |
| Open Questions | Required | Present | Three items, all actionable |

---

## Consistency / Traceability Check

- **BR/FR numbering consistent:** Yes — BR-01 through BR-05 and FR-01 through FR-04
  are sequential with no gaps
- **Acceptance criteria coverage:** No — BR-03 has no corresponding acceptance criterion;
  BR-01, BR-02, BR-04, BR-05 are each covered
- **Cross-reference integrity:** FR-01 references BR-01 and BR-02; FR-02 references BR-03;
  FR-03 references BR-04; FR-04 references BR-05. All references resolve correctly.
  However, FR-02's dependency on BR-03 highlights the AC gap — if BR-03 cannot be validated,
  FR-02 acceptance is also unverifiable.

---

## Unsupported Content Check

| # | Location | Content | Concern |
|---|----------|---------|---------|
| U-01 | Section 9 — Module Allocation | Program names CRDHLDR, CRDHLDUPD, CRDHLDNTF | These program names appear in the module allocation table but are not referenced in the original requirements or elsewhere in the Functional Spec. They may be correct design-level names, but at the Functional Spec layer they are unconfirmed. This concern resolves naturally if the content moves to Technical Design as recommended in M-01. |

---

## IBM i Fit Check

- **Object names realistic:** Cannot verify — the three program names in Section 9 follow
  IBM i naming conventions (uppercase, 10 characters or fewer) but their existence cannot
  be confirmed from the document alone
- **Program type appropriate:** Not specified at Functional Spec level — appropriate, as
  program type is a Technical Design / Program Spec concern
- **Batch/online distinction clear:** Yes — the spec identifies this as an online process
  triggered by user action
- **File/object dependencies plausible:** Yes — references to customer master and accounts
  receivable files are consistent with a credit hold process
- **Level of detail matches IBM i delivery expectations:** Yes — appropriate for a
  Functional Spec, except for the module allocation (see M-01)

---

## Readiness Decision

**Readiness:** Ready with minor fixes

**Ready for:** Business review, after the fixes below are applied

**Fix path:** Patch with targeted fixes

**Blocking issues:** 0 Critical findings
**Non-blocking issues:** 2 Major + 1 Minor findings

The two Major findings (layer boundary violation and missing acceptance criterion) should
be resolved before business review to ensure the document is clean for sign-off. Neither
requires structural rework — both are targeted corrections.

---

## Recommended Fix Actions

1. **Remove Section 9 (Module Allocation)** — Move this content to a Technical Design
   input note. The Functional Spec should not contain module-level decomposition. (M-01)
2. **Add acceptance criterion for BR-03** — Define at least one testable condition for the
   automatic credit hold release behavior. Ensure it covers threshold, timing, and
   resulting system state. (M-02)
3. **Break up the run-on sentence in Future Behavior paragraph 2** — Split into separate
   sentences covering trigger, notification channel, recipient logic, and escalation
   path. (m-01)
4. **Verify program names** — When the Module Allocation content moves to Technical Design,
   confirm that CRDHLDR, CRDHLDUPD, and CRDHLDNTF are the correct program object names
   on the target system. (U-01)
