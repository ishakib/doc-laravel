# jouleslabs-docker-boilerplate

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
Boilerplate-Docker is a Docker-based project for running the Boilerplate application and web services. It provides a convenient way to set up and run these services using Docker containers.

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
1. Clone the Boilerplate-Docker project and navigate to the project directory:

   HTTPS:
   ```shell
   git clone https://github.com/JoulesLabs/jouleslabs-docker-boilerplate.git
   cd jouleslabs-docker-boilerplate
   ```

   SSH:
   ```shell
   git clone git@github.com:JoulesLabs/jouleslabs-docker-boilerplate.git
   cd jouleslabs-docker-boilerplate
   ```

## File Overview
The project structure looks like this:

```shell
boilerplate-docker
├── .docker
│   ├── nginx
│   │   ├── nginx.conf
│   │   ├── app
│   │   │   └── FPM
│   │   │   |   └── local.conf
|   |   |   |   └── staging.conf
|   |   |   |   └── prod.conf
│   │   │   └── Octane
│   │   │       └── local.conf
|   |   |       └── staging.conf
|   |   |       └── prod.conf
|   |   |
│   │   ├── admin
│   │   |      └── local.conf
|   |   |      └── staging.conf
|   |   |      └── prod.conf
│   │   ├── web
│   │   |     └── local.conf
|   |   |     └── staging.conf
|   |   |     └── prod.conf
│   │   ├── shopify-app
│   │                └── local.conf
|   |                └── staging.conf
|   |                └── prod.conf
│   ├── app
│   │   └── FPM
│   │   |   └── ${PHP_VERSION}
│   │   |       └── Dockerfile
│   │   └── Octane
│   │       └── ${PHP_VERSION}
│   │           └── Dockerfile
│   │           └── other file
│   ├── admin
│   │   └── ${PHP_VERSION}
│   │       └── Dockerfile
│   │       └── other file
│   ├── web
│   │   └── Dockerfile
│   ├── worker
│   │   ├── FPM
│   │   │   └── ${PHP_VERSION}
│   │   │       └── Dockerfile
|   |   |       └── worker.conf
│   │   |       └── other file
│   │   └── Octane
│   │       └── ${PHP_VERSION}
│   │           └── Dockerfile
|   |           └── worker.conf
│   │           └── other file
│   ├── postgres
│   │   └── initdb
│   │       └── (init scripts if any)
├── .data
│   ├── nginx
│   │   └── logs
│   ├── redis
│   │   └── (redis data)
│   ├── logs
│   │   └── worker
│   ├── certs
│       └── certbot
│           ├── conf
│           └── www
├── app
│   └── (application code)
├── admin
│   └── (admin panel code)
├── web
│   ├── .env
│   └── (web application code)
├── make-ssl.example
├── deploy.sh.example
├── .gitignore
├── .env.example
└── docker-compose.yml

```
## For example / .env file
```shell
PHP_VERSION=8.3
DB_USERNAME=
DB_PASSWORD=
DB_DATABASE=
NGROK_AUTH= ngrok Your Authtoken key
NGROK_DOMAIN=ngrok domain (example.com)
```
## Nginx Configuration

Make sure you use the correct configuration file for either `FPM` or `Octane`:

```shell
./.docker/nginx/app/FPM/local.conf:/etc/nginx/conf.d/default.conf
```
## nginx
 This service uses the latest Nginx image to serve as a reverse proxy for other services. It mounts various configuration files and log directories, and exposes port 80 (and optionally port 443 for production).

## app
This service builds a Docker image for the main application from a specified Dockerfile and mounts the application code. It restarts automatically and is part of the application network.

## admin:
 Similar to the app service, this builds a Docker image for the admin panel from a specified Dockerfile and mounts the admin code. It also restarts automatically and is part of the application network.

## web:
 This service builds a Docker image for a web application, mounts the web application code, and sets up environment variables from a .env file. It exposes necessary volumes for node modules and next.js.

## redis:
 This service uses the latest Redis image to provide a Redis server. It mounts a data directory and exposes port 6379.

## worker:
 This service builds a Docker image for background workers using Supervisord. It mounts the application code, logs directory, and Supervisor configuration. It restarts automatically and is part of the application network.

## database:
 This service uses the Postgres 16 image to provide a PostgreSQL database. It sets up environment variables for the database user, password, and name, and mounts a data directory. It exposes port 5433 and restarts automatically.

## mailhog:
 This service uses the MailHog image for testing emails. It disables logging, exposes ports 1026 for SMTP and 8026 for the web UI, and is part of the application network.

## certbot:
 This service uses the Certbot image to handle SSL certificate renewal. It mounts directories for certificate configurations and renewal, and restarts automatically unless stopped.

## ngrok:
 This service uses the Ngrok image to create secure tunnels to the local Nginx server. It sets up the Ngrok authentication token and domain, and exposes port 4041.

## Volumes:
 This section defines volumes for pgdata and redis with local drivers to persist data.

## Networks:
 This section defines a custom bridge network named application_network.
## Nginx Cconfigureation port, depends_on, networks
Check your `docker-compose.yml`, `nginx service` block, and configure your `volumes` so that local setup files are mounted inside the Docker `nginx` container. configure your port, depends_on, networks for local, staging, prod.
```shell
    volumes:
      - ./.docker/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./.docker/nginx/app/FPM/local.conf:/etc/nginx/conf.d/default.conf
      - ./.docker/nginx/admin/local.conf:/etc/nginx/conf.d/admin.conf
      - ./.docker/nginx/web/local.conf:/etc/nginx/conf.d/web.conf
      - ./.data/nginx/logs:/var/log/nginx
      - ./app:/var/www/app
      - ./admin:/var/www/admin
      # - ./.data/certs/certbot/conf:/etc/letsencrypt # uncomment when production deploy
      # - ./.data/certs/certbot/www:/var/www/certbot # uncomment when production deploy
    ports:
      - "80:80"
      - "81:81"
      - "3000:300"
      # - "443:443" # uncomment when production deploy
    depends_on:
      - app
      - web
      - admin
    networks:
      - application_network
    environment:
      - X_SERVER_TYPE=nginx
```
## Setup Boilerplate App and Web for HTTPS
To set up Boilerplate App and Web for HTTPS, follow these steps:

```shell
git clone https://github.com/JoulesLabs/example.git app
git clone https://github.com/JoulesLabs/example.git admin
git clone https://github.com/JoulesLabs/example.git web
cp docker-compose.yml.example docker-compose.yml
cp .env.example .env 
cd app
cp .env.example .env && cd ..
cd admin
cp .env.example .env && cd ..
cd web
cp .env.example .env && cd ..
docker-compose up -d --build
docker-compose ps -a
docker-compose exec app php artisan migrate:fresh --seed
docker-compose exec admin php artisan migrate:fresh --seed
```

## Setup Boilerplate App and Web for SSH
To set up Boilerplate App and Web for SSH, follow these steps:

```shell
git clone git@github.com:JoulesLabs/example.git app
git clone git@github.com:JoulesLabs/example.git web
cp docker-compose.yml.example docker-compose.yml
cp .env.example .env 
cd app
cp .env.example .env && cd ..
cd admin
cp .env.example .env && cd ..
cd web
cp .env.example .env && cd ..
docker-compose up -d --build
docker-compose ps -a
docker-compose exec app php artisan migrate:fresh --seed
docker-compose exec admin php artisan migrate:fresh --seed
```

## Browser Access
Finally, access the services in your browser at `http://localhost:80` or `Ngrok Domain`.

## Stopping Services
To stop all the services, run the command:

```shell
docker-compose down
```
## Set up Ngrok & cloudflare for Local Tunneling to Public Access
## Ngrok

 Copy your `.env.example` file to `.env` file
 ```shell
NGROK_AUTH=
NGROK_DOMAIN=
 ```
Make sure you have access from local to public by using `Ngrok`. You must have an `Ngrok account` First, set up the `environment` variables `NGROK_AUTH=` and `NGROK_DOMAIN=`. and commnent out docker-compose.yml `service` block `ngrok`.

I have already installed the `all` Docker container. Available tools include `git`,and code editors `vim`, `nano`, and `vi`.

# Cloudflare Tunneling

### The Pros:
	- No bandwidth limit 
	- Easy to start 
	- No account / access token requires

### The Cons: 
	- Domain will be changes when process exited

Is have any solution of the Cons?
	Yes.
	We can fix the process exited issue
	And also the domain changed issue --requires to buy a domain


### Lets start ...

Installation 

```bash
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb

sudo dpkg -i cloudflared-linux-amd64.deb 

sudo apt-get install -f

```

Is installed ?

	cloudflared --version


#### Start tunneling :

`cloudflared tunnel --url localhost:8008`

NB: A serious note if your port is `localhost:80` then please only use ``cloudflared tunnel --url localhost`

### The Problem 
Now if I terminate the process from terminal then the domain will change again 😕 

### The solution

We will use a linux tool called `nohup` that stands for `no hangup` and it will solves us

```
nohup cloudflared tunnel --url localhost:8008 &
```

NB: The `&` at the end of the command makes the process run in the background. 

The nohup created a file called `nohup.out` in your current directory where you get the cloudflared tunneling logs.

**On nohup.out file you will find the tunneling domain also**.

#### Now how we stop the cloudflared process ?

```bash
#all running processes and filters for cloudflared

ps aux | grep cloudflared

# only PID(s)
pgrep cloudflared

# now kill the pid
kill PID

# for force kill 
kill -9 PID
```


### Now what we have limitation ?

- If you stop our computer or restart then the domain will change

## Is there any solution for this?

Yes we have but we need a custom domain and that need to config with cloudflare. But I think this our solution is enough. 

If you want to know more about the domain config related things, then go [here](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-local-tunnel/)

### Customization

- Replace `https://github.com/yourusername/yourrepository.git` with your actual repository URL.
- Adjust the directory structure and paths in the instructions if they differ.
- Add more sections as needed, such as **Troubleshooting**, **FAQ**, **Credits**, or **Contact**.
