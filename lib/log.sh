#!/usr/bin/env bash
set -eufo pipefail

info_log_path="$(chezmoi source-path)"/log.info.txt
debug_log_path="$(chezmoi source-path)"/log.debug.txt

# tail the info logfile as a background process so the contents of the info logfile are output to stdout.
tail -n0 -f "${info_log_path}" &

# set an EXIT trap to ensure your background process is cleaned-up when the script exits
trap 'pkill -P $$' EXIT

# redirect both stdout and stderr to write to the debug logfile
exec 1>>"${debug_log_path}" 2>>"${debug_log_path}"

function log_info() {
  printf "%s" "${1}" | tee -a "${info_log_path}"
  printf "\n"
}

function log_info_complete() {
  printf " ✅ \n" >> "${info_log_path}"
}

function log_debug() {
  printf "%s" "${1}"
}

function log_start_msg() {
  printf "🦄 chezmoi with jrmcdonald/dotfiles 🦄\n" | tee -a "${info_log_path}"
  printf "\n" | tee -a "${info_log_path}"
}
