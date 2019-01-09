#!/bin/bash

set -eu

PKS_DOMAIN=$1

SSL_FILE=sslconf-${PKS_DOMAIN}.conf

#Generate SSL Config with SANs
if [ ! -f $SSL_FILE ]; then
 cat > $SSL_FILE <<EOM
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
[req_distinguished_name]
#countryName = Country Name (2 letter code)
#countryName_default = US
#stateOrProvinceName = State or Province Name (full name)
#stateOrProvinceName_default = TX
#localityName = Locality Name (eg, city)
#localityName_default = Frisco
#organizationalUnitName     = Organizational Unit Name (eg, section)
#organizationalUnitName_default   = Pivotal Labs
#commonName = Pivotal
#commonName_max = 64
[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.${PKS_DOMAIN}
EOM
fi

openssl genrsa -out ${PKS_DOMAIN}.key 2048
openssl req -new -out ${PKS_DOMAIN}.csr -subj "/CN=*.${PKS_DOMAIN}/O=Pivotal/C=US" -key ${PKS_DOMAIN}.key -config ${SSL_FILE} -sha256
openssl req -text -noout -in ${PKS_DOMAIN}.csr -sha256
openssl x509 -req -days 3650 -in ${PKS_DOMAIN}.csr -signkey ${PKS_DOMAIN}.key -out ${PKS_DOMAIN}.crt -extensions v3_req -extfile ${SSL_FILE} -sha256
openssl x509 -in ${PKS_DOMAIN}.crt -text -noout
