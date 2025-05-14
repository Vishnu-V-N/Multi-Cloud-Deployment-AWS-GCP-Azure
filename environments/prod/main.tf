terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }

  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

provider "azurerm" {
  features {}
}

module "aws_compute" {
  source = "../../modules/aws/compute"
  count  = var.deploy_aws ? 1 : 0
  # Pass necessary variables to the AWS compute module
}

module "gcp_compute" {
  source = "../../modules/gcp/compute"
  count  = var.deploy_gcp ? 1 : 0
  # Pass necessary variables to the GCP compute module
}

module "azure_compute" {
  source = "../../modules/azure/compute"
  count  = var.deploy_azure ? 1 : 0
  # Pass necessary variables to the Azure compute module
}

module "aws_storage" {
  source = "../../modules/aws/storage"
  count  = var.deploy_aws ? 1 : 0
  # Pass necessary variables to the AWS storage module
}

module "gcp_storage" {
  source = "../../modules/gcp/storage"
  count  = var.deploy_gcp ? 1 : 0
  # Pass necessary variables to the GCP storage module
}

module "azure_storage" {
  source = "../../modules/azure/storage"
  count  = var.deploy_azure ? 1 : 0
  # Pass necessary variables to the Azure storage module
}

module "aws_dns" {
  source = "../../modules/aws/dns"
  count  = var.deploy_aws ? 1 : 0
  # Pass necessary variables to the AWS DNS module
}

module "gcp_dns" {
  source = "../../modules/gcp/dns"
  count  = var.deploy_gcp ? 1 : 0
  # Pass necessary variables to the GCP DNS module
}

module "azure_dns" {
  source = "../../modules/azure/dns"
  count  = var.deploy_azure ? 1 : 0
  # Pass necessary variables to the Azure DNS module
}

resource "aws_route53_record" "failover" {
  count = var.deploy_aws ? 1 : 0
  zone_id = var.route53_zone_id
  name     = var.failover_record_name
  type     = "A"

  alias {
    name                   = module.aws_dns.record_name
    zone_id                = module.aws_dns.zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.example.id
}

resource "google_dns_record_set" "failover" {
  count = var.deploy_gcp ? 1 : 0
  managed_zone = var.gcp_dns_zone
  name         = var.failover_record_name
  type         = "A"
  ttl          = 300

  rrdatas = [module.gcp_dns.record_ip]
}

output "aws_instance_ids" {
  value = module.aws_compute.instance_ids
  condition = var.deploy_aws
}

output "gcp_instance_ids" {
  value = module.gcp_compute.instance_ids
  condition = var.deploy_gcp
}

output "azure_instance_ids" {
  value = module.azure_compute.instance_ids
  condition = var.deploy_azure
}