#!/bin/bash

if1=$1
if2=$2
ip1=192.168.136.1
ip2=192.168.136.2

ip netns add test_server
ip netns add test_client

trap "echo 'cleaning up...' && ip netns del test_server && ip netns del test_client" EXIT

ip link set "$if1" netns test_server
ip link set "$if2" netns test_client

ip netns exec test_server ip addr add dev "$if1" $ip1/24
ip netns exec test_server ip link set dev "$if1" up
ip netns exec test_client ip addr add dev "$if2" $ip2/24
ip netns exec test_client ip link set dev "$if2" up

echo "server will be: $if1"
echo "client will be: $if2"

(
	trap 'kill 0' SIGINT EXIT
	ip netns exec test_server iperf3 -s -1 -B $ip1 &&
		sleep 1 &
	ip netns exec test_client iperf3 -c $ip1 -B $ip2 -T client &
	wait
)
