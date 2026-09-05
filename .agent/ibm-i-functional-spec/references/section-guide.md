# Section Guide — IBM i Functional Spec (V1.0)

Detailed guidance on what belongs in each section of the Functional Spec.
See `references/tier-guide.md` for Document Level selection rules.

---

## Document Header

**Contains:**
- Document ID (format: `FS-yyyymmdd-nn`)
- Document Level (L1 Lite, L2 Standard, L3 Full)
- Version, Status, Change Type, Target Platform
- Related Business Process name(s)
- One to two sentence functional summary

**Does NOT contain:**
- Program names, module names, or object names
- Technical platform details beyond "IBM i"
- References to specific files, data queues, or data areas

**Common mistakes:**
- Including program names in the header (those belong in Technical Design)
- Writing a multi-paragraph description instead of 1-2 sentences
- Omitting the Document Level or Change Type

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Amendment History

**Contains:**
- Version history table with Version, Date, Author, Change Description
- First draft always starts at Version 1.0

**Does NOT contain:**
- Technical change details (e.g., "changed file access method")
- Commit hashes or deployment references

**Common mistakes:**
- Leaving the table empty instead of adding the initial 1.0 row
- Including implementation-level change descriptions

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Functional Overview

**Contains:**
- 2-4 sentence executive summary
- What business function is being specified
- Why it matters to the business
- Who benefits
- For enhancements: what exists today, what changes, and why

**Does NOT contain:**
- Technical approach or solution design
- Module or program names
- Detailed business rules (those go in the Business Rules section)

**Common mistakes:**
- Writing a technical summary instead of a business summary
- Restating the requirement verbatim instead of summarizing at executive level
- Exceeding 4 sentences — this is a summary, not a narrative

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Business Context / Background

**Contains:**
- Business Area identification
- Current Pain Point or Driver (the business reason for the change)
- Requesting Stakeholder (role or team)
- Business Priority (if stated)
- Enough context for a reviewer unfamiliar with the process to understand why this spec exists

**Does NOT contain:**
- Technical background (system architecture, platform history)
- Solution approach or design rationale
- Detailed process descriptions (those belong in Current/Future Behavior)

**Common mistakes:**
- Describing the technical environment instead of the business context
- Including solution direction ("we will use a new validation program")
- Writing too little — a single sentence is rarely enough for L2/L3

**Included at:** L1 OPTIONAL | L2 REQUIRED | L3 REQUIRED

---

## Business Objective

**Contains:**
- The business goal in 1-3 sentences
- The outcome the business wants to achieve — not a restatement of the requirement
- Measurable or observable business impact when possible

**Does NOT contain:**
- Technical objectives ("reduce file I/O", "improve response time")
- Implementation goals ("create a new program", "add a parameter")
- A copy of the requirement

**Common mistakes:**
- Restating the requirement as the objective ("add credit limit checking" is a requirement, not an objective; "reduce bad debt write-offs by preventing over-limit orders" is an objective)
- Including multiple unrelated objectives (each spec should have one clear objective)
- Stating a technical goal disguised as a business goal

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Scope and Boundary

**Contains:**
- In Scope: bulleted list of what this Functional Spec covers
- Out of Scope: bulleted list of what this spec explicitly does NOT cover
- Boundary Notes: upstream processes assumed in place, downstream processes not covered, related changes handled separately

**Does NOT contain:**
- Technical scope (which programs change, which files are affected)
- Design decisions or implementation boundaries
- Detailed requirements (those belong in Functional Requirements)

**Common mistakes:**
- Listing technical objects in scope instead of business capabilities
- Omitting Out of Scope entirely — this is critical for scope control
- Including implementation tasks ("create new program", "modify display file")

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Current Process / Current Behavior

**Contains:**
- How the process works today as seen by the business
- What the user or operator experiences
- What business outcomes are currently produced
- For L1: only the specific behavior being changed (1-3 sentences)
- For new functions: "N/A — new function. No current process exists."

**Does NOT contain:**
- Technical internals (file reads, program calls, processing stages)
- Field names, return codes, or data structures
- The entire process history — only the relevant current state

**Common mistakes:**
- Describing technical processing instead of business behavior
- For L1, describing the entire process instead of just the behavior being changed
- Including "how the program works" instead of "what the business sees"
- Omitting this section for enhancements (it is REQUIRED at L2/L3)

**Included at:** L1 CONDITIONAL | L2 REQUIRED | L3 REQUIRED

---

## Future Process / Desired Behavior

**Contains:**
- How the process will work after the change, as visible to the business
- What the user or operator will see differently
- What business outcomes will change
- For enhancements: clear distinction between what changes and what stays the same
- For new functions: complete desired behavior end to end

**Does NOT contain:**
- Program structure, module responsibility, or processing stages
- Technical data flow between objects
- Implementation approach or design choices

**Common mistakes:**
- Describing the technical solution instead of the business behavior
- Failing to clearly distinguish changes from unchanged behavior in enhancements
- Including implementation language ("the program will read the file and check...")
- Being too vague — this is the core of the spec and must be specific

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Functional Requirements

**Contains:**
- Numbered FR-nn entries describing what capabilities the system must provide
- Each FR states a function — something the system must DO
- For enhancements: tagged (NEW), (MODIFIED), or (EXISTING -- context only)

**Does NOT contain:**
- Business rules or constraints (those go in Business Rules)
- Implementation details or technical specifications
- Duplicated content from Business Rules

**Common mistakes:**
- Confusing FRs with BRs: "The system must validate credit limits" is an FR; "Orders exceeding the credit limit must be rejected" is a BR
- Including both the function and its governing rule in the same FR entry
- Listing technical capabilities ("read CUSTMAST file") instead of business capabilities ("look up customer information")
- Omitting tags on enhancement specs

**FR vs BR distinction:**
- FR = function: what the system must do
- BR = constraint: the rule that governs how the function behaves

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Business Rules

**Contains:**
- Numbered BR-xx entries stating business constraints, policies, or decision criteria
- Rules stated in business language
- For enhancements: tagged (NEW), (MODIFIED) with old and new rule stated, or (EXISTING -- context only)
- BR-xx numbers that carry forward into Technical Design and Program Spec

**Does NOT contain:**
- Implementation conditions (IF ORDAMT > CRDLMT THEN reject)
- Technical field names or program logic
- Capabilities or functions (those go in Functional Requirements)

**Common mistakes:**
- Writing rules in implementation language instead of business language
- Duplicating FR content as a BR or vice versa
- Including every existing rule in an enhancement spec — only include EXISTING rules needed to understand NEW or MODIFIED rules
- Non-atomic rules (combining multiple conditions into one BR)

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Functional Inputs / Outputs

**Contains:**
- Inputs table: what information enters the process, where it comes from, business meaning
- Outputs table: what information or outcomes the process produces, where they go, business meaning
- Sources and destinations described at business level (user, upstream process, report, etc.)

**Does NOT contain:**
- Field names, data types, parameter contracts, or file-level detail
- Technical interface specifications
- Record layouts or data structures

**Common mistakes:**
- Listing field names instead of business-level input descriptions
- Including parameter types and lengths (those belong in Program Spec)
- Describing internal data flows instead of business-visible inputs/outputs

**Included at:** L1 CONDITIONAL | L2 REQUIRED | L3 REQUIRED

---

## User / Role / Trigger Context

**Contains:**
- Actor table: who interacts with this process and what role they play
- Primary Trigger: what starts this process (user action, schedule, event)
- Frequency: how often the process runs or is triggered (if known)

**Does NOT contain:**
- Technical trigger mechanisms (job scheduler entries, data queue monitors)
- Program call chains or menu option numbers
- User profile or authority details

**Common mistakes:**
- Describing technical triggers instead of business triggers ("nightly batch job" is fine; "SBMJOB CMD(CALL PGM(ORDVAL))" is not)
- Omitting the frequency when it is relevant to capacity or business planning
- Including system accounts as actors instead of business roles

**Included at:** L1 OPTIONAL | L2 CONDITIONAL | L3 REQUIRED

---

## Exception Scenarios

**Contains:**
- Numbered exception entries (E-nn) describing what goes wrong in business terms
- Business Outcome: what should happen when the exception occurs (user message, process halt, notification)
- Severity classification (Critical / High / Medium / Low)
- Only scenarios visible to users, operators, or business stakeholders

**Does NOT contain:**
- Internal technical failures (file locks, system errors, job abends)
- Return codes, error handling strategies, or logging details
- Implementation-level error descriptions

**Common mistakes:**
- Including technical exceptions ("file lock timeout", "program returns error code 9")
- Describing internal error handling instead of business-visible outcomes
- Omitting severity classification
- Confusing exception scenarios with error handling (error handling belongs in Technical Design/Program Spec)

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Acceptance Criteria

**Contains:**
- Numbered criteria (AC-nn) in Given/When/Then format
- Each criterion validates a specific BR-xx or FR-nn
- Business-testable conditions verifiable through observable behavior
- Every NEW and MODIFIED FR and BR covered by at least one criterion

**Does NOT contain:**
- Implementation-level test cases (field values, return codes, program calls)
- Technical verification steps
- Test data specifications

**Common mistakes:**
- Writing implementation-level criteria ("Given CRDLMT = 5000, when ORDVAL is called, then RETCODE = 1")
- Failing to cover every NEW and MODIFIED rule with at least one criterion
- Including criteria for EXISTING items that are not affected by the change
- Omitting the Validates column linking back to BR-xx or FR-nn

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Upstream / Downstream Business Dependencies

**Contains:**
- Upstream table: processes, systems, or inputs that must be in place for this function to work
- Downstream table: processes, systems, or outputs that depend on this function
- Dependencies described at business/process level

**Does NOT contain:**
- Program call chains, file dependencies, or object interaction maps
- Technical interface specifications
- Deployment or compilation dependencies

**Common mistakes:**
- Listing program-level dependencies instead of business process dependencies
- Describing file or data queue dependencies (those belong in Technical Design)
- Omitting downstream dependencies that are affected by the change

**Included at:** L1 CONDITIONAL | L2 REQUIRED | L3 REQUIRED

---

## Assumptions / Constraints

**Contains:**
- Assumptions: things that, if false, would change the functional requirements
- Constraints: business constraints, regulatory requirements, timeline constraints, or process limitations

**Does NOT contain:**
- Technical assumptions (system capacity, library list configuration)
- Implementation constraints (available RPG features, compiler version)
- Design decisions

**Common mistakes:**
- Listing technical assumptions instead of business assumptions
- Confusing assumptions with requirements (if it must be true, it is a requirement or constraint, not an assumption)
- Omitting regulatory or compliance constraints that affect behavior

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Open Questions / TBD

**Contains:**
- Numbered entries with Section, Question, Source, and Status
- Every TBD in the document must have a corresponding entry
- Every (Inferred) element that needs confirmation
- Source: where the question originated (Requirement, Business, Dependency)

**Does NOT contain:**
- Technical design questions (those belong in Technical Design open questions)
- Resolved items without status update
- Implementation questions

**Common mistakes:**
- Having TBDs in the document body without corresponding Open Questions entries
- Including questions that are answerable from the requirement (read more carefully)
- Omitting the Source column, making it unclear who needs to answer

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED

---

## Functional Summary

**Contains:**
- Document Level, Change Type, Target Platform
- Count of Functional Requirements (total, new, modified)
- Count of Business Rules (total, new, modified)
- Count of Exception Scenarios
- Count of Acceptance Criteria
- Count of Open Questions
- Business Review Ready indicator (Yes/No with blockers if No)

**Does NOT contain:**
- Technical metrics (file count, program count, lines of code)
- Implementation estimates
- Design complexity indicators

**Common mistakes:**
- Counts that do not match the actual document content
- Omitting the new/modified breakdown for enhancement specs
- Marking "Business Review Ready: Yes" when there are critical open questions

**Included at:** L1 REQUIRED | L2 REQUIRED | L3 REQUIRED
