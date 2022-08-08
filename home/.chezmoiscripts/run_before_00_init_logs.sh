#!/usr/bin/env bash
set -eufo pipefail

printf '' > "$(chezmoi source-path)"/log.info.txt
printf '' > "$(chezmoi source-path)"/log.debug.txt

. "$(chezmoi source-path)/../lib/log.sh"

log_start_msg

