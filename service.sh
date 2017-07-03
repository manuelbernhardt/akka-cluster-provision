#!/usr/bin/env bash
set -e

echo "Starting Akka..."
sudo start akka

echo "Starting Consul..."
sudo start consul
