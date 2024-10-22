# 🚀 CI/CD for Static Website Hosting with AWS S3, CloudFront & Terraform

This project demonstrates how to set up a CI/CD pipeline for hosting a static website on AWS using S3, CloudFront, and Terraform. The process is fully automated using GitHub Actions.

![Screenshot 2024-10-15 at 3 06 31 PM](https://github.com/user-attachments/assets/845dc5cf-8b45-4519-9f33-e16024e3d100)

## ✨ Project Highlights

This project sets up a secure and scalable static website hosting environment on AWS. It involves:

- Automated deployment pipeline with GitHub Actions 🤖
- Static website hosting on S3 🗄️
- CloudFront CDN integration with custom domain 🌐
- Automatic SSL certificate generation via AWS ACM 🔐
- Custom error pages (404 & 403) 🛠️

## 🛠️ Prerequisites

1. **AWS Account**: You must have access to AWS.
2. **Terraform Installed**: The infrastructure is provisioned using Terraform.
3. **GitHub Secrets**: You'll need to configure AWS credentials in GitHub Secrets to enable GitHub Actions to interact with AWS.

## 🌳 Project Structure
    ```bash        
    .
    ├── main.tf                # Terraform main file
    ├── variables.tf           # Variables for the project
    ├── outputs.tf             # Outputs for DNS validation
    ├── .github/workflows/terraform.yml # GitHub Actions CI/CD file
    └── README.md              # Project documentation

## ⚙️ Setup Instructions

### 1️⃣ Clone the Repository

    ```bash
    git clone https://github.com/Syedhashirayub/Deploy-a-static-website-using-AWS-and-terraform.git
    
### 2️⃣ Set up Terraform
Ensure Terraform is installed and the AWS CLI is configured.
Initialize Terraform in the project folder:

    ```bash
     terraform init

### 3️⃣ Configure GitHub Secrets 🔐
Set up the following repository secrets in your GitHub repository:
- `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.
- `AWS_REGION`: The region where your resources are deployed.

### 4️⃣ Deploy via Terraform 🚀
    ```bash
    terraform apply
- Confirm when prompted, and Terraform will set up S3, CloudFront, and the SSL certificate.

### 5️⃣ Automate with GitHub Actions 🤖
The CI/CD pipeline is already configured via .github/workflows/terraform.yml.
Once you push changes to the repository, GitHub Actions will automatically deploy them to your AWS environment.

![Screenshot 2024-10-21 at 3 24 40 PM](https://github.com/user-attachments/assets/df01d38d-a8e5-4e44-95f0-d51a442fdb7d)

### 6️⃣ Access the Website 🌍
- After deployment, your static website will be available at https://www.carvilla.run.place.


## 📂 Key Terraform Resources

- S3 Bucket: Stores the website files.
- ACM Certificate: Provides SSL certificates for secure HTTPS access.
- CloudFront: CDN that delivers the website globally with custom domain support.
- GitHub Actions: Automates the deployment process.

## 📜 Custom Domain DNS Records
Add the DNS records to your domain registrar for ACM validation and CloudFront distribution.

## 🛡️ License
This project is licensed under the MIT License.





