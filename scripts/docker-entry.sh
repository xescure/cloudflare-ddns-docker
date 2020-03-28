#!/bin/sh
set -e

# Clear crontabs
rm -rf /var/spool/cron/crontabs && mkdir -m 0644 -p /var/spool/cron/crontabs

# Copy mounted cron jobs
[ "$(ls -A /etc/cron.d)" ] && cp -f /etc/cron.d/* /var/spool/cron/crontabs/ || true

# Add cron job based on the environmental variable
[ ! -z "$CRON_STRINGS" ] && echo -e "$CRON_STRINGS\n" > /var/spool/cron/crontabs/CRON_STRINGS

# If defined, add simple cron entry to the DDNS script
[ ! -z "$ZONE_NAME" ] && echo -e "$REFRESH_SCHEDULE $RUN_SCRIPT -z $ZONE_NAME\n" > /var/spool/cron/crontabs/CLOUDFLARE_DDNS


chmod -R 0644 /var/spool/cron/crontabs

exec "$@"