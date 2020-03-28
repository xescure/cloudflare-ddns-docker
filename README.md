# Dockerized Cloudflare-DDNS

# Currently Work in Progress

## Prerequisites

1. [Add the domain you would like to update to Cloudflare](https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website)
2. Create a configuration file based on [example.com.yml](https://github.com/xescure/cloudflare-ddns-docker/blob/master/zones/example.com.yml) and put it in a directory named `zones`

    * The script can only update existing records, so make sure you manually create them first at cloudflare.com

## Simple Usage
```
docker run --name=cloudflare-ddns -d --restart=always \
-v /your/zones/directory:/zones \
-e ZONE_NAME="example.com" \
xescure/cloudflare-ddns:latest-amd64
```
By default this will update your domain every minute to your current public IP. Simple as that.

You can use a custom refresh schedule, just add `-e REFRESH_SCHEDULE="<your cron schedule expression>"` to the `docker run` command. If you are not sure about cron, consult [crontab.guru](https://crontab.guru/) ;)

## Raspberry Pi

The image is fully compatible with the Raspberry Pi, just use the tag `xescure/cloudflare-ddns:latest-arm` or build it for yourself by cloning the repository and running `docker build -t cloudflare-ddns .`

## Update multiple domains

Work in progress

## Sources

The project is based on [xordiv/docker-alpine-cron](https://github.com/xordiv/docker-alpine-cron) and [adrienbrignon/cloudflare-ddns](https://github.com/adrienbrignon/cloudflare-ddns)

## Retained from [xordiv/docker-alpine-cron](https://github.com/xordiv/docker-alpine-cron)

### Environment Variables
* **CRON_STRINGS** - strings with cron jobs. Use "\n" for newline (Default: undefined)

* **CRON_TAIL** - if defined cron log file will read to stdout by tail (Default: undefined) *- note from xescure: i might break this once I implement proper logging*

By default cron is running in the foreground

### Mountpoints
* **/var/log/cron/cron.log** - the default location for cron's logs

* **/etc/cron.d** - custom crontab files mounted here will be copied to the proper location and activated
