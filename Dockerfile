# You can find the new timestamped tags here: https://hub.docker.com/r/gitpod/workspace-full/tags
FROM gitpod/workspace-full:2022-08-04-13-40-17

RUN GITPOD_BUILD=1 sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --apply --source=. --include=scripts
