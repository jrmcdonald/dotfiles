#!/usr/bin/env bats

setup() {
  load '../test_helper'
  export HOME="${BATS_TEST_TMPDIR}"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

@test "log.sh: file exists and is readable" {
  assert_file_exists "${REPO_ROOT}/lib/log.sh"
}

@test "log::info: writes message to output" {
  run bash -c "
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    . '${REPO_ROOT}/lib/log.sh'
    log::info 'hello world'
  "
  assert_success
  assert_output --partial "hello world"
}

@test "log::info::complete: writes checkmark to output" {
  run bash -c "
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    . '${REPO_ROOT}/lib/log.sh'
    log::info::complete
  "
  assert_success
  assert_output --partial "✅"
}

@test "log::start: writes banner to output" {
  run bash -c "
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    . '${REPO_ROOT}/lib/log.sh'
    log::start
  "
  assert_success
  assert_output --partial "chezmoi with jrmcdonald/dotfiles"
}

@test "log::debug: writes message to log file" {
  run bash -c "
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    . '${REPO_ROOT}/lib/log.sh'
    log::debug 'debug message'
  "
  assert_success
  assert_file_contains "${LOG_FILE}" "debug message"
}

@test "log.sh: creates log file if it does not exist" {
  rm -f "${LOG_FILE}"
  run bash -c "
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    . '${REPO_ROOT}/lib/log.sh'
    log::info 'trigger creation'
  "
  assert_success
  assert_file_exists "${LOG_FILE}"
}
