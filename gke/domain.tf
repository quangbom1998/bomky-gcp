# reserved IP address
resource "google_compute_global_address" "global_ip" {
  name = "bomky-static-ip"
}

# map domain
resource "google_dns_record_set" "domain" {
  name         = "dev.bomky.shop."
  type         = "A"
  managed_zone = "bomkyshop-dev"
  rrdatas      = [google_compute_global_address.global_ip.address]
  ttl          = 21600
}
