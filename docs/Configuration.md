# Configuration 

## <b>Contents
- [Heimdall](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#Heimdall)
- [Prowlarr](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#Prowlarr)
- [qBittorrent](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#qBittorrent)
- [Filebrowser](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#Filebrowser)
- [Bazarr](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#Bazarr)
- [Radarr](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#Radarr)
- [Sonarr](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#Sonarr)
- [Jellyfin](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#Jellyfin)
- [Jellyseerr](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#Jellyseerr)
- [Portainer](https://github.com/useraid/AutomatedMediaSrv/blob/main/docs/Configuration.md#Portainer)

## Heimdall

Add the services running on the docker containers with the format http://ip-addr:port. This will allow easier access to all the running containers without needing to put in the ip address and remembering different ports for different services.

## Prowlarr

Choose and add your favourite indexers using the + button and test the items added to the list using the test button on top right.

## qBittorrent

- Login using Username - `admin` Password - `adminadmin`

## Filebrowser

This service would allow you to browse the root directory of the server.

## Bazarr

- Add Sonarr and Radarr api keys.
- Add the Providers (Recommended OpenSubtitles, SubScene)

## Radarr

- Add the qBittorrent in the Download Clients tab.

## Sonarr

- Add the qBittorrent in the Download Clients tab.

## Jellyfin

- Create an account (This is the default admin account)
- Add the media libraries from the administration dashboard.

## Jellyseerr

- Create an account (This is the default admin account)
- Add Sonarr and Radarr servers using their respective ports and ip addresses.
- Add different users with different permissions.

## Portainer

- Create an account (This is the default admin account)
- You can manage the containers from here.
