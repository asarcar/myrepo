DHCPD Server Installation
-------------------------
* Provide Conf File: sudo cp dhcpd.conf /etc/dhcp/

* Validate Conf File: dhcpd -t -cf /etc/dhcp/dhcpd.conf

* sudo cp base /etc/resolvconf/resolv.conf.d/base

* sudo resolvconf -u

* sudo /etc/init.d/isc-dhcp-server start

* Validate by perusing log file: 
tail -f /var/log/syslog | grep dhcpd

* Ensure: DHCP service is always started on boot:
sudo update-rc.d isc-dhcp-server defaults 



