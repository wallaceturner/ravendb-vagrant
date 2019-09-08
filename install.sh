#!/bin/bash

#to run manually
#./install.sh 2>&1 | tee output.log


USER=wal

#add user
useradd -u 1001 -s /bin/bash -m -p $(openssl passwd -1 fred) $USER 
usermod -aG sudo $USER
usermod -aG www-data $USER

#firewall
ufw allow 443/tcp
ufw allow 8080/tcp
ufw allow 38888/tcp
ufw enable

#ravendb setup
tar -xf /tmp/install_files/RavenDB-4.2.3-linux-x64.tar.bz2 -C /opt/
cp /tmp/install_files/server.pfx /opt/RavenDB/Server/
cp /tmp/install_files/raven.settings.json /opt/RavenDB/Server/settings.json
sed -i "s/hostname/$(hostname -f)/g" /opt/RavenDB/Server/settings.json

#ravendb service
cp /tmp/install_files/ravendb.service /etc/systemd/system/ravendb.service
systemctl enable ravendb.service
systemctl start ravendb.service

#cert config - note change of filename to .crt is intentional
cp /tmp/install_files/mooo_com_CA.cer /usr/local/share/ca-certificates/certificate.crt
update-ca-certificates

#register client certificate
apt-get install expect -y
expect /tmp/install_files/trustClientCert.exp