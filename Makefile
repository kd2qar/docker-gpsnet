TAG=kd2qar/gpscat

all: build

build:
	docker compose build --pull --build-arg GPSD_SERVER=roan

up: build
	docker compose up --remove-orphans -d

run: up

shell: build
	docker compose run --rm -i --service-ports gpsnet

ck: cknmea

cknmea: cknmea.c Makefile
	gcc -o cknmea cknmea.c 
	./cknmea "GPGLL,3723.2475,N,12158.3416,W,161229.487,A,A"
	@echo ""
	./cknmea "GPGLL,5300.97914,N,00259.98174,E,125926,A"
	./cknmea "GPGSA,A,3,28,25,10,31,02,32,,,,,,,2.91,1.56,2.46"

remove:
	docker stop gpsnet || true
	docker rm gpsnet || true

