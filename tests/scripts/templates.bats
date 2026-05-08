#!/usr/bin/env bats

setup() {
  load '../test_helper'
  SCRIPTS="${REPO_ROOT}/home/.chezmoiscripts"
  export LOG_FILE="${CHEZMOI_SOURCE_DIR}/debug-log.txt"
}

teardown() {
  rm -f "${LOG_FILE}"
}

assert_valid_bash() {
  run bash -n <<< "${1}"
  assert_success
}

# ============================================================
# install_brews — home profile
# ============================================================

@test "install_brews [home]: renders valid bash" {
  run render_home "${SCRIPTS}/run_onchange_before_01_install_brews.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "install_brews [home]: contains all common brews" {
  run render_home "${SCRIPTS}/run_onchange_before_01_install_brews.sh.tmpl"
  assert_success
  assert_output --partial 'brew "mise"'
  assert_output --partial 'brew "sheldon"'
  assert_output --partial 'brew "starship"'
  assert_output --partial 'brew "neovim"'
  assert_output --partial 'brew "atuin"'
  assert_output --partial 'brew "direnv"'
}

@test "install_brews [home]: does not contain work brews" {
  [[ "$(uname)" == "Darwin" ]] || skip "darwin only"
  run render_home "${SCRIPTS}/run_onchange_before_01_install_brews.sh.tmpl"
  assert_success
  refute_output --partial 'brew "awscli"'
  refute_output --partial 'brew "kubernetes-cli"'
  refute_output --partial 'brew "gnupg"'
}

@test "install_brews [home]: does not contain any casks" {
  [[ "$(uname)" == "Darwin" ]] || skip "darwin only"
  run render_home "${SCRIPTS}/run_onchange_before_01_install_brews.sh.tmpl"
  assert_success
  refute_output --partial 'cask "'
}

# ============================================================
# install_brews — work profile
# ============================================================

@test "install_brews [work]: renders valid bash" {
  run render_work "${SCRIPTS}/run_onchange_before_01_install_brews.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "install_brews [work]: contains all common brews" {
  run render_work "${SCRIPTS}/run_onchange_before_01_install_brews.sh.tmpl"
  assert_success
  assert_output --partial 'brew "mise"'
  assert_output --partial 'brew "sheldon"'
  assert_output --partial 'brew "starship"'
  assert_output --partial 'brew "direnv"'
}

@test "install_brews [work]: contains work-only brews" {
  [[ "$(uname)" == "Darwin" ]] || skip "darwin only"
  run render_work "${SCRIPTS}/run_onchange_before_01_install_brews.sh.tmpl"
  assert_success
  assert_output --partial 'brew "awscli"'
  assert_output --partial 'brew "kubernetes-cli"'
  assert_output --partial 'brew "gnupg"'
  assert_output --partial 'brew "helm"'
}

@test "install_brews [work]: contains work casks" {
  [[ "$(uname)" == "Darwin" ]] || skip "darwin only"
  run render_work "${SCRIPTS}/run_onchange_before_01_install_brews.sh.tmpl"
  assert_success
  assert_output --partial 'cask "jetbrains-toolbox"'
  assert_output --partial 'cask "ghostty"'
  assert_output --partial 'cask "alfred"'
}

# ============================================================
# configure_java — home profile
# ============================================================

@test "configure_java [home]: renders valid bash" {
  run render_home "${SCRIPTS}/run_onchange_after_configure_java.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "configure_java [home]: does not exit early" {
  run render_home "${SCRIPTS}/run_onchange_after_configure_java.sh.tmpl"
  assert_success
  refute_output --partial "exit 0"
}

@test "configure_java [home]: installs all three java versions" {
  run render_home "${SCRIPTS}/run_onchange_after_configure_java.sh.tmpl"
  assert_success
  assert_output --partial "mise install java@17"
  assert_output --partial "mise install java@21"
  assert_output --partial "mise install java@25"
}

# ============================================================
# configure_java — work profile
# ============================================================

@test "configure_java [work]: renders valid bash" {
  run render_work "${SCRIPTS}/run_onchange_after_configure_java.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "configure_java [work]: does not exit early" {
  run render_work "${SCRIPTS}/run_onchange_after_configure_java.sh.tmpl"
  assert_success
  refute_output --partial "exit 0"
}

@test "configure_java [work]: installs all three java versions" {
  run render_work "${SCRIPTS}/run_onchange_after_configure_java.sh.tmpl"
  assert_success
  assert_output --partial "mise install java@17"
  assert_output --partial "mise install java@21"
  assert_output --partial "mise install java@25"
}

@test "configure_java [work]: sets java 21 as global default" {
  run render_work "${SCRIPTS}/run_onchange_after_configure_java.sh.tmpl"
  assert_success
  refute_output --partial "mise use --global java@21"
}

# ============================================================
# configure_node — home profile
# ============================================================

@test "configure_node [home]: renders valid bash" {
  run render_home "${SCRIPTS}/run_onchange_after_configure_node.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "configure_node [home]: does not exit early" {
  run render_home "${SCRIPTS}/run_onchange_after_configure_node.sh.tmpl"
  assert_success
  refute_output --partial "exit 0"
}

@test "configure_node [home]: installs node 24.14.1" {
  run render_home "${SCRIPTS}/run_onchange_after_configure_node.sh.tmpl"
  assert_success
  assert_output --partial "mise install node@24.14.1"
}

@test "configure_node [home]: installs corepack" {
  run render_home "${SCRIPTS}/run_onchange_after_configure_node.sh.tmpl"
  assert_success
  assert_output --partial "npm install -g corepack"
}

# ============================================================
# configure_node — work profile
# ============================================================

@test "configure_node [work]: renders valid bash" {
  run render_work "${SCRIPTS}/run_onchange_after_configure_node.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "configure_node [work]: does not exit early" {
  run render_work "${SCRIPTS}/run_onchange_after_configure_node.sh.tmpl"
  assert_success
  refute_output --partial "exit 0"
}

@test "configure_node [work]: installs node 24.14.1" {
  run render_work "${SCRIPTS}/run_onchange_after_configure_node.sh.tmpl"
  assert_success
  assert_output --partial "mise install node@24.14.1"
}

@test "configure_node [work]: sets node 24.14.1 as global default" {
  run render_work "${SCRIPTS}/run_onchange_after_configure_node.sh.tmpl"
  assert_success
  refute_output --partial "mise use --global node@24.14.1"
}

@test "configure_node [work]: installs corepack" {
  run render_work "${SCRIPTS}/run_onchange_after_configure_node.sh.tmpl"
  assert_success
  assert_output --partial "npm install -g corepack"
}

# ============================================================
# install_pipx — home profile
# ============================================================

@test "install_pipx [home]: renders valid bash" {
  run render_home "${SCRIPTS}/run_onchange_before_02_install_pipx.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "install_pipx [home]: exits early (not work profile)" {
  run render_home "${SCRIPTS}/run_onchange_before_02_install_pipx.sh.tmpl"
  assert_success
  assert_output --partial "exit 0"
}

# ============================================================
# install_pipx — work profile
# ============================================================

@test "install_pipx [work]: renders valid bash" {
  run render_work "${SCRIPTS}/run_onchange_before_02_install_pipx.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "install_pipx [work]: installs aws-sso-util" {
  [[ "$(uname)" == "Darwin" ]] || skip "darwin only"
  run render_work "${SCRIPTS}/run_onchange_before_02_install_pipx.sh.tmpl"
  assert_success
  assert_output --partial "pipx install"
  assert_output --partial "aws-sso-util"
}

# ============================================================
# configure_tmux + configure_vim — syntax only (no template vars)
# ============================================================

@test "configure_tmux [home]: renders valid bash" {
  run render_home "${SCRIPTS}/run_onchange_after_configure_tmux.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "configure_vim [home]: renders valid bash" {
  run render_home "${SCRIPTS}/run_onchange_after_configure_vim.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

# ============================================================
# cleanup + chsh — syntax only
# ============================================================

@test "cleanup [home]: renders valid bash" {
  run render_home "${SCRIPTS}/run_once_after_cleanup_old_tools.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}

@test "chsh [home]: renders valid bash" {
  run render_home "${SCRIPTS}/run_onchange_after_chsh.sh.tmpl"
  assert_success
  assert_valid_bash "${output}"
}
