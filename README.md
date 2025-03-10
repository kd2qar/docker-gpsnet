# docker-gpsnet
This container connects to a gpsd instance and streams the NMEA data via tcp/ip
This is, primiarily, intented to to be compatible with the Winlink 
tcp/ip gps option. 

You must have a local server with a gps device running gpsd. Configure the gpsd port to be available on the local network.
Modify the docker-compose.yaml file to point to the gpsd server and attach to a tcp port on the docker host.

modify docker-compose.yaml:

	x-anchors: # CREATE ANCHOR VARIABLES SPECIFIC TO LOCAL ENVIRONMENT  
 	  # Port other network clients will use to connect to your instance  
	  port: &port 50505  
   	  # IP Address of the docker host  
	  HOSTIP: &hostip 192.168.1.12  
   	  # ip address of the gpsd server on the local network  
	  GPSD_SERVER: &gpsd_server 192.168.1.15  
   	  # The name of the running container
	  CONTAINER: &container gpsnet  

You should be able to start your instance using

	docker compose up

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

## To Use with WINLINK
Under settings--\>GPS Position Reports
select "TCP/IP" for the serial port
Fill in your host IP and port in the "IP Address" and "IP Port" fields.

![position report sample ](images/GPS_Position_Report.jpg?raw=true "Winlink Position Report")


## To Use With Other Software (e.g. VARAC):

To provide this stream to other applications on Windows that expect a serial port, such as VARAC, you can create a virtual serial port using a tool like VSPE from Eterlogic that connects to the gps data stream:

Using Eterlogc Software <https://eterlogic.com/>

Create a virtual COM port:

![](images/VSPE-Select-Virtual-Connector.jpg?raw=true "Create Virtual Connector")
![](images/VirtualSerialPortCOM11.jpg?raw=true "Assign COM Port")

Create a TCP-Client and attch it to the new COM port:

![](images/VSPE-Select-TCP-Client.jpg?raw=true "Create TCP Client")
![](images/VSPE-TCP-Client.jpg?raw=true "Connect TCP Client to gpsnet service")


