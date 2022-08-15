#/bin/bash
mkdir /etc/scripts
cp status.sh /etc/scripts
(crontab -l 2>/dev/null; echo "*/30 * * * * /etc/scripts/status.sh >/dev/null 2>&1") | crontab -
