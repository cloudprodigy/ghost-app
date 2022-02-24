locals {
  dbroot_creds = {
    password = random_id.root_password.b64_url
  }
  dbuser_creds = {
    password = random_id.user_password.b64_url
  }
}
resource "random_id" "root_password" {
  byte_length = 20
  lifecycle {
    ignore_changes = all
  }
}

resource "random_id" "user_password" {
  byte_length = 20
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_secretsmanager_secret" "dbroot" {
  name_prefix = "dbroot-${var.app_name}"
}

resource "aws_secretsmanager_secret_version" "dbroot_ver" {
  secret_id     = aws_secretsmanager_secret.dbroot.id
  secret_string = jsonencode(local.dbroot_creds)
}

resource "aws_secretsmanager_secret" "dbuser" {
  name_prefix = "dbuser-${var.app_name}"
}

resource "aws_secretsmanager_secret_version" "dbuser_ver" {
  secret_id     = aws_secretsmanager_secret.dbuser.id
  secret_string = jsonencode(local.dbuser_creds)
}
