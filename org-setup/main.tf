provider "aws" {
  region = "us-east-1"
}

resource "aws_organizations_organization" "main" {
  feature_set = "ALL"
}

resource "aws_organizations_account" "security" {
  name      = "SecurityAccount"
  email     = "your+security@example.com"  # Change this
  role_name = "OrganizationAccountAccessRole"
}

resource "aws_organizations_account" "dev" {
  name      = "DevAccount"
  email     = "your+dev@example.com"  # Change this
  role_name = "OrganizationAccountAccessRole"
}
