DOCKERCOMPOSE=docker-compose -f srcs/docker-compose.yml
up:
	${DOCKERCOMPOSE} up --build

down:
	${DOCKERCOMPOSE} down

clean:
	${DOCKERCOMPOSE} down --rmi all -v
	rm -rf /home/tibarike/data/wordpress/*
	rm -rf /home/tibarike/data/mariadb/*

fclean:
	${DOCKERCOMPOSE} down --rmi all -v
	rm -rf /home/tibarike/data/wordpress/*
	rm -rf /home/tibarike/data/mariadb/*
	docker system prune -af

re: fclean up
