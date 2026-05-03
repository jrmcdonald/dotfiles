#!/usr/bin/env bats

setup() {
  load '../test_helper'
  SCRIPT="${REPO_ROOT}/home/.chezmoiscripts/run_before_00_init_logs.sh"
  export HOME="${BATS_TEST_TMPDIR}"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

@test "init_logs: script exists" {
  assert_file_exists "${SCRIPT}"
}

@test "init_logs: creates log file if it does not exist" {
  rm -f "${LOG_FILE}"
  run bash -c "export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'; bash '${SCRIPT}'"
  assert_success
  assert_file_exists "${LOG_FILE}"
}

@test "init_logs: truncates existing log file content" {
  echo "old content" > "${LOG_FILE}"
  run bash -c "export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'; bash '${SCRIPT}'"
  assert_success
  run grep "old content" "${LOG_FILE}"
  assert_failure
}

@test "init_logs: writes start banner to output" {
  run bash -c "export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'; bash '${SCRIPT}'"
  assert_success
  assert_output --partial "chezmoi with jrmcdonald/dotfiles"
}
