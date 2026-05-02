#!/usr/bin/env bash

set -e # -e: exit on error

if ! [ -x "$(command -v curl)" ] || ! [ -x "$(command -v git)" ]|| ! [ -x "$(command -v brew)" ]; then
    printf "ERROR: To install these dotfiles, you must have curl, git, and brew installed.\n" >&2
    exit 1
fi

if [ ! "$(command -v chezmoi)" ]; then
  printf "INFO: installing chezmoi\n"
  brew install chezmoi
fi

if [ -d "${HOME}/.local/share/chezmoi/.git" ]; then
  printf "INFO: dotfiles present... updating\n"
  exec chezmoi update --apply
else
  printf "INFO: dotfiles absent... init from github\n"
  exec chezmoi init --apply jrmcdonald
fi
