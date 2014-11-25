* This document provides information on how to setup the Layer-2
VPN client on your machine. 

# The VPN username/passwd should correspond to the one 
you have on vpnserver.asarcar.com which run OpenVPN server. 
Everyone should have an account on vpnserver.asarcar.com. 
The password should be changed by ssh'ing into this machine.

# Please ensure you brctl apps and utils are installed. 
e.g. Debian dist run: sudo apt-get install -y bridge-utils.
 
# Please note that each VPN client is allocated IP address from the
corporate DHCP server from 10.7.22.200 to 10.7.22.254. Hence, please
verify that you don't have any machine in your LAN that overlaps 
with that address range. 

# Client Actions: Depending on whether your client machine is
running Microsoft Windows, Linux, or Mac OS you need to follow
the following steps:  

## Microsoft Windows
a) Download the OpenVPN Installer. Run it and install the software. 
This should create an icon calledOpenVPN GUI on the Windows Desktop.
b) Download the files ca.crt, asarcar.crt, asarcar.key, asarcar.conf 
and ta.key. 
c) Put them in the directory C:\Program Files (x86)\OpenVPN\config.
d) Right click on the OpenVPN GUI icon and select Run as Administrator. 
This will place a red icon showing two computers in the system tray 
located at the bottom right of the screen.
e) Right click on the above red icon and click on Connect.
f) When prompted for the username/passwd, enter your username and passwd 
from vpnserver.asarcar.com.
g) Upon successful establishment of an OpenVPN session, 
the red icon would turn green.

## Linux
a) sudo apt-get install openvpn
b) Download the files ca.crt, asarcar.crt, asarcar.key, asarcar.conf 
and ta.key. 
c) Put them in any directory of your choice: say Vpn.
d) cd Vpn and execute sudo openvpn asarcar-client.conf
e) When prompted for the username/passwd, enter your username and passwd 
from vpnserver.asarcar.com.

## Mac OS
a) Download the Tunnelblick software and install it.
b) Download the files ca.crt, asarcar.crt, asarcar.key, asarcar.conf 
and ta.key. 
c) Put them in ~/Library/openvpn directory.
d) Start Tunnelblick and ask it to establish the VPN session.
e) When prompted for the username/passwd, enter your username and passwd 
from vpnserver.asarcar.com.

----------
# Note that availability of Layer-2 VPN implies that you have
available at your local LAN all the services that are available
on the remote LAN, such as Domain Name Resolution, DHCP, etc. 
available at the server site. 
----------

OpenVPN Server Installation
---------------------------
# Create brige tap br0 on eth0 (LAN connected interface).
The "interfaces" file located at /etc/networks/
shows how one sets up bridge with the physical interface 
connected to local LAN in promiscous mode. Bounce the
networking stack.

# Allow ip forwarding via kernel.
The "sysctl.conf" file located at /etc/ has ip forwarding
enabled (net.ipv4.ip_forward=1). This allows any IP traffic 
generated from your computer destined for the remote subnet 
(in our case 10.7.22.0/24) that is tunneled to the remote 
vpn server to be forwarded to the remote site LAN.

# Generate Digital Signature Certificates, Server Certificate/Key, 
Client Certificate/Key, and HMAC Key:
ca.crt, asarcar-server.crt, asarcar-server.key, asarcar-client.crt, 
asarcar-client.key, and ta.key.

# Upload Client needed files to intranet site for easy download by Clients: 
ca.crt, asarcar-client.crt, asarcar-client.key, ta.key, 
and asarcar-client.conf

# sudo mv ca.crt asarcar.crt asarcar.key ta.key /etc/openvpn

# Provide Conf File and Scripts:
sudo cp asarcar.conf up.sh down.sh /etc/openvpn

# Run the vpn-install.sh script: it will create vpn namespace, 
# setup the env, and start openvpn in vpn NS
echo pwd | sudo -S ls && vpn-install.sh 

# Validate by perusing log file: 
tail -f /var/log/syslog | grep ovpn

# TODO: ensure openvpn service is always started 
# on boot, we need to plug vpn-install.sh in init script
# "usual cmd": sudo update-rc.d openvpn defaults

# To Kill OpenVPN server
sudo ip netns exec vpn sh -c 'pkill -SIGKILL openvpn'
sudo ip netns del vpn

