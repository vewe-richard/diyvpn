#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include "diyvpn.h"


void usage(void)
{
	fprintf(stderr, "Usage: diyvpn [-s|-c ip] [-p port]\n");
}

int main(int argc, char * argv[])
{
	char c;
	bool enableserver = false;
	bool enableclient = false;
	char ipaddr[30];
	int port = 23;


	while( ( c = getopt(argc, argv, "sc:p:") ) != -1)
	{
		switch( c )
		{
			case 's':
				enableserver = true;
				break;
			case 'c':
				enableclient = true;
				memset(ipaddr, 0, 30);
				snprintf(ipaddr, 29, "%s", optarg);
				break;
			case 'p':
				port = atoi(optarg);
				break;
			default:
				usage();
				break;
		}
	}
	if(enableserver)
	{
		vpnserver(port);
	}
	else if(enableclient)
	{
		vpnclient(ipaddr, port);
	}
	else
		usage();
	return 0;
}


