TAG=kd2qar/gpscat

all: build

build:
	docker compose build --pull

up:
	docker compose up --build -d

run: up

shell:
	docker compose run --build --rm -i --service-ports gpsnet

