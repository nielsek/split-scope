#!/usr/bin/env ruby

require 'netaddr'
require 'CSV'

# TODO - output:
#
#subnet 10.129.0.0 netmask 255.255.128.0 {
#  pool {
#    range 10.129.0.32 10.129.127.254;
#  }
#  default-lease-time 604800;
#  max-lease-time 604800;
#  option routers 10.129.0.1;
#  option broadcast-address 10.129.127.255;
#  option subnet-mask 255.255.128.0;
#  option domain-name-servers 10.0.224.10, 10.0.225.10;
#}
# ...

subnets = CSV.read("/Users/nk/Dropbox/rf-it 2012/2013/Core Netværk/Servere/dhcp/dhcpd/subnets.csv", {:col_sep => ";"})

statics = 32 # FIXME: should be a pr. subnet option
hostprcnt = [50, 40, 10]

subnets.each do |subnet|
  '''
  subnet[0] - network - eg 10.1.0.0
  subnet[1] - netmask - eg 255.255.255.0
  subnet[2] - range - eg 10.1.0.32 10.1.0.254 # FIXME: should not be defined
  subnet[3] - broadcast - eg 10.1.0.255       # FIXME: should not be defined
  subnet[4] - gateway - eg 10.1.0.1
  subnet[5] - leasetime - eg 10800
  '''

  cidr = NetAddr::CIDR.create(subnet[0] + ' ' + subnet[1])
  puts cidr

  # Number of addrs - 1
  ipcount = cidr::size - 1

  # bcast
  puts '  Broadcast ' + cidr.nth(ipcount)

  # ipcount - bcast - statics
  dhcppool = ipcount - 1 - statics

  # Split thingy
  puts '  Scopes:'
  lowcount = statics
  hostprcnt.each_with_index do |prcnt, index|
    # Last scope gets leftovers
    if index == hostprcnt.size - 1
      highcount = ipcount - 1
    else
      highcount = (dhcppool / 100.0 * prcnt + lowcount).floor
    end
    puts '    ' + cidr.nth(lowcount) + ' - ' + cidr.nth(highcount)
    lowcount = highcount + 1
  end
end
