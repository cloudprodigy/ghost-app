data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "default" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  user_data = templatefile("${path.module}/user_data.sh", {
    "root_password"  = jsondecode(aws_secretsmanager_secret_version.dbroot_ver.secret_string)["password"],
    "ssh_public_key" = var.ssh_public_key,
    "db_user"        = var.db_username,
    "user_password"  = jsondecode(aws_secretsmanager_secret_version.dbuser_ver.secret_string)["password"],
    "db_name"        = var.db_name

  })

  depends_on = [aws_secretsmanager_secret_version.dbroot_ver, aws_secretsmanager_secret_version.dbuser_ver]

  tags = merge(local.common_tags,
    {
      Name       = "${var.app_name}-${var.environment}",
      Deployment = "Enabled",
      Cron       = "Enabled"
  })



  lifecycle {
    ignore_changes = [
      ami, subnet_id
    ]
  }
}

resource "aws_eip" "default" {
  instance = aws_instance.default.id
  vpc      = true

  tags = merge(local.common_tags,
    {
      Name = "${var.app_name}-${var.environment}"
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "app_server_role"
  path = "/"
  role = aws_iam_role.ec2.name
}

resource "aws_iam_role" "ec2" {
  name               = "app_server_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ec2_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ssm.amazonaws.com"]
    }
  }
}
