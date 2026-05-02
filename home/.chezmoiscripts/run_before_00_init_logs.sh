#!/usr/bin/env bash
set -eufo pipefail

printf '' > "${CHEZMOI_SOURCE_DIR:-${HOME}/.local/share/chezmoi}/home/debug-log.txt"

. "${CHEZMOI_SOURCE_DIR:-${HOME}/.local/share/chezmoi}/lib/log.sh"

log::start

