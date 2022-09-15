terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.35.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }
  }
  backend "gcs" {
    bucket = "bomky-gcp"
    prefix = "gke"
  }
}

provider "google" {
  # credentials = file("../creds/serviceaccount.json")
  project     = var.project_id # REPLACE WITH YOUR PROJECT ID
  region      = var.region
}

# provider "kubernetes" {
#   cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
#   host                   = module.gke_auth.host
#   token                  = module.gke_auth.token
#   load_config_file       = false
# }

provider "helm" {
  kubernetes {
    cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
    host                   = module.gke_auth.host
    token                  = module.gke_auth.token
  }
}
