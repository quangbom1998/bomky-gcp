data "google_compute_zones" "available" {
}

output "zones" {
    value = data.google_compute_zones.available.names
}

resource "google_compute_instance" "default" {
  count        = length(data.google_compute_zones.available.names)
  name         = "www-${count.index}"
  machine_type = "e2-small"
  zone         = data.google_compute_zones.available.names[count.index]

  tags = ["network-lb-tag"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
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
  service apache2 restart
  echo "<h3>Web Server: www-${count.index}</h3>" | tee /var/www/html/index.html
  EOF
}

output "vm_self_link" {
    value = google_compute_instance.default.*.self_link
}

resource "google_compute_firewall" "rules" {
  name        = "www-firewall-network-lb"
  network     = "default"
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80"]
  }

  source_ranges = [ "0.0.0.0/0" ]
  target_tags = ["network-lb-tag"]
}