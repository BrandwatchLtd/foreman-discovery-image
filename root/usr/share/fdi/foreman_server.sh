#!/bin/bash
foreman_ip=$( facter dhcp_servers | cut -d '"' -f 4 )
sleep 2
foreman_server=$( facter foreman_server )
echo "${foreman_ip} ${foreman_server}" >> /etc/hosts
echo "10.3.104.2 theforeman-hay0.brandwatch.net" >> /etc/hosts
