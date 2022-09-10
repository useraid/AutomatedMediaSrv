# Installation

## <b>Contents

- Method I (Quick Setup)

    - [Prerequisites](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/installation.md#prerequsites)
    - [Installer Script](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/installation.md#installer-script)
    - [Using `git`]()


- Method II

    - [Prerequisites](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/installation.md#prerequisites)
    - [Installing all the containers](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/installation.md#installing-all-the-containers)
    - [Installing Containers using compose file](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/installation.md#installing-containers-using-compose-file)

# Method 1

## Prerequsites

Install Prerequisites
```
sudo apt install curl
```
## Installer Script

Download Script using `curl` 
```
curl -O https://raw.githubusercontent.com/useraid/AutomatedMediaSrv/main/installer.sh
```
Make it executable 
```
chmod +x installer.sh
```
Run it
```
sudo ./installer.sh
```

## Use `git` to pull repository

Use `git clone` to download full repository.
```
git clone https://github.com/useraid/AutomatedMediaSrv.git
```
Make it executable 
```
chmod +x installer.sh
```
Run it
```
sudo ./installer.sh
```

# Method II

## Prerequisites

Docker and docker-compose should be installed or could be installed from 
- Using the official docker install script (For all supported Distributions)
```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```


## Installing all the containers
- Download/clone the repository using git or the download code button.
```
git clone https://github.com/useraid/AutomatedMediaSrv.git
```
- Extract the zip file.
- Change directory into the folder and run the `docli.sh` after making it executable using `chmod +x ./docli.sh` .
```
cd AutomatedMediaSrv
chmod +x ./docli.sh
./docli.sh
```

##  Installing Containers using compose file

- The containers can be deployed using stacks tab in portainer or docker-compose if you do not want to install using the script.
- To deploy using portainer
    -  Login to portainer web app on http://ip-addr:9000 and local enviornment.
    - Open the stack tab on sidebar and upload or paste the contents of `compose.yml`.
    - Deploy the stack.
    - This should pull the images and run them in few minutes (depending on your internet speed).
- Using `docker-compose`
    - Use `docker-compose up -d` to install the containers in the compose file.
    - Verify the install using `docker ps`.
    ```
    docker-compose up -d
    docker ps
    ```