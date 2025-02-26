#!/bin/sh
set -e

#chown -R www-data:www-data /var/www/admin/storage/

php-fpm
#php /var/www/admin/artisan queue:work
