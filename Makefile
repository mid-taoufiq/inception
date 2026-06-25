DOCKERCOMPOSE=docker compose -f srcs/docker-compose.yml
up:
	${DOCKERCOMPOSE} up -d --build

down:
	${DOCKERCOMPOSE} down

clean:
	${DOCKERCOMPOSE} down --rmi all -v
	rm -rf /home/tibarike/data/wordpress/*
	rm -rf /home/tibarike/data/mariadb/*

re: clean up
