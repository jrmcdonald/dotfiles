#!/usr/bin/env bash
set -eufo pipefail

err_report() {
  >&2 printf '\nERROR: error running install-docker.sh ... appending debug log\n\n'
  >&2 cat "$(chezmoi source-path)"/debug-log.txt
}

trap 'err_report' ERR

GITPOD_BUILD=1 sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b $HOME/.local/bin init jrmcdonald
$HOME/.local/bin/chezmoi apply --include=scripts
