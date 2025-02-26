FROM php:8.2-cli-alpine

# Add Repositories
RUN rm -f /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories

# Add Build Dependencies
RUN apk update && apk add --no-cache  \
    libzip-dev \
    libmcrypt-dev \
    libjpeg-turbo-dev \
    libjpeg-turbo \
    jpeg-dev \
    libpng-dev \
    libxml2-dev \
    bzip2-dev \
    libwebp-dev \
    zip \
    jpegoptim \
    pngquant \
    optipng \
    icu-dev \
    freetype-dev \
    libpq \
    zlib-dev \
    imap-dev \
    git \
    vim \
    openssl-dev \
    pcre-dev  \
    pcre2-dev \
    supervisor

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd
RUN docker-php-ext-configure pcntl --enable-pcntl \
  && docker-php-ext-install pcntl

RUN set -ex \
  && apk --no-cache add \
    postgresql-dev

# Configure & Install Extension
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install -j "$(nproc)" \
    opcache \
    pdo \
    pdo_pgsql \
    pgsql


RUN apk add --update --no-cache autoconf g++ make \
&& pecl install redis \
&&  docker-php-ext-enable redis

RUN pecl install swoole-5.1.1 && docker-php-ext-enable swoole

## Crontab
RUN apk update
RUN touch /var/log/cron.log
COPY .docker/worker/Octane/8.2/cron /etc/cron.d/cron
RUN chmod -R 755 /etc/cron.d/cron

RUN /usr/bin/crontab /etc/cron.d/cron


## Supervisor

COPY .docker/worker/Octane/8.2/worker.conf /etc/supervisor/conf.d/worker.conf
COPY .docker/worker/Octane/8.2/supervisord.conf /etc/supervisord.conf
RUN chmod -R 644 /etc/supervisor/conf.d/worker.conf
RUN chmod -R 644 /etc/supervisord.conf
RUN touch /tmp/supervisor.sock
RUN chmod 777 /tmp/supervisor.sock


COPY .docker/worker/Octane/8.2/php.ini $PHP_INI_DIR/conf.d/

# Setup Working Dir
WORKDIR /var/www/app

RUN curl -sS https://getcomposer.org/installer | \
php -- --install-dir=/usr/bin/ --filename=composer
#
ENV COMPOSER_ALLOW_SUPERUSER=1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]