# Wheelie

This repo builds and uploads wheels for pip packages commonly used in linuxserver.io images.

The wheel index is located at https://wheel-index.linuxserver.io
The wheels are downloaded from https://wheels.linuxserver.io

## Ubuntu and Alpine packages (glibc and musl respectively)

Only 3 files are user configurable:
- `packages.txt`: lists the packages for which the wheels are built.
- `distros.txt`: lists the distros the wheels are built with.
  - Should be in the format of either `ubuntu-jammy` or `alpine-3.15` (only ubuntu and alpine versions are supported).
  - ~~Should only be updated if cpython version changes. For instance, alpine 3.14 and 3.15 both use `cp39` so their wheels should be identical, thus no need to add `alpine-3.15` as a new distro.~~ Even if the cpython version matches, the deps may be different. For instance cffi dependency libffi has different versions on alpine 3.14 and 3.15 and while the cpython versions are the same, the cffi wheel built on one is not compatible with the other due to libffi version mismatch. Therefore, we had to split up alpine wheel repos as alpine-3.15, alpine-3.16, etc. Ubuntu has always changed the cpython version between LTS releases, so that issue has not affected Ubuntu in the recent past. Therefore we can maintain a single endpoint for all Ubuntu wheels. In short, should be updated with each distro version.
- `Jenkinsfile`: if `distros.txt` is updated, [the matrix in Jenkinsfile](https://github.com/linuxserver/wheelie/blob/b5b61bc94d129fe5671db9768fd63f998a08c90d/Jenkinsfile#L28) must also be updated to match it as Jenkins pipelines don't support dynamix matrices.

After modifying the above 3 files, you can either wait until the scheduler runs (hourly) or manually trigger the github workflow `wheelie-scheduler.yml`

The wheels will be built on native hardware for the following arches: `amd64` and `arm64v8`.

If adding a new package to `packages.txt` please make sure the Dockerfile has all the necessary dependencies installed, by testing locally first. To do that, follow the steps below:
- Clone the repo: `git clone https://github.com/linuxserver/wheelie.git`
- Enter the folder: `cd wheels`
- Test all the distros:
  - `docker build --build-arg DISTRO=alpine --build-arg DISTROVER=3.21 --build-arg ARCH=amd64 --build-arg PACKAGES=gevent .`
  - `docker build --build-arg DISTRO=alpine --build-arg DISTROVER=3.20 --build-arg ARCH=arm64v8 --build-arg PACKAGES=gevent .`
  - `docker build --build-arg DISTRO=ubuntu --build-arg DISTROVER=noble --build-arg ARCH=amd64 --build-arg PACKAGES=gevent .`
  - `docker build --build-arg DISTRO=ubuntu --build-arg DISTROVER=jammy --build-arg ARCH=arm64v8 --build-arg PACKAGES=gevent .`
- The package name is case sensitive and should match the listing on pypi.org (ie. `PyYAML`).
- If the build fails (or if it downloads a prebuilt wheel instead of building), you can add the necessary dependencies to the Dockerfile and/or change the arch, and test again (build cache should save some time).
- Once confirmed, you can commit your changes to this repo and let the scheduler trigger in the next hourly.

To manually trigger a package build for a single package or a list of packages, a new build with parameters can be triggered on Jenkins at the following link: https://ci.linuxserver.io/job/Tools/job/wheelie/. The `PACKAGE` parameter can be set to a package name, or a list of package names (space delimited). Specific package version can also be included (ie. `cryptography==36.0.1`), however if the version defined is not supported on an older cpython version (like Ubuntu bionic's cp36), the build will fail.

## Home Assistant packages (musl) (deprecated and using upstream wheels with custom python builds)

Home Assistant installs over 1,000 pip packages, many of which don't have prebuilt wheels. HA also doesn't rely on the latest versions of these packages, and most if not all of them are pinned to older versions, which makes our regular wheelie not very useful.

We came up with a custom wheelie specifically for HA. It builds and pushes the HA pinned versions of packages for each new release. The workflow is integrated with the HA docker image's workflow and is as follows:
1. `wheelie_HA_scheduler` runs every hour, grabs the 3 `requirements.txt` files (core, core-all and base) from the latest HA release and compares them to the [saved versions](https://github.com/linuxserver/wheelie/tree/main/HA-reqs) in this repo. 
    * If they're the same, it triggers the HA docker repo's external trigger scheduler so it can check for a new version.
    * If they're different, it triggers the Jenkins job [wheelieHA](https://ci.linuxserver.io/job/Tools/job/wheelieHA/).
2. `wheelieHA` grabs the 3 `requirements.txt` files from the latest HS release, spins up 2 docker images (amd64 and arm64v8), builds and pushes all the HA required wheels. When done, it first updates the 3 `requirements.txt` files in this repo and then it triggers the HA docker repo's external trigger so it can check for a new version (if the requirements files were changed that suggests a new HA release was indeed published).
3. HA docker repo's external trigger scheduler is currently disabled, so it is no longer triggered by cron to prevent premature HA builds (building HA docker before all the new packages are uploaded by `wheelieHA`). HA docker repo's external trigger is only triggered when the `wheelie_HA_scheduler` of this repo and the Jenkins job `wheelieHA` are completed successfully. When it finds a new release of HA, it initiates a docker build for HA on jenkins. As a result, it is ensured that whenever the HA docker build is triggered due to a new HA release, the new pip packages are already in the wheel repo so none of the packages have to be built from scratch on Jenkins.