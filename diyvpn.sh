#!/bin/sh

servertundev=tun13
clienttundev=tun13
serverip=10.10.0.1
clientip=10.10.0.100
port=23
debug=-d

startserver() {
	echo "start server."
	ip tuntap add mode tun $servertundev
	ip addr add $serverip/24 dev $servertundev
	ip link set $servertundev up
	ifconfig $servertundev
	./simpletun -i $servertundev -s -p $port $debug
}

stopserver() {
	echo "stop server."
	ip tuntap del mode tun $servertundev
}

startclient() {
	echo "start client."
}

stopclient() {
	echo "stop client."
}

usage() {
	echo "Usage: $0 [server|client] [start|stop]"
}


case "$1" in
	server)
		case "$2" in
			start)
				startserver
			;;

			stop)
				stopserver
			;;

			*)
				echo "unknown server command"
				usage
			;;
		esac
	;;

	client)
		case "$2" in
			start)
				startclient
			;;

			stop)
				stopclient
			;;

			*)
				echo "unknown client command"
				usage
			;;
		esac
	;;

	*)
		echo "unknown command"
		usage
	;;
esac


