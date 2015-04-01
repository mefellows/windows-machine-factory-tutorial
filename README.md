# Machine Factory Tutorial

Example project to accompany a series of blogs (TBA @ [onegeek.com.au](http://www.onegeek.com.au)) on setting up Machine Factories on Windows.

## Background

The "Machine Factory" was affectionately named by the team in project MarioKart at SEEK. The idea being that a single set of provisioning scripts could build images for dev machines (Vagrant & Virtualbox/Parallels) build agents (EC2/AMI) and Production environments (EC2/AMI).

This additional optimisation was added to improve the spin-up time of developer/build machines by having prebaked base images.

Parity between Development and CI environments is achieved by using a shared [provisioning script](scripts/provision.ps1). Both developer machine images and build agent AMIs are provisioned using the same recipe but built using different virtualisation platforms.

## IMPORTANT: Before you start

### Dependencies:

- [Virtualbox](https://www.virtualbox.org/wiki/Downloads): virtualisation platform to run development machine images.
- *[Parallels Desktop](http://www.parallels.com/au/products/desktop/download/) and the SDK. This is only required if creating Parallels images.
- [Packer](https://packer.io/): used to build and provision machine images.
- [Packer Community](https://github.com/packer-community/packer-windows-plugins): specialised plugins to make Windows box generation work
- A set of AWS Credentials for your account (Consider using [credulous](https://github.com/realestate-com-au/credulous) to manage your keys)
- A subnet and optionally, a VPC, to load the application into

## Virtualbox Developer machine image

Get existing Windows base box OR create a new one from scratch:

### 1(a). Get pre-prepared VirtualBox machine image

- *Source:* `\\aumel-nas2\developers\vagrant\machinefactory-api\output-basebox-vbox`
- *Destination:* `<PROJECT_ROOT>/output-output-basebox-vbox`

### 1(b). OR, Create a new VirtualBox machine image

A new base machine image is required if the `iso_url` or [Autounattend.xml](answer_files/2012_r2/Autounattend.xml) file changes:

1. Create new machine image

    ```
    cd <PROJECT_ROOT>
    packer build -only basebox-vbox vagrant.json
    ```
1. Upload image to share drive
    1. Upload a VirtualBox package file:
        - *Source:* `<PROJECT_ROOT>\machine-factory\basebox\output-basebox-vbox`
        - *Destination:* `\\aumel-nas2\developers\vagrant\machinefactory-api\output-basebox-vbox`

### 2. Build Vagrant box

A new Vagrant box is required when [provision.ps1](scripts/provision.ps1) changes or your Vagrantfile is doing too much heavy lifting on first boot.

1. Build the machinefactory-api developer box

    ```
    cd <PROJECT_ROOT>
    packer build -only=devbox-vbox vagrant.json
    ```

1. Register the new box with Vagrant on your local machine

    ```
    vagrant box add machinefactory-api file:///<PROJECT_ROOT>/machinefactory-api-1.0.1.box
    ```

1. Upload the machinefactory-api developer box and share with the rest of the team.  This is the base image used by Vagrant to spin up a virtualised developer environment.


## Parallels Developer Machine

Follow the instructions as per Virtualbox, however instead of using the postfix `vbox` on the builders, use `parallels`. Additionally, due to a packer post-processor issue with Parallels 10, you will need to manually zip the contents of the box into its own .box file:


    cd output-devbox-parallels
    echo '{"provider":"parallels"}' > metadata.json
    cat ../vagrantfile-windows_2012_r2.template > Vagrantfile
    tar --lzma -cvf machinefactory-api-parallels-1.0.2.box *

Copy the box to the shared drive:
    
    cp machinefactory-api-parallels-1.0.2.box <some storage location>

## Base AMIs

This is normally never required to be performed manually (it should be part of a CI process) but if you do, its fairly simple:

```
PACKER_LOG=true PACKER_LOG_PATH=./packer.log packer build -only=base-ami -var build_version=1.0.46 ./base.json
```

## Build Agents

```
PACKER_LOG=true PACKER_LOG_PATH=./packer.log packer build -only=buildagent -var build_version=1.0.46 ./buildagent.json
```

You will need to install and configure your specific build server application (TeamCity, Jenkins/Hudson, Bamboo etc.) separately, or enhance `provision-agent.ps1`.