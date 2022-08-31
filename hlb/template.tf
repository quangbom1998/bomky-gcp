resource "google_compute_instance_template" "default" {
  name        = "lb-backend-template"
  description = "This template is used to create app server instances."

  tags = ["allow-health-check"]

  instance_description = "description assigned to instances"
  machine_type         = "e2-small"

  // Create a new boot disk from an image
  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys = "quangbom1998:${file("./gcp-vm.pub")}"
  }

  metadata_startup_script = <<-EOF
  #!/bin/bash
  apt-get update
  apt-get install apache2 -y
  a2ensite default-ssl
  a2enmod ssl
  vm_hostname="$(curl -H "Metadata-Flavor:Google" \
  http://169.254.169.254/computeMetadata/v1/instance/name)"
  echo "Page served from: $vm_hostname" | \
  tee /var/www/html/index.html
  systemctl restart apache2
  EOF
}

resource "google_compute_instance_group_manager" "appserver" {
  name = "lb-backend-group"

  base_instance_name = "app"
  zone               = "us-east1-b"

  version {
    instance_template = google_compute_instance_template.default.id
  }

  #   all_instances_config {
  #     metadata = {
  #       ssh-keys = "quangbom1998:${file("./gcp-vm.pub")}"
  #     }
  #   }

  target_size = 2

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_firewall" "rules" {
  name        = "fw-allow-health-check"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"
  direction   = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
}
