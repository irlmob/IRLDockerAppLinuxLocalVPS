### docker build .

FROM linuxserver/wireguard:latest

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    redir psmisc avahi-daemon

# Copy Init scripts
COPY ./build /etc/wireguard-redir
RUN chmod 500 /etc/wireguard-redir/*

