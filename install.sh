#!/bin/bash

#to run manually
#./install.sh 2>&1 | tee output.log


USER=wal

#add user
useradd -u 1001 -s /bin/bash -m -p $(openssl passwd -1 fred) $USER 
usermod -aG sudo $USER
usermod -aG www-data $USER

#firewall
ufw allow 22,8080,38888/tcp
ufw --force enable

#ravendb setup
wget --no-verbose -nc -O /vagrant/RavenDB.tar.bz2 https://hibernatingrhinos.com/downloads/RavenDB%20for%20Linux%20x64/42018 
tar -xf /vagrant/RavenDB.tar.bz2 -C /opt/
cp /vagrant/install_files/server.pfx /opt/RavenDB/Server/
cp /vagrant/install_files/raven.settings.json /opt/RavenDB/Server/settings.json
sed -i "s/hostname/$(hostname -f)/g" /opt/RavenDB/Server/settings.json

#ravendb service
cp /vagrant/install_files/ravendb.service /etc/systemd/system/ravendb.service
systemctl enable ravendb.service
systemctl start ravendb.service

#extract CA certificate out of the PFX
openssl pkcs12 -in /vagrant/install_files/server.pfx -cacerts -nokeys -chain -passin pass:"" | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /usr/local/share/ca-certificates/ca_certs.crt
update-ca-certificates

#register client certificate
apt-get install expect -y
expect /vagrant/install_files/trustClientCert.exp