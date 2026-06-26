# User Documentation
 
This document explains how to use the Inception stack.

## 1. What this stack provides
 
Visiting **https://tibarke.42.fr** gives you access to a WordPress website, served securely over HTTPS. Behind the scenes, the stack also provides:
 
- A **WordPress admin panel** to manage the site's content.
- An **Adminer** interface to inspect the WordPress database directly.
- An **FTP server** to upload/download website files.
- A **Redis cache** that speeds up the site (no direct user interaction needed).
- A separate **static website** with its own address.
- A custom **Webserv** HTTP server, used for an additional bonus service.

## 2. Starting and stopping the project
 
From the project's root directory:
 
- **Start everything**:
```bash
  make
```
- **Stop everything** (containers stopped, data kept):
```bash
  make down
```
- **Stop and remove all data** (use with care — wipes the database and WordPress
  files):
```bash
  make clean
```
 
You'll know it's running when `docker ps` lists containers named `nginx`, `wordpress`,
`mariadb`, `ftp`, `adminer`, `redis`, `static_site`, and `webserv`, all with status
`Up`.

## 3. Accessing the website and admin panel
 
- **Website**: open `https://tibarke.42.fr` in your browser. Your browser may warn about a self-signed certificate — this is expected in this local setup; accept the exception to continue.
- **WordPress admin panel**: go to `https://tibarke.42.fr/wp-admin` and log in with one of the two WordPress user accounts (see below).
- **Adminer (database UI)**: accessible at the dedicated Adminer URL/port configured in the stack. Log in using the MariaDB credentials stored in `srcs/.env` (see section 4).
- **Static site / Webserv**: each is reachable on its own dedicated port — check the `docker-compose.yml` `ports:` section or ask the developer for the exact URLs if they're not documented elsewhere on your deployment.

## 4. Locating and managing credentials
 
For security, no password is stored in plain text inside the Dockerfiles or the Git
repository. All credentials and configuration live in:
 
- **`.env` file** (`srcs/.env`): contains the domain name, database/service names, and all passwords (MariaDB, WordPress admin, FTP, etc.). This file is **not committed to Git** (create the file then copy paste from `DEV_DOC.md`).
There are two WordPress users:
- An **administrator** account (username does *not* contain "admin"/"administrator", per project rules).
- A second, regular user account. If you need to change a password, edit the relevant variable in `srcs/.env`, then restart the affected container(s) so the new value is picked up (see `DEV_DOC.md` for exact commands).
 
## 5. Checking that the services are running correctly
 
- **Quick check** — list running containers and their status:
```bash
  docker ps
```
  All services should show `Up` (not `Restarting` or `Exited`).
 
- **Check logs for a specific service** if something looks wrong:
```bash
  docker logs <container_name>
```
  For example: `docker logs wordpress`, `docker logs mariadb`, `docker logs ftp`.
 
- **Check the website itself**: load `https://tibarke.42.fr` — if it loads with a valid WordPress page, NGINX, php-fpm, and MariaDB are all working together correctly.
- **Check FTP**: connect with any FTP client to the configured FTP port using the credentials from `srcs/.env`; you should see the WordPress files. If a container keeps restarting, it's almost always either a misconfiguration in its `conf` files or a missing/incorrect environment variable — see `DEV_DOC.md` for troubleshooting steps.