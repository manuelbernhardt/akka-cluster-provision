variable "platform" {
    default = "ubuntu"
    description = "The OS Platform"
}

variable "user" {
    default = {
        ubuntu  = "ubuntu"
    }
}

variable "machine_image" {
    default = {
        ubuntu  = "ubuntu-os-cloud/ubuntu-1404-trusty-v20160314"
    }
}

variable "service_conf" {
    default = {
        ubuntu  = "debian_upstart.conf"
    }
}
variable "service_conf_dest" {
    default = {
        ubuntu  = "upstart.conf"
    }
}

variable "key_path" {
    description = "Path to the private key used to access the cloud servers"
}

variable "consul_server_address" {
  description   = "IP address of consul server"
}

variable "region" {
    default     = "us-central1"
    description = "The region of Google Cloud where to launch the cluster"
}

variable "region_zone" {
    default     = "us-central1-f"
    description = "The zone of Google Cloud in which to launch the cluster"
}

variable "servers" {
    default     = "3"
    description = "The number of Akka nodes to launch"
}

variable "machine_type" {
    default     = "f1-micro"
    description = "Google Cloud Compute machine type"
}

variable "tag_name" {
    default     = "akka"
    description = "Name tag for the servers"
}
