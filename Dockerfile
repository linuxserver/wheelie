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
      cmake \
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
      cmake \
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
  if [ "${DISTRO}" = "alpine" ]; then \
    INDEXDISTRO="${DISTRO}-${DISTROVER}"; \
  else \
    INDEXDISTRO="${DISTRO}"; \
  fi && \
  python3 -m venv /build-env && \
  . /build-env/bin/activate && \
  pip install -U pip setuptools wheel cython && \
  mkdir -p /build && \
  if [ -z "${PACKAGES}" ]; then \
    PACKAGES=$(cat /packages.txt); \
  fi && \
  pip wheel --wheel-dir=/build --find-links="https://wheel-index.linuxserver.io/${INDEXDISTRO}/" --no-cache-dir -v \
    ${PACKAGES} && \
  echo "**** Wheels built are: ****" && \
  ls /build

FROM scratch as artifacts

COPY --from=builder /build /build
