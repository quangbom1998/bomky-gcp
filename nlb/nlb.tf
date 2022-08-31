resource "google_compute_address" "ip_address" {
  name = "network-lb-ip-1"
}

resource "google_compute_http_health_check" "default" {
  name         = "basic-check"
  request_path = "/"
}

resource "google_compute_target_pool" "default" {
  name = "www-pool"

  instances = google_compute_instance.default.*.self_link

  health_checks = [
    google_compute_http_health_check.default.name,
  ]
}

resource "google_compute_forwarding_rule" "default" {
  name       = "www-rule"
  target     = google_compute_target_pool.default.id
  ip_address = google_compute_address.ip_address.address
}