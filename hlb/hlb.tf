resource "google_compute_global_address" "default" {
  name = "lb-ipv4-1"
}

resource "google_compute_health_check" "http-health-check" {
  name        = "http-basic-check"
  description = "Health check via http"

  timeout_sec         = 5
  check_interval_sec  = 5
  healthy_threshold   = 2
  unhealthy_threshold = 5

  http_health_check {
    request_path = "/"
    proxy_header = "NONE"
    port         = 80
  }
}

resource "google_compute_backend_service" "default" {
  name          = "web-backend-service"
  health_checks = [google_compute_health_check.http-health-check.id]
  port_name     = "http"
  protocol      = "HTTP"

  backend {
    group = google_compute_instance_group_manager.appserver.instance_group
  }
}
