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

```

---

## ✅ Prerequisites

- AWS account with billing enabled
- Access to the **AWS root user** (only for initial setup)
- **AWS Organizations must be enabled manually** if it's your first time using it
- Optional: Git + Terraform installed locally **or use CloudShell (recommended)**

---

### ⚠️ First-Time AWS Organizations Users

Terraform cannot automatically create an AWS Organization. If you're using Organizations for the first time:

1. Log into the AWS Console as the root user.
2. Go to [AWS Organizations Console](https://console.aws.amazon.com/organizations).
3. Click **“Create organization”** if prompted.
4. Wait a minute or two for it to fully activate.
5. Then re-run `terraform apply`.

If you see this error:
```

AWSOrganizationsNotInUseException: Your account is not a member of an organization.

````
Just wait a moment and try again.

---

## 💻 Running Terraform in AWS CloudShell (Recommended)

CloudShell is a browser-based shell that’s already authenticated with your root console session — ideal for setting up AWS Organizations.

### Setup Steps for Terraform in CloudShell

Terraform isn’t preinstalled in CloudShell, so you can install it using `tfenv`:

```bash
# Install tfenv
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
mkdir ~/bin
ln -s ~/.tfenv/bin/* ~/bin/

# Install and select the latest Terraform version
tfenv install latest
tfenv use 1.11.4
````

> ⚠️ Be sure to run `tfenv use <version>` to make it default.

---

## 🚀 Deployment Steps

### 1. Clone the Repo

```bash
git clone https://github.com/zarguell/aws-security-sandbox.git
cd aws-security-sandbox
```

### 2. Create the Organization and Accounts

Navigate to the `org-setup` directory and apply:

```bash
cd org-setup
terraform init
terraform apply
```

Save the output account IDs — you'll need them for the next steps.

---

### 3. Set Up the Dev Account Role

Update `dev-account/main.tf` with your actual Security account ID:

```hcl
variable "security_account_id" {
  default = "<your-security-account-id>"
}
```

Then run:

```bash
cd ../dev-account
terraform init
terraform apply
```

---

### 4. Set Up the Security Account Infrastructure

Update `security-account/main.tf` with your actual Dev account ID:

```hcl
variable "dev_account_id" {
  default = "<your-dev-account-id>"
}
```

Then run:

```bash
cd ../security-account
terraform init
terraform apply
```

---

## 🧠 Learning Goals

* Practice secure cross-account IAM role design
* Build automation using Lambda and Terraform
* Learn about audit/report pipelines (IAM, S3, STS)
* Explore real-world security operations concepts in AWS

---

## 📎 License

MIT License – for educational use.

