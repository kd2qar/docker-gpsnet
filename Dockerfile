##
ARG PORT
ARG GPSD_SERVER
ARG HOSTIP

FROM alpine

ENV PORT=${PORT:-50505}
ENV GPSD_SERVER=${GPSD_SERVER:-roan}
ENV HOSTIP=${HOSTIP}

RUN apk add gpsd-clients nmap-ncat

COPY --chmod=755 <<-CATIT /bin/catit
	#!/bin/sh
	echo \"GPS Server: $GPSD_SERVER\"
	echo \"Listening on Port: $PORT\"
	echo \"Listening on Addr: $HOSTIP\"
	ncat -l -k -p $PORT -e \"/usr/bin/gpspipe -r $GPSD_SERVER\"
	CATIT

ENTRYPOINT ["/bin/catit"]

#RUN if [ -f /sbin/apk ]; then apk add bash; fi
#CMD ["/bin/bash"]
