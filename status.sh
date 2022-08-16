#!/bin/bash
url="webhook_url"
websites_list="http://IP_ADDR:PORT"
curl -H "Content-Type: application/json" -X POST -d '{"content":"'" $(date) \n***Services*** "'"}'  $url
for website in ${websites_list} ; do
        status_code=$(curl --write-out %{http_code} --silent --output /dev/null -L ${website})

        if [[ "$status_code" -ne 200 ]] ; then
            if [[ "$website" = http://*.*.*.*:8096 ]] ; then
                domain="Jellyfin"
            elif [[ "$website" = http://*.*.*.*:9000 ]] ; then
                domain="Portainer"
            elif [[ "$website" = http://*.*.*.*:8989 ]] ; then
                domain="Sonarr"
            elif [[ "$website" = http://*.*.*.*:7878 ]] ; then
                domain="Radarr"
            elif [[ "$website" = http://*.*.*.*:8090 ]] ; then
                domain="qBittorrent"
            elif [[ "$website" = http://*.*.*.*:5055 ]] ; then
                domain="Jellyseerr"
            fi
            # POST request to Discord Webhook with the domain name and the HTTP status code
            curl -H "Content-Type: application/json" -X POST -d '{"content":"'"${website} is down with SC : ${status_code}"'"}'  $url
        else
            if [[ "$website" = http://*.*.*.*:8096 ]] ; then
                domain="Jellyfin"
            elif [[ "$website" = http://*.*.*.*:9000 ]] ; then
                domain="Portainer"
            elif [[ "$website" = http://*.*.*.*:8989 ]] ; then
                domain="Sonarr"
            elif [[ "$website" = http://*.*.*.*:7878 ]] ; then
                domain="Radarr"
            elif [[ "$website" = http://*.*.*.*:8090 ]] ; then
                domain="qBittorrent"
            elif [[ "$website" = http://*.*.*.*:5055 ]] ; then
                domain="Jellyseerr"
            fi
            curl -H "Content-Type: application/json" -X POST -d '{"content":"'"${domain} is up and running with SC : ${status_code}"'"}'  $url
        fi
done