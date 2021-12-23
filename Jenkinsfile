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
  }
  stages {
    stage('Build-Multi') {
      // matrix {
      //   axes {
      //     axis {
      //       name 'MATRIXARCH'
      //       values 'X86-64-MULTI', 'ARM64', 'ARMHF-WHEELIE-NATIVE', 'ARMHF-WHEELIE-CHROOT'
      //     }
      //     axis {
      //       name 'MATRIXDISTRO'
      //       values 'ubuntu-focal', 'ubuntu-bionic', 'alpine-3.14', 'alpine-3.13'
      //     }
      //   }
      //   stages {
      //     stage('axis') {
      //       agent none
      //       steps {
      //         script {
      //           stage("${MATRIXDISTRO} on ${MATRIXARCH}") {
      //             print "${MATRIXDISTRO} on ${MATRIXARCH}"
      //           }
      //         }
      //       }
      //     }
      //     stage ('Build') {
      //       agent {
      //         label "${MATRIXARCH}"
      //       }
      //       steps {
      //         echo "Running on node: ${NODE_NAME}"
      //         echo 'Logging into Github'
      //         script {
      //           env.DISTRONAME = sh(
      //             script: '''echo ${MATRIXDISTRO} | sed 's|-.*||' ''',
      //             returnStdout: true).trim()
      //         }
      //         script {
      //           env.DISTROVER = sh(
      //             script: '''echo ${MATRIXDISTRO} | sed 's|.*-||' ''',
      //             returnStdout: true).trim()
      //         }
      //         script {
      //           env.ARCH = sh(
      //             script: ''' #! /bin/bash
      //                         if [ "${MATRIXARCH}" == "X86-64-MULTI" ]; then
      //                           echo "amd64"
      //                         elif [ "${MATRIXARCH}" == "ARM64" ]; then
      //                           echo "arm64v8"
      //                         elif [ "${MATRIXARCH}" == "ARMHF-WHEELIE-CHROOT" ]; then
      //                           echo "arm32v8"
      //                         else
      //                           echo "arm32v7"
      //                         fi
      //                     ''',
      //             returnStdout: true).trim()
      //         }
      //         script {
      //           env.INTERNALARCH = sh(
      //             script: ''' #! /bin/bash
      //                         if [ "${ARCH}" == "arm32v8" ]; then
      //                           echo "arm32v7"
      //                         else
      //                           echo "${ARCH}"
      //                         fi
      //                     ''',
      //             returnStdout: true).trim()
      //         }
      //         sh '''#! /bin/bash
      //               echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
      //            '''
      //         sh "docker build \
      //           --no-cache --pull -t ghcr.io/linuxserver/wheelie:${ARCH}-${DISTRONAME}-${DISTROVER} \
      //           --build-arg DISTRO=${DISTRONAME} \
      //           --build-arg DISTROVER=${DISTROVER} \
      //           --build-arg ARCH=${INTERNALARCH} \
      //           --build-arg PACKAGES=${PACKAGES} ."
      //         retry(5) {
      //           sh "docker push ghcr.io/linuxserver/wheelie:${ARCH}-${DISTRONAME}-${DISTROVER}"
      //         }
      //         sh '''docker rmi \
      //               ghcr.io/linuxserver/wheelie:${ARCH}-${DISTRONAME}-${DISTROVER} || :'''
      //       }
      //     }
      //   }
      // }
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
      steps {
        withCredentials([
          string(credentialsId: 'ci-tests-s3-key-id', variable: 'S3_KEY'),
          string(credentialsId: 'ci-tests-s3-secret-access-key	', variable: 'S3_SECRET') 
          ]) {
          sh '''#! /bin/bash
                set -e
                mkdir -p build-alpine build-ubuntu
                for distro in alpine-3.14 alpine-3.13 ubuntu-focal ubuntu-bionic; do
                  for arch in amd64 arm64v8 arm32v7 arm32v8; do
                    docker pull ghcr.io/linuxserver/wheelie:${arch}-${distro}
                    docker create --name ${arch}-${distro} ghcr.io/linuxserver/wheelie:${arch}-${distro} blah
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
          script {
            env.TEMPDIR = sh(
              script: '''mktemp -d ''',
              returnStdout: true).trim()
          }
          sh '''#! /bin/bash
                set -e
                git clone https://github.com/linuxserver/wheelie.git ${TEMPDIR}/wheelie
                echo "setting up s3cmd"
                docker run -d --rm \
                  --name s3cmd \
                  -v ${PWD}/build-ubuntu:/build-ubuntu \
                  -v ${PWD}/build-alpine:/build-alpine \
                  -e AWS_ACCESS_KEY_ID=\"${S3_KEY}\" \
                  -e AWS_SECRET_ACCESS_KEY=\"${S3_SECRET}\" \
                  ghcr.io/linuxserver/baseimage-alpine:3.14
                docker exec s3cmd /bin/bash -c 'apk add --no-cache py3-pip && pip install s3cmd'
                echo "pushing wheels as necessary"
                for os in ubuntu alpine; do
                  for wheel in $(ls build-${os}/); do
                    if ! grep -q "${wheel}" "${TEMPDIR}/wheelie/docs/${os}/index.html" && ! echo "${wheel}" | grep -q "none-any"; then
                      echo "**** ${wheel} for ${os} is being uploaded to aws ****"
                      UPLOADED="${UPLOADED}\\n${wheel}" 
                      docker exec s3cmd s3cmd put --acl-public "/build-${os}/${wheel}" "s3://wheels.linuxserver.io/${os}/${wheel}"
                      sed -i "s|</body>|    <a href='https://wheels.linuxserver.io/${os}/${wheel}'>${wheel}</a>\\n    <br />\\n\\n</body>|" "${TEMPDIR}/wheelie/docs/${os}/index.html"
                    else
                      echo "**** ${wheel} for ${os} already processed, skipping ****"
                    fi
                  done
                done
                if [ -n "${UPLOADED}" ]; then
                  echo -e "**** Uploaded wheels are: **** ${UPLOADED}"
                else
                  echo "No wheels were uploaded"
                fi
                echo "Stopping s3cmd and removing temp files"
                docker stop s3cmd
                rm -rf build-ubuntu build-alpine
             '''
          sh '''#! /bin/bash
                set -e
                echo "updating git repo as necessary"
                cd ${TEMPDIR}/wheelie
                git add . || :
                git commit -m '[bot] Updating indices' || :
                git push https://LinuxServer-CI:${GITHUB_TOKEN}@github.com/linuxserver/wheelie.git --all || :
             '''
        }
      }
    }
  }
  post {
    always {
      script{
        sh '''#! /bin/bash
              docker stop s3cmd || :
              rm -rf ${TEMPDIR}/wheelie
           '''
        if (currentBuild.currentResult == "SUCCESS"){
          sh ''' curl -X POST -H "Content-Type: application/json" --data '{"avatar_url": "https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png","embeds": [{"color": 1681177,\
                 "description": "**Wheelie Build:**  '${BUILD_NUMBER}'\\n**Status:**  Success\\n**Job:** '${RUN_DISPLAY_URL}'\\n**Packages:** '${PACKAGES}'\\n"}],\
                 "username": "Jenkins"}' ${BUILDS_DISCORD} '''
        }
        else {
          sh ''' curl -X POST -H "Content-Type: application/json" --data '{"avatar_url": "https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png","embeds": [{"color": 16711680,\
                 "description": "**Wheelie Build:**  '${BUILD_NUMBER}'\\n**Status:**  failure\\n**Job:** '${RUN_DISPLAY_URL}'\\n**Packages:** '${PACKAGES}'\\n"}],\
                 "username": "Jenkins"}' ${BUILDS_DISCORD} '''
        }
      }
    }
    cleanup {
      cleanWs()
    }
  }
}