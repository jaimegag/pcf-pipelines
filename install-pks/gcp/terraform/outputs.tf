// Core Project Output

output "project" {
  value = "${var.gcp_proj_id}"
}

output "region" {
  value = "${var.gcp_region}"
}

output "azs" {
  value = "${var.gcp_zone_1},${var.gcp_zone_2},${var.gcp_zone_3}"
}

output "deployment-prefix" {
  value = "${var.prefix}-vms"
}

// DNS Output

output "ops_manager_dns" {
  value = "${google_dns_record_set.ops-manager-dns.name}"
}

output "pcf_domain" {
  value = "${var.pcf_domain}"
}

output "pks_domain" {
  value = "${var.pks_domain}"
}

output "ops_manager_public_ip" {
  value = "${google_compute_instance.ops-manager.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "env_dns_zone_name_servers" {
  value = "${google_dns_managed_zone.env_dns_zone.name_servers}"
}

// Network Output

output "network_name" {
  value = "${google_compute_network.pcf-virt-net.name}"
}

output "ops_manager_gateway" {
  value = "${google_compute_subnetwork.subnet-ops-manager.gateway_address}"
}

output "ops_manager_cidr" {
  value = "${google_compute_subnetwork.subnet-ops-manager.ip_cidr_range}"
}

output "ops_manager_subnet" {
  value = "${google_compute_subnetwork.subnet-ops-manager.name}"
}

output "pcf_gateway" {
  value = "${google_compute_subnetwork.subnet-pcf.gateway_address}"
}

output "pcf_cidr" {
  value = "${google_compute_subnetwork.subnet-pcf.ip_cidr_range}"
}

output "pcf_subnet" {
  value = "${google_compute_subnetwork.subnet-pcf.name}"
}

output "svc_net_1_gateway" {
  value = "${google_compute_subnetwork.subnet-services-1.gateway_address}"
}

output "svc_net_1_cidr" {
  value = "${google_compute_subnetwork.subnet-services-1.ip_cidr_range}"
}

output "svc_net_1_subnet" {
  value = "${google_compute_subnetwork.subnet-services-1.name}"
}

output "dynamic_svc_net_1_gateway" {
  value = "${google_compute_subnetwork.subnet-dynamic-services-1.gateway_address}"
}

output "dynamic_svc_net_1_cidr" {
  value = "${google_compute_subnetwork.subnet-dynamic-services-1.ip_cidr_range}"
}

output "dynamic_svc_net_1_subnet" {
  value = "${google_compute_subnetwork.subnet-dynamic-services-1.name}"
}

// Load Balancer Output

output "pks-api_pool" {
  value = "${google_compute_target_pool.pks-api.name}"
}

// Cloud Storage Bucket Output

output "director_blobstore_bucket" {
  value = "${google_storage_bucket.director.name}"
}

output "pub_ip_pks_api_lb" {
  value = "${google_compute_address.pks-api.address}"
}

output "pub_ip_opsman" {
  value = "${google_compute_address.opsman.address}"
}

/*
output "ert_certificate" {
  value = "${google_compute_ssl_certificate.ssl-cert.certificate}"
}

output "ert_certificate_key" {
  value = "${google_compute_ssl_certificate.ssl-cert.private_key}"
}
*/
