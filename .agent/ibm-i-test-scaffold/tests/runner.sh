#!/usr/bin/env bash
# Local adaptation: remove legacy home-directory fallback; explicit CLI and PATH lookup remain.
# ============================================================================
# Test Scaffold Generator Test Runner (Semi-Automated)
#
# Uses `claude -p` to invoke the ibm-i-test-scaffold skill for each test case,
# captures output, and validates structural rules from the checks files.
#
# Usage:
#   ./runner.sh                      # Run all test cases
#   ./runner.sh tc-ts-01 tc-ts-03    # Run specific test cases
#   ./runner.sh --category service   # Run only service-program tests
#   ./runner.sh --dry-run            # Show what would run without executing
#   ./runner.sh --list               # List all cases
#   ./runner.sh --model sonnet       # Override model
# ============================================================================ 

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CASES_DIR="${SCRIPT_DIR}/cases"
RESULTS_DIR="${SCRIPT_DIR}/results"
MODEL="${TS_TEST_MODEL:-sonnet}"
DRY_RUN=false
VERBOSE=false
LIST_ONLY=false
FILTER_CATEGORY=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CLAUDE_BIN="${CLAUDE_BIN:-$(command -v claude 2>/dev/null || echo "")}"
if [[ -z "${CLAUDE_BIN}" ]]; then
  for candidate in \
    "/Applications/cmux.app/Contents/Resources/bin/claude" \
    "/usr/local/bin/claude" \
    ; do
    if [[ -x "${candidate}" ]]; then
      CLAUDE_BIN="${candidate}"
      break
    fi
  done
fi

SELECTED_CASES=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --verbose) VERBOSE=true; shift ;;
    --list) LIST_ONLY=true; shift ;;
    --model) MODEL="$2"; shift 2 ;;
    --category) FILTER_CATEGORY="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: $0 [--dry-run] [--list] [--verbose] [--model MODEL] [--category NAME] [tc-ts-01 ...]"
      exit 0
      ;;
    tc-ts-*) SELECTED_CASES+=("$1"); shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

get_category() {
  local tc_id="$1"
  local checks_file="${CASES_DIR}/${tc_id}-checks.txt"
  grep '^category=' "${checks_file}" 2>/dev/null | head -1 | cut -d= -f2
}

get_desc() {
  case "$1" in
    tc-ts-01) echo "Batch RPGLE close-order scaffold" ;;
    tc-ts-02) echo "Interactive RPGLE manual-guide scaffold" ;;
    tc-ts-03) echo "CL wrapper billing extract scaffold" ;;
    tc-ts-04) echo "Service program caller-stub scaffold" ;;
    tc-ts-05) echo "Secondary input path from Program Spec" ;;
    tc-ts-06) echo "Missing library names / TBD placeholders" ;;
    *) echo "unknown" ;;
  esac
}

ALL_CASES=()
for f in "${CASES_DIR}"/tc-ts-*-input.md; do
  [[ -f "${f}" ]] || continue
  ALL_CASES+=("$(basename "${f}" | sed 's/-input\.md//')")
done

CASES=()
if [[ ${#SELECTED_CASES[@]} -gt 0 ]]; then
  for tc_id in "${SELECTED_CASES[@]}"; do
    if [[ -n "${FILTER_CATEGORY}" ]]; then
      [[ "$(get_category "${tc_id}")" == "${FILTER_CATEGORY}" ]] && CASES+=("${tc_id}")
    else
      CASES+=("${tc_id}")
    fi
  done
else
  for tc_id in "${ALL_CASES[@]}"; do
    if [[ -n "${FILTER_CATEGORY}" ]]; then
      [[ "$(get_category "${tc_id}")" == "${FILTER_CATEGORY}" ]] || continue
    fi
    CASES+=("${tc_id}")
  done
fi

if ${LIST_ONLY}; then
  printf "%-10s %-14s %s\n" "Case" "Category" "Description"
  printf "%-10s %-14s %s\n" "--------" "------------" "----------------------------------------------"
  for tc_id in "${ALL_CASES[@]}"; do
    printf "%-10s %-14s %s\n" "${tc_id}" "$(get_category "${tc_id}")" "$(get_desc "${tc_id}")"
  done
  exit 0
fi

if ! ${DRY_RUN} && [[ -z "${CLAUDE_BIN}" ]]; then
  echo "ERROR: claude CLI not found. Set CLAUDE_BIN=/path/to/claude or add claude to PATH."
  exit 1
fi

mkdir -p "${RESULTS_DIR}"

build_prompt() {
  local input_file="$1"
  local input_content
  input_content=$(cat "${input_file}")
  cat <<PROMPT
You are the ibm-i-test-scaffold skill. Generate executable SQL/CL test scaffold output from the following input.

Follow the skill rules exactly:
- Output a markdown scaffold with six artifacts in order.
- Use IBM i SQL system naming (library/file), not schema.table.
- Include compile commands, test data setup, execution, verification, and cleanup.
- Do not execute anything.
- Preserve TBD and (Inferred) labels when input is incomplete.

Input:

${input_content}
PROMPT
}

validate_output() {
  local tc_id="$1"
  local output_file="$2"
  local checks_file="${CASES_DIR}/${tc_id}-checks.txt"
  local output
  output=$(cat "${output_file}")
  local failures=()

  while IFS= read -r line; do
    [[ -z "${line}" || "${line}" =~ ^# ]] && continue
    [[ "${line}" =~ ^category= ]] && continue

    local rule value
    rule=$(echo "${line}" | cut -d= -f1)
    value=$(echo "${line}" | cut -d= -f2-)

    case "${rule}" in
      artifact_count)
        local actual_count
        actual_count=$(echo "${output}" | grep -Ec '^## Artifact [1-6]:')
        if [[ "${actual_count}" != "${value}" ]]; then
          failures+=("artifact_count expected ${value}, got ${actual_count}")
        fi
        ;;
      must_contain)
        if ! echo "${output}" | grep -qF "${value}"; then
          failures+=("missing '${value}'")
        fi
        ;;
      must_not_contain)
        if echo "${output}" | grep -qF "${value}"; then
          failures+=("unexpected '${value}'")
        fi
        ;;
      must_contain_regex)
        if ! echo "${output}" | grep -Eq "${value}"; then
          failures+=("missing regex '${value}'")
        fi
        ;;
      must_not_contain_regex)
        if echo "${output}" | grep -Eq "${value}"; then
          failures+=("unexpected regex '${value}'")
        fi
        ;;
    esac
  done < "${checks_file}"

  local verdict_file="${RESULTS_DIR}/${tc_id}-verdict.txt"
  if [[ ${#failures[@]} -eq 0 ]]; then
    echo "PASS" > "${verdict_file}"
    echo "PASS"
  else
    {
      echo "FAIL"
      for failure in "${failures[@]}"; do
        echo "  ${failure}"
      done
    } > "${verdict_file}"
    echo "FAIL"
  fi
}

REPORT_FILE="${RESULTS_DIR}/report.md"
{
  echo "# Test Scaffold Generator Test Report"
  echo ""
  echo "| Case | Category | Verdict | Description |"
  echo "|------|----------|---------|-------------|"
} > "${REPORT_FILE}"

pass_count=0
fail_count=0

for tc_id in "${CASES[@]}"; do
  input_file="${CASES_DIR}/${tc_id}-input.md"
  actual_file="${RESULTS_DIR}/${tc_id}-actual.txt"
  category="$(get_category "${tc_id}")"
  desc="$(get_desc "${tc_id}")"

  if ${DRY_RUN}; then
    echo "[DRY-RUN] ${tc_id} (${category}) - ${desc}"
    continue
  fi

  echo -e "${BLUE}Running ${tc_id}${NC} (${category}) - ${desc}"
  prompt="$(build_prompt "${input_file}")"
  "${CLAUDE_BIN}" -p --model "${MODEL}" "${prompt}" > "${actual_file}"

  verdict="$(validate_output "${tc_id}" "${actual_file}")"
  if [[ "${verdict}" == "PASS" ]]; then
    ((pass_count+=1))
    echo -e "  ${GREEN}PASS${NC}"
  else
    ((fail_count+=1))
    echo -e "  ${RED}FAIL${NC}"
    if ${VERBOSE}; then
      cat "${RESULTS_DIR}/${tc_id}-verdict.txt"
    fi
  fi

  echo "| ${tc_id} | ${category} | ${verdict} | ${desc} |" >> "${REPORT_FILE}"
done

if ! ${DRY_RUN}; then
  echo ""
  echo -e "${GREEN}Passed:${NC} ${pass_count}"
  echo -e "${RED}Failed:${NC} ${fail_count}"
  echo "Report: ${REPORT_FILE}"
fi
