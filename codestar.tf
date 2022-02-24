resource "aws_codestarconnections_connection" "this" {
  name          = "${local.app_name}-${local.environment}"
  provider_type = "GitHub"
}