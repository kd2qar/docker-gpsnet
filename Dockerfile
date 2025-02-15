##
FROM alpine

ARG CONT_IMG_VER
ENV CONT_IMG_VER=${CONT_IMG_VER:-v1.0.0}


ARG PORT
ARG GPSD_SERVER=roan

ENV PORT=${PORT:-50505}
ENV GPSD_SERVER=${GPSD_SERVER:-roan}

RUN apk add gpsd-clients nmap-ncat

COPY --chmod=755 <<-CATIT /bin/catit
	#!/bin/sh
	ncat -l -k -p $PORT -e \"/usr/bin/gpspipe -r $GPSD_SERVER\"
	CATIT

#ENTRYPOINT ["/usr/bin/ncat","-lk","-p",$PORT,"-e","/usr/bin/gpspipe -r $GPSD_SERVER"]
ENTRYPOINT ["/bin/catit"]

#RUN if [ -f /sbin/apk ]; then apk add bash; fi
#CMD ["/bin/bash"]
