# Set variables to pass

auto-up:
	docker-compose up -d --build

up:
	docker-compose up -d

down:
	docker-compose down $@

clean:
	docker-compose down --remove-orphans --volumes

build:
	docker-compose build $@

sync: up

migrate:

wait:
	sleep 5

logs:
	docker-compose logs --follow $@

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

