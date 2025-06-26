# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adrgutie <adrgutie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/12 20:30:51 by adrgutie          #+#    #+#              #
#    Updated: 2025/06/26 13:38:44 by adrgutie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# # --- DEBUG MAKEFILE ---
# # This version prints all commands and will fail on any error.

# YML_FILE = ./srcs/docker-compose.yml
# COMPOSE_PROJECT_NAME = $(shell basename $$(dirname $(YML_FILE)))
# DB_VOLUME = $(COMPOSE_PROJECT_NAME)_db_data
# WP_VOLUME = $(COMPOSE_PROJECT_NAME)_wordpress_data
# COMPOSE = docker compose -f $(YML_FILE)

# all: up

# up:
# 	echo "Building and starting containers..."
# 	$(COMPOSE) up -d --build

# down:
# 	echo "Stopping and removing containers..."
# 	$(COMPOSE) down --remove-orphans

# clean:
# 	echo "--- RUNNING DEBUG CLEAN ---"
# 	echo "STEP 1: Stopping project..."
# 	$(COMPOSE) down --remove-orphans
# 	echo "STEP 2: Forcefully deleting DB volume ($(DB_VOLUME))..."
# 	docker volume rm -f $(DB_VOLUME)
# 	echo "STEP 3: Forcefully deleting WP volume ($(WP_VOLUME))..."
# 	docker volume rm -f $(WP_VOLUME)
# 	echo "--- DEBUG CLEAN FINISHED ---"

# fclean: clean
# 	echo "--- Pruning Docker system ---"
# 	docker system prune -af

# .PHONY: all up down clean fclean


# --- Variables ---
# Use variables to make the Makefile easy to read and modify.
COMPOSE_FILE = ./srcs/docker-compose.yml
WP_DATA_PATH = /home/adrgutie/data/wordpress
DB_DATA_PATH = /home/adrgutie/data/mariadb

# --- Main Rules ---
# The default rule when you just type 'make'
all: up

# Builds and starts the containers
up:
	@echo "STEP 1: Creating data directories if they don't exist..."
	@sudo mkdir -p $(WP_DATA_PATH)
	@sudo mkdir -p $(DB_DATA_PATH)
	@echo "STEP 2: Setting permissions for data directories..."
	@sudo chown -R 33:33 $(WP_DATA_PATH)
	@sudo chown -R 999:999 $(DB_DATA_PATH)
	@echo "STEP 3: Building and starting containers..."
	docker compose -f $(COMPOSE_FILE) up -d --build

# Stops the containers
down:
	@echo "Stopping containers..."
	docker compose -f $(COMPOSE_FILE) down --remove-orphans

# Stops containers and removes all associated data (a true factory reset)
fclean:
	@echo "--- RUNNING FULL CLEAN ---"
	@echo "STEP 1: Stopping and removing containers..."
	docker compose -f $(COMPOSE_FILE) down --remove-orphans -v
	@echo "STEP 2: Deleting host volume data..."
	@sudo rm -rf $(WP_DATA_PATH)
	@sudo rm -rf $(DB_DATA_PATH)
	@echo "STEP 3: Pruning Docker system..."
	@docker system prune -af
	@echo "--- FULL CLEAN FINISHED ---"

# Restarts the containers
re: fclean all

# Shows logs
logs:
	docker compose -f $(COMPOSE_FILE) logs -f

# --- Phony Rules ---
# Tells make that these are not files
.PHONY: all up down fclean re logs