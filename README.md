split-scope
===========

Split IPv{4,6} subnets into multiple DHCP ranges.

`Input: .csv`

`Output: isc-dhcpd config files`

CSV format: (look in samples)

    Column A - network - eg 10.1.0.0 or 10.1.0.0/24
    Column B - netmask - eg 255.255.255.0 or
    Column C - statics - eg 31
    Column D - dhcpware/splitpercent - eg dhcpd/60,kea/30,dhcpd/10 (split between 3 hosts 60%,30%,10%)
    Column E - gateway - eg 10.1.0.1
    Column F - leasetime - eg 10800
    Column G - pool options - eg failover peer "rf";
    Column H - subnet options - eg option domain-name-servers 10.0.224.10, 10.0.225.10; class "pxe" { match if ( (substring(option vendor-class-identifier, 0, 9) = "PXEClient") or (substring(option vendor-class-identifier, 0, 9) = "Etherboot") ); filename "pxelinux.0"; };
