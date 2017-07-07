resource "aws_instance" "akka" {
    count = "${var.servers}"
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    security_groups = ["${aws_security_group.akka.name}"]

    connection {
        user        = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    #Instance tags
    tags {
        Name = "${var.tag_name}-${count.index}"
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
            "echo ${var.papertrail_host} > /tmp/papertrail-host",
            "echo ${var.papertrail_port} > /tmp/papertail-port",
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

resource "aws_security_group" "akka" {
    name = "akka${var.platform}"
    description = "Akka internal traffic + maintenance."

    // These are for internal traffic
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        self = true
    }

    // These are for maintenance
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // This is for outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
