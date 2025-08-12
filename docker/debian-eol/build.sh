#!/usr/bin/env bash

# https://hub.docker.com/r/debian/eol/tags?name=slim&ordering=-name

version="${1:-jessie}"
plateform="${2:-linux/amd64}"
plateform_tag="${plateform//\//-}"
image_name=debian/$version:slim-$plateform_tag-gcc
fc_uid=$(id -u)
fc_un=$(id -un)
fc_gid=$(id -g)

docker build \
    --build-arg TARGETPLATFORM=$plateform \
    --build-arg BASE_IMAGE=debian/eol:$version-slim \
    --build-arg FC_UID=$fc_uid \
    --build-arg FC_UN=$fc_un \
    --build-arg FC_GID=$fc_gid \
    -t $image_name .

# docker image inspect $image_name --format='{{.Architecture}}/{{.Os}}'