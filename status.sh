#!/bin/bash

url="webhook_url"

websites_list="http://IP_ADDR:PORT"

for website in ${websites_list} ; do
        status_code=$(curl --write-out %{http_code} --silent --output /dev/null -L ${website})

        if [[ "$status_code" -ne 200 ]] ; then
            curl -H "Content-Type: application/json" -X POST -d '{"content":"'"${website} : ${status_code}"'"}'  $url
        else
            curl -H "Content-Type: application/json" -X POST -d '{"content":"'"${website} : ${status_code}"'"}'  $url
        fi
done