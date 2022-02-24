module "artifact_bucket" {
  source      = "./modules/s3log"
  environment = local.environment
  bucket_name = "build-artifacts"
  account_id  = data.aws_caller_identity.current.account_id
  service     = "codepipeline"
}
