#!/bin/bash
foreman_ip=$( facter dhcp_servers | cut -d '"' -f 4 )
foreman_server=$( facter foreman_server )
if [[ "$foreman_ip" =~ ^10 ]]; then
  echo -e "${foreman_ip}\t${foreman_server}" >> /etc/hosts
fi
