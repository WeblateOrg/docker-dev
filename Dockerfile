# Copyright © Michal Čihař <michal@weblate.org>
#
# SPDX-License-Identifier: MIT

FROM weblate/base:2025.30.0@sha256:86a3cf49ebb8e66a49c3919b918db0ad664dc70703058981b0f140c4f521c3c3
ARG TARGETARCH

LABEL name="Weblate Dev"
LABEL maintainer="Michal Čihař <michal@cihar.com>"
LABEL org.opencontainers.image.url="https://weblate.org/"
LABEL org.opencontainers.image.documentation="https://docs.weblate.org/en/latest/admin/install/docker.html"
LABEL org.opencontainers.image.source="https://github.com/WeblateOrg/docker-dev"
LABEL org.opencontainers.image.author="Michal Čihař <michal@weblate.org>"
LABEL org.opencontainers.image.vendor="Weblate"
LABEL org.opencontainers.image.title="Weblate Dev Image"
LABEL org.opencontainers.image.description="A web-based continuous localization system with tight version control integration"
LABEL org.opencontainers.image.licenses="MIT"

# hadolint ignore=DL3008
RUN \
  export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    pkg-config \
    make \
    libcairo2-dev \
    libxml2-dev \
    libacl1-dev \
    liblz4-dev \
    libzstd-dev \
    libxxhash-dev \
    libmariadb-dev \
    libxmlsec1-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    zlib1g-dev \
    libjpeg62-dev \
    libgirepository-2.0-dev \
    patch \
    gcc \
    g++ \
  && apt-get clean \
  && rm -rf /root/.cache /tmp/* /var/lib/apt/lists/*
