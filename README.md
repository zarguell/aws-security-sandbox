# AWS Security Sandbox – Multi-Account Terraform Project

This project sets up a **security-focused AWS sandbox** using multiple AWS accounts, simulating a production-like environment for learning AWS security engineering, IAM auditing, automation with Lambda, and cross-account role assumptions.

---

## 📌 What This Project Does

- Creates a basic AWS Organizations structure with:
  - A **Security** account (for running audit tools and storing reports)
  - A **Dev** account (to simulate an environment to be audited)
- Sets up cross-account **IAM role trust** so the Security account can assume roles in the Dev account.
- Provisions:
  - An **S3 bucket** in the Security account to store audit reports.
  - An **IAM role** in the Dev account that the Security Lambda can assume.
  - A **Lambda-ready IAM role** in the Security account with permission to assume into Dev and write to S3.

---

## 📁 Project Structure

```

aws-security-sandbox/
│
├── org-setup/              # Sets up the AWS Organization & accounts
│   └── main.tf
│
├── security-account/       # Creates S3 bucket and Lambda IAM role
│   └── main.tf
│
└── dev-account/            # Creates cross-account IAM role for auditing
└── main.tf

````

---

## ✅ Prerequisites

- AWS CLI configured as root or delegated admin account
- Terraform installed (v1.3+ recommended)
- Billing-enabled AWS account with AWS Organizations support
- Email aliases for account creation (`your+dev@example.com`, etc.)
- Some patience—account creation and propagation can take several minutes

---

## 🚀 Deployment Steps

### 1. Clone the Repo

```bash
git clone https://github.com/zarguell/aws-security-sandbox.git
cd aws-security-sandbox
````

### 2. Create the Organization and Accounts

Navigate to the `org-setup` directory and apply:

```bash
cd org-setup
terraform init
terraform apply
```

> This creates the Security and Dev accounts. Save the account IDs from the output or AWS Console.

---

### 3. Set Up the Dev Account Role

Update the `dev-account/main.tf` with your Security account ID.

```hcl
variable "security_account_id" {
  default = "<your-security-account-id>"
}
```

Then deploy:

```bash
cd ../dev-account
terraform init
terraform apply
```

---

### 4. Set Up the Security Account Infrastructure

Update the `security-account/main.tf` with your Dev account ID.

```hcl
variable "dev_account_id" {
  default = "<your-dev-account-id>"
}
```

Then deploy:

```bash
cd ../security-account
terraform init
terraform apply
```

---

## 🔜 Next Steps

* Add a Lambda function in the Security account to assume the Dev audit role.
* Use the Lambda to collect IAM data and write to the S3 bucket.
* Schedule it with EventBridge for periodic audits.
* Optionally: add more accounts, roles, and monitoring tools (Security Hub, Config, GuardDuty).

---

## 🧠 Learning Goals

* Practice secure cross-account IAM role design
* Build automation using Lambda and Terraform
* Learn about audit/report pipelines (IAM, S3, STS)
* Explore real-world security operations concepts in AWS

---

## 📎 License

MIT License – for educational use.

