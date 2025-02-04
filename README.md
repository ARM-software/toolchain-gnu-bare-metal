# Deprecation Notice

**This repository is now deprecated and will no longer be maintained. Arm now supports a comprehensive tool for building different toolchains for arm targets at this address.**

**New Repository Link:** https://gitlab.arm.com/tooling/gnu-devtools-for-arm

Please update your bookmarks and references to point to the new repository.

---

How to build GNU toolchain for Arm Embedded Processors.

System requirement:
- 25G of free disk space
- Docker (installed with appropriate permission)

Default build command:
$ ./build.sh

Build for AArch64 host:
# Build system requirement: Ubuntu 16.04 LTS Arm64 onwards
$ ./build.sh

Build for x86_64 Linux/Windows host:
# Build system requirement: Ubuntu 18.04 LTS x86_64 onwards
$ ./build.sh # or
$ ./build.sh --skip_steps=mingw32 # Only build for x86_64 Linux host

Build for Mac_OS host:
# Build system requirement: Mac_OS 10
$ ./build.sh
