# Wheelie

This repo builds and uploads wheels for pip packages commonly used in linuxserver.io images.

The wheel index is located at https://wheel-index.linuxserver.io
The wheels are downloaded from https://wheels.linuxserver.io

## Ubuntu and Alpine packages (glibc and musl respectively)

Only 1 file is user configurable:
- `packages.txt`: lists the packages for which the wheels are built.

After modifying the above file, you can either wait until the scheduler runs (hourly) or manually trigger the github workflow `wheelie-scheduler.yml`

If adding a new package to `packages.txt` please make sure the Dockerfile has all the necessary dependencies installed, by testing locally first. To do that, follow the steps below:
- Clone the repo: `git clone https://github.com/aptalca/wheels.git`
- Enter the folder: `cd wheels`
- Test all the distros (may need to use the arm32v7 versions if amd64 already has prebuilt wheels in pypi):
  - `docker build --build-arg DISTRO=alpine --build-arg DISTROVER=3.14 --build-arg ARCH=amd64 --build-arg PACKAGES=gevent .`
  - `docker build --build-arg DISTRO=alpine --build-arg DISTROVER=3.13 --build-arg ARCH=amd64 --build-arg PACKAGES=gevent .`
  - `docker build --build-arg DISTRO=ubuntu --build-arg DISTROVER=focal --build-arg ARCH=arm32v7 --build-arg PACKAGES=gevent .`
  - `docker build --build-arg DISTRO=ubuntu --build-arg DISTROVER=bionic --build-arg ARCH=arm32v7 --build-arg PACKAGES=gevent .`
- If the build fails (or if it downloads a prebuilt wheel instead of building), you can add the necessary dependencies to the Dockerfile and/or change the arch, and test again (build cache should save some time).
- Once confirmed, you can commit your changes to this repo and let the scheduler trigger in the next hourly.

## Home Assistant packages (musl)

Home Assistant installs over 1,000 pip packages, many of which don't have prebuilt wheels. HA also doesn't rely on the latest versions of these packages, and most if not all of them are pinned to older versions, which makes our regular wheelie not very useful.

We came up with a custom wheelie specifically for HA. It builds and pushes the HA pinned versions of packages for each new release. The workflow is integrated with the HA docker image's workflow and is as follows:
1. `wheelie_HA_scheduler` runs every hour, grabs the 3 `requirements.txt` files (core, core-all and base) from the latest HA release and compares them to the [saved versions](https://github.com/linuxserver/wheelie/tree/main/HA-reqs) in this repo. 
    * If they're the same, it triggers the HA docker repo's external trigger scheduler so it can check for a new version.
    * If they're different, it triggers the Jenkins job [wheelieHA](https://ci.linuxserver.io/job/Tools/job/wheelieHA/).
2. `wheelieHA` grabs the 3 `requirements.txt` files from the latest HS release, spins up 3 docker images (1 for each arch), builds and pushes all the HA required wheels. When done, it first updates the 3 `requirements.txt` files in this repo and then it triggers the HA docker repo's external trigger scheduler so it can check for a new version (if the requirments files were changed that suggests a new HA release was indeed published).
3. HA docker repo's external trigger scheduler is currently disabled, so it is no longer triggered by cron to prevent premature HA builds (building HA docker before all the new packages are uploaded by `wheelieHA`). HA docker repo's external trigger is only triggered when the `wheelie_HA_scheduler` of this repo and the Jenkins job `wheelieHA` are completed successfully. When it finds a new release of HA, it initiates a docker build for HA on jenkins. As a result, it is ensured that whenever the HA docker build is triggered due to a new HA release, the new pip packages are already in the wheel repo so none of the packages have to be built from scratch on Jenkins.