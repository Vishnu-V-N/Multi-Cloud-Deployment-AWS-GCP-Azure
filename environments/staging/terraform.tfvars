environment = "staging"

aws_region = "us-west-2"
gcp_region = "us-central1"
azure_region = "westus"

# AWS specific variables
aws_instance_type = "t2.micro"
aws_s3_bucket_name = "my-staging-bucket"

# GCP specific variables
gcp_instance_type = "f1-micro"
gcp_storage_bucket_name = "my-staging-gcs-bucket"

# Azure specific variables
azure_vm_size = "Standard_B1s"
azure_blob_container_name = "my-staging-blob-container"

# DNS settings
route53_zone_id = "Z1234567890"
gcp_dns_zone_name = "my-staging-dns-zone"
azure_dns_zone_name = "my-staging-azure-dns-zone"

# Enable or disable features
enable_aws = true
enable_gcp = true
enable_azure = true

# Failover settings
dns_failover_enabled = true
failover_ip = "203.0.113.1"