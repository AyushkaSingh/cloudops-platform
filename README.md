# CloudOps Platform 🚀

CloudOps Platform is an automated CI/CD deployment project that builds, tests, containerizes, and deploys a Node.js application to AWS EC2 using GitHub Actions, Docker, GitHub Container Registry, and Terraform.

## Architecture

Developer
   ↓
GitHub Repository
   ↓
GitHub Actions CI
   ├── Install dependencies
   ├── Run automated tests
   ├── Build Docker image
   └── Push image to GHCR
            ↓
       GitHub Actions CD
            ↓
       SSH into AWS EC2
            ↓
       Pull Docker image
            ↓
       Run Docker Container
            ↓
       Live Application

## Technologies Used

- Node.js
- Express.js
- Docker
- GitHub Actions
- GitHub Container Registry (GHCR)
- AWS EC2
- AWS VPC
- AWS Security Groups
- Terraform
- SSH
- Linux

## Application Endpoints

### Home
GET /

Returns:

CloudOps Application is Running 🚀

### Health Check
GET /health

Returns:

{
  "status": "healthy"
}

## CI Pipeline

The CI pipeline is triggered on pushes and pull requests to the main branch.

It performs:

1. Dependency installation using `npm ci`
2. Automated tests using `npm test`
3. Docker image build
4. Authentication with GitHub Container Registry
5. Docker image push to GHCR

## CD Pipeline

The CD pipeline is triggered after a successful CI workflow.

It:

1. Connects to AWS EC2 using SSH
2. Logs into GHCR
3. Pulls the latest Docker image
4. Removes the previous container
5. Starts the new container
6. Exposes the application on port 80

## Infrastructure

Terraform provisions:

- AWS VPC
- Public subnet
- Internet Gateway
- Route table
- Security Group
- EC2 instance
- AWS key pair

## Key Features

- Automated testing
- Containerized application
- Automated CI/CD
- Infrastructure as Code
- Docker image registry
- Automated EC2 deployment
- Health check endpoint
- Reproducible infrastructure

## Project Goal

The goal of this project is to demonstrate practical DevOps and Cloud engineering concepts by automating the complete application delivery lifecycle from source code commit to production deployment.