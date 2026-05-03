#!/usr/bin/env bash

BATS_LIB_PATH="${BATS_TEST_DIRNAME}/../test_helper"

load "${BATS_LIB_PATH}/bats-support/load"
load "${BATS_LIB_PATH}/bats-assert/load"
load "${BATS_LIB_PATH}/bats-file/load"

export REPO_ROOT
REPO_ROOT="$(cd "${BATS_TEST_DIRNAME}/../.." && pwd)"

# Mirror what chezmoi sets at runtime: CHEZMOI_SOURCE_DIR = the home/ subdir
export CHEZMOI_SOURCE_DIR="${REPO_ROOT}/home"

export FIXTURE_HOME="${REPO_ROOT}/tests/fixtures/chezmoi-home.toml"
export FIXTURE_WORK="${REPO_ROOT}/tests/fixtures/chezmoi-work.toml"

render_home() {
  chezmoi execute-template --config "${FIXTURE_HOME}" < "${1}"
}

render_work() {
  chezmoi execute-template --config "${FIXTURE_WORK}" < "${1}"
}
