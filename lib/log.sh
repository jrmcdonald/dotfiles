#!/usr/bin/env bash
set -eufo pipefail

debug_log_path="$(chezmoi source-path)"/debug-log.txt

# redirect both stdout and stderr to write to the debug logfile
exec 1>>"${debug_log_path}" 2>>"${debug_log_path}"

function log_info() {
  printf "%s" "${1}" | tee /dev/tty
  printf "\n"
}

function log_info_complete() {
  printf " ✅ \n" >> /dev/tty
}

function log_debug() {
  printf "%s" "${1}"
}

function log_start_msg() {
  printf "🦄 chezmoi with jrmcdonald/dotfiles 🦄\n" | tee /dev/tty
  printf "\n" | tee /dev/tty
}
