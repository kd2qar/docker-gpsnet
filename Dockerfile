##
ARG PORT=50505
ARG PORT_TEST=50506
ARG GPSD_SERVER=roan
ARG HOSTIP
ARG CONTAINER

FROM alpine AS base

FROM base AS builder
COPY cknmea.c .
RUN <<-BUILD
	apk add gcc build-base
	gcc -o cknmea cknmea.c
	apk del gcc build-base
	BUILD

FROM base
LABEL org.opencontainers.image.authors="Mark Vincett kd2qar@gmail.com"

ENV PORT=$PORT
ENV PORT_TEST=$PORT_TEST
ENV GPSD_SERVER=$GPSD_SERVER
ENV HOSTIP=$HOSTIP
ENV CONTAINER=$CONTAINER

RUN apk add gpsd-clients nmap-ncat

COPY --chmod=755 <<-"CATIT" /bin/catit1
	#!/bin/sh
	echo "GPS Server: ${GPSD_SERVER}"
	echo "Listening on Port: ${PORT}"
	echo "Listening on Addr: ${HOSTIP}"
	ncat -l -k -p $PORT -e "/usr/bin/gpspipe -r $GPSD_SERVER"
	CATIT

COPY cknmea.c .
RUN <<-BUILD
	apk add gcc build-base
	gcc -o cknmea cknmea.c
	apk del gcc build-base
	BUILD

COPY --from=builder --chmod=755  /cknmea /cknmea

COPY --chmod=755 nmeapump /bin/nmeapump

COPY --chmod=755 <<-"PUMPIT" /bin/catit2
	#!/bin/sh
	echo "GPS Server: ${GPSD_SERVER}"
	echo "Listening on Port: ${PORT}"
	echo "Listening on Addr: ${HOSTIP}"
	ncat -l -k -p $PORT -e "/usr/bin/gpspipe -r $GPSD_SERVER" &
	ncat -l -k -p $PORT_TEST -e /bin/nmeapump
	PUMPIT

## TEMPORARY UNTIL GPS IS BACK ON LINE
COPY --chmod=755 <<-"FAKEIT" /bin/catit3
	#!/bin/sh
	echo "GPS Server: ${GPSD_SERVER}"
	echo "Listening on Port: ${PORT_TEST}"
	echo "Listening on Addr: ${HOSTIP}"
	echo "USING /bin/nmeapump"
	#ncat -l -k -p $PORT -e "/usr/bin/gpspipe -r $GPSD_SERVER" &
	ncat -l -k -p $PORT_TEST -e /bin/nmeapump
	FAKEIT

#The options that can appear before CMD are:
#
#--interval=DURATION (default: 30s)
#--timeout=DURATION (default: 30s)
#--start-period=DURATION (default: 0s)
#--start-interval=DURATION (default: 5s)
#--retries=N (default: 3)
HEALTHCHECK --interval=200s --retries=5 CMD nc -z -w 1 localhost ${PORT}

ENTRYPOINT ["/bin/catit3"]

