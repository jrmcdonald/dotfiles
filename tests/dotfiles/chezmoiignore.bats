#!/usr/bin/env bats

setup() {
  load '../test_helper'
  IGNORE_FILE="${REPO_ROOT}/home/.chezmoiignore"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

@test "chezmoiignore [home]: renders without error" {
  run render_home "${IGNORE_FILE}"
  assert_success
}

@test "chezmoiignore [home]: ignores .aws" {
  run render_home "${IGNORE_FILE}"
  assert_output --partial ".aws"
}

@test "chezmoiignore [home]: ignores .gnupg" {
  run render_home "${IGNORE_FILE}"
  assert_output --partial ".gnupg"
}

@test "chezmoiignore [home]: ignores .ssh" {
  run render_home "${IGNORE_FILE}"
  assert_output --partial ".ssh"
}

@test "chezmoiignore [home]: ignores work-specific files" {
  run render_home "${IGNORE_FILE}"
  assert_output --partial ".zsh_wtr_functions"
  assert_output --partial ".config/git/waitrose.com"
  assert_output --partial ".local/bin/jira"
  assert_output --partial ".local/bin/allowlist"
}

@test "chezmoiignore [work]: renders without error" {
  run render_work "${IGNORE_FILE}"
  assert_success
}

@test "chezmoiignore [work]: does not ignore .aws" {
  run render_work "${IGNORE_FILE}"
  refute_output --partial ".aws"
}

@test "chezmoiignore [work]: does not ignore .gnupg or .ssh" {
  run render_work "${IGNORE_FILE}"
  refute_output --partial ".gnupg"
  refute_output --partial ".ssh"
}

@test "chezmoiignore [work]: does not ignore work-specific config" {
  run render_work "${IGNORE_FILE}"
  refute_output --partial ".config/git/waitrose.com"
  refute_output --partial ".zsh_wtr_functions"
}

@test "chezmoiignore [both]: always ignores debug-log.txt" {
  run render_home "${IGNORE_FILE}"
  assert_output --partial "debug-log.txt"

  run render_work "${IGNORE_FILE}"
  assert_output --partial "debug-log.txt"
}
