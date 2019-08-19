FROM php:7.3-apache

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
&& apt-get install --no-install-recommends --no-install-suggests -y \
    locales locales-all \
    supervisor \
    rsyslog \
    cron \
    wget iproute2 bind9-host iputils-ping less \
    jq unzip \
    libexif-dev \
    libpng-dev libjpeg-dev libfreetype6-dev libjpeg62-turbo-dev \
    libmagic-dev \
    libmagickwand-dev \
    libgmp-dev \
    libmcrypt-dev \
    libbz2-dev \
    libldap2-dev \
    libxslt1-dev \
    libxml2-dev \
    libtidy-dev \
    libicu-dev libpq-dev \
    libc-client-dev libkrb5-dev \
    libzip-dev \
&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ \
&& docker-php-ext-configure gmp >/dev/null \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ >/dev/null \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ >/dev/null \
&& docker-php-ext-configure wddx >/dev/null \
&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl >/dev/null \
&& docker-php-ext-configure zip --with-libzip=/usr/include \
&& docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    gmp \
    imap \
    intl \
    ldap \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    shmop sysvmsg sysvsem sysvshm \
    soap \
    sockets \
    tidy \
    wddx \
    xmlrpc \
    xsl \
    zip >/dev/null \
&& pecl install \
    apcu \
    redis \
    imagick >/dev/null \
&& docker-php-ext-enable apcu redis imagick \
&& a2enmod rewrite headers ssl \
&& a2dismod status \
&& a2ensite default-ssl.conf \
&& sed -i 's/^ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf \
&& sed -i 's/^ServerTokens OS/ServerTokens Minimal/' /etc/apache2/conf-available/security.conf \
&& mkdir -p /var/lib/php/sessions /usr/local/etc/php-cli \
&& chmod 1733 /var/lib/php/sessions \
&& ln -sfT /dev/stdout /var/log/cron.log \
&& echo 'Europe/Paris' > /etc/timezone \
&& dpkg-reconfigure -f noninteractive tzdata \
&& rm -f /etc/cron.*/* \
&& apt-get clean \
&& dpkg -l | awk '{print $2}' | grep '\-dev' | xargs apt-get remove --purge -y \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* /usr/share/doc /usr/share/man \
&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
&& ln -s $(composer config --global home) /root/composer

ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

ENV TZ=Europe/Paris
ENV LC_ALL fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8

#&& a2dissite 000-default.conf >/dev/null \
#COPY sites-enabled/* /etc/apache2/sites-enabled/
COPY ssl-cert-snakeoil.key /etc/ssl/private/
COPY ssl-cert-snakeoil.pem /etc/ssl/certs/

COPY php/php.ini /usr/local/etc/php/php.ini
# /usr/local/bin/php --php-ini /usr/local/etc/php-cli/php.ini -f /var/www/html/cli.php
COPY php/php-cli.ini /usr/local/etc/php-cli/php.ini

COPY supervisor/supervisord.conf /etc/supervisor/supervisord.conf
# ATTENTION cette conf execute le script de l'image php:7.1-apache : /usr/local/bin/apache2-foreground
COPY supervisor/apache2-foreground.conf /etc/supervisor/conf.d/apache2-foreground.conf
COPY supervisor/rsyslogd.conf /etc/supervisor/conf.d/rsyslogd.conf
COPY supervisor/cron.conf /etc/supervisor/conf.d/cron.conf

COPY rsyslog.conf /etc/rsyslog.conf

HEALTHCHECK --interval=30s --timeout=30s --start-period=1s --retries=3 CMD curl -o /dev/null -sm 10 http://localhost/ || exit 1

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

EXPOSE 80 443
