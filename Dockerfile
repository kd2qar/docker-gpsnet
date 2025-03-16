##
ARG PORT
ARG GPSD_SERVER
ARG HOSTIP
ARG CONTAINER

FROM alpine

MAINTAINER Mark Vincett kd2qar@gmail.com
LABEL org.opencontainers.image.authors="Mark Vincett kd2qar@gmail.com"

ENV PORT=${PORT:-50505}
ENV GPSD_SERVER=${GPSD_SERVER:-roan}
ENV HOSTIP=${HOSTIP}
ENV CONTAINER=${CONTAINER}

RUN apk add gpsd-clients nmap-ncat

COPY --chmod=755 <<-"CATIT" /bin/catit
	#!/bin/sh
	echo "GPS Server: ${GPSD_SERVER}"
	echo "Listening on Port: ${PORT}"
	echo "Listening on Addr: ${HOSTIP}"
	ncat -l -k -p $PORT -e "/usr/bin/gpspipe -r $GPSD_SERVER"
	CATIT

#The options that can appear before CMD are:
#
#--interval=DURATION (default: 30s)
#--timeout=DURATION (default: 30s)
#--start-period=DURATION (default: 0s)
#--start-interval=DURATION (default: 5s)
#--retries=N (default: 3)
HEALTHCHECK --interval=200s --retries=5 CMD nc -z -w 1 localhost ${PORT}

ENTRYPOINT ["/bin/catit"]

