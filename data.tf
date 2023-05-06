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
output "ami" {
  value=data.aws_ami.centos.image_id
}
