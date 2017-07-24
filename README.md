# Akka Cluster Provision

Terraform script for bootstrapping an Akka Cluster on AWS.

This requires a Consul server (or cluster) to already run, which can be created [here](https://github.com/hashicorp/consul/tree/master/terraform/aws.

To run a cluster, provide the following variables (the Papertrail variables are optional but useful to get aggregated logs):

```shell
terraform apply -var 'region=us-east-1' \
                -var 'key_name=akka' \
                -var 'key_path=/home/ubuntu/.ssh/akka.pem' \
                -var 'consul_server_address=x.x.x.x' \
                -var 'servers=3' \
                -var 'members=3' \
                -var 'aws_security_group=sg-1234567' \
                -var 'papertrail_host=logsN.papertrailapp.com' \
                -var 'papertrail_port=1234'

```
