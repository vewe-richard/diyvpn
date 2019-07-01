#!/bin/sh

servertundev=tun13
clienttundev=tun13
serverip=10.10.0.1
clientip=10.10.0.100
port=21
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
	echo "Stop client."
	ip tuntap del mode tun $clienttundev
    echo "Change netplan yaml, the nameserver to 192.168.22.1"
    read -p "Continue: " unused
	vi /etc/netplan/50-cloud-init.yaml
	netplan apply --debug
	systemd-resolve --flush-caches
	systemd-resolve --statistics
}

startclient() {
	echo "Start client."
    if ip link show $clienttundev 2>&1 >/dev/null; then
		ip tuntap del mode tun $clienttundev
    fi

    echo "Change netplan yaml, the nameserver to 100.100.2.136"
    read  -p "Continue: " unused
	vi /etc/netplan/50-cloud-init.yaml
	netplan apply --debug
    read -p "Wait till netplan apply the default router: " unused
	ip tuntap add mode tun $clienttundev
	ip addr add $clientip/24 dev $clienttundev
	ip link set $clienttundev up
	ifconfig $clienttundev

	ip route add $hkserverip via $defaultrouter
	ip route delete default via $defaultrouter
	ip route add default via $serverip
	systemd-resolve --flush-caches
    ip route list
	./simpletun -i $clienttundev -c $hkserverip -p $port $debug
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


