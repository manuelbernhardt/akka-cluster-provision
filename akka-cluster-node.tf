resource "google_compute_instance" "akka" {
    count = "${var.servers}"

    name = "akka-${count.index}"
    zone = "${var.region_zone}"
    tags = ["${var.tag_name}"]

    machine_type = "${var.machine_type}"

    disk {
        image = "${lookup(var.machine_image, var.platform)}"
    }

    network_interface {
        network = "default"

        access_config {
            # Ephemeral
        }
    }

    service_account {
        scopes = ["https://www.googleapis.com/auth/compute.readonly"]
    }

    connection {
        user        = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    provisioner "file" {
        source      = "${path.module}/akka_upstart.conf"
        destination = "/tmp/akka_upstart.conf"
    }

    provisioner "file" {
        source      = "${path.module}/consul_upstart.conf"
        destination = "/tmp/consul_upstart.conf"
    }

    provisioner "file" {
        source      = "${path.module}/akka-fd-benchmark.jar"
        destination = "/tmp/akka-fd-benchmark.jar"
    }

    # Consul cluster already formed by https://github.com/hashicorp/consul/tree/master/terraform/google
    provisioner "remote-exec" {
        inline = [
            "echo ${var.servers} > /tmp/akka-server-count",
            "echo ${var.consul_server_address} > /tmp/consul-server-addr"
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/install.sh",
            "${path.module}/service.sh",
            "${path.module}/ip_tables.sh",
        ]
    }

}

resource "google_compute_firewall" "consul_agent_ingress" {
    name = "consul-agent-internal-access"
    network = "default"

    allow {
        protocol = "tcp"
        ports = [
            "8500", # HTTP
            "8600"  # DNS
        ]
    }

    source_tags = ["${var.tag_name}"]
    target_tags = ["${var.tag_name}"]
}

resource "google_compute_firewall" "akka_ingress" {
    name = "akka-internal-access"
    network = "default"

    allow {
        protocol = "tcp"
        ports = [
            "2552"
        ]
    }

    allow {
      protocol = "udp"
      ports = [
        "25520"
      ]
    }

    source_tags = ["${var.tag_name}"]
    target_tags = ["${var.tag_name}"]
}
