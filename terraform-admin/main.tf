variable "iam_username" {
  default = "terraform-admin-user"
}

resource "aws_iam_user" "admin_user" {
  name = var.iam_username
}

resource "aws_iam_group" "admin_group" {
  name = "TerraformAdmins"
}

resource "aws_iam_group_policy_attachment" "admin_group_attach" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_group_membership" "admin_user_membership" {
  user = aws_iam_user.admin_user.name
  groups = [
    aws_iam_group.admin_group.name
  ]
}

resource "aws_iam_access_key" "admin_key" {
  user = aws_iam_user.admin_user.name
}

output "aws_access_key_id" {
  value     = aws_iam_access_key.admin_key.id
  sensitive = false
}

output "aws_secret_access_key" {
  value     = aws_iam_access_key.admin_key.secret
  sensitive = true
}
