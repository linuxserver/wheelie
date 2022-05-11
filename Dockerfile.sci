ARG ARCH=amd64
ARG DISTRO=focal

FROM ghcr.io/linuxserver/baseimage-ubuntu:${ARCH}-${DISTRO} as builder

RUN \
  echo "**** Installing dependencies ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    build-essential \
    gfortran \
    libatlas-base-dev \
    python3-dev \
    python3-pip \
    python3-venv && \
  python3 -m venv /build-env && \
  . /build-env/bin/activate && \
  pip3 install -U pip setuptools wheel cython && \
  mkdir -p /build && \
  pip wheel --wheel-dir=/build -f https://wheel-index.linuxserver.io/ubuntu/ -v scipy scikit-learn && \
  echo "**** Clean up ****" && \
  apt-get purge --auto-remove -y \
    build-essential \
    gfortran \
    libatlas-base-dev \
    python3-dev \
    python3-pip \
    python3-venv && \
  apt-get clean &&
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
