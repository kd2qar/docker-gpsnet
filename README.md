# docker-gpsnet
connects to a gpsd instance and streams the NMEA data via tcp/ip
This is, primiarily, intented to to be compatible with the Winlink 
tcp/ip gps option. 
Under settings--\>GPS Position Reports
select "TCP/IP" for the serial port
Fill in your host IP and port in the "IP Address" and "IP Port" fields.
![position report sample ](images/GPS_Position_Report.jpg?raw=true "Winlink Position Report")


You can also verify that your stream is working by using telnet to connect the the host/port:

For example, if your container is connected to the address 192.168.1.12 on port 50505.
connect to 
	telnet 192.168.1.12 50505
and you should see the NMEA data stream.

modify the docker-compose.yaml file to reflect your local network:
Use the anchor variables at the beginning of the file:
gpsid_server:	the server with the gps device attached and running gpsd
				you will need to expose the gpsd port (2947) on the local network
				so it can be polled by this container unless the container is running
				on the same server.
hostip:			the ip address on the docker host that will serve up the data
port:			the port on the docker host serving NMEA data stream

multiple clients should be able to connect..

modify docker-compose.yaml:

	`x-anchors: # CREATE ANCHOR VARIABLES SPECIFIC TO LOCAL ENVIRONMENT  
	  port: &port 50505  
	  HOSTIP: &hostip 192.168.1.12  
	  GPSD_SERVER: &gpsd_server 192.168.1.15  
	  CONTAINER: &container gpsnet`  


