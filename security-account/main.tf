provider "aws" {
  alias  = "security"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::<SECURITY_ACCOUNT_ID>:role/OrganizationAccountAccessRole"
  }
}

variable "dev_account_id" {}

resource "aws_s3_bucket" "report_bucket" {
  provider = aws.security
  bucket   = "security-audit-reports-12345"
}

resource "aws_iam_role" "lambda_exec_role" {
  provider = aws.security
  name     = "SecurityLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_assume_dev" {
  provider = aws.security
  role     = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = "arn:aws:iam::${var.dev_account_id}:role/CrossAccountAuditRole"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.report_bucket.arn}/*"
      }
    ]
  })
}
