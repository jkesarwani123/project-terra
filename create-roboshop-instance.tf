data "aws_ami" "centos" {
  owners           = ["973714476881"]
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
}

data "aws_security_group" "selected" {
  name = "allow-all"
}

output "security_group_id"{
  value = data.aws_security_group.selected
}
variable "instanceTy" {
  default = "t3.micro"
}

output "ami" {
value=data.aws_ami.centos.image_id
}

variable "components" {
  default ={
    frontend={
      name="frontend"
      instance_type = "t3.micro"
    }
    mongodb={
      name="mongodb"
      instance_type = "t3.micro"
    }
    catalogue={
      name="catalogue"
      instance_type = "t3.micro"
    }
    redis={
      name="redis"
      instance_type = "t3.micro"
    }
    user={
      name="user"
      instance_type = "t3.micro"
    }
    cart={
      name="cart"
      instance_type = "t3.micro"
    }
    mysql={
      name="mysql"
      instance_type = "t3.micro"
    }
    shipping={
      name="shipping"
      instance_type = "t3.micro"
    }
    rabbitmq={
      name="rabbitmq"
      instance_type = "t3.micro"
    }
    payment={
      name="payment"
      instance_type = "t3.micro"
    }
    dispatch={
      name="dispatch"
      instance_type = "t3.micro"
    }
  }
}

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
  zone_id = "Z0598390HIMZ28WHPBM2"
  name    = "${each.value["name"]}.mushitude.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance[each.value["name"]].private_ip]
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
#}