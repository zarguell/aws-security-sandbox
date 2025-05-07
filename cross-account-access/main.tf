# Create IAM Role for cross-account access (in Management Account)

resource "aws_iam_role" "cross_account_role" {
  name               = "CrossAccountDevRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          AWS = "arn:aws:iam::${var.dev_account_id}:role/OrganizationAccountAccessRole"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cross_account_policy" {
  name   = "CrossAccountPolicy"
  role   = aws_iam_role.cross_account_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = "arn:aws:iam::${var.dev_account_id}:role/OrganizationAccountAccessRole"
      }
    ]
  })
}

resource "aws_iam_role" "cross_account_role" {
  name               = "CrossAccountDevRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          AWS = "arn:aws:iam::${var.security_account_id}:role/OrganizationAccountAccessRole"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cross_account_policy" {
  name   = "CrossAccountPolicy"
  role   = aws_iam_role.cross_account_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = "arn:aws:iam::${var.security_account_id}:role/OrganizationAccountAccessRole"
      }
    ]
  })
}

# Output role ARN for reference
output "cross_account_role_arn" {
  value = aws_iam_role.cross_account_role.arn
}
