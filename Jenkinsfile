pipeline {
  agent {
    label 'X86-64-MULTI'
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '10', daysToKeepStr: '60'))
    parallelsAlwaysFailFast()
  }
  // Input to determine which packages to build
  parameters {
     string(defaultValue: '', description: 'Package list', name: 'PACKAGES')
  }
  // Configuration for the variables used for this specific repo
  environment {
    BUILDS_DISCORD=credentials('build_webhook_url')
    GITHUB_TOKEN=credentials('498b4638-2d02-4ce5-832d-8a57d01d97ab')
    EXIT_STATUS=''
  }
  stages {
    stage('Build-Multi') {
      when {
        environment name: 'EXIT_STATUS', value: ''
      }
      parallel {
        stage('Build amd64 alpine 3.14') {
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:amd64-alpine-3.14 \
              --build-arg DISTRO=alpine \
              --build-arg DISTROVER=3.14 \
              --build-arg ARCH=amd64 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:amd64-alpine-3.14"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:amd64-alpine-3.14 || :'''
          }
        }
        stage('Build amd64 alpine 3.13') {
          agent {
            label 'X86-64-MULTI'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:amd64-alpine-3.13 \
              --build-arg DISTRO=alpine \
              --build-arg DISTROVER=3.13 \
              --build-arg ARCH=amd64 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:amd64-alpine-3.13"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:amd64-alpine-3.13 || :'''
          }
        }
        stage('Build amd64 ubuntu focal') {
          agent {
            label 'X86-64-MULTI'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:amd64-ubuntu-focal \
              --build-arg DISTRO=ubuntu \
              --build-arg DISTROVER=focal \
              --build-arg ARCH=amd64 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:amd64-ubuntu-focal"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:amd64-ubuntu-focal || :'''
          }
        }
        stage('Build amd64 ubuntu bionic') {
          agent {
            label 'X86-64-MULTI'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:amd64-ubuntu-bionic \
              --build-arg DISTRO=ubuntu \
              --build-arg DISTROVER=bionic \
              --build-arg ARCH=amd64 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:amd64-ubuntu-bionic"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:amd64-ubuntu-bionic || :'''
          }
        }
        stage('Build arm64v8 alpine 3.14') {
          agent {
            label 'ARM64'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm64v8-alpine-3.14 \
              --build-arg DISTRO=alpine \
              --build-arg DISTROVER=3.14 \
              --build-arg ARCH=arm64v8 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm64v8-alpine-3.14"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm64v8-alpine-3.14 || :'''
          }
        }
        stage('Build arm64v8 alpine 3.13') {
          agent {
            label 'ARM64'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm64v8-alpine-3.13 \
              --build-arg DISTRO=alpine \
              --build-arg DISTROVER=3.13 \
              --build-arg ARCH=arm64v8 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm64v8-alpine-3.13"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm64v8-alpine-3.13 || :'''
          }
        }
        stage('Build arm64v8 ubuntu focal') {
          agent {
            label 'ARM64'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm64v8-ubuntu-focal \
              --build-arg DISTRO=ubuntu \
              --build-arg DISTROVER=focal \
              --build-arg ARCH=arm64v8 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm64v8-ubuntu-focal"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm64v8-ubuntu-focal || :'''
          }
        }
        stage('Build arm64v8 ubuntu bionic') {
          agent {
            label 'ARM64'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm64v8-ubuntu-bionic \
              --build-arg DISTRO=ubuntu \
              --build-arg DISTROVER=bionic \
              --build-arg ARCH=arm64v8 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm64v8-ubuntu-bionic"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm64v8-ubuntu-bionic || :'''
          }
        }
        stage('Build arm32v7 alpine 3.14') {
          agent {
            label 'ARMHF-WHEELIE-NATIVE'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm32v7-alpine-3.14 \
              --build-arg DISTRO=alpine \
              --build-arg DISTROVER=3.14 \
              --build-arg ARCH=arm32v7 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm32v7-alpine-3.14"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm32v7-alpine-3.14 || :'''
          }
        }
        stage('Build arm32v7 alpine 3.13') {
          agent {
            label 'ARMHF-WHEELIE-NATIVE'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm32v7-alpine-3.13 \
              --build-arg DISTRO=alpine \
              --build-arg DISTROVER=3.13 \
              --build-arg ARCH=arm32v7 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm32v7-alpine-3.13"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm32v7-alpine-3.13 || :'''
          }
        }
        stage('Build arm32v7 ubuntu focal') {
          agent {
            label 'ARMHF-WHEELIE-NATIVE'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm32v7-ubuntu-focal \
              --build-arg DISTRO=ubuntu \
              --build-arg DISTROVER=focal \
              --build-arg ARCH=arm32v7 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm32v7-ubuntu-focal"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm32v7-ubuntu-focal || :'''
          }
        }
        stage('Build arm32v7 ubuntu bionic') {
          agent {
            label 'ARMHF-WHEELIE-NATIVE'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm32v7-ubuntu-bionic \
              --build-arg DISTRO=ubuntu \
              --build-arg DISTROVER=bionic \
              --build-arg ARCH=arm32v7 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm32v7-ubuntu-bionic"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm32v7-ubuntu-bionic || :'''
          }
        }
        stage('Build arm32v8 alpine 3.14') {
          agent {
            label 'ARMHF-WHEELIE-CHROOT'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm32v8-alpine-3.14 \
              --build-arg DISTRO=alpine \
              --build-arg DISTROVER=3.14 \
              --build-arg ARCH=arm32v7 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm32v8-alpine-3.14"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm32v8-alpine-3.14 || :'''
          }
        }
        stage('Build arm32v8 alpine 3.13') {
          agent {
            label 'ARMHF-WHEELIE-CHROOT'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm32v8-alpine-3.13 \
              --build-arg DISTRO=alpine \
              --build-arg DISTROVER=3.13 \
              --build-arg ARCH=arm32v7 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm32v8-alpine-3.13"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm32v8-alpine-3.13 || :'''
          }
        }
        stage('Build arm32v8 ubuntu focal') {
          agent {
            label 'ARMHF-WHEELIE-CHROOT'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm32v8-ubuntu-focal \
              --build-arg DISTRO=ubuntu \
              --build-arg DISTROVER=focal \
              --build-arg ARCH=arm32v7 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm32v8-ubuntu-focal"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm32v8-ubuntu-focal || :'''
          }
        }
        stage('Build arm32v8 ubuntu bionic') {
          agent {
            label 'ARMHF-WHEELIE-CHROOT'
          }
          steps {
            echo "Running on node: ${NODE_NAME}"
            echo 'Logging into Github'
            sh '''#! /bin/bash
                  echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
               '''
            sh "docker build \
              --no-cache --pull -t ghcr.io/linuxserver/wheelie:arm32v8-ubuntu-bionic \
              --build-arg DISTRO=ubuntu \
              --build-arg DISTROVER=bionic \
              --build-arg ARCH=arm32v7 \
              --build-arg PACKAGES=${PACKAGES} ."
            retry(5) {
              sh "docker push ghcr.io/linuxserver/wheelie:arm32v8-ubuntu-bionic"
            }
            sh '''docker rmi \
                  ghcr.io/linuxserver/wheelie:arm32v8-ubuntu-bionic || :'''
          }
        }
      }
    }
    stage ('Push artifacts') {
      when {
        environment name: 'EXIT_STATUS', value: ''
      }
      steps {
        sh '''#! /bin/bash
              set -e
              echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
              mkdir -p build-alpine build-ubuntu
              for distro in alpine-3.14 alpine-3.13 ubuntu-focal ubuntu-bionic; do
                for arch in amd64 arm64v8 arm32v7 arm32v8; do
                  docker pull ghcr.io/linuxserver/wheelie:${arch}-${distro}
                  docker create --name ${arch}-${distro} ghcr.io/linuxserver/wheelie:${arch}-${distro}
                  if echo "${distro}" | grep -q "alpine"; then
                    docker cp ${arch}-${distro}:/build/. build-alpine/
                  else
                    docker cp ${arch}-${distro}:/build/. build-ubuntu/
                  fi
                  docker rm ${arch}-${distro}
                  docker rmi ghcr.io/linuxserver/wheelie:${arch}-${distro}
                done
              done
           '''
        sh '''#! /bin/bash
              set -e
              ls -al build-ubuntu
              ls -al build-alpine
           '''
      }
    }
  }
}