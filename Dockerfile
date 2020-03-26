FROM python:3.6-alpine3.11

RUN apk update && apk add dcron curl wget rsync ca-certificates git

RUN mkdir -p /var/log/cron && mkdir -m 0644 -p /var/spool/cron/crontabs && touch /var/log/cron/cron.log && mkdir -m 0644 -p /etc/cron.d

RUN git clone https://github.com/xescure/cloudflare-ddns.git /cloudflare-ddns
RUN pip install -r /cloudflare-ddns/requirements.txt


#COPY scripts/* /

COPY zones/* /cloudflare-ddns/zones

RUN ln -s /cloudflare-ddns/zones /zones && ln -s /cloudflare-ddns/cloudflare-ddns.py /cloudflare-ddns.py

VOLUME /zones

RUN apk del git && rm -rf /var/cache/apk/*

ENTRYPOINT ["/docker-entry.sh"]
CMD ["/docker-cmd.sh"]
