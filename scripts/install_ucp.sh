export UCP_IPADDR=$(cat /vagrant/centos-ucp-node1)
export UCP_PASSWORD=$(cat /vagrant/ucp_password)
export HUB_USERNAME=$(cat /vagrant/hub_username)
export HUB_PASSWORD=$(cat /vagrant/hub_password)
docker login -u ${HUB_USERNAME} -p ${HUB_PASSWORD}
docker pull docker/ucp:2.1.4
docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.1.4 install --host-address ${UCP_IPADDR} --admin-password ${UCP_PASSWORD} --san ucp.local --license $(cat /vagrant/docker_subscription.lic) --debug
docker swarm join-token manager | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-mgr
docker swarm join-token worker | awk -F " " '/token/ {print $2}' > /vagrant/swarm-join-token-worker
docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.1.4 id | awk '{ print $1}' > /vagrant/ucp-vancouver-id
export UCP_ID=$(cat /vagrant/ucp-vancouver-id)
docker run --rm -i --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.1.4 backup --id ${UCP_ID} --root-ca-only --passphrase "secret" > /vagrant/backup.tar
