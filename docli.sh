#!/bin/bash

CODE_SAVE_CURSOR="\033[s"
CODE_RESTORE_CURSOR="\033[u"
CODE_CURSOR_IN_SCROLL_AREA="\033[1A"
COLOR_FG="\e[30m"
COLOR_BG="\e[42m"
COLOR_BG_BLOCKED="\e[43m"
RESTORE_FG="\e[39m"
RESTORE_BG="\e[49m"
PROGRESS_BLOCKED="false"
TRAPPING_ENABLED="false"
TRAP_SET="false"

CURRENT_NR_LINES=0

setup_scroll_area() {
    if [ "$TRAPPING_ENABLED" = "true" ]; then
        trap_on_interrupt
    fi

    lines=$(tput lines)
    CURRENT_NR_LINES=$lines
    let lines=$lines-1
    echo -en "\n"

    echo -en "$CODE_SAVE_CURSOR"
    echo -en "\033[0;${lines}r"

    echo -en "$CODE_RESTORE_CURSOR"
    echo -en "$CODE_CURSOR_IN_SCROLL_AREA"

    draw_progress_bar 0
}

destroy_scroll_area() {
    lines=$(tput lines)
    echo -en "$CODE_SAVE_CURSOR"
    echo -en "\033[0;${lines}r"
    echo -en "$CODE_RESTORE_CURSOR"
    echo -en "$CODE_CURSOR_IN_SCROLL_AREA"
    clear_progress_bar
    echo -en "\n\n"
    if [ "$TRAP_SET" = "true" ]; then
        trap - INT
    fi
}

draw_progress_bar() {
    percentage=$1
    lines=$(tput lines)
    let lines=$lines
    if [ "$lines" -ne "$CURRENT_NR_LINES" ]; then
        setup_scroll_area
    fi
    echo -en "$CODE_SAVE_CURSOR"
    echo -en "\033[${lines};0f"
    tput el
    PROGRESS_BLOCKED="false"
    print_bar_text $percentage
    echo -en "$CODE_RESTORE_CURSOR"
}

clear_progress_bar() {
    lines=$(tput lines)
    let lines=$lines
    echo -en "$CODE_SAVE_CURSOR"
    echo -en "\033[${lines};0f"
    tput el
    echo -en "$CODE_RESTORE_CURSOR"
}

print_bar_text() {
    local percentage=$1
    local cols=$(tput cols)
    let bar_size=$cols-17

    local color="${COLOR_FG}${COLOR_BG}"
    if [ "$PROGRESS_BLOCKED" = "true" ]; then
        color="${COLOR_FG}${COLOR_BG_BLOCKED}"
    fi

    let complete_size=($bar_size*$percentage)/100
    let remainder_size=$bar_size-$complete_size
    progress_bar=$(echo -ne "["; echo -en "${color}"; printf_new "#" $complete_size; echo -en "${RESTORE_FG}${RESTORE_BG}"; printf_new "." $remainder_size; echo -ne "]");
    echo -ne " Progress ${percentage}% ${progress_bar}"
}

enable_trapping() {
    TRAPPING_ENABLED="true"
}

trap_on_interrupt() {
    TRAP_SET="true"
    trap cleanup_on_interrupt INT
}

cleanup_on_interrupt() {
    destroy_scroll_area
    exit
}

printf_new() {
    str=$1
    num=$2
    v=$(printf "%-${num}s" "$str")
    echo -ne "${v// /$str}"
}

draw_progress_bar 1

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

draw_progress_bar 10

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

draw_progress_bar 20

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

draw_progress_bar 30

# Filebrowser
docker run -d \
    -v /:/srv \
    -v $HOME/dockdata/filebrowser/filebrowser.db:/database.db \
    -e PUID=1000 \
    -e PGID=1000 \
    -p 8081:80 \
    filebrowser/filebrowser

draw_progress_bar 40

# Jellyseerr
docker run -d \
 --name jellyseerr \
 -e LOG_LEVEL=debug \
 -e TZ=Asia/Kolkata \
 -p 5055:5055 \
 -v $HOME/dockdata/jellyseerr:/app/config \
 --restart unless-stopped \
 fallenbagel/jellyseerr:latest

draw_progress_bar 50

 # Portainer
docker volume create portainer_data
docker run -d -p 9000:9000 -p 8000:8000 -p 9443:9443 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest

draw_progress_bar 60

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

draw_progress_bar 70  

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

draw_progress_bar 80

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

draw_progress_bar 90

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

draw_progress_bar 100
destroy_scroll_area

# Thanks to https://github.com/pollev/bash_progress_bar
