# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.11

ARG DOWNLOAD_URL=https://minecraft.azureedge.net/bin-linux/bedrock-server-1.11.2.1.zip

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# update packages and install dependencies
RUN apt-get update \
    && apt-get -y install unzip libcurl4 curl nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl ${DOWNLOAD_URL} --output bedrock-server.zip && \
    unzip bedrock-server.zip -d /srv/bedrock_server && \
    rm bedrock-server.zip

WORKDIR /srv/bedrock_server

# Copy the startup script
COPY ./startup.sh .

RUN chmod +x startup.sh \
    && mkdir -p /srv/bedrock_server/worlds \
    && mkdir -p /srv/bedrock_server/config \
    && cp server.properties server.properties.defaults

ENV LD_LIBRARY_PATH=.

# create volumes for settings that need to be persisted.
VOLUME /srv/bedrock_server/worlds /srv/bedrock_server/config

EXPOSE 19132/udp 19133/udp

ENTRYPOINT ./startup.sh
