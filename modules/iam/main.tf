resource "aws_iam_role" "cicd_role" {
  name               = "${var.project_main_prefix}-cicd-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
     {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
     }
]
    }
EOF
}

resource "aws_iam_role_policy" "cicd_role_policy" {
  name   = "access_aws_services"
  policy = data.aws_iam_policy_document.cicd_role_policy_document.json
  role   = aws_iam_role.cicd_role.id
}

data "aws_iam_policy_document" "cicd_role_policy_document" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "codedeploy:*",
      "sns:*"
    ]

    resources = ["*"]
  }


  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }



  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:GetParameters",
      "ssm:AddTagsToResource"
    ]

    resources = ["*"]
  }


  statement {
    actions = [
      "events:DescribeRule",
      "events:DeleteRule",
      "events:ListRuleNamesByTarget",
      "events:ListTargetsByRule",
      "events:PutRule",
      "events:PutTargets",
      "events:RemoveTargets",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfiles",
      "iam:ListRoles",
      "ec2:*"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:CreateGrant",
      "kms:Decrypt"
    ]

    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "codestar-connections:*"
    ]
    resources = ["*"]
  }

}
