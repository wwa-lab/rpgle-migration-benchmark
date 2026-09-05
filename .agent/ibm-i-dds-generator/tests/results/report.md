# DDS Generator Test Report

- **Date**: 2026-04-04 21:53:05
- **Model**: sonnet
- **Total**: 31
- **Passed**: 0
- **Failed**: 0
- **Errors**: 31

## Results by Source Type

| Type | Total | Passed | Failed |
|------|-------|--------|--------|
| PF | 13 | 0 | 13 |
| LF | 10 | 0 | 10 |
| PRTF | 3 | 0 | 3 |
| DSPF | 5 | 0 | 5 |

## Detailed Results

### PF Tests

| TC | Description | Category | Verdict | Details |
|----|-------------|----------|---------|---------|
| tc-01 | Full CUSTMAST PF (all keywords) | happy | PASS |  |
| tc-02 | Minimal valid PF | happy | PASS |  |
| tc-03 | All nine field types | happy | FAIL |   MISSING: '9P 2';  MISSING: '7S 0';  MISSING: '9B 0';  MISSING: '10I 0'; |
| tc-04 | Multiple keys, non-unique | happy | PASS |  |
| tc-05 | Keyword stacking (ALWNULL+DFT+CCSID) | happy | FAIL |   MISSING: '9P 2';  MISSING: 'COLHDG('GEN' 'NOTES')'; |
| tc-06 | CCSID keyword | happy | PASS |  |
| tc-07 | No key definition | happy | PASS |  |
| tc-08 | Long TEXT truncation | happy | PASS |  |
| tc-09 | TBD field name | happy | FAIL |   MISSING: '7P 2'; |
| tc-11 | Reject missing fieldName | rejection | PASS |  |
| tc-12 | Reject missing decimals on P | rejection | PASS |  |
| tc-13 | Anti-hallucination: exact field count | happy | PASS |  |
| tc-29 | PF version file (same format, diff key) | happy | PASS |  |

### LF Tests

| TC | Description | Category | Verdict | Details |
|----|-------------|----------|---------|---------|
| tc-10 | Reject LF missing basedOnPhysicalFiles | rejection | PASS |  |
| tc-14 | Simple LF rekey (all fields inherited) | happy | FAIL |   UNEXPECTED: 'UNIQUE' found in output; |
| tc-15 | LF with select/omit (COMP EQ) | happy | PASS |  |
| tc-16 | LF with multiple select/omit + ALL | happy | PASS |  |
| tc-17 | LF with field rename (RENAME keyword) | happy | PASS |  |
| tc-18 | Join LF (JFILE/JOIN/JFLD/JREF) | happy | PASS |  |
| tc-19 | Join LF outer (JDFTVAL) | happy | FAIL |   MISSING: 'JOIN(1 2)'; |
| tc-20 | LF with DESCEND key | happy | PASS |  |
| tc-21 | LF version file | happy | PASS |  |
| tc-30 | Reject LF missing basedOnPhysicalFiles | rejection | PASS |  |

### PRTF Tests

| TC | Description | Category | Verdict | Details |
|----|-------------|----------|---------|---------|
| tc-22 | Simple PRTF (header + detail) | happy | PASS |  |
| tc-23 | PRTF with edit codes | happy | N/A |  |
| tc-24 | PRTF with spacing (SPACEB) | happy | N/A |  |

### DSPF Tests

| TC | Description | Category | Verdict | Details |
|----|-------------|----------|---------|---------|
| tc-25 | Simple DSPF (no subfile, CA/CF) | happy | PASS |  |
| tc-26 | DSPF with subfile (SFL/SFLCTL) | happy | PASS |  |
| tc-27 | DSPF with CHECK/ERRMSG validation | happy | PASS |  |
| tc-28 | DSPF with conditioning indicators | happy | N/A |  |
| tc-31 | Reject DSPF missing row/col | rejection | N/A |  |


## Files

Actual outputs saved in `results/tc-XX-actual.txt`.
Verdict details in `results/tc-XX-verdict.txt`.

## How to Re-run

```bash
# All tests
./runner.sh

# By source type
./runner.sh --type PF
./runner.sh --type LF
./runner.sh --type PRTF
./runner.sh --type DSPF

# List all tests with types
./runner.sh --list

# Specific failing tests
./runner.sh tc-01 tc-14

# With verbose output
./runner.sh --type LF --verbose

# Different model
./runner.sh --model opus
```
