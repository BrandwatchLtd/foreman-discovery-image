#!/usr/bin/env ruby
# vim: ts=2:sw=2:et
#

Facter.add("fdident", :timeout => 10) do
  setcode do
    ident = Facter.fact("serialnumber").value
    ipmi_serial = Facter.fact("ipmi_fru_board_serial").value
    if ident.match(/12345678/)
      if ipmi_serial
        ident = ipmi_serial
      else
        ident = Facter.value(:discovery_bootif).gsub(/:/,'')
      end
    end
    ident
  end
end
