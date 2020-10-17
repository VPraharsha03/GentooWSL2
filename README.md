# GentooWSL2
Gentoo Linux on WSL2 (Windows 10 1903 or later)
based on [wsldl](https://github.com/yuk7/wsldl)

![screenshot](https://github.com/VPraharsha03/GentooWSL2/blob/main/img/screenshot.jpg?raw=true)

[![CircleCI](https://circleci.com/gh/VPraharsha03/GentooWSL2.svg?style=svg)](https://circleci.com/gh/VPraharsha03/GentooWSL2)
[![Github All Releases](http://img.shields.io/github/downloads/VPraharsha03/GentooWSL2/total.svg?style=flat-square)](https://github.com/VPraharsha03/GentooWSL2/releases/latest)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
![License](https://img.shields.io/github/license/yuk7/AlpineWSL.svg?style=flat-square)

### [Download](https://github.com/VPraharsha03/GentooWSL2/releases)


## Requirements
* Windows 10 1903 x64 ([KB4566116 update](https://www.catalog.update.microsoft.com/Search.aspx?q=KB4566116) required on 1903/09) or later.
* Windows Subsystem for Linux feature is enabled.

## Installation
#### 1. [Download](https://github.com/VPraharsha03/GentooWSL2/releases) installer zip

#### 2. Extract all files in zip file to same directory

#### 3.Run Gentoo.exe to Extract rootfs and Register to WSL
Exe filename is used as the instance name to register.
If you rename it, you can register with a different name and have multiple installs.

### Final steps:
Make changes to the portage environment accordingly (**/etc/portage/make.conf** file):
* Adjust CPU configuration and COMMON_FLAGS to match your PC architecture.
* Adjust MAKEOPTS to the number of CPU cores (+1) to make the compilation faster

To finish the Gentoo installation a new snapshot of the ebuild repository should be downloaded. A recompilation of the compiler ensures that GCC is on the most recent stable version. After updating GCC a recompilation of all programs / libraries ensures that the set optimizations take effect.

```shell
#!/bin/bash
set -e -x

# Download a snapshot of all official ebuilds
emerge-webrsync

# Upgrade the compiler and the required libtool library
emerge --oneshot --deep sys-devel/gcc
emerge --oneshot --usepkg=n sys-devel/libtool

# Update all packages with the newly built compiler
# This will take a long time, ~1-5 hours
emerge --oneshot --emptytree --deep @world
emerge --oneshot --deep @preserved-rebuild
emerge --ask --depclean
```

### Limit WSL2 resource usage:
Create a global configuration for all installed WSL2 Linux disributions, named .wslconfig in your user profile folder. This is necessary to set a maximum size limit of the RAM WSL will use. Sometimes, Linux Kernel may use free memory as cache and will eat away RAM of host. 

```dos
[wsl2]
#kernel=
memory=4GB # Limit VM memory
#processors=
#swap=
#swapFile=
localhostForwarding=true
EOF
``` 
Restart WSL from Powershell with admin rights
```powershell
Restart-Service LxssManager
```

## How-to-Use(for Installed Instance)
#### exe Usage
```dos
Usage :
    <no args>
      - Open a new shell with your default settings.

    run <command line>
      - Run the given command line in that distro. Inherit current directory.

    runp <command line (includes windows path)>
      - Run the path translated command line in that distro.

    config [setting [value]]
      - `--default-user <user>`: Set the default user for this distro to <user>
      - `--default-uid <uid>`: Set the default user uid for this distro to <uid>
      - `--append-path <on|off>`: Switch of Append Windows PATH to $PATH
      - `--mount-drive <on|off>`: Switch of Mount drives
      - `--default-term <default|wt|flute>`: Set default terminal window

    get [setting]
      - `--default-uid`: Get the default user uid in this distro
      - `--append-path`: Get on/off status of Append Windows PATH to $PATH
      - `--mount-drive`: Get on/off status of Mount drives
      - `--wsl-version`: Get WSL Version 1/2 for this distro
      - `--default-term`: Get Default Terminal for this distro launcher
      - `--lxguid`: Get WSL GUID key for this distro

    backup [contents]
      - `--tgz`: Output backup.tar.gz to the current directory using tar command
      - `--reg`: Output settings registry file to the current directory

    clean
      - Uninstall the distro.

    help
      - Print this usage message.
```


#### How to uninstall instance
```dos
>Gentoo.exe clean

```
