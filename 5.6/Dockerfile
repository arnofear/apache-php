FROM php:5.6-apache

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Paris
# https://pecl.php.net/package/APCu
ENV PECL_APCU_VERSION 4.0.11

RUN apt-get update \
&& apt-get install --no-install-recommends --no-install-suggests -y \
    jq \
    libexif-dev \
    libpng-dev libjpeg-dev libfreetype6-dev libjpeg62-turbo-dev \
    libmagic-dev \
    libgmp-dev \
    libmcrypt-dev \
    libbz2-dev \
    libldap2-dev \
    libxslt1-dev \
    libxml2-dev \
    libtidy-dev \
    libicu-dev libpq-dev \
&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ \
&& docker-php-ext-configure gmp >/dev/null \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ >/dev/null \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ >/dev/null \
&& docker-php-ext-configure wddx >/dev/null \
&& docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    exif \
    gd \
    gettext \
    gmp \
    intl \
    ldap \
    mcrypt \
    mysqli \
    opcache \
    pdo_mysql \
    shmop sysvmsg sysvsem sysvshm \
    soap \
    sockets \
    tidy \
    wddx \
    xmlrpc \
    xsl \
    zip >/dev/null \
&& pecl install \
    apcu-$PECL_APCU_VERSION \
    redis >/dev/null \
&& docker-php-ext-enable apcu redis \
&& a2enmod rewrite headers \
&& a2dismod status \
&& sed -i 's/^ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf \
&& sed -i 's/^ServerTokens OS/ServerTokens Minimal/' /etc/apache2/conf-available/security.conf \
&& mkdir -p /var/lib/php/sessions \
&& chmod 1733 /var/lib/php/sessions \
&& echo 'Europe/Paris' > /etc/timezone \
&& dpkg-reconfigure -f noninteractive tzdata \
&& apt-get clean \
&& dpkg -l | awk '{print $2}' | grep '\-dev' | xargs apt-get remove --purge -y \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* /usr/share/doc /usr/share/man

COPY php.ini /usr/local/etc/php/php.ini

HEALTHCHECK --interval=30s --timeout=30s --start-period=0s --retries=3 CMD curl -o /dev/null -sm 10 http://localhost/ || exit 1
