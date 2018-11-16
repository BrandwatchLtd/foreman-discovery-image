mkdir -p root/root/.ssh
scp root@10.3.104.2:/root/.ssh/authorized_keys root/root/.ssh/authorized_keys
./build-livecd fdi-centos7.ks
./build-livecd-root
