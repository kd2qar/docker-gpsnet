##
FROM alpine

RUN apk add gpsd-clients nmap-ncat

COPY --chmod=755 <<-"CATIT" /bin/catit
	#!/bin/bash
	ncat -l -k -p 50505 -e "/usr/bin/gpspipe -r roan"
	CATIT

ENTRYPOINT ["ncat","-lk","-p","50505","-e","/usr/bin/gpspipe -r roan"]

#RUN if [ -f /sbin/apk ]; then apk add bash; fi
#CMD ["/bin/bash"]
