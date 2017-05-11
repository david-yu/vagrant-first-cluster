# Join UCP Swarm
< /dev/urandom tr -dc a-f0-9 | head -c${1:-12} > /vagrant/dtr-replica-id
export UCP_IPADDR=172.28.128.31
export DTR_IPADDR=172.28.128.34
export UCP_PASSWORD=$(cat /vagrant/ucp_password)
export DTR_REPLICA_ID=$(cat /vagrant/dtr-replica-id)
docker swarm join --token SWMTKN-1-1xkrglei9xno157rs13z04q81jp10qvf8xh9lobb8b8c6jxry6-6pbomvl4pq13m6gh6j4kr8m0n 172.28.128.31:2377

# Install DTR
curl -k https://ucp.local/ca > ucp-ca.pem
docker run --rm docker/dtr:2.2.4 install --ucp-url https://${UCP_IPADDR} --ucp-node dtr-node1.local --replica-id ${DTR_REPLICA_ID} --dtr-external-url https://dtr.local --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat ucp-ca.pem)"
# Run backup of DTR
docker run --rm docker/dtr:2.2.4 backup --ucp-url https://${UCP_IPADDR} --existing-replica-id ${DTR_REPLICA_ID} --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat ucp-ca.pem)" > /tmp/backup.tar
# Trust self-signed DTR CA
sudo curl -k https://dtr.local/ca -o /etc/pki/ca-trust/source/anchors/dtr.local.crt
sudo update-ca-trust
sudo /bin/systemctl restart docker.service

# Copy convenience scripts
sudo cp -r /vagrant/scripts /home/ubuntu/scripts
# Download UCP client bundle
echo "Retrieving authtoken"
export AUTHTOKEN=$(curl -sk -d '{"username":"admin","password":"'"${UCP_PASSWORD}"'"}' https://${UCP_IPADDR}/auth/login | jq -r .auth_token)
sudo mkdir ucp-bundle-admin
echo "Downloading ucp bundle"
sudo curl -k -H "Authorization: Bearer ${AUTHTOKEN}" https://${UCP_IPADDR}/api/clientbundle -H 'accept: application/json, text/plain, */*' --insecure > /home/ubuntu/ucp-bundle-admin/bundle.zip
sudo unzip /home/ubuntu/ucp-bundle-admin/bundle.zip -d /home/ubuntu/ucp-bundle-admin/
sudo rm -f /home/ubuntu/ucp-bundle-admin/bundle.zip

# Bootstrap DTR
# Install Notary
curl -L https://github.com/docker/notary/releases/download/v0.4.3/notary-Linux-amd64 > /home/ubuntu/notary
chmod +x /home/ubuntu/notary
# create users
createUser() {
	USER_NAME=$1
  FULL_NAME=$2
  curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" \
    --user admin:dockeradmin -d "{
      \"isOrg\": false,
      \"isAdmin\": false,
      \"isActive\": true,
      \"fullName\": \"${FULL_NAME}\",
      \"name\": \"${USER_NAME}\",
      \"password\": \"docker123\"}" \
      "https://${DTR_IPADDR}/enzi/v0/accounts"
}
createUser david 'David Yu'
createUser solomon 'Solomon Hykes'
createUser banjot 'Banjot Chanana'
createUser vivek 'Vivek Saraswat'
createUser chad 'Chad Metcalf'
# create organizations
createOrg() {
	ORG_NAME=$1
	curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" \
    --user admin:dockeradmin -d "{
      \"isOrg\": true,
      \"name\": \"${ORG_NAME}\"}" \
      "https://${DTR_IPADDR}/enzi/v0/accounts"
}
createOrg engineering
createOrg infrastructure
# import notary private key
notary -d ~/.docker/trust key import /home/ubuntu/ucp-bundle-admin/key.pem
# create repositories
createRepo() {
    REPO_NAME=$1
    ORG_NAME=$2
    NOTARY_ROOT_PASSPHRASE="docker123"
    NOTARY_TARGETS_PASSPHRASE="docker123"
    NOTARY_SNAPSHOT_PASSPHRASE="docker123"
    NOTARY_DELEGATION_PASSPHRASE="docker123"
    NOTARY_OPTS="-s https://${DTR_URL} -d ${HOME}/.docker/trust"
    curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" \
      --user admin:dockeradmin -d "{
      \"name\": \"${REPO_NAME}\",
      \"shortDescription\": \"\",
      \"longDescription\": \"\",
      \"visibility\": \"public\"}" \
      "https://${DTR_IPADDR}/api/v0/repositories/${ORG_NAME}"
    notary -d ~/.docker/trust -s ${DTR_IPADDR} init ${DTR_IPADDR}/${ORG_NAME}/${REPO_NAME}
    notary -d ~/.docker/trust -s ${DTR_IPADDR} key rotate ${DTR_IPADDR}/${ORG_NAME}/${REPO_NAME} snapshot -r
    notary -d ~/.docker/trust publish -s ${DTR_IPADDR} ${DTR_IPADDR}/${ORG_NAME}/${REPO_NAME}
}
createRepo mongo engineering
createRepo wordpress engineering
createRepo mariadb engineering
createRepo leroy-jenkins infrastructure
# pull images from hub
docker pull mongo
docker pull wordpress
docker pull mariadb
# build custom images
docker build -t leroy-jenkins .
# tag images
docker tag mongo ${DTR_IPADDR}/engineering/mongo:latest
docker tag wordpress ${DTR_IPADDR}/engineering/wordpress:latest
docker tag mariadb ${DTR_IPADDR}/engineering/mariadb:latest
docker tag leroy-jenkins ${DTR_IPADDR}/infrastructure/leroy-jenkins:latest
# push signed images
docker push ${DTR_IPADDR}/engineering/mongo:latest
docker push ${DTR_IPADDR}/engineering/wordpress:latest
docker push ${DTR_IPADDR}/engineering/mariadb:latest
docker push ${DTR_IPADDR}/infrastructure/leroy-jenkins:latest
