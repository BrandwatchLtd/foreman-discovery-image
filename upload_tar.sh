./build-livecd fdi-centos7.ks
./build-livecd-root
scp fdi-image-3.3.1.tar root@theforeman.brandwatch.net:/usr/share/foreman/public
