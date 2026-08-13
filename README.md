# Cloud Resume Challenge - My Portfolio 

This project is my implementation of the [Cloud Resume Challenge](https://cloudresumechallenge.dev/) using Terraform for Infrastructure as Code (IaC).

The challenge demonstrates practical cloud engineering and DevOps skills by building and deploying a serverless resume website on AWS with automation, CI/CD, and monitoring.

---

## 🌐 Live Demo

- Portfolio Website: [https://shaunmane.com](https://shaunmane.com)
- API Endpoint: `https://your-api-url`
- Visitor Counter API: Enabled

---

## 📌 Architecture

This project uses a fully serverless architecture on AWS.

### Services Used

- **Amazon S3** – Static website hosting
- **Amazon CloudFront** – CDN and HTTPS delivery
- **Cloudflare** – DNS management
- **AWS Certificate Manager (ACM)** – SSL certificates
- **AWS Lambda** – Backend API for visitor counter
- **Amazon DynamoDB** – Stores visitor count
- **API Gateway** – Exposes Lambda endpoint
- **Terraform** – Infrastructure as Code
- **GitHub Actions** – CI/CD automation

---

## 🏗️ Infrastructure Diagram

```text
                         ┌───────────────────────┐
                         │       GitHub          │
                         │   Source Repository   │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │     GitHub Actions    │
                         │     CI/CD Pipeline    │
                         └───────────┬───────────┘
                                     │
                    ┌────────────────┴────────────────┐
                    │                                 │
                    ▼                                 ▼
          ┌──────────────────┐             ┌──────────────────┐
          │ Terraform Deploy │             │ Frontend Deploy  │
          │   AWS Resources  │             │   Upload to S3   │
          └─────────┬────────┘             └─────────┬────────┘
                    │                                │
                    └──────────────┬─────────────────┘
                                   ▼
                         ┌───────────────────────┐
                         │       AWS Cloud       │
                         │                       │
                         │  S3 + CloudFront      │
                         │  API Gateway + Lambda │
                         │  DynamoDB             │
                         └───────────┬───────────┘
                                     │
                                     │
                    ┌────────────────┴────────────────┐
                    │                                 │
                    ▼                                 ▼
          ┌──────────────────┐             ┌──────────────────┐
          │   CloudFront     │             │   API Gateway    │
          │   Static Site    │             │   Visitor API    │
          └─────────┬────────┘             └─────────┬────────┘
                    │                                │
                    │                                ▼
                    │                       ┌──────────────────┐
                    │                       │      Lambda      │
                    │                       │ Visitor Counter  │
                    │                       └─────────┬────────┘
                    │                                 │
                    │                                 ▼
                    │                       ┌──────────────────┐
                    │                       │    DynamoDB      │
                    │                       │  Visitor Count   │
                    │                       └──────────────────┘
                    │
                    ▼
          ┌──────────────────┐
          │    Cloudflare    │
          │       DNS        │
          └─────────┬────────┘
                    │
                    ▼
          ┌──────────────────┐
          │       User       │
          │  Custom Domain   │
          └──────────────────┘

Flow:
1. User visits custom domain
2. Cloudflare handles DNS and routes the request to CloudFront
3. CloudFront serves the static frontend from S3
4. Frontend calls the API Gateway endpoint
5. API Gateway triggers the Lambda function
6. Lambda reads/writes the visitor count in DynamoDB
7. Updated visitor count is returned to the frontend
8. GitHub Actions automates deployments using Terraform
```

## Project Directory Structure
```text
.
├── .github/workflows/        # GitHub Actions CI/CD
│   ├── portfolio_update.yml
│   └── deploy_infra.yml
│
├── frontend/                 # Resume website files
│   ├── index.html
│   ├── style.css
│   └── script.js
│
├── terraform/                # Terraform configuration
│   ├── modules/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── providers.tf
│
├── backend/                  # Lambda function source
│   └── visitor-counter.py
│
└── README.md
```

## Flow 
```
Internet
   ↓
shaunmane.com
   ↓
Cloudflare DNS
   ↓
CloudFront
   ↓
Private S3 Bucket (OAC)
```

## Features

- Fully serverless AWS architecture
- HTTPS enabled with CloudFront + ACM
- Automated infrastructure provisioning using Terraform
- Visitor counter powered by Lambda + DynamoDB
- CI/CD pipeline with GitHub Actions
- Custom domain with Route 53
- Infrastructure modularization
- Secure IAM policies and least privilege access

## 🔐 Security Considerations

- IAM roles follow least privilege principles
- IAM roles added through OIDC
- S3 bucket access restricted through CloudFront
- HTTPS enforced across the site
- Secrets managed using GitHub Secrets