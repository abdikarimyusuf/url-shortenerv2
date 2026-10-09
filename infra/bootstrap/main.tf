resource "aws_s3_bucket" "state" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.name}-bucket"
  }
}


resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "oidc" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [ #audiance
    "sts.amazonaws.com"
  ]

  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint
  ]

  tags = {
    Name = "${var.name}-github-oidc"
  }

}


data "aws_iam_policy_document" "github_actions_assume_role_trust_policy" {
  statement { #rule
    effect = "Allow"
    principals {         #who
      type = "Federated" #externel

      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:abdikarimyusuf@135855913/url-shortenerv2@1359477764:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = "${var.name}-github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_trust_policy.json
  tags = {
    Name = "${var.name}-github-actions-role"
  }
}

data "aws_iam_policy_document" "github_actions_role_permissions" {
  statement {
    sid    = "ECR"
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:CreateRepository",

    ]

    resources = ["*"]
  }

  statement {
    sid    = "ECRRepositories"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeRepositories",
      "ecr:DescribeImages",
      "ecr:ListImages"
    ]

    resources = ["*"]
  }
  statement {
    sid    = "TerraformStateBucketAccess"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:CreateBucket",
    ]

    resources = [
      "arn:aws:s3:::url-shortener-bucket-1234567890123"
    ]
  }

  statement {
    sid    = "TerraformStateObjectAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::url-shortener-bucket-1234567890123/url-shortener/terraform.tfstate"
    ]
  }

  statement {
    sid    = "TerraformStateLockAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::url-shortener-bucket-1234567890123/url-shortener/terraform.tfstate.tflock"
    ]
  }

  statement {
    sid    = "Route53"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:GetChange",
      "route53:ListResourceRecordSets",
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:GetHostedZone",
      "route53:ListTagsForResource",
      "route53:ChangeTagsForResource"
    ]

    resources = ["*"]
  }

  # EC2 networking and VPC
  statement {
    sid    = "EC2VpcNetworking"
    effect = "Allow"

    actions = [
      "ec2:Describe*",
      "ec2:CreateVpc",
      "ec2:DeleteVpc",
      "ec2:ModifyVpcAttribute",
      "ec2:CreateSubnet",
      "ec2:DeleteSubnet",
      "ec2:ModifySubnetAttribute",
      "ec2:CreateRouteTable",
      "ec2:DeleteRouteTable",
      "ec2:CreateRoute",
      "ec2:DeleteRoute",
      "ec2:ReplaceRoute",
      "ec2:AssociateRouteTable",
      "ec2:DisassociateRouteTable",
      "ec2:CreateInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:AttachInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:AllocateAddress",
      "ec2:ReleaseAddress",
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress",
      "ec2:CreateNatGateway",
      "ec2:DeleteNatGateway",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:CreateVpcEndpoint",
      "ec2:ModifyVpcEndpoint",
      "ec2:DeleteVpcEndpoints",
      "ec2:CreateTags",
      "ec2:DeleteTags"
    ]

    resources = ["*"]
  }

  # ECS and ECR
  statement {
    sid    = "ECSAndECR"
    effect = "Allow"

    actions = [
      "ecs:*",
      "ecr:*"
    ]

    resources = ["*"]
  }

  # Application Load Balancer
  statement {
    sid    = "ApplicationLoadBalancers"
    effect = "Allow"

    actions = [
      "elasticloadbalancing:*"
    ]

    resources = ["*"]
  }

  # ACM certificates
  statement {
    sid    = "ACMCertificates"
    effect = "Allow"

    actions = [
      "acm:AddTagsToCertificate",
      "acm:DeleteCertificate",
      "acm:DescribeCertificate",
      "acm:ExportCertificate",
      "acm:GetCertificate",
      "acm:ImportCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate",
      "acm:RemoveTagsFromCertificate",
      "acm:RequestCertificate",
      "acm:ResendValidationEmail",
      "acm:UpdateCertificateOptions"
    ]

    resources = ["*"]
  }

  # CloudFront
  statement {
    sid    = "CloudFront"
    effect = "Allow"

    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:CreateDistributionWithTags",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:ListDistributions",
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:ListOriginAccessControls",
      "cloudfront:UpdateOriginAccessControl",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:ListTagsForResource",
      "cloudfront:GetCachePolicy",
      "cloudfront:ListCachePolicies",
      "cloudfront:GetOriginRequestPolicy",
      "cloudfront:ListOriginRequestPolicies",
      "cloudfront:GetResponseHeadersPolicy",
      "cloudfront:ListResponseHeadersPolicies"
    ]

    resources = ["*"]
  }

  # AWS WAFv2
  statement {
    sid    = "WAFv2"
    effect = "Allow"

    actions = [
      "wafv2:CreateWebACL",
      "wafv2:DeleteWebACL",
      "wafv2:GetWebACL",
      "wafv2:ListWebACLs",
      "wafv2:UpdateWebACL",
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL",
      "wafv2:CreateIPSet",
      "wafv2:DeleteIPSet",
      "wafv2:GetIPSet",
      "wafv2:UpdateIPSet",
      "wafv2:GetWebACLForResource",
      "wafv2:ListIPSets",
      "wafv2:ListResourcesForWebACL",
      "wafv2:ListAvailableManagedRuleGroups",
      "wafv2:ListTagsForResource",
      "wafv2:TagResource",
      "wafv2:UntagResource",
      "wafv2:CheckCapacity",
      "wafv2:GetLoggingConfiguration",
      "wafv2:PutLoggingConfiguration",
      "wafv2:DeleteLoggingConfiguration"
    ]

    resources = ["*"]
  }

  # SQS queues
  statement {
    sid    = "SQSQueues"
    effect = "Allow"

    actions = [
      "sqs:CreateQueue",
      "sqs:DeleteQueue",
      "sqs:GetQueueAttributes",
      "sqs:SetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListQueues",
      "sqs:TagQueue",
      "sqs:UntagQueue",
      "sqs:ListQueueTags"
    ]

    resources = ["*"]
  }

  # RDS
  statement {
    sid       = "RDS"
    effect    = "Allow"
    actions   = ["rds:*"]
    resources = ["*"]
  }

  # ElastiCache / Redis
  statement {
    sid       = "ElastiCacheRedis"
    effect    = "Allow"
    actions   = ["elasticache:*"]
    resources = ["*"]
  }

  # CloudWatch and CloudWatch Logs
  statement {
    sid    = "CloudWatchAndLogs"
    effect = "Allow"

    actions = [
      "cloudwatch:DescribeAlarms",
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:TagResource",
      "cloudwatch:UntagResource",
      "cloudwatch:ListTagsForResource",
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:ListTagsForResource",
      "logs:TagResource",
      "logs:UntagResource"
    ]

    resources = ["*"]
  }

  # Create and manage project IAM roles and policies
  statement {
    sid    = "CreateAndManageProjectIAMRoles"
    effect = "Allow"

    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:UpdateRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:GetPolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:SetDefaultPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:TagPolicy",
      "iam:UntagPolicy"
    ]

    resources = [
      "arn:aws:iam::266380778025:role/url-shortener-*",
      "arn:aws:iam::266380778025:policy/url-shortener-*"
    ]
  }

  # Allow ECS to use the project task roles
  statement {
    sid       = "PassProjectRolesToAWSServices"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::266380778025:role/url-shortener-*"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"

      values = [
        "ecs-tasks.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }

  # Create service-linked roles when required
  statement {
    sid       = "CreateRequiredServiceLinkedRoles"
    effect    = "Allow"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"

      values = [
        "elasticloadbalancing.amazonaws.com",
        "ecs.amazonaws.com",
        "rds.amazonaws.com",
        "elasticache.amazonaws.com"
      ]
    }
  }

  # Secrets Manager metadata
  statement {
    sid    = "SecretsManagerMetadata"
    effect = "Allow"

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets",
      "secretsmanager:TagResource",
      "secretsmanager:UntagResource"
    ]

    resources = ["*"]
  }

  # Allow creation and discovery of the frontend bucket
  statement {
    sid    = "FrontendBucket"
    effect = "Allow"

    actions = [
      "s3:CreateBucket",
      "s3:ListAllMyBuckets"
    ]

    resources = ["*"]
  }

  # Manage the existing frontend bucket
  statement {
    sid    = "ManageFrontendBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketWebsite",
      "s3:PutBucketWebsite",
      "s3:DeleteBucketWebsite",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketOwnershipControls",
      "s3:PutBucketOwnershipControls",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:DeleteBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::url-shortener-frontend98",
      "arn:aws:s3:::url-shortener-frontend98/*"
    ]
  }

}

resource "aws_iam_role_policy" "github_action_inline" {
  name   = "${var.name}-github-action-inline"
  role   = aws_iam_role.github_actions_role.id
  policy = data.aws_iam_policy_document.github_actions_role_permissions.json
}