#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer
sudo apt-get install -y unzip
sudo apt-get install -y ntp
sudo apt-get install -y wget

echo "Fetching Consul..."
CONSUL=0.8.5
cd /tmp
wget https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_amd64.zip -O consul.zip --quiet

echo "Installing Consul..."
unzip consul.zip >/dev/null
chmod +x consul
sudo mv consul /usr/local/bin/consul
sudo mkdir -p /opt/consul/data

CONSUL_JOIN=$(cat /tmp/consul-server-addr | tr -d '\n')

# Write the flags to a temporary file
cat >/tmp/consul_flags << EOF
CONSUL_FLAGS="-join=${CONSUL_JOIN} -data-dir=/opt/consul/data"
EOF

echo "Installing Upstart service for consul..."
sudo mkdir -p /etc/consul.d
sudo mkdir -p /etc/service
sudo chown root:root /tmp/consul_upstart.conf
sudo mv /tmp/consul_upstart.conf /etc/init/consul.conf
sudo chmod 0644 /etc/init/consul.conf
sudo mv /tmp/consul_flags /etc/service/consul
sudo chmod 0644 /etc/service/consul

echo "Installing akka..."
sudo mkdir -p /opt/akka
sudo mv /tmp/akka-fd-benchmark.jar /opt/akka
echo "phi" > /tmp/failure-detector
sudo mv /tmp/failure-detector /opt/akka

echo "Installing Upstart service for akka..."
sudo mkdir -p /etc/akka.d
sudo chown root:root /tmp/akka_upstart.conf
sudo mv /tmp/akka_upstart.conf /etc/init/akka.conf
SERVER_COUNT=$(cat /tmp/akka-server-count | tr -d '\n')
PAPERTRAIL_HOST=$(cat /tmp/papertail-host | tr -d '\n')
PAPERTRAIL_PORT=$(cat /tmp/papertrail-port | tr -d '\n')
sudo sed "s/  export EXPECT_MEMBERS=.*/  export EXPECT_MEMBERS=${SERVER_COUNT}/g" /etc/init/akka.conf
sudo sed "s/  export PAPERTRAIL_HOST=.*/  export PAPERTRAIL_HOST=${PAPERTRAIL_HOST}/g" /etc/init/akka.conf
sudo sed "s/  export PAPERTRAIL_PORT=.*/  export PAPERTRAIL_PORT=${PAPERTRAIL_PORT}/g" /etc/init/akka.conf
sudo chmod 0644 /etc/init/akka.conf
