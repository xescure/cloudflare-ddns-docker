#!/bin/sh
set -e

if [ ! -z "$CRON_TAIL" ] 
then
	# crond running in background and log file reading every second by tail to STDOUT
	crond -s /var/spool/cron/crontabs -b -L /var/log/cron/cron.log /cloudflare-ddns/logs/* "$@" && tail -f /var/log/cron/cron.log /cloudflare-ddns/logs/*
else
	# crond running in foreground. log files can be retrieved from /var/log/cron mountpoint
	crond -s /var/spool/cron/crontabs -f -L /var/log/cron/cron.log /cloudflare-ddns/logs/* "$@"
fi