#!/usr/bin/env ruby
# vim: ts=2:sw=2:et
#
require 'facter/util/ip'
require '/usr/lib64/ruby/vendor_ruby/discovery.rb'

def cmdline option=nil, default=nil
  line = File.open("/proc/cmdline", 'r') { |f| f.read }
  if option
    result = line.split.map { |x| $1 if x.match(/^#{option}=(.*)/)}.compact
    result.size == 1 ? result.first : default
  else
    line
  end
end

def discovery_bootif
  # PXELinux dash-separated hexadecimal *without* the leading hardware type
  cmdline('BOOTIF', cmdline('fdi.pxmac', detect_first_nic_with_link)).gsub(/^[a-fA-F0-9]+-/, '').gsub('-', ':') rescue '00:00:00:00:00:00'
end

Facter.add("discovery_version") do
  setcode do
    File.open('/usr/share/fdi/VERSION') {|f| f.readline.chomp}
  end
end

Facter.add("discovery_release") do
  setcode do
    File.open('/usr/share/fdi/RELEASE') {|f| f.readline.chomp}
  end
end

Facter.add("discovery_bootif", :timeout => 10) do
  setcode do
    discovery_bootif
  end
end

Facter.add("foreman_location", :timeout => 10) do
  setcode do
    location = 'unknown'
    ip = Facter.fact("ipaddress").value
    required = discovery_bootif
    Facter::Util::IP.get_interfaces.each do |iface|
      mac = Facter::Util::IP.get_interface_value(iface, "macaddress")
      ip = Facter::Util::IP.get_interface_value(iface, "ipaddress") if mac == required
    end
    if ip.match(/^10\.2/)
      location = 'Sov House Brighton'
    elsif ip.match(/^10\.1/)
      location = 'Custodian DC Maidstone'
    elsif ip.match(/^10\.0\.13/)
      location = 'Custodian DC Maidstone'
    elsif ip.match(/^10\.0/)
      location = '4d DC Byfleet'
    end
  end
end
