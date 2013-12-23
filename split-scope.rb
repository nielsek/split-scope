#!/usr/bin/env ruby

require 'netaddr'

cidr = '10.0.0.0/8'
hostprcnt = [12, 7, 28, 19, 16, 18]

puts 'Inputs:'
puts '  CIDR: ' + cidr
puts '  Hosts/% ' + hostprcnt.to_s

puts 'Results:'

# Total to be split
totrange = NetAddr::CIDR.create(cidr)

# Number of addrs - 1
ipcount = totrange::size - 1

# Broadcast
puts '  Broadcast ' + totrange.nth(ipcount)

# Split thingy
puts '  Ranges:'
lowcount = 0
for percnt in hostprcnt
  highcount = (ipcount / 100.0 * percnt + lowcount).floor - 1
  puts '    ' + totrange.nth(lowcount) + ' - ' + totrange.nth(highcount)
  lowcount = highcount+1
end
