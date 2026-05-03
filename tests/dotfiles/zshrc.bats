#!/usr/bin/env bats

setup() {
  load '../test_helper'
  ZSHRC="${REPO_ROOT}/home/executable_dot_zshrc.tmpl"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

# ---- home profile ----

@test "zshrc [home]: renders without error" {
  run render_home "${ZSHRC}"
  assert_success
}

@test "zshrc [home]: sources sheldon" {
  run render_home "${ZSHRC}"
  assert_output --partial "sheldon source"
}

@test "zshrc [home]: activates mise" {
  run render_home "${ZSHRC}"
  assert_output --partial "mise activate zsh"
}

@test "zshrc [home]: does not contain work-only exports" {
  run render_home "${ZSHRC}"
  refute_output --partial "AWS_REGION"
  refute_output --partial "GPG_TTY"
  refute_output --partial "DOCKER_HOST"
  refute_output --partial "kubectl completion"
  refute_output --partial "zsh_wtr_functions"
}

@test "zshrc [home]: does not contain direnv hook" {
  run render_home "${ZSHRC}"
  refute_output --partial "direnv hook"
}

# ---- work profile ----

@test "zshrc [work]: renders without error" {
  run render_work "${ZSHRC}"
  assert_success
}

@test "zshrc [work]: sources sheldon" {
  run render_work "${ZSHRC}"
  assert_output --partial "sheldon source"
}

@test "zshrc [work]: activates mise" {
  run render_work "${ZSHRC}"
  assert_output --partial "mise activate zsh"
}

@test "zshrc [work]: sets AWS environment variables" {
  run render_work "${ZSHRC}"
  assert_output --partial "AWS_REGION=eu-west-1"
}

@test "zshrc [work]: sets up GPG agent" {
  run render_work "${ZSHRC}"
  assert_output --partial "GPG_TTY"
  assert_output --partial "gpgconf --launch gpg-agent"
}

@test "zshrc [work]: sources work functions file" {
  run render_work "${ZSHRC}"
  assert_output --partial "zsh_wtr_functions"
}

@test "zshrc [work]: enables direnv" {
  run render_work "${ZSHRC}"
  assert_output --partial "direnv hook zsh"
}

@test "zshrc [work]: sets Docker socket variables" {
  run render_work "${ZSHRC}"
  assert_output --partial "DOCKER_HOST"
  assert_output --partial "TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE"
}

@test "zshrc [work]: loads kubectl completions" {
  run render_work "${ZSHRC}"
  assert_output --partial "kubectl completion zsh"
}
