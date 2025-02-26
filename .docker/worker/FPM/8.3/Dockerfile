FROM php:8.3-fpm-alpine

ARG SERVER_ENVIRONMENT
ARG APP_DIR=/var/www/app

# Setup Working Dir
WORKDIR $APP_DIR

RUN set -ex \
  && apk --no-cache add \
    postgresql-dev \
    make

# Add Repositories
RUN rm -f /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories

# fix work iconv library with alpine
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Add Build Dependencies
RUN apk add --no-cache \
    php82-pear \
    libwebp-dev \
    libzip-dev \
    libjpeg-turbo-dev \
    libjpeg-turbo \
    libpng-dev \
    libxpm-dev \
    php82-dev gcc \
    zlib-dev \
    curl-dev \
    imagemagick \
    imagemagick-dev \
    freetype-dev \
    icu-dev \
    g++ \
    npm \
    zip \
    vim \
    nano \
    supervisor

# Configure & Install Extension
RUN docker-php-ext-install -j "$(nproc)" \
    curl \
    pgsql \
    pdo \
    pdo_pgsql \
    bcmath \
    zip


RUN docker-php-ext-configure intl && \
    docker-php-ext-install intl &&\
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql


RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure pcntl --enable-pcntl \
  && docker-php-ext-install pcntl

#Install Redis
RUN pecl install redis && docker-php-ext-enable redis

# Install Build Tools
RUN apk add --no-cache build-base

# Install Imagick PHP extension
RUN apk update && apk upgrade

#RUN pecl install imagick && docker-php-ext-enable imagick
RUN apk add git --update --no-cache && \
    git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick && \
    cd /tmp/imagick && \
    git fetch origin master && \
    git switch master && \
    cd /tmp/imagick && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    docker-php-ext-enable imagick

# Configure and enable OPCache extension
RUN docker-php-ext-configure opcache --enable-opcache
RUN docker-php-ext-install opcache
# Add Composer lastest version
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

## Crontab
RUN apk update
RUN touch /var/log/cron.log
COPY ./.docker/worker/FPM/8.3/cron /etc/cron.d/cron
RUN chmod -R 755 /etc/cron.d/cron

RUN /usr/bin/crontab /etc/cron.d/cron


## Supervisor
COPY ./.docker/worker/FPM/8.3/worker.conf /etc/supervisor/conf.d/worker.conf
COPY ./.docker/worker/FPM/8.3/supervisord.conf /etc/supervisord.conf
RUN chmod -R 644 /etc/supervisor/conf.d/worker.conf

RUN chmod -R 644 /etc/supervisord.conf
RUN touch /tmp/supervisor.sock
RUN chmod 777 /tmp/supervisor.sock


COPY ./.docker/worker/FPM/8.3/php.ini $PHP_INI_DIR/conf.d/

RUN curl -sS https://getcomposer.org/installer | \
php -- --install-dir=/usr/bin/ --filename=composer
#
ENV COMPOSER_ALLOW_SUPERUSER=1


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]