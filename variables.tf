variable "platform" {
    default = "ubuntu"
    description = "The OS Platform"
}

variable "user" {
    default = {
        ubuntu  = "ubuntu"
    }
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "

  default = {
    us-east-1-ubuntu      = "ami-fce3c696"
    us-east-2-ubuntu      = "ami-b7075dd2"
    us-west-1-ubuntu      = "ami-a9a8e4c9"
    us-west-2-ubuntu      = "ami-9abea4fb"
    eu-west-1-ubuntu      = "ami-47a23a30"
    eu-central-1-ubuntu   = "ami-accff2b1"
    ap-northeast-1-ubuntu = "ami-90815290"
    ap-northeast-2-ubuntu = "ami-58af6136"
    ap-southeast-1-ubuntu = "ami-0accf458"
    ap-southeast-2-ubuntu = "ami-1dc8b127"
    us-east-1-rhel6       = "ami-0d28fe66"
    us-east-2-rhel6       = "ami-aff2a9ca"
    us-west-2-rhel6       = "ami-3d3c0a0d"
    us-east-1-centos6     = "ami-57cd8732"
    us-east-2-centos6     = "ami-c299c2a7"
    us-west-2-centos6     = "ami-1255b321"
    us-east-1-rhel7       = "ami-2051294a"
    us-east-2-rhel7       = "ami-0a33696f"
    us-west-2-rhel7       = "ami-775e4f16"
    us-east-1-centos7     = "ami-6d1c2007"
    us-east-2-centos7     = "ami-6a2d760f"
    us-west-1-centos7     = "ami-af4333cf"
  }
}

variable "service_conf" {
    default = {
        ubuntu  = "debian_upstart.conf"
    }
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
    description = "Path to the private key used to access the cloud servers"
}

variable "consul_server_address" {
  description   = "IP address of consul server"
}

variable "region" {
  default     = "us-east-1"
  description = "The region of AWS, for AMI lookups."
}

variable "servers" {
    default     = "3"
    description = "The number of Akka nodes to launch"
}

variable "members" {
    default     = "3"
    description = "The number of Akka nodes the actor system expects to work with"
}

variable "papertrail_host" {
    default     = ""
    description = "The papertail host"
}

variable "papertrail_port" {
    default     = ""
    description = "The papertrail port"
}

variable "system_name" {
    default     = "akka-cluster"
    description = "The actor system name"
}

variable "instance_type" {
  default     = "c4.large"
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "aws_security_group" {
  description = "Name of the AWS Security Group allowing access to the consul servers"
}

variable "tag_name" {
    default     = "akka"
    description = "Name tag for the servers"
}
