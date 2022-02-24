module "codepipeline" {
  source                  = "./modules/codepipeline"
  region                  = local.region
  environment             = local.environment
  project_name            = local.project_name
  github_repo_owner       = "cloudprodigy"
  github_repo_name        = "blog"
  github_repo_branch      = "master"
  s3_artifact_store       = module.artifact_bucket.s3_bucket_name
  cicd_role               = module.iam.cicd_role
  account_id              = data.aws_caller_identity.current.account_id
  codestar_connection_arn = aws_codestarconnections_connection.this.arn
  app_name                = local.app_name
}
