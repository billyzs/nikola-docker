FROM python:3.6.4-alpine3.7 as builder

RUN ["/bin/sh", "-c", "set -eux && \
        apk add --no-cache \
            # install isso dependencies \
            sqlite \ 
            # install pillow dependencies \
            build-base  \
            zlib-dev    \
            libxml2-dev \
            libxslt-dev \
            jpeg-dev    \
            && \
        pip --no-cache-dir install virtualenv \
            && \
        # install deps in a virtualenv \
        virtualenv /nikola && /nikola/bin/pip --no-cache-dir install \
            isso \
            'nikola[extra]' \
            webassets \
            && \
        # remove build dependencies \
        apk del build-base \
"]
# Usage: adduser [OPTIONS] USER [GROUP]

# Create new user, or add USER to GROUP

#        -h DIR          Home directory
#        -g GECOS        GECOS field
#        -s SHELL        Login shell
#        -G GRP          Group
#        -S              Create a system user
#        -D              Don't assign a password
#        -H              Don't create home directory
#        -u UID          User id
#        -k SKEL         Skeleton directory (/etc/skel)

RUN ["/bin/sh", "-c", "set -eux && \
        # -S creates system group \
        addgroup -S build -g 1000 \
            && \
        adduser -DH -G build -u 1000 nikola \
"]

USER nikola
WORKDIR /nikola

# TODO is it possible to copy the built stuff out to another container?

