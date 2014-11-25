#!/bin/sh

#-----------------------------------------------------------#
# SERVER OPEN VPN INSTALLATION IN SEPARATE "VPN" NAMESPACE  #
#-----------------------------------------------------------#
echo ">> execute 'echo password | sudo -S ls -al' so that subsequent sudo commands do not require password"
echo ">> close the terminal afterwards since we now have unrestricted sudo access"

###############
# Assumptions #
###############
####################################################################
# 1. script is running in directory with all openvpn set up files
# 2. br0 bridge device already created
# 3. eth0 is already added to br0 in promiscous mode.
#    auto eth0
#    iface eth0 inet manual
#      up ifconfig $IFACE 0.0.0.0 up
#      up ip link set $IFACE promisc on
#      down ip link set $IFACE promisc off
#      down ifconfig $IFACE down
#    auto br0
#      iface br0 inet static
#      address 10.7.22.2
#      netmask 255.255.255.0
#      gateway 10.7.22.1
#      bridge_ports eth0
# 4. Install OpenVPN Certificates and Keys in openvpn dir 
#    sudo mv ca.crt asarcar.crt asarcar.key ta.key /etc/openvpn
# 5. Install Server Conf File and Scripts to openvpn dir:
#    sudo cp asarcar.conf up.sh down.sh /etc/openvpn
####################################################################

########################
# Install bridge-utils #
########################
sudo apt-get install -y bridge-utils

# Allow ipv4 forwarding via sysctl 
# OR update /proc/sys/net/ipv4/ip_forward
# sudo echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward > /dev/null
# For persistency update /etc/sysctl.conf
# by enabling net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.ip_forward=1

#######################
# Add Network NS: vpn #
#######################
sudo ip netns add vpn
# Add veth pair in base and vpn NS, set to promisc mode, and bring it up
sudo ip link add veth0 type veth peer name veth-vpn 
sudo ip link set veth-vpn netns vpn
sudo ip link set dev veth0 promisc on
sudo ip link set dev veth0 up
# Add veth0 to bridge in base NS
sudo brctl addif br0 veth0

#####################
# vpn NS operations #
#####################
sudo ip netns exec vpn ip link set lo up
sudo ip netns exec vpn ip link set dev veth-vpn promisc on
sudo ip netns exec vpn ip link set dev veth-vpn up
# Create bridge for vpn traffic and LAN traffic
sudo ip netns exec vpn brctl addbr br-vpn
sudo ip netns exec vpn brctl addif br-vpn veth-vpn
sudo ip netns exec vpn ip link set dev br-vpn up
# Set IP bind address for VPN traffic
sudo ip netns exec vpn ip addr add 10.7.22.25/24 broadcast 10.7.22.255 dev br-vpn
# Set default route in vpn
sudo ip netns exec vpn ip route add default via 10.7.22.1 dev br-vpn

#############################
# Execute OpenVPN in vpn NS #
#############################
sudo ip netns exec vpn sh -c 'cd /etc/openvpn && openvpn asarcar.conf &'
