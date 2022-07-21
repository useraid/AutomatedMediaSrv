## Dockerized Media Server

<p align="right"> <a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fuseraid%2FAutomatedMediaSrv&count_bg=%233DB3C8&title_bg=%23555555&icon=github.svg&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>

This script allows to create an automated media server using docker containers.

The currently added containers are 
### UI
- qBittorrent
- Jellyfin
- Heimdall
- Filebrowser
- Jellyseerr
- Portainer
### Indexers
- Jackett
- Sonarr
- Radarr
- Bazarr

<b>The Documentation for the project can be [found here.](https://github.com/useraid/AutomatedMediaSrv/tree/main/docs)

# Quick Setup

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
After the system reboots, run it once again
```
sudo ./installer.sh
```