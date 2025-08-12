#!/usr/bin/env bash

# https://hub.docker.com/r/debian/eol/tags?name=slim&ordering=-name

version="${1:-jessie}"
plateform="${2:-linux/amd64}"
plateform_tag="${plateform//\//-}"
image_name=debian/$version:slim-$plateform_tag-gcc

docker run --rm -it \
    --user $(id -u):$(id -g) \
    -v $(pwd)/../..:/trdc \
    --hostname docker-$version-$plateform_tag \
    $image_name


# docker image inspect $image_name --format='{{.Architecture}}/{{.Os}}'