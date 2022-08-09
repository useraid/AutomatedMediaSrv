#!/bin/bash

# Jellyfin
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
docker run -d \
  --name=qbittorrent \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Kolkata \
  -e WEBUI_PORT=8090 \
  -p 8090:8090 \
  -p 6881:6881 \
  -p 6881:6881/udp \
  -v $HOME/dockdata/qbittorent/appdata/config:/config \
  -v $HOME/dockdata/qbittorent/downloads:/downloads \
  -v $HOME/data:/data \
  --restart unless-stopped \
  linuxserver/qbittorrent:latest

# Heimdall
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
docker run -d \
    -v /:/srv \
    -v $HOME/dockdata/filebrowser/filebrowser.db:/database.db \
    -e PUID=1000 \
    -e PGID=1000 \
    -p 8081:80 \
    filebrowser/filebrowser

# Jellyseerr
docker run -d \
 --name jellyseerr \
 -e LOG_LEVEL=debug \
 -e TZ=Asia/Kolkata \
 -p 5055:5055 \
 -v $HOME/dockdata/jellyseerr:/app/config \
 --restart unless-stopped \
 fallenbagel/jellyseerr:latest

 # Portainer
docker volume create portainer_data
docker run -d -p 9000:9000 -p 8000:8000 -p 9443:9443 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest

# Indexers

# Prowlarr
docker run -d \
  --name=prowlarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e Asia/Kolkata \
  -p 9696:9696 \
  -v $HOME/dockdata/prowlarr:/config \
  --restart unless-stopped \
  linuxserver/prowlarr:latest

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
  -v $HOME/dockdata/qbittorent/downloads:/downloads \
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
  -v $HOME/dockdata/qbittorent/downloads:/downloads \
  --restart unless-stopped \
  linuxserver/radarr:latest

echo "Jellyfin deployed on port 8096
Qbittorrent deployed on port 8090
Heimdall deployed on port 80 (default port)
FileBrowser deployed on port 8081
Jellyseerr deployed on port 5055
Portainer deployed on port 9443"
echo ""
echo "Indexers: "
echo "Prowlarr deployed on port 9696
Bazarr deployed on port 6767
Sonarr deployed on port 8989
Radarr deployed on port 7878"
echo "You can add these ports along with ip while setting up the Heimdall"
echo ""
echo "Installation Complete!"
