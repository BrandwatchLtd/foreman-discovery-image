repo --name=centos --mirrorlist=http://mirrorlist.centos.org/?release=7&arch=$basearch&repo=os
repo --name=centos-updates --mirrorlist=http://mirrorlist.centos.org/?release=7&arch=$basearch&repo=updates
repo --name=epel7 --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
repo --name=foreman-el7 --baseurl=http://yum.theforeman.org/nightly/el7/$basearch/
repo --name=foreman-plugins-el7 --baseurl=http://yum.theforeman.org/plugins/nightly/el7/$basearch/
repo --name=fusion-io --baseurl=file:///root/git/foreman-discovery-image/rpms/
repo --name=hp-spp --baseurl=http://downloads.linux.hpe.com/SDR/repo/spp/RHEL/7.2/x86_64/current/
repo --name=hp-mcp --baseurl=http://downloads.linux.hpe.com/SDR/repo/mcp/centos/7.2/x86_64/current/
