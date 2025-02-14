##
FROM debian:bullseye-slim as BUILDER

RUN apt-get update; apt-get install -y man manpages man-db manpages-dev less;

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y install --no-install-recommends vim aptitude nmap
RUN apt-get -y install --no-install-recommends git

RUN <<BULLSEYE
 dpkg-query -l libgps* gpsd*
#.....
 apt-get -y purge gpsd libgps28
#Then update your system, and install the packages required by gpsd:

 apt-get update
# apt-get dist-upgrade
# reboot
 apt-get -y install scons libncurses-dev python-dev pps-tools
apt-get -y install git-core
 apt-get -y install build-essential manpages-dev pkg-config
#If "apt-get install scons …​" fails, check the file "/etc/apt/sources.list".

#Git-core is required to build from a git repository. pps-tools is for PPS timing. Build-essential installs the compiler and associated tools. Manpages-dev is for the associated man pages. Pkg-config is a helper for scons.

#Gtk3 is only required to run xgps and xgpsspeed. You do not need a local X11 server installed, but it still pulls in a lot of packages.

 apt-get -y install python-gi-dev
 apt-get -y install libgtk-3-dev
#Ubxtool and zerk may optionally use the pyserial module for direct connection to the GNSS receiver:

 apt-get -y install python3-serial
#gpsd may optional connect to dbus with the libdbus package:

 apt-get -y install libdbus-1-dev
#gpsplot uses matplotlib, which is in the package python3-matplotlib.

 apt install-y  python3-matplotlib
#Several programs written in Python (xgps, xgpsspeed, etc.) are installed locally. So if you intend to use them, set your PYTHONPATH. You may wish to add it to your shell’s log-in scripts to make it permanent. For more information on PYTHONPATH, see: https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH

#Something like this, but see the output from the "scons install" command and other scons commands.

export PYTHONPATH=${PYTHONPATH}:/usr/local/lib/python3/dist-packages
#Some very old Garmin USB devices need libusb:

 apt-get -y install libusb-1.0-0-dev
#If you wish to build the documentation, be warned it pulls in a lot of packages. Build the documentation is a prerequisite to building the HTML files for the website (www/), and also to make a source tarball (scons dist). To install the tools to build the documentation:

apt-get -y install asciidoctor
#The rest of the installation is just as for any other source based install:

 git clone https://gitlab.com/gpsd/gpsd.git
 cd gpsd
 scons -c && scons && scons check && scons install

BULLSEYE

#RUN apt-get -y install gpsd-clients
RUN apt-get -y install socat ncat
RUN apt-get -y install --no-install-recommends gpsd-tools 
#RUN apt-get -y install bsdmainutils
#RUN apt-get -y install netcat-traditional
RUN apt-get -y install net-tools
WORKDIR /gps
RUN <<-LOCATE
	apt-get -y install --no-install-recommends locate
	updatedb
	LOCATE

WORKDIR /gps


COPY <<-ALIASES /root/.bash.aliases
	alias ls='ls --color'
	alias ll='ls -Alh'
	ALIASES

COPY <<-"BASHRC" /root/.bashrc
	# ~/.bashrc: executed by bash(1) for non-login shells.
	
	# Note: PS1 and umask are already set in /etc/profile. You should not
	# need this unless you want different defaults for root.
	# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
	# umask 022
	
	# You may uncomment the following lines if you want `ls' to be colorized:
	export LS_OPTIONS='--color=auto'
	# eval "$(dircolors)"
	alias ls='ls --color'
	alias ll='ls -Alh'
	# alias l='ls $LS_OPTIONS -lA'
	#
	# Some more alias to avoid making mistakes:
	# alias rm='rm -i'
	# alias cp='cp -i'
	# alias mv='mv -i'
	BASHRC
FROM debian:bullseye-slim

COPY --from=BUILDER /usr/local/bin/gpspipe /bin/gpspipe
RUN <<-INSTALL
	apt-get update;
	apt-get -y install --no-install-recommends ncat
	rm -rf /var/lib/apt/lists
	INSTALL

COPY --chmod=755 <<-"CATIT" /bin/catit
	#!/bin/bash
	nc -l -k -p 50505 -e "/bin/gpspipe -r roan"
	CATIT

ENTRYPOINT ["nc","-lk","-p","50505","-e","/bin/gpspipe -r roan"]



#CMD ["/bin/bash"]
