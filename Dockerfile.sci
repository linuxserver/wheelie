ARG ARCH=amd64
ARG DISTRO=focal

FROM ghcr.io/linuxserver/baseimage-ubuntu:${ARCH}-${DISTRO} as builder

ARG ARCH=amd64
ARG DISTRO=focal
ARG PACKAGES="scipy scikit-learn"

RUN \
  echo "**** Installing dependencies ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    dh-autoreconf \
    gfortran \
    git \
    jq \
    libopenblas-dev \
    libjpeg-dev \
    pkg-config \
    python3-dev \
    python3-pip \
    python3-venv \
    zlib1g-dev && \
  python3 -m venv /build-env && \
  . /build-env/bin/activate && \
  pip3 install -U pip setuptools wheel cython && \
  mkdir -p /build && \
  pip wheel --wheel-dir=/build -f https://wheel-index.linuxserver.io/ubuntu/ -v ninja patchelf && \
  pip install /build/ninja-* /build/patchelf-* && \
  pip wheel --wheel-dir=/build -f https://wheel-index.linuxserver.io/ubuntu/ -v \
    ${PACKAGES} && \
  echo "**** Clean up ****" && \
  apt-get purge --auto-remove -y \
    build-essential \
    cmake \
    dh-autoreconf \
    gfortran \
    git \
    jq \
    libopenblas-dev \
    libjpeg-dev \
    pkg-config \
    python3-dev \
    python3-pip \
    python3-venv \
    zlib1g-dev && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    ${HOME}/.cargo \
    ${HOME}/.cache && \
  echo "**** Renaming wheels if necessary ****" && \
  /bin/bash -c 'for i in $(ls /build/*armv8l*.whl 2>/dev/null); do echo "processing ${i}" && cp -- "$i" "${i//armv8l/armv7l}"; done' && \
  echo "**** Wheels built are: ****" && \
  ls /build

FROM scratch as artifacts

COPY --from=builder /build /build
