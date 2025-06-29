# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adrgutie <adrgutie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/12 20:30:51 by adrgutie          #+#    #+#              #
#    Updated: 2025/06/29 22:27:44 by adrgutie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- DEBUG MAKEFILE ---
# This version prints all commands and will fail on any error.

YML_FILE = ./srcs/docker-compose.yml
COMPOSE_PROJECT_NAME = $(shell basename $$(dirname $(YML_FILE)))
DB_VOLUME = $(COMPOSE_PROJECT_NAME)_db_data
WP_VOLUME = $(COMPOSE_PROJECT_NAME)_wordpress_data
COMPOSE = docker compose -f $(YML_FILE)

all: up

up:
	echo "Building and starting containers..."
	$(COMPOSE) up -d --build

down:
	echo "Stopping and removing containers..."
	$(COMPOSE) down --remove-orphans

clean:
	echo "--- RUNNING DEBUG CLEAN ---"
	echo "STEP 1: Stopping project..."
	$(COMPOSE) down --remove-orphans
	echo "STEP 2: Forcefully deleting DB volume ($(DB_VOLUME))..."
	docker volume rm -f $(DB_VOLUME)
	echo "STEP 3: Forcefully deleting WP volume ($(WP_VOLUME))..."
	docker volume rm -f $(WP_VOLUME)
	echo "--- DEBUG CLEAN FINISHED ---"

fclean: clean
	echo "--- Pruning Docker system ---"
	docker system prune -af

.PHONY: all up down clean fclean


