#!/usr/bin/env bash
set -eufo pipefail

. "${CHEZMOI_SOURCE_DIR:-${HOME}/.local/share/chezmoi}/../lib/log.sh"

if [[ "$(uname -s)" != "Linux" ]]; then
  exit 0
fi

if locale -a 2>/dev/null | grep -qx "en_US.utf8"; then
  exit 0
fi

log_info "Generating en_US.UTF-8 locale"
sudo locale-gen en_US.UTF-8
