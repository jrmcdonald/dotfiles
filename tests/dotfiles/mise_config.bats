#!/usr/bin/env bats

setup() {
  load '../test_helper'
  MISE_CONFIG="${REPO_ROOT}/home/private_dot_config/mise/config.toml.tmpl"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

@test "mise config [home]: renders without error" {
  run render_home "${MISE_CONFIG}"
  assert_success
}

@test "mise config [home]: has idiomatic_version_file setting" {
  run render_home "${MISE_CONFIG}"
  assert_output --partial "idiomatic_version_file = true"
}

@test "mise config [home]: sets temurin as java shorthand vendor" {
  run render_home "${MISE_CONFIG}"
  assert_output --partial 'java.shorthand_vendor = "temurin"'
}

@test "mise config [home]: has minimum_release_age setting" {
  run render_home "${MISE_CONFIG}"
  assert_output --partial 'minimum_release_age = "3d"'
}

@test "mise config [home]: declares node and java tools" {
  run render_home "${MISE_CONFIG}"
  assert_output --partial 'idiomatic_version_file_enable_tools = ["java", "node"]'
  assert_output --partial "[tools]"
  assert_output --partial 'node = "24.14.1"'
  assert_output --partial 'java = "21"'
}

@test "mise config [work]: renders without error" {
  run render_work "${MISE_CONFIG}"
  assert_success
}

@test "mise config [work]: has minimum_release_age setting" {
  run render_work "${MISE_CONFIG}"
  assert_output --partial 'minimum_release_age = "3d"'
}

@test "mise config [work]: declares node and java tools" {
  run render_work "${MISE_CONFIG}"
  assert_output --partial 'idiomatic_version_file_enable_tools = ["java", "node"]'
  assert_output --partial "[tools]"
  assert_output --partial 'node = "24.14.1"'
  assert_output --partial 'java = "21"'
}
