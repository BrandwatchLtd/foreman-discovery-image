#!/usr/bin/env ruby
# vim: ts=2:sw=2:et
#
chassis_manufacturer = Facter::Util::Resolution.exec("cat /sys/class/dmi/id/chassis_vendor")
dmi_system = Facter::Util::Resolution.exec("dmidecode -t 1")
dmi_serial = dmi_system.match(/Serial Number:\s+(.*)$/).captures[0].to_s
dmi_base = Facter::Util::Resolution.exec("dmidecode -t 2")

Facter.add("fdident", :timeout => 10) do
  setcode do
    if chassis_manufacturer != 'HP' then
      ipmi_serial = Facter.value(:ipmi_fru_product_serial) || false
      ipmi_board_product = Facter.value(:ipmi_fru_board_product) || false
      ipmi_product_name = Facter.value(:ipmi_fru_product_name) || false
      ldap_serial = Facter.value(:ldap_serialnumber) || false

      if dmi_serial and dmi_serial.match(/.*-\w+$/) then
        node_serial = dmi_serial
      elsif ipmi_serial and not ipmi_serial.match(/12345678/) then
        node_serial = ipmi_serial
      elsif dmi_serial and not dmi_serial.match(/12345678/) then
        node_serial = dmi_serial
      elsif ldap_serial then
        node_serial = ldap_serial
      else
        node_serial = Facter.value(:macaddress).gsub(/:/,'')
      end
    else
      node_serial = dmi_serial
    end

    if node_serial.match(/-/) then
      nodes = node_serial.split("-")
      node_number = nodes[1]
      node_serial = nodes[0]
    else
      begin
        node_number  = dmi_base.match(/Location In Chassis:.*?(\d)/).captures[0].to_s
      rescue
        begin
          node_number = ipmi_product_name.match(/(\d)/).captures[0].to_s
        rescue
          begin
            node_number = ipmi_board_product.match(/(\d)/).captures[0].to_s
          rescue
            node_number = 1
          end
        end
      end
    end
    ident = node_serial + "-" + node_number
  end
end
