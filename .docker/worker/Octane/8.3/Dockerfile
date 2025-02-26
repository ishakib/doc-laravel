FROM php:8.3-cli-alpine

ARG SERVER_ENVIRONMENT

RUN set -ex \
  && apk --no-cache add \
    freetype-dev \
    gmp-dev \
    icu-dev \
    libintl \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    linux-headers \
    postgresql-dev \
    $PHPIZE_DEPS \
    ; \
    docker-php-ext-configure gd \
        --with-freetype=/usr/include/ \
        --with-jpeg=/usr/include/

# Add Repositories
RUN rm -f /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories

# Fix work iconv library with alpine
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Add Build Dependencies
RUN apk update && apk add --no-cache \
    libmcrypt-dev \
    libjpeg-turbo \
    jpeg-dev \
    bzip2-dev \
    libwebp-dev \
    zip \
    jpegoptim \
    pngquant \
    optipng \
    libpq \
    zlib-dev \
    curl-dev \
    imap-dev \
    git \
    vim \
    openssl-dev \
    pcre-dev \
    pcre2-dev \
    supervisor

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure pcntl --enable-pcntl \
  && docker-php-ext-install pcntl

# Configure & Install Extension
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install -j "$(nproc)" \
    opcache \
    pdo \
    pdo_pgsql \
    pgsql

RUN apk add --update --no-cache autoconf g++ make \
&& pecl install redis \
&& docker-php-ext-enable redis

RUN pecl install swoole-5.1.1 && docker-php-ext-enable swoole

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
#RUN pecl install imagick && docker-php-ext-enable imagick
RUN apk add --no-cache \
    libheif \
    imagemagick-dev \
    imagemagick \
    pkgconfig \
    autoconf \
    g++ \
    make \
    && git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick \
    && cd /tmp/imagick \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable imagick
## Crontab
RUN apk update
RUN touch /var/log/cron.log
COPY .docker/worker/Octane/8.3/cron /etc/cron.d/cron
RUN chmod -R 755 /etc/cron.d/cron

RUN /usr/bin/crontab /etc/cron.d/cron

## Supervisor
COPY .docker/worker/Octane/8.3/supervisord.conf /etc/supervisord.conf
RUN chmod -R 644 /etc/supervisord.conf
RUN touch /tmp/supervisor.sock
RUN chmod 777 /tmp/supervisor.sock

COPY .docker/worker/Octane/8.3/php.ini $PHP_INI_DIR/conf.d/

# Setup Working Dir
WORKDIR /var/www/app

ENV COMPOSER_ALLOW_SUPERUSER=1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]