# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adrgutie <adrgutie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/12 20:30:51 by adrgutie          #+#    #+#              #
#    Updated: 2025/06/15 02:52:00 by adrgutie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

COMPOSE = docker compose
YML_FILE = ./srcs/docker-compose.yml

up:
	$(COMPOSE) -f $(YML_FILE) up -d --build

down:
	$(COMPOSE) -f $(YML_FILE) down

start:
	$(COMPOSE) -f $(YML_FILE) start

stop:
	$(COMPOSE) -f $(YML_FILE) stop

restart:
	$(MAKE) stop
	$(MAKE) up

re:
	$(MAKE) down
	$(MAKE) up

clean:
	$(COMPOSE) -f $(YML_FILE) down -v --remove-orphans

fclean: clean
	docker system prune -a --volumes -f

.PHONY: up down start stop restart clean fclean


