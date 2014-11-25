#!/bin/sh
#
BR=$1
DEV=$2
MTU=$3
# Invoked as BR=br-vpn DEV=tap0 MTU=1500
/sbin/ifconfig $DEV mtu $MTU promisc up
/sbin/brctl addif $BR $DEV
