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
      matrix {
        axes {
          axis {
            name 'MATRIXARCH'
            values 'X86-64-MULTI', 'ARM64'
          }
          axis {
            name 'MATRIXDISTRO'
            values 'ubuntu-jammy', 'ubuntu-noble', 'alpine-3.18', 'alpine-3.19', 'alpine-3.20'
          }
        }
        stages {
          stage('axis') {
            agent none
            steps {
              script {
                stage("${MATRIXDISTRO} on ${MATRIXARCH}") {
                  print "${MATRIXDISTRO} on ${MATRIXARCH}"
                }
              }
            }
          }
          stage ('Build') {
            agent {
              label "${MATRIXARCH}"
            }
            steps {
              echo "Running on node: ${NODE_NAME}"
              echo 'Logging into Github'
              sh '''#! /bin/bash
                    echo $GITHUB_TOKEN | docker login ghcr.io -u LinuxServer-CI --password-stdin
                 '''
              echo 'Building wheels'
              sh '''#! /bin/bash
                    DISTRONAME=$(echo ${MATRIXDISTRO} | sed 's|-.*||')
                    DISTROVER=$(echo ${MATRIXDISTRO} | sed 's|.*-||')
                    if [ "${MATRIXARCH}" == "X86-64-MULTI" ]; then
                      ARCH="amd64"
                      PLATFORM="linux/amd64"
                    elif [ "${MATRIXARCH}" == "ARM64" ]; then
                      ARCH="arm64v8"
                      PLATFORM="linux/arm64"
                    fi
                    docker buildx build \
                      --no-cache --pull -t ghcr.io/linuxserver/wheelie:${ARCH}-${DISTRONAME}-${DISTROVER} \
                      --platform=${PLATFORM} \
                      --build-arg DISTRO=${DISTRONAME} \
                      --build-arg DISTROVER=${DISTROVER} \
                      --build-arg ARCH=${ARCH} \
                      --build-arg PACKAGES=\"${PACKAGES}\" .
                 '''
              echo 'Pushing images to ghcr'
              retry(5) {
                    sh '''#! /bin/bash
                          DISTRONAME=$(echo ${MATRIXDISTRO} | sed 's|-.*||')
                          DISTROVER=$(echo ${MATRIXDISTRO} | sed 's|.*-||')
                          if [ "${MATRIXARCH}" == "X86-64-MULTI" ]; then
                            ARCH="amd64"
                          elif [ "${MATRIXARCH}" == "ARM64" ]; then
                            ARCH="arm64v8"
                          fi
                          docker push ghcr.io/linuxserver/wheelie:${ARCH}-${DISTRONAME}-${DISTROVER}
                       '''
              }
              echo 'Cleaning up'
              sh '''#! /bin/bash
                    containers=$(docker ps -aq)
                    if [[ -n "${containers}" ]]; then
                      docker stop ${containers}
                    fi
                    docker system prune -af --volumes || : '''
            }
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
                echo "Retrieving wheels"
                for distro in $(cat distros.txt); do
                  if echo "${distro}" | grep ubuntu; then
                    mkdir -p builds/build-ubuntu
                  else
                    mkdir -p builds/build-${distro}
                  fi
                  for arch in amd64 arm64v8; do
                    echo "**** Retrieving wheels for ${arch}-${distro} ****"
                    if [[ "${arch}" = "amd64" ]]; then
                      PLATFORM="linux/amd64"
                    else
                      PLATFORM="linux/arm64"
                    fi
                    docker pull --platform="${PLATFORM}" ghcr.io/linuxserver/wheelie:${arch}-${distro}
                    docker create --name ${arch}-${distro} ghcr.io/linuxserver/wheelie:${arch}-${distro} blah
                    if echo ${distro} | grep alpine; then
                      docker cp ${arch}-${distro}:/build/. builds/build-${distro}/
                    else
                      docker cp ${arch}-${distro}:/build/. builds/build-ubuntu/
                    fi
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
                echo "Cloning repo and preparing s3cmd"
                git clone https://github.com/linuxserver/wheelie.git ${TEMPDIR}/wheelie
                docker run -d --rm \
                  --name s3cmd \
                  -v ${PWD}/builds:/builds \
                  -e AWS_ACCESS_KEY_ID=\"${S3_KEY}\" \
                  -e AWS_SECRET_ACCESS_KEY=\"${S3_SECRET}\" \
                  ghcr.io/linuxserver/baseimage-alpine:3.18
                docker exec s3cmd /bin/bash -c 'apk add --no-cache python3 && python3 -m venv /lsiopy && pip install -U pip && pip install s3cmd'
             '''
          sh '''#! /bin/bash
                set -e
                echo "pushing wheels as necessary"
                cd builds
                for os in ubuntu $(cat ../distros.txt | grep alpine); do
                  for wheel in $(ls build-${os}/); do
                    if ! grep -q "${wheel}" "${TEMPDIR}/wheelie/docs/${os}/index.html" && ! echo "${wheel}" | grep -q "none-any"; then
                      echo "**** ${wheel} for ${os} is being uploaded to aws ****"
                      UPLOADED="${UPLOADED}\\n${wheel}" 
                      docker exec s3cmd s3cmd put --no-preserve -m application/octet-stream --acl-public "/builds/build-${os}/${wheel}" "s3://wheels.linuxserver.io/${os}/${wheel}"
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
                cd ..
                rm -rf builds
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
              echo "Final clean up, remove s3cmd if still exists"
              docker stop s3cmd || :
              rm -rf ${TEMPDIR}/wheelie
           '''
        if (currentBuild.currentResult == "SUCCESS"){
          sh ''' curl -X POST -H "Content-Type: application/json" --data '{"avatar_url": "https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png","embeds": [{"color": 1681177,\
                 "description": "**Wheelie Build:**  '${BUILD_NUMBER}'\\n**Status:**  Success\\n**Job:** '${RUN_DISPLAY_URL}'\\n**Packages:** '"${PACKAGES}"'\\n"}],\
                 "username": "Jenkins"}' ${BUILDS_DISCORD} '''
        }
        else {
          sh ''' curl -X POST -H "Content-Type: application/json" --data '{"avatar_url": "https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png","embeds": [{"color": 16711680,\
                 "description": "**Wheelie Build:**  '${BUILD_NUMBER}'\\n**Status:**  failure\\n**Job:** '${RUN_DISPLAY_URL}'\\n**Packages:** '"${PACKAGES}"'\\n"}],\
                 "username": "Jenkins"}' ${BUILDS_DISCORD} '''
        }
      }
    }
    cleanup {
      sh '''#! /bin/bash
            echo "Performing docker system prune!!"
            containers=$(docker ps -aq)
            if [[ -n "${containers}" ]]; then
              docker stop ${containers}
            fi
            docker system prune -af --volumes || :
         '''
      cleanWs()
    }
  }
}
