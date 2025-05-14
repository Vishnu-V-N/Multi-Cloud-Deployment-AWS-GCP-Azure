# Multi-Cloud Deployment with Terraform (AWS + GCP + Azure)

## Goal

Deploy identical infrastructure across AWS, GCP, and Azure using Terraform modules and workspaces. The infrastructure will include Compute (VMs), Storage (Blob/Cloud Storage), and DNS failover configuration.

## Terraform Skills Demonstrated

- **Provider Aliasing**: Managing multiple cloud providers in a single configuration using aliases.
- **Cross-cloud Variable Abstraction**: Using variables to abstract common configurations across different cloud providers.
- **Conditional Deployments**: Deploy resources conditionally based on environment (e.g., dev, staging, production).
- **Multi-Cloud Resources**:
  - AWS: EC2, S3
  - GCP: Compute Engine, Cloud Storage
  - Azure: Virtual Machines, Blob Storage
- **DNS Failover**: Setting up DNS failover using AWS Route 53 and GCP Cloud DNS to ensure high availability.

## Prerequisites

- Terraform 1.4.x or later
- AWS, GCP, and Azure accounts with appropriate permissions
- API keys or credentials for AWS, GCP, and Azure set up on your machine (environment variables or `~/.aws/credentials`, `~/.gcp/credentials.json`, `~/.azure/config`)
- Terraform provider plugins installed for AWS, GCP, and Azure.

## Project Structure
├── main.tf # Main Terraform configuration
├── variables.tf # Variables for resource configurations
├── outputs.tf # Outputs after deployment
├── modules/
│ ├── aws_infrastructure/ # AWS-specific resources (EC2, S3)
│ ├── gcp_infrastructure/ # GCP-specific resources (Compute Engine, Cloud Storage)
│ └── azure_infrastructure/ # Azure-specific resources (VM, Blob Storage)
├── workspaces/ # Separate configurations per environment (dev, staging, prod)
├── dns_failover.tf # Route 53 and GCP DNS failover configuration
└── README.md 

....


## Usage

### 1. Setup Providers

Configure provider aliases for AWS, GCP, and Azure in `main.tf`:

```hcl
provider "aws" {
  region = var.aws_region
  alias  = "aws"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  alias   = "gcp"
}

provider "azurerm" {
  features {}
  alias = "azure"
}
...
