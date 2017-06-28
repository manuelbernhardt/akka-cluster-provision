# Akka Cluster Provision

Terraform script for bootstrapping an Akka Cluster on the Google Cloud Engine.

This requires a Consul server (or cluster) to already run, which can be created [here](https://github.com/hashicorp/consul/tree/master/terraform/google.

To run an Ubuntu-based cluster, replace `key_path` and `consul_server_address` with actual values and run:

```shell
terraform apply -var 'key_path=/Users/xyz/akka-cluster.pem' -var 'consul_server_address=x.x.x.x'
```
