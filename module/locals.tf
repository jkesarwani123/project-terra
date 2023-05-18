locals {
  name = var.component_name
  db_commands = [
    "rm -rf Sample-Project",
    "git clone https://github.com/jkesarwani123/Sample-Project.git",
    "cd Sample-Project",
    "sudo bash ${var.component_name}.sh ${var.password}"
  ]
  app_commands = [
    "sudo labauto ansible",
    "ansible-pull -i localhost, -U https://github.com/jkesarwani123/roboshop-ansible roboshop.yml -e env=${var.env} -e role_name=${var.component_name}"
  ]

  db_tags = {
    Name = "${var.component_name}"
  }

  app_tags ={
    Name = "${var.component_name}"
    Monitor = "true"
  }
}