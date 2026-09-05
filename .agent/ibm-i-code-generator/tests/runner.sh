#!/usr/bin/env bash
# Local adaptation: remove legacy home-directory fallback; explicit CLI and PATH lookup remain.
# ============================================================================
# Code Generator Test Runner (Semi-Automated)
#
# Uses `claude -p` to invoke the ibm-i-code-generator skill for each test case,
# captures output, and validates against check rules.
#
# Supports 3 layers:
#   Layer 1 — Structural validation (pattern checks on generated RPGLE/CLLE)
#   Layer 2 — Two-stage pipeline (generate → review with ibm-i-code-reviewer)
#   Layer 3 — Enhancement regression (delta output, format policy, safety)
#
# Usage:
#   ./runner.sh                    # Run all 8 test cases
#   ./runner.sh tc-cg-01 tc-cg-02  # Run specific test cases
#   ./runner.sh --layer 1          # Run only Layer 1 tests
#   ./runner.sh --layer 3          # Run only Layer 3 (enhancement) tests
#   ./runner.sh --dry-run          # Show what would run without executing
#   ./runner.sh --model sonnet     # Use a specific model (default: sonnet)
#   ./runner.sh --verbose          # Show detailed failure output
#
# Output:
#   results/tc-cg-XX-actual.txt    — Raw claude output per test
#   results/tc-cg-XX-stage1.txt   — Stage 1 output (Layer 2 pipeline tests only)
#   results/tc-cg-XX-verdict.txt  — PASS / FAIL / PARTIAL with details
#   results/report.md              — Summary report
# ============================================================================

set -euo pipefail

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CASES_DIR="${SCRIPT_DIR}/cases"
RESULTS_DIR="${SCRIPT_DIR}/results"
MODEL="${CG_TEST_MODEL:-sonnet}"
DRY_RUN=false
VERBOSE=false
FILTER_LAYER=""

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Locate claude CLI ---
CLAUDE_BIN="${CLAUDE_BIN:-$(command -v claude 2>/dev/null || echo "")}"
if [[ -z "$CLAUDE_BIN" ]]; then
  for candidate in \
    "/Applications/cmux.app/Contents/Resources/bin/claude" \
    "/usr/local/bin/claude" \
    ; do
    if [[ -x "$candidate" ]]; then
      CLAUDE_BIN="$candidate"
      break
    fi
  done
fi
if [[ -z "$CLAUDE_BIN" ]]; then
  echo "ERROR: claude CLI not found. Set CLAUDE_BIN=/path/to/claude or add claude to PATH."
  exit 1
fi

# --- Parse arguments ---
SELECTED_CASES=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)   DRY_RUN=true; shift ;;
    --verbose)   VERBOSE=true; shift ;;
    --model)     MODEL="$2"; shift 2 ;;
    --layer)     FILTER_LAYER="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: $0 [--dry-run] [--verbose] [--model MODEL] [--layer 1|2|3] [tc-cg-01 ...]"
      exit 0
      ;;
    tc-cg-*)     SELECTED_CASES+=("$1"); shift ;;
    *)           echo "Unknown option: $1"; exit 1 ;;
  esac
done

# --- Discover test cases ---
ALL_CASES=()
for f in "${CASES_DIR}"/tc-cg-*-input.md; do
  tc_id=$(basename "$f" | sed 's/-input\.md//')
  ALL_CASES+=("$tc_id")
done

# --- Descriptions ---
get_desc() {
  case "$1" in
    tc-cg-01) echo "L1: New batch RPGLE (free format)" ;;
    tc-cg-02) echo "L1: 1:N access — SETLL/READE required" ;;
    tc-cg-03) echo "L1: New CLLE program structure" ;;
    tc-cg-04) echo "L1: TBD spec — Skeleton mode" ;;
    tc-cg-05) echo "L1: Embedded SQL — EXEC SQL blocks" ;;
    tc-cg-06) echo "L2: Pipeline — generate then review" ;;
    tc-cg-07) echo "L3: Enhancement with existing source" ;;
    tc-cg-08) echo "L3: Enhancement without source" ;;
    *)        echo "unknown" ;;
  esac
}

get_layer() {
  local checks_file="${CASES_DIR}/${1}-checks.txt"
  grep '^layer=' "$checks_file" 2>/dev/null | head -1 | cut -d= -f2
}

# --- Apply filters ---
CASES=()
if [[ ${#SELECTED_CASES[@]} -gt 0 ]]; then
  CASES=("${SELECTED_CASES[@]}")
else
  for tc_id in "${ALL_CASES[@]}"; do
    if [[ -n "$FILTER_LAYER" ]]; then
      tc_layer=$(get_layer "$tc_id")
      if [[ "$tc_layer" != "$FILTER_LAYER" ]]; then
        continue
      fi
    fi
    CASES+=("$tc_id")
  done
fi

# --- Setup results dir ---
mkdir -p "${RESULTS_DIR}"

# --- Build prompt for code generation (Layer 1 and Layer 3) ---
build_generate_prompt() {
  local spec_file="$1"
  local existing_file="$2"
  local spec_content
  spec_content=$(cat "$spec_file")

  local change_type="New Program"
  if [[ -n "$existing_file" && -f "$existing_file" ]]; then
    change_type="Change to Existing"
  fi

  local prompt="You are the ibm-i-code-generator skill. Generate source code from the following Program Spec.

Follow the skill rules exactly:
- Output language must match the Programming Language section.
- For new RPGLE programs, use free format.
- For changes to existing RPGLE programs, use fixed format.
- If TBDs affect interfaces, file names, or core logic, downgrade to Skeleton with TODO markers.
- For enhancements, default to minimal delta (change block), not full-member regeneration.
- Output the pre-code notes and source code. No additional explanation beyond what the skill output structure requires.

Change Type: ${change_type}"

  if [[ -n "$existing_file" && -f "$existing_file" ]]; then
    local existing_content
    existing_content=$(cat "$existing_file")
    prompt="${prompt}

Existing Source:

\`\`\`rpgle
${existing_content}
\`\`\`"
  fi

  prompt="${prompt}

Program Spec:

${spec_content}"

  echo "$prompt"
}

# --- Build prompt for code review (Layer 2 Stage 2) ---
build_review_prompt() {
  local spec_file="$1"
  local code_file="$2"
  local spec_content
  spec_content=$(cat "$spec_file")
  local code_content
  code_content=$(cat "$code_file")

  cat <<PROMPT
You are the ibm-i-code-reviewer skill. Review the following source code against the controlling Program Spec.

Follow the skill rules exactly:
- Produce a structured review report.
- Include a Readiness Decision.
- Do not rewrite or replace the code.

Program Spec:

${spec_content}

Code to Review:

${code_content}
PROMPT
}

# --- Validate output against check rules ---
validate_output() {
  local tc_id="$1"
  local output_file="$2"
  local checks_file="${CASES_DIR}/${tc_id}-checks.txt"
  local pass=true
  local failures=()

  if [[ ! -f "$checks_file" ]]; then
    echo "SKIP (no checks file)"
    return 2
  fi

  local output
  output=$(cat "$output_file")

  while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
    [[ "$line" =~ ^(layer|lang|change_type|type)= ]] && continue

    local rule value
    rule=$(echo "$line" | cut -d= -f1)
    value=$(echo "$line" | cut -d= -f2-)

    case "$rule" in
      must_contain)
        if ! echo "$output" | grep -qiF "$value"; then
          pass=false
          failures+=("MISSING: '$value'")
        fi
        ;;
      must_not_contain)
        if echo "$output" | grep -qiF "$value"; then
          pass=false
          failures+=("UNEXPECTED: '$value' found in output")
        fi
        ;;
      must_contain_regex)
        if ! echo "$output" | grep -qiE "$value"; then
          pass=false
          failures+=("MISSING_REGEX: '$value'")
        fi
        ;;
      must_not_contain_regex)
        if echo "$output" | grep -qiE "$value"; then
          pass=false
          failures+=("UNEXPECTED_REGEX: '$value' matched in output")
        fi
        ;;
    esac
  done < "$checks_file"

  local verdict_file="${RESULTS_DIR}/${tc_id}-verdict.txt"
  if $pass; then
    echo "PASS" > "$verdict_file"
    echo "PASS"
  else
    echo "FAIL" > "$verdict_file"
    for f in "${failures[@]}"; do
      echo "  $f" >> "$verdict_file"
    done
    echo "FAIL"
    if $VERBOSE; then
      for f in "${failures[@]}"; do
        echo -e "  ${RED}$f${NC}"
      done
    fi
  fi
}

# --- Main execution ---
echo ""
echo "========================================"
echo " Code Generator Test Runner"
echo " Claude: ${CLAUDE_BIN}"
echo " Model: ${MODEL}"
echo " Cases: ${#CASES[@]} of ${#ALL_CASES[@]}"
if [[ -n "$FILTER_LAYER" ]]; then
  echo " Filter: Layer ${FILTER_LAYER}"
fi
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"
echo ""

if $DRY_RUN; then
  echo "[DRY RUN MODE — no tests will execute]"
  echo ""
  for tc_id in "${CASES[@]}"; do
    desc=$(get_desc "$tc_id")
    layer=$(get_layer "$tc_id")
    existing="${CASES_DIR}/${tc_id}-existing.rpgle"
    has_existing="no"
    [[ -f "$existing" ]] && has_existing="yes"
    echo "  ${tc_id}: ${desc}"
    echo "    Layer: ${layer}  Existing source: ${has_existing}"
  done
  exit 0
fi

# Counters
total=${#CASES[@]}
passed=0
failed=0
errors=0

# --- Run each test case ---
for tc_id in "${CASES[@]}"; do
  desc=$(get_desc "$tc_id")
  layer=$(get_layer "$tc_id")
  input_file="${CASES_DIR}/${tc_id}-input.md"
  existing_file="${CASES_DIR}/${tc_id}-existing.rpgle"
  output_file="${RESULTS_DIR}/${tc_id}-actual.txt"

  printf "%-12s %-45s " "${tc_id}" "${desc}"

  if [[ ! -f "$input_file" ]]; then
    echo -e "${YELLOW}SKIP${NC} (input file missing)"
    continue
  fi

  if [[ "$layer" == "2" ]]; then
    # --- Layer 2: Two-stage pipeline ---
    stage1_file="${RESULTS_DIR}/${tc_id}-stage1.txt"

    # Stage 1: Generate code
    prompt=$(build_generate_prompt "$input_file" "")
    set +e
    stage1_output=$(echo "$prompt" | "$CLAUDE_BIN" -p --model "$MODEL" 2>/dev/null)
    exit_code=$?
    set -e

    if [[ $exit_code -ne 0 ]]; then
      echo -e "${RED}ERROR${NC} (Stage 1 claude exit: ${exit_code})"
      echo "ERROR: Stage 1 exit code ${exit_code}" > "$output_file"
      ((errors++))
      continue
    fi
    echo "$stage1_output" > "$stage1_file"

    # Stage 2: Review the generated code
    review_prompt=$(build_review_prompt "$input_file" "$stage1_file")
    set +e
    review_output=$(echo "$review_prompt" | "$CLAUDE_BIN" -p --model "$MODEL" 2>/dev/null)
    exit_code=$?
    set -e

    if [[ $exit_code -ne 0 ]]; then
      echo -e "${RED}ERROR${NC} (Stage 2 claude exit: ${exit_code})"
      echo "ERROR: Stage 2 exit code ${exit_code}" > "$output_file"
      ((errors++))
      continue
    fi
    echo "$review_output" > "$output_file"

  else
    # --- Layer 1 and Layer 3: Single-stage generation ---
    existing_arg=""
    [[ -f "$existing_file" ]] && existing_arg="$existing_file"

    prompt=$(build_generate_prompt "$input_file" "$existing_arg")
    set +e
    actual_output=$(echo "$prompt" | "$CLAUDE_BIN" -p --model "$MODEL" 2>/dev/null)
    exit_code=$?
    set -e

    if [[ $exit_code -ne 0 ]]; then
      echo -e "${RED}ERROR${NC} (claude exit: ${exit_code})"
      echo "ERROR: claude exit code ${exit_code}" > "$output_file"
      ((errors++))
      continue
    fi
    echo "$actual_output" > "$output_file"
  fi

  # Validate
  verdict=$(validate_output "$tc_id" "$output_file")

  case "$verdict" in
    PASS)    echo -e "${GREEN}PASS${NC}"; ((passed++)) ;;
    FAIL)    echo -e "${YELLOW}FAIL${NC}"; ((failed++)) ;;
    SKIP*)   echo -e "${YELLOW}${verdict}${NC}" ;;
    *)       echo -e "${YELLOW}${verdict}${NC}" ;;
  esac
done

# --- Generate report ---
report_file="${RESULTS_DIR}/report.md"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
cat > "$report_file" <<REPORT
# Code Generator Test Report

- **Date**: ${timestamp}
- **Model**: ${MODEL}
- **Total**: ${total}
- **Passed**: ${passed}
- **Failed**: ${failed}
- **Errors**: ${errors}

## Results

| TC | Layer | Description | Verdict | Details |
|----|-------|-------------|---------|---------|
REPORT

for tc_id in "${CASES[@]}"; do
  desc=$(get_desc "$tc_id")
  layer=$(get_layer "$tc_id")
  verdict_file="${RESULTS_DIR}/${tc_id}-verdict.txt"
  if [[ -f "$verdict_file" ]]; then
    verdict=$(head -1 "$verdict_file")
    details=$(tail -n +2 "$verdict_file" | tr '\n' '; ' | sed 's/; $//')
  else
    verdict="N/A"
    details=""
  fi
  echo "| ${tc_id} | L${layer} | ${desc} | ${verdict} | ${details} |" >> "$report_file"
done

cat >> "$report_file" <<REPORT

## Test Layers

- **Layer 1** — Structural validation: pattern checks on generated RPGLE/CLLE
- **Layer 2** — Pipeline: generate code then review with ibm-i-code-reviewer
- **Layer 3** — Enhancement regression: delta output, format policy, safety

## How to Re-run

\`\`\`bash
./runner.sh                    # All tests
./runner.sh --layer 1          # Layer 1 only (structural)
./runner.sh --layer 3          # Layer 3 only (enhancement)
./runner.sh tc-cg-02           # Single test (1:N access pattern)
./runner.sh --verbose          # Show failure details
./runner.sh --model opus       # Different model
\`\`\`
REPORT

# --- Summary ---
echo ""
echo "========================================"
echo " Results: ${passed} PASS / ${failed} FAIL / ${errors} ERROR"
echo " Report:  ${report_file}"
echo "========================================"
echo ""

if [[ $failed -gt 0 || $errors -gt 0 ]]; then
  exit 1
fi
