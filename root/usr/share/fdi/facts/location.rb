#!/usr/bin/env ruby
# vim: ts=2:sw=2:et
#

location = 'unknown'
ip = Facter.value(:discovery_bootip)
if ip.match(/^10\.2/)
  location = 'Sov House Brighton'
  foreman_server = 'theforeman.int.brandwatch.net'
elsif ip.match(/^10\.1/)
  location = 'Custodian DC Maidstone'
  foreman_server = 'theforeman.dr.brandwatch.net'
elsif ip.match(/^10\.3/)
  location = 'Virtus DC (Hayes)'
  foreman_server = 'theforeman-hay0.brandwatch.net'
elsif ip.match(/^10\.0\.13/)
  location = 'Custodian DC Maidstone'
  foreman_server = 'theforeman.stage.brandwatch.net'
elsif ip.match(/^10\.0/)
  location = '4d DC Byfleet'
  foreman_server = 'theforeman.live.brandwatch.net'
end

Facter.add("foreman_location", :timeout => 10) do
  setcode do
    location
  end
end

Facter.add("foreman_server", :timeout => 10) do
  setcode do
    foreman_server
  end
end
