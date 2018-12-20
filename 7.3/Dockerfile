FROM php:7.3-fpm

LABEL maintainer="Ruzhentsev Alexandr <git@pgallery.ru>"
LABEL version="1.2"
LABEL description="Docker image PHP 7.3 for pGallery project"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade && apt-get install -y git locales libpng-dev libjpeg-dev libfreetype6-dev libgd-dev libpq-dev \
        libcurl4-gnutls-dev libicu-dev libxml2-dev libxslt1-dev libbz2-dev libzip-dev libmagick++-dev libssh-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr

RUN pecl install imagick

RUN docker-php-ext-install bcmath bz2 calendar curl dom fileinfo gd gettext gettext iconv intl json opcache pdo pdo_mysql \
        pdo_pgsql phar soap xml xmlrpc xsl zip

#RUN git clone https://github.com/php-memcached-dev/php-memcached memcached \
#    && ( \
#        cd memcached && git checkout php7 && phpize \
#        && ./configure --with-php-config=/usr/local/bin/php-config \
#        && make -j$(nproc) && make install \
#    ) \
#    && rm -r memcached

RUN git clone https://github.com/phpredis/phpredis.git \
    && ( \
        cd phpredis && phpize \
        && ./configure \
        && make -j$(nproc) && make install \
    ) \
    && rm -r phpredis

RUN docker-php-ext-enable redis imagick

RUN apt-get purge --auto-remove -y gcc make \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo "ru_RU.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ru_RU.UTF-8 UTF-8 && \
    dpkg-reconfigure locales

ENV LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

RUN rm -rf /usr/src/php.tar.xz

COPY config/php-fpm.conf 	/usr/local/etc/php-fpm.conf
COPY config/www.conf 		/usr/local/etc/php-fpm.d/www.conf
COPY config/php.ini 		/usr/local/etc/php/php.ini
COPY config/opcache.ini 	/usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
