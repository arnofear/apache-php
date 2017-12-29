FROM php:7.1-apache

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
&& apt-get install --no-install-recommends --no-install-suggests -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmagic-dev \
    libmagickwand-dev \
    libexif-dev \
    libgmp-dev \
    file \
    libmcrypt-dev \
    libbz2-dev \
    libldap2-dev \
    libxslt1-dev \
    libxml2-dev \
    libtidy-dev \
    jq \
    bzip2 \
    libicu-dev \
    libpq-dev \
&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/ \
&& docker-php-ext-configure gmp \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ >/dev/null \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ >/dev/null \
&& docker-php-ext-configure wddx >/dev/null \
&& docker-php-ext-install -j$(nproc) opcache mysqli pdo_mysql pgsql pdo_pgsql gd exif zip bz2 ldap bcmath calendar mcrypt xsl xmlrpc soap tidy sockets gettext gmp wddx intl shmop sysvmsg sysvsem sysvshm >/dev/null \
&& pecl install apcu >/dev/null \
&& pecl install redis >/dev/null \
&& pecl install imagick >/dev/null \
&& docker-php-ext-enable apcu redis imagick \
&& a2enmod rewrite headers \
&& a2dismod status \
&& echo 'Europe/Paris' > /etc/timezone \
&& dpkg-reconfigure -f noninteractive tzdata \
&& apt-get clean ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* /usr/share/doc/*
