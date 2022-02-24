data "archive_file" "os_user" {
  type        = "zip"
  source_file = "${path.module}/code/os_user.py"
  output_path = "${path.module}/code/os_user.zip"
}

resource "aws_lambda_function" "os_user" {
  filename         = data.archive_file.os_user.output_path
  function_name    = "manageBastionOSUsers-${var.environment}"
  role             = aws_iam_role.default.arn
  handler          = "os_user.handler"
  source_code_hash = filebase64sha256(data.archive_file.os_user.output_path)
  runtime          = "python3.8"
  timeout          = 60
  tags             = local.common_tags

}
