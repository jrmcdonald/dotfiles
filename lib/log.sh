#!/usr/bin/env bash
set -eufo pipefail

debug_log_path="${CHEZMOI_SOURCE_DIR:-${HOME}/.local/share/chezmoi/home}/debug-log.txt"

# keep original descriptor for stdout
exec 5<&1

# redirect both stdout and stderr to write to the debug logfile
exec 1>>"${debug_log_path}" 2>>"${debug_log_path}"

function log::info() {
  printf "%s" "${1}" >&1 >&5
  printf "\n"
}

function log::info::complete() {
  printf " ✅ \n" >&5
}

function log::debug() {
  printf "%s" "${1}"
}

function log::start() {
  printf "🦄 chezmoi with jrmcdonald/dotfiles 🦄\n" >&1 >&5
  printf "\n" >&1 >&5
}
