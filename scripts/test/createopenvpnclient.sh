#!/bin/bash

# this script to make client to connect to openvpn server

ssl_path=$(pwd)

cd "$ssl_path/easy-rsa-example/easy-rsa"

# make client certificate
echo "--------------------------- Create client certificate ---------------------------"

# get client name from user 
echo "enter client name"
read client_name

echo -e "\n\n\n\n\n\n\n\n" | ./easyrsa build-client-full $client_name  nopass

echo -e "this make three file \n \
        $ssl_path/easy-rsa-example/easy-rsa/pki/issued/client.crt : public key \n \
        $ssl_path/easy-rsa-example/easy-rsa/pki/private/client.key : private key \n \
        $ssl_path/easy-rsa-example/easy-rsa/pki/reqs/client.req : request file \n "

cp "$ssl_path/easy-rsa-example/easy-rsa/pki/private/$client_name.key"  /etc/openvpn/client/
cp "$ssl_path/easy-rsa-example/easy-rsa/pki/issued/$client_name.crt"  /etc/openvpn/client/
cp "$ssl_path/easy-rsa-example/easy-rsa/pki/{ca.crt,ta.key}"  /etc/openvpn/client/


cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf "$client_name/easy-rsa-example/easy-rsa/"



echo -e "remote my-server-1 1194 # my-server-1 is the server public IP \n \
        user nobody \n \
        group nogroup   \n \
        ;ca ca.crt  \n \
        ;cert client.crt \n \
        ;key client.key \n \
        ;tls-auth ta.key 1 \n \
        key-direction 1 \n  " > "$client_name/easy-rsa-example/easy-rsa/client.conf"