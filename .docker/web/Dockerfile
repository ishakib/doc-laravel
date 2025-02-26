# pull official base image
FROM node:22.5-alpine

ARG SERVER_ENVIRONMENT
# Add Repositories
RUN rm -f /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/community" >> /etc/apk/repositories

RUN apk update && apk add --no-cache  \
    libzip-dev \
    bzip2-dev \
    libwebp-dev \
    zip \
    bash \
    icu-dev \
    zlib-dev \
    curl-dev \
    git \
    vim

RUN npm install --global pm2


COPY ./web /usr/src/web
COPY ./.docker/web/init.sh /usr/src/init.sh

WORKDIR /usr/src/web

RUN yarn install -f
#RUN npm install
RUN chmod +x /usr/src/init.sh

#RUN npm run build
RUN yarn build
EXPOSE 3000

#USER node
ENTRYPOINT ["/usr/src/init.sh"]