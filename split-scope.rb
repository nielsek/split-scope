#!/usr/bin/env ruby

require 'netaddr'

subnet = '10.0.0.0/8'
statics = 100
hostprcnt = [12, 7, 28, 19, 16, 18]


puts 'Inputs:'
puts '  Subnet: ' + subnet
puts '  Statics: ' + statics.to_s
puts '  Hosts/% ' + hostprcnt.to_s

puts 'Results:'

cidr = NetAddr::CIDR.create(subnet)

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
