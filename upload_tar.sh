FOREMAN_SERVER=$1 || echo "need to provide foreman server to upload to!" && exit 1
scp fdi-image-3.3.1.tar root@${FOREMAN_SERVER}:/usr/share/foreman/public
