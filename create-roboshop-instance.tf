data "aws_ami" "centos" {
  owners           = ["973714476881"]
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
}

output "ami" {
value=data.aws_ami.centos.image_id
}
resource "aws_instance" "frontend" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "frontend"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = "Z0598390HIMZ28WHPBM2"
  name    = "frontend.mushitude.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.frontend.private_ip]
}

//output "frontend" {
// value=aws_instance.frontend.private_ip
//}

resource "aws_instance" "mongodb" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "mongodb"
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = "Z0598390HIMZ28WHPBM2"
  name    = "mongodb.mushitude.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.mongodb.private_ip]
}

resource "aws_instance" "catalogue" {
  ami           = data.aws_ami.centos.image_id
  instance_type = "t3.micro"

  tags = {
    Name = "catalogue"
  }
}

resource "aws_route53_record" "catalogue" {
  zone_id = "Z0598390HIMZ28WHPBM2"
  name    = "catalogue.mushitude.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.catalogue.private_ip]
}