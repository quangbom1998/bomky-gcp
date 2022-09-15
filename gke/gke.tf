module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id               = var.project_id
  name                     = "${var.cluster_name}-${var.env_name}"
  regional                 = true
  region                   = var.region
  network                  = module.gcp-network.network_name
  subnetwork               = module.gcp-network.subnets_names[0]
  ip_range_pods            = var.ip_range_pods_name
  ip_range_services        = var.ip_range_services_name
  remove_default_node_pool = true
  create_service_account   = false
  release_channel          = "REGULAR"
  kubernetes_version       = "1.22.11-gke.400"

  master_authorized_networks = [
    {
      cidr_block   = "118.70.133.189/32",
      display_name = "MLVN"
    },
    {
      cidr_block   = "113.160.19.218/32",
      display_name = "MLVN"
    },
    {
      cidr_block   = "27.72.56.167/32",
      display_name = "MLVN"
    },
    {
      cidr_block   = "14.248.15.114/32",
      display_name = "Quang"
    }
  ]

  node_pools = [
    {
      name           = "node-pool"
      machine_type   = "e2-small"
      node_locations = join(",", data.google_compute_zones.available.names)
      min_count      = 1
      max_count      = 2
      disk_size_gb   = 30
      service_account = google_service_account.default.email
    },
  ]

  # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

// https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/auth
module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "./kubeconfig-${var.env_name}"
}
