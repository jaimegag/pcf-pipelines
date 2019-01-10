// PKS API Health check
resource "google_compute_http_health_check" "pks-api" {
  name                = "${var.prefix}-pks-api-lb"
  host                = "api.${var.pks_domain}."
  port                = 9021
  request_path        = "/actuator/health"
  check_interval_sec  = 30
  timeout_sec         = 5
  healthy_threshold   = 10
  unhealthy_threshold = 2
}

// PKS API target pool
resource "google_compute_target_pool" "pks-api" {
  name = "${var.prefix}-pks-api-lb"

  health_checks = [
    "${google_compute_http_health_check.pks-api.name}",
  ]
}

// PKS API forwarding rules
resource "google_compute_forwarding_rule" "pks-api-lb-8443" {
  name        = "${var.prefix}-pks-api-lb-8443"
  target      = "${google_compute_target_pool.pks-api.self_link}"
  port_range  = "8443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.pks-api.address}"
}
resource "google_compute_forwarding_rule" "pks-api-lb-9021" {
  name        = "${var.prefix}-pks-api-lb-9021"
  target      = "${google_compute_target_pool.pks-api.self_link}"
  port_range  = "9021"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.pks-api.address}"
}
