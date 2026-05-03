#!/usr/bin/env bats

setup() {
  load '../test_helper'
  GIT_CONFIG="${REPO_ROOT}/home/private_dot_config/git/config.tmpl"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

@test "git config [home]: renders without error" {
  run render_home "${GIT_CONFIG}"
  assert_success
}

@test "git config [home]: contains personal email" {
  run render_home "${GIT_CONFIG}"
  assert_output --partial "email = jamie@qwyck.net"
}

@test "git config [home]: sets nvim as editor" {
  run render_home "${GIT_CONFIG}"
  assert_output --partial "editor = nvim"
}

@test "git config [home]: does not contain gpg signing config" {
  run render_home "${GIT_CONFIG}"
  refute_output --partial "gpgsign = true"
  refute_output --partial "includeIf"
}

@test "git config [work]: renders without error" {
  run render_work "${GIT_CONFIG}"
  assert_success
}

@test "git config [work]: enables gpg commit signing" {
  run render_work "${GIT_CONFIG}"
  assert_output --partial "gpgsign = true"
}

@test "git config [work]: includes work git config conditionally" {
  run render_work "${GIT_CONFIG}"
  assert_output --partial 'includeIf "gitdir:~/Development/"'
  assert_output --partial "waitrose.com"
}
