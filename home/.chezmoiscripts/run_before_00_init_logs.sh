#!/usr/bin/env bash
set -eufo pipefail

printf '' > "${HOME}/.local/share/chezmoi/home/debug-log.txt"

. "${HOME}/.local/share/chezmoi/lib/log.sh"

log::start

