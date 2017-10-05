FROM php:7.1-apache

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
&& apt-get install --no-install-recommends --no-install-suggests -y libpng-dev libjpeg-dev libfreetype6-dev libjpeg62-turbo-dev libmagic-dev libexif-dev file libmcrypt-dev libbz2-dev libldap2-dev libxslt1-dev libxml2-dev libtidy-dev jq bzip2 \
&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ >/dev/null \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ >/dev/null \
&& docker-php-ext-install opcache pdo_mysql mysqli gd exif zip bz2 ldap bcmath calendar mcrypt xsl xmlrpc soap tidy sockets gettext >/dev/null \
&& pecl install apcu \
&& docker-php-ext-enable apcu \
&& echo 'extension=apcu.so' > /usr/local/etc/php/conf.d/apcu.ini \
&& a2enmod rewrite headers \
&& a2dismod status \
&& apt-get clean ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* /usr/share/doc/*

