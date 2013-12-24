split-scope
===========

Split a range into multiple dhcp scopes


    nk-mbp:split-scope nk$ ./split-scope.rb
    Inputs:
      Subnet: 10.0.0.0/8
      Statics: 100
      Hosts/% [12, 7, 28, 19, 16, 18]
    Results:
      Broadcast 10.255.255.255
      Scopes:
        10.0.0.100 - 10.30.184.169
        10.30.184.170 - 10.48.164.39
        10.48.164.40 - 10.120.82.31
        10.120.82.32 - 10.168.245.227
        10.168.245.228 - 10.209.235.150
        10.209.235.151 - 10.255.255.254
