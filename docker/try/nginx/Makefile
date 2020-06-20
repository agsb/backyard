# Set variables to pass
DOCKER_HOST := $(DOCKER_HOST)
DOCKER_HOST_IP := `docker run --net=host codenvy/che-ip:nightly`

auto-up:
	docker-compose up -d --build

up:
	docker-compose up -d

down:
	docker-compose down

clean:
	docker-compose down --remove-orphans --volumes

build:
	docker-compose build postgisdb
	docker-compose build pgadmindb
	docker-compose build geonetwork

sync: up

migrate:

wait:
	sleep 5

logs:
	docker-compose logs --follow

pull:
	docker-compose pull

#smoketest: up
#	docker-compose exec --noinput --nocapture --detailed-errors --verbosity=1 --failfast
#
#unittest: up

#test: smoketest unittest

reset: down up wait sync

hardreset: pull build reset

develop: pull build up sync

