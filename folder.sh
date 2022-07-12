#!/bin/bash
cd /
mkdir data dockdata
cd data
mkdir tvseries movies
cd ..
cd dockdata
mkdir sonarr radarr qbittorrent jackett jellyfin bazarr heimdall filebrowser jellyseerr
cd filebrowser
touch filebrowser.db
cd ..
cd qbittorrent
mkdir appdata downloads
cd appdata 
mkdir config
