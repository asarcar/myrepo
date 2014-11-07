$ORIGIN .
$TTL 259200	; 3 days
asarcar.com		IN SOA	ns1.asarcar.com. admin.asarcar.com. (
				2014102569 ; serial
				3600       ; refresh (1 hour)
				600        ; retry (10 minutes)
				86400      ; expire (1 day)
				3600       ; minimum (1 hour)
				)
			NS	ns1.asarcar.com.
			A	10.7.22.2
$ORIGIN asarcar.com.
dhcpserver		CNAME	ns1
ns1			A	10.7.22.2
$TTL 300	; 5 minutes
Ory-iPhone		A	10.7.22.102
			TXT	"310e7350cfaf1a5ea9290ba2e325228da8"
SARCAR-iPAD		A	10.7.22.103
			TXT	"31ca50753905cb99f5ac6241aa1852814b"
titan			A	10.7.22.50
			TXT	"31f1334fe4a8492d72f843a1ebb40bf6dd"
$TTL 259200	; 3 days
vpnserver		CNAME	ns1
www			CNAME	ns1
zeus			CNAME	ns1
