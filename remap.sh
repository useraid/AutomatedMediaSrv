#!/bin/bash

## Installing Dependencies

sudo apt-get -y install figlet
echo "AutomatedMediaSrv" | figlet

## Help Prompt

function help {
cat <<EOF
Welcome to AutomatedMediaSrv.

It is a script to setup a Media server that fetches and installs Movies, Shows, Automatically 
using various services running as docker containers.
    WARNING: Most of the functionality in this script requires root privileges. Use at
your own risk.

    options:

        -h|--help                Display all options and flags. 

        -a|--install-all         Install all Services, Programs and Containers.

        -s|--selective           Choose which services, containers and programs to install.

        -r|--remove-all          Run the entire script from beginning to end.

        -x|--selective-remove    Choose which services, containers and programs to remove.
EOF
}

## Flag Selector

while [ $# -gt 0 ]; do
  case $1 in
    -a|--install-all)
      help
      exit
      ;;
    -h|--help)
      help
      exit
      ;;
    *)
      echo "Unknown option $1"
      help
      exit 1
      ;;
  esac
done