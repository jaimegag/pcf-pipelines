// Static IP address for PKS API
resource "google_compute_address" "pks-api" {
  name = "${var.prefix}-pks-api-lb"
}

// Static IP address for OpsManager
resource "google_compute_address" "opsman" {
  name = "${var.prefix}-opsman"
}
