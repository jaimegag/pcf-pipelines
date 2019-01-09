// Allow ssh from public networks
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.prefix}-allow-ssh"
  network = "${google_compute_network.pcf-virt-net.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh"]
}

// Allow http from public
resource "google_compute_firewall" "pcf-allow-http" {
  name    = "${var.prefix}-allow-http"
  network = "${google_compute_network.pcf-virt-net.name}"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-http", "router"]
}

// Allow https from public
resource "google_compute_firewall" "pcf-allow-https" {
  name    = "${var.prefix}-allow-https"
  network = "${google_compute_network.pcf-virt-net.name}"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-https", "router"]
}

//// PKS API from public
resource "google_compute_firewall" "pcf-allow-pks-api" {
  name    = "${var.prefix}-allow-http-pks-api"
  network = "${google_compute_network.pcf-virt-net.name}"

  allow {
    protocol = "tcp"
    ports    = ["8443"]
  }

  allow {
    protocol = "tcp"
    ports    = ["9021"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["pks-api"]
}

//// Create Firewall Rule for allow-pcf-all com between bosh deployed jobs
//// This will match the default OpsMan tag configured for the deployment
resource "google_compute_firewall" "allow-pcf-all" {
  name       = "${var.prefix}-allow-pcf-all"
  depends_on = ["google_compute_network.pcf-virt-net"]
  network    = "${google_compute_network.pcf-virt-net.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  target_tags = ["${var.prefix}", "${var.prefix}-opsman", "nat-traverse"]
  source_tags = ["${var.prefix}", "${var.prefix}-opsman", "nat-traverse"]
}
