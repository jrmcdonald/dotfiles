#!/usr/bin/env bash

set -e # -e: exit on error

if [ ! "$(command -v chezmoi)" ]; then
  printf "INFO: Installing chezmoi\n"
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
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
