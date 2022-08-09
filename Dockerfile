# You can find the new timestamped tags here: https://hub.docker.com/r/gitpod/workspace-full/tags
FROM gitpod/workspace-full:2022-08-04-13-40-17

ADD install-docker.sh .
RUN ./install-docker.sh
RUN rm ./install-docker.sh

