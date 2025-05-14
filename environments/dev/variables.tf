variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "gcp_region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "azure_region" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "The environment for deployment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "The type of instance to use for compute resources"
  type        = string
  default     = "t2.micro"
}

variable "storage_bucket_name" {
  description = "The name of the storage bucket"
  type        = string
}

variable "dns_zone_name" {
  description = "The DNS zone name for Route 53 and GCP DNS"
  type        = string
}

variable "enable_azure_dns" {
  description = "Enable Azure DNS management"
  type        = bool
  default     = false
}

variable "enable_failover" {
  description = "Enable DNS failover between AWS and GCP"
  type        = bool
  default     = true
}