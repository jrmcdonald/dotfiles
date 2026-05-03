#!/usr/bin/env bats

setup() {
  load '../test_helper'
  CHSH_SCRIPT="${REPO_ROOT}/home/.chezmoiscripts/run_onchange_after_chsh.sh.tmpl"
  export HOME="${BATS_TEST_TMPDIR}"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
  MOCK_BIN="${BATS_TEST_TMPDIR}/bin"
  mkdir -p "${MOCK_BIN}"
  printf '#!/usr/bin/env bash\necho "/usr/bin/zsh"\n' > "${MOCK_BIN}/zsh"
  chmod +x "${MOCK_BIN}/zsh"
  export PATH="${MOCK_BIN}:${PATH}"
}

teardown() {
  rm -f "${LOG_FILE}"
}

@test "chsh script: file exists" {
  assert_file_exists "${CHSH_SCRIPT}"
}

@test "chsh::change_if_needed: skips when SHELL already matches zsh" {
  MOCK_BIN="${BATS_TEST_TMPDIR}/bin"
  printf '#!/usr/bin/env bash\necho "ERROR: chsh should not be called"; exit 1\n' \
    > "${MOCK_BIN}/sudo"
  chmod +x "${MOCK_BIN}/sudo"

  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    export PATH='${MOCK_BIN}:\${PATH}'
    export SHELL=\$(${MOCK_BIN}/zsh)
    source '${CHSH_SCRIPT}'
    chsh::change_if_needed
  "
  assert_success
  refute_output --partial "ERROR"
}

@test "chsh::change_if_needed: calls chsh when SHELL differs from zsh path" {
  MOCK_BIN="${BATS_TEST_TMPDIR}/bin"
  CALL_LOG="${BATS_TEST_TMPDIR}/sudo.log"
  FULL_PATH="${MOCK_BIN}:${PATH}"
  printf '#!/usr/bin/env bash\necho "$@" >> %s\n' "${CALL_LOG}" > "${MOCK_BIN}/sudo"
  chmod +x "${MOCK_BIN}/sudo"

  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    export PATH='${FULL_PATH}'
    export SHELL='/bin/bash'
    source '${CHSH_SCRIPT}'
    chsh::change_if_needed
  "
  assert_success
  assert_file_exists "${CALL_LOG}"
  assert_file_contains "${CALL_LOG}" "chsh"
}

@test "chsh script: does not execute when sourced" {
  MOCK_BIN="${BATS_TEST_TMPDIR}/bin"
  printf '#!/usr/bin/env bash\necho "ERROR: should not run"; exit 1\n' \
    > "${MOCK_BIN}/sudo"
  chmod +x "${MOCK_BIN}/sudo"

  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    export PATH='${MOCK_BIN}:\${PATH}'
    export SHELL='/bin/bash'
    source '${CHSH_SCRIPT}'
  "
  assert_success
  refute_output --partial "ERROR"
}
