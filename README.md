# Dockerized Cloudflare-DDNS

## Prerequisites

1. Get your own domain, if you don't yet have one

    * Maybe pick one up for free at [Freenom](freenom.com)

1. [Add the domain to Cloudflare](https://support.cloudflare.com/hc/en-us/articles/201720164-Creating-a-Cloudflare-account-and-adding-a-website)

1. Create a configuration file based on [example.com.yml](https://github.com/xescure/cloudflare-ddns-docker/blob/master/zones/example.com.yml) and put it in a directory named `zones`

    * The script can only update existing records, so make sure you manually create them first at [dash.cloudflare.com](dash.cloudflare.com)
    * Change `proxied:` to `false` if the domain is used for practically anything other than HTTP/S traffic

## Simple Usage
```
docker run --name=cloudflare-ddns -d --restart=always \
-v /your/zones/directory:/zones \
-e ZONE_NAME="example.com" \
xescure/cloudflare-ddns:latest-amd64
```
By default this will update the selected domain every minute to your current public IP. Simple as that.

A custom update schedule can be set by adding `-e REFRESH_SCHEDULE="<your cron schedule expression>"` to the `docker run` command. *If you are not sure about cron, consult [crontab.guru](https://crontab.guru/) ;)*

## Raspberry Pi

The image is fully compatible with the Raspberry Pi, just use the tag `xescure/cloudflare-ddns:latest-arm` or build it for yourself by cloning the repository and running `docker build -t cloudflare-ddns .`

## Logging

Logs can be found at `/logs/your.domain.log`.

If persistent logging is needed, use `-v /where/you/want/your/logs:/logs`.

## Docker Compose example
```
version: '3.3'
services:
    cloudflare-ddns:
        image: xescure/cloudflare-ddns:latest-amd64
        container_name: cloudflare-ddns
        restart: always
        volumes:
            - '/docker/cloudflare-ddns/zones:/zones'
            - '/docker/cloudflare-ddns/logs:/logs'
        environment:
            - ZONE_NAME=your.domain
            - REFRESH_SCHEDULE=*/5 * * * *
```

## Update multiple domains

Work in progress

## Sources

The project is based on [xordiv/docker-alpine-cron](https://github.com/xordiv/docker-alpine-cron) and [adrienbrignon/cloudflare-ddns](https://github.com/adrienbrignon/cloudflare-ddns), huge thanks to them!

## Retained from [xordiv/docker-alpine-cron](https://github.com/xordiv/docker-alpine-cron)

### Environment Variables
* **CRON_STRINGS** - strings with cron jobs. Use "\n" for newline (Default: undefined)

* **CRON_TAIL** - if defined cron log file will read to stdout by tail (Default: undefined) *- note from xescure: i might break this once I implement proper logging*

By default cron is running in the foreground

### Mountpoints
* **/var/log/cron/cron.log** - the default location for cron's logs

* **/etc/cron.d** - custom crontab files mounted here will be copied to the proper location and activated
