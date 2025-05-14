module "aws_compute" {
  source = "../../modules/aws/compute"
}

module "aws_storage" {
  source = "../../modules/aws/storage"
}

module "aws_dns" {
  source = "../../modules/aws/dns"
}

module "gcp_compute" {
  source = "../../modules/gcp/compute"
}

module "gcp_storage" {
  source = "../../modules/gcp/storage"
}

module "gcp_dns" {
  source = "../../modules/gcp/dns"
}

module "azure_compute" {
  source = "../../modules/azure/compute"
}

module "azure_storage" {
  source = "../../modules/azure/storage"
}

module "azure_dns" {
  source = "../../modules/azure/dns"
}

resource "aws_route53_record" "failover" {
  count = var.enable_dns_failover ? 1 : 0

  zone_id = var.aws_route53_zone_id
  name     = var.dns_name
  type     = "A"

  alias {
    name                   = module.aws_dns.record_name
    zone_id                = module.aws_dns.zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.example.id
}

resource "google_dns_record_set" "failover" {
  count = var.enable_dns_failover ? 1 : 0

  managed_zone = var.gcp_dns_zone
  name         = var.dns_name
  type         = "A"
  ttl          = 300

  rrdatas = [module.gcp_dns.record_ip]
}

output "aws_instance_ids" {
  value = module.aws_compute.instance_ids
}

output "gcp_instance_ids" {
  value = module.gcp_compute.instance_ids
}

output "azure_vm_ids" {
  value = module.azure_compute.vm_ids
}