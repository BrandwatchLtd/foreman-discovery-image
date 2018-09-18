#!/bin/bash
foreman_ip=$( facter dhcp_servers | cut -d '"' -f 4 )
sleep 2
foreman_server=$( facter foreman_server )
echo -e "${foreman_ip}\t${foreman_server}" >> /etc/hosts
echo "10.3.104.2\ttheforeman-hay0.brandwatch.net" >> /etc/hosts
