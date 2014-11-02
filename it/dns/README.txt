DNS Server Installation
-----------------------
* Provide Conf File: 
sudo cp named.conf.options named.conf.local /etc/bind/

* Validate DNS Conf File: named-checkconf /etc/bind/named.conf

* Provide FWD/REVERSE Bind Zone Files: 
sudo cp fwd.db.asarcar.com /var/lib/bind/
sudo cp rev.db.22.7.10.in-addr.arpa /var/lib/bind/

* Validate Bind Zone Files:
named-checkzone asarcar.com /var/lib/bind/fwd.db.asarcar.com
named-checkzone 22.7.10.in-addr.arpa /var/lib/bind/rev.db.22.7.10.in-addr.arpa

* sudo /etc/init.d/bind9 start

* Validate by perusing log file: 
tail -f /var/log/syslog | grep named

* Ensure: DNS service is always started on boot:
sudo update-rc.d bind9 defaults 


DNS Client Installation
-----------------------
* Add DNS Server IP to resolv.conf
*** sudo printf 'search asarcar.com # your private domain\nnameserver 10.7.22.2\n' | sudo tee /etc/resolvconf/resolv.conf.d/base > /dev/null
*** sudo resolvconf -u
*** Validate DNS Server is appropriately recorded: cat /etc/resolv.conf
