FROM debian:13-slim
LABEL maintainer="Joe Block <jpb@unixorn.net>"

RUN apt update && \
    apt install -y apt-utils ca-certificates bzip2 gzip curl --no-install-recommends && \
    apt autoclean && \
    rm -rf /var/lib/apt/lists/*
RUN update-ca-certificates

COPY tal-backup-etcd /usr/local/bin/tal-backup-etcd
RUN chmod 755 /usr/local/bin/tal-backup-etcd
RUN curl -sL https://talos.dev/install | sh
