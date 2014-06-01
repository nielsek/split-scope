#!/usr/bin/env ruby

require 'netaddr'
require 'CSV'

config = Hash.new {|h,k| h[k] = Array.new }

subnets = CSV.read('./samples/subnets.csv', {:col_sep => ';'})

subnets.each do |subnet|
  '''
  subnet[0] - network - eg 10.1.0.0 or 10.1.0.0/24
  subnet[1] - netmask - eg 255.255.255.0 or
  subnet[2] - statics - eg 31
  subnet[3] - hosts/splitpercent - eg 60,30,10 (split between 3 hosts 60%,30%,10%)
  subnet[4] - gateway - eg 10.1.0.1
  subnet[5] - leasetime - eg 10800
  subnet[6] - pool options - eg failover peer "rf";
  subnet[7] - subnet options - eg option domain-name-servers 10.0.224.10, 10.0.225.10; class "pxe" { match if ( (substring(option vendor-class-identifier, 0, 9) = "PXEClient") or (substring(option vendor-class-identifier, 0, 9) = "Etherboot") ); filename "pxelinux.0"; };

  '''


  # If subnet;netmask else cidr;nil
  if subnet[1]
    cidr = NetAddr::CIDR.create(subnet[0] + ' ' + subnet[1])
  else
    cidr = NetAddr::CIDR.create(subnet[0])
  end

  # Number of addrs - 1
  ipcount = cidr::size - 1

  # ipcount - bcast - statics
  dhcppool = ipcount - 1 - Integer(subnet[2])

  # Skip statics
  lowcount = Integer(subnet[2])

  # For each host calculate scope and build config
  subnet[3].split(',').each_with_index do |prcnt, index|

    # Config pr. host / pr. ip version
    configarr = "#{index}-#{cidr.version}"

    '''
    subnet 10.1.4.0 netmask 255.255.255.0 {
    subnet6 2a02:0108:0107:2003:0000:0000:0000:0000/64 {
    '''
    if cidr.version == 4
      config["#{configarr}"].push('subnet ' + cidr.network + ' netmask ' + cidr.wildcard_mask + ' {')
    else
      config["#{configarr}"].push('subnet6 ' + String(cidr) + ' {')
    end

    '''
      pool {
        range 10.1.4.32 10.1.4.254;
        failover peer "rf";
      }
    '''
    config["#{configarr}"].push('  pool {')
    # Last scope gets leftovers
    if index == subnet[3].size - 1
      highcount = ipcount - 1
    else
      highcount = (dhcppool / 100.0 * Integer(prcnt) + lowcount).floor
    end
    config["#{configarr}"].push('    range ' + cidr.nth(lowcount) + ' ' + cidr.nth(highcount) + ';')
    lowcount = highcount + 1

    config["#{configarr}"].push('    ' + String(subnet[6]))
    config["#{configarr}"].push('  }')

    '''
      default-lease-time 604800;
      max-lease-time 604800;
      option routers 10.1.4.1;
      option broadcast-address 10.1.4.255;
      option subnet-mask 255.255.255.0;
      option domain-name-servers 10.0.224.10, 10.0.225.10;
    }
    '''
    config["#{configarr}"].push('  default-lease-time ' + String(subnet[5]) + ';')
    config["#{configarr}"].push('  max-lease-time ' + String(subnet[5]) + ';')
    config["#{configarr}"].push('  option routers ' + String(subnet[4]) + ';')
    config["#{configarr}"].push('  option broadcast-address ' + cidr.nth(ipcount) + ';')
    config["#{configarr}"].push('  option subnet-mask ' + cidr.wildcard_mask + ';')
    config["#{configarr}"].push('  ' + String(subnet[7]))
    config["#{configarr}"].push('}')
    config["#{configarr}"].push('')

  end
end

# Write files
config.each do |filename, lines|
  File.open("subnets#{filename}.conf", 'w') do |file|
    lines.each do |line|
      file.puts line
    end
  end
end

puts 'done!'
puts
puts 'Remember to declare the dhcp servers own subnets in the files, if they are not already included. eg:'
puts 'subnet 10.0.224.0 netmask 255.255.255.0 {'
puts '}'
