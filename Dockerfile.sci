ARG ARCH=amd64
ARG DISTRO=focal

FROM ghcr.io/linuxserver/baseimage-ubuntu:${ARCH}-${DISTRO} as builder

ARG ARCH=amd64
ARG DISTRO=focal
ARG PACKAGES="scipy scikit-learn pikepdf"

RUN \
  echo "**** Installing dependencies ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    build-essential \
    gfortran \
    jq \
    libatlas-base-dev \
    libjpeg-dev \
    python3-dev \
    python3-pip \
    python3-venv \
    zlib1g-dev && \
  if echo "${PACKAGES}" | grep -q pikepdf && [ "${ARCH}" = "arm32v7" ]; then \
    echo "**** install qpdf on armhf ****"; \
    QPDF_VERSION=$(curl -sX GET "https://api.github.com/repos/qpdf/qpdf/releases/latest" \
      | jq -r '.tag_name' | sed 's|release-qpdf-||'); \
    mkdir -p /tmp/qpdf; \
    curl -o \
      /tmp/qpdf.tar.gz -L \
      "https://github.com/qpdf/qpdf/releases/download/release-qpdf-${QPDF_VERSION}/qpdf-${QPDF_VERSION}.tar.gz"; \
    tar xf \
      /tmp/qpdf.tar.gz -C \
      /tmp/qpdf --strip-components=1; \
    cd /tmp/qpdf; \
    mkdir -p /usr/local/include/qpdf; \
    cp -a /tmp/qpdf/include/qpdf/* /usr/local/include/qpdf/; \
    if curl -fso \
      /tmp/libqpdf.tar -L \
      "https://wheels.linuxserver.io/ubuntu/libqpdf-${QPDF_VERSION}-${DISTRO}-${ARCH}.tar"; then \
        echo "**** Found libqpdf so for version ${QPDF_VERSION}; installing. ****"; \
        tar xvPf \
          /tmp/libqpdf.tar; \
    else \
      echo "**** Did not find libqpdf so version ${QPDF_VERSION}; building from source. ****"; \
      ./configure; \
      make; \
      make install; \
      mkdir -p /build; \
      find /usr -name libqpdf.so* -exec tar -rvPf "/build/libqpdf-${QPDF_VERSION}-${DISTRO}-${ARCH}.tar" {} +; \
    fi; \
  fi && \
  python3 -m venv /build-env && \
  . /build-env/bin/activate && \
  pip3 install -U pip setuptools wheel cython && \
  mkdir -p /build && \
  PIKEPDF_VERSION=$(curl -sL "https://pypi.python.org/pypi/pikepdf/json" |jq -r '. | .info.version') && \
  env SETUPTOOLS_SCM_PRETEND_VERSION="${PIKEPDF_VERSION}" pip wheel --wheel-dir=/build -f https://wheel-index.linuxserver.io/ubuntu/ -v \
    ${PACKAGES} && \
  echo "**** Clean up ****" && \
  apt-get purge --auto-remove -y \
    build-essential \
    gfortran \
    jq \
    libatlas-base-dev \
    libjpeg-dev \
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
  echo "**** Wheels built are: ****" && \
  ls /build

FROM scratch as artifacts

COPY --from=builder /build /build
