#  Terraform S3 Bucket Automation

This repository contains Terraform configuration to **automate the creation of an Amazon S3 bucket**, with deployment triggered via **GitHub Actions**. Additionally, the project maintains Terraform state in a dedicated S3 bucket.

---

##  Project Structure

```
terraform-s3-automation/
├── main.tf                # Defines the target S3 bucket resource
├── provider.tf            # AWS provider configuration
├── variables.tf           # Input variables (bucket name, region)
├── terraform.tfvars       # Variable values for deployment
├── outputs.tf             # Output values like bucket name/ARN
├── backend.tf             # Stores Terraform state in S3
└── .github/
    └── workflows/
        └── terraform.yml  # GitHub Actions automation workflow
```

---

## What It Does

- Provisions an **Amazon S3 bucket** using Terraform.
- Enables **versioning** on the created bucket.
- Stores Terraform state securely in a separate S3 bucket.
- Automates deployment via GitHub Actions (`terraform init`, `plan`, `apply`).
- Only two input variables are required: `bucket_name` and `aws_region`.

---

##  Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- AWS IAM user with S3 permissions
- GitHub repository secrets configured:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

---

##  One-Time Setup: Create tfstate Bucket

Before deploying, create the S3 bucket that will store the Terraform state:

```bash
aws s3api create-bucket --bucket prathyusha-tfstatefile --region us-east-1

aws s3api put-bucket-versioning   --bucket prathyusha-tfstatefile   --versioning-configuration Status=Enabled
```

---

##  backend.tf

This configuration tells Terraform to use the above S3 bucket for storing state:

```hcl
terraform {
  backend "s3" {
    bucket = "prathyusha-tfstatefile"
    key    = "s3-bucket-repo/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
```

---

##  Usage

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/terraform-s3-automation.git
cd terraform-s3-automation
```

### 2. Edit `terraform.tfvars`

```hcl
bucket_name = "your-unique-s3-bucket-name"
aws_region  = "us-east-1"
```

### 3. Push to GitHub

```bash
git add .
git commit -m "Setup S3 automation "
git push origin main
```

This will trigger GitHub Actions to deploy the S3 bucket.

---

##  (Optional) Run Locally

```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -auto-approve -var-file="terraform.tfvars"
```