resource "aws_codedeploy_app" "default" {
  compute_platform = "Server"
  name             = "${var.project_name}-${var.app_name}-app"
}

resource "aws_codedeploy_deployment_group" "default" {
  app_name              = aws_codedeploy_app.default.name
  deployment_group_name = "${var.project_name}-${var.app_name}-group"
  service_role_arn      = var.cicd_role

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Deployment"
      type  = "KEY_AND_VALUE"
      value = "Enabled"
    }
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "build-failure"
    trigger_target_arn = aws_sns_topic.default.arn
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.project_name}-pipeline-${var.app_name}"
  role_arn = var.cicd_role
  tags     = local.common_tags

  artifact_store {
    location = var.s3_artifact_store
    type     = "S3"
  }

  stage {
    name = "source-${var.project_name}-${var.app_name}"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = "${var.github_repo_owner}/${var.github_repo_name}"
        BranchName       = var.github_repo_branch

      }
    }
  }

  stage {
    name = "deploy-${var.project_name}-${var.app_name}"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["source"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.default.name
        DeploymentGroupName = aws_codedeploy_deployment_group.default.deployment_group_name
      }

      run_order = "1"
    }
  }
}


