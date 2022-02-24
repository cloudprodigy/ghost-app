data "local_file" "ssh_public_key" {
  filename = "ssh_public_keys/id_rsa.pub"
}

data "aws_caller_identity" "current" {}
