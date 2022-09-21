#/bin/bash
ip=$(hostname -I | cut -d' ' -f1)
echo "Enter the Webhook URL : "
read webhook
echo http://$ip > ip.txt
echo $webhook > webhook.txt
echo "How often do you want the notifications ? (in Minutes ) : "
read ti

mkdir /etc/scripts
cp status.sh /etc/scripts
cp webhook.txt /etc/scripts
cp ip.txt /etc/scripts
(crontab -l 2>/dev/null; echo "*/$ti * * * * /etc/scripts/status.sh >/dev/null 2>&1") | crontab -
