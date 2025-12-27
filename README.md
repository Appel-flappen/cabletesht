# Cabletesht

A simple bash script to test that an ethernet cable reaches expected throughput.

Note that the throughput will never be higher than that of the slowest interface, even if you have a super fancy cat(n+1) cable!

## Requirements

1. An ethernet cable.
1. 2 network interfaces (can be usb).
1. `iperf3` and `ip` installed on your system.
1. Download this script and make it executable.

## How do

1. Plug ethernet cable into interface 1 and interface 2.
1. Run `ip link` and get the names of the two interfaces.
1. Run `cabletest.sh <interface 1> <interface 2>`
1. Observe the output.

## What it do

Based on the very useful answer by Thomas Tannhäuser
[here](serverfault.com/questions/127636/force-local-ip-traffic-to-an-external-interface/861465),
I just turned it into a script.

Sets up 2 network namespaces, brings up each interface with an IP, then runs
Iperf3 as a server and a client across the interfaces. At the end, or when
interrupted, cleans up by deleting the namespaces.

You may want to check that the IP address used will not conflict with your
network. The default IP addresses are 192.168.136.1 and 192.168.136.2.
