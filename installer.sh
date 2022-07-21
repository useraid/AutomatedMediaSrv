#!/bin/bash
# filename: installer.sh

# check if the reboot flag file exists. 
if [ ! -f /home/pre ]; then
  echo "running script for the first time.."

  # Updating System
  sudo apt update
  sudo apt upgrade -y # remove -y flag if it's not a new install and you want to check dependencies.

  # Installing Docker
  curl -fsSL https://get.docker.com -o docker.sh
  sh docker.sh
  sudo groupadd docker # Creating docker group
  sudo usermod -aG docker $USER # Adding current user to docker group

  # create a flag file to check if we are resuming from reboot.
  touch /home/pre
  
  echo "rebooting.."
  sudo reboot
  
else 
  echo "resuming script after reboot.."
  # remove the temporary file that we created to check for reboot
  sudo rm -f /home/pre

  # continue with rest of the script
  # Creating folders
	cd $HOME    
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

	# Pulling and running the docker containers
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

	# Jackett
	docker run -d \
		--name=jackett \
		-e PUID=1000 \
		-e PGID=1000 \
		-e Asia/Kolkata \
		-p 9117:9117 \
		-v $HOME/dockdata/jackett:/config \
		--restart unless-stopped \
		linuxserver/jackett:latest

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
		-v $HOME/data/tvseries:/tv \
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
		-v $HOME/data/movies:/movies  \
		-v $HOME/dockdata/qbittorent/downloads:/downloads \
		--restart unless-stopped \
		linuxserver/radarr:latest

	echo "Docker Configuration Complete"

	# Printing out the ip address and ports

	echo "The installation is complete now, proceed with the configuration of the containers"
	echo "IP address is" 
	hostname -I
	printf "Use the following ports for the services: \n Portainer :9000 \n Jellyfin :8096 \n qBittorrent :8090 \n Heimdall :80(default http port) \n Filebrowser :8081 \n Jellyseerr :5055 \n Jackett :9117 \n Bazarr :6767 \n Radarr :7878 \n Sonarr :8989 \n"
	echo "Add these services to Heimdall so you don't need to keep track of the IP addresses and the Port numbers"

fi