provider "aws" {
  alias  = "dev"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.dev_account_id}:role/OrganizationAccountAccessRole"
  }
}

variable "dev_account_id" {
  description = "The account ID of the Dev account"
  type        = string
}

variable "security_account_id" {}

resource "aws_iam_role" "audit_role" {
  provider = aws.dev
  name     = "CrossAccountAuditRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::${var.security_account_id}:root"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "readonly_attach" {
  provider   = aws.dev
  role       = aws_iam_role.audit_role.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
