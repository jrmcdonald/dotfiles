#!/usr/bin/env bats

setup() {
  load '../test_helper'
  TMUX_SCRIPT="${REPO_ROOT}/home/.chezmoiscripts/run_onchange_after_configure_tmux.sh.tmpl"
  VIM_SCRIPT="${REPO_ROOT}/home/.chezmoiscripts/run_onchange_after_configure_vim.sh.tmpl"
  export HOME="${BATS_TEST_TMPDIR}"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
  MOCK_BIN="${BATS_TEST_TMPDIR}/bin"
  mkdir -p "${MOCK_BIN}"
  export PATH="${MOCK_BIN}:${PATH}"
}

teardown() {
  rm -f "${LOG_FILE}"
}

# --- tmux ---

@test "configure_tmux script: file exists" {
  assert_file_exists "${TMUX_SCRIPT}"
}

@test "tmux::install_plugins: is a no-op when tpm directory does not exist" {
  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${TMUX_SCRIPT}'
    tmux::install_plugins
  "
  assert_success
}

@test "tmux::install_plugins: calls install_plugins when tpm directory exists" {
  CALL_LOG="${BATS_TEST_TMPDIR}/tpm.log"
  mkdir -p "${HOME}/.tmux/plugins/tpm/bin"
  printf '#!/usr/bin/env bash\necho "tpm called" >> %s\n' "${CALL_LOG}" \
    > "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
  chmod +x "${HOME}/.tmux/plugins/tpm/bin/install_plugins"

  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${TMUX_SCRIPT}'
    tmux::install_plugins
  "
  assert_success
  assert_file_contains "${CALL_LOG}" "tpm called"
}

@test "configure_tmux script: does not execute when sourced" {
  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${TMUX_SCRIPT}'
  "
  assert_success
}

# --- vim ---

@test "configure_vim script: file exists" {
  assert_file_exists "${VIM_SCRIPT}"
}

@test "vim::sync_plugins: is a no-op when nvim config does not exist" {
  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${VIM_SCRIPT}'
    vim::sync_plugins
  "
  assert_success
}

@test "vim::sync_plugins: calls nvim when config directory exists" {
  CALL_LOG="${BATS_TEST_TMPDIR}/nvim.log"
  FULL_PATH="${MOCK_BIN}:${PATH}"
  mkdir -p "${HOME}/.config/nvim"
  printf '#!/usr/bin/env bash\necho "nvim called: $*" >> %s\n' "${CALL_LOG}" \
    > "${MOCK_BIN}/nvim"
  chmod +x "${MOCK_BIN}/nvim"

  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    export PATH='${FULL_PATH}'
    source '${VIM_SCRIPT}'
    vim::sync_plugins
  "
  assert_success
  assert_file_contains "${CALL_LOG}" "Lazy! sync"
}

@test "configure_vim script: does not execute when sourced" {
  run bash -c "
    export HOME='${HOME}'
    export CHEZMOI_SOURCE_DIR='${CHEZMOI_SOURCE_DIR}'
    source '${VIM_SCRIPT}'
  "
  assert_success
}
