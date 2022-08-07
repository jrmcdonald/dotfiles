# You can find the new timestamped tags here: https://hub.docker.com/r/gitpod/workspace-full/tags
FROM gitpod/workspace-full:2022-08-04-13-40-17

COPY . /dotfiles
WORKDIR /dotfiles

RUN sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b $HOME/.local/bin

RUN GITPOD_BUILD=1 $HOME/.local/bin/chezmoi init --source=.

RUN $HOME/.local/bin/chezmoi apply --include=scripts

WORKDIR $HOME