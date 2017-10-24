FROM php:7.1-fpm

LABEL maintainer="Ruzhentsev Alexandr <git@pgallery.ru>"
LABEL version="1.0 beta"
LABEL description="Docker image PHP 7.1 for pGallery project"

RUN apt-get update && apt-get -y upgrade && apt-get install -y git libmemcached-dev libpng12-dev libjpeg-dev libfreetype6-dev libgd-dev libpq-dev \
        libcurl4-gnutls-dev libicu-dev libxml2-dev libxslt1-dev libbz2-dev libzip-dev libmcrypt-dev libmagick++-dev libssh-dev librabbitmq-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && pecl install imagick amqp \
    && docker-php-ext-install bcmath bz2 calendar curl dom fileinfo gd gettext gettext iconv intl json mcrypt opcache pdo pdo_mysql \
        pdo_pgsql phar soap xml xmlrpc xsl zip \
    && git clone https://github.com/php-memcached-dev/php-memcached memcached \
    && ( \
        cd memcached && git checkout php7 && phpize \
        && ./configure --with-php-config=/usr/local/bin/php-config \
        && make -j$(nproc) && make install \
    ) \
    && rm -r memcached \
    && git clone https://github.com/phpredis/phpredis.git \
    && ( \
        cd phpredis && phpize \
        && ./configure \
        && make -j$(nproc) && make install \
    ) \
    && rm -r phpredis \
    && docker-php-ext-enable redis memcached imagick amqp \
    && apt-get purge --auto-remove -y gcc make \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN rm -rf /usr/src/php.tar.xz

COPY config/php-fpm.conf 	/usr/local/etc/php-fpm.conf
COPY config/www.conf 		/usr/local/etc/php-fpm.d/www.conf
COPY config/php.ini 		/usr/local/etc/php/php.ini
COPY config/opcache.ini 	/usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
