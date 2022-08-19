# For local testing of a gitpod workspace
# You can find the new timestamped tags here: https://hub.docker.com/r/gitpod/workspace-full/tags
FROM gitpod/workspace-full:latest
ADD . /home/gitpod/.local/share/chezmoi/
RUN sudo chown -R gitpod:gitpod /home/gitpod/.local/share/chezmoi
RUN GITPOD_WORKSPACE_ID=1 sh -c "$(curl -fsLS https://chezmoi.io/get)" -- -b $HOME/.local/bin init

