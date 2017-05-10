openssl genrsa -out CAkey.pem 2048
openssl req -new -key CAkey.pem -x509 -days 365 -out ca.pem -sha256
openssl genrsa -out UCPkey.pem 2048
openssl req -subj "/CN=ucp.local" -new -key UCPkey.pem -out UCP.csr -sha256
openssl x509 -req -days 365 -in UCP.csr -CA ca.pem -CAkey CAkey.pem -CAcreateserial -out UCPcrt.pem -extensions v3_req -sha256
openssl rsa -in UCPkey.pem -out UCPkey.pem
openssl genrsa -out DTRkey.pem 2048
openssl req -subj "/CN=dtr.local" -new -key DTRkey.pem -out DTR.csr -sha256
openssl x509 -req -days 365 -in DTR.csr -CA ca.pem -CAkey CAkey.pem -CAcreateserial -out DTRcrt.pem -extensions v3_req -sha256
openssl rsa -in DTRkey.pem -out DTRkey.pem
