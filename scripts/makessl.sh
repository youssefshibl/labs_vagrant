#!/bin/bash 



# make signed ssl certificate for openvpn server 
# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-16-04

# make a directory to store the keys that we will make and change to it
mkdir -p /etc/openvpn/easy-rsa/keys
cd /etc/openvpn/easy-rsa

# copy the variables file to the working directory
cp /usr/share/easy-rsa/vars ./

# edit the variables file
sed -i /etc/openvpn/easy-rsa/vars -e \
    "/export KEY_COUNTRY*/ c export KEY_COUNTRY=\"US\""
sed -i /etc/openvpn/easy-rsa/vars -e \
    "/export KEY_PROVINCE*/ c export KEY_PROVINCE=\"CA\""
sed -i /etc/openvpn/easy-rsa/vars -e \
    "/export KEY_CITY*/ c export KEY_CITY=\"SanFrancisco\""
sed -i /etc/openvpn/easy-rsa/vars -e \
    "/export KEY_ORG*/ c export KEY_ORG=\"Fort-Funston\""
sed -i /etc/openvpn/easy-rsa/vars -e \
    "/export KEY_EMAIL*/ c export KEY_EMAIL=\""

# source the variables file
source ./vars

# clean any previous keys
./clean-all

# build the certificate authority
./build-ca --batch

# build the server key
./build-key-server server --batch

# generate a Diffie-Hellman key exchange
./build-dh

# copy the files to the openvpn directory
cd /etc/openvpn/easy-rsa/keys
cp dh2048.pem ca.crt server.crt server.key /etc/openvpn

# copy the sample server configuration file to the openvpn directory
gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz > /etc/openvpn/server.conf

# edit the server configuration file
sed -i /etc/openvpn/server.conf -e \
    "/dh dh1024.pem*/ c dh dh2048.pem"
sed -i /etc/openvpn/server.conf -e \
    "/ca ca.crt*/ c ca /etc/openvpn/ca.crt"
sed -i /etc/openvpn/server.conf -e \
    "/cert server.crt*/ c cert /etc/openvpn/server.crt"
sed -i /etc/openvpn/server.conf -e \
    "/key server.key*/ c key /etc/openvpn/server.key"
sed -i /etc/openvpn/server.conf -e \
    "/cipher AES-256-CBC*/ c cipher AES-256-CBC"
sed -i /etc/openvpn/server.conf -e \
    "/user nobody*/ c user nobody"
sed -i /etc/openvpn/server.conf -e \
    "/group nogroup*/ c group nogroup"
sed -i /etc/openvpn/server.conf -e \
    "/status openvpn-status.log*/ c status openvpn-status.log"
sed -i /etc/openvpn/server.conf -e \
    "/log         openvpn.log*/ c log         openvpn.log"
sed -i /etc/openvpn/server.conf -e \
    "/verb 3*/ c verb 3"
sed -i /etc/openvpn/server.conf -e \
    "/mute 20*/ c mute 20"
sed -i /etc/openvpn/server.conf -e \
    "/push \"redirect-gateway def1 bypass-dhcp\"*/ c push \"redirect-gateway def1 bypass-dhcp\""
sed -i /etc/openvpn/server.conf -e \
    "/push \"dhcp-option DNS"

# enable IP forwarding
sed -i /etc/sysctl.conf -e \
    "/net.ipv4.ip_forward=1*/ c net.ipv4.ip_forward=1"

# enable NAT
iptables -t nat -A POSTROUTING -s

# restart openvpn
systemctl restart openvpn@server

# enable openvpn to start on boot
systemctl enable openvpn@server

# make a directory to store the client keys
mkdir -p /etc/openvpn/clientconf

# copy the sample client configuration file to the openvpn directory
gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/client.conf.gz > /etc/openvpn/clientconf/client.conf

# edit the client configuration file
sed -i /etc/openvpn/clientconf/client.conf -e \
    "/remote my-server-1*/ c remote"

# copy the client keys to the client configuration directory
cp /etc/openvpn/easy-rsa/keys/ca.crt /etc/openvpn/easy-rsa/keys/client.crt /etc/openvpn/easy-rsa/keys/client.key /etc/openvpn/clientconf

# copy the client configuration file to the client configuration directory
cp /etc/openvpn/clientconf/client.conf /etc/openvpn/clientconf/client.ovpn

# create a tar archive of the client configuration directory
tar -C /etc/openvpn/clientconf -cvf /etc/openvpn/clientconf/client.tar .

# copy the tar archive to the home directory
cp /etc/openvpn/clientconf/client.tar /home/vagrant

# change to the home directory
cd /home/vagrant

# change the ownership of the tar archive
chown vagrant:vagrant client.tar

# remove the client configuration directory
rm -rf /etc/openvpn/clientconf

# remove the easy-rsa directory
rm -rf /etc/openvpn/easy-rsa

# remove the openvpn directory
rm -rf /etc/openvpn

# remove the openvpn package
apt-get remove --purge --auto-remove openvpn -y

# remove the openvpn package dependencies
apt-get remove --purge --auto-remove easy-rsa -y

# remove the openvpn package dependencies
apt-get remove --purge --auto-remove openssl -y

# remove the openvpn package dependencies
apt-get remove --purge --auto-remove ca-certificates -y

# remove the openvpn package dependencies
apt-get remove --purge --auto-remove liblzo2-2 -y

# remove the openvpn package dependencies
apt-get remove --purge --auto-remove libpam0g -y

# remove the openvpn package dependencies
apt-get remove --purge --auto-remove libpkcs11-helper1 -y

# remove the openvpn package dependencies
apt-get remove --purge --auto-remove libssl1.0.0 -y

# remove the openvpn package dependencies
apt-get remove --purge --auto-remove liblz4-1 -y

# remove the openvpn package dependencies
apt-get remove --purge --auto-remove libsystemd0 -y


