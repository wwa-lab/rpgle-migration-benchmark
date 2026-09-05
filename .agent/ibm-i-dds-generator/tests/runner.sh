#!/usr/bin/env bash
# Local adaptation: remove legacy home-directory fallback; explicit CLI and PATH lookup remain.
# ============================================================================
# DDS Generator Test Runner V2.0 (Semi-Automated)
#
# Uses `claude -p` to invoke the ibm-i-dds-generator skill for each test case,
# captures output, and validates against check rules.
#
# Usage:
#   ./runner.sh                       # Run all test cases
#   ./runner.sh --type PF             # Run only PF test cases
#   ./runner.sh --type LF             # Run only LF test cases
#   ./runner.sh --type PRTF           # Run only PRTF test cases
#   ./runner.sh --type DSPF           # Run only DSPF test cases
#   ./runner.sh tc-01 tc-05           # Run specific test cases
#   ./runner.sh --dry-run             # Show what would run without executing
#   ./runner.sh --dry-run --type LF   # Preview LF tests only
#   ./runner.sh --model sonnet        # Use a specific model (default: sonnet)
#   ./runner.sh --list                # List all test cases with types
#
# Prerequisites:
#   - `claude` CLI installed and authenticated
#   - Run from the tests/ directory or pass TESTS_DIR
#
# Test Case Naming Convention:
#   cases/tc-XX-input.json   — Input JSON
#   cases/tc-XX-checks.txt   — Validation checks (must include source_type= tag)
#
# Check File Format:
#   source_type=PF|LF|PRTF|DSPF    — File type (REQUIRED, used for --type filtering)
#   type=happy|rejection|edge       — Test category
#   must_contain=<text>             — Output must contain this string
#   must_not_contain=<text>         — Output must NOT contain this string
#   field_count=<n>                 — Output must have exactly n field definitions
#
# Output:
#   results/tc-XX-actual.txt     — Raw claude output per test
#   results/tc-XX-verdict.txt    — PASS / FAIL / PARTIAL with details
#   results/report.md            — Summary report (grouped by source type)
# ============================================================================

set -uo pipefail
# Note: NOT using set -e — we handle errors explicitly per test case

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CASES_DIR="${SCRIPT_DIR}/cases"
RESULTS_DIR="${SCRIPT_DIR}/results"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
MODEL="${DDS_TEST_MODEL:-sonnet}"
DRY_RUN=false
VERBOSE=false
LIST_ONLY=false
FILTER_TYPE=""  # PF, LF, PRTF, DSPF, or empty for all
TIMEOUT=120  # seconds per test case

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
if [[ -z "$CLAUDE_BIN" && "$LIST_ONLY" == "false" && "$DRY_RUN" == "false" ]]; then
  echo "ERROR: claude CLI not found. Set CLAUDE_BIN=/path/to/claude or add claude to PATH."
  exit 1
fi

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# --- Parse arguments ---
SELECTED_CASES=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)   DRY_RUN=true; shift ;;
    --verbose)   VERBOSE=true; shift ;;
    --list)      LIST_ONLY=true; shift ;;
    --model)     MODEL="$2"; shift 2 ;;
    --type)
      FILTER_TYPE=$(echo "$2" | tr '[:lower:]' '[:upper:]')
      if [[ ! "$FILTER_TYPE" =~ ^(PF|LF|PRTF|DSPF)$ ]]; then
        echo "ERROR: --type must be PF, LF, PRTF, or DSPF (got: $2)"
        exit 1
      fi
      shift 2
      ;;
    --help|-h)
      echo "Usage: $0 [OPTIONS] [tc-01 tc-02 ...]"
      echo ""
      echo "Options:"
      echo "  --type TYPE   Filter by source type: PF, LF, PRTF, DSPF"
      echo "  --dry-run     Show what would run without executing"
      echo "  --verbose     Show detailed output during execution"
      echo "  --list        List all test cases with types (no execution)"
      echo "  --model NAME  Claude model to use (default: sonnet)"
      echo "  tc-XX         Run only specific test cases"
      echo ""
      echo "Examples:"
      echo "  $0 --type PF              # Run all PF tests"
      echo "  $0 --type LF --verbose    # Run LF tests with detail"
      echo "  $0 --type DSPF --dry-run  # Preview DSPF tests"
      echo "  $0 tc-01 tc-14            # Run specific tests"
      exit 0
      ;;
    tc-*)        SELECTED_CASES+=("$1"); shift ;;
    *)           echo "Unknown option: $1"; exit 1 ;;
  esac
done

# --- Get source type from checks file ---
get_source_type() {
  local tc_id="$1"
  local checks_file="${CASES_DIR}/${tc_id}-checks.txt"
  if [[ -f "$checks_file" ]]; then
    local st
    st=$(grep '^source_type=' "$checks_file" 2>/dev/null | head -1 | cut -d= -f2)
    if [[ -n "$st" ]]; then
      echo "$st"
      return
    fi
  fi
  echo "PF"  # Default for legacy tests without source_type tag
}

# --- Get test category from checks file ---
get_test_category() {
  local tc_id="$1"
  local checks_file="${CASES_DIR}/${tc_id}-checks.txt"
  if [[ -f "$checks_file" ]]; then
    grep '^type=' "$checks_file" 2>/dev/null | head -1 | cut -d= -f2
  else
    echo "unknown"
  fi
}

# --- Descriptions ---
get_desc() {
  case "$1" in
    # PF tests (existing)
    tc-01) echo "Full CUSTMAST PF (all keywords)" ;;
    tc-02) echo "Minimal valid PF" ;;
    tc-03) echo "All nine field types" ;;
    tc-04) echo "Multiple keys, non-unique" ;;
    tc-05) echo "Keyword stacking (ALWNULL+DFT+CCSID)" ;;
    tc-06) echo "CCSID keyword" ;;
    tc-07) echo "No key definition" ;;
    tc-08) echo "Long TEXT truncation" ;;
    tc-09) echo "TBD field name" ;;
    tc-10) echo "Reject LF missing basedOnPhysicalFiles" ;;
    tc-11) echo "Reject missing fieldName" ;;
    tc-12) echo "Reject missing decimals on P" ;;
    tc-13) echo "Anti-hallucination: exact field count" ;;
    # LF tests
    tc-14) echo "Simple LF rekey (all fields inherited)" ;;
    tc-15) echo "LF with select/omit (COMP EQ)" ;;
    tc-16) echo "LF with multiple select/omit + ALL" ;;
    tc-17) echo "LF with field rename (RENAME keyword)" ;;
    tc-18) echo "Join LF (JFILE/JOIN/JFLD/JREF)" ;;
    tc-19) echo "Join LF outer (JDFTVAL)" ;;
    tc-20) echo "LF with DESCEND key" ;;
    tc-21) echo "LF version file" ;;
    # PRTF tests
    tc-22) echo "Simple PRTF (header + detail)" ;;
    tc-23) echo "PRTF with edit codes" ;;
    tc-24) echo "PRTF with spacing (SPACEB)" ;;
    # DSPF tests
    tc-25) echo "Simple DSPF (no subfile, CA/CF)" ;;
    tc-26) echo "DSPF with subfile (SFL/SFLCTL)" ;;
    tc-27) echo "DSPF with CHECK/ERRMSG validation" ;;
    tc-28) echo "DSPF with conditioning indicators" ;;
    # Version file tests
    tc-29) echo "PF version file (same format, diff key)" ;;
    # Rejection tests
    tc-30) echo "Reject LF missing basedOnPhysicalFiles" ;;
    tc-31) echo "Reject DSPF missing row/col" ;;
    *)     echo "unknown" ;;
  esac
}

# --- Discover test cases ---
ALL_CASES=()
for f in "${CASES_DIR}"/tc-*-input.json; do
  [[ -f "$f" ]] || continue
  tc_id=$(basename "$f" | sed 's/-input\.json//')
  ALL_CASES+=("$tc_id")
done

# --- Apply filters ---
CASES=()
if [[ ${#SELECTED_CASES[@]} -gt 0 ]]; then
  # Specific test cases requested — apply type filter if also set
  for tc_id in "${SELECTED_CASES[@]}"; do
    if [[ -n "$FILTER_TYPE" ]]; then
      st=$(get_source_type "$tc_id")
      [[ "$st" == "$FILTER_TYPE" ]] && CASES+=("$tc_id")
    else
      CASES+=("$tc_id")
    fi
  done
elif [[ -n "$FILTER_TYPE" ]]; then
  # Filter all cases by type
  for tc_id in "${ALL_CASES[@]}"; do
    st=$(get_source_type "$tc_id")
    [[ "$st" == "$FILTER_TYPE" ]] && CASES+=("$tc_id")
  done
else
  CASES=("${ALL_CASES[@]}")
fi

# --- List mode ---
if $LIST_ONLY; then
  echo ""
  echo "DDS Generator Test Cases"
  echo "========================"
  echo ""
  printf "${BOLD}%-8s %-8s %-12s %-50s${NC}\n" "TC" "Type" "Category" "Description"
  printf "%-8s %-8s %-12s %-50s\n" "------" "------" "----------" "------------------------------------------------"
  for tc_id in "${ALL_CASES[@]}"; do
    st=$(get_source_type "$tc_id")
    cat=$(get_test_category "$tc_id")
    desc=$(get_desc "$tc_id")
    # Color by type
    case "$st" in
      PF)   color="$GREEN" ;;
      LF)   color="$BLUE" ;;
      PRTF) color="$YELLOW" ;;
      DSPF) color="$CYAN" ;;
      *)    color="$NC" ;;
    esac
    printf "%-8s ${color}%-8s${NC} %-12s %-50s\n" "$tc_id" "$st" "$cat" "$desc"
  done
  echo ""

  # Summary by type
  echo "Summary by type:"
  for t in PF LF PRTF DSPF; do
    count=0
    for tc_id in "${ALL_CASES[@]}"; do
      st=$(get_source_type "$tc_id")
      [[ "$st" == "$t" ]] && ((count++))
    done
    echo "  ${t}: ${count} tests"
  done
  echo "  Total: ${#ALL_CASES[@]} tests"
  exit 0
fi

# --- Check claude is available for execution ---
if [[ -z "$CLAUDE_BIN" ]]; then
  echo "ERROR: claude CLI not found. Set CLAUDE_BIN=/path/to/claude or add claude to PATH."
  exit 1
fi

# --- Setup results dir ---
mkdir -p "${RESULTS_DIR}"

# --- Build the prompt template ---
build_prompt() {
  local json_file="$1"
  local source_type="$2"
  local json_content
  json_content=$(cat "$json_file")

  cat <<PROMPT
You are the ibm-i-dds-generator skill (V2.0). Generate DDS source code from the following File Spec JSON.

Follow the skill rules exactly:
- Supported file types: PF, LF, PRTF, DSPF.
- If validation fails (missing fieldName, missing decimals on numeric type, missing PFILE on LF, missing row/col on DSPF), list the blockers. Do not generate partial DDS.
- If fieldName is "TBD", generate a TODO comment line.
- Output ONLY the DDS source code (or error message for rejections). No markdown fences, no explanation, no preamble.

Source type: ${source_type}

File Spec JSON:

${json_content}
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
    # Skip comments, empty lines, and metadata tags
    [[ "$line" =~ ^#.*$ || -z "$line" || "$line" =~ ^type= || "$line" =~ ^source_type= ]] && continue

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
      field_count)
        local actual_count
        actual_count=$(echo "$output" | grep -cE '^ {5}A {12}[A-Z@#$][A-Z0-9@#$_ ]{0,9}' || true)
        if [[ "$actual_count" -ne "$value" ]]; then
          pass=false
          failures+=("FIELD_COUNT: expected $value, got $actual_count")
        fi
        ;;
      must_contain_regex)
        if ! echo "$output" | grep -qE "$value"; then
          pass=false
          failures+=("REGEX_MISSING: pattern '$value'")
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
echo " DDS Generator Test Runner V2.0"
echo " Claude: ${CLAUDE_BIN}"
echo " Model: ${MODEL}"
if [[ -n "$FILTER_TYPE" ]]; then
  echo " Filter: ${FILTER_TYPE} only"
fi
echo " Cases: ${#CASES[@]} of ${#ALL_CASES[@]}"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"
echo ""

if [[ ${#CASES[@]} -eq 0 ]]; then
  echo "No test cases match the filter."
  echo "Use --list to see available tests, or --type PF|LF|PRTF|DSPF to filter."
  exit 0
fi

if $DRY_RUN; then
  echo "[DRY RUN MODE — no tests will execute]"
  echo ""
  current_type=""
  for tc_id in "${CASES[@]}"; do
    st=$(get_source_type "$tc_id")
    desc="$(get_desc "$tc_id")"
    # Print type header when type changes
    if [[ "$st" != "$current_type" ]]; then
      echo -e "\n${BOLD}--- ${st} Tests ---${NC}"
      current_type="$st"
    fi
    echo "  ${tc_id}: ${desc}"
    echo "    Input: ${CASES_DIR}/${tc_id}-input.json"
    echo "    Checks: ${CASES_DIR}/${tc_id}-checks.txt"
  done
  exit 0
fi

# --- Counters (total and per-type) ---
total=${#CASES[@]}
passed=0
failed=0
errors=0

declare_type_counters() {
  # Use simple variables since bash 3 has no associative arrays
  PF_TOTAL=0; PF_PASS=0; PF_FAIL=0
  LF_TOTAL=0; LF_PASS=0; LF_FAIL=0
  PRTF_TOTAL=0; PRTF_PASS=0; PRTF_FAIL=0
  DSPF_TOTAL=0; DSPF_PASS=0; DSPF_FAIL=0
}
declare_type_counters

inc_type_counter() {
  local st="$1" result="$2"
  case "$st" in
    PF)   PF_TOTAL=$((PF_TOTAL+1)); [[ "$result" == "PASS" ]] && PF_PASS=$((PF_PASS+1)); [[ "$result" == "FAIL" ]] && PF_FAIL=$((PF_FAIL+1)) ;;
    LF)   LF_TOTAL=$((LF_TOTAL+1)); [[ "$result" == "PASS" ]] && LF_PASS=$((LF_PASS+1)); [[ "$result" == "FAIL" ]] && LF_FAIL=$((LF_FAIL+1)) ;;
    PRTF) PRTF_TOTAL=$((PRTF_TOTAL+1)); [[ "$result" == "PASS" ]] && PRTF_PASS=$((PRTF_PASS+1)); [[ "$result" == "FAIL" ]] && PRTF_FAIL=$((PRTF_FAIL+1)) ;;
    DSPF) DSPF_TOTAL=$((DSPF_TOTAL+1)); [[ "$result" == "PASS" ]] && DSPF_PASS=$((DSPF_PASS+1)); [[ "$result" == "FAIL" ]] && DSPF_FAIL=$((DSPF_FAIL+1)) ;;
  esac
  return 0
}

# --- Run each test case ---
current_type=""
for tc_id in "${CASES[@]}"; do
  st=$(get_source_type "$tc_id")
  desc="$(get_desc "$tc_id")"
  input_file="${CASES_DIR}/${tc_id}-input.json"
  output_file="${RESULTS_DIR}/${tc_id}-actual.txt"

  # Print type header when type changes
  if [[ "$st" != "$current_type" ]]; then
    echo -e "\n${BOLD}--- ${st} Tests ---${NC}"
    current_type="$st"
  fi

  printf "  %-8s %-45s " "${tc_id}" "${desc}"

  if [[ ! -f "$input_file" ]]; then
    echo -e "${YELLOW}SKIP${NC} (input file missing)"
    continue
  fi

  prompt=$(build_prompt "$input_file" "$st")

  set +e
  actual_output=$(echo "$prompt" | "$CLAUDE_BIN" -p \
    --model "$MODEL" \
    2>/dev/null)
  exit_code=$?
  set -e

  if [[ $exit_code -ne 0 ]]; then
    echo -e "${RED}ERROR${NC} (claude exit code: ${exit_code})"
    echo "ERROR: claude exit code ${exit_code}" > "$output_file"
    errors=$((errors+1))
    inc_type_counter "$st" "FAIL"
    continue
  fi

  echo "$actual_output" > "$output_file"

  verdict=$(validate_output "$tc_id" "$output_file")

  case "$verdict" in
    PASS)    echo -e "${GREEN}PASS${NC}"; passed=$((passed+1)); inc_type_counter "$st" "PASS" ;;
    FAIL)    echo -e "${RED}FAIL${NC}"; failed=$((failed+1)); inc_type_counter "$st" "FAIL" ;;
    SKIP*)   echo -e "${YELLOW}${verdict}${NC}" ;;
    *)       echo -e "${YELLOW}${verdict}${NC}" ;;
  esac
done

# --- Generate report ---
report_file="${RESULTS_DIR}/report.md"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
filter_note=""
[[ -n "$FILTER_TYPE" ]] && filter_note=" (filtered: ${FILTER_TYPE} only)"

cat > "$report_file" <<REPORT
# DDS Generator Test Report

- **Date**: ${timestamp}
- **Model**: ${MODEL}
- **Total**: ${total}${filter_note}
- **Passed**: ${passed}
- **Failed**: ${failed}
- **Errors**: ${errors}

## Results by Source Type

| Type | Total | Passed | Failed |
|------|-------|--------|--------|
| PF | ${PF_TOTAL} | ${PF_PASS} | ${PF_FAIL} |
| LF | ${LF_TOTAL} | ${LF_PASS} | ${LF_FAIL} |
| PRTF | ${PRTF_TOTAL} | ${PRTF_PASS} | ${PRTF_FAIL} |
| DSPF | ${DSPF_TOTAL} | ${DSPF_PASS} | ${DSPF_FAIL} |

## Detailed Results

REPORT

# Group results by type
for source_t in PF LF PRTF DSPF; do
  has_cases=false
  for tc_id in "${CASES[@]}"; do
    st=$(get_source_type "$tc_id")
    [[ "$st" == "$source_t" ]] && has_cases=true && break
  done
  $has_cases || continue

  cat >> "$report_file" <<REPORT
### ${source_t} Tests

| TC | Description | Category | Verdict | Details |
|----|-------------|----------|---------|---------|
REPORT

  for tc_id in "${CASES[@]}"; do
    st=$(get_source_type "$tc_id")
    [[ "$st" != "$source_t" ]] && continue

    desc="$(get_desc "$tc_id")"
    cat=$(get_test_category "$tc_id")
    verdict_file="${RESULTS_DIR}/${tc_id}-verdict.txt"
    if [[ -f "$verdict_file" ]]; then
      verdict=$(head -1 "$verdict_file")
      details=$(tail -n +2 "$verdict_file" | tr '\n' '; ' | sed 's/; $//')
    else
      verdict="N/A"
      details=""
    fi
    echo "| ${tc_id} | ${desc} | ${cat} | ${verdict} | ${details} |" >> "$report_file"
  done
  echo "" >> "$report_file"
done

cat >> "$report_file" <<REPORT

## Files

Actual outputs saved in \`results/tc-XX-actual.txt\`.
Verdict details in \`results/tc-XX-verdict.txt\`.

## How to Re-run

\`\`\`bash
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
\`\`\`
REPORT

# --- Summary ---
echo ""
echo "========================================"
echo " Results: ${passed} PASS / ${failed} FAIL / ${errors} ERROR"
if [[ $PF_TOTAL -gt 0 ]]; then echo "   PF:   ${PF_PASS}/${PF_TOTAL} passed"; fi
if [[ $LF_TOTAL -gt 0 ]]; then echo "   LF:   ${LF_PASS}/${LF_TOTAL} passed"; fi
if [[ $PRTF_TOTAL -gt 0 ]]; then echo "   PRTF: ${PRTF_PASS}/${PRTF_TOTAL} passed"; fi
if [[ $DSPF_TOTAL -gt 0 ]]; then echo "   DSPF: ${DSPF_PASS}/${DSPF_TOTAL} passed"; fi
echo " Report: ${report_file}"
echo "========================================"
echo ""

if [[ $failed -gt 0 || $errors -gt 0 ]]; then
  exit 1
fi
