FROM nextcloud:apache

RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends ffmpeg libmagickcore-6.q16-6-extra procps smbclient

RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends libbz2-dev libc-client-dev libkrb5-dev libsmbclient-dev; \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install bz2 imap; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient

RUN mkdir -p /srv/nextcloud/data; chown www-data /srv/nextcloud/data

RUN set -ex; \
    apt-get update && apt-get install -y supervisor; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir /var/log/supervisord /var/run/supervisord

COPY supervisord.conf /

ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]

