#!/usr/bin/env ruby
# vim: ts=2:sw=2:et
#

Facter.add("foreman_location", :timeout => 10) do
  setcode do
    location = 'unknown'
    ip = Facter.value(:discovery_bootip)
    if ip.match(/^10\.2/)
      location = 'Sov House Brighton'
    elsif ip.match(/^10\.1/)
      location = 'Custodian DC Maidstone'
    elsif ip.match(/^10\.3/)
      location = 'Virtus DC (Hayes)'
    elsif ip.match(/^10\.0\.13/)
      location = 'Custodian DC Maidstone'
    elsif ip.match(/^10\.0/)
      location = '4d DC Byfleet'
    end
  end
end
