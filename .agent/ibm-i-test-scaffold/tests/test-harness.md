# Test Scaffold Generator Test Harness (V1.0)

This document defines a lightweight structural test harness for the
`ibm-i-test-scaffold` skill.

The goal is not to execute SQL or CL on a real IBM i partition. Instead, the harness
checks whether the generated scaffold:

- emits the expected six-artifact structure
- uses IBM i-specific compile and execution patterns
- generates SQL verification with explicit PASS/FAIL logic
- preserves anti-hallucination behavior (`TBD`, `(Inferred)`, explicit prerequisites)

## How to Run

**Manual**: Invoke `ibm-i-test-scaffold` with each case input and compare the output
to the listed checks.

**Semi-automated**: Run `tests/runner.sh`. The runner feeds each case to the skill via
`claude -p`, captures the raw scaffold, and validates it against `must_contain`,
`must_not_contain`, regex, and artifact-count rules.

---

## Test Case Index

| ID | Category | Description | Key Feature Tested |
|----|----------|-------------|--------------------|
| TC-TS-01 | happy | Batch RPGLE close-order scaffold | Full six-artifact flow, `CRTBNDRPG`, `CALL`, SQL PASS/FAIL |
| TC-TS-02 | interactive | Interactive RPGLE order-entry scaffold | Manual execution guide, automated setup + verification |
| TC-TS-03 | cl | CL wrapper billing extract scaffold | `CRTBNDCL`, `SBMJOB`, CL side-effect verification |
| TC-TS-04 | service | Service program scaffold | `CRTRPGMOD` + `CRTSRVPGM`, caller-stub guidance |
| TC-TS-05 | secondary | Program Spec + test scenarios input | Secondary input path, inferred compile/data decisions |
| TC-TS-06 | edge | Missing-library / TBD scaffold | Honest placeholders, open questions, no hallucinated names |

---

## Check File Format

Each `cases/tc-ts-XX-checks.txt` file supports:

- `category=<name>` — used for filtering
- `artifact_count=<n>` — number of required artifact headings
- `must_contain=<text>` — output must contain literal text
- `must_not_contain=<text>` — output must not contain literal text
- `must_contain_regex=<pattern>` — output must match regex
- `must_not_contain_regex=<pattern>` — output must not match regex

---

## Expected Output Shape

Every happy-path scaffold should contain, in order:

1. `## Artifact 1: Environment Setup (CL)`
2. `## Artifact 2: Compile (CL)`
3. `## Artifact 3: Test Data Setup (SQL)`
4. `## Artifact 4: Test Execution`
5. `## Artifact 5: Result Verification (SQL)`
6. `## Artifact 6: Cleanup (SQL)`

The harness intentionally validates shape and IBM i idioms rather than exact full text.
This keeps the tests stable while still detecting regressions in structure and platform fit.
