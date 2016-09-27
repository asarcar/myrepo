DNS Server Installation
-----------------------
* Provide Conf and View Files For Internal/External Zone Definitions: 
sudo cp named.conf named.conf.options named.conf.views /etc/bind/
sudo cp internal_zones.conf external_zones.conf /var/lib/bind


* Generate cryptographic hash (rndc.key) used by DHCP to enter records in DNS
sudo /usr/bin/rndc-confgen -a 

* Validate DNS Conf File: 
named-checkconf /etc/bind/named.conf

* Provide FWD/REVERSE Bind Zone Files For Internal View:
sudo cp fwd.db.asarcar.com /var/lib/bind/
sudo cp fwd.db.corp.saralnet.com /var/lib/bind/
sudo cp rev.db.22.7.10.in-addr.arpa /var/lib/bind/

* Provide FWD/REVERSE Bind Zone Files For External View:
sudo cp fwd.db.saralnet.com /var/lib/bind/
sudo cp rev.db.230.32.102.76.in-addr.arpa /var/lib/bind/

* Validate Bind Zone Files (Internal and External):
named-checkzone asarcar.com /var/lib/bind/fwd.db.asarcar.com
named-checkzone corp.saralnet.com /var/lib/bind/fwd.db.corp.saralnet.com
named-checkzone 22.7.10.in-addr.arpa /var/lib/bind/rev.db.22.7.10.in-addr.arpa
named-checkzone saralnet.com /var/lib/bind/fwd.db.saralnet.com
named-checkzone 230.32.102.76.in-addr.arpa /var/lib/bind/rev.db.230.32.102.76.in-addr.arpa

* sudo /etc/init.d/bind9 start
# Undo: sudo /etc/init.d/bind9 stop OR sudo service bind9 stop
# Review: service bind9 status

* Validate by perusing log file: 
tail -f /var/log/syslog | grep named

* Ensure: DNS service is always started on boot:
sudo update-rc.d bind9 defaults 
# Undo: sudo update-rc.d -f bind9 remove
# Review: Creation of File: /etc/init.d/bind9


DNS Client Installation
-----------------------
* Add DNS Server IP to resolv.conf
*** sudo printf 'search asarcar.com # your private domain\nnameserver 10.7.22.2\n' | sudo tee /etc/resolvconf/resolv.conf.d/base > /dev/null
*** sudo resolvconf -u
*** Validate DNS Server is appropriately recorded: cat /etc/resolv.conf
