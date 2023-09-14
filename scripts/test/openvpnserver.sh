#!/bin/bash

ssl_path=$(pwd)
server_name="testserver"

echo "----------------------- make ssl certificate -----------------------"
echo "----------------------- update and install easy-rsa -----------------------"
# make signed ssl certificate 
sudo apt update
sudo apt install easy-rsa

echo "----------------------- make new directory for easy-rsa -----------------------"

mkdir -p "$server_name/easy-rsa-example"
cp -a /usr/share/easy-rsa "$server_name/easy-rsa-example"

cd "$server_name/easy-rsa-example/easy-rsa"

mv vars.example vars

# EASYRSA_DN "org"
# EASYRSA_REQ_COUNTRY
# EASYRSA_REQ_PROVINCE
# EASYRSA_REQ_CITY
# EASYRSA_REQ_ORG
# EASYRSA_REQ_EMAIL        

sed -i "$server_name/easy-rsa-example/easy-rsa/vars" -e \
    "/export EASYRSA_REQ_COUNTRY*/ c export EASYRSA_REQ_COUNTRY=\"US\""
sed -i "$server_name/easy-rsa-example/easy-rsa/vars" -e \
    "/export EASYRSA_REQ_PROVINCE*/ c export EASYRSA_REQ_PROVINCE=\"CA\""
sed -i "$server_name/easy-rsa-example/easy-rsa/vars" -e \
    "/export EASYRSA_REQ_CITY*/ c export EASYRSA_REQ_CITY=\"SanFrancisco\""
sed -i "$server_name/easy-rsa-example/easy-rsa/vars" -e \
    "/export EASYRSA_REQ_ORG*/ c export EASYRSA_REQ_ORG=\"Fort-Funston\""
sed -i "$server_name/easy-rsa-example/easy-rsa/vars" -e \
    "/export EASYRSA_REQ_EMAIL*/ c export EASYRSA_REQ_EMAIL=mail@host.domain\""
sed -i "$server_name/easy-rsa-example/easy-rsa/vars" -e \
    "/export EASYRSA_DN*/ c export EASYRSA_DN=\"org\"" 



./easyrsa init-pki

# make  "./easyrsa build-ca" without input 
echo "make certificat authority without input"
# ./easyrsa build-ca nopass


echo "--------------------------- Create CA certificate ---------------------------"

echo -e "\n\n\n\n\n\n\n\n" | ./easyrsa build-ca nopass

echo -e "this make two file \n \
        $ssl_path/easy-rsa-example/easy-rsa/pki/ca.crt : public key \n \
        $ssl_path/easy-rsa-example/easy-rsa/pki/private/ca.key : private key \n"




echo "---------------------------- Generate Server Certificate Request and Key ----------------------------"

echo -e "\nyes\n" | ./easyrsa gen-req $server_name nopass

echo -e "this make two file \n \
        $ssl_path/easy-rsa-example/easy-rsa/pki/reqs/server.req : public key \n \
        $ssl_path/easy-rsa-example/easy-rsa/pki/private/server.key : private key \n"

echo "---------------------------- Sign the Server Certificate ----------------------------"
echo -e "yes" |  ./easyrsa sign-req server $server_name


echo "---------------------------- Generate Diffie-Hellman Key Exchange ----------------------------"
./easyrsa gen-dh


echo "---------------------------- Generate TLS Auth Key ----------------------------"
openvpn --genkey secret pki/ta.key

echo "---------------------------- Copy the Files to the OpenVPN Directory ----------------------------"
cat \
  /usr/share/doc/openvpn/examples/sample-config-files/server.conf \
  | sudo tee /etc/openvpn/server.conf > /dev/null


echo
cp "$server_name/easy-rsa-example/easy-rsa/pki/{ca.crt,dh.pem,ta.key}" /etc/openvpn
cp "$server_name/easy-rsa-example/easy-rsa/pki/issued/server.crt" /etc/openvpn
cp "$server_name/easy-rsa-example/easy-rsa/pki/private/server.key" /etc/openvpn


echo "---------------------------- Configure the OpenVPN Service ----------------------------"
echo  -e  "ca ca.crt \n \
        cert server.crt \n \
        key server.key  # This file should be kept secret \n \
        dh dh.pem \n \
        ;tls-auth ta.key 0 # This file is secret \n \
        tls-crypt ta.key"  > /etc/openvpn/server.conf

# Enable IP Forwarding    

echo "---------------------------- Enable IP Forwarding ----------------------------"
sed -i "/#net.ipv4.ip_forward=1*/ c net.ipv4.ip_forward=1" /etc/sysctl.conf
sysctl -p

echo "---------------------------- Start and Enable the OpenVPN Service ----------------------------"
systemctl start openvpn@server 
systemctl enable openvpn@server

echo "---------------------------- Configure the UFW Firewall ----------------------------"
ufw allow OpenVPN




