# Brings up the Haskell Tooling as a Docker container.
# Use make shell to get an interactive shell.
#

CONTAINER="docker_haskell_1"

all: up 

up:
	xhost +LOCAL:
	mkdir -p ~/lib/haskell/.cabal ~/lib/haskell/.local ~/lib/haskell/.stack ~/lib/haskell/usr/local
	docker-compose up --detach

down:
	sync
	docker-compose down

# If problems persist after a force-down then manually restart Docker daemon.
force-down:
	sync
	docker rm -f $(CONTAINER)

ls:
	docker ps -a

images:
	docker images

rebuild:
	docker-compose build --no-cache

build:
	docker-compose build

attach:
	xhost +LOCAL:
	docker attach $(CONTAINER)

shell:
	xhost +LOCAL:
	docker exec -it $(CONTAINER) /bin/bash
