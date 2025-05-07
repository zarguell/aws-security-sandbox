resource "aws_iam_role" "terraform_admin" {
  name = "TerraformAdmin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "*"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "terraform_admin_policy" {
  name = "TerraformAdminPolicy"
  role = aws_iam_role.terraform_admin.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "sts:AssumeRole"
      ],
      Resource = [
        "arn:aws:iam::${var.dev_account_id}:role/OrganizationAccountAccessRole",
        "arn:aws:iam::${var.security_account_id}:role/OrganizationAccountAccessRole"
      ]
    }]
  })
}
