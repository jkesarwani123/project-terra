resource "aws_instance" "instance" {
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [ data.aws_security_group.selected.id ]

  tags = {
    Name = var.component_name
  }
}

resource "aws_route53_record" "records" {
  #for_each = var.components
  zone_id = "Z08610883Q0OU1R5RFMYM"
  name    = "${var.component_name}.jkdevops.online"
  type    = "A"
  ttl     = 30
  records = "aws_instance.instance.private_ip"
}

resource "null_resource" "provisioner"{
  depends_on = [aws_instance.instance,aws_route53_record.records]
  #for_each = var.components
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = "aws_instance.instance.private_ip"
    }

    inline = [
      "rm -rf Sample-Project",
      "git clone https://github.com/jkesarwani123/Sample-Project.git",
      "cd Sample-Project",
      "sudo bash ${var.component_name.sh} ${var.password}"
    ]
  }
}
