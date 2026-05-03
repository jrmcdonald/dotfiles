#!/usr/bin/env bats

setup() {
  load '../test_helper'
  SHELDON_PLUGINS="${REPO_ROOT}/home/private_dot_config/sheldon/plugins.toml"
}

@test "sheldon plugins: file exists" {
  assert_file_exists "${SHELDON_PLUGINS}"
}

@test "sheldon plugins: is valid TOML" {
  run python3 -c "
import sys
try:
    import tomllib
except ImportError:
    try:
        import tomli as tomllib
    except ImportError:
        sys.exit(0)
with open('${SHELDON_PLUGINS}', 'rb') as f:
    tomllib.load(f)
"
  assert_success
}

@test "sheldon plugins: declares zsh-autosuggestions" {
  run cat "${SHELDON_PLUGINS}"
  assert_output --partial "zsh-users/zsh-autosuggestions"
}

@test "sheldon plugins: declares zsh-history-substring-search" {
  run cat "${SHELDON_PLUGINS}"
  assert_output --partial "zsh-users/zsh-history-substring-search"
}

@test "sheldon plugins: declares zsh-completions" {
  run cat "${SHELDON_PLUGINS}"
  assert_output --partial "zsh-users/zsh-completions"
}

@test "sheldon plugins: declares git-open" {
  run cat "${SHELDON_PLUGINS}"
  assert_output --partial "paulirish/git-open"
}

@test "sheldon plugins: declares kubetail" {
  run cat "${SHELDON_PLUGINS}"
  assert_output --partial "johanhaleby/kubetail"
}

@test "sheldon plugins: does not reference old zgen or slimzsh" {
  run cat "${SHELDON_PLUGINS}"
  refute_output --partial "zgen"
  refute_output --partial "slimzsh"
}
