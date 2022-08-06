# You can find the new timestamped tags here: https://hub.docker.com/r/gitpod/workspace-full/tags
FROM gitpod/workspace-full:2022-08-04-13-40-17 as build
COPY . /dotfiles
WORKDIR /dotfiles
RUN GITPOD_BUILD=1 ./install.sh

FROM gitpod/workspace-full:2022-08-04-13-40-17
COPY --from=build /home/gitpod /home/gitpod
