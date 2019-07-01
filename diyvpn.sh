#!/bin/sh

servertundev=tun13
clienttundev=tun13
serverip=10.10.0.1
clientip=10.10.0.100
port=23
#debug=-d
debug=

#client specific
defaultrouter=192.168.22.1
hkserverip=47.75.45.219

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

stopclient() {
	echo "stop client."
	ip tuntap del mode tun $clienttundev
	ip route delete $hkserverip via $defaultrouter
	ip route delete default
	ip route add default via $defaultrouter
}

startclient() {
	echo "start client."
	stopclient
	ip tuntap add mode tun $clienttundev
	ip addr add $clientip/24 dev $clienttundev
	ip link set $clienttundev up
	ifconfig $clienttundev

	ip route add $hkserverip via $defaultrouter
	ip route delete default via $defaultrouter
	ip route add default via $serverip
	./simpletun -i $clienttundev -c $hkserverip -p $port $debug
	ip route delete default
	ip route add default via $defaultrouter
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


