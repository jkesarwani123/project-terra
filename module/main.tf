resource "aws_instance" "instance" {
  ami           = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [ data.aws_security_group.selected.id ]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  tags = {
    Name = var.component_name
  }
}


resource "null_resource" "provisioner"{
  count=var.provisioner? 1 : 0
  depends_on = [aws_instance.instance,aws_route53_record.records]
  #for_each = var.components
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance.private_ip
    }
    inline = var.app_type == "db" ? local.db_commands : local.app_commands
  }
}


resource "aws_route53_record" "records" {
  #for_each = var.components
  zone_id = "Z08610883Q0OU1R5RFMYM"
  name    = "${var.component_name}.jkdevops.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

resource "aws_iam_role" "role" {
  name = "${var.component_name}.${var.env}.role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.component_name}.${var.env}.role"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.component_name}-${var.env}-role"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "ssm_roboshop_policy" {
  name = "${var.component_name}.${var.env}.role"
  role = aws_iam_role.role.id
  policy = jsonencode({

    "Version": "2012-10-17",
    "Statement": [
    {
    "Effect": "Allow",
    "Action": "iam:CreateServiceLinkedRole",
    "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
    "Condition": {
    "StringLike": {
    "iam:AWSServiceName": "ssm.amazonaws.com"
  }
  }
  },
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "kms:GetParametersForImport",
          "kms:Decrypt",
          "kms:ListAliases"
        ],
        "Resource": "*"
      },
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "ssm:GetParameterHistory",
          "ssm:DescribeDocumentParameters",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource": "*"
#        "Resource": [
#          "arn:aws:ssm:us-east-1:043742147815:document/dev.frontend.*",
#          "arn:aws:ssm:us-east-1:043742147815:parameter/dev.frontend.*"
#        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "cloudwatch:PutMetricData",
          "ds:CreateComputer",
          "ds:DescribeDirectories",
          "ec2:DescribeInstanceStatus",
          "logs:*",
          "ssm:*",
          "ec2messages:*"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "iam:DeleteServiceLinkedRole",
          "iam:GetServiceLinkedRoleDeletionStatus"
        ],
        "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ],
        "Resource": "*"
      }

    ]
  })
}