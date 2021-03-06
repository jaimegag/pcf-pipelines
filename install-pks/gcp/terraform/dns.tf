resource "google_dns_managed_zone" "env_dns_zone" {
  name        = "${var.prefix}-zone"
  dns_name    = "${var.pcf_domain}."
  description = "DNS zone (var.pcf_domain) for the var.prefix deployment"
}

resource "google_dns_record_set" "ops-manager-dns" {
  name = "opsman.${google_dns_managed_zone.env_dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_address.opsman.address}"]
}

resource "google_dns_record_set" "pks-api-dns" {
  name = "*.${var.pks_domain}."
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_address.pks-api.address}"]
}
