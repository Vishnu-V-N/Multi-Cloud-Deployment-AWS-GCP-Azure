output "aws_instance_ids" {
  value = module.aws_compute.instance_ids
}

output "gcp_instance_ids" {
  value = module.gcp_compute.instance_ids
}

output "azure_vm_ids" {
  value = module.azure_compute.vm_ids
}

output "aws_s3_bucket" {
  value = module.aws_storage.bucket_name
}

output "gcp_storage_bucket" {
  value = module.gcp_storage.bucket_name
}

output "azure_blob_container" {
  value = module.azure_storage.container_name
}

output "route53_dns_name" {
  value = module.aws_dns.dns_name
}

output "gcp_dns_name" {
  value = module.gcp_dns.dns_name
}

output "dns_failover" {
  value = {
    aws = module.aws_dns.failover_record
    gcp  = module.gcp_dns.failover_record
  }
}