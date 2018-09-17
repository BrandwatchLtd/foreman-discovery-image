#!/bin/bash
foreman_ip=$( facter dhcp_servers | cut -d '"' -f 4 )
until [[ "$foreman_ip" =~ ^10 ]]; do
  echo "Foreman ip fact not yet set - sleeping!"
  sleep 2
done
foreman_server=$( facter foreman_server )
until [[ "$foreman_server" =~ ^theforeman ]]; do
  echo "Foreman server fact not yet set - sleeping!"
  sleep 2
done
echo -e "${foreman_ip}\t${foreman_server}" >> /etc/hosts
