# Code Generator Test Report

- **Date**: 2026-04-04 21:29:53
- **Model**: sonnet
- **Total**: 8
- **Passed**: 0
- **Failed**: 0
- **Errors**: 8

## Results

| TC | Layer | Description | Verdict | Details |
|----|-------|-------------|---------|---------|
| tc-cg-01 | L1 | L1: New batch RPGLE (free format) | N/A |  |
| tc-cg-02 | L1 | L1: 1:N access — SETLL/READE required | N/A |  |
| tc-cg-03 | L1 | L1: New CLLE program structure | N/A |  |
| tc-cg-04 | L1 | L1: TBD spec — Skeleton mode | N/A |  |
| tc-cg-05 | L1 | L1: Embedded SQL — EXEC SQL blocks | N/A |  |
| tc-cg-06 | L2 | L2: Pipeline — generate then review | N/A |  |
| tc-cg-07 | L3 | L3: Enhancement with existing source | N/A |  |
| tc-cg-08 | L3 | L3: Enhancement without source | N/A |  |

## Test Layers

- **Layer 1** — Structural validation: pattern checks on generated RPGLE/CLLE
- **Layer 2** — Pipeline: generate code then review with ibm-i-code-reviewer
- **Layer 3** — Enhancement regression: delta output, format policy, safety

## How to Re-run

```bash
./runner.sh                    # All tests
./runner.sh --layer 1          # Layer 1 only (structural)
./runner.sh --layer 3          # Layer 3 only (enhancement)
./runner.sh tc-cg-02           # Single test (1:N access pattern)
./runner.sh --verbose          # Show failure details
./runner.sh --model opus       # Different model
```
