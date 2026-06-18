DOCKERCOMPOSE=docker-compose -f srcs/docker-compose.yml
up:
	${DOCKERCOMPOSE}  up -d --build
#-d for running containers in the background and give new prompt without terminal will be stuck watching the containers
#--build rebuilds the image from scratch without it if the umage already exist it will skip and not build it
down:
	${DOCKERCOMPOSE} down
clean:
	${DOCKERCOMPOSE} down --rmi local -v
#--rmi local removes all local image created locally with docker
fclean:
	${DOCKERCOMPOSE} down --rmi all -v
	docker system prune -af
	rm -rf /home/tibarike/data/wordpress/*
	rm -rf /home/tibarike/data/mariadb/*
#--rmi all removes all images local and base ones
re: fclean up
