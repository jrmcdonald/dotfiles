#!/usr/bin/env bats

setup() {
  load '../test_helper'
  CLEANUP_SCRIPT="${REPO_ROOT}/home/.chezmoiscripts/run_once_after_cleanup_old_tools.sh.tmpl"
  export HOME="${BATS_TEST_TMPDIR}"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

@test "cleanup script: file exists" {
  assert_file_exists "${CLEANUP_SCRIPT}"
}

@test "cleanup::remove_if_exists: removes directory when it exists" {
  mkdir -p "${HOME}/.nvm"
  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${CLEANUP_SCRIPT}'
    cleanup::remove_if_exists 'nvm' '${HOME}/.nvm'
  "
  assert_success
  assert_not_exists "${HOME}/.nvm"
}

@test "cleanup::remove_if_exists: is a no-op when directory does not exist" {
  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${CLEANUP_SCRIPT}'
    cleanup::remove_if_exists 'nvm' '${HOME}/.nvm'
  "
  assert_success
}

@test "cleanup script: does not call main when sourced" {
  mkdir -p "${HOME}/.nvm"
  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${CLEANUP_SCRIPT}'
  "
  assert_success
  assert_exists "${HOME}/.nvm"
}

@test "main: removes all five old tool directories" {
  mkdir -p "${HOME}/.nvm" "${HOME}/.jenv" "${HOME}/.sdkman" \
            "${HOME}/.zgen" "${HOME}/.slimzsh"
  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${CLEANUP_SCRIPT}'
    main
  "
  assert_success
  assert_not_exists "${HOME}/.nvm"
  assert_not_exists "${HOME}/.jenv"
  assert_not_exists "${HOME}/.sdkman"
  assert_not_exists "${HOME}/.zgen"
  assert_not_exists "${HOME}/.slimzsh"
}

@test "main: is a no-op when no old tools are present" {
  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${CLEANUP_SCRIPT}'
    main
  "
  assert_success
}
