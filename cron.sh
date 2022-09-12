#/bin/bash
ip=$(hostname -I | cut -d' ' -f1)
echo "Enter the Webhook URL : "
read webhook
echo http://$ip > ip.txt
echo $webhook > webhook.txt

mkdir /etc/scripts
cp status.sh /etc/scripts
cp webhook.txt /etc/scripts
cp ip.txt /etc/scripts
(crontab -l 2>/dev/null; echo "*/30 * * * * /etc/scripts/status.sh >/dev/null 2>&1") | crontab -
