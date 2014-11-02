$ORIGIN .
$TTL 259200	; 3 days
asarcar.com		IN SOA	dnsserver.asarcar.com. admin.asarcar.com. (
				2014102550 ; serial
				3600       ; refresh (1 hour)
				600        ; retry (10 minutes)
				86400      ; expire (1 day)
				3600       ; minimum (1 hour)
				)
			NS	dnsserver.asarcar.com.
asarcar.com             A       10.7.22.2
$ORIGIN asarcar.com.
$TTL 259200	; 3 days
dnsserver               A       10.7.22.2

dhcpserver		CNAME	dnsserver
vpnserver		CNAME	dnsserver
webserver		CNAME	dnsserver
www			CNAME	dnsserver
zeus			CNAME	dnsserver
