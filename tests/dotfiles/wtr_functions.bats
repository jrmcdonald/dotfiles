#!/usr/bin/env bats

setup() {
  load '../test_helper'
  WTR_FUNCTIONS="${REPO_ROOT}/home/executable_dot_zsh_wtr_functions.tmpl"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

# ---- home profile ----

@test "wtr_functions [home]: renders without error (empty on home profile)" {
  run render_home "${WTR_FUNCTIONS}"
  assert_success
  assert_output ""
}

# ---- work profile ----

@test "wtr_functions [work]: renders without error" {
  run render_work "${WTR_FUNCTIONS}"
  assert_success
}

@test "wtr_functions [work]: renders valid bash" {
  run render_work "${WTR_FUNCTIONS}"
  assert_success
  run bash -n <<< "${output}"
  assert_success
}

@test "wtr_functions [work]: gcloud-sso checks for active auth before login" {
  run render_work "${WTR_FUNCTIONS}"
  assert_success
  assert_output --partial 'gcloud auth list'
  assert_output --partial 'status=ACTIVE'
  assert_output --partial 'gcloud auth login'
}

@test "wtr_functions [work]: gcloud-pam checks for active grant before creating" {
  run render_work "${WTR_FUNCTIONS}"
  assert_success
  assert_output --partial 'gcloud pam grants list'
  assert_output --partial 'state=ACTIVE OR state=ACTIVATING'
  assert_output --partial 'gcloud pam grants create'
}

@test "wtr_functions [work]: gcloud-pam uses gcloud_entitlement_suffix data variable" {
  run render_work "${WTR_FUNCTIONS}"
  assert_success
  assert_output --partial 'locations/global/entitlements/test-entitlement'
}

@test "wtr_functions [work]: gcloud-k8s sets flex project and cluster by default" {
  run render_work "${WTR_FUNCTIONS}"
  assert_success
  assert_output --partial 'test-flex-project'
  assert_output --partial 'test-flex-cluster'
}

@test "wtr_functions [work]: gcloud-k8s sets prod project and cluster for prod env" {
  run render_work "${WTR_FUNCTIONS}"
  assert_success
  assert_output --partial 'test-prod-project'
  assert_output --partial 'test-prod-cluster'
}
