# I'm trying to make one image that works on CUDA and non-cuda machines

https://stackoverflow.com/questions/62183656/re-use-dockerfile-with-different-base-image



Multi-stage build magic is one way to do it:

ARG TARGET="gpu"

FROM node:10.21.0-buster-slim as gpu
# do stuff

FROM debian:buster as cpu
# do other stuff, like apt-get install nodejs

FROM ${TARGET}
# anything in common here

Build the image with DOCKER_BUILDKIT=1 docker build --build-arg 'TARGET=cpu' [...] to get the development-specific stuff. Build image with DOCKER_BUILDKIT=1 docker build [...] to get the existing "prod" stuff. Switch out the value in the first ARG line to change the default behavior if the --build-arg flag is omitted.

Using the DOCKER_BUILDKIT=1 environment flag is important; if you leave it out, builds will always do all three stages. This becomes a much bigger problem the more phases you have and the more conditional stuff you do. When you include it, the build executes the last stage in the file, and only the previous stages that are necessary to complete the multi-stage build. Meaning, for TARGET=gpu, the dev stage never executes, and vice versa.
