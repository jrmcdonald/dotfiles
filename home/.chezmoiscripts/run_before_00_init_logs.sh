#!/usr/bin/env bash
set -eufo pipefail

printf '' > "$(chezmoi source-path)"/debug-log.txt

. "$(chezmoi source-path)/../lib/log.sh"

log::start

