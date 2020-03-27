#!/bin/sh
set -e

rm -rf /var/spool/cron/crontabs && mkdir -m 0644 -p /var/spool/cron/crontabs


[ "$(ls -A /etc/cron.d)" ] && cp -f /etc/cron.d/* /var/spool/cron/crontabs/ || true

[ ! -z "$CRON_STRINGS" ] && echo -e "$CRON_STRINGS\n" > /var/spool/cron/crontabs/CRON_STRINGS

[ ! -z "$REFRESH_SCHEDULE" ] && echo -e "$REFRESH_SCHEDULE python /cloudflare-ddns.py -z $ZONE_NAME\n" > /var/spool/cron/crontabs/CDDNS_ENV


chmod -R 0644 /var/spool/cron/crontabs

exec "$@"