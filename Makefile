TAG=kd2qar/gpscat

all: build

build:
	docker compose build --pull --build-arg GPSD_SERVER=roan

up: build
	docker compose up --remove-orphans -d

run: up

shell: build
	docker compose run --rm -i --service-ports gpsnet

remove:
	docker stop gpsnet || true
	docker rm gpsnet || true

