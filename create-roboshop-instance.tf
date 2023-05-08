
resource "aws_instance" "instance" {
  //count         = length ( var.components )
  for_each = var.components
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [ data.aws_security_group.selected.id ]

  tags = {
    Name = each.value["name"]
  }
}

resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id = "Z08610883Q0OU1R5RFMYM"
  name    = "${each.value["name"]}.jkdevops.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance[each.value["name"]].private_ip]
}

resource "null_resource" "provisioner"{
  depends_on = [aws_instance.instance,aws_route53_record.records]
  for_each = var.components
  provisioner "remote-exec" {
  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = "[aws_instance.instance[each.value[\"name\"]].private_ip]"
  }

    inline = [
      "rm -rf Sample-Project",
      "git clone https://github.com/jkesarwani123/Sample-Project.git",
      "cd Sample-Project",
      "sudo bash ${each.value["name"]}.sh ${lookup(each.value,"password","null")}"
      ]
  }
}
