# Installation

## <b>Contents
- [Prerequisites](empty)
- [Installing all the containers](empty)
- [Installing Containers using compose file](empty)


## Prerequisites

Docker and docker-compose should be installed or could be installed from 
- Using the official docker install script (For all supported Distributions)
```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```
- `dockerinstall.sh` (for Debian)


## Installing all the containers
- Download/clone the repository using git or the download code button.
```
git clone https://github.com/useraid/AutomatedMediaSrv.git
```
- Extract the zip file.
- Change directory into the folder and run the `install.sh` after making it executable using `chmod +x ./install.sh` .
```
cd AutomatedMediaSrv
chmod +x ./install.sh
./install.sh
```

##  Installing Containers using compose file

- The containers can be deployed using stacks tab in portainer or docker-compose if you do not want to install using the script.
- To deploy using portainer
    - Make `portinstall.sh` executable and run it or manually pull and run portainer.
    ```
    chmod +x portinstall.sh
    ./portinstall.sh
    ```
    -  Login to web app on http://ip-addr:9000 and local enviornment.
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