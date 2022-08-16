#/bin/bash

echo "Enter the IP address : "
read ip
echo "Enter the Webhook URL : "
read webhook
echo http://$ip > ip.txt
echo $webhook > webhook.txt

mkdir /etc/scripts
cp status.sh /etc/scripts
(crontab -l 2>/dev/null; echo "*/30 * * * * /etc/scripts/status.sh >/dev/null 2>&1") | crontab -
