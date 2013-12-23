split-scope
===========

Split a range into multiple dhcp scopes


    nk-mbp:split-scope nk$ ./split-scope.rb
    Inputs:
      CIDR: 10.0.0.0/8
      Hosts/% [12, 7, 28, 19, 16, 18]
    Results:
      Broadcast 10.255.255.255
      Scopes:
        10.0.0.0 - 10.30.184.81
        10.30.184.82 - 10.48.163.215
        10.48.163.216 - 10.120.81.236
        10.120.81.237 - 10.168.245.195
        10.168.245.196 - 10.209.235.134
        10.209.235.135 - 10.255.255.254
