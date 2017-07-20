resource "aws_instance" "akka-template-instance" {
    #count = "${var.servers}"
    ami = "${lookup(var.ami, "${var.region}-${var.platform}")}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${var.aws_security_group}"]

    connection {
        user        = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

    #Instance tags
    tags {
        Name = "akka-template"
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
            "echo ${var.papertrail_port} > /tmp/papertrail-port",
            "echo ${var.consul_server_address} > /tmp/consul-server-addr"
        ]
    }

    provisioner "remote-exec" {
        scripts = [
            "${path.module}/install.sh",
            "${path.module}/ip_tables.sh",
        ]
    }

}

resource "aws_ami_from_instance" "akka-template-ami" {
  name               = "akka-template-ami-${aws_instance.akka-template-instance.id}"
  source_instance_id = "${aws_instance.akka-template-instance.id}"
}

resource "aws_instance" "akka" {
    count = "${var.servers}"
    ami = "${aws_ami_from_instance.akka-template-ami.id}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = ["${var.aws_security_group}"]
    key_name = "${var.key_name}"

    tags {
        Name = "${var.tag_name}-${count.index}"
    }

    connection {
        user        = "${lookup(var.user, var.platform)}"
        private_key = "${file("${var.key_path}")}"
    }

}
