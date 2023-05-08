
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
      "sudo bash ${each.value["name"]}.sh lookup(each.value,\"password\",\"dummy\")"
      ]
  }
}

#resource "aws_instance" "frontend" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instanceTy
#  vpc_security_group_ids = [ data.aws_security_group.selected.id ]
#
#  tags = {
#    Name = "frontend"
#  }
#}
#
#resource "aws_route53_record" "frontend" {
#  zone_id = "Z0598390HIMZ28WHPBM2"
#  name    = "frontend.mushitude.online"
#  type    = "A"
#  ttl     = 30
#  records = [aws_instance.frontend.private_ip]
#}
#
#//output "frontend" {
#// value=aws_instance.frontend.private_ip
#//}
#
#resource "aws_instance" "mongodb" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instanceTy
#  vpc_security_group_ids = [ data.aws_security_group.selected.id ]
#
#  tags = {
#    Name = "mongodb"
#  }
#}
#
#resource "aws_route53_record" "mongodb" {
#  zone_id = "Z0598390HIMZ28WHPBM2"
#  name    = "mongodb.mushitude.online"
#  type    = "A"
#  ttl     = 30
#  records = [aws_instance.mongodb.private_ip]
#}
#
#resource "aws_instance" "catalogue" {
#  ami           = data.aws_ami.centos.image_id
#  instance_type = var.instanceTy
#  vpc_security_group_ids = [ data.aws_security_group.selected.id ]
#
#  tags = {
#    Name = "catalogue"
#  }
#}
#
#resource "aws_route53_record" "catalogue" {
#  zone_id = "Z0598390HIMZ28WHPBM2"
#  name    = "catalogue.mushitude.online"
#  type    = "A"
#  ttl     = 30
#  records = [aws_instance.catalogue.private_ip]
#}"