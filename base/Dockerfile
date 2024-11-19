# Copyright © Michal Čihař <michal@weblate.org>
#
# SPDX-License-Identifier: MIT

FROM python:3.12.7-slim-bookworm
ARG TARGETARCH

ENV UV_VERSION=0.5.3
ENV PYVERSION=3.12

LABEL name="Weblate Base"
LABEL maintainer="Michal Čihař <michal@cihar.com>"
LABEL org.opencontainers.image.url="https://weblate.org/"
LABEL org.opencontainers.image.documentation="https://docs.weblate.org/en/latest/admin/install/docker.html"
LABEL org.opencontainers.image.source="https://github.com/WeblateOrg/docker-base"
LABEL org.opencontainers.image.author="Michal Čihař <michal@weblate.org>"
LABEL org.opencontainers.image.vendor="Weblate"
LABEL org.opencontainers.image.title="Weblate"
LABEL org.opencontainers.image.description="A web-based continuous localization system with tight version control integration"
LABEL org.opencontainers.image.licenses="MIT"


SHELL ["/bin/bash", "-o", "pipefail", "-x", "-c"]

# Add user early to get a consistent userid
# - the root group so it can run with any uid
# - the tty group for /dev/std* access
# - see https://github.com/WeblateOrg/docker/issues/326 and https://github.com/moby/moby/issues/31243#issuecomment-406879017
RUN \
  useradd --shell /bin/sh --user-group weblate --groups root,tty \
  && mkdir -p /home/weblate/.ssh \
  && touch /home/weblate/.ssh/authorized_keys \
  && chown -R weblate:weblate /home/weblate \
  && chmod 700 /home/weblate/.ssh \
  && install -d -o weblate -g weblate -m 755 /app/data \
  && install -d -o weblate -g weblate -m 755 /app/cache

# Configure utf-8 locales to make sure Python
# correctly handles unicode filenames, configure settings
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
# Home directory
ENV HOME=/home/weblate
# Avoid Python buffering stdout and delaying logs
ENV PYTHONUNBUFFERED=1
# Add virtualenv to path
ENV PATH=/app/venv/bin:/opt/tools/bin:/usr/local/bin:/usr/bin:/bin

# Install dependencies
# hadolint ignore=DL3008,DL3013,SC2046,DL3003
RUN \
  export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y \
    nginx-light \
    ruby-licensee \
    openssh-client \
    ca-certificates \
    curl \
    gir1.2-pango-1.0 \
    gir1.2-rsvg-2.0 \
    libxmlsec1-openssl \
    libjpeg62-turbo \
    libmariadb3 \
    gettext \
    git \
    git-svn \
    gnupg \
    subversion \
    file \
    locales \
    libldap-common \
    libcairo-gobject2 \
    libenchant-2-2 \
    unzip \
    xz-utils \
  && c_rehash \
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
  && /usr/sbin/locale-gen \
  && echo "deb http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc > /etc/apt/trusted.gpg.d/pgdg.asc \
  && apt-get update \
  && apt-get install --no-install-recommends -y postgresql-client-17 \
  && apt-get clean \
  && rm -rf /root/.cache /tmp/* /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/${UV_VERSION}/install.sh | env UV_UNMANAGED_INSTALL="/usr/local/bin" sh

# Install supervisor and gunicorn to /opt/tools
RUN export UV_NO_CACHE=1 && uv venv /opt/tools
COPY --link requirements.txt /opt/tools/src/requirements.txt
RUN export UV_NO_CACHE=1 && \
    source /opt/tools/bin/activate && \
    uv pip install -r /opt/tools/src/requirements.txt
