#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update -y
sudo apt-get -y install oracle-java8-installer
sudo apt-get install -y unzip
sudo apt-get install -y ntp
sudo apt-get install -y wget

echo "Fetching Consul..."
CONSUL=0.8.3
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
sudo chown root:root /tmp/upstart.conf
sudo mv /tmp/upstart-consul.conf /etc/init/consul.conf
sudo chmod 0644 /etc/init/consul.conf
sudo mv /tmp/consul_flags /etc/service/consul
sudo chmod 0644 /etc/service/consul



echo "Installing akka..."
sudo mkdir -p /opt/akka
sudo mv /tmp/akka.jar /opt/akka
sudo echo "phi" > /opt/akka/failure-detector

echo "Installing Upstart service for akka..."
sudo mkdir -p /etc/akka.d
sudo chown root:root /tmp/upstart.conf
sudo mv /tmp/upstart-akka.conf /etc/init/akka.conf
sudo chmod 0644 /etc/init/akka.conf
