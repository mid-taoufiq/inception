*This project has been created as part of the 42 curriculum by tibarke.*

# Inception

## Description

Inception is a 42 school project where you build a small web infrastructure using Docker. Every service runs in its own container, built from a Dockerfile written from scratch.

The mandatory part sets up three containers, each running a single service:

- **NGINX** — the only entry point to the infrastructure, exposing port 443 with TLSv1.3 only.
- **WordPress + php-fpm** — the WordPress site logic, without its own web server.
- **MariaDB** — the database backend for WordPress.

On top of the mandatory part, the following **bonus services** have been added, each in
its own container with its own Dockerfile:

| Service | Purpose |
|---|---|
| **FTP (vsftpd)** | Provides FTP access to the WordPress volume for file management. |
| **Adminer** | Lightweight web UI to inspect/manage the MariaDB database. |
| **Redis** | Object cache for WordPress to reduce database load. |
| **Static site** | A standalone static website (non-PHP) served independently. |
| **Webserv** | A custom-built HTTP server (the "service of your choice" bonus). |

All **mandatory** containers as well as the **redis** and **adminer** containers, communicate over a dedicated Docker network (`inception`), and WordPress' files and database data are persisted using **named volumes** mounted on `/home/tibarke/data` on the host.

## Instructions

### Requirements

- A Linux Virtual Machine (this project was developed/run on Kali Linux).
- Docker and Docker Compose installed.
- `make` installed.

### How to execute

1. Clone the repository.
2. Create the environment file (see `DEV_DOC.md` for the exact file and variables expected). the env file is committed to Git.
3. Add an entry for the domain in `/etc/hosts` (or your local DNS) pointing `tibarke.42.fr` to `127.0.0.1`.
4. Build and start everything:
```bash
   make
```

5. Visit `https://tibarke.42.fr` in your browser.

## Resources

- [Docker official documentation](https://docs.docker.com/)
- [Docker Compose file reference](https://docs.docker.com/compose/compose-file/)
- [WordPress cli documentation](https://developer.wordpress.org/cli/commands/)
- [php-fpm documentation](https://docs.rockylinux.org/10/guides/web/php/)
- [MariaDB Docker documentation](https://mariadb.com/kb/en/installing-mariadb-with-docker/)
- [NGINX documentation on SSL/TLS configuration](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [vsftpd documentation](https://security.appspot.com/vsftpd.html)
- [Redis documentation](https://redis.io/docs/)
- [Adminer official site](https://www.adminer.org/)

### AI usage

AI was used to understand some concepts in this project and also helped to write the **README**, **USER_DOC** and **DEV_DOC** files.

## Project description: Docker, design choices & comparisons

### Why Docker for this project

Each service (NGINX, WordPress/php-fpm, MariaDB, and the bonus services) runs in its own container, built from its own Dockerfile. Containers talk to each other over a Docker network, and WordPress/MariaDB data is kept in named volumes so it survives restarts. This keeps each service isolated and easy to rebuild.

### Virtual Machines vs Docker

A VM virtualizes a whole machine, including its own kernel — that makes it heavier and slower to start. A Docker container shares the host's kernel and only packages the app itself, so it starts in seconds and uses much less disk/RAM. The tradeoff is that VMs isolate more strongly, since they don't share a kernel with the host. Here, Docker is the better fit because we need several lightweight services that rebuild fast; the VM is only used as the required host environment.

### Secrets vs Environment Variables
 Environment variables (in `.env`) are fine for normal config like the domain name or database name, but they're visible to anyone who inspects the container, so they're not ideal for passwords. Docker secrets are mounted as files inside the container instead, which keeps them hidden from that kind of inspection. This project uses `.env` for all configuration, including passwords; the `.env` file is not committed to Git.

### Docker Network vs Host Network
 `network: host` makes a container share the host's network directly — no isolation, it's forbidden by the subject. A custom Docker network keeps containers isolated, lets them reach each other by name (e.g. `mariadb`), and only exposes the ports we choose. This project uses a custom network so that only NGINX is reachable from outside, on port 443.

### Docker Volumes vs Bind Mounts
 A bind mount links a container directly to a specific folder on the host, which is simple but less portable and not managed by Docker. A named volume is fully managed by Docker, making it more reliable and easier to back up or move. The subject requires named volumes for the WordPress files and database, stored under `/home/tibarke/data` on the host, which this project follows.