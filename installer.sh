#!/bin/bash

# Banner
cat << EOF
 █████╗ ██╗   ██╗████████╗ ██████╗ ███╗   ███╗ █████╗ ████████╗███████╗██████╗ 
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗████╗ ████║██╔══██╗╚══██╔══╝██╔════╝██╔══██╗
███████║██║   ██║   ██║   ██║   ██║██╔████╔██║███████║   ██║   █████╗  ██║  ██║
██╔══██║██║   ██║   ██║   ██║   ██║██║╚██╔╝██║██╔══██║   ██║   ██╔══╝  ██║  ██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝██║ ╚═╝ ██║██║  ██║   ██║   ███████╗██████╔╝
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═════╝ 
                                                                               
███╗   ███╗███████╗██████╗ ██╗ █████╗ ███████╗██████╗ ██╗   ██╗                
████╗ ████║██╔════╝██╔══██╗██║██╔══██╗██╔════╝██╔══██╗██║   ██║                
██╔████╔██║█████╗  ██║  ██║██║███████║███████╗██████╔╝██║   ██║                
██║╚██╔╝██║██╔══╝  ██║  ██║██║██╔══██║╚════██║██╔══██╗╚██╗ ██╔╝                
██║ ╚═╝ ██║███████╗██████╔╝██║██║  ██║███████║██║  ██║ ╚████╔╝                 
╚═╝     ╚═╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝  ╚═══╝    
EOF

# Updating System

echo "Updating System"
sudo apt update
sudo apt upgrade -y # remove -y flag if it's not a new install and you want to check dependencies.

# Installing Docker
echo "Checking Dependencies"
# Curl
if ! command -v curl &> /dev/null
then
    echo "Installing Curl"
    sudo apt-get -y install curl
fi
# Docker
if ! command -v docker &> /dev/null
then
    echo "Installing Docker"
    curl -sSL https://get.docker.com/ | sh
    sudo groupadd docker # Creating docker group
    sudo usermod -aG docker $USER # Adding current user to docker group
    newgrp docker # Refreshing permissions of current session
fi

function get_distro() {
    if [[ -f /etc/os-release ]]
    then
        source /etc/os-release
        echo $ID
    else
        uname
    fi
}
case $(get_distro) in # Installing Server management Tools
    fedora)
        echo "Installing Webmin"
        wget http://prdownloads.sourceforge.net/webadmin/webmin-1.998-1.noarch.rpm
        sudo yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty perl-Encode-Detect
        sudo rpm -U webmin-1.998-1.noarch.rpm
        echo "Installing Cockpit"
        sudo dnf install cockpit
        sudo systemctl enable --now cockpit.socket
        sudo firewall-cmd --add-service=cockpit
        sudo firewall-cmd --add-service=cockpit --permanent
        ;;
    ubuntu)
        echo "Installing Webmin"
        wget http://prdownloads.sourceforge.net/webadmin/webmin_1.998_all.deb
        sudo dpkg --install webmin_1.998_all.deb
        echo "Installing Cockpit"
        . /etc/os-release
        sudo apt install -t ${VERSION_CODENAME}-backports cockpit
        ;;
    debian)
        echo "Installing Webmin"
        wget http://prdownloads.sourceforge.net/webadmin/webmin_1.998_all.deb
        sudo dpkg --install webmin_1.998_all.deb
        echo "Installing Cockpit"
        . /etc/os-release
        echo "deb http://deb.debian.org/debian ${VERSION_CODENAME}-backports main" > \
            /etc/apt/sources.list.d/backports.list
        apt update
        apt install -t ${VERSION_CODENAME}-backports cockpit
        ;;
esac

mkdir -p $HOME/dockdata/filebrowser
touch $HOME/dockdata/filebrowser/filebrowser.db

# Pulling and running the docker containers
# Jellyfin
echo "Adding Jellyfin"
docker run -d \
    --name=jellyfin \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Asia/Kolkata \
    -p 8096:8096 \
    -p 8920:8920  \
    -p 7359:7359/udp  \
    -p 1900:1900/udp  \
    -v $HOME/dockdata/jellyfin:/config \
    -v $HOME/data/tvseries:/data/tvshows \
    -v $HOME/data/movies:/data/movies \
    --restart unless-stopped \
    linuxserver/jellyfin:latest

# qBittorrent
echo "Adding qBittorrent"
docker run -d \
    --name=qbittorrent \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Asia/Kolkata \
    -e WEBUI_PORT=8090 \
    -p 8090:8090 \
    -p 6881:6881 \
    -p 6881:6881/udp \
    -v $HOME/dockdata/qbittorrent/appdata/config:/config \
    -v $HOME/dockdata/qbittorrent/downloads:/downloads \
    -v $HOME/data:/data \
    --restart unless-stopped \
    linuxserver/qbittorrent:latest

# Heimdall
echo "Adding Heimdall"
docker run -d \
    --name=heimdall \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Asia/Kolkata \
    -p 80:80 \
    -p 443:443 \
    -v $HOME/dockdata/heimdall:/config \
    --restart unless-stopped \
    linuxserver/heimdall:latest

# Filebrowser
echo "Adding Filebrowser"
docker run -d \
    --name=filebrowser \
        -v /:/srv \
        -v $HOME/dockdata/filebrowser/filebrowser.db:/database.db \
        -e PUID=1000 \
        -e PGID=1000 \
        -p 8081:80 \
        filebrowser/filebrowser

# Jellyseerr
echo "Adding Jellyseerr"
docker run -d \
--name jellyseerr \
-e LOG_LEVEL=debug \
-e TZ=Asia/Kolkata \
-p 5055:5055 \
-v $HOME/dockdata/jellyseerr:/app/config \
--restart unless-stopped \
fallenbagel/jellyseerr:latest

# Portainer
echo "Adding Portainer"
docker volume create portainer_data
docker run -d -p 9000:9000 -p 8000:8000 -p 9443:9443 --name portainer \
        --restart=always \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v portainer_data:/data \
        portainer/portainer-ce:latest

# Watchtower
echo "Adding Watchtower"
docker run -d \
--name watchtower   \
--restart always   \
-v /var/run/docker.sock:/var/run/docker.sock   \
v2tec/watchtower   \
-i 3600	

# Indexers

echo "Installing Indexers - Prowlarr, Radarr, Sonarr and Bazarr"

# Prowlarr
docker run -d \
--name=prowlarr \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Europe/London \
-p 9696:9696 \
-v $HOME/dockdata/prowlarr:/config \
--restart unless-stopped \
linuxserver/prowlarr:develop

# Bazarr
docker run -d \
    --name=bazarr \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Asia/Kolkata \
    -p 6767:6767 \
    -v $HOME/dockdata/bazarr:/config \
    -v $HOME/data/movies:/movies  \
    -v $HOME/data/tvseries:/tv   \
    --restart unless-stopped \
    linuxserver/bazarr:latest

# Sonarr
docker run -d \
    --name=sonarr \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Asia/Kolkata \
    -p 8989:8989 \
    -v $HOME/dockdata/sonarr:/config \
    -v $HOME/data:/data \
    -v $HOME/dockdata/qbittorrent/downloads:/downloads \
    --restart unless-stopped \
    linuxserver/sonarr:latest

# Radarr
docker run -d \
    --name=radarr \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Asia/Kolkata \
    -p 7878:7878 \
    -v $HOME/dockdata/radarr/data:/config \
    -v $HOME/data:/data  \
    -v $HOME/dockdata/qbittorrent/downloads:/downloads \
    --restart unless-stopped \
    linuxserver/radarr:latest

echo "Docker Configuration Complete"

# Server Notifications 

echo "To setup Notifications answer the following: "
chmod +x cron.sh
./cron.sh

# Printing out the ip address and ports

echo "The installation is complete now, proceed with the configuration of the containers"
echo "IP address is" 
hostname -I
printf "Use the following ports for the services: \n Portainer :9000 \n Jellyfin :8096 \n qBittorrent :8090 \n Heimdall :80(default http port) \n Filebrowser :8081 \n Jellyseerr :5055 \n Prowlarr :9696 \n Bazarr :6767 \n Radarr :7878 \n Sonarr :8989 \n"
echo "Add these services to Heimdall so you don't need to keep track of the IP addresses and the Port numbers"