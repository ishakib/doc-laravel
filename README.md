# docker-boilerplate

## Table of Contents
- [Introduction](#introduction)
- [Docker Services](#docker-services)
- [Requirements](#requirements)
- [Stop & Remove all the containers (optional)](#stop--remove-all-the-containers-optional)
- [Installation](#installation)
- [File Overview](#file-overview)
- [Setup Boilerplate App and Web for HTTPS](#setup-Boilerplate-app-and-web-for-https)
- [Setup Boilerplate App and Web for SSH](#setup-Boilerplate-app-and-web-for-ssh)
- [Browser Access](#browser-access)
- [Stopping Services](#stopping-services)

## Introduction
This is a Docker-based project for running an application and web services. It provides a convenient way to set up and run these services using Docker containers.

## Docker Services
- nginx
- app
- web
- worker
- database
- redis
- certbot
- mailhog

## Requirements
- Docker
- Docker Compose

## Stop & Remove all the containers (optional)
To stop and remove all Docker containers, you can run the following commands:

```shell
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

## Installation
1. Clone the project and navigate to the project directory:

   HTTPS:
   ```shell
   git clone https://github.com/example/docker-boilerplate.git
   cd docker-boilerplate
   ```

   SSH:
   ```shell
   git clone git@github.com:example/docker-boilerplate.git
   cd docker-boilerplate
   ```

## File Overview
The project structure looks like this:

```shell
docker-boilerplate
├── .docker
│   ├── nginx
│   │   ├── nginx.conf
│   │   ├── app
│   │   ├── web
│   ├── app
│   │   ├── FPM
│   │   ├── Octane
│   ├── admin
│   ├── worker
│   ├── postgres
├── .data
├── app
├── admin
├── web
├── .env.example
├── docker-compose.yml
```

## Example `.env` file
```shell
PHP_VERSION=8.3
DB_USERNAME=
DB_PASSWORD=
DB_DATABASE=
NGROK_AUTH=
NGROK_DOMAIN=
```

## Nginx Configuration

```shell
./.docker/nginx/app/FPM/local.conf:/etc/nginx/conf.d/default.conf
```

## Setup Boilerplate App and Web for HTTPS
```shell
git clone https://github.com/example/app.git app
git clone https://github.com/example/admin.git admin
git clone https://github.com/example/web.git web
cp .env.example .env
docker-compose up -d --build
docker-compose exec app php artisan migrate:fresh --seed
docker-compose exec admin php artisan migrate:fresh --seed
```

## Setup Boilerplate App and Web for SSH
```shell
git clone git@github.com:example/app.git app
git clone git@github.com:example/admin.git admin
git clone git@github.com:example/web.git web
cp .env.example .env
docker-compose up -d --build
docker-compose exec app php artisan migrate:fresh --seed
docker-compose exec admin php artisan migrate:fresh --seed
```

## Browser Access
Access the services in your browser at `http://localhost:80` or `Ngrok Domain`.

## Stopping Services
To stop all the services, run the command:
```shell
docker-compose down
```

## Ngrok & Cloudflare for Local Tunneling

### Ngrok
```shell
NGROK_AUTH=
NGROK_DOMAIN=
```

To start Ngrok tunneling:
```shell
cloudflared tunnel --url localhost:8008
```
To run in the background:
```shell
nohup cloudflared tunnel --url localhost:8008 &
```
To stop the process:
```shell
ps aux | grep cloudflared
pgrep cloudflared
kill PID
```

For custom domains, refer to Cloudflare documentation.

