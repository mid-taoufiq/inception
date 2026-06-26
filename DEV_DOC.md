# Developer Documentation
 
This document explains how to set up, build, and maintain the Inception project as a developer.

## 1. Prerequisites
 
- A Linux Virtual Machine (developed/tested on Kali Linux).
- Docker Engine and Docker Compose plugin installed.
- `make` installed.
- A `git` client, with the repository cloned locally.

## 2. Configuration files
 
Before building, set up the following (not tracked by Git):
 
### `srcs/.env`
 
Holds all configuration consumed by `docker-compose.yml`, including passwords:
 
```env
#Mariadb
MARIADB_PORT=3306
MYSQL_ROOT_PASS=<mysql_root_password>
MYSQL_DB=inception_database
MYSQL_USR=<mysql_user_name>
MYSQL_USR_PASS=<mysql_user_password>

#Wordpress
WP_URL=tibarike.42.fr
WP_TITLE=inception
WP_ADMIN=<wp_admin_name>
WP_ADMIN_PASS=<wp_admin_password>
WP_ADMIN_EMAIL=<wp_admin_email>
WP_USR=<wp_user_name>
WP_USR_EMAIL=<wp_user_email>
WP_USR_PASS=<wp_user_password>

#FTP
FTP_USR=<ftp_user_name>
FTP_PASS=<ftp_user_password>
```
 
This file must be added to `.gitignore` so no password ever ends up in the Git
repository.

### `/etc/hosts`
 
Add a line pointing the domain to your local machine:
 
```
127.0.0.1   tibarke.42.fr
```

## 3. Building and launching the project
 
The `Makefile` at the repository root drives everything:
 
```bash
make			# build images from scratch and start all containers via docker compose
make up			# same as make
make down		# stop and remove containers, keep volumes/data
make clean		# stop everything and remove images and volumes (destructive)
make re			# remove images and volumes and rebuild from scratch
```

## 4. Managing containers and volumes
 
### Containers
 
```bash
docker ps                       # list running containers
docker logs <container>			# follow logs for a given service
docker exec -it <container> sh  # open a shell inside a running container
docker inspect <container>      # see full config/state (env vars, mounts, network, etc.)
```
 
Service names match container/image names: `nginx`, `wordpress`, `mariadb`, `ftp`,
`adminer`, `redis`, `static_site`, `webserv`.
 
### Volumes
 
```bash
docker volume ls                       # list all named volumes
docker volume inspect wordpress_data   # see mountpoint/metadata for a volume
```
 
Both `wordpress_data` (website files) and `mariadb_data` (database) are Docker
**named volumes** (bind mounts are not used, per project rules), and are configured
in `docker-compose.yml` to physically store their data under
`/home/tibarke/data` on the host.

## 5. Where project data is stored and how it persists
 
- **WordPress files** (themes, plugins, uploads, core files) live in the
  `wordpress_data` named volume, mounted into the `wordpress` and `nginx` containers,
  and physically backed by `/home/tibarke/data/wordpress` on the host.
- **MariaDB data** (the actual database files) lives in the `mariadb_data` named
  volume, mounted into the `mariadb` container, backed by
  `/home/tibarke/data/mariadb` on the host.
- Because these are named volumes (not container filesystems), running `make down`
  and `make up` again does **not** lose data — only `make fclean` (or manually
  removing the volumes with `docker volume rm`) does.
- Container restart policy is set to `restart: always` (or `on-failure`) in
  `docker-compose.yml` so that any crashed container is automatically restarted by
  the Docker daemon without manual intervention.