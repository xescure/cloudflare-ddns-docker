FROM python:3.6-alpine3.11

# Install Cron and it's dependencies
RUN apk update && apk add dcron curl wget rsync ca-certificates && rm -rf /var/cache/apk/*

# I've not yet read what it does, but it's from the original docker-cron repo
RUN mkdir -p /var/log/cron && mkdir -m 0644 -p /var/spool/cron/crontabs && touch /var/log/cron/cron.log && mkdir -m 0644 -p /etc/cron.d

# Move the required scripts and directories to the image
RUN mkdir /cloudflare-ddns
COPY cloudflare-ddns.py /cloudflare-ddns

RUN mkdir /cloudflare-ddns/zones
COPY zones/* /cloudflare-ddns/zones

RUN mkdir /cloudflare-ddns/logs

# Create symbolic links for easier mounting
RUN ln -s /cloudflare-ddns/zones /zones && ln -s /cloudflare-ddns/cloudflare-ddns.py /cloudflare-ddns.py

# Install requirements for ddns script and clean up
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt && rm requirements.txt

# Declare volumes
VOLUME /zones

# Cron's entry and cmd (proper logging should be implemented here for the ddns, i think)
ENTRYPOINT ["/docker-entry.sh"]
CMD ["/docker-cmd.sh"]
