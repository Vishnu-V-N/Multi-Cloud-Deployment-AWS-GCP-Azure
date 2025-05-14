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
  providers = {
    aws = aws
  }
  instance_type = var.aws_instance_type
  ami           = var.aws_ami
}

module "gcp_compute" {
  source = "../../modules/gcp/compute"
  providers = {
    google = google
  }
  machine_type = var.gcp_machine_type
  image        = var.gcp_image
}

module "azure_compute" {
  source = "../../modules/azure/compute"
  providers = {
    azurerm = azurerm
  }
  vm_size = var.azure_vm_size
  image   = var.azure_image
}

module "aws_storage" {
  source = "../../modules/aws/storage"
  providers = {
    aws = aws
  }
  bucket_name = var.aws_bucket_name
}

module "gcp_storage" {
  source = "../../modules/gcp/storage"
  providers = {
    google = google
  }
  bucket_name = var.gcp_bucket_name
}

module "azure_storage" {
  source = "../../modules/azure/storage"
  providers = {
    azurerm = azurerm
  }
  container_name = var.azure_container_name
}

module "aws_dns" {
  source = "../../modules/aws/dns"
  providers = {
    aws = aws
  }
  zone_name = var.aws_zone_name
}

module "gcp_dns" {
  source = "../../modules/gcp/dns"
  providers = {
    google = google
  }
  zone_name = var.gcp_zone_name
}

resource "aws_route53_record" "failover" {
  count = var.enable_dns_failover ? 1 : 0
  zone_id = module.aws_dns.zone_id
  name    = var.dns_record_name
  type    = "A"

  alias {
    name                   = module.aws_dns.failover_target
    zone_id                = module.aws_dns.failover_zone_id
    evaluate_target_health = true
  }
}

resource "google_dns_record_set" "failover" {
  count = var.enable_dns_failover ? 1 : 0
  managed_zone = module.gcp_dns.zone_name
  name         = var.dns_record_name
  type         = "A"
  ttl          = 300

  rrdatas = [module.gcp_dns.failover_target]
}

output "aws_instance_id" {
  value = module.aws_compute.instance_id
}

output "gcp_instance_id" {
  value = module.gcp_compute.instance_id
}

output "azure_vm_id" {
  value = module.azure_compute.vm_id
}

output "aws_bucket_id" {
  value = module.aws_storage.bucket_id
}

output "gcp_bucket_id" {
  value = module.gcp_storage.bucket_id
}

output "azure_container_id" {
  value = module.azure_storage.container_id
}

output "dns_failover_record" {
  value = var.enable_dns_failover ? aws_route53_record.failover.fqdn : google_dns_record_set.failover.fqdn
}