#!/usr/bin/env ruby
# vim: ts=2:sw=2:et
#

Facter.add("fdident", :timeout => 10) do
  setcode do
    ident = Facter.fact("serialnumber").value
    if ident.match(/12345678/)
      ident = Facter.value(:discovery_bootif).gsub(/:/,'')
    end
    ident
  end
end
