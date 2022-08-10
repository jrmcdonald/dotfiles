#!/usr/bin/env bash

set -e # -e: exit on error

if ! [ -x "$(command -v curl)" ] || ! [ -x "$(command -v git)" ]; then
    printf "ERROR: To install these dotfiles, you must have curl and git installed.\n" >&2
    exit 1
fi

if [ ! "$(command -v chezmoi)" ]; then
  printf "INFO: installing chezmoi\n"
  bin_dir="$HOME/.local/bin"

  if ! [[ ":$PATH:" == *":${bin_dir}:"* ]]; then
    printf "ERROR: Please add ${bin_dir} to your path to execute chezmoi.\n" >&2
    exit 1
  fi

  chezmoi="$bin_dir/chezmoi"
  sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
else
  chezmoi=chezmoi
fi

if [ -d "${HOME}/.local/share/chezmoi/.git" ]; then
  printf "INFO: dotfiles present... updating\n"
  exec "$chezmoi" update --apply
else
  printf "INFO: dotfiles absent... init from github\n"
  exec "$chezmoi" init --apply jrmcdonald
fi
