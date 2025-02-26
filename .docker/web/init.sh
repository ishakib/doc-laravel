#!/bin/sh
set -e

#mkdir \-p /run/nginx

cd /usr/src/web
if [ "$VITE_ENVIRONMENT" = "local" ]  || [ -z "${VITE_ENVIRONMENT}" ]
then
#  npm run dev
 yarn dev
else
#  npm install
#  yarn build
  HOST=0.0.0.0 pm2-runtime start yarn --interpreter bash --name web -- preview
#   pm2-runtime start npm -- start
fi