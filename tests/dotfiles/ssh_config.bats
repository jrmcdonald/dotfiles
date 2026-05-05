#!/usr/bin/env bats

setup() {
  load '../test_helper'
  SSH_CONFIG="${REPO_ROOT}/home/private_dot_ssh/private_config.tmpl"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

# ============================================================
# ssh config — home profile
# ============================================================

@test "ssh config [home]: renders without error" {
  run render_home "${SSH_CONFIG}"
  assert_success
}

@test "ssh config [home]: contains github.com host entry" {
  run render_home "${SSH_CONFIG}"
  assert_output --partial "Host github.com"
}

@test "ssh config [home]: uses yubikey identity for github" {
  run render_home "${SSH_CONFIG}"
  assert_output --partial "IdentitiesOnly yes"
  assert_output --partial "IdentityFile ~/.ssh/id_rsa_yubikey.pub"
}

@test "ssh config [home]: does not include colima ssh config" {
  run render_home "${SSH_CONFIG}"
  refute_output --partial "colima"
}

@test "ssh config [home]: does not contain gitlab.com host entry" {
  run render_home "${SSH_CONFIG}"
  refute_output --partial "Host gitlab.com"
}

# ============================================================
# ssh config — work profile
# ============================================================

@test "ssh config [work]: renders without error" {
  run render_work "${SSH_CONFIG}"
  assert_success
}

@test "ssh config [work]: includes colima ssh config" {
  run render_work "${SSH_CONFIG}"
  assert_output --partial "Include /Users/jammdon/.colima/ssh_config"
}

@test "ssh config [work]: contains github.com host entry" {
  run render_work "${SSH_CONFIG}"
  assert_output --partial "Host github.com"
}

@test "ssh config [work]: contains gitlab.com host entry" {
  run render_work "${SSH_CONFIG}"
  assert_output --partial "Host gitlab.com"
}

@test "ssh config [work]: uses yubikey identity for gitlab" {
  run render_work "${SSH_CONFIG}"
  assert_output --partial "IdentitiesOnly yes"
  assert_output --partial "IdentityFile ~/.ssh/id_rsa_yubikey.pub"
}
