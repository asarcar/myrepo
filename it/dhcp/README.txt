DHCPD Server Installation
-------------------------
* Provide Conf File: sudo cp dhcpd.conf /etc/dhcp/

* Validate Conf File: dhcpd -t -cf /etc/dhcp/dhcpd.conf

* sudo cp base /etc/resolvconf/resolv.conf.d/base
# Undo: Comment out lines referring to private domain and dns 

* sudo resolvconf -u

* sudo /etc/init.d/isc-dhcp-server start
# Undo: sudo /etc/init.d/isc-dhcp-server stop

* Validate by perusing log file: 
tail -f /var/log/syslog | grep dhcpd

* Ensure: DHCP service is always started on boot:
sudo update-rc.d isc-dhcp-server defaults 
# Undo: sudo update-rc.d -f isc-dhcp-server remove



