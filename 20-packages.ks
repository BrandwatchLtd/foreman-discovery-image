# Debugging support
# Dracut missing deps (https://bugzilla.redhat.com/show_bug.cgi?id=1285810)
# Enable stripping
# Facter
# For UEFI/Secureboot support
# Foreman
# Fusion IO driver
# HP tools
# Interactive discovery
# Only needed because livecd-tools runs /usr/bin/firewall-offline-cmd
# Packages to Remove
# Remove the kbd bits
# SSH access
# Starts all interfaces automatically for us
# Things it would be nice to loose
# Used to update code at runtime
# file system stuff
# grub
# required to build drivers (should it be needed?)
# selinux toolchain of policycoreutils, libsemanage, ustr
# unconditionally; patch submitted upstream. Remove once released version
# with it is available
#hp-health
#hp-smh-templates
#hp-snmp-agents
#hponcfg
#hpsmh
#lldpad
%packages --excludedocs
-authconfig
-checkpolicy
-ed
-fedora-logos
-fedora-release-notes
-freetype
-grubby
-kbd
-libselinux
-libselinux-python
-os-prober
-policycoreutils
-prelink
-selinux-policy*
-setserial
-usermode
-wireless-tools
NetworkManager
OpenIPMI
OpenIPMI-tools
acpid
bash
bind-utils
binutils
biosdevname
bzip2
chkconfig
cpp
dmidecode
dmraid
e2fsprogs
e2fsprogs-libs
efibootmgr
ethtool
facter
file
fio-common
fio-preinstall
fio-sysvinit
fio-util
firewalld
foreman-proxy
gcc
glibc-devel
glibc-headers
grub2
grub2-efi
grub2-efi-x64
grub2-efi-x64-cdboot
grub2-tools
gzip
hpssa
hpssacli
iomemory-vsl
isomd5sum
kbd
kernel
kernel-devel
kernel-headers
kexec-tools
less
libmpc
lldpd
lvm2
mdadm
mpfr
net-tools
openssh-clients
openssh-server
openssl
parted
passwd
policycoreutils
rootfiles
rubygem-fast_gettext
rubygem-newt
rubygem-smart_proxy_discovery_image
shim
shim-x64
sudo
system-storage-manager
tar
tcpdump
tftp
unzip
uuid
vim-minimal
virt-what
xfsprogs
yum
%end
