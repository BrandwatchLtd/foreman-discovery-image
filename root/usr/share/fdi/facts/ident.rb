#!/usr/bin/env ruby
# vim: ts=2:sw=2:et
#

Facter.add("fdident", :timeout => 10) do
  setcode do
    ident = Facter.fact("serialnumber").value
    ipmi_serial = Facter.fact("ipmi_fru_product_serial").value
    if ipmi_serial and not ipmi_serial.match(/12345678/)
      ident = ipmi_serial
    elsif ident.match(/12345678/)
      ident = Facter.value(:discovery_bootif).gsub(/:/,'')
    end
    ident
  end
end
