ARG DISTRO
ARG DISTROVER
ARG ARCH

FROM ghcr.io/linuxserver/baseimage-${DISTRO}:${ARCH}-${DISTROVER} as builder

ARG DISTRO
ARG DISTROVER
ARG ARCH
ARG PACKAGES

# grpcio build args
ARG GRPC_BUILD_WITH_BORING_SSL_ASM=false
ARG GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=true 
ARG GRPC_PYTHON_BUILD_WITH_CYTHON=true 
ARG GRPC_PYTHON_DISABLE_LIBC_COMPATIBILITY=true

COPY packages.txt /packages.txt

RUN \
  echo "**** Installing dependencies ****" && \
  if [ -f /usr/bin/apt ]; then \
    echo "**** Detected Ubuntu ****" && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
      cargo \
      g++ \
      git \
      libffi-dev \
      libglib2.0-dev \
      libjpeg-dev \
      libssl-dev \
      libwebp-dev \
      libxml2-dev \
      libxslt1-dev \
      make \
      python3-dev \
      python3-pip \
      python3-venv \
      zlib1g-dev; \
  else \
    echo "**** Detected Alpine ****" && \
    apk add --no-cache --virtual=build-dependencies \
      cargo \
      g++ \
      gcc \
      git \
      glib-dev \
      jpeg-dev \
      libffi-dev \
      libwebp-dev \
      libxml2-dev \
      libxslt-dev \
      make \
      openssl-dev \
      py3-pip \
      python3-dev \
      zlib-dev; \
  fi && \
  echo "**** Updating pip and building wheels ****" && \
  if [ "${DISTROVER}" = "3.15" ]; then \
    INDEXDISTRO="alpine-3.15"; \
  elif [ "${DISTROVER}" = "3.16" ]; then \
    INDEXDISTRO="alpine-3.16"; \
  else \
    INDEXDISTRO="${DISTRO}"; \
  fi && \
  python3 -m venv /build-env && \
  . /build-env/bin/activate && \
  pip3 install -U pip setuptools wheel cython && \
  mkdir -p /build && \
  if [ -z "${PACKAGES}" ]; then \
    PACKAGES=$(cat /packages.txt); \
  fi && \
  # ignore official arm32v7 wheel of grpcio
  if [ "${DISTRO}" = "alpine" ] && [ "${ARCH}" = "arm32v7" ]; then \
    GRPCIOSKIP="--no-binary grpcio"; \
  else \
    GRPCIOSKIP=""; \
  fi && \
  pip wheel --wheel-dir=/build --find-links="https://wheel-index.linuxserver.io/${INDEXDISTRO}/" --no-cache-dir -v ${GRPCIOSKIP} \
    ${PACKAGES} && \
  echo "**** Clean up ****" && \
  if [ -f /usr/bin/apt ]; then \
    echo "**** Detected Ubuntu ****" && \
    apt-get purge --auto-remove -y \
      cargo \
      g++ \
      git \
      libffi-dev \
      libglib2.0-dev \
      libjpeg-dev \
      libssl-dev \
      libxml2-dev \
      libxslt1-dev \
      make \
      python3-dev \
      python3-pip \
      python3-venv \
      zlib1g-dev && \
    apt-get clean; \
  else \
    echo "**** Detected Alpine ****" && \
    apk del --purge \
      build-dependencies; \
  fi && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    ${HOME}/.cargo \
    ${HOME}/.cache && \
  echo "**** Wheels built are: ****" && \
  ls /build

FROM scratch as artifacts

COPY --from=builder /build /build
