# physical hash
Facter.add(:physical) do
  confine :kernel => :linux, :virtual => :physical

  ENV["PATH"]="/bin:/sbin:/usr/bin:/usr/sbin"

  setcode do
    physical_hash = Hash.new { |hash, key| hash[key] = Hash.new(&hash.default_proc) }
    # We know pcitools is installed, as it's rolled into our discovery image
    # lspci_installed = system("dpkg -l | grep -q pciutils") ? true : false
    lspci_output = Facter::Core::Execution.exec("lspci -nn")
    return nil unless lspci_output
    # Temporary bumf to match the hardware in Applejack, so we can test
    if lspci_output.match(/C220/) then
      physical_hash[:raid][:intel_c220] = true
    end
    # Intel NVME
    if lspci_output.match(/\[8086:0953/) then
      physical_hash[:nand][:intel_nvme] = true
    end
    # FusionIO
    if lspci_output.match(/\[1aed:/) then
      physical_hash[:nand][:fusionio] = true
    end
    # HP raid p440ar/p840ar - probably any smart array controller
    if lspci_output.match(/\[103c:3239/) then
      physical_hash[:raid][:hp_smartarray] = true
    end
    # LSI raid
    if lspci_output.match(/RAID.*LSI/) then
      physical_hash[:raid][:lsi] = true
    end
    # Adaptec raid
    if lspci_output.match(/Adaptec/) then
      physical_hash[:raid][:adaptec] = true
    end
    # Infiniband interface
    # REF: http://cateee.net/lkddb/web-lkddb/INFINIBAND.html
    if lspci_output.match(/\[(1077|15b3|1678|1867|18b8|1fc1):/) then
      physical_hash[:interface][:infiniband] = true
    end
    # IPMI interface
    ipmi_dmidecode = Facter::Core::Execution.exec("dmidecode --type 38")
    if ipmi_dmidecode.match(/KCS/) then
      physical_hash[:interface][:ipmi] = true
    end
    physical_hash
  end
end
